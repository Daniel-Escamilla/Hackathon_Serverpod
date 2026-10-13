import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/features/group/group_controller.dart';
import 'package:hackathon_serverpod_flutter/features/shop/shop_controller.dart';
import 'package:hackathon_serverpod_flutter/features/shop/shop_page.dart';
import 'package:hackathon_serverpod_flutter/features/wallet/wallet_controller.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../helpers/harness.dart';

RewardItem item(int id, String title) => RewardItem(
  id: id,
  groupId: 1,
  title: title,
  description: '',
  price: 20,
  status: RewardItemStatus.active,
  createdById: 1,
);

void main() {
  testWidgets('the shop shows its rewards two to a row', (tester) async {
    tester.view
      ..physicalSize = const Size(400, 1600)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final shop = FakeShopController()
      ..hasLoaded = true
      ..rewards = [
        item(1, 'Elegir la peli'),
        item(2, 'Te cambio el turno de limpieza durante toda una semana'),
        item(3, 'Un masaje'),
      ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ShopController>.value(value: shop),
          ChangeNotifierProvider<GroupController>.value(
            value: FakeGroupController(me: 1, members: [member(1, 'Ana')]),
          ),
          ChangeNotifierProvider<WalletController>.value(
            value: FakeWalletController(),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: ShopPage()),
        ),
      ),
    );
    await tester.pump();

    double top(String text) => tester.getTopLeft(find.text(text)).dy;
    double left(String text) => tester.getTopLeft(find.text(text)).dx;
    expect(
      top('Elegir la peli'),
      top('Te cambio el turno de limpieza durante toda una semana'),
    );
    expect(
      left('Elegir la peli'),
      lessThan(left('Te cambio el turno de limpieza durante toda una semana')),
    );
    expect(top('Un masaje'), greaterThan(top('Elegir la peli')));
    expect(tester.takeException(), isNull);
  });
}
