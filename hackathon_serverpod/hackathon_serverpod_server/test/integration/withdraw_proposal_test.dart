import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _adminAuthUserId = '0c0c0c0c-0c0c-4c0c-8c0c-0c0c0c0c0c0c';
const _proposerAuthUserId = '0d0d0d0d-0d0d-4d0d-8d0d-0d0d0d0d0d0d';
const _otherAuthUserId = '0e0e0e0e-0e0e-4e0e-8e0e-0e0e0e0e0e0e';

void main() {
  withServerpod('Given a proposal still being voted on', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();

    TestSessionBuilder sessionOf(String authUserId) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(authUserId, {}),
    );

    setUp(() async {
      final home = await Group.db.insertRow(
        session,
        Group(name: 'Piso', type: GroupType.sharedFlat, inviteCode: 'WDRW01'),
      );
      for (final (id, name, role) in [
        (_adminAuthUserId, 'Admin', GroupMemberRole.admin),
        (_proposerAuthUserId, 'Autora', GroupMemberRole.member),
        (_otherAuthUserId, 'Otra', GroupMemberRole.member),
      ]) {
        await GroupMember.db.insertRow(
          session,
          GroupMember(
            groupId: home.id!,
            authUserId: UuidValue.fromString(id),
            displayName: name,
            role: role,
          ),
        );
      }
    });

    Future<Task> propose() => endpoints.task.proposeTask(
      sessionOf(_proposerAuthUserId),
      'Ordenar el trastero',
      '',
      10,
    );

    test('then its proposer withdraws the task, with no fine', () async {
      final task = await propose();

      final withdrawn = await endpoints.task.withdrawTask(
        sessionOf(_proposerAuthUserId),
        task.id!,
      );

      expect(withdrawn.status, TaskStatus.withdrawn);
      expect(withdrawn.voteClosesAt, isNull);
      expect(
        await endpoints.wallet.getBalance(sessionOf(_proposerAuthUserId)),
        0,
      );
    });

    test('then a task with a counter-offer waiting can be withdrawn', () async {
      final task = await propose();
      await endpoints.task.counterOfferTask(
        sessionOf(_otherAuthUserId),
        task.id!,
        5,
      );

      final withdrawn = await endpoints.task.withdrawTask(
        sessionOf(_proposerAuthUserId),
        task.id!,
      );

      expect(withdrawn.status, TaskStatus.withdrawn);
    });

    test('then the admin withdraws someone else\'s task', () async {
      final task = await propose();

      final withdrawn = await endpoints.task.withdrawTask(
        sessionOf(_adminAuthUserId),
        task.id!,
      );

      expect(withdrawn.status, TaskStatus.withdrawn);
    });

    test('then another member cannot withdraw it', () async {
      final task = await propose();

      await expectLater(
        endpoints.task.withdrawTask(sessionOf(_otherAuthUserId), task.id!),
        throwsA(
          isA<TaskException>().having(
            (e) => e.reason,
            'reason',
            TaskErrorReason.notProposer,
          ),
        ),
      );
    });

    test('then a task already open cannot be withdrawn', () async {
      final task = await propose();
      await endpoints.task.voteTaskProposal(
        sessionOf(_otherAuthUserId),
        task.id!,
        true,
      );

      await expectLater(
        endpoints.task.withdrawTask(sessionOf(_proposerAuthUserId), task.id!),
        throwsA(
          isA<TaskException>().having(
            (e) => e.reason,
            'reason',
            TaskErrorReason.notOpen,
          ),
        ),
      );
    });

    test('then its proposer withdraws a reward, and it is gone', () async {
      final proposer = sessionOf(_proposerAuthUserId);
      final reward = await endpoints.shop.proposeReward(
        proposer,
        'Un masaje',
        '',
        50,
      );
      await endpoints.shop.voteReward(
        sessionOf(_otherAuthUserId),
        reward.id!,
        false,
      );

      await endpoints.shop.withdrawReward(proposer, reward.id!);

      expect(await RewardItem.db.findById(session, reward.id!), isNull);
      expect(
        await RewardVote.db.count(
          session,
          where: (t) => t.itemId.equals(reward.id!),
        ),
        0,
      );
    });

    test('then another member cannot withdraw a reward', () async {
      final reward = await endpoints.shop.proposeReward(
        sessionOf(_proposerAuthUserId),
        'Un masaje',
        '',
        50,
      );

      await expectLater(
        endpoints.shop.withdrawReward(sessionOf(_otherAuthUserId), reward.id!),
        throwsA(
          isA<ShopException>().having(
            (e) => e.reason,
            'reason',
            ShopErrorReason.notProposer,
          ),
        ),
      );
    });
  });
}
