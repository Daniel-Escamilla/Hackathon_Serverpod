import 'dart:math';

import '../events/event_service.dart';
import '../generated/protocol.dart';
import '../shop/shop_service.dart';
import 'current_member.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Excludes 0/O and 1/I/L: easy to read out loud and to type from a phone,
/// which is how a group's code is meant to travel (PRODUCT.md §7).
const _inviteCodeAlphabet = '23456789ABCDEFGHJKMNPQRSTUVWXYZ';
const _inviteCodeLength = 6;

/// Create a group and join one by invite code (PRODUCT.md §7, §10.3).
class GroupEndpoint extends Endpoint {
  final ShopService _shopService = const ShopService();
  final EventService _eventService = const EventService();

  @override
  bool get requireLogin => true;

  /// Creates a group with [name] and [type], making the signed-in user its admin,
  /// and seeds the profile's reward templates. A person can belong to only one
  /// group at a time (PRODUCT.md §7).
  Future<Group> createGroup(
    Session session,
    String name,
    GroupType type, {
    String? displayName,
  }) async {
    final authUserId = session.authenticated!.authUserId;
    await _requireNoActiveMembership(session, authUserId);
    final resolvedDisplayName =
        displayName ?? await _defaultDisplayName(session);
    // Picked before the transaction opens: retrying a failed insert inside it
    // cannot work, because Postgres aborts the whole transaction on the first
    // error and refuses every statement after it.
    final inviteCode = await _freeInviteCode(session);

    return session.db.transaction((transaction) async {
      final group = await Group.db.insertRow(
        session,
        Group(name: name, type: type, inviteCode: inviteCode),
        transaction: transaction,
      );

      final admin = await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: group.id!,
          authUserId: authUserId,
          displayName: resolvedDisplayName,
          role: GroupMemberRole.admin,
        ),
        transaction: transaction,
      );

      await _shopService.seedRewardTemplates(
        session,
        group: group,
        createdBy: admin,
        transaction: transaction,
      );

      return group;
    });
  }

  /// Joins the group identified by [inviteCode]. Enters directly, no approval
  /// needed (PRODUCT.md §7). A person can belong to only one group at a time.
  Future<GroupMember> joinGroup(
    Session session,
    String inviteCode, {
    String? displayName,
  }) async {
    final authUserId = session.authenticated!.authUserId;
    await _requireNoActiveMembership(session, authUserId);

    final group = await Group.db.findFirstRow(
      session,
      where: (t) => t.inviteCode.equals(inviteCode.toUpperCase()),
    );
    if (group == null) {
      throw GroupException(reason: GroupErrorReason.inviteCodeNotFound);
    }

    final resolvedDisplayName =
        displayName ?? await _defaultDisplayName(session);

    return GroupMember.db.insertRow(
      session,
      GroupMember(
        groupId: group.id!,
        authUserId: authUserId,
        displayName: resolvedDisplayName,
        role: GroupMemberRole.member,
        balance: await _carriedOverDebt(
          session,
          groupId: group.id!,
          authUserId: authUserId,
        ),
      ),
    );
  }

  /// A debt (negative balance) from a previous membership of [authUserId] in
  /// this *same* group carries over on rejoining, so leaving and rejoining
  /// can't be used to erase a fine. Coins earned do not carry over —
  /// PRODUCT.md §4.6 already says leaving loses the balance; this only closes
  /// the one direction that can be abused (today, reachable via an admin's
  /// `expelMember` followed by rejoining with a code that still works).
  Future<int> _carriedOverDebt(
    Session session, {
    required int groupId,
    required UuidValue authUserId,
  }) async {
    final previous = await GroupMember.db.findFirstRow(
      session,
      where: (t) =>
          t.groupId.equals(groupId) &
          t.authUserId.equals(authUserId) &
          t.leftAt.notEquals(null),
      orderBy: (t) => t.leftAt.desc(),
    );
    if (previous == null || previous.balance >= 0) return 0;
    return previous.balance;
  }

  /// The signed-in member's group: its name, profile and invite code.
  ///
  /// `joinGroup` returns the membership, not the group, so without this a
  /// member who joined could never read the code to pass on to anyone else.
  Future<Group> myGroup(Session session) async {
    final member = await currentGroupMember(session);
    final group = await Group.db.findById(session, member.groupId);
    if (group == null) {
      throw GroupException(reason: GroupErrorReason.noMembership);
    }
    return group;
  }

  /// Everyone currently in the caller's group, oldest first — the order the
  /// admin role passes down in when an admin leaves (PRODUCT.md §7).
  Future<List<GroupMember>> listMembers(Session session) async {
    final member = await currentGroupMember(session);
    return GroupMember.db.find(
      session,
      where: (t) => t.groupId.equals(member.groupId) & t.leftAt.equals(null),
      orderBy: (t) => t.joinedAt,
    );
  }

  /// The admin removes [memberId] from the group (PRODUCT.md §7).
  ///
  /// Entry is direct with the code, so this is what protects a group whose
  /// code has leaked: whoever got in without being wanted can be put out.
  ///
  /// The row is kept with `leftAt` set, so the tasks they did and the coins
  /// they moved stay in everyone's history. Their balance is lost, as §4.6
  /// says, without touching the ledger: no call ever reaches a membership that
  /// has left, and joining again later starts a new one at zero.
  Future<void> expelMember(Session session, int memberId) async {
    final admin = await _requireAdmin(session);
    if (memberId == admin.id) {
      throw GroupException(reason: GroupErrorReason.cannotExpelSelf);
    }

    final target = await GroupMember.db.findById(session, memberId);
    if (target == null ||
        target.groupId != admin.groupId ||
        target.leftAt != null) {
      throw GroupException(reason: GroupErrorReason.memberNotFound);
    }

    await GroupMember.db.updateRow(
      session,
      target.copyWith(leftAt: DateTime.now().toUtc()),
    );
    // Their app is still watching the group; this is what sends it away.
    await _eventService.publish(
      session,
      groupId: admin.groupId,
      kind: GroupEventKind.memberExpelled,
      memberId: target.id,
    );
  }

  /// The admin replaces the invite code. The old one stops working at once;
  /// nobody already in the group is affected.
  ///
  /// The other half of what expelling covers: this stops a leaked code from
  /// letting anyone else in, expelling removes whoever already used it.
  Future<Group> regenerateInviteCode(Session session) async {
    final admin = await _requireAdmin(session);
    final group = await Group.db.findById(session, admin.groupId);
    if (group == null) {
      throw GroupException(reason: GroupErrorReason.noMembership);
    }
    return Group.db.updateRow(
      session,
      group.copyWith(inviteCode: await _freeInviteCode(session)),
    );
  }

  /// The admin hands the role over to [memberId] and becomes a plain member
  /// (PRODUCT.md §7). Never to themselves, and never to a child (§8).
  ///
  /// Both roles change in one transaction on the admin's row read locked:
  /// two hand-overs sent at once would otherwise both pass the admin check
  /// and leave the group with two admins.
  Future<GroupMember> transferAdmin(Session session, int memberId) async {
    final admin = await _requireAdmin(session);
    if (memberId == admin.id) {
      throw GroupException(reason: GroupErrorReason.cannotTransferAdmin);
    }

    return session.db.transaction((transaction) async {
      final lockedAdmin = await GroupMember.db.findById(
        session,
        admin.id!,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (lockedAdmin == null ||
          lockedAdmin.role != GroupMemberRole.admin ||
          lockedAdmin.leftAt != null) {
        throw GroupException(reason: GroupErrorReason.notAdmin);
      }

      final target = await GroupMember.db.findById(
        session,
        memberId,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (target == null ||
          target.groupId != lockedAdmin.groupId ||
          target.leftAt != null) {
        throw GroupException(reason: GroupErrorReason.memberNotFound);
      }
      if (target.role == GroupMemberRole.child) {
        throw GroupException(reason: GroupErrorReason.cannotTransferAdmin);
      }

      // In a family the admin is also a guardian and stays one (§8).
      final group = await Group.db.findById(
        session,
        lockedAdmin.groupId,
        transaction: transaction,
      );
      await GroupMember.db.updateRow(
        session,
        lockedAdmin.copyWith(
          role: group?.type == GroupType.family
              ? GroupMemberRole.guardian
              : GroupMemberRole.member,
        ),
        transaction: transaction,
      );
      return GroupMember.db.updateRow(
        session,
        target.copyWith(role: GroupMemberRole.admin),
        transaction: transaction,
      );
    });
  }

  /// The admin renames the group or changes its fine percentage (PRODUCT.md
  /// §7, §4.4). A field left null keeps its current value; the profile is not
  /// here because it never changes after creation.
  Future<Group> updateGroup(
    Session session, {
    String? name,
    int? finePercent,
  }) async {
    final admin = await _requireAdmin(session);
    final trimmedName = name?.trim();
    if (trimmedName != null && trimmedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be blank');
    }
    if (finePercent != null && (finePercent < 0 || finePercent > 100)) {
      throw RangeError.range(finePercent, 0, 100, 'finePercent');
    }

    final group = await Group.db.findById(session, admin.groupId);
    if (group == null) {
      throw GroupException(reason: GroupErrorReason.noMembership);
    }
    return Group.db.updateRow(
      session,
      group.copyWith(
        name: trimmedName ?? group.name,
        finePercent: finePercent ?? group.finePercent,
      ),
    );
  }

  Future<GroupMember> _requireAdmin(Session session) async {
    final member = await currentGroupMember(session);
    if (member.role != GroupMemberRole.admin) {
      throw GroupException(reason: GroupErrorReason.notAdmin);
    }
    return member;
  }

  Future<void> _requireNoActiveMembership(
    Session session,
    UuidValue authUserId,
  ) async {
    final existing = await GroupMember.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId) & t.leftAt.equals(null),
    );
    if (existing != null) {
      throw GroupException(reason: GroupErrorReason.alreadyInGroup);
    }
  }

  /// Email sign-in collects no name, so fall back through what the auth profile
  /// does have down to the email's local part. The profile lookup needs
  /// `AuthServices` set up, which isn't guaranteed in every context (e.g. tests),
  /// so a failure there just means the generic fallback instead of a 500.
  Future<String> _defaultDisplayName(Session session) async {
    UserProfileModel? profile;
    try {
      profile = await session.authenticated?.userProfile(session);
    } catch (_) {
      profile = null;
    }
    return profile?.fullName ??
        profile?.userName ??
        profile?.email?.split('@').first ??
        'Miembro';
  }

  /// A code no group has yet. The `unique` constraint on `inviteCode` remains
  /// the final guard: two groups picking the same code between this check and
  /// their insert would need a collision in about 887 million, and the loser's
  /// transaction fails cleanly rather than half-creating a group.
  Future<String> _freeInviteCode(Session session) async {
    for (var attempt = 0; attempt < 5; attempt++) {
      final code = _generateInviteCode();
      final taken = await Group.db.findFirstRow(
        session,
        where: (t) => t.inviteCode.equals(code),
      );
      if (taken == null) return code;
    }
    // Five collisions in a row out of 887 million codes is not bad luck. It is
    // a server fault, so it stays a plain error rather than a GroupException.
    throw StateError('Could not generate a unique invite code.');
  }

  String _generateInviteCode() {
    final random = Random.secure();
    return List.generate(
      _inviteCodeLength,
      (_) => _inviteCodeAlphabet[random.nextInt(_inviteCodeAlphabet.length)],
    ).join();
  }
}
