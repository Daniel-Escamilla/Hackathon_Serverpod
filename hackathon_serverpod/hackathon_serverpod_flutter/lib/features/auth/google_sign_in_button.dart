import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../client.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/feedback.dart';

/// Signs in with Google. Once the server accepts the account the session is
/// kept, and the auth gate moves on by itself, as with email.
///
/// Drawn as an [AppButton] rather than Serverpod's `GoogleSignInWidget`, so it
/// follows the design standard like the rest of the screen.
class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({this.signIn, super.key});

  /// Replaces the real Google flow, so a test can run without a server.
  final Future<void> Function()? signIn;

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  GoogleAuthController? _controller;
  bool _loading = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _showError() {
    if (!mounted) return;
    showMessage(
      context,
      AppLocalizations.of(context).googleSignInError,
      isError: true,
    );
  }

  Future<void> _submit() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await (widget.signIn ?? _signInWithGoogle)();
    } catch (_) {
      _showError();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Made on the first tap, not with the screen, so the welcome screen does
  /// not touch [client] until someone asks for Google.
  Future<void> _signInWithGoogle() async {
    final controller = _controller ??= GoogleAuthController(
      client: client,
      onError: (_) => _showError(),
    );
    // It must listen for Google's answer before the sign-in starts.
    if (controller.state == GoogleAuthState.initializing) {
      final ready = Completer<void>();
      void onChange() {
        if (controller.state != GoogleAuthState.initializing &&
            !ready.isCompleted) {
          ready.complete();
        }
      }

      controller.addListener(onChange);
      await ready.future;
      controller.removeListener(onChange);
    }
    if (controller.state == GoogleAuthState.error) return;
    await controller.signIn();
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: AppLocalizations.of(context).welcomeGoogle,
      kind: AppButtonKind.secondary,
      loading: _loading,
      onPressed: _submit,
    );
  }
}
