import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../app_theme.dart';
import '../../client.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/password_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

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
      final authSuccess = await client.emailIdp.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await client.auth.updateSignedInUser(authSuccess);
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on EmailAccountLoginException catch (e) {
      setState(
        () => _error = switch (e.reason) {
          EmailAccountLoginExceptionReason.invalidCredentials =>
            l10n.signInErrorInvalidCredentials,
          EmailAccountLoginExceptionReason.tooManyAttempts =>
            l10n.authErrorTooManyAttempts,
          EmailAccountLoginExceptionReason.unknown => l10n.signInErrorUnknown,
        },
      );
    } catch (e) {
      setState(() => _error = l10n.signInErrorUnknown);
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
      ],
    );
  }
}
