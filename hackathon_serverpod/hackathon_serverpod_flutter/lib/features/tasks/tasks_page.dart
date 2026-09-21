import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'available_task_screen.dart';
import 'task_vote_screen.dart';
import 'validation_screen.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: 'Tareas', subtitle: 'Buenas, Mayte'),
        SizedBox(
          height: 44,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            children: const [
              FilterPill('Todas', selected: true),
              FilterPill('Tu voto'),
              FilterPill('Disponibles'),
              FilterPill('Validación'),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            children: [
              _ActionBanner(
                color: AppColors.coral,
                icon: Icons.notifications_active_rounded,
                title: '1 tarea espera tu voto',
                subtitle: 'Tu opinión cuenta',
                onTap: () => pushPage(context, const TaskVoteScreen()),
              ),
              const SizedBox(height: 14),
              _TaskCard(
                emoji: '🧼',
                title: 'Limpiar el baño',
                coins: 20,
                status: 'Tu voto',
                statusColor: AppColors.sky,
                detail: '23 h 42 min',
                onTap: () => pushPage(context, const TaskVoteScreen()),
              ),
              const SizedBox(height: 12),
              _TaskCard(
                emoji: '🗑️',
                title: 'Sacar la basura',
                coins: 5,
                status: 'Disponible',
                statusColor: AppColors.lime,
                onTap: () => pushPage(context, const AvailableTaskScreen()),
              ),
              const SizedBox(height: 12),
              _TaskCard(
                emoji: '✨',
                title: 'Fregar los platos',
                coins: 10,
                status: 'Validación',
                statusColor: AppColors.coral.withValues(alpha: .35),
                onTap: () => pushPage(context, const ValidationScreen()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionBanner extends StatelessWidget {
  const _ActionBanner({
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
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 42, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    Text(subtitle, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.emoji,
    required this.title,
    required this.coins,
    required this.status,
    required this.statusColor,
    required this.onTap,
    this.detail,
  });

  final String emoji;
  final String title;
  final int coins;
  final String status;
  final Color statusColor;
  final String? detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.sky.withValues(alpha: .36),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 35)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(
                  '🪙 $coins monedas',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFeatures: AppFonts.tabularFigures,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    StatusPill(label: status, color: statusColor),
                    if (detail != null)
                      Text(
                        detail!,
                        style: const TextStyle(color: AppColors.muted),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
        ],
      ),
    );
  }
}
