import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../client.dart';

/// Holds the group's tasks and the actions that change them. One instance
/// lives for the lifetime of [HomeShell] (see home_shell.dart) so the tasks
/// tab, the propose flow and the wallet's task-title lookup all see the
/// same data.
class TasksController extends ChangeNotifier {
  List<Task> tasks = [];

  /// The votes cast so far in the group's open votes (see
  /// `TaskEndpoint.listTaskVotes`).
  List<TaskVote> votes = [];
  bool loading = false;
  bool hasLoaded = false;
  Object? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final (loadedTasks, loadedVotes) = await (
        client.task.listTasks(),
        client.task.listTaskVotes(),
      ).wait;
      tasks = loadedTasks;
      votes = loadedVotes;
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      hasLoaded = true;
      notifyListeners();
    }
  }

  List<TaskVote> votesFor(int taskId) =>
      votes.where((v) => v.taskId == taskId).toList();

  /// Whether [memberId] has already voted in [task]'s open vote.
  bool hasVoted(Task task, int? memberId) =>
      memberId != null &&
      votes.any((v) => v.taskId == task.id && v.memberId == memberId);

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

  Future<Task> voteTaskCompletion(int taskId, bool approve) async {
    final task = await client.task.voteTaskCompletion(taskId, approve);
    await load();
    return task;
  }
}
