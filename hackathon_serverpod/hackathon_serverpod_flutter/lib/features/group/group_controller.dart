import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../data/auth_repository.dart';
import '../../data/group_repository.dart';

/// The signed-in member's group and its members. GroupGate already knows the
/// caller has a group by the time this loads, so a load failure here is
/// always a real error, never "no group yet".
class GroupController extends ChangeNotifier {
  GroupController({
    this.repository = const GroupRepository(),
    this.auth = const AuthRepository(),
  });

  final GroupRepository repository;
  final AuthRepository auth;

  Group? group;
  List<GroupMember> members = [];
  bool loading = false;
  bool hasLoaded = false;
  Object? error;

  /// The signed-in member's id in this group: what a task's `doneById` or a
  /// purchase's `providerId` point at. Null until the members have loaded.
  int? get myMemberId {
    final myUserId = auth.signedInUserId;
    return members.firstWhereOrNull((m) => m.authUserId == myUserId)?.id;
  }

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      // Future.wait rethrows the first failure as it is; a record's `.wait`
      // would wrap it in a ParallelWaitError.
      final results = await Future.wait<Object>([
        repository.myGroup(),
        repository.listMembers(),
      ]);
      final loadedGroup = results[0] as Group;
      final loadedMembers = results[1] as List<GroupMember>;
      group = loadedGroup;
      members = loadedMembers;
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      hasLoaded = true;
      notifyListeners();
    }
  }

  Future<void> expel(int memberId) async {
    await repository.expelMember(memberId);
    await load();
  }

  Future<void> updateSettings({
    required String name,
    required int finePercent,
  }) async {
    group = await repository.updateGroup(name: name, finePercent: finePercent);
    notifyListeners();
  }

  Future<void> regenerateInviteCode() async {
    group = await repository.regenerateInviteCode();
    notifyListeners();
  }
}
