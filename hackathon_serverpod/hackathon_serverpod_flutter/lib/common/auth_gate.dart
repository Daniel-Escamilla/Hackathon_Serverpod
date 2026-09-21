import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../features/auth/welcome_screen.dart';
import 'group_gate.dart';

/// Root of the navigation stack. Rebuilds whenever the session's sign-in
/// state changes, so signing in or out anywhere in the app routes here
/// automatically instead of every screen managing its own redirect.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: client.auth.authInfoListenable,
      builder: (context, authInfo, _) {
        if (authInfo == null) return const WelcomeScreen();
        return const GroupGate();
      },
    );
  }
}
