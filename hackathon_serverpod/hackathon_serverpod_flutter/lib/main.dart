import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'client.dart';
import 'prototype_app.dart';
import 'ui/sounds.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  // Loaded before the first frame so the very first tap already has its pop.
  // Never throws: without audio the app just stays quiet (see UiSounds.load).
  uiSounds = await UiSounds.load();
  // Flutter's default is its red error screen with a raw stack trace, shown
  // to whoever is using the app — including a judge. This builder has no
  // BuildContext to reach AppLocalizations, so the one string here is
  // hardcoded rather than pulled from the ARB, same as UiSounds.load's catch.
  ErrorWidget.builder = (details) => Directionality(
    textDirection: TextDirection.ltr,
    child: Container(
      color: AppColors.cream,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: AppColors.coral),
          SizedBox(height: 12),
          Text('Algo salió mal.', textAlign: TextAlign.center),
        ],
      ),
    ),
  );
  runApp(const PrototypeApp());
}
