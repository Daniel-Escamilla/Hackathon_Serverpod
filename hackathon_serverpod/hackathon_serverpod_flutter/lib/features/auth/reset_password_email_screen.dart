import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../data/password_reset_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import 'reset_password_code_screen.dart';

/// First step of the password reset: the email the code goes to.
class ResetPasswordEmailScreen extends StatefulWidget {
  const ResetPasswordEmailScreen({
    this.initialEmail = '',
    this.repository = const PasswordResetRepository(),
    super.key,
  });

  /// Whatever was already typed on the sign-in screen, so it is not asked
  /// twice.
  final String initialEmail;
  final PasswordResetRepository repository;

  @override
  State<ResetPasswordEmailScreen> createState() =>
      _ResetPasswordEmailScreenState();
}

class _ResetPasswordEmailScreenState extends State<ResetPasswordEmailScreen> {
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final requestId = await widget.repository.sendCode(email);
      if (mounted) {
        pushPage(
          context,
          ResetPasswordCodeScreen(
            email: email,
            requestId: requestId,
            repository: widget.repository,
          ),
        );
      }
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
      title: l10n.resetPasswordTitle,
      subtitle: l10n.resetPasswordSubtitle,
      art: const RoundIcon(
        icon: Icons.lock_reset_rounded,
        color: AppColors.sky,
      ),
      children: [
        FieldLabel(l10n.emailFieldLabel),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(hintText: l10n.emailHint),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: AppColors.coral)),
        ],
        const SizedBox(height: 18),
        AppButton(
          label: l10n.resetPasswordSendCode,
          loading: _loading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
