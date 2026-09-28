import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/data/app_failure.dart';
import 'package:hackathon_serverpod_flutter/features/group/group_controller.dart';
import 'package:hackathon_serverpod_flutter/features/group/group_settings_screen.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';

/// Records the save instead of calling the server, or fails it on demand.
class _FakeGroupController extends GroupController {
  final saved = <({String name, int finePercent})>[];
  Object? failWith;

  @override
  Future<void> updateSettings({
    required String name,
    required int finePercent,
  }) async {
    if (failWith != null) throw failWith!;
    saved.add((name: name, finePercent: finePercent));
  }
}

void main() {
  final group = Group(
    name: 'Piso de prueba',
    type: GroupType.sharedFlat,
    inviteCode: 'ABC234',
    finePercent: 20,
  );
  late _FakeGroupController controller;

  setUp(() => controller = _FakeGroupController());

  /// Opens the screen on top of a home route, so a save that pops can be seen
  /// going back to it.
  Future<void> open(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => GroupSettingsScreen(
                    group: group,
                    controller: controller,
                  ),
                ),
              ),
              child: const Text('home'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('home'));
    await tester.pumpAndSettle();
  }

  testWidgets('starts from the group current name and fine', (tester) async {
    await open(tester);

    expect(find.widgetWithText(TextField, 'Piso de prueba'), findsOneWidget);
    expect(find.text('20 %'), findsOneWidget);
  });

  testWidgets('saves the trimmed name and the fine, then goes back', (
    tester,
  ) async {
    await open(tester);

    await tester.enterText(find.byType(TextField), '  Piso nuevo  ');
    final slider = tester.widget<Slider>(find.byType(Slider));
    slider.onChanged!(35);
    await tester.pump();
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(controller.saved, [(name: 'Piso nuevo', finePercent: 35)]);
    expect(find.byType(GroupSettingsScreen), findsNothing);
    expect(find.text('Configuración guardada.'), findsOneWidget);
  });

  testWidgets('a blank name is refused without calling the server', (
    tester,
  ) async {
    await open(tester);

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(controller.saved, isEmpty);
    expect(find.text('Ponle un nombre al grupo.'), findsOneWidget);
    expect(find.byType(GroupSettingsScreen), findsOneWidget);
  });

  testWidgets('a refusal from the server stays on the screen and says why', (
    tester,
  ) async {
    controller.failWith = const AppException(AppFailure.notAdmin);
    await open(tester);

    await tester.tap(find.text('Guardar cambios'));
    await tester.pumpAndSettle();

    expect(find.byType(GroupSettingsScreen), findsOneWidget);
    final l10n = await AppLocalizations.delegate.load(const Locale('es'));
    expect(find.text(l10n.errorNotAdmin), findsOneWidget);
  });
}
