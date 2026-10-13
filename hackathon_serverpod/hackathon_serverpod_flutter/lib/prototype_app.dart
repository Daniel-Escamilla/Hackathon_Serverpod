import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'common/auth_gate.dart';
import 'features/settings/locale_controller.dart';
import 'features/settings/theme_controller.dart';
import 'l10n/generated/app_localizations.dart';

/// Phones and small windows are unaffected — this only kicks in once the
/// window is wider than the app itself was ever designed to be.
const _maxContentWidth = 480.0;

/// Spanish is the language the app is written in (PLAN.md §8), so a phone set
/// to a language the app does not have gets Spanish, not the first in the list.
const _fallbackLocale = Locale('es');

class PrototypeApp extends StatelessWidget {
  const PrototypeApp({required this.locale, required this.theme, super.key});

  final LocaleController locale;
  final ThemeController theme;

  @override
  Widget build(BuildContext context) {
    // Above MaterialApp, so every route — including sign-in, before any
    // group exists — sees the same controller.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locale),
        ChangeNotifierProvider.value(value: theme),
      ],
      child: Consumer2<LocaleController, ThemeController>(
        builder: (context, locale, theme, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale.locale,
          localeResolutionCallback: (device, supported) => supported.firstWhere(
            (l) => l.languageCode == device?.languageCode,
            orElse: () => _fallbackLocale,
          ),
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: theme.mode,
          home: const AuthGate(),
          // On desktop/web this app would otherwise stretch full-bleed: cards,
          // buttons and text at window width. `builder` wraps every route, every
          // dialog and every bottom sheet in one place, so nothing has to opt in
          // screen by screen.
          builder: (context, child) => ColoredBox(
            color: context.palette.background,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
