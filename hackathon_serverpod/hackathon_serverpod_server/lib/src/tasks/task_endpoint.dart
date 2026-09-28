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

  /// The votes cast so far in the group's open votes: the proposal votes of
  /// tasks still `proposed` or `counterOffered` and the completion votes of
  /// tasks `inValidation`. Lets the app show who has voted and leave out of
  /// "waiting for your vote" what the member already voted (PRODUCT.md §11).
  /// Closed votes stay out, so the list does not grow with the history.
  Future<List<TaskVote>> listTaskVotes(Session session) async {
    final member = await currentGroupMember(session);
    final openTasks = await Task.db.find(
      session,
      where: (t) =>
          t.groupId.equals(member.groupId) &
          t.status.inSet({
            TaskStatus.proposed,
            TaskStatus.counterOffered,
            TaskStatus.inValidation,
          }),
    );
    if (openTasks.isEmpty) return [];
    final phaseOf = {
      for (final task in openTasks)
        task.id!: task.status == TaskStatus.inValidation
            ? TaskVotePhase.completion
            : TaskVotePhase.proposal,
    };
    final votes = await TaskVote.db.find(
      session,
      where: (v) => v.taskId.inSet(phaseOf.keys.toSet()),
    );
    return [
      for (final vote in votes)
        if (vote.phase == phaseOf[vote.taskId]) vote,
    ];
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

  /// Vote on whether a claimed task was actually done. Approval pays the
  /// claimant; denial fines them and reopens the task for someone else
  /// (PRODUCT.md §3).
  Future<Task> voteTaskCompletion(
    Session session,
    int taskId,
    bool approve,
  ) async {
    final member = await currentGroupMember(session);
    final task = await _findGroupTask(session, member, taskId);
    return _taskService.castCompletionVote(
      session,
      task: task,
      voter: member,
      approve: approve,
    );
  }

  Future<Task> _findGroupTask(
    Session session,
    GroupMember member,
    int taskId,
  ) async {
    final task = await Task.db.findById(session, taskId);
    if (task == null || task.groupId != member.groupId) {
      throw TaskException(reason: TaskErrorReason.taskNotFound);
    }
    return task;
  }
}
