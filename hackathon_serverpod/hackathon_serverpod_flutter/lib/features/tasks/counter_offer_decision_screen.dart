import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'tasks_controller.dart';

/// Shown to a task's author to accept or withdraw a pending counter-offer.
/// The counter's actual amount lives on a TaskVote row, which has no read
/// endpoint yet — so this can drive the real decision, but can't yet show
/// what price was offered.
class CounterOfferDecisionScreen extends StatelessWidget {
  const CounterOfferDecisionScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(
        label: 'Votación pausada',
        color: Color(0xFFFFDFA0),
      ),
      title: task.title,
      content: const [
        InfoRow(
          icon: Icons.restart_alt_rounded,
          text:
              'Han contraofertado un nuevo precio para esta tarea. Si '
              'aceptas, la votación empieza de cero con esa cifra.',
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => _respond(context, true),
          child: const Text('Aceptar la contraoferta'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => _respond(context, false),
          child: const Text('Retirar sin multa'),
        ),
      ],
    );
  }

  Future<void> _respond(BuildContext context, bool accept) async {
    final controller = context.read<TasksController>();
    try {
      await controller.respondToCounterOffer(task.id!, accept);
      if (context.mounted) {
        showSnack(
          context,
          accept ? 'Contraoferta aceptada' : 'Propuesta retirada',
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        showSnack(context, 'No se pudo procesar tu decisión');
      }
    }
  }
}
