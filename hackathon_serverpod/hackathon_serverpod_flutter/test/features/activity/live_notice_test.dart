import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/features/activity/live_notice.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';

import '../../helpers/harness.dart';

void main() {
  Future<BuildContext> pumpScaffold(WidgetTester tester) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (c) {
              context = c;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    return context;
  }

  GroupEvent claimedBy(int actor) => GroupEvent(
    groupId: 1,
    kind: GroupEventKind.taskClaimed,
    actorMemberId: actor,
    occurredAt: DateTime.now().toUtc(),
  );

  testWidgets("another member's action shows up at once, by name", (
    tester,
  ) async {
    final context = await pumpScaffold(tester);

    showLiveNotice(context, claimedBy(2), [member(2, 'Ana')]);
    await tester.pump();

    expect(find.text('Ana dice que ha hecho una tarea'), findsOneWidget);
  });

  testWidgets('an unknown member reads as someone', (tester) async {
    final context = await pumpScaffold(tester);

    showLiveNotice(context, claimedBy(9), const []);
    await tester.pump();

    expect(find.text('Alguien dice que ha hecho una tarea'), findsOneWidget);
  });
}
