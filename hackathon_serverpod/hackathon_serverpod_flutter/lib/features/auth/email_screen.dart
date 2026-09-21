import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'verification_screen.dart';

class EmailScreen extends StatelessWidget {
  const EmailScreen({super.key});

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
        const TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(hintText: 'mayte@email.com'),
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: () => pushPage(context, const VerificationScreen()),
          child: const Text('Continuar'),
        ),
      ],
    );
  }
}
