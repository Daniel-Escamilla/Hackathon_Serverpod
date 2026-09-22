import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _aliceAuthUserId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
const _bobAuthUserId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
const _strangerAuthUserId = 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee';

void main() {
  // The stream's own lookup runs alongside the call that publishes, and
  // concurrent database calls need rollback disabled (serverpod-testing
  // skill). No test here depends on another's rows.
  withServerpod(
    'Given a group watched live by one of its members',
    (
      sessionBuilder,
      endpoints,
    ) {
      TestSessionBuilder sessionOf(String authUserId) =>
          sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authUserId,
              {},
            ),
          );

      test(
        'when another member proposes a task then the watcher gets it',
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
          final stream = endpoints.event.watchGroup(sessionOf(_bobAuthUserId));
          await flushEventQueue();

          final task = await endpoints.task.proposeTask(
            sessionOf(_aliceAuthUserId),
            'Limpiar el baño',
            '',
            25,
          );

          final event = await stream.first;
          expect(event.groupId, group.id);
          expect(event.kind, GroupEventKind.taskProposed);
          expect(event.taskId, task.id);
        },
      );

      test('when someone with no group watches then it is refused', () async {
        final stream = endpoints.event.watchGroup(
          sessionOf(_strangerAuthUserId),
        );

        await expectLater(
          stream.first,
          throwsA(
            isA<GroupException>().having(
              (e) => e.reason,
              'reason',
              GroupErrorReason.noMembership,
            ),
          ),
        );
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
