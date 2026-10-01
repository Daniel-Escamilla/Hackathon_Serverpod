import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:hackathon_serverpod_server/src/wallet/wallet_service.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  // The stream's own lookup runs alongside the call that publishes, and
  // concurrent database calls need rollback disabled, so every test builds
  // its own group with its own people (see event_endpoint_test.dart).
  withServerpod(
    'Given a couple watching their group live',
    (sessionBuilder, endpoints) {
      final session = sessionBuilder.build();
      const walletService = WalletService();
      var run = 0;

      TestSessionBuilder sessionOf(String authUserId) =>
          sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authUserId,
              {},
            ),
          );

      /// A new couple per test: two fresh auth user ids, a group, and 50
      /// coins for the second one so they can buy.
      Future<
        ({
          TestSessionBuilder ana,
          TestSessionBuilder bea,
          GroupMember anaMember,
          GroupMember beaMember,
        })
      >
      couple() async {
        run++;
        final n = run.toString().padLeft(2, '0');
        final ana = sessionOf('5a5a5a5a-5a5a-4a5a-8a5a-5a5a5a5a5a$n');
        final bea = sessionOf('5b5b5b5b-5b5b-4b5b-8b5b-5b5b5b5b5b$n');
        final group = await endpoints.group.createGroup(
          ana,
          'Pareja $n',
          GroupType.couple,
          displayName: 'Ana',
        );
        await endpoints.group.joinGroup(
          bea,
          group.inviteCode,
          displayName: 'Bea',
        );
        final members = await endpoints.group.listMembers(ana);
        final anaMember = members.firstWhere((m) => m.displayName == 'Ana');
        final beaMember = members.firstWhere((m) => m.displayName == 'Bea');
        await walletService.recordTransaction(
          session,
          groupId: group.id!,
          memberId: beaMember.id!,
          amount: 50,
          reason: CoinTransactionReason.earned,
        );
        return (
          ana: ana,
          bea: bea,
          anaMember: anaMember,
          beaMember: beaMember,
        );
      }

      /// Bea buys an active reward that Ana has to fulfil.
      Future<Purchase> beaBuysFromAna(
        ({
          TestSessionBuilder ana,
          TestSessionBuilder bea,
          GroupMember anaMember,
          GroupMember beaMember,
        })
        c,
      ) async {
        final reward = await endpoints.shop.proposeReward(
          c.bea,
          'Elegir la peli',
          'Esta noche',
          10,
        );
        await endpoints.shop.voteReward(c.ana, reward.id!, true);
        return endpoints.shop.purchaseReward(
          c.bea,
          reward.id!,
          c.anaMember.id!,
        );
      }

      test('when a reward is proposed then the other one hears it', () async {
        final c = await couple();
        final stream = endpoints.event.watchGroup(c.ana);
        await flushEventQueue();

        final reward = await endpoints.shop.proposeReward(
          c.bea,
          'Desayuno en la cama',
          '',
          15,
        );

        final event = await stream.first;
        expect(event.kind, GroupEventKind.rewardProposed);
        expect(event.rewardId, reward.id);
        expect(event.actorMemberId, c.beaMember.id);
      });

      test('when a reward is voted then the proposer hears it', () async {
        final c = await couple();
        final reward = await endpoints.shop.proposeReward(
          c.bea,
          'Desayuno en la cama',
          '',
          15,
        );
        final stream = endpoints.event.watchGroup(c.bea);
        await flushEventQueue();

        await endpoints.shop.voteReward(c.ana, reward.id!, true);

        final event = await stream.first;
        expect(event.kind, GroupEventKind.rewardVoteCast);
        expect(event.rewardId, reward.id);
        expect(event.actorMemberId, c.anaMember.id);
      });

      test('when a purchase is accepted then the buyer hears it', () async {
        final c = await couple();
        final purchase = await beaBuysFromAna(c);
        final stream = endpoints.event.watchGroup(c.bea);
        await flushEventQueue();

        await endpoints.shop.respondToPurchase(c.ana, purchase.id!, true);

        final event = await stream.first;
        expect(event.kind, GroupEventKind.purchaseResponded);
        expect(event.purchaseId, purchase.id);
        expect(event.actorMemberId, c.anaMember.id);
      });

      test('when a purchase is refused then the buyer hears it too', () async {
        final c = await couple();
        final purchase = await beaBuysFromAna(c);
        final stream = endpoints.event.watchGroup(c.bea);
        await flushEventQueue();

        await endpoints.shop.respondToPurchase(c.ana, purchase.id!, false);

        final event = await stream.first;
        expect(event.kind, GroupEventKind.purchaseResponded);
        expect(event.purchaseId, purchase.id);
        expect(event.actorMemberId, c.anaMember.id);
      });

      test('when a purchase is delivered then the buyer hears it', () async {
        final c = await couple();
        final purchase = await beaBuysFromAna(c);
        await endpoints.shop.respondToPurchase(c.ana, purchase.id!, true);
        final stream = endpoints.event.watchGroup(c.bea);
        await flushEventQueue();

        await endpoints.shop.markDelivered(c.ana, purchase.id!);

        final event = await stream.first;
        expect(event.kind, GroupEventKind.purchaseDelivered);
        expect(event.purchaseId, purchase.id);
        expect(event.actorMemberId, c.anaMember.id);
      });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
