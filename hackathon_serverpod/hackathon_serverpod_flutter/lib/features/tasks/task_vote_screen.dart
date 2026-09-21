import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'counter_offer_decision_screen.dart';
import 'counter_offer_sheet.dart';
import 'tasks_controller.dart';

class TaskVoteScreen extends StatelessWidget {
  const TaskVoteScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(
        label: 'Esperando tu voto',
        color: Color(0xFFE2DCFF),
      ),
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
        if (task.voteClosesAt != null) ...[
          const SizedBox(height: 12),
          InfoRow(
            icon: Icons.schedule_rounded,
            text: _remaining(task.voteClosesAt!),
          ),
        ],
      ],
      actions: [
        FilledButton.icon(
          onPressed: () => _vote(context, true),
          icon: const Icon(Icons.thumb_up_alt_rounded),
          label: const Text('Aprobar'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _counterOffer(context),
          icon: const Icon(Icons.swap_horiz_rounded),
          label: const Text('Contraofertar'),
        ),
        TextButton(
          onPressed: () => _vote(context, false),
          style: TextButton.styleFrom(foregroundColor: AppColors.coral),
          child: const Text('Rechazar'),
        ),
      ],
    );
  }

  String _remaining(DateTime closesAt) {
    final left = closesAt.difference(DateTime.now());
    if (left.isNegative) return 'La votación está a punto de cerrar';
    return 'Quedan ${left.inHours} h ${left.inMinutes % 60} min';
  }

  Future<void> _vote(BuildContext context, bool approve) async {
    final controller = context.read<TasksController>();
    try {
      await controller.voteTaskProposal(task.id!, approve);
      if (context.mounted) {
        showSnack(
          context,
          approve ? 'Has aprobado la propuesta' : 'Propuesta rechazada',
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) showSnack(context, 'No se pudo registrar tu voto');
    }
  }

  Future<void> _counterOffer(BuildContext context) async {
    final controller = context.read<TasksController>();
    final sent = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CounterOfferSheet(initialValue: task.reward),
    );
    if (sent == null || !context.mounted) return;
    try {
      final updated = await controller.counterOfferTask(task.id!, sent);
      if (context.mounted) {
        pushPage(context, CounterOfferDecisionScreen(task: updated));
      }
    } catch (e) {
      if (context.mounted) {
        showSnack(context, 'No se pudo enviar la contraoferta');
      }
    }
  }
}
