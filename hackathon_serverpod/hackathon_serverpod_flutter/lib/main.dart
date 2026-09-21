import 'package:flutter/material.dart';

import 'client.dart';
import 'prototype_app.dart';
import 'ui/sounds.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  // Loaded before the first frame so the very first tap already has its pop.
  // Never throws: without audio the app just stays quiet (see UiSounds.load).
  uiSounds = await UiSounds.load();
  runApp(const PrototypeApp());
}
