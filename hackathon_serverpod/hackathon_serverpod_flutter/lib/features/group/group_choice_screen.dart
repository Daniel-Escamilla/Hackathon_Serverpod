import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import 'create_group_screen.dart';
import 'join_group_screen.dart';

class GroupChoiceScreen extends StatelessWidget {
  const GroupChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Hola, Mayte!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '¿Cómo quieres\nempezar?',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 34),
              _ChoiceCard(
                color: AppColors.lime,
                icon: Icons.home_rounded,
                title: 'Crear un grupo',
                subtitle: 'Prepara vuestro espacio',
                onTap: () => pushPage(context, const CreateGroupScreen()),
              ),
              const SizedBox(height: 16),
              _ChoiceCard(
                color: AppColors.sky,
                icon: Icons.confirmation_number_rounded,
                title: 'Unirme con un código',
                subtitle: 'Entra en un grupo existente',
                onTap: () => pushPage(context, const JoinGroupScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.violet, size: 42),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
