import 'dart:io';

import 'package:serverpod/serverpod.dart';

import '../events/event_service.dart';
import '../generated/future_calls.dart' show ServerpodFutureCallsGetter;
import '../generated/protocol.dart';
import '../wallet/wallet_service.dart';

/// How long a proposal or completion vote stays open (#64, PRODUCT.md §4.2,
/// §10.5): 24 hours in production, a short default elsewhere so tests and
/// demos don't wait a day. Override with `TASK_VOTE_WINDOW_SECONDS` (e.g. for
/// the demo recording) without touching code.
Duration _voteWindow(Session session) {
  final overrideSeconds = int.tryParse(
    Platform.environment['TASK_VOTE_WINDOW_SECONDS'] ?? '',
  );
  if (overrideSeconds != null) return Duration(seconds: overrideSeconds);

  return session.serverpod.runMode == ServerpodRunMode.production
      ? const Duration(hours: 24)
      : const Duration(minutes: 2);
}

/// Proposing and voting on tasks (PRODUCT.md §3, §4.1, §4.4).
class TaskService {
  const TaskService({
    this.walletService = const WalletService(),
    this.eventService = const EventService(),
  });

  final WalletService walletService;
  final EventService eventService;

  /// Starts a new task as `proposed`, open to a proposal vote.
  Future<Task> proposeTask(
    Session session, {
    required GroupMember proposer,
    required String title,
    required String description,
    required int reward,
  }) async {
    final task = await Task.db.insertRow(
      session,
      Task(
        groupId: proposer.groupId,
        title: title,
        description: description,
        reward: reward,
        proposedById: proposer.id!,
        voteClosesAt: DateTime.now().toUtc().add(_voteWindow(session)),
      ),
    );
    await _scheduleVoteExpiry(session, task);
    await eventService.publish(
      session,
      groupId: task.groupId,
      kind: GroupEventKind.taskProposed,
      taskId: task.id,
    );
    return task;
  }

  /// Schedules the `FutureCall` (#64, PRODUCT.md §10.5) that closes [task]'s
  /// vote if it's still open when `task.voteClosesAt` arrives. Called every
  /// time a proposal or completion vote opens or restarts; see
  /// `TaskVoteFutureCall.expireVote` for what runs when it fires, and
  /// [expireVote] below for why a stale one is safe to leave scheduled.
  Future<void> _scheduleVoteExpiry(Session session, Task task) {
    return session.serverpod.futureCalls
        .callAtTime(
          task.voteClosesAt!,
          identifier: 'task-vote-${task.id}',
        )
        .taskVote
        .expireVote(task.id!, task.voteClosesAt!);
  }

