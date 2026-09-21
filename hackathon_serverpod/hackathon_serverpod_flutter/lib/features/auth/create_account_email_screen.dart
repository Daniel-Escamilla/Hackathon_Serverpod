import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../../app_theme.dart';
import '../../client.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import 'create_account_code_screen.dart';

class CreateAccountEmailScreen extends StatefulWidget {
  const CreateAccountEmailScreen({super.key});

  @override
  State<CreateAccountEmailScreen> createState() =>
      _CreateAccountEmailScreenState();
}

class _CreateAccountEmailScreenState extends State<CreateAccountEmailScreen> {
  final _emailController = TextEditingController();
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
      final accountRequestId = await client.emailIdp.startRegistration(
        email: email,
      );
      if (mounted) {
        pushPage(
          context,
          CreateAccountCodeScreen(
            email: email,
            accountRequestId: accountRequestId,
          ),
        );
      }
    } on EmailAccountRequestException catch (e) {
      setState(
        () => _error = switch (e.reason) {
          EmailAccountRequestExceptionReason.tooManyAttempts =>
            l10n.authErrorTooManyAttempts,
          _ => l10n.createAccountErrorGeneric,
        },
      );
    } catch (e) {
      setState(() => _error = l10n.createAccountErrorStart);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SimpleFormPage(
      title: l10n.createAccountTitle,
      art: const RoundIcon(
        icon: Icons.alternate_email_rounded,
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
          label: l10n.createAccountContinue,
          loading: _loading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
