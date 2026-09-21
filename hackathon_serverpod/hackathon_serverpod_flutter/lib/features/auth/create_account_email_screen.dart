import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

import '../../app_theme.dart';
import '../../client.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
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
            'Demasiados intentos. Prueba en unos minutos.',
          _ =>
            'No se pudo empezar el registro. ¿Ya tienes cuenta con ese email?',
        },
      );
    } catch (e) {
      setState(() => _error = 'No se pudo empezar el registro.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFormPage(
      title: 'Crea tu cuenta',
      art: const RoundIcon(
        icon: Icons.alternate_email_rounded,
        color: AppColors.sky,
      ),
      children: [
        const FieldLabel('Email'),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          onSubmitted: (_) => _submit(),
          decoration: const InputDecoration(hintText: 'mayte@email.com'),
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
              : const Text('Continuar'),
        ),
      ],
    );
  }
}
