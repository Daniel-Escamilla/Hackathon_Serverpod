import 'package:flutter/material.dart';

import 'client.dart';
import 'prototype_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const PrototypeApp());
}
