import 'package:hackathon_serverpod_server/src/events/event_service.dart';
import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:hackathon_serverpod_server/src/tasks/task_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _aliceAuthUserId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
const _bobAuthUserId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
const _carolAuthUserId = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc';
const _daveAuthUserId = 'dddddddd-dddd-4ddd-8ddd-dddddddddddd';
const _race2ProposerAuthUserId = '01010101-0101-4101-8101-010101010101';
const _race2VoterAAuthUserId = '02020202-0202-4202-8202-020202020202';
const _race2VoterBAuthUserId = '03030303-0303-4303-8303-030303030303';
const _race3ProposerAuthUserId = '04040404-0404-4404-8404-040404040404';
const _race3VoterAuthUserId = '05050505-0505-4505-8505-050505050505';
const _race3ClaimantAuthUserId = '06060606-0606-4606-8606-060606060606';

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

    test(
      'then proposing also publishes a GroupEvent on the group stream (#65)',
      () async {
        final firstEvent = session.messages
            .createStream<GroupEvent>(groupEventChannel(householdGroup.id!))
            .first;

        final task = await endpoints.task.proposeTask(
          sessionOf(_aliceAuthUserId),
          'Limpiar el baño',
          '',
          25,
        );

        final event = await firstEvent.timeout(const Duration(seconds: 5));
        expect(event.groupId, householdGroup.id);
        expect(event.kind, GroupEventKind.taskProposed);
        expect(event.taskId, task.id);
      },
    );

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
          expect(history.single.reason, CoinTransactionReason.proposalDenied);
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

          final carolFine = await CoinTransaction.db.find(
            session,
            where: (t) => t.memberId.equals(carol.id!),
          );
          expect(carolFine.single.reason, CoinTransactionReason.voteExpired);
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

      test(
        'then voting also publishes a GroupEvent on the group stream (#65)',
        () async {
          final firstEvent = session.messages
              .createStream<GroupEvent>(
                groupEventChannel(householdGroup.id!),
              )
              .first;

          await endpoints.task.voteTaskProposal(
            sessionOf(_bobAuthUserId),
            proposedTask.id!,
            true,
          );

          final event = await firstEvent.timeout(const Duration(seconds: 5));
          expect(event.kind, GroupEventKind.taskVoteCast);
          expect(event.taskId, proposedTask.id);
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
            expect(
              history.single.reason,
              CoinTransactionReason.validationDenied,
            );
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

            final carolFine = await CoinTransaction.db.find(
              session,
              where: (t) => t.memberId.equals(carol.id!),
            );
            expect(carolFine.single.reason, CoinTransactionReason.voteExpired);
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

      test(
        'then two simultaneous deciding proposal votes reject and fine the proposer only once',
        () async {
          final householdGroup = await Group.db.insertRow(
            session,
            Group(
              name: 'Piso de prueba',
              type: GroupType.sharedFlat,
              inviteCode: 'TASK03',
            ),
          );
          final proposer = await GroupMember.db.insertRow(
            session,
            GroupMember(
              groupId: householdGroup.id!,
              authUserId: UuidValue.fromString(_race2ProposerAuthUserId),
              displayName: 'Proposer',
              role: GroupMemberRole.admin,
            ),
          );
          await GroupMember.db.insertRow(
            session,
            GroupMember(
              groupId: householdGroup.id!,
              authUserId: UuidValue.fromString(_race2VoterAAuthUserId),
              displayName: 'Voter A',
              role: GroupMemberRole.member,
            ),
          );
          await GroupMember.db.insertRow(
            session,
            GroupMember(
              groupId: householdGroup.id!,
              authUserId: UuidValue.fromString(_race2VoterBAuthUserId),
              displayName: 'Voter B',
              role: GroupMemberRole.member,
            ),
          );

          final proposedTask = await endpoints.task.proposeTask(
            sessionOf(_race2ProposerAuthUserId),
            'Limpiar el baño',
            '',
            25,
          );

          // 2 other members: ceil(2/2) = 1 approval opens it, so it takes both
          // denying at once to cross the deny threshold — the race window this
          // regression test targets (Notion "Puntos de mejora", punto 1).
          // Casting a vote is always valid while the task is still `proposed`,
          // so both calls succeed; the lock only decides which one of them
          // ends up processing the deciding vote — it must resolve exactly
          // once, not twice.
          final outcomes = await Future.wait([
            endpoints.task
                .voteTaskProposal(
                  sessionOf(_race2VoterAAuthUserId),
                  proposedTask.id!,
                  false,
                )
                .then<Object>((task) => task, onError: (Object e) => e),
            endpoints.task
                .voteTaskProposal(
                  sessionOf(_race2VoterBAuthUserId),
                  proposedTask.id!,
                  false,
                )
                .then<Object>((task) => task, onError: (Object e) => e),
          ]);

          expect(outcomes, everyElement(isA<Task>()));

          final finalState = await Task.db.findById(session, proposedTask.id!);
          expect(finalState!.status, TaskStatus.rejected);

          final fines = await CoinTransaction.db.find(
            session,
            where: (t) => t.memberId.equals(proposer.id!),
          );
          expect(fines, hasLength(1));
          expect(fines.single.reason, CoinTransactionReason.proposalDenied);
        },
      );

      test(
        'then two simultaneous deciding completion votes fine the claimant only once',
        () async {
          final householdGroup = await Group.db.insertRow(
            session,
            Group(
              name: 'Piso de prueba',
              type: GroupType.sharedFlat,
              inviteCode: 'TASK04',
            ),
          );
          await GroupMember.db.insertRow(
            session,
            GroupMember(
              groupId: householdGroup.id!,
              authUserId: UuidValue.fromString(_race3ProposerAuthUserId),
              displayName: 'Proposer',
              role: GroupMemberRole.admin,
            ),
          );
          await GroupMember.db.insertRow(
            session,
            GroupMember(
              groupId: householdGroup.id!,
              authUserId: UuidValue.fromString(_race3VoterAuthUserId),
              displayName: 'Voter',
              role: GroupMemberRole.member,
            ),
          );
          final claimant = await GroupMember.db.insertRow(
            session,
            GroupMember(
              groupId: householdGroup.id!,
              authUserId: UuidValue.fromString(_race3ClaimantAuthUserId),
              displayName: 'Claimant',
              role: GroupMemberRole.member,
            ),
          );

          final proposedTask = await endpoints.task.proposeTask(
            sessionOf(_race3ProposerAuthUserId),
            'Limpiar el baño',
            '',
            25,
          );
          final openTask = await endpoints.task.voteTaskProposal(
            sessionOf(_race3VoterAuthUserId),
            proposedTask.id!,
            true,
          );
          final claimedTask = await endpoints.task.markTaskDone(
            sessionOf(_race3ClaimantAuthUserId),
            openTask.id!,
          );

          // 2 other members (proposer, voter): ceil(2/2) = 1 approval closes
          // it, so it takes both denying at once to cross the deny threshold —
          // same race window as the proposal vote above, on the completion
          // vote. Both calls succeed for the same reason as above; only the
          // resolution — one fine, not two — is what must hold.
          final outcomes = await Future.wait([
            endpoints.task
                .voteTaskCompletion(
                  sessionOf(_race3ProposerAuthUserId),
                  claimedTask.id!,
                  false,
                )
                .then<Object>((task) => task, onError: (Object e) => e),
            endpoints.task
                .voteTaskCompletion(
                  sessionOf(_race3VoterAuthUserId),
                  claimedTask.id!,
                  false,
                )
                .then<Object>((task) => task, onError: (Object e) => e),
          ]);

          expect(outcomes, everyElement(isA<Task>()));

          final finalState = await Task.db.findById(session, claimedTask.id!);
          expect(finalState!.status, TaskStatus.open);
          expect(finalState.doneById, isNull);

          final fines = await CoinTransaction.db.find(
            session,
            where: (t) => t.memberId.equals(claimant.id!),
          );
          expect(fines, hasLength(1));
          expect(fines.single.reason, CoinTransactionReason.validationDenied);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
