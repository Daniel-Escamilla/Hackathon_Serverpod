import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../client.dart';
import 'app_failure.dart';

/// The only place in the app that talks to `GroupEndpoint`.
class GroupRepository {
  const GroupRepository(this._client);

  final Client _client;

  /// Creates a group and makes the caller its admin. The returned [Group]
  /// carries the invite code to share (PRODUCT.md §7).
  Future<Group> create({required String name, required GroupType type}) async {
    try {
      return await _client.group.createGroup(name, type);
    } catch (error) {
      throw mapServerError(error);
    }
  }

  /// Joins the group with that invite code. No approval needed.
  Future<GroupMember> joinWithCode(String inviteCode) async {
    try {
      return await _client.group.joinGroup(inviteCode);
    } catch (error) {
      throw mapServerError(error);
    }
  }
}

final clientProvider = Provider<Client>((ref) => client);

final groupRepositoryProvider = Provider<GroupRepository>(
  (ref) => GroupRepository(ref.watch(clientProvider)),
);
