import 'dart:math';

import '../generated/protocol.dart';
import '../shop/shop_service.dart';
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

    return session.db.transaction((transaction) async {
      final group = await _insertWithUniqueInviteCode(
        session,
        name,
        type,
        transaction,
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
      throw StateError('No group found for that invite code.');
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

  Future<void> _requireNoActiveMembership(
    Session session,
    UuidValue authUserId,
  ) async {
    final existing = await GroupMember.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(authUserId) & t.leftAt.equals(null),
    );
    if (existing != null) {
      throw StateError('You already belong to a group.');
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

  Future<Group> _insertWithUniqueInviteCode(
    Session session,
    String name,
    GroupType type,
    Transaction transaction,
  ) async {
    for (var attempt = 0; attempt < 5; attempt++) {
      try {
        return await Group.db.insertRow(
          session,
          Group(name: name, type: type, inviteCode: _generateInviteCode()),
          transaction: transaction,
        );
      } on DatabaseUniqueViolationException {
        continue;
      }
    }
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
