import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../client.dart';
import 'app_failure.dart';

/// The group's tasks and the calls of their cycle (PRODUCT.md §3), as
/// `TaskEndpoint` exposes them. Every call throws [AppException].
class TasksRepository {
  const TasksRepository();

  Future<List<Task>> listTasks() => guardServerCall(client.task.listTasks);

  /// The votes cast so far in the group's open votes.
  Future<List<TaskVote>> listTaskVotes() =>
      guardServerCall(client.task.listTaskVotes);

  Future<Task> proposeTask(String title, String description, int reward) =>
      guardServerCall(
        () => client.task.proposeTask(title, description, reward),
      );

  Future<Task> voteTaskProposal(int taskId, bool approve) =>
      guardServerCall(() => client.task.voteTaskProposal(taskId, approve));

  Future<Task> counterOfferTask(int taskId, int counterReward) =>
      guardServerCall(
        () => client.task.counterOfferTask(taskId, counterReward),
      );

  Future<Task> respondToCounterOffer(int taskId, bool accept) =>
      guardServerCall(() => client.task.respondToCounterOffer(taskId, accept));

  Future<Task> markTaskDone(int taskId) =>
      guardServerCall(() => client.task.markTaskDone(taskId));

  Future<Task> voteTaskCompletion(int taskId, bool approve) =>
      guardServerCall(() => client.task.voteTaskCompletion(taskId, approve));
}
