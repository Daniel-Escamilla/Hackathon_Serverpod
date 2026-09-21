import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/result_screen.dart';
import '../../common/widgets.dart';

class TaskReviewScreen extends StatelessWidget {
  const TaskReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(label: 'Revisa el trato', color: AppColors.sky),
      title: 'Limpiar el baño',
      content: const [
        BigValueCard(
          color: AppColors.lime,
          value: '25',
          label: 'monedas',
          icon: '🪙',
        ),
        SizedBox(height: 16),
        InfoRow(
          icon: Icons.schedule_rounded,
          text: 'El grupo tendrá 24 horas para votar',
        ),
        SizedBox(height: 10),
        InfoRow(
          icon: Icons.warning_amber_rounded,
          text: 'Si la rechazan, recibirás una multa de 5 monedas',
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => pushPage(
            context,
            const ResultScreen(
              emoji: '🗳️',
              title: 'Enviada a votación',
              message: 'Avisaremos al grupo para que decida el trato.',
              value: '25 monedas · 24 horas',
              button: 'Volver a tareas',
            ),
          ),
          child: const Text('Enviar a votación'),
        ),
      ],
    );
  }
}
