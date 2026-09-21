import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../app_theme.dart';
import '../../client.dart';
import '../../common/widgets.dart';

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
            'La contraseña no cumple los requisitos.',
          EmailAccountRequestExceptionReason.expired =>
            'La sesión de registro ha caducado. Vuelve a empezar.',
          _ => 'No se pudo crear la cuenta.',
        },
      );
    } catch (e) {
      setState(() => _error = 'No se pudo crear la cuenta.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFormPage(
      title: 'Elige una contraseña',
      art: const RoundIcon(icon: Icons.lock_rounded, color: AppColors.lime),
      children: [
        const FieldLabel('Contraseña'),
        TextField(
          controller: _passwordController,
          obscureText: true,
          onSubmitted: (_) => _submit(),
          decoration: const InputDecoration(hintText: '••••••••'),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: const TextStyle(color: AppColors.coral)),
        ],
        const SizedBox(height: 18),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Crear cuenta'),
        ),
      ],
    );
  }
}
