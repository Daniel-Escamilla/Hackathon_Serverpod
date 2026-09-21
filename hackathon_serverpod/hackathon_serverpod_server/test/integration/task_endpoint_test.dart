import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:hackathon_serverpod_server/src/tasks/task_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _aliceAuthUserId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
const _bobAuthUserId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
const _carolAuthUserId = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc';
const _daveAuthUserId = 'dddddddd-dddd-4ddd-8ddd-dddddddddddd';

void main() {
  withServerpod('Given a group of four with a proposed task', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    const taskService = TaskService();

    late Group householdGroup;
    late GroupMember alice;
    late GroupMember bob;
    late GroupMember carol;
    late GroupMember dave;

    TestSessionBuilder sessionOf(String authUserId) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(authUserId, {}),
    );

    setUp(() async {
      householdGroup = await Group.db.insertRow(
        session,
        Group(
          name: 'Piso de prueba',
          type: GroupType.sharedFlat,
          inviteCode: 'TASK01',
        ),
      );
      alice = await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: householdGroup.id!,
          authUserId: UuidValue.fromString(_aliceAuthUserId),
          displayName: 'Alice',
          role: GroupMemberRole.admin,
        ),
      );
      bob = await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: householdGroup.id!,
          authUserId: UuidValue.fromString(_bobAuthUserId),
          displayName: 'Bob',
          role: GroupMemberRole.member,
        ),
      );
      carol = await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: householdGroup.id!,
          authUserId: UuidValue.fromString(_carolAuthUserId),
          displayName: 'Carol',
          role: GroupMemberRole.member,
        ),
      );
      dave = await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: householdGroup.id!,
          authUserId: UuidValue.fromString(_daveAuthUserId),
          displayName: 'Dave',
          role: GroupMemberRole.member,
        ),
      );
    });

    test('then proposing starts it as proposed, open to a vote', () async {
      final task = await endpoints.task.proposeTask(
        sessionOf(_aliceAuthUserId),
        'Limpiar el baño',
        '',
        25,
      );

      expect(task.status, TaskStatus.proposed);
      expect(task.proposedById, alice.id);
      expect(task.voteClosesAt, isNotNull);
    });

    group('when voting on the proposal', () {
      late Task proposedTask;

      setUp(() async {
        proposedTask = await endpoints.task.proposeTask(
          sessionOf(_aliceAuthUserId),
          'Limpiar el baño',
          '',
          25,
        );
      });

      test('then it opens once the majority of 3 others approve', () async {
        await endpoints.task.voteTaskProposal(
          sessionOf(_bobAuthUserId),
          proposedTask.id!,
          true,
        );
        final resolved = await endpoints.task.voteTaskProposal(
          sessionOf(_carolAuthUserId),
          proposedTask.id!,
          true,
        );

        expect(resolved.status, TaskStatus.open);
        expect(resolved.voteClosesAt, isNull);
      });

      test(
        'then it is rejected and fines the proposer once approval becomes impossible',
        () async {
          await endpoints.task.voteTaskProposal(
            sessionOf(_bobAuthUserId),
            proposedTask.id!,
            false,
          );
          final resolved = await endpoints.task.voteTaskProposal(
            sessionOf(_carolAuthUserId),
            proposedTask.id!,
            false,
          );

          expect(resolved.status, TaskStatus.rejected);

          final proposer = await GroupMember.db.findById(session, alice.id!);
          expect(proposer!.balance, -5); // 20% of 25, rounded up

          final history = await CoinTransaction.db.find(
            session,
            where: (t) => t.memberId.equals(alice.id!),
          );
          expect(history, hasLength(1));
          expect(history.single.reason, CoinTransactionReason.fined);
          expect(history.single.taskId, proposedTask.id);
        },
      );

      test('then the proposer cannot vote on their own task', () async {
        await expectLater(
          endpoints.task.voteTaskProposal(
            sessionOf(_aliceAuthUserId),
            proposedTask.id!,
            true,
          ),
          throwsA(isA<StateError>()),
        );
      });

      test(
        'then expiring it fines only the members who did not vote (#64, #63)',
        () async {
          await endpoints.task.voteTaskProposal(
            sessionOf(_bobAuthUserId),
            proposedTask.id!,
            true,
          );

          await taskService.expireVote(
            session,
            taskId: proposedTask.id!,
            expectedVoteClosesAt: proposedTask.voteClosesAt!,
          );

          final resolved = await Task.db.findById(session, proposedTask.id!);
          expect(resolved!.status, TaskStatus.rejected);
          expect(resolved.voteClosesAt, isNull);

          final bobAfter = await GroupMember.db.findById(session, bob.id!);
          expect(bobAfter!.balance, 0); // voted, no fine

          final carolAfter = await GroupMember.db.findById(session, carol.id!);
          expect(carolAfter!.balance, -5); // 20% of 25, rounded up
          final daveAfter = await GroupMember.db.findById(session, dave.id!);
          expect(daveAfter!.balance, -5);

          final proposerAfter = await GroupMember.db.findById(
            session,
            alice.id!,
          );
          expect(proposerAfter!.balance, 0); // excluded, not "didn't vote"
        },
      );

      test(
        'then expiring an already-resolved vote does nothing',
        () async {
          await endpoints.task.voteTaskProposal(
            sessionOf(_bobAuthUserId),
            proposedTask.id!,
            true,
          );
          await endpoints.task.voteTaskProposal(
            sessionOf(_carolAuthUserId),
            proposedTask.id!,
            true,
          );

          await taskService.expireVote(
            session,
            taskId: proposedTask.id!,
            expectedVoteClosesAt: proposedTask.voteClosesAt!,
          );

          final resolved = await Task.db.findById(session, proposedTask.id!);
          expect(resolved!.status, TaskStatus.open); // unchanged by expiry

          final daveAfter = await GroupMember.db.findById(session, dave.id!);
          expect(daveAfter!.balance, 0); // never voted, but not fined
        },
      );
    });

    group('when counter-offering the proposal', () {
      late Task proposedTask;

      setUp(() async {
        proposedTask = await endpoints.task.proposeTask(
          sessionOf(_aliceAuthUserId),
          'Limpiar el baño',
          '',
          25,
        );
      });

      test('then it freezes the vote for everyone else', () async {
        final countered = await endpoints.task.counterOfferTask(
          sessionOf(_bobAuthUserId),
          proposedTask.id!,
          20,
        );
        expect(countered.status, TaskStatus.counterOffered);

        await expectLater(
          endpoints.task.voteTaskProposal(
            sessionOf(_carolAuthUserId),
            proposedTask.id!,
            true,
          ),
          throwsA(isA<StateError>()),
        );
        await expectLater(
          endpoints.task.counterOfferTask(
            sessionOf(_carolAuthUserId),
            proposedTask.id!,
            15,
          ),
          throwsA(isA<StateError>()),
        );
      });

      group('and the proposer responds', () {
        setUp(() async {
          await endpoints.task.counterOfferTask(
            sessionOf(_bobAuthUserId),
            proposedTask.id!,
            20,
          );
        });

        test(
          'then accepting restarts the vote from zero at the new price',
          () async {
            final restarted = await endpoints.task.respondToCounterOffer(
              sessionOf(_aliceAuthUserId),
              proposedTask.id!,
              true,
            );

            expect(restarted.status, TaskStatus.proposed);
            expect(restarted.reward, 20);
            expect(restarted.voteClosesAt, isNotNull);

            final votes = await TaskVote.db.find(
              session,
              where: (t) => t.taskId.equals(proposedTask.id!),
            );
            expect(votes, isEmpty);

            final resolved = await endpoints.task.voteTaskProposal(
              sessionOf(_bobAuthUserId),
              proposedTask.id!,
              true,
            );
            await endpoints.task.voteTaskProposal(
              sessionOf(_carolAuthUserId),
              proposedTask.id!,
              true,
            );
            final opened = await Task.db.findById(session, resolved.id!);
            expect(opened!.status, TaskStatus.open);
          },
        );

        test(
          'then expiring the original window after a restart does nothing',
          () async {
            final originalVoteClosesAt = proposedTask.voteClosesAt!;

            final restarted = await endpoints.task.respondToCounterOffer(
              sessionOf(_aliceAuthUserId),
              proposedTask.id!,
              true,
            );

            await taskService.expireVote(
              session,
              taskId: proposedTask.id!,
              expectedVoteClosesAt: originalVoteClosesAt,
            );

            final unchanged = await Task.db.findById(session, restarted.id!);
            expect(unchanged!.status, TaskStatus.proposed);
            expect(unchanged.voteClosesAt, isNotNull);

            final proposerAfter = await GroupMember.db.findById(
              session,
              alice.id!,
            );
            expect(proposerAfter!.balance, 0);
          },
        );

        test('then withdrawing carries no fine', () async {
          final withdrawn = await endpoints.task.respondToCounterOffer(
            sessionOf(_aliceAuthUserId),
            proposedTask.id!,
            false,
          );

          expect(withdrawn.status, TaskStatus.withdrawn);

          final proposer = await GroupMember.db.findById(session, alice.id!);
          expect(proposer!.balance, 0);
        });

        test('then only the proposer can respond', () async {
          await expectLater(
            endpoints.task.respondToCounterOffer(
              sessionOf(_bobAuthUserId),
              proposedTask.id!,
              true,
            ),
            throwsA(isA<StateError>()),
          );
        });
      });
    });

    group('when the task is open', () {
      late Task openTask;

      setUp(() async {
        final proposedTask = await endpoints.task.proposeTask(
          sessionOf(_aliceAuthUserId),
          'Limpiar el baño',
          '',
          25,
        );
        await endpoints.task.voteTaskProposal(
          sessionOf(_bobAuthUserId),
          proposedTask.id!,
          true,
        );
        openTask = await endpoints.task.voteTaskProposal(
          sessionOf(_carolAuthUserId),
          proposedTask.id!,
          true,
        );
      });

      test('then marking it done sends it to validation', () async {
        final claimed = await endpoints.task.markTaskDone(
          sessionOf(_bobAuthUserId),
          openTask.id!,
        );

        expect(claimed.status, TaskStatus.inValidation);
        expect(claimed.doneById, bob.id);
        expect(claimed.voteClosesAt, isNotNull);
      });

      test(
        'then the proposer can also claim and cash their own task',
        () async {
          final claimed = await endpoints.task.markTaskDone(
            sessionOf(_aliceAuthUserId),
            openTask.id!,
          );

          expect(claimed.doneById, alice.id);
        },
      );

      test('then a second claim on an already-claimed task fails', () async {
        await endpoints.task.markTaskDone(
          sessionOf(_bobAuthUserId),
          openTask.id!,
        );

        await expectLater(
          endpoints.task.markTaskDone(
            sessionOf(_carolAuthUserId),
            openTask.id!,
          ),
          throwsA(isA<StateError>()),
        );
      });

      group('and it is claimed', () {
        late Task claimedTask;

        setUp(() async {
          claimedTask = await endpoints.task.markTaskDone(
            sessionOf(_bobAuthUserId),
            openTask.id!,
          );
        });

        test(
          'then approving the validation pays the claimant and closes it as done',
          () async {
            await endpoints.task.voteTaskCompletion(
              sessionOf(_aliceAuthUserId),
              claimedTask.id!,
              true,
            );
            final resolved = await endpoints.task.voteTaskCompletion(
              sessionOf(_carolAuthUserId),
              claimedTask.id!,
              true,
            );

            expect(resolved.status, TaskStatus.done);
            expect(resolved.voteClosesAt, isNull);

            final claimant = await GroupMember.db.findById(session, bob.id!);
            expect(claimant!.balance, 25);

            final history = await CoinTransaction.db.find(
              session,
              where: (t) => t.memberId.equals(bob.id!),
            );
            expect(history, hasLength(1));
            expect(history.single.reason, CoinTransactionReason.earned);
            expect(history.single.amount, 25);
            expect(history.single.taskId, claimedTask.id);
          },
        );

        test(
          'then denying the validation fines the claimant and reopens the task',
          () async {
            await endpoints.task.voteTaskCompletion(
              sessionOf(_aliceAuthUserId),
              claimedTask.id!,
              false,
            );
            final resolved = await endpoints.task.voteTaskCompletion(
              sessionOf(_carolAuthUserId),
              claimedTask.id!,
              false,
            );

            expect(resolved.status, TaskStatus.open);
            expect(resolved.doneById, isNull);
            expect(resolved.voteClosesAt, isNull);

            final claimant = await GroupMember.db.findById(session, bob.id!);
            expect(claimant!.balance, -5); // 20% of 25, rounded up

            final history = await CoinTransaction.db.find(
              session,
              where: (t) => t.memberId.equals(bob.id!),
            );
            expect(history, hasLength(1));
            expect(history.single.reason, CoinTransactionReason.fined);
            expect(history.single.taskId, claimedTask.id);
          },
        );

        test(
          'then the claimant cannot vote on their own completion',
          () async {
            await expectLater(
              endpoints.task.voteTaskCompletion(
                sessionOf(_bobAuthUserId),
                claimedTask.id!,
                true,
              ),
              throwsA(isA<StateError>()),
            );
          },
        );

        test(
          'then expiring it fines only the members who did not vote (#64, #63)',
          () async {
            await endpoints.task.voteTaskCompletion(
              sessionOf(_aliceAuthUserId),
              claimedTask.id!,
              true,
            );

            await taskService.expireVote(
              session,
              taskId: claimedTask.id!,
              expectedVoteClosesAt: claimedTask.voteClosesAt!,
            );

            final resolved = await Task.db.findById(session, claimedTask.id!);
            expect(resolved!.status, TaskStatus.open);
            expect(resolved.doneById, isNull);
            expect(resolved.voteClosesAt, isNull);

            final aliceAfter = await GroupMember.db.findById(
              session,
              alice.id!,
            );
            expect(aliceAfter!.balance, 0); // voted, no fine

            final carolAfter = await GroupMember.db.findById(
              session,
              carol.id!,
            );
            expect(carolAfter!.balance, -5); // 20% of 25, rounded up
            final daveAfter = await GroupMember.db.findById(session, dave.id!);
            expect(daveAfter!.balance, -5);

            final claimantAfter = await GroupMember.db.findById(
              session,
              bob.id!,
            );
            expect(claimantAfter!.balance, 0); // excluded as claimant
          },
        );
      });
    });
  });

  // Its own group: real concurrent transactions need rollback disabled
  // (serverpod-testing skill), and each withServerpod group gets its own
  // database, so this never leaks into the group above.
  withServerpod(
    'Given an open task and two members racing to claim it',
    (sessionBuilder, endpoints) {
      final session = sessionBuilder.build();

      TestSessionBuilder sessionOf(String authUserId) =>
          sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authUserId,
              {},
            ),
          );

      test('then only one of the two simultaneous claims wins', () async {
        final householdGroup = await Group.db.insertRow(
          session,
          Group(
            name: 'Piso de prueba',
            type: GroupType.sharedFlat,
            inviteCode: 'TASK02',
          ),
        );
        await GroupMember.db.insertRow(
          session,
          GroupMember(
            groupId: householdGroup.id!,
            authUserId: UuidValue.fromString(_aliceAuthUserId),
            displayName: 'Alice',
            role: GroupMemberRole.admin,
          ),
        );
        await GroupMember.db.insertRow(
          session,
          GroupMember(
            groupId: householdGroup.id!,
            authUserId: UuidValue.fromString(_bobAuthUserId),
            displayName: 'Bob',
            role: GroupMemberRole.member,
          ),
        );
        await GroupMember.db.insertRow(
          session,
          GroupMember(
            groupId: householdGroup.id!,
            authUserId: UuidValue.fromString(_carolAuthUserId),
            displayName: 'Carol',
            role: GroupMemberRole.member,
          ),
        );

        final proposedTask = await endpoints.task.proposeTask(
          sessionOf(_aliceAuthUserId),
          'Limpiar el baño',
          '',
          25,
        );
        // 2 other members: ceil(2/2) = 1 approval already opens it.
        final openTask = await endpoints.task.voteTaskProposal(
          sessionOf(_bobAuthUserId),
          proposedTask.id!,
          true,
        );

        final outcomes = await Future.wait([
          endpoints.task
              .markTaskDone(sessionOf(_bobAuthUserId), openTask.id!)
              .then<Object>((task) => task, onError: (Object e) => e),
          endpoints.task
              .markTaskDone(sessionOf(_carolAuthUserId), openTask.id!)
              .then<Object>((task) => task, onError: (Object e) => e),
        ]);

        final wins = outcomes.whereType<Task>();
        final losses = outcomes.whereType<StateError>();
        expect(wins, hasLength(1));
        expect(losses, hasLength(1));

        final finalState = await Task.db.findById(session, openTask.id!);
        expect(finalState!.status, TaskStatus.inValidation);
        expect(finalState.doneById, wins.single.doneById);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
