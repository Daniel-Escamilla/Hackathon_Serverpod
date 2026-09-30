import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../data/auth_repository.dart';
import '../../data/password_reset_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import '../../ui/feedback.dart';
import '../../ui/password_field.dart';
import '../../ui/sounds.dart';

/// Last step of the password reset: the new password. Ends back on the
/// sign-in screen, where the person enters with it — or, when changed from
/// the settings, signed out and back at the start.
class ResetPasswordNewScreen extends StatefulWidget {
  const ResetPasswordNewScreen({
    required this.token,
    required this.repository,
    this.signedIn = false,
    this.auth = const AuthRepository(),
    super.key,
  });

  final String token;
  final PasswordResetRepository repository;

  /// Opened from the settings by someone signed in.
  final bool signedIn;
  final AuthRepository auth;

  @override
  State<ResetPasswordNewScreen> createState() => _ResetPasswordNewScreenState();
}

class _ResetPasswordNewScreenState extends State<ResetPasswordNewScreen> {
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final l10n = AppLocalizations.of(context);
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.repository.setPassword(
        widget.token,
        _passwordController.text,
      );
      if (!mounted) return;
      if (widget.signedIn) {
        // The server has just revoked every session of this account, this
        // one included (EmailIdp.finishPasswordReset): the next call would be
        // refused, so sign out here and start again from the welcome screen.
        await signOutToStart(
          context,
          auth: widget.auth,
          message: l10n.passwordChanged,
        );
        return;
      }
      // The message outlives the pops: ScaffoldMessenger carries it over to
      // the sign-in screen.
      showMessage(context, l10n.passwordChanged, sound: AppSound.success);
      // This screen, the code and the email: the three steps above sign-in.
      var popped = 0;
      Navigator.of(context).popUntil((_) => popped++ == 3);
    } catch (e) {
      setState(() => _error = failureMessage(e, l10n));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SimpleFormPage(
      title: l10n.newPasswordTitle,
      art: const RoundIcon(icon: Icons.lock_rounded, color: AppColors.sky),
      children: [
        FieldLabel(l10n.passwordFieldLabel),
        PasswordField(
          controller: _passwordController,
          hintText: l10n.passwordHint,
          onSubmitted: (_) => _submit(),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: AppColors.coral)),
        ],
        const SizedBox(height: 18),
        AppButton(
          label: l10n.newPasswordButton,
          loading: _loading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
