import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../features/tasks/available_task_screen.dart';
import '../features/tasks/counter_offer_decision_screen.dart';
import '../home_shell.dart';
import 'navigation.dart';
import 'widgets.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actividad')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          _ActivityCard(
            emoji: '👨🏽',
            title: 'Juan ha contraofertado 20 monedas',
            time: 'Ahora',
            action: 'Responder',
            onTap: () => pushPage(context, const CounterOfferDecisionScreen()),
          ),
          _ActivityCard(
            emoji: '✅',
            title: 'Tu tarea está disponible',
            time: 'Hace 8 min',
            action: 'Ver tarea',
            onTap: () => pushPage(context, const AvailableTaskScreen()),
          ),
          _ActivityCard(
            emoji: '🪙',
            title: 'Has ganado 20 monedas',
            time: 'Ayer',
            action: 'Ver cartera',
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  builder: (_) => const HomeShell(initialIndex: 2),
                ),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.emoji,
    required this.title,
    required this.time,
    required this.action,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String time;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SoftCard(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton(onPressed: onTap, child: Text(action)),
          ],
        ),
      ),
    );
  }
}
