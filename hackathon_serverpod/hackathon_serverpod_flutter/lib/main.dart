import 'package:flutter/material.dart';

import 'client.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const HackathonApp());
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
      title: 'Tareas de casa',
      theme: buildAppTheme(),
      home: const SignInScreen(child: HomeScreen()),
    );
  }
}
