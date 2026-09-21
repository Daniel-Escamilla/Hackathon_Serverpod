import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';

/// There is no endpoint yet for the completion vote — TaskEndpoint's
/// voteTaskProposal only accepts tasks in `proposed` status, so it can't be
/// reused here. Shows the real task while the action is blocked, instead of
/// wiring buttons that would always fail.
class ValidationScreen extends StatelessWidget {
  const ValidationScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(label: 'Validación', color: AppColors.lime),
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
        const SizedBox(height: 16),
        const InfoRow(
          icon: Icons.construction_rounded,
          text:
              'Todavía no se puede votar la validación: falta el endpoint '
              'en el backend.',
        ),
      ],
      actions: const [],
    );
  }
}
