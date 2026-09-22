import 'package:hackathon_serverpod_server/src/generated/protocol.dart';
import 'package:hackathon_serverpod_server/src/wallet/wallet_service.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

const _aliceAuthUserId = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
const _bobAuthUserId = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
const _carolAuthUserId = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc';
const _daveAuthUserId = 'dddddddd-dddd-4ddd-8ddd-dddddddddddd';
const _race1BuyerAuthUserId = '11111111-1111-4111-8111-111111111111';
const _race1ProviderAuthUserId = '12121212-1212-4212-8212-121212121212';
const _race1ThirdAuthUserId = '13131313-1313-4313-8313-131313131313';
const _race2AuthUserIds = [
  '21212121-2121-4121-8121-212121212121',
  '22222222-2222-4222-8222-222222222222',
  '23232323-2323-4323-8323-232323232323',
  '24242424-2424-4424-8424-242424242424',
  '25252525-2525-4525-8525-252525252525',
];

void main() {
  withServerpod('Given a group of four with a proposed reward', (
    sessionBuilder,
    endpoints,
  ) {
    final session = sessionBuilder.build();
    const walletService = WalletService();

    late Group householdGroup;
    late GroupMember alice;
    late GroupMember bob;
    late GroupMember carol;
    late RewardItem proposedItem;

    TestSessionBuilder sessionOf(String authUserId) => sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(authUserId, {}),
    );

    setUp(() async {
      householdGroup = await Group.db.insertRow(
        session,
        Group(
          name: 'Piso de prueba',
          type: GroupType.sharedFlat,
          inviteCode: 'SHOP01',
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
      bob = await GroupMember.db.insertRow(
        session,
        GroupMember(
          groupId: householdGroup.id!,
          authUserId: UuidValue.fromString(_bobAuthUserId),
          displayName: 'Bob',
          role: GroupMemberRole.member,
        ),
      );
      carol = await GroupMember.db.insertRow(
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
      proposedItem = await RewardItem.db.insertRow(
        session,
        RewardItem(
          groupId: householdGroup.id!,
          title: 'Elegir la peli de la noche',
          description: '',
          price: 20,
          createdById: alice.id!,
          stock: 2,
        ),
      );
    });

    group('when listing and proposing rewards', () {
      test('then listRewards returns the group shop', () async {
        final rewards = await endpoints.shop.listRewards(
          sessionOf(_bobAuthUserId),
        );

        expect(rewards.map((r) => r.id), contains(proposedItem.id));
      });

      test('then proposeReward starts a proposed reward', () async {
        final proposed = await endpoints.shop.proposeReward(
          sessionOf(_bobAuthUserId),
          'Un masaje',
          '',
          50,
        );

        expect(proposed.status, RewardItemStatus.proposed);
        expect(proposed.createdById, bob.id);
        expect(proposed.groupId, householdGroup.id);
      });
    });

    group('family mode stubs, out of MVP scope (PLAN.md §1)', () {
      test('then requestWish is unimplemented', () async {
        await expectLater(
          endpoints.shop.requestWish(sessionOf(_bobAuthUserId), 'Una PS5', ''),
          throwsA(isA<UnimplementedError>()),
        );
      });

      test('then approveChildPurchase is unimplemented', () async {
        await expectLater(
          endpoints.shop.approveChildPurchase(
            sessionOf(_bobAuthUserId),
            1,
            true,
          ),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('when voting on the proposal', () {
      test('then it activates once the majority of 3 others approve', () async {
        await endpoints.shop.voteReward(
          sessionOf(_bobAuthUserId),
          proposedItem.id!,
          true,
        );
        await endpoints.shop.voteReward(
          sessionOf(_carolAuthUserId),
          proposedItem.id!,
          true,
        );

        final updated = await RewardItem.db.findById(session, proposedItem.id!);
        expect(updated!.status, RewardItemStatus.active);
      });

      test('then it is rejected once approval becomes impossible', () async {
        await endpoints.shop.voteReward(
          sessionOf(_bobAuthUserId),
          proposedItem.id!,
          false,
        );
        await endpoints.shop.voteReward(
          sessionOf(_carolAuthUserId),
          proposedItem.id!,
          false,
        );

        final updated = await RewardItem.db.findById(session, proposedItem.id!);
        expect(updated!.status, RewardItemStatus.rejected);

        final history = await CoinTransaction.db.find(
          session,
          where: (t) => t.memberId.equals(alice.id!),
        );
        expect(history, isEmpty);
      });

      test('then the proposer cannot vote on their own reward', () async {
        await expectLater(
          endpoints.shop.voteReward(
            sessionOf(_aliceAuthUserId),
            proposedItem.id!,
            true,
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('then voting on an unknown reward throws', () async {
        await expectLater(
          endpoints.shop.voteReward(sessionOf(_bobAuthUserId), 999999, true),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('when the reward is active', () {
      setUp(() async {
        proposedItem = await RewardItem.db.updateRow(
          session,
          proposedItem.copyWith(status: RewardItemStatus.active),
        );
      });

      test('then buying it charges the buyer and decrements stock', () async {
        await walletService.recordTransaction(
          session,
          groupId: householdGroup.id!,
          memberId: bob.id!,
          amount: 50,
          reason: CoinTransactionReason.earned,
        );

        final purchase = await endpoints.shop.purchaseReward(
          sessionOf(_bobAuthUserId),
          proposedItem.id!,
          carol.id!,
        );
        expect(purchase.status, PurchaseStatus.pending);
        expect(purchase.providerId, carol.id);

        final buyer = await GroupMember.db.findById(session, bob.id!);
        expect(buyer!.balance, 30);

        final item = await RewardItem.db.findById(session, proposedItem.id!);
        expect(item!.stock, 1);
      });

      test('then buying with an unknown provider throws', () async {
        await expectLater(
          endpoints.shop.purchaseReward(
            sessionOf(_bobAuthUserId),
            proposedItem.id!,
            999999,
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('then a member with a negative balance cannot buy', () async {
        await walletService.recordTransaction(
          session,
          groupId: householdGroup.id!,
          memberId: bob.id!,
          amount: -5,
          reason: CoinTransactionReason.fined,
        );

        await expectLater(
          endpoints.shop.purchaseReward(
            sessionOf(_bobAuthUserId),
            proposedItem.id!,
            carol.id!,
          ),
          throwsA(isA<StateError>()),
        );
      });

      group('and bought', () {
        late Purchase purchase;

        setUp(() async {
          await walletService.recordTransaction(
            session,
            groupId: householdGroup.id!,
            memberId: bob.id!,
            amount: 50,
            reason: CoinTransactionReason.earned,
          );
          purchase = await endpoints.shop.purchaseReward(
            sessionOf(_bobAuthUserId),
            proposedItem.id!,
            carol.id!,
          );
        });

        test(
          'then the provider refusing fines them, refunds the buyer and restores stock',
          () async {
            await endpoints.shop.respondToPurchase(
              sessionOf(_carolAuthUserId),
              purchase.id!,
              false,
            );

            final refused = await Purchase.db.findById(session, purchase.id!);
            expect(refused!.status, PurchaseStatus.refused);

            final provider = await GroupMember.db.findById(session, carol.id!);
            expect(provider!.balance, -4); // 20% of 20, rounded up

            final buyer = await GroupMember.db.findById(session, bob.id!);
            expect(buyer!.balance, 50); // 30 + 20 refunded

            final item = await RewardItem.db.findById(
              session,
              proposedItem.id!,
            );
            expect(item!.stock, 2); // restored
          },
        );

        test('then the buyer and the provider both see it listed', () async {
          final seenByBuyer = await endpoints.shop.listPurchases(
            sessionOf(_bobAuthUserId),
          );
          final seenByProvider = await endpoints.shop.listPurchases(
            sessionOf(_carolAuthUserId),
          );
          expect(seenByBuyer.map((p) => p.id), [purchase.id]);
          expect(seenByProvider.map((p) => p.id), [purchase.id]);
        });

        test('then a member who is neither does not see it', () async {
          final seenByDave = await endpoints.shop.listPurchases(
            sessionOf(_daveAuthUserId),
          );
          expect(seenByDave, isEmpty);
        });

        test('then the most recent purchase is listed first', () async {
          final second = await endpoints.shop.purchaseReward(
            sessionOf(_bobAuthUserId),
            proposedItem.id!,
            alice.id!,
          );

          final seenByBuyer = await endpoints.shop.listPurchases(
            sessionOf(_bobAuthUserId),
          );
          expect(seenByBuyer.map((p) => p.id), [second.id, purchase.id]);
        });

        test('then someone other than the provider cannot respond', () async {
          await expectLater(
            endpoints.shop.respondToPurchase(
              sessionOf(_daveAuthUserId),
              purchase.id!,
              true,
            ),
            throwsA(isA<StateError>()),
          );
        });

        test('then accepting and delivering moves it to delivered', () async {
          await endpoints.shop.respondToPurchase(
            sessionOf(_carolAuthUserId),
            purchase.id!,
            true,
          );
          var current = await Purchase.db.findById(session, purchase.id!);
          expect(current!.status, PurchaseStatus.accepted);

          await endpoints.shop.markDelivered(
            sessionOf(_carolAuthUserId),
            purchase.id!,
          );
          current = await Purchase.db.findById(session, purchase.id!);
          expect(current!.status, PurchaseStatus.delivered);
        });

        test('then responding to an unknown purchase throws', () async {
          await expectLater(
            endpoints.shop.respondToPurchase(
              sessionOf(_carolAuthUserId),
              999999,
              true,
            ),
            throwsA(isA<StateError>()),
          );
        });

        test(
          'then someone other than the provider cannot mark it delivered',
          () async {
            await endpoints.shop.respondToPurchase(
              sessionOf(_carolAuthUserId),
              purchase.id!,
              true,
            );

            await expectLater(
              endpoints.shop.markDelivered(
                sessionOf(_daveAuthUserId),
                purchase.id!,
              ),
              throwsA(isA<StateError>()),
            );
          },
        );
      });
    });
  });

  // Real concurrent transactions need rollback disabled (serverpod-testing
  // skill); each withServerpod group gets its own database, and every test
  // here uses its own members and invite code so none sees another's rows.
  withServerpod(
    'Given a shop purchase and two requests racing on it',
    (sessionBuilder, endpoints) {
      final session = sessionBuilder.build();
      const walletService = WalletService();

      TestSessionBuilder sessionOf(String authUserId) =>
          sessionBuilder.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              authUserId,
              {},
            ),
          );

      /// A shared flat with a buyer holding 50 coins, a provider and a third
      /// member, and one active reward at 20 with 2 units.
      Future<
        ({
          Group group,
          GroupMember buyer,
          GroupMember provider,
          RewardItem item,
        })
      >
      seed({
        required String inviteCode,
        required String buyerAuthUserId,
        required String providerAuthUserId,
        required String thirdAuthUserId,
      }) async {
        final group = await Group.db.insertRow(
          session,
          Group(
            name: 'Piso de prueba',
            type: GroupType.sharedFlat,
            inviteCode: inviteCode,
          ),
        );
        GroupMember member(String authUserId, GroupMemberRole role) =>
            GroupMember(
              groupId: group.id!,
              authUserId: UuidValue.fromString(authUserId),
              displayName: authUserId.substring(0, 4),
              role: role,
            );
        final buyer = await GroupMember.db.insertRow(
          session,
          member(buyerAuthUserId, GroupMemberRole.admin),
        );
        final provider = await GroupMember.db.insertRow(
          session,
          member(providerAuthUserId, GroupMemberRole.member),
        );
        await GroupMember.db.insertRow(
          session,
          member(thirdAuthUserId, GroupMemberRole.member),
        );
        await walletService.recordTransaction(
          session,
          groupId: group.id!,
          memberId: buyer.id!,
          amount: 50,
          reason: CoinTransactionReason.earned,
        );
        final item = await RewardItem.db.insertRow(
          session,
          RewardItem(
            groupId: group.id!,
            title: 'Elegir la peli de la noche',
            description: '',
            price: 20,
            status: RewardItemStatus.active,
            createdById: buyer.id!,
            stock: 2,
          ),
        );
        return (group: group, buyer: buyer, provider: provider, item: item);
      }

      test(
        'then two simultaneous refusals fine the provider and refund the buyer only once',
        () async {
          final seeded = await seed(
            inviteCode: 'RACE01',
            buyerAuthUserId: _race1BuyerAuthUserId,
            providerAuthUserId: _race1ProviderAuthUserId,
            thirdAuthUserId: _race1ThirdAuthUserId,
          );
          final purchase = await endpoints.shop.purchaseReward(
            sessionOf(_race1BuyerAuthUserId),
            seeded.item.id!,
            seeded.provider.id!,
          );

          final outcomes = await Future.wait([
            for (var i = 0; i < 2; i++)
              endpoints.shop
                  .respondToPurchase(
                    sessionOf(_race1ProviderAuthUserId),
                    purchase.id!,
                    false,
                  )
                  .then<Object?>((_) => null, onError: (Object e) => e),
          ]);
          expect(outcomes.whereType<StateError>(), hasLength(1));

          final provider = await GroupMember.db.findById(
            session,
            seeded.provider.id!,
          );
          expect(provider!.balance, -4); // one fine: 20% of 20
          final buyer = await GroupMember.db.findById(
            session,
            seeded.buyer.id!,
          );
          expect(buyer!.balance, 50); // 50 - 20 + one refund of 20
          final item = await RewardItem.db.findById(session, seeded.item.id!);
          expect(item!.stock, 2); // restored once
        },
      );

      test(
        "then a member's double-tapped vote succeeds both times and counts once",
        () async {
          final group = await Group.db.insertRow(
            session,
            Group(
              name: 'Piso de prueba',
              type: GroupType.sharedFlat,
              inviteCode: 'RACE02',
            ),
          );
          final members = <GroupMember>[];
          for (final authUserId in _race2AuthUserIds) {
            members.add(
              await GroupMember.db.insertRow(
                session,
                GroupMember(
                  groupId: group.id!,
                  authUserId: UuidValue.fromString(authUserId),
                  displayName: authUserId.substring(0, 4),
                  role: members.isEmpty
                      ? GroupMemberRole.admin
                      : GroupMemberRole.member,
                ),
              ),
            );
          }
          // Proposer plus 4 others: ceil(4/2) = 2 approvals needed.
          final item = await RewardItem.db.insertRow(
            session,
            RewardItem(
              groupId: group.id!,
              title: 'Desayuno en la cama',
              description: '',
              price: 30,
              createdById: members.first.id!,
            ),
          );

          // Without the lock the second insert hits the unique index on
          // (itemId, memberId) and the app gets a server error.
          await Future.wait([
            for (var i = 0; i < 2; i++)
              endpoints.shop.voteReward(
                sessionOf(_race2AuthUserIds[1]),
                item.id!,
                true,
              ),
          ]);

          final votes = await RewardVote.db.find(
            session,
            where: (t) => t.itemId.equals(item.id!),
          );
          expect(votes, hasLength(1));
          final after = await RewardItem.db.findById(session, item.id!);
          expect(after!.status, RewardItemStatus.proposed);
        },
      );
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
