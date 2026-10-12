import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/app_theme.dart';
import 'package:hackathon_serverpod_flutter/common/widgets.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (la > lb ? la + .05 : lb + .05) / (la > lb ? lb + .05 : la + .05);
}

Widget _inDark(Widget child) => MaterialApp(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.dark,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  test('every dark text colour reads on both greys (WCAG AA, 4.5:1)', () {
    const p = AppPalette.dark;
    for (final text in [p.ink, p.muted, p.accent, p.danger, p.positive]) {
      for (final surface in [p.background, p.card]) {
        expect(
          _contrast(text, surface),
          greaterThanOrEqualTo(4.5),
          reason: '$text on $surface',
        );
      }
    }
  });

  testWidgets('a pill on a pastel keeps dark ink in dark mode', (
    tester,
  ) async {
    await tester.pumpWidget(
      _inDark(const StatusPill(label: 'Disponible', color: AppColors.lime)),
    );

    final text = tester.widget<Text>(find.text('Disponible'));
    expect(text.style?.color, AppColors.ink);
  });

  testWidgets('a lime card in dark mode reads with the light theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      _inDark(
        SoftCard(
          color: AppColors.lime,
          child: Builder(
            builder: (context) => Text(
              'Casa',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Casa'));
    expect(text.style?.color, AppColors.ink);
  });

  testWidgets('a plain card in dark mode keeps the light text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _inDark(
        SoftCard(
          child: Builder(
            builder: (context) => Text(
              'Casa',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Casa'));
    expect(text.style?.color, AppPalette.dark.ink);
  });
}
