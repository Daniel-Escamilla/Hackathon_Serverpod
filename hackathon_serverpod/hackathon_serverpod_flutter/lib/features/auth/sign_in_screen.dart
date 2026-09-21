import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../app_theme.dart';
import '../../client.dart';
import '../../common/widgets.dart';

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
            'Email o contraseña incorrectos.',
          EmailAccountLoginExceptionReason.tooManyAttempts =>
            'Demasiados intentos. Prueba en unos minutos.',
          EmailAccountLoginExceptionReason.unknown =>
            'No se pudo iniciar sesión.',
        },
      );
    } catch (e) {
      setState(() => _error = 'No se pudo iniciar sesión.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFormPage(
      title: 'Entra en tu cuenta',
      art: const RoundIcon(
        icon: Icons.alternate_email_rounded,
        color: AppColors.sky,
      ),
      children: [
        const FieldLabel('Email'),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'mayte@email.com'),
        ),
        const SizedBox(height: 18),
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
              : const Text('Entrar'),
        ),
      ],
    );
  }
}
