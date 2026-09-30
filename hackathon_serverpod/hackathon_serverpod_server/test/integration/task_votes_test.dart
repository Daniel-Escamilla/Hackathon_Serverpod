import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _aliceAuthUserId = 'a1a1a1a1-a1a1-4a1a-8a1a-a1a1a1a1a1a1';
const _bobAuthUserId = 'b1b1b1b1-b1b1-4b1b-8b1b-b1b1b1b1b1b1';
const _carolAuthUserId = 'c1c1c1c1-c1c1-4c1c-8c1c-c1c1c1c1c1c1';
const _daveAuthUserId = 'd1d1d1d1-d1d1-4d1d-8d1d-d1d1d1d1d1d1';
const _outsiderAuthUserId = 'e1e1e1e1-e1e1-4e1e-8e1e-e1e1e1e1e1e1';

void main() {
  withServerpod('Given a group of four with a proposed task', (
    sessionBuilder,
    endpoints,
  ) {
    TestSessionBuilder sessionOf(String authUserId) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(authUserId, {}),
    );

    late Task task;
    late Map<String, int> memberIds;

    setUp(() async {
      final group = await endpoints.group.createGroup(
        sessionOf(_aliceAuthUserId),
        'Piso de prueba',
        GroupType.sharedFlat,
        displayName: 'Alice',
      );
      for (final (authUserId, name) in [
        (_bobAuthUserId, 'Bob'),
        (_carolAuthUserId, 'Carol'),
        (_daveAuthUserId, 'Dave'),
      ]) {
        await endpoints.group.joinGroup(
          sessionOf(authUserId),
          group.inviteCode,
          displayName: name,
        );
      }
      final members = await endpoints.group.listMembers(
        sessionOf(_aliceAuthUserId),
      );
      memberIds = {for (final m in members) m.displayName: m.id!};
      // Three others vote, so the proposal needs two yes votes (§4.1).
      task = await endpoints.task.proposeTask(
        sessionOf(_aliceAuthUserId),
        'Limpiar el baño',
        '',
        10,
      );
    });

    test('when nobody has voted yet then there are no votes', () async {
      final votes = await endpoints.task.listTaskVotes(
        sessionOf(_bobAuthUserId),
      );
      expect(votes, isEmpty);
    });

    test(
      'when one member votes on the proposal then every member sees that vote',
      () async {
        await endpoints.task.voteTaskProposal(
          sessionOf(_bobAuthUserId),
          task.id!,
          true,
        );

        final votes = await endpoints.task.listTaskVotes(
          sessionOf(_carolAuthUserId),
        );
        expect(votes, hasLength(1));
        expect(votes.single.taskId, task.id);
        expect(votes.single.memberId, memberIds['Bob']);
        expect(votes.single.phase, TaskVotePhase.proposal);
        expect(votes.single.approve, isTrue);
      },
    );

    test(
      'when the proposal vote closes then its votes leave the list',
      () async {
        await endpoints.task.voteTaskProposal(
          sessionOf(_bobAuthUserId),
          task.id!,
          true,
        );
        final opened = await endpoints.task.voteTaskProposal(
          sessionOf(_carolAuthUserId),
          task.id!,
          true,
        );
        expect(opened.status, TaskStatus.open);

        final votes = await endpoints.task.listTaskVotes(
          sessionOf(_aliceAuthUserId),
        );
        expect(votes, isEmpty);
      },
    );

    test(
      'when the task is claimed then only the completion votes are listed',
      () async {
        await endpoints.task.voteTaskProposal(
          sessionOf(_bobAuthUserId),
          task.id!,
          true,
        );
        await endpoints.task.voteTaskProposal(
          sessionOf(_carolAuthUserId),
          task.id!,
          true,
        );
        await endpoints.task.markTaskDone(sessionOf(_daveAuthUserId), task.id!);
        await endpoints.task.voteTaskCompletion(
          sessionOf(_aliceAuthUserId),
          task.id!,
          true,
        );

        final votes = await endpoints.task.listTaskVotes(
          sessionOf(_bobAuthUserId),
        );
        expect(votes, hasLength(1));
        expect(votes.single.memberId, memberIds['Alice']);
        expect(votes.single.phase, TaskVotePhase.completion);
      },
    );

    test('when someone from another group asks then they see none', () async {
      await endpoints.task.voteTaskProposal(
        sessionOf(_bobAuthUserId),
        task.id!,
        true,
      );
      await endpoints.group.createGroup(
        sessionOf(_outsiderAuthUserId),
        'Otro piso',
        GroupType.sharedFlat,
        displayName: 'Eve',
      );

      final votes = await endpoints.task.listTaskVotes(
        sessionOf(_outsiderAuthUserId),
      );
      expect(votes, isEmpty);
    });
  });
}
