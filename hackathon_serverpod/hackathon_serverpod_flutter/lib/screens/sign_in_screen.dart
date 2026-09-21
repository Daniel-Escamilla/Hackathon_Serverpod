import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../theme.dart';

/// Gates [child] behind a real Serverpod sign-in. `SignInWidget` runs the email
/// identity provider: it takes an address, mails a verification code and
/// exchanges it for a session. In development the code is printed to the server
/// console, so this is testable without any mail setup.
class SignInScreen extends StatefulWidget {
  final Widget child;
  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    setState(() {
      _isSignedIn = client.auth.isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isSignedIn) return widget.child;

    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Las tareas de casa,\nen un trato',
                    style: text.displaySmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Entra con tu correo. Te enviamos un código para confirmar '
                    'que eres tú.',
                    style: text.bodyLarge?.copyWith(color: appMuted),
                  ),
                  const SizedBox(height: 28),
                  SignInWidget(
                    client: client,
                    onAuthenticated: () =>
                        _showMessage(context, 'Sesión iniciada.'),
                    onError: (error) => _showMessage(
                      context,
                      'No se ha podido entrar: $error',
                      isError: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? appCoral : appInk,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
