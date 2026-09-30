import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';
import '../../data/app_failure.dart';
import '../../data/auth_repository.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import '../../ui/password_field.dart';

class CreateAccountPasswordScreen extends StatefulWidget {
  const CreateAccountPasswordScreen({
    required this.registrationToken,
    this.repository = const AuthRepository(),
    super.key,
  });

  final String registrationToken;
  final AuthRepository repository;

  @override
  State<CreateAccountPasswordScreen> createState() =>
      _CreateAccountPasswordScreenState();
}

class _CreateAccountPasswordScreenState
    extends State<CreateAccountPasswordScreen> {
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
      await widget.repository.finishRegistration(
        widget.registrationToken,
        _passwordController.text,
      );
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      setState(
        () => _error = switch (e) {
          AppException(
            failure: AppFailure.passwordPolicy ||
                AppFailure.registrationExpired,
          ) =>
            failureMessage(e, l10n),
          _ => l10n.passwordErrorGeneric,
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
      title: l10n.choosePasswordTitle,
      art: const RoundIcon(icon: Icons.lock_rounded, color: AppColors.lime),
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
          label: l10n.createAccountButton,
          loading: _loading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
