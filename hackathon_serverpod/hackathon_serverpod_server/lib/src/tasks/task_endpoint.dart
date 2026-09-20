import '../generated/protocol.dart';
import '../groups/current_member.dart';
import 'package:serverpod/serverpod.dart';

import 'task_service.dart';

/// Propose and vote on tasks (PRODUCT.md §3, §10.3).
class TaskEndpoint extends Endpoint {
  final TaskService _taskService = const TaskService();

  @override
  bool get requireLogin => true;

  /// All tasks in the signed-in member's group.
  Future<List<Task>> listTasks(Session session) async {
    final member = await currentGroupMember(session);
    return Task.db.find(
      session,
      where: (t) => t.groupId.equals(member.groupId),
    );
  }

  /// Propose a new task. Starts `proposed` and opens a proposal vote.
  Future<Task> proposeTask(
    Session session,
    String title,
    String description,
    int reward,
  ) async {
    final member = await currentGroupMember(session);
    return _taskService.proposeTask(
      session,
      proposer: member,
      title: title,
      description: description,
      reward: reward,
    );
  }

  /// Vote on a proposed task's price and description.
  Future<Task> voteTaskProposal(
    Session session,
    int taskId,
    bool approve,
  ) async {
    final member = await currentGroupMember(session);
    final task = await _findGroupTask(session, member, taskId);
    return _taskService.castProposalVote(
      session,
      task: task,
      voter: member,
      approve: approve,
    );
  }

  /// Counter-offer a different price instead of a plain reject. Freezes the
  /// vote until the proposer responds.
  Future<Task> counterOfferTask(
    Session session,
    int taskId,
    int counterReward,
  ) async {
    final member = await currentGroupMember(session);
    final task = await _findGroupTask(session, member, taskId);
    return _taskService.counterOfferTask(
      session,
      task: task,
      voter: member,
      counterReward: counterReward,
    );
  }

  /// The proposer accepts or withdraws the pending counter-offer.
  Future<Task> respondToCounterOffer(
    Session session,
    int taskId,
    bool accept,
  ) async {
    final member = await currentGroupMember(session);
    final task = await _findGroupTask(session, member, taskId);
    return _taskService.respondToCounterOffer(
      session,
      task: task,
      author: member,
      accept: accept,
    );
  }

  /// Claim an open task as done. Whoever's request commits first wins; the
  /// other gets rejected (PRODUCT.md §3, §10.2).
  Future<Task> markTaskDone(Session session, int taskId) async {
    final member = await currentGroupMember(session);
    final task = await _findGroupTask(session, member, taskId);
    return _taskService.markDone(session, task: task, claimant: member);
  }

  Future<Task> _findGroupTask(
    Session session,
    GroupMember member,
    int taskId,
  ) async {
    final task = await Task.db.findById(session, taskId);
    if (task == null || task.groupId != member.groupId) {
      throw StateError('Task not found in your group.');
    }
    return task;
  }
}
