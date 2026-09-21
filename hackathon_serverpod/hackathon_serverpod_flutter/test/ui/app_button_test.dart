import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/ui/app_button.dart';
import 'package:hackathon_serverpod_flutter/ui/sounds.dart';

/// Records what would have played instead of playing it.
class _RecordingSounds extends UiSounds {
  _RecordingSounds() : super.silent();

  final played = <AppSound>[];

  @override
  void play(AppSound sound) => played.add(sound);
}

void main() {
  late _RecordingSounds sounds;
  late int presses;

  setUp(() {
    sounds = _RecordingSounds();
    uiSounds = sounds;
    presses = 0;
  });

  tearDown(() {
    uiSounds = UiSounds.silent();
  });

  Future<void> pump(WidgetTester tester, AppButton button) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: button)),
    ),
  );

  testWidgets('a primary button pops and does its job', (tester) async {
    await pump(tester, AppButton(label: 'Crear', onPressed: () => presses++));

    await tester.tap(find.text('Crear'));
    await tester.pumpAndSettle();

    expect(presses, 1);
    expect(sounds.played, [AppSound.tap]);
  });

  testWidgets('a secondary button pops too', (tester) async {
    await pump(
      tester,
      AppButton(
        label: 'Entrar',
        kind: AppButtonKind.secondary,
        onPressed: () => presses++,
      ),
    );

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(sounds.played, [AppSound.tap]);
  });

  testWidgets('quiet and danger buttons stay silent', (tester) async {
    for (final kind in [AppButtonKind.quiet, AppButtonKind.danger]) {
      await pump(
        tester,
        AppButton(label: kind.name, kind: kind, onPressed: () => presses++),
      );
      await tester.tap(find.text(kind.name));
      await tester.pumpAndSettle();
    }

    expect(presses, 2);
    expect(sounds.played, isEmpty);
  });

  testWidgets('an explicit sound replaces the default one', (tester) async {
    await pump(
      tester,
      AppButton(
        label: 'Votar',
        sound: AppSound.success,
        onPressed: () => presses++,
      ),
    );

    await tester.tap(find.text('Votar'));
    await tester.pumpAndSettle();

    expect(sounds.played, [AppSound.success]);
  });

  testWidgets('a loading button ignores presses and makes no sound', (
    tester,
  ) async {
    await pump(
      tester,
      AppButton(label: 'Crear', loading: true, onPressed: () => presses++),
    );

    // The label is swapped for a spinner, so tap the button itself.
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(presses, 0);
    expect(sounds.played, isEmpty);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('a disabled button makes no sound', (tester) async {
    await pump(tester, const AppButton(label: 'Crear', onPressed: null));

    await tester.tap(find.text('Crear'));
    await tester.pump();

    expect(sounds.played, isEmpty);
  });
}
