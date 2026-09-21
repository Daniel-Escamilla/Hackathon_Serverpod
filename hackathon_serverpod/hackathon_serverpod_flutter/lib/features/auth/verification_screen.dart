import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../group/group_choice_screen.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleFormPage(
      title: 'Revisa tu email',
      subtitle: 'Hemos enviado un código de 6 dígitos.',
      art: const RoundIcon(
        icon: Icons.mark_email_read_rounded,
        color: AppColors.lime,
      ),
      children: [
        const TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 14,
            fontWeight: FontWeight.w800,
          ),
          decoration: InputDecoration(hintText: '284619'),
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: () => pushPage(context, const GroupChoiceScreen()),
          child: const Text('Verificar'),
        ),
        TextButton(onPressed: () {}, child: const Text('Reenviar código')),
      ],
    );
  }
}
