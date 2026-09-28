import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';
import 'package:hackathon_serverpod_flutter/ui/password_field.dart';

void main() {
  late TextEditingController controller;

  setUp(() => controller = TextEditingController(text: 'secreto'));
  tearDown(() => controller.dispose());

  Future<void> pump(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: PasswordField(controller: controller)),
    ),
  );

  bool obscured(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField)).obscureText;

  testWidgets('starts hidden and the eye toggles it', (tester) async {
    await pump(tester);
    expect(obscured(tester), isTrue);
    expect(find.byTooltip('Mostrar contraseña'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_rounded));
    await tester.pump();
    expect(obscured(tester), isFalse);
    expect(find.byTooltip('Ocultar contraseña'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_rounded));
    await tester.pump();
    expect(obscured(tester), isTrue);
  });
}
