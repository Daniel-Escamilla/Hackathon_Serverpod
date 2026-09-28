import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../client.dart';
import 'app_failure.dart';

/// The signed-in member's group, as `GroupEndpoint` exposes it: creating or
/// joining one, and what the admin manages (PRODUCT.md §7). Every call throws
/// [AppException].
class GroupRepository {
  const GroupRepository();

  Future<Group> createGroup(String name, GroupType type) =>
      guardServerCall(() => client.group.createGroup(name, type));

  Future<GroupMember> joinGroup(String inviteCode) =>
      guardServerCall(() => client.group.joinGroup(inviteCode));

  Future<Group> myGroup() => guardServerCall(client.group.myGroup);

  /// The members still in the group, oldest first.
  Future<List<GroupMember>> listMembers() =>
      guardServerCall(client.group.listMembers);

  Future<void> expelMember(int memberId) =>
      guardServerCall(() => client.group.expelMember(memberId));

  Future<Group> updateGroup({required String name, required int finePercent}) =>
      guardServerCall(
        () => client.group.updateGroup(name: name, finePercent: finePercent),
      );

  /// The group's live events (PRODUCT.md §10.4). Errors arrive as they are:
  /// the caller only retries, it never shows them.
  Stream<GroupEvent> watchGroup() => client.event.watchGroup();

  Future<Group> regenerateInviteCode() =>
      guardServerCall(client.group.regenerateInviteCode);
}
