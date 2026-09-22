import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:hackathon_serverpod_server/src/tasks/task_vote_future_call.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _aliceAuthUserId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
const _bobAuthUserId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';

void main() {
  withServerpod('Given a proposal nobody voted on', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();

    TestSessionBuilder sessionOf(String authUserId) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(authUserId, {}),
    );

    test(
      'when its scheduled call fires then the proposal is rejected',
      () async {
        final group = await endpoints.group.createGroup(
          sessionOf(_aliceAuthUserId),
          'Piso de prueba',
          GroupType.sharedFlat,
          displayName: 'Alice',
        );
        await endpoints.group.joinGroup(
          sessionOf(_bobAuthUserId),
          group.inviteCode,
          displayName: 'Bob',
        );
        final task = await endpoints.task.proposeTask(
          sessionOf(_aliceAuthUserId),
          'Limpiar el baño',
          '',
          25,
        );

        await TaskVoteFutureCall().expireVote(
          session,
          task.id!,
          task.voteClosesAt!,
        );

        final expired = await Task.db.findById(session, task.id!);
        expect(expired!.status, TaskStatus.rejected);
      },
    );
  });
}
