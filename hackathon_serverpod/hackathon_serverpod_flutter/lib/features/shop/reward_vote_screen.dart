import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';

class RewardVoteScreen extends StatelessWidget {
  const RewardVoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(
        label: 'Espera tu voto',
        color: Color(0xFFE2DCFF),
      ),
      title: 'Desayuno en la cama',
      content: const [
        Center(child: Text('☕🥐', style: TextStyle(fontSize: 90))),
        BigValueCard(
          color: AppColors.sky,
          value: '40',
          label: 'monedas',
          icon: '🪙',
        ),
        SizedBox(height: 14),
        PersonRow(name: 'Propuesta por Mayte', emoji: '👩🏽'),
        SizedBox(height: 14),
        InfoRow(icon: Icons.schedule_rounded, text: 'Quedan 23 h 42 min'),
      ],
      actions: [
        FilledButton(
          onPressed: () => showSnack(context, 'Recompensa aprobada'),
          child: const Text('Aprobar recompensa'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => showSnack(context, 'Recompensa rechazada'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.coral,
            side: const BorderSide(color: AppColors.coral),
          ),
          child: const Text('Rechazar'),
        ),
      ],
    );
  }
}
