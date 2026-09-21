import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../../app_theme.dart';
import '../../client.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'create_account_password_screen.dart';

class CreateAccountCodeScreen extends StatefulWidget {
  const CreateAccountCodeScreen({
    required this.email,
    required this.accountRequestId,
    super.key,
  });

  final String email;
  final UuidValue accountRequestId;

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
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final registrationToken = await client.emailIdp.verifyRegistrationCode(
        accountRequestId: widget.accountRequestId,
        verificationCode: _codeController.text.trim(),
      );
      if (mounted) {
        pushPage(
          context,
          CreateAccountPasswordScreen(registrationToken: registrationToken),
        );
      }
    } on EmailAccountRequestException catch (e) {
      setState(
        () => _error = switch (e.reason) {
          EmailAccountRequestExceptionReason.expired =>
            'El código ha caducado. Vuelve a empezar.',
          EmailAccountRequestExceptionReason.invalid => 'Código incorrecto.',
          EmailAccountRequestExceptionReason.tooManyAttempts =>
            'Demasiados intentos. Prueba en unos minutos.',
          _ => 'No se pudo verificar el código.',
        },
      );
    } catch (e) {
      setState(() => _error = 'No se pudo verificar el código.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFormPage(
      title: 'Revisa tu email',
      subtitle: 'Hemos enviado un código de verificación a ${widget.email}.',
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
          decoration: const InputDecoration(hintText: '284619'),
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
              : const Text('Verificar'),
        ),
      ],
    );
  }
}
