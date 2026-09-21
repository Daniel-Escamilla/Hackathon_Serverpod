import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'features/auth/welcome_screen.dart';

class PrototypeApp extends StatelessWidget {
  const PrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prototipo de tareas',
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}
