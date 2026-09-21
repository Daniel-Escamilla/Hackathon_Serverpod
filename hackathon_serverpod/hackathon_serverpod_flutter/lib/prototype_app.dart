import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'common/auth_gate.dart';
import 'l10n/generated/app_localizations.dart';

/// Phones and small windows are unaffected — this only kicks in once the
/// window is wider than the app itself was ever designed to be.
const _maxContentWidth = 480.0;

class PrototypeApp extends StatelessWidget {
  const PrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      home: const AuthGate(),
      // On desktop/web this app would otherwise stretch full-bleed: cards,
      // buttons and text at window width. `builder` wraps every route, every
      // dialog and every bottom sheet in one place, so nothing has to opt in
      // screen by screen.
      builder: (context, child) => ColoredBox(
        color: AppColors.cream,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxContentWidth),
            child: child,
          ),
        ),
      ),
    );
  }
}
