import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/result_screen.dart';
import '../../common/widgets.dart';
import 'tasks_controller.dart';

class AvailableTaskScreen extends StatelessWidget {
  const AvailableTaskScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(label: 'Disponible', color: AppColors.lime),
      title: task.title,
      content: [
        BigValueCard(
          color: AppColors.lime,
          value: '${task.reward}',
          label: 'monedas',
          icon: '🪙',
        ),
        const SizedBox(height: 16),
        InfoRow(icon: Icons.description_rounded, text: task.description),
        const SizedBox(height: 12),
        const InfoRow(
          icon: Icons.info_outline_rounded,
          text: 'No se reserva: reclama cuando esté hecha',
        ),
      ],
      actions: [
        FilledButton.icon(
          onPressed: () => _markDone(context),
          icon: const Icon(Icons.check_rounded),
          label: const Text('Ya está hecha'),
        ),
      ],
    );
  }

  Future<void> _markDone(BuildContext context) async {
    final controller = context.read<TasksController>();
    try {
      await controller.markTaskDone(task.id!);
      if (context.mounted) {
        pushPage(
          context,
          ResultScreen(
            emoji: '✅',
            title: '¡Reclamada!',
            message: 'Ahora el grupo debe confirmar que está hecha.',
            value: 'En validación · ${task.reward} monedas',
            button: 'Volver a tareas',
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnack(
          context,
          'No se pudo reclamar. Puede que ya la haya cogido otra persona.',
        );
      }
    }
  }
}
