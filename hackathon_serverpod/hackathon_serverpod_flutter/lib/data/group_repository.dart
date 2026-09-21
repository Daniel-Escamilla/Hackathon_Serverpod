import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
// For the `auth` extension on the client: the signed-in session.
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

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

  /// The caller's group, invite code included.
  Future<Group> myGroup() async {
    try {
      return await _client.group.myGroup();
    } catch (error) {
      throw mapServerError(error);
    }
  }

  /// Everyone in the caller's group, oldest first.
  Future<List<GroupMember>> members() async {
    try {
      return await _client.group.listMembers();
    } catch (error) {
      throw mapServerError(error);
    }
  }

  /// Admin only: removes someone from the group. Their history stays.
  Future<void> expel(int memberId) async {
    try {
      await _client.group.expelMember(memberId);
    } catch (error) {
      throw mapServerError(error);
    }
  }

  /// Admin only: replaces the invite code. The old one stops working at once.
  Future<Group> regenerateInviteCode() async {
    try {
      return await _client.group.regenerateInviteCode();
    } catch (error) {
      throw mapServerError(error);
    }
  }
}

final clientProvider = Provider<Client>((ref) => client);

final groupRepositoryProvider = Provider<GroupRepository>(
  (ref) => GroupRepository(ref.watch(clientProvider)),
);

/// The caller's group, invite code included. Invalidate it after replacing the
/// code so every screen showing it picks up the new one.
final myGroupProvider = FutureProvider<Group>(
  (ref) => ref.watch(groupRepositoryProvider).myGroup(),
);

/// Everyone in the caller's group. Invalidate it after expelling someone.
final groupMembersProvider = FutureProvider<List<GroupMember>>(
  (ref) => ref.watch(groupRepositoryProvider).members(),
);

/// Who is signed in, to tell "you" apart in a list of members. Read from the
/// session the client already holds, so it costs no request.
final signedInUserIdProvider = Provider<UuidValue?>(
  (ref) => ref.watch(clientProvider).auth.authInfoListenable.value?.authUserId,
);
