import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'client.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'theme.dart';
import 'ui/sounds.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  // Loaded before the first frame so the very first tap already has its pop.
  // Never throws: without audio the app just stays quiet.
  final sounds = await UiSounds.load();
  runApp(
    ProviderScope(
      overrides: [uiSoundsProvider.overrideWithValue(sounds)],
      child: const HackathonApp(),
    ),
  );
}

/// The real app: it signs in against Serverpod and reads its data from the
/// server. `prototype_app.dart` stays in the repository as the design
/// reference it was built to be — it holds no live data and is not wired up
/// here on purpose.
class HackathonApp extends StatelessWidget {
  const HackathonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: buildAppTheme(),
      home: const SignInScreen(child: HomeScreen()),
    );
  }
}
