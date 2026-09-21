import 'package:serverpod/serverpod.dart';

import 'task_service.dart';

/// Closes an expired proposal or completion vote (#64, PRODUCT.md §10.5).
/// `TaskService` schedules one of these for every `voteClosesAt` it sets —
/// see `TaskService._scheduleVoteExpiry` for where, and
/// `TaskService.expireVote` for what actually runs when it fires.
class TaskVoteFutureCall extends FutureCall {
  final TaskService _taskService = const TaskService();

  Future<void> expireVote(
    Session session,
    int taskId,
    DateTime expectedVoteClosesAt,
  ) {
    return _taskService.expireVote(
      session,
      taskId: taskId,
      expectedVoteClosesAt: expectedVoteClosesAt,
    );
  }
}
