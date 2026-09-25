import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../data/password_reset_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import 'reset_password_new_screen.dart';

/// Second step of the password reset: the code that was emailed.
class ResetPasswordCodeScreen extends StatefulWidget {
  const ResetPasswordCodeScreen({
    required this.email,
    required this.requestId,
    required this.repository,
    super.key,
  });

  final String email;
  final UuidValue requestId;
  final PasswordResetRepository repository;

  @override
  State<ResetPasswordCodeScreen> createState() =>
      _ResetPasswordCodeScreenState();
}

class _ResetPasswordCodeScreenState extends State<ResetPasswordCodeScreen> {
  final _codeController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
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
      final token = await widget.repository.verifyCode(
        widget.requestId,
        _codeController.text.trim(),
      );
      if (mounted) {
        pushPage(
          context,
          ResetPasswordNewScreen(token: token, repository: widget.repository),
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
      title: l10n.verifyEmailTitle,
      subtitle: l10n.verifyEmailSubtitle(widget.email),
      art: const RoundIcon(
        icon: Icons.mark_email_read_rounded,
        color: AppColors.sky,
      ),
      children: [
        TextField(
          controller: _codeController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          onSubmitted: (_) => _submit(),
          style: const TextStyle(
            fontSize: 25,
            letterSpacing: 14,
            fontWeight: FontWeight.w800,
          ),
          decoration: InputDecoration(hintText: l10n.codeHint),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.coral),
          ),
        ],
        const SizedBox(height: 18),
        AppButton(
          label: l10n.verifyButton,
          loading: _loading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
