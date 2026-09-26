import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../data/app_failure.dart';
import '../../data/auth_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import 'create_account_password_screen.dart';

class CreateAccountCodeScreen extends StatefulWidget {
  const CreateAccountCodeScreen({
    required this.email,
    required this.accountRequestId,
    this.repository = const AuthRepository(),
    super.key,
  });

  final String email;
  final UuidValue accountRequestId;
  final AuthRepository repository;

  @override
  State<CreateAccountCodeScreen> createState() =>
      _CreateAccountCodeScreenState();
}

class _CreateAccountCodeScreenState extends State<CreateAccountCodeScreen> {
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
      final registrationToken = await widget.repository.verifyRegistrationCode(
        widget.accountRequestId,
        _codeController.text.trim(),
      );
      if (mounted) {
        pushPage(
          context,
          CreateAccountPasswordScreen(
            registrationToken: registrationToken,
            repository: widget.repository,
          ),
        );
      }
    } catch (e) {
      setState(
        () => _error = switch (e) {
          AppException(failure: AppFailure.registrationExpired) =>
            l10n.codeErrorExpired,
          AppException(failure: AppFailure.unknown) => l10n.codeErrorGeneric,
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
      title: l10n.verifyEmailTitle,
      subtitle: l10n.verifyEmailSubtitle(widget.email),
      art: const RoundIcon(
        icon: Icons.mark_email_read_rounded,
        color: AppColors.lime,
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
