import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// The signed-in user's active membership. A person belongs to at most one
/// group at a time (PRODUCT.md §7).
Future<GroupMember> currentGroupMember(Session session) async {
  final authUserId = session.authenticated?.authUserId;
  if (authUserId == null) {
    // Unreachable through the API: every endpoint sets `requireLogin`, so
    // Serverpod turns an anonymous call away before it gets here. A guard
    // against misuse from server code, hence a plain error, not something the
    // app is expected to handle.
    throw StateError('This endpoint requires an authenticated user.');
  }

  final member = await GroupMember.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(authUserId) & t.leftAt.equals(null),
  );
  if (member == null) {
    // Expected, and the app acts on it: it is how a signed-in user with no
    // group yet is told to create or join one.
    throw GroupException(reason: GroupErrorReason.noMembership);
  }

  return member;
}
