import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';

class JoinGroupScreen extends StatelessWidget {
  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleFormPage(
      title: 'Únete a tu gente',
      subtitle: 'Introduce el código que te han compartido.',
      art: const RoundIcon(icon: Icons.groups_rounded, color: AppColors.sky),
      children: [
        const TextField(
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.characters,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
          decoration: InputDecoration(hintText: 'NIDO-482'),
        ),
        const SizedBox(height: 8),
        const Text(
          'El código no distingue mayúsculas',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () => enterHome(context),
          child: const Text('Entrar al grupo'),
        ),
      ],
    );
  }
}
