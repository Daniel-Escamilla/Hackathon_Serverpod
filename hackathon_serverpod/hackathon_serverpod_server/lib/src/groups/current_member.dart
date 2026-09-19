import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// The signed-in user's active membership. A person belongs to at most one
/// group at a time (PRODUCT.md §7).
Future<GroupMember> currentGroupMember(Session session) async {
  final authUserId = session.authenticated?.authUserId;
  if (authUserId == null) {
    throw StateError('This endpoint requires an authenticated user.');
  }

  final member = await GroupMember.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(authUserId) & t.leftAt.equals(null),
  );
  if (member == null) {
    throw StateError('No active group membership for the signed-in user.');
  }

  return member;
}
