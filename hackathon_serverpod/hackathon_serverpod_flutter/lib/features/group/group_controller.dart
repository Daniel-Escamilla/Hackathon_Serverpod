import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../client.dart';
import '../../data/app_failure.dart';

/// The signed-in member's group and its members. GroupGate already knows the
/// caller has a group by the time this loads, so a load failure here is
/// always a real error, never "no group yet".
class GroupController extends ChangeNotifier {
  Group? group;
  List<GroupMember> members = [];
  bool loading = false;
  bool hasLoaded = false;
  Object? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        client.group.myGroup(),
        client.group.listMembers(),
      ]);
      group = results[0] as Group;
      members = results[1] as List<GroupMember>;
    } catch (e) {
      error = mapServerError(e);
    } finally {
      loading = false;
      hasLoaded = true;
      notifyListeners();
    }
  }

  Future<void> expel(int memberId) async {
    try {
      await client.group.expelMember(memberId);
    } catch (e) {
      throw mapServerError(e);
    }
    await load();
  }

  Future<void> regenerateInviteCode() async {
    try {
      group = await client.group.regenerateInviteCode();
      notifyListeners();
    } catch (e) {
      throw mapServerError(e);
    }
  }
}
