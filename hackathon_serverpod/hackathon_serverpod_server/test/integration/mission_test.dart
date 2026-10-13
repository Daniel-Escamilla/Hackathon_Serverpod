import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:hackathon_serverpod_server/src/tasks/mission_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _anaAuthUserId = '1a1a1a1a-1a1a-4a1a-8a1a-1a1a1a1a1a1a';
const _leoAuthUserId = '1b1b1b1b-1b1b-4b1b-8b1b-1b1b1b1b1b1b';

// 13 October 2026 is a Tuesday; the 15th a Thursday, the 20th the next
// Tuesday. Mid-morning UTC is the same day in Madrid.
final _tuesday = DateTime.utc(2026, 10, 13, 9);
final _wednesday = DateTime.utc(2026, 10, 14, 9);
final _nextTuesday = DateTime.utc(2026, 10, 20, 9);

void main() {
  withServerpod('Given a couple scheduling a mission', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    const missions = MissionService();
    late int groupId;

    TestSessionBuilder sessionOf(String authUserId) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(authUserId, {}),
    );

    setUp(() async {
      final home = await Group.db.insertRow(
        session,
        Group(name: 'Casa', type: GroupType.couple, inviteCode: 'MISS01'),
      );
      groupId = home.id!;
      for (final (id, name, role) in [
        (_anaAuthUserId, 'Ana', GroupMemberRole.admin),
        (_leoAuthUserId, 'Leo', GroupMemberRole.member),
      ]) {
        await GroupMember.db.insertRow(
          session,
          GroupMember(
            groupId: groupId,
            authUserId: UuidValue.fromString(id),
            displayName: name,
            role: role,
          ),
        );
      }
    });

    /// Ana proposes "Sacar la basura" on Tuesdays and Thursdays; Leo approves.
    Future<Task> scheduledMission() async {
      final proposed = await endpoints.task.proposeTask(
        sessionOf(_anaAuthUserId),
        'Sacar la basura',
        '',
        5,
        weekdays: [4, 2, 2],
      );
      return endpoints.task.voteTaskProposal(
        sessionOf(_leoAuthUserId),
        proposed.id!,
        true,
      );
    }

    Future<List<Task>> spawned() => Task.db.find(
      session,
      where: (t) => t.groupId.equals(groupId) & t.missionId.notEquals(null),
    );

    test('then the proposal is a mission with its days, voted once', () async {
      final proposed = await endpoints.task.proposeTask(
        sessionOf(_anaAuthUserId),
        'Sacar la basura',
        '',
        5,
        weekdays: [4, 2, 2],
      );

      expect(proposed.kind, TaskKind.mission);
      expect(proposed.weekdays, [2, 4]);
      expect(proposed.status, TaskStatus.proposed);
    });

    test('then days outside Monday to Sunday are refused', () async {
      await expectLater(
        endpoints.task.proposeTask(
          sessionOf(_anaAuthUserId),
          'Sacar la basura',
          '',
          5,
          weekdays: [8],
        ),
        throwsA(
          isA<TaskException>().having(
            (e) => e.reason,
            'reason',
            TaskErrorReason.invalidSchedule,
          ),
        ),
      );
    });

    test('then once approved it is scheduled, not claimable', () async {
      final mission = await scheduledMission();

      expect(mission.status, TaskStatus.scheduled);
    });

    test(
      'then on one of its days it puts one open task on the board',
      () async {
        final mission = await scheduledMission();

        await missions.spawnDue(session, groupId: groupId, now: _tuesday);
        await missions.spawnDue(session, groupId: groupId, now: _tuesday);

        final tasks = await spawned();
        expect(tasks, hasLength(1));
        expect(tasks.single.status, TaskStatus.open);
        expect(tasks.single.missionId, mission.id);
        expect(tasks.single.title, 'Sacar la basura');
        expect(tasks.single.kind, TaskKind.oneOff);
      },
    );

    test('then on a day that is not its own nothing appears', () async {
      await scheduledMission();

      await missions.spawnDue(session, groupId: groupId, now: _wednesday);

      expect(await spawned(), isEmpty);
    });

    test('then an undone repetition does not pile up', () async {
      await scheduledMission();
      await missions.spawnDue(session, groupId: groupId, now: _tuesday);

      await missions.spawnDue(session, groupId: groupId, now: _nextTuesday);

      expect(await spawned(), hasLength(1));
    });

    test(
      'then once the last one is done, the next day brings a new one',
      () async {
        await scheduledMission();
        await missions.spawnDue(session, groupId: groupId, now: _tuesday);
        final first = (await spawned()).single;
        await endpoints.task.markTaskDone(sessionOf(_leoAuthUserId), first.id!);
        final validated = await endpoints.task.voteTaskCompletion(
          sessionOf(_anaAuthUserId),
          first.id!,
          true,
        );
        expect(validated.status, TaskStatus.done);

        await missions.spawnDue(session, groupId: groupId, now: _nextTuesday);

        expect(await spawned(), hasLength(2));
      },
    );

    test('then stopping it ends the repetitions', () async {
      final mission = await scheduledMission();

      final stopped = await endpoints.task.withdrawTask(
        sessionOf(_anaAuthUserId),
        mission.id!,
      );
      await missions.spawnDue(session, groupId: groupId, now: _tuesday);

      expect(stopped.status, TaskStatus.withdrawn);
      expect(await spawned(), isEmpty);
    });
  });
}
