import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../client.dart';

/// Holds the group's tasks and the actions that change them. One instance
/// lives for the lifetime of [HomeShell] (see home_shell.dart) so the tasks
/// tab, the propose flow and the wallet's task-title lookup all see the
/// same data.
class TasksController extends ChangeNotifier {
  List<Task> tasks = [];
  bool loading = false;
  Object? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      tasks = await client.task.listTasks();
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Task> proposeTask(
    String title,
    String description,
    int reward,
  ) async {
    final task = await client.task.proposeTask(title, description, reward);
    await load();
    return task;
  }

  Future<Task> voteTaskProposal(int taskId, bool approve) async {
    final task = await client.task.voteTaskProposal(taskId, approve);
    await load();
    return task;
  }

  Future<Task> counterOfferTask(int taskId, int counterReward) async {
    final task = await client.task.counterOfferTask(taskId, counterReward);
    await load();
    return task;
  }

  Future<Task> respondToCounterOffer(int taskId, bool accept) async {
    final task = await client.task.respondToCounterOffer(taskId, accept);
    await load();
    return task;
  }

  Future<Task> markTaskDone(int taskId) async {
    final task = await client.task.markTaskDone(taskId);
    await load();
    return task;
  }
}
