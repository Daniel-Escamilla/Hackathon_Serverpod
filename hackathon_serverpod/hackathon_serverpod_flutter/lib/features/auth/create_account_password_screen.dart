import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../app_theme.dart';
import '../../client.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';

class CreateAccountPasswordScreen extends StatefulWidget {
  const CreateAccountPasswordScreen({
    required this.registrationToken,
    super.key,
  });

  final String registrationToken;

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
      final authSuccess = await client.emailIdp.finishRegistration(
        registrationToken: widget.registrationToken,
        password: _passwordController.text,
      );
      await client.auth.updateSignedInUser(authSuccess);
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    } on EmailAccountRequestException catch (e) {
      setState(
        () => _error = switch (e.reason) {
          EmailAccountRequestExceptionReason.policyViolation =>
            l10n.passwordErrorPolicy,
          EmailAccountRequestExceptionReason.expired =>
            l10n.passwordErrorExpired,
          _ => l10n.passwordErrorGeneric,
        },
      );
    } catch (e) {
      setState(() => _error = l10n.passwordErrorGeneric);
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
        TextField(
          controller: _passwordController,
          obscureText: true,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(hintText: l10n.passwordHint),
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
