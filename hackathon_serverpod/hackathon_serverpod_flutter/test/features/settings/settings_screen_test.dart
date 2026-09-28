import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/features/group/group_controller.dart';
import 'package:hackathon_serverpod_flutter/features/settings/locale_controller.dart';
import 'package:hackathon_serverpod_flutter/features/settings/settings_screen.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';
import 'package:hackathon_serverpod_flutter/ui/member_avatar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/harness.dart';

/// Bea is signed in; saving records what would go to the server.
class RecordingGroupController extends FakeGroupController {
  RecordingGroupController()
    : super(me: 2, members: [member(1, 'Ana'), member(2, 'Bea')]);

  final saved = <String>[];

  @override
  Future<void> updateMyProfile({
    String? displayName,
    String? avatarEmoji,
    String? avatarColor,
  }) async {
    saved.add('$displayName $avatarEmoji $avatarColor');
  }
}

/// The settings screen under a MaterialApp that follows the language
/// controller, as the real app's does.
Future<LocaleController> openSettings(
  WidgetTester tester,
  GroupController group,
) async {
  SharedPreferences.setMockInitialValues({});
  final locale = await LocaleController.load();
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GroupController>.value(value: group),
        ChangeNotifierProvider<LocaleController>.value(value: locale),
      ],
      child: Consumer<LocaleController>(
        builder: (context, locale, _) => MaterialApp(
          locale: locale.locale ?? const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsScreen(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return locale;
}

/// Scrolls the settings list until [finder] is built and on screen, lets the
/// scroll finish, then taps it. The list builds lazily, so the rows at the
/// bottom do not exist until scrolled to, and typing in the name field
/// scrolls on its own: tapping mid-scroll would miss.
Future<void> tapFound(WidgetTester tester, Finder finder) async {
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  group('settings', () {
    testWidgets('starts from the signed-in member\'s current name', (
      tester,
    ) async {
      await openSettings(tester, RecordingGroupController());

      expect(find.widgetWithText(TextField, 'Bea'), findsOneWidget);
    });

    testWidgets('saves the emoji, colour and name picked', (tester) async {
      final group = RecordingGroupController();
      await openSettings(tester, group);

      await tapFound(tester, find.text('🦊'));
      await tapFound(tester, find.bySemanticsLabel('Lima'));
      await tester.enterText(find.byType(TextField), '  Beatriz ');
      await tapFound(tester, find.text('Guardar perfil'));

      expect(group.saved, ['Beatriz 🦊 lime']);
      expect(find.text('Perfil guardado'), findsOneWidget);
    });

    testWidgets('a blank name is not sent', (tester) async {
      final group = RecordingGroupController();
      await openSettings(tester, group);

      await tester.enterText(find.byType(TextField), '   ');
      await tapFound(tester, find.text('Guardar perfil'));

      expect(group.saved, isEmpty);
      expect(find.text('Escribe un nombre.'), findsOneWidget);
    });

    testWidgets('changing the password opens the code-by-email steps', (
      tester,
    ) async {
      await openSettings(tester, RecordingGroupController());

      await tapFound(tester, find.text('Cambiar contraseña'));

      expect(find.text('Recupera tu contraseña'), findsOneWidget);
    });

    testWidgets('picking English switches the app and remembers it', (
      tester,
    ) async {
      final locale = await openSettings(tester, RecordingGroupController());

      await tapFound(tester, find.text('English'));

      expect(locale.locale, const Locale('en'));
      // A row next to the one tapped: the title has scrolled off by now.
      expect(find.text("The phone's language"), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_locale'), 'en');
    });
  });

  group('language preference', () {
    test('follows the phone until something is picked', () async {
      SharedPreferences.setMockInitialValues({});
      final locale = await LocaleController.load();

      expect(locale.locale, isNull);
    });

    test(
      'a pick survives a restart, and going back to the phone forgets it',
      () async {
        SharedPreferences.setMockInitialValues({});
        await (await LocaleController.load()).setLocale(const Locale('en'));

        final reloaded = await LocaleController.load();
        expect(reloaded.locale, const Locale('en'));

        await reloaded.setLocale(null);
        expect((await LocaleController.load()).locale, isNull);
      },
    );
  });

  group('avatar', () {
    Future<void> pumpAvatar(WidgetTester tester, MemberAvatar avatar) =>
        tester.pumpWidget(MaterialApp(home: Scaffold(body: avatar)));

    testWidgets('shows the initial until an emoji is picked', (tester) async {
      await pumpAvatar(tester, const MemberAvatar(name: 'bea'));

      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('shows the emoji once one is picked', (tester) async {
      await pumpAvatar(
        tester,
        const MemberAvatar(name: 'bea', emoji: '🦊', color: 'lime'),
      );

      expect(find.text('🦊'), findsOneWidget);
      expect(find.text('B'), findsNothing);
    });
  });
}
