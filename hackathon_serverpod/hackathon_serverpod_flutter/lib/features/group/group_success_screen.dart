import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';

class GroupSuccessScreen extends StatelessWidget {
  const GroupSuccessScreen({
    required this.groupName,
    required this.inviteCode,
    super.key,
  });

  final String groupName;
  final String inviteCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const RoundIcon(icon: Icons.home_rounded, color: AppColors.lime),
              const SizedBox(height: 30),
              Text(
                '¡Ya tenéis casa!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(groupName, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 28),
              SoftCard(
                child: Column(
                  children: [
                    const Text(
                      'Código del grupo',
                      style: TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      inviteCode,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_rounded),
                label: const Text('Compartir código'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => enterHome(context),
                child: const Text('Ir a las tareas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
