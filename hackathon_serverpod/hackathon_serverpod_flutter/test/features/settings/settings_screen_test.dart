import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_flutter/data/auth_repository.dart';
import 'package:hackathon_serverpod_flutter/data/password_reset_repository.dart';
import 'package:hackathon_serverpod_flutter/features/group/group_controller.dart';
import 'package:hackathon_serverpod_flutter/features/settings/locale_controller.dart';
import 'package:hackathon_serverpod_flutter/features/settings/settings_screen.dart';
import 'package:hackathon_serverpod_flutter/features/settings/sound_preference.dart';
import 'package:hackathon_serverpod_flutter/l10n/generated/app_localizations.dart';
import 'package:hackathon_serverpod_flutter/ui/member_avatar.dart';
import 'package:hackathon_serverpod_flutter/ui/sounds.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/harness.dart';

/// A session that records signing out instead of reaching the server.
class FakeAuth extends AuthRepository {
  final _session = ValueNotifier<AuthSuccess?>(null);
  bool signedOut = false;

  @override
  ValueListenable<AuthSuccess?> get session => _session;

  @override
  Future<void> signOut() async => signedOut = true;
}

/// The three password calls, recorded instead of sent.
class FakePasswordReset extends PasswordResetRepository {
  final calls = <String>[];

  @override
  Future<UuidValue> sendCode(String email) async {
    calls.add('send $email');
    return UuidValue.fromString('00000000-0000-4000-8000-000000000003');
  }

  @override
  Future<String> verifyCode(UuidValue requestId, String code) async {
    calls.add('verify $code');
    return 'token';
  }

  @override
  Future<void> setPassword(String token, String newPassword) async {
    calls.add('set $token $newPassword');
  }
}

/// Bea is signed in; saving records what would go to the server.
class RecordingGroupController extends FakeGroupController {
  RecordingGroupController()
    : super(me: 2, members: [member(1, 'Ana'), member(2, 'Bea')]);

  final fakeAuth = FakeAuth();

  @override
  AuthRepository get auth => fakeAuth;

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
  GroupController group, {
  PasswordResetRepository passwordReset = const PasswordResetRepository(),
}) async {
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
          home: SettingsScreen(passwordReset: passwordReset),
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

    testWidgets('changing the password warns it will sign you out', (
      tester,
    ) async {
      await openSettings(tester, RecordingGroupController());

      await tapFound(tester, find.text('Cambiar contraseña'));

      expect(find.text('Cambia tu contraseña'), findsOneWidget);
      expect(
        find.textContaining('tendrás que volver a entrar'),
        findsOneWidget,
      );
      expect(find.text('Recupera tu contraseña'), findsNothing);
    });

    testWidgets(
      'finishing the password change signs out and goes back to the start',
      (tester) async {
        final group = RecordingGroupController();
        final reset = FakePasswordReset();
        await openSettings(tester, group, passwordReset: reset);

        await tapFound(tester, find.text('Cambiar contraseña'));
        await tester.enterText(find.byType(TextField), 'bea@email.com');
        await tapFound(tester, find.text('Enviar código'));
        await tester.enterText(find.byType(TextField), '123456');
        await tapFound(tester, find.text('Verificar'));
        await tester.enterText(find.byType(TextField), 'nueva-clave');
        await tapFound(tester, find.text('Cambiar contraseña'));

        expect(reset.calls, [
          'send bea@email.com',
          'verify 123456',
          'set token nueva-clave',
        ]);
        expect(group.fakeAuth.signedOut, isTrue);
        expect(find.text('Entrar con email'), findsOneWidget);
        expect(
          find.text('Contraseña cambiada. Entra con la nueva.'),
          findsOneWidget,
        );
      },
    );

    testWidgets('the sound switch mutes every sound and remembers it', (
      tester,
    ) async {
      addTearDown(() => uiSounds.muted = false);
      await openSettings(tester, RecordingGroupController());
      expect(uiSounds.muted, isFalse);

      await tapFound(tester, find.text('Sonidos de la app'));

      expect(uiSounds.muted, isTrue);
      expect(await SoundPreference.loadMuted(), isTrue);

      await tapFound(tester, find.text('Sonidos de la app'));

      expect(uiSounds.muted, isFalse);
      expect(await SoundPreference.loadMuted(), isFalse);
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
