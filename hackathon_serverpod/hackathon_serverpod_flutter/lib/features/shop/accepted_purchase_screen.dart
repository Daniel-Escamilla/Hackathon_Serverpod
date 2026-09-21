import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';

class AcceptedPurchaseScreen extends StatelessWidget {
  const AcceptedPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(
        label: 'Pendiente de entrega',
        color: Color(0xFFFFDFA0),
      ),
      title: 'Elijo yo la serie esta noche',
      content: const [
        Center(child: Text('📺', style: TextStyle(fontSize: 100))),
        InfoRow(
          icon: Icons.person_rounded,
          text: 'La cumple Juan · para Mayte',
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _TimelineStep(label: 'Comprada', done: true),
            _TimelineStep(label: 'Aceptada', done: true),
            _TimelineStep(label: 'Entregada', done: false),
          ],
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => showSnack(context, 'Recompensa entregada'),
          child: const Text('Marcar como entregada'),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: done ? AppColors.violet : const Color(0xFFD8D5DE),
          child: Icon(
            done ? Icons.check : Icons.more_horiz,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ],
    );
  }
}
