import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../wallet/wallet_service.dart';

/// Placeholder proposal-vote window: #64 makes it configurable per environment
/// and wires the `FutureCall` that expires it (PRODUCT.md §4.2, §10.5).
const _voteWindow = Duration(hours: 24);

/// Proposing and voting on tasks (PRODUCT.md §3, §4.1, §4.4).
class TaskService {
  const TaskService({this.walletService = const WalletService()});

  final WalletService walletService;

  /// Starts a new task as `proposed`, open to a proposal vote.
  Future<Task> proposeTask(
    Session session, {
    required GroupMember proposer,
    required String title,
    required String description,
    required int reward,
  }) {
    return Task.db.insertRow(
      session,
      Task(
        groupId: proposer.groupId,
        title: title,
        description: description,
        reward: reward,
        proposedById: proposer.id!,
        voteClosesAt: DateTime.now().toUtc().add(_voteWindow),
      ),
    );
  }

  /// Records [voter]'s proposal vote on [task] and resolves it to `open`/`rejected`
  /// once the result can no longer change (PRODUCT.md §4.1: `ceil((members - 1) / 2)`
  /// approvals). A denied proposal fines whoever proposed it (§4.4).
  Future<Task> castProposalVote(
    Session session, {
    required Task task,
    required GroupMember voter,
    required bool approve,
  }) async {
    if (task.status != TaskStatus.proposed) {
      throw StateError('This task is not open for a proposal vote.');
    }
    if (voter.id == task.proposedById) {
      throw StateError('The proposer cannot vote on their own task.');
    }

    final existingVote = await TaskVote.db.findFirstRow(
      session,
      where: (t) =>
          t.taskId.equals(task.id!) &
          t.memberId.equals(voter.id!) &
          t.phase.equals(TaskVotePhase.proposal),
    );
    if (existingVote == null) {
      await TaskVote.db.insertRow(
        session,
        TaskVote(
          taskId: task.id!,
          memberId: voter.id!,
          phase: TaskVotePhase.proposal,
          approve: approve,
        ),
      );
    } else {
      await TaskVote.db.updateRow(
        session,
        existingVote.copyWith(approve: approve),
      );
    }

    final otherMembers = await GroupMember.db.count(
      session,
      where: (t) =>
          t.groupId.equals(task.groupId) &
          t.leftAt.equals(null) &
          t.id.notEquals(task.proposedById),
    );
    final needed = (otherMembers / 2).ceil();

    final votes = await TaskVote.db.find(
      session,
      where: (t) =>
          t.taskId.equals(task.id!) & t.phase.equals(TaskVotePhase.proposal),
    );
    final approveCount = votes.where((v) => v.approve).length;
    final denyCount = votes.length - approveCount;

    if (approveCount >= needed) {
      return Task.db.updateRow(
        session,
        task.copyWith(status: TaskStatus.open, voteClosesAt: null),
      );
    }
    if (denyCount > otherMembers - needed) {
      return _denyProposal(session, task);
    }
    return task;
  }

  /// [voter] counter-offers [counterReward] instead of approving or denying.
  /// Freezes the proposal: nobody else can vote or counter-offer until the
  /// proposer responds (PRODUCT.md §4.3).
  Future<Task> counterOfferTask(
    Session session, {
    required Task task,
    required GroupMember voter,
    required int counterReward,
  }) async {
    if (task.status != TaskStatus.proposed) {
      throw StateError('This task is not open for a counter-offer.');
    }
    if (voter.id == task.proposedById) {
      throw StateError('The proposer cannot counter-offer their own task.');
    }

    final existingVote = await TaskVote.db.findFirstRow(
      session,
      where: (t) =>
          t.taskId.equals(task.id!) &
          t.memberId.equals(voter.id!) &
          t.phase.equals(TaskVotePhase.proposal),
    );
    if (existingVote == null) {
      await TaskVote.db.insertRow(
        session,
        TaskVote(
          taskId: task.id!,
          memberId: voter.id!,
          phase: TaskVotePhase.proposal,
          approve: false,
          counterReward: counterReward,
        ),
      );
    } else {
      await TaskVote.db.updateRow(
        session,
        existingVote.copyWith(approve: false, counterReward: counterReward),
      );
    }

    return Task.db.updateRow(
      session,
      task.copyWith(status: TaskStatus.counterOffered),
    );
  }

  /// [author] accepts or withdraws the pending counter-offer on [task]
  /// (PRODUCT.md §4.3). Accepting restarts the proposal vote from zero at the
  /// new price; withdrawing carries no fine.
  Future<Task> respondToCounterOffer(
    Session session, {
    required Task task,
    required GroupMember author,
    required bool accept,
  }) async {
    if (task.status != TaskStatus.counterOffered) {
      throw StateError('This task has no pending counter-offer.');
    }
    if (author.id != task.proposedById) {
      throw StateError('Only the proposer can respond to a counter-offer.');
    }

    if (!accept) {
      return Task.db.updateRow(
        session,
        task.copyWith(status: TaskStatus.withdrawn, voteClosesAt: null),
      );
    }

    final counterVote = await TaskVote.db.findFirstRow(
      session,
      where: (t) =>
          t.taskId.equals(task.id!) &
          t.phase.equals(TaskVotePhase.proposal) &
          t.counterReward.notEquals(null),
    );
    if (counterVote == null) {
      throw StateError('No counter-offer found for this task.');
    }

    return session.db.transaction((transaction) async {
      await TaskVote.db.deleteWhere(
        session,
        where: (t) =>
            t.taskId.equals(task.id!) & t.phase.equals(TaskVotePhase.proposal),
        transaction: transaction,
      );
      return Task.db.updateRow(
        session,
        task.copyWith(
          status: TaskStatus.proposed,
          reward: counterVote.counterReward!,
          voteClosesAt: DateTime.now().toUtc().add(_voteWindow),
        ),
        transaction: transaction,
      );
    });
  }

  Future<Task> _denyProposal(Session session, Task task) {
    return session.db.transaction((transaction) async {
      final updated = await Task.db.updateRow(
        session,
        task.copyWith(status: TaskStatus.rejected, voteClosesAt: null),
        transaction: transaction,
      );

      final group = await Group.db.findById(
        session,
        task.groupId,
        transaction: transaction,
      );
      if (group == null) throw StateError('Group not found.');

      final fine = (task.reward * group.finePercent / 100).ceil();
      await walletService.recordTransaction(
        session,
        groupId: task.groupId,
        memberId: task.proposedById,
        amount: -fine,
        reason: CoinTransactionReason.fined,
        taskId: task.id,
        transaction: transaction,
      );

      return updated;
    });
  }
}
