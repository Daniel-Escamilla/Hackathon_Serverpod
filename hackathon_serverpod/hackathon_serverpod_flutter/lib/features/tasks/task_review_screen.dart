import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/result_screen.dart';
import '../../common/widgets.dart';
import 'tasks_controller.dart';

class TaskReviewScreen extends StatelessWidget {
  const TaskReviewScreen({
    required this.title,
    required this.description,
    required this.reward,
    super.key,
  });

  final String title;
  final String description;
  final int reward;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(label: 'Revisa el trato', color: AppColors.sky),
      title: title,
      content: [
        BigValueCard(
          color: AppColors.lime,
          value: '$reward',
          label: 'monedas',
          icon: '🪙',
        ),
        const SizedBox(height: 16),
        const InfoRow(
          icon: Icons.schedule_rounded,
          text: 'El grupo tendrá 24 horas para votar',
        ),
        const SizedBox(height: 10),
        const InfoRow(
          icon: Icons.warning_amber_rounded,
          text: 'Si la rechazan, recibirás una multa sobre estas monedas',
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => _submit(context),
          child: const Text('Enviar a votación'),
        ),
      ],
    );
  }

  Future<void> _submit(BuildContext context) async {
    final controller = context.read<TasksController>();
    try {
      await controller.proposeTask(title, description, reward);
      if (context.mounted) {
        pushPage(
          context,
          ResultScreen(
            emoji: '🗳️',
            title: 'Enviada a votación',
            message: 'Avisaremos al grupo para que decida el trato.',
            value: '$reward monedas',
            button: 'Volver a tareas',
          ),
        );
      }
    } catch (e) {
      if (context.mounted) showSnack(context, 'No se pudo enviar la propuesta');
    }
  }
}
