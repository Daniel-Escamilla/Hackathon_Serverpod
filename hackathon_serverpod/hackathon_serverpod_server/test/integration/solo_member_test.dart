import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _soloAuthUserId = '0a0a0a0a-0a0a-4a0a-8a0a-0a0a0a0a0a0a';
const _guestAuthUserId = '0b0b0b0b-0b0b-4b0b-8b0b-0b0b0b0b0b0b';

void main() {
  withServerpod('Given a home with a single member', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    late Group home;

    TestSessionBuilder sessionOf(String authUserId) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(authUserId, {}),
    );

    setUp(() async {
      home = await Group.db.insertRow(
        session,
        Group(
          name: 'Estudio',
          type: GroupType.sharedFlat,
          inviteCode: 'SOLO01',
        ),
      );
      await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: home.id!,
          authUserId: UuidValue.fromString(_soloAuthUserId),
          displayName: 'Sola',
          role: GroupMemberRole.admin,
        ),
      );
    });

    test('then a proposed task opens at once, with no vote', () async {
      final task = await endpoints.task.proposeTask(
        sessionOf(_soloAuthUserId),
        'Regar las plantas',
        '',
        5,
      );

      expect(task.status, TaskStatus.open);
      expect(task.voteClosesAt, isNull);
    });

    test('then marking a task done pays it at once', () async {
      final solo = sessionOf(_soloAuthUserId);
      final task = await endpoints.task.proposeTask(solo, 'Fregar', '', 10);

      final done = await endpoints.task.markTaskDone(solo, task.id!);

      expect(done.status, TaskStatus.done);
      expect(await endpoints.wallet.getBalance(solo), 10);
    });

    test('then a proposed reward is active at once', () async {
      final reward = await endpoints.shop.proposeReward(
        sessionOf(_soloAuthUserId),
        'Un masaje',
        '',
        50,
      );

      expect(reward.status, RewardItemStatus.active);
    });

    test('then once someone joins, proposals go to a vote again', () async {
      await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: home.id!,
          authUserId: UuidValue.fromString(_guestAuthUserId),
          displayName: 'Invitada',
          role: GroupMemberRole.member,
        ),
      );

      final task = await endpoints.task.proposeTask(
        sessionOf(_soloAuthUserId),
        'Regar las plantas',
        '',
        5,
      );

      expect(task.status, TaskStatus.proposed);
    });
  });
}
