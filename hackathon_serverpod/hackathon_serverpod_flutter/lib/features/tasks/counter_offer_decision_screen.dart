import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';

class CounterOfferDecisionScreen extends StatelessWidget {
  const CounterOfferDecisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(
        label: 'Votación pausada',
        color: Color(0xFFFFDFA0),
      ),
      title: 'Nueva contraoferta',
      content: const [
        PersonRow(name: 'Mayte propone', emoji: '👩🏽'),
        SizedBox(height: 22),
        BigValueCard(
          color: AppColors.sky,
          value: '20',
          label: 'monedas',
          icon: '🪙',
        ),
        SizedBox(height: 18),
        InfoRow(
          icon: Icons.restart_alt_rounded,
          text: 'Si aceptas, la votación empezará de cero',
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => showSnack(context, 'Contraoferta aceptada'),
          child: const Text('Aceptar 20 monedas'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Retirar sin multa'),
        ),
      ],
    );
  }
}
