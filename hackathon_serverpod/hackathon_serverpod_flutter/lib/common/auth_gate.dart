import 'package:flutter/material.dart';

import '../data/auth_repository.dart';
import '../features/auth/welcome_screen.dart';
import 'group_gate.dart';

/// Root of the navigation stack. Rebuilds whenever the session's sign-in
/// state changes, so signing in or out anywhere in the app routes here
/// automatically instead of every screen managing its own redirect.
class AuthGate extends StatelessWidget {
  const AuthGate({this.auth = const AuthRepository(), super.key});

  final AuthRepository auth;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: auth.session,
      builder: (context, authInfo, _) {
        if (authInfo == null) return const WelcomeScreen();
        return const GroupGate();
      },
    );
  }
}
