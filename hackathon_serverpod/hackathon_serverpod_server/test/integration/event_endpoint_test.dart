import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _aliceAuthUserId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
const _bobAuthUserId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
const _strangerAuthUserId = 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee';
// Rollback is off in this file, so each test that builds a group brings its
// own people.
const _claimAdminAuthUserId = 'c2c2c2c2-c2c2-4c2c-8c2c-c2c2c2c2c2c2';
const _claimantAuthUserId = 'c3c3c3c3-c3c3-4c3c-8c3c-c3c3c3c3c3c3';
const _expelAdminAuthUserId = 'c4c4c4c4-c4c4-4c4c-8c4c-c4c4c4c4c4c4';
const _expelledAuthUserId = 'c5c5c5c5-c5c5-4c5c-8c5c-c5c5c5c5c5c5';

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

      test(
        'when a member claims a task as done then the watcher gets it',
        () async {
          final group = await endpoints.group.createGroup(
            sessionOf(_claimAdminAuthUserId),
            'Piso de reclamar',
            GroupType.sharedFlat,
            displayName: 'Alice',
          );
          await endpoints.group.joinGroup(
            sessionOf(_claimantAuthUserId),
            group.inviteCode,
            displayName: 'Bob',
          );
          final task = await endpoints.task.proposeTask(
            sessionOf(_claimAdminAuthUserId),
            'Sacar la basura',
            '',
            10,
          );
          // Two members: Bob's yes is the majority and opens it (§4.1).
          await endpoints.task.voteTaskProposal(
            sessionOf(_claimantAuthUserId),
            task.id!,
            true,
          );
          final stream = endpoints.event.watchGroup(
            sessionOf(_claimAdminAuthUserId),
          );
          await flushEventQueue();

          await endpoints.task.markTaskDone(
            sessionOf(_claimantAuthUserId),
            task.id!,
          );

          final event = await stream.first;
          expect(event.kind, GroupEventKind.taskClaimed);
          expect(event.taskId, task.id);
        },
      );

      test(
        'when the admin expels a member then the expelled member hears it',
        () async {
          final group = await endpoints.group.createGroup(
            sessionOf(_expelAdminAuthUserId),
            'Piso de expulsar',
            GroupType.sharedFlat,
            displayName: 'Alice',
          );
          final expelled = await endpoints.group.joinGroup(
            sessionOf(_expelledAuthUserId),
            group.inviteCode,
            displayName: 'Bob',
          );
          final stream = endpoints.event.watchGroup(
            sessionOf(_expelledAuthUserId),
          );
          await flushEventQueue();

          await endpoints.group.expelMember(
            sessionOf(_expelAdminAuthUserId),
            expelled.id!,
          );

          final event = await stream.first;
          expect(event.kind, GroupEventKind.memberExpelled);
          expect(event.memberId, expelled.id);
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
