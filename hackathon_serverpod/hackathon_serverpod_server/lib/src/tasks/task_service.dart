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

  /// [claimant] marks [task] as done, sending it to validation. Nobody reserves
  /// a task beforehand (PRODUCT.md §3), so two members can press "done" on the
  /// same task at once; the row lock inside this transaction means only the
  /// first commit sees `open` and wins, the other gets a `StateError`
  /// (PRODUCT.md §10.2).
  Future<Task> markDone(
    Session session, {
    required Task task,
    required GroupMember claimant,
  }) {
    return session.db.transaction((transaction) async {
      final locked = await Task.db.findById(
        session,
        task.id!,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (locked == null) throw StateError('Task not found.');
      if (locked.status != TaskStatus.open) {
        throw StateError('This task is not available to claim.');
      }

      return Task.db.updateRow(
        session,
        locked.copyWith(
          status: TaskStatus.inValidation,
          doneById: claimant.id,
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

  /// Records [voter]'s completion vote on [task] and resolves it to `done`/back
  /// to `open` once the result can no longer change — the same majority rule as
  /// the proposal vote (PRODUCT.md §4.1: `ceil((members - 1) / 2)` approvals,
  /// excluding whoever claimed it). Approval pays the claimant (§3); denial
  /// fines them and reopens the task for someone else, without rejecting it
  /// (§4.4, `task_status.spy.yaml`).
  Future<Task> castCompletionVote(
    Session session, {
    required Task task,
    required GroupMember voter,
    required bool approve,
  }) async {
    if (task.status != TaskStatus.inValidation) {
      throw StateError('This task is not open for a completion vote.');
    }
    if (voter.id == task.doneById) {
      throw StateError('The claimant cannot vote on their own completion.');
    }

    final existingVote = await TaskVote.db.findFirstRow(
      session,
      where: (t) =>
          t.taskId.equals(task.id!) &
          t.memberId.equals(voter.id!) &
          t.phase.equals(TaskVotePhase.completion),
    );
    if (existingVote == null) {
      await TaskVote.db.insertRow(
        session,
        TaskVote(
          taskId: task.id!,
          memberId: voter.id!,
          phase: TaskVotePhase.completion,
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
          t.id.notEquals(task.doneById!),
    );
    final needed = (otherMembers / 2).ceil();

    final votes = await TaskVote.db.find(
      session,
      where: (t) =>
          t.taskId.equals(task.id!) &
          t.phase.equals(TaskVotePhase.completion),
    );
    final approveCount = votes.where((v) => v.approve).length;
    final denyCount = votes.length - approveCount;

    if (approveCount >= needed) {
      return _payClaimant(session, task);
    }
    if (denyCount > otherMembers - needed) {
      return _denyValidation(session, task);
    }
    return task;
  }

  /// The validation vote passed: closes [task] as `done` and pays its claimant.
  /// Coins are only ever paid here, never on marking a task done (PRODUCT.md §3).
  Future<Task> _payClaimant(Session session, Task task) {
    return session.db.transaction((transaction) async {
      final updated = await Task.db.updateRow(
        session,
        task.copyWith(status: TaskStatus.done, voteClosesAt: null),
        transaction: transaction,
      );

      await walletService.recordTransaction(
        session,
        groupId: task.groupId,
        memberId: task.doneById!,
        amount: task.reward,
        reason: CoinTransactionReason.earned,
        taskId: task.id,
        transaction: transaction,
      );

      return updated;
    });
  }

  /// The validation vote failed: fines whoever claimed [task] and reopens it for
  /// someone else to claim — unlike a denied proposal, this does not reject the
  /// task (PRODUCT.md §3, §4.4).
  Future<Task> _denyValidation(Session session, Task task) {
    return session.db.transaction((transaction) async {
      final claimantId = task.doneById!;
      final updated = await Task.db.updateRow(
        session,
        task.copyWith(
          status: TaskStatus.open,
          doneById: null,
          voteClosesAt: null,
        ),
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
        memberId: claimantId,
        amount: -fine,
        reason: CoinTransactionReason.fined,
        taskId: task.id,
        transaction: transaction,
      );

      return updated;
    });
  }
}
