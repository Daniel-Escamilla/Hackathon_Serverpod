import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/common/widgets.dart';
import 'package:hackathon_serverpod_flutter/features/activity/activity_controller.dart';
import 'package:hackathon_serverpod_flutter/features/group/group_controller.dart';
import 'package:hackathon_serverpod_flutter/home_shell.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../helpers/harness.dart';

const me = 1;
const ana = 2;

GroupEvent event(GroupEventKind kind, int actor) => GroupEvent(
  groupId: 1,
  kind: kind,
  actorMemberId: actor,
  occurredAt: DateTime.now().toUtc(),
);

void main() {
  late ActivityController activity;
  late HomeTabController tabs;

  setUp(() {
    activity = ActivityController(myMemberId: () => me);
    tabs = HomeTabController(HomeTabController.wallet);
  });

  Future<void> pumpHeader(WidgetTester tester) => tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ActivityController>.value(value: activity),
        ChangeNotifierProvider<HomeTabController>.value(value: tabs),
        ChangeNotifierProvider<GroupController>.value(
          value: FakeGroupController(
            me: me,
            members: [member(me, 'Yo'), member(ana, 'Ana')],
          ),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: PageHeader(title: 'Tareas', showBalance: false),
        ),
      ),
    ),
  );

  bool dotVisible(WidgetTester tester) =>
      tester.widget<Badge>(find.byType(Badge)).isLabelVisible;

  testWidgets('no dot without notices', (tester) async {
    await pumpHeader(tester);

    expect(dotVisible(tester), isFalse);
  });

  testWidgets("another member's notice lights the dot; mine does not", (
    tester,
  ) async {
    await pumpHeader(tester);

    activity.add(event(GroupEventKind.taskProposed, me));
    await tester.pump();
    expect(dotVisible(tester), isFalse);

    activity.add(event(GroupEventKind.taskProposed, ana));
    await tester.pump();
    expect(dotVisible(tester), isTrue);
  });

  testWidgets('opening Activity lists the notice and clears the dot', (
    tester,
  ) async {
    await pumpHeader(tester);
    activity.add(event(GroupEventKind.rewardProposed, ana));
    await tester.pump();

    await tester.tap(find.byTooltip('Actividad'));
    await tester.pumpAndSettle();

    expect(find.text('Ana ha propuesto una recompensa'), findsOneWidget);
    expect(find.text('Ahora mismo'), findsOneWidget);
    expect(activity.hasUnread, isFalse);
  });

  testWidgets('tapping a notice goes to its tab', (tester) async {
    await pumpHeader(tester);
    activity.add(event(GroupEventKind.rewardProposed, ana));
    await tester.tap(find.byTooltip('Actividad'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ana ha propuesto una recompensa'));
    await tester.pumpAndSettle();

    expect(tabs.index, HomeTabController.shop);
    expect(find.text('Ana ha propuesto una recompensa'), findsNothing);
  });

  testWidgets('with no notices Activity says what will show up', (
    tester,
  ) async {
    await pumpHeader(tester);

    await tester.tap(find.byTooltip('Actividad'));
    await tester.pumpAndSettle();

    expect(find.textContaining('lo que hagan los demás'), findsOneWidget);
  });
}
