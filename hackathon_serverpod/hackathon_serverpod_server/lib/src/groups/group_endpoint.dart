import 'dart:math';

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
      ),
    );
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
