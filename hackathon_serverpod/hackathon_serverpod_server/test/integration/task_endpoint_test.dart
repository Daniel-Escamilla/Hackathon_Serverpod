import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
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

    late Group householdGroup;
    late GroupMember alice;

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
      await GroupMember.db.insertRow(
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
    });
  });
}
