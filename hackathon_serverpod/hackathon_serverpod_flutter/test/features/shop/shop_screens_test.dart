import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/features/shop/buy_reward_screen.dart';
import 'package:hackathon_serverpod_flutter/features/shop/purchase_screen.dart';
import 'package:hackathon_serverpod_flutter/features/shop/reward_vote_screen.dart';

import '../../helpers/harness.dart';

final reward = RewardItem(
  id: 4,
  groupId: 1,
  title: 'Elegir la peli',
  description: 'Esta noche',
  price: 15,
  status: RewardItemStatus.active,
  createdById: 1,
);

Purchase purchase(PurchaseStatus status) => Purchase(
  id: 9,
  groupId: 1,
  itemId: reward.id!,
  buyerId: 1,
  providerId: 2,
  status: status,
);

void main() {
  late FakeShopController shop;
  late FakeGroupController members;

  setUp(() {
    shop = FakeShopController()..rewards = [reward];
    members = FakeGroupController(
      me: 2,
      members: [member(1, 'Ana'), member(2, 'Bea'), member(3, 'Carla')],
    );
  });

  group('reward vote', () {
    testWidgets('approving votes yes and goes back', (tester) async {
      await openScreen(tester, RewardVoteScreen(reward: reward), shop: shop);

      await tapLabel(tester, 'Aprobar recompensa');

      expect(shop.calls, ['vote 4 true']);
      expect(find.text('pestaña'), findsOneWidget);
    });
  });

  group('buying', () {
    testWidgets('only the other members can be chosen to fulfil it', (
      tester,
    ) async {
      await openScreen(
        tester,
        BuyRewardScreen(reward: reward),
        shop: shop,
        group: members,
      );

      expect(find.text('Ana'), findsOneWidget);
      expect(find.text('Carla'), findsOneWidget);
      expect(find.text('Bea'), findsNothing);
    });

    testWidgets('it buys from the member picked', (tester) async {
      await openScreen(
        tester,
        BuyRewardScreen(reward: reward),
        shop: shop,
        group: members,
      );

      await tapLabel(tester, 'Carla');
      await tapLabel(tester, '15 monedas');

      expect(shop.calls, ['buy 4 from 3']);
      expect(find.text('🎁'), findsOneWidget);
    });

    testWidgets('a negative balance says why it cannot buy', (tester) async {
      shop.failWith = ShopException(reason: ShopErrorReason.negativeBalance);
      await openScreen(
        tester,
        BuyRewardScreen(reward: reward),
        shop: shop,
        group: members,
      );

      await tapLabel(tester, 'Carla');
      await tapLabel(tester, '15 monedas');

      expect(
        find.text('Con saldo negativo no se puede comprar.'),
        findsOneWidget,
      );
    });
  });

  group('a purchase, seen by whoever fulfils it', () {
    testWidgets('names the reward, the buyer and the provider', (
      tester,
    ) async {
      await openScreen(
        tester,
        PurchaseScreen(
          purchase: purchase(PurchaseStatus.pending),
          myMemberId: 2,
        ),
        shop: shop,
        group: members,
      );

      expect(find.text('Elegir la peli'), findsOneWidget);
      expect(find.text('La compró Ana'), findsOneWidget);
      expect(find.text('Le toca cumplirla a Bea'), findsOneWidget);
    });

    testWidgets('accepting it answers yes and goes back', (tester) async {
      await openScreen(
        tester,
        PurchaseScreen(
          purchase: purchase(PurchaseStatus.pending),
          myMemberId: 2,
        ),
        shop: shop,
        group: members,
      );

      await tapLabel(tester, 'Aceptar');

      expect(shop.calls, ['respond 9 true']);
      expect(find.text('pestaña'), findsOneWidget);
    });

    testWidgets('refusing asks first, since it costs a fine', (tester) async {
      await openScreen(
        tester,
        PurchaseScreen(
          purchase: purchase(PurchaseStatus.pending),
          myMemberId: 2,
        ),
        shop: shop,
        group: members,
      );

      await tapLabel(tester, 'Negarme');
      expect(find.text('¿Negarte a cumplirla?'), findsOneWidget);
      expect(shop.calls, isEmpty);

      await tapLabel(tester, 'Negarme');
      expect(shop.calls, ['respond 9 false']);
    });

    testWidgets('once accepted, the only step left is delivering it', (
      tester,
    ) async {
      await openScreen(
        tester,
        PurchaseScreen(
          purchase: purchase(PurchaseStatus.accepted),
          myMemberId: 2,
        ),
        shop: shop,
        group: members,
      );

      expect(find.text('Aceptar'), findsNothing);
      await tapLabel(tester, 'Marcar como entregada');

      expect(shop.calls, ['delivered 9']);
    });

    testWidgets('a refused answer from the server stays on the screen', (
      tester,
    ) async {
      shop.failWith = Exception('boom');
      await openScreen(
        tester,
        PurchaseScreen(
          purchase: purchase(PurchaseStatus.pending),
          myMemberId: 2,
        ),
        shop: shop,
        group: members,
      );

      await tapLabel(tester, 'Aceptar');

      expect(find.text('Algo ha fallado. Inténtalo otra vez.'), findsOneWidget);
      expect(find.text('Elegir la peli'), findsOneWidget);
    });
  });

  testWidgets('the buyer only follows it: no buttons', (tester) async {
    await openScreen(
      tester,
      PurchaseScreen(purchase: purchase(PurchaseStatus.pending), myMemberId: 1),
      shop: shop,
      group: members,
    );

    expect(find.text('Por aceptar'), findsOneWidget);
    expect(find.text('Aceptar'), findsNothing);
    expect(find.text('Negarme'), findsNothing);
    expect(find.text('Marcar como entregada'), findsNothing);
  });
}
