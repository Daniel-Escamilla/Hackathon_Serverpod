import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../data/app_failure.dart';
import '../../data/auth_repository.dart';
import '../../data/password_reset_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import '../../ui/password_field.dart';
import 'reset_password_email_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    this.auth = const AuthRepository(),
    this.passwordReset = const PasswordResetRepository(),
    super.key,
  });

  final AuthRepository auth;

  /// Handed down the password reset steps, so a test can swap in a fake.
  final PasswordResetRepository passwordReset;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
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
      await widget.auth.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      setState(
        () => _error = switch (e) {
          AppException(failure: AppFailure.unknown) => l10n.signInErrorUnknown,
          _ => failureMessage(e, l10n),
        },
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SimpleFormPage(
      title: l10n.signInTitle,
      art: const RoundIcon(
        icon: Icons.alternate_email_rounded,
        color: AppColors.sky,
      ),
      children: [
        FieldLabel(l10n.emailFieldLabel),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(hintText: l10n.emailHint),
        ),
        const SizedBox(height: 18),
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
          label: l10n.signInSubmit,
          loading: _loading,
          onPressed: _submit,
        ),
        const SizedBox(height: 8),
        AppButton(
          label: l10n.forgotPasswordLink,
          kind: AppButtonKind.quiet,
          onPressed: () => pushPage(
            context,
            ResetPasswordEmailScreen(
              initialEmail: _emailController.text.trim(),
              repository: widget.passwordReset,
            ),
          ),
        ),
      ],
    );
  }
}