  /// Records [voter]'s proposal vote on [task] and resolves it to `open`/`rejected`
  /// once the result can no longer change (PRODUCT.md §4.1: `ceil((members - 1) / 2)`
  /// approvals). A denied proposal fines whoever proposed it (§4.4).
  ///
  /// Reads [task] locked, inside the same transaction as the vote and the
  /// recount: two members casting the deciding vote within the same instant
  /// otherwise both read the recount before either commits, and both would
  /// resolve the task — paying or fining it twice (same risk `markDone`
  /// guards against with its own lock).
  Future<Task> castProposalVote(
    Session session, {
    required Task task,
    required GroupMember voter,
    required bool approve,
  }) async {
    final resolved = await session.db.transaction((transaction) async {
      final locked = await Task.db.findById(
        session,
        task.id!,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (locked == null) {
        throw TaskException(reason: TaskErrorReason.taskNotFound);
      }
      if (locked.status != TaskStatus.proposed) {
        throw TaskException(reason: TaskErrorReason.notOpen);
      }
      if (voter.id == locked.proposedById) {
        throw TaskException(reason: TaskErrorReason.ownTask);
      }

      final existingVote = await TaskVote.db.findFirstRow(
        session,
        where: (t) =>
            t.taskId.equals(locked.id!) &
            t.memberId.equals(voter.id!) &
            t.phase.equals(TaskVotePhase.proposal),
        transaction: transaction,
      );
      if (existingVote == null) {
        await TaskVote.db.insertRow(
          session,
          TaskVote(
            taskId: locked.id!,
            memberId: voter.id!,
            phase: TaskVotePhase.proposal,
            approve: approve,
          ),
          transaction: transaction,
        );
      } else {
        await TaskVote.db.updateRow(
          session,
          existingVote.copyWith(approve: approve),
          transaction: transaction,
        );
      }

      final otherMembers = await GroupMember.db.count(
        session,
        where: (t) =>
            t.groupId.equals(locked.groupId) &
            t.leftAt.equals(null) &
            t.id.notEquals(locked.proposedById),
        transaction: transaction,
      );
      final needed = (otherMembers / 2).ceil();

      final votes = await TaskVote.db.find(
        session,
        where: (t) =>
            t.taskId.equals(locked.id!) &
            t.phase.equals(TaskVotePhase.proposal),
        transaction: transaction,
      );
      final approveCount = votes.where((v) => v.approve).length;
      final denyCount = votes.length - approveCount;

      if (approveCount >= needed) {
        return Task.db.updateRow(
          session,
          locked.copyWith(status: TaskStatus.open, voteClosesAt: null),
          transaction: transaction,
        );
      }
      if (denyCount > otherMembers - needed) {
        return _denyProposal(session, locked, transaction: transaction);
      }
      return locked;
    });

    await eventService.publish(
      session,
      groupId: resolved.groupId,
      kind: GroupEventKind.taskVoteCast,
      taskId: resolved.id,
    );
    return resolved;
  }

  /// [voter] counter-offers [counterReward] instead of approving or denying.
  /// Freezes the proposal: nobody else can vote or counter-offer until the
  /// proposer responds (PRODUCT.md §4.3).
  ///
  /// Reads [task] locked, so a counter-offer arriving in the same instant as
  /// a vote or another counter-offer can't both pass the `proposed` check —
  /// "la primera contraoferta congela la votación" only holds if a second one
  /// can't slip in before the first commits.
  Future<Task> counterOfferTask(
    Session session, {
    required Task task,
    required GroupMember voter,
    required int counterReward,
  }) async {
    final countered = await session.db.transaction((transaction) async {
      final locked = await Task.db.findById(
        session,
        task.id!,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (locked == null) {
        throw TaskException(reason: TaskErrorReason.taskNotFound);
      }
      if (locked.status != TaskStatus.proposed) {
        throw TaskException(reason: TaskErrorReason.notOpen);
      }
      if (voter.id == locked.proposedById) {
        throw TaskException(reason: TaskErrorReason.ownTask);
      }

      final existingVote = await TaskVote.db.findFirstRow(
        session,
        where: (t) =>
            t.taskId.equals(locked.id!) &
            t.memberId.equals(voter.id!) &
            t.phase.equals(TaskVotePhase.proposal),
        transaction: transaction,
      );
      if (existingVote == null) {
        await TaskVote.db.insertRow(
          session,
          TaskVote(
            taskId: locked.id!,
            memberId: voter.id!,
            phase: TaskVotePhase.proposal,
            approve: false,
            counterReward: counterReward,
          ),
          transaction: transaction,
        );
      } else {
        await TaskVote.db.updateRow(
          session,
          existingVote.copyWith(approve: false, counterReward: counterReward),
          transaction: transaction,
        );
      }

      return Task.db.updateRow(
        session,
        locked.copyWith(status: TaskStatus.counterOffered),
        transaction: transaction,
      );
    });

    await eventService.publish(
      session,
      groupId: countered.groupId,
      kind: GroupEventKind.taskCounterOffered,
      taskId: countered.id,
    );
    return countered;
  }

  /// [author] accepts or withdraws the pending counter-offer on [task]
  /// (PRODUCT.md §4.3). Accepting restarts the proposal vote from zero at the
  /// new price; withdrawing carries no fine.
  ///
  /// Reads [task] locked, in the same transaction as the accept/withdraw
  /// write — [author] is the only one who can call this, so the risk here is
  /// smaller than the vote-counting methods, but the same guard keeps a
  /// double click from restarting the vote (and scheduling two expiries) or
  /// withdrawing twice.
  Future<Task> respondToCounterOffer(
    Session session, {
    required Task task,
    required GroupMember author,
    required bool accept,
  }) async {
    final result = await session.db.transaction((transaction) async {
      final locked = await Task.db.findById(
        session,
        task.id!,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (locked == null) {
        throw TaskException(reason: TaskErrorReason.taskNotFound);
      }
      if (locked.status != TaskStatus.counterOffered) {
        throw TaskException(reason: TaskErrorReason.notOpen);
      }
      if (author.id != locked.proposedById) {
        throw TaskException(reason: TaskErrorReason.notProposer);
      }

      if (!accept) {
        return Task.db.updateRow(
          session,
          locked.copyWith(status: TaskStatus.withdrawn, voteClosesAt: null),
          transaction: transaction,
        );
      }

      final counterVote = await TaskVote.db.findFirstRow(
        session,
        where: (t) =>
            t.taskId.equals(locked.id!) &
            t.phase.equals(TaskVotePhase.proposal) &
            t.counterReward.notEquals(null),
        transaction: transaction,
      );
      if (counterVote == null) {
        throw StateError('No counter-offer found for this task.');
      }

      await TaskVote.db.deleteWhere(
        session,
        where: (t) =>
            t.taskId.equals(locked.id!) &
            t.phase.equals(TaskVotePhase.proposal),
        transaction: transaction,
      );
      return Task.db.updateRow(
        session,
        locked.copyWith(
          status: TaskStatus.proposed,
          reward: counterVote.counterReward!,
          voteClosesAt: DateTime.now().toUtc().add(_voteWindow(session)),
        ),
        transaction: transaction,
      );
    });

    if (result.status == TaskStatus.proposed) {
      await _scheduleVoteExpiry(session, result);
    }
    return result;
  }

  /// [claimant] marks [task] as done, sending it to validation. Nobody reserves
  /// a task beforehand (PRODUCT.md §3), so two members can press "done" on the
  /// same task at once; the row lock inside this transaction means only the
  /// first commit sees `open` and wins, the other gets `TaskErrorReason.notOpen`
  /// (PRODUCT.md §10.2).
  Future<Task> markDone(
    Session session, {
    required Task task,
    required GroupMember claimant,
  }) async {
    final claimed = await session.db.transaction((transaction) async {
      final locked = await Task.db.findById(
        session,
        task.id!,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (locked == null) {
        throw TaskException(reason: TaskErrorReason.taskNotFound);
      }
      if (locked.status != TaskStatus.open) {
        throw TaskException(reason: TaskErrorReason.notOpen);
      }

      return Task.db.updateRow(
        session,
        locked.copyWith(
          status: TaskStatus.inValidation,
          doneById: claimant.id,
          voteClosesAt: DateTime.now().toUtc().add(_voteWindow(session)),
        ),
        transaction: transaction,
      );
    });
    await _scheduleVoteExpiry(session, claimed);
    await eventService.publish(
      session,
      groupId: claimed.groupId,
      kind: GroupEventKind.taskClaimed,
      taskId: claimed.id,
    );
    return claimed;
  }

  /// Rejects [task] and fines whoever proposed it (§4.4). Runs inside
  /// [transaction] when the caller already has one open — every caller does,
  /// now that vote resolution happens under [castProposalVote]'s lock — and
  /// opens its own otherwise, the same optional-transaction shape as
  /// `WalletService.recordTransaction`.
  Future<Task> _denyProposal(
    Session session,
    Task task, {
    Transaction? transaction,
  }) {
    Future<Task> run(Transaction tx) async {
      final updated = await Task.db.updateRow(
        session,
        task.copyWith(status: TaskStatus.rejected, voteClosesAt: null),
        transaction: tx,
      );

      final group = await Group.db.findById(
        session,
        task.groupId,
        transaction: tx,
      );
      if (group == null) throw StateError('Group not found.');

      final fine = (task.reward * group.finePercent / 100).ceil();
      await walletService.recordTransaction(
        session,
        groupId: task.groupId,
        memberId: task.proposedById,
        amount: -fine,
        reason: CoinTransactionReason.proposalDenied,
        taskId: task.id,
        transaction: tx,
      );

      return updated;
    }

    if (transaction != null) return run(transaction);
    return session.db.transaction(run);
  }

  /// Records [voter]'s completion vote on [task] and resolves it to `done`/back
  /// to `open` once the result can no longer change — the same majority rule as
  /// the proposal vote (PRODUCT.md §4.1: `ceil((members - 1) / 2)` approvals,
  /// excluding whoever claimed it). Approval pays the claimant (§3); denial
  /// fines them and reopens the task for someone else, without rejecting it
  /// (§4.4, `task_status.spy.yaml`).
  ///
  /// Locked the same way as [castProposalVote], and for the same reason: two
  /// completion votes landing the majority at once must not both pay or both
  /// fine the claimant.
  Future<Task> castCompletionVote(
    Session session, {
    required Task task,
    required GroupMember voter,
    required bool approve,
  }) async {
    final resolved = await session.db.transaction((transaction) async {
      final locked = await Task.db.findById(
        session,
        task.id!,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (locked == null) {
        throw TaskException(reason: TaskErrorReason.taskNotFound);
      }
      if (locked.status != TaskStatus.inValidation) {
        throw TaskException(reason: TaskErrorReason.notOpen);
      }
      if (voter.id == locked.doneById) {
        throw TaskException(reason: TaskErrorReason.ownTask);
      }

      final existingVote = await TaskVote.db.findFirstRow(
        session,
        where: (t) =>
            t.taskId.equals(locked.id!) &
            t.memberId.equals(voter.id!) &
            t.phase.equals(TaskVotePhase.completion),
        transaction: transaction,
      );
      if (existingVote == null) {
        await TaskVote.db.insertRow(
          session,
          TaskVote(
            taskId: locked.id!,
            memberId: voter.id!,
            phase: TaskVotePhase.completion,
            approve: approve,
          ),
          transaction: transaction,
        );
      } else {
        await TaskVote.db.updateRow(
          session,
          existingVote.copyWith(approve: approve),
          transaction: transaction,
        );
      }

      final otherMembers = await GroupMember.db.count(
        session,
        where: (t) =>
            t.groupId.equals(locked.groupId) &
            t.leftAt.equals(null) &
            t.id.notEquals(locked.doneById!),
        transaction: transaction,
      );
      final needed = (otherMembers / 2).ceil();

      final votes = await TaskVote.db.find(
        session,
        where: (t) =>
            t.taskId.equals(locked.id!) &
            t.phase.equals(TaskVotePhase.completion),
        transaction: transaction,
      );
      final approveCount = votes.where((v) => v.approve).length;
      final denyCount = votes.length - approveCount;

      if (approveCount >= needed) {
        return _payClaimant(session, locked, transaction: transaction);
      }
      if (denyCount > otherMembers - needed) {
        return _denyValidation(session, locked, transaction: transaction);
      }
      return locked;
    });

    await eventService.publish(
      session,
      groupId: resolved.groupId,
      kind: GroupEventKind.taskValidated,
      taskId: resolved.id,
    );
    return resolved;
  }

  /// The validation vote passed: closes [task] as `done` and pays its claimant.
  /// Coins are only ever paid here, never on marking a task done (PRODUCT.md §3).
  /// Same optional-[transaction] shape as [_denyProposal].
  Future<Task> _payClaimant(
    Session session,
    Task task, {
    Transaction? transaction,
  }) {
    Future<Task> run(Transaction tx) async {
      final updated = await Task.db.updateRow(
        session,
        task.copyWith(status: TaskStatus.done, voteClosesAt: null),
        transaction: tx,
      );

      await walletService.recordTransaction(
        session,
        groupId: task.groupId,
        memberId: task.doneById!,
        amount: task.reward,
        reason: CoinTransactionReason.earned,
        taskId: task.id,
        transaction: tx,
      );

      return updated;
    }

    if (transaction != null) return run(transaction);
    return session.db.transaction(run);
  }

  /// The validation vote failed: fines whoever claimed [task] and reopens it for
  /// someone else to claim — unlike a denied proposal, this does not reject the
  /// task (PRODUCT.md §3, §4.4). Same optional-[transaction] shape as
  /// [_denyProposal].
  Future<Task> _denyValidation(
    Session session,
    Task task, {
    Transaction? transaction,
  }) {
    Future<Task> run(Transaction tx) async {
      final claimantId = task.doneById!;
      final updated = await Task.db.updateRow(
        session,
        task.copyWith(
          status: TaskStatus.open,
          doneById: null,
          voteClosesAt: null,
        ),
        transaction: tx,
      );

      final group = await Group.db.findById(
        session,
        task.groupId,
        transaction: tx,
      );
      if (group == null) throw StateError('Group not found.');

      final fine = (task.reward * group.finePercent / 100).ceil();
      await walletService.recordTransaction(
        session,
        groupId: task.groupId,
        memberId: claimantId,
        amount: -fine,
        reason: CoinTransactionReason.validationDenied,
        taskId: task.id,
        transaction: tx,
      );

      return updated;
    }

    if (transaction != null) return run(transaction);
    return session.db.transaction(run);
  }

  /// Resolves an expired vote when its `FutureCall` (#64, PRODUCT.md §10.5)
  /// fires: fines every member who was eligible to vote and didn't, then
  /// resolves [taskId] the same way an explicit denial would — `rejected` for
  /// an expired proposal, back to `open` for an expired completion vote
  /// (issue #63, third fine: "votación expirada (pagan los que no votaron)").
  ///
  /// A no-op if the vote isn't the one that scheduled this call anymore:
  /// [expectedVoteClosesAt] must still match the task's current
  /// `voteClosesAt`, which changes the moment the vote resolves early or a
  /// new round starts (a counter-offer restarting the proposal vote reuses
  /// the same `proposed` status, so comparing the timestamp — not just the
  /// status — is what keeps a stale call from closing the wrong round).
  ///
  /// The match is checked twice: once before doing any work, to skip it
  /// cheaply, and again on the locked row inside the transaction — a human
  /// vote resolving the task in the instant between those two reads would
  /// otherwise still get fined by a `FutureCall` that fired a moment too
  /// late.
  Future<void> expireVote(
    Session session, {
    required int taskId,
    required DateTime expectedVoteClosesAt,
  }) async {
    final task = await Task.db.findById(session, taskId);
    if (task == null) return;
    if (task.voteClosesAt == null ||
        !task.voteClosesAt!.isAtSameMomentAs(expectedVoteClosesAt)) {
      return;
    }

    await session.db.transaction((transaction) async {
      final locked = await Task.db.findById(
        session,
        taskId,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (locked == null) return;
      if (locked.voteClosesAt == null ||
          !locked.voteClosesAt!.isAtSameMomentAs(expectedVoteClosesAt)) {
        return;
      }

      final phase = switch (locked.status) {
        TaskStatus.proposed => TaskVotePhase.proposal,
        TaskStatus.inValidation => TaskVotePhase.completion,
        _ => null,
      };
      if (phase == null) return;
      final excludedMemberId = phase == TaskVotePhase.proposal
          ? locked.proposedById
          : locked.doneById!;

      final eligibleVoters = await GroupMember.db.find(
        session,
        where: (t) =>
            t.groupId.equals(locked.groupId) &
            t.leftAt.equals(null) &
            t.id.notEquals(excludedMemberId),
        transaction: transaction,
      );
      final votes = await TaskVote.db.find(
        session,
        where: (t) => t.taskId.equals(locked.id!) & t.phase.equals(phase),
        transaction: transaction,
      );
      final votedMemberIds = votes.map((v) => v.memberId).toSet();
      final nonVoters = eligibleVoters.where(
        (member) => !votedMemberIds.contains(member.id),
      );

      final group = await Group.db.findById(
        session,
        locked.groupId,
        transaction: transaction,
      );
      if (group == null) throw StateError('Group not found.');
      final fine = (locked.reward * group.finePercent / 100).ceil();

      for (final member in nonVoters) {
        await walletService.recordTransaction(
          session,
          groupId: locked.groupId,
          memberId: member.id!,
          amount: -fine,
          reason: CoinTransactionReason.voteExpired,
          taskId: locked.id,
          transaction: transaction,
        );
      }

      await Task.db.updateRow(
        session,
        phase == TaskVotePhase.proposal
            ? locked.copyWith(status: TaskStatus.rejected, voteClosesAt: null)
            : locked.copyWith(
                status: TaskStatus.open,
                doneById: null,
                voteClosesAt: null,
              ),
        transaction: transaction,
      );
    });
  }
}
