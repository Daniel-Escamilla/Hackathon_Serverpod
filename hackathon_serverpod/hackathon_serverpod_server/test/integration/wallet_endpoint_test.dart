import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:hackathon_serverpod_server/src/wallet/wallet_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given a group with two members', (sessionBuilder, endpoints) {
    final session = sessionBuilder.build();
    const walletService = WalletService();

    const aliceAuthUserId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
    const bobAuthUserId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';

    late Group householdGroup;
    late GroupMember alice;
    late GroupMember bob;

    setUp(() async {
      householdGroup = await Group.db.insertRow(
        session,
        Group(
          name: 'Piso de prueba',
          type: GroupType.sharedFlat,
          inviteCode: 'TEST01',
        ),
      );
      alice = await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: householdGroup.id!,
          authUserId: UuidValue.fromString(aliceAuthUserId),
          displayName: 'Alice',
          role: GroupMemberRole.admin,
        ),
      );
      bob = await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: householdGroup.id!,
          authUserId: UuidValue.fromString(bobAuthUserId),
          displayName: 'Bob',
          role: GroupMemberRole.member,
        ),
      );
    });

    group('when recording a transaction', () {
      test('then it updates the balance and inserts one history row', () async {
        await walletService.recordTransaction(
          session,
          groupId: householdGroup.id!,
          memberId: alice.id!,
          amount: 10,
          reason: CoinTransactionReason.earned,
        );

        final updated = await GroupMember.db.findById(session, alice.id!);
        expect(updated!.balance, 10);

        final history = await CoinTransaction.db.find(
          session,
          where: (t) => t.memberId.equals(alice.id!),
        );
        expect(history, hasLength(1));
        expect(history.single.amount, 10);
        expect(history.single.reason, CoinTransactionReason.earned);
      });

      test('then a fine can take the balance negative', () async {
        await walletService.recordTransaction(
          session,
          groupId: householdGroup.id!,
          memberId: alice.id!,
          amount: -5,
          reason: CoinTransactionReason.fined,
        );

        final updated = await GroupMember.db.findById(session, alice.id!);
        expect(updated!.balance, -5);
      });
    });

    group('when the signed-in member checks their wallet', () {
      test(
        'then getBalance returns their own balance, not another member\'s',
        () async {
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: 30,
            reason: CoinTransactionReason.earned,
          );
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: bob.id!,
            amount: 5,
            reason: CoinTransactionReason.earned,
          );

          final authedAsAlice = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              aliceAuthUserId,
              {},
            ),
          );

          final balance = await endpoints.wallet.getBalance(authedAsAlice);
          expect(balance, 30);
        },
      );

      test(
        'then getHistory returns their own movements, most recent first',
        () async {
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: 10,
            reason: CoinTransactionReason.earned,
          );
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: -3,
            reason: CoinTransactionReason.fined,
          );

          final authedAsAlice = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              aliceAuthUserId,
              {},
            ),
          );

          final history = await endpoints.wallet.getHistory(
            authedAsAlice,
            limit: 50,
            offset: 0,
          );
          expect(history, hasLength(2));
          expect(history.first.reason, CoinTransactionReason.fined);
          expect(history.last.reason, CoinTransactionReason.earned);
        },
      );

      test(
        'then each movement carries the title of the task or reward behind it',
        () async {
          final task = await Task.db.insertRow(
            session,
            Task(
              groupId: householdGroup.id!,
              title: 'Limpiar el baño',
              description: '',
              reward: 20,
              proposedById: bob.id!,
            ),
          );
          final reward = await RewardItem.db.insertRow(
            session,
            RewardItem(
              groupId: householdGroup.id!,
              title: 'Elijo yo la serie esta noche',
              description: '',
              price: 20,
              status: RewardItemStatus.active,
              createdById: bob.id!,
            ),
          );
          final purchase = await Purchase.db.insertRow(
            session,
            Purchase(
              groupId: householdGroup.id!,
              itemId: reward.id!,
              buyerId: alice.id!,
              providerId: bob.id!,
            ),
          );

          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: 20,
            reason: CoinTransactionReason.earned,
            taskId: task.id,
          );
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: -20,
            reason: CoinTransactionReason.spent,
            purchaseId: purchase.id,
          );
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: -3,
            reason: CoinTransactionReason.fined,
          );

          final history = await endpoints.wallet.getHistory(
            sessionBuilder.copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                aliceAuthUserId,
                {},
              ),
            ),
            limit: 50,
            offset: 0,
          );

          expect(history.map((m) => m.title), [
            // Most recent first. A fine that points at nothing has no title.
            null,
            'Elijo yo la serie esta noche',
            'Limpiar el baño',
          ]);
        },
      );
    });

    group('when computing the weekly ranking', () {
      test(
        'then it nets earned minus fined and excludes spent',
        () async {
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: 20,
            reason: CoinTransactionReason.earned,
          );
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: -5,
            reason: CoinTransactionReason.fined,
          );
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: -100,
            reason: CoinTransactionReason.spent,
          );
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: bob.id!,
            amount: 8,
            reason: CoinTransactionReason.earned,
          );

          final authedAsAlice = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              aliceAuthUserId,
              {},
            ),
          );

          final ranking = await endpoints.wallet.getWeeklyRanking(
            authedAsAlice,
          );
          expect(ranking, hasLength(2));
          expect(ranking.first.memberId, alice.id);
          expect(ranking.first.netCoins, 15);
          expect(
            ranking.firstWhere((r) => r.memberId == bob.id).netCoins,
            8,
          );
        },
      );

      test(
        "then it also nets the task cycle's specific fine reasons "
        '(proposalDenied, validationDenied, voteExpired)',
        () async {
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: 20,
            reason: CoinTransactionReason.earned,
          );
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: -3,
            reason: CoinTransactionReason.proposalDenied,
          );
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: -4,
            reason: CoinTransactionReason.validationDenied,
          );
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: alice.id!,
            amount: -5,
            reason: CoinTransactionReason.voteExpired,
          );

          final authedAsAlice = sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              aliceAuthUserId,
              {},
            ),
          );

          final ranking = await endpoints.wallet.getWeeklyRanking(
            authedAsAlice,
          );
          final aliceRanking = ranking.firstWhere(
            (r) => r.memberId == alice.id,
          );
          expect(aliceRanking.netCoins, 8); // 20 - 3 - 4 - 5
        },
      );
    });
  });
}
