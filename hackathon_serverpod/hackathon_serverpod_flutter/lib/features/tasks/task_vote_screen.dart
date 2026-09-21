import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'counter_offer_decision_screen.dart';
import 'counter_offer_sheet.dart';

class TaskVoteScreen extends StatelessWidget {
  const TaskVoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(
        label: 'Esperando tu voto',
        color: Color(0xFFE2DCFF),
      ),
      title: 'Limpiar el baño',
      content: [
        const PersonRow(name: 'Propuesta por Juan', emoji: '👨🏽'),
        const SizedBox(height: 20),
        const BigValueCard(
          color: AppColors.lime,
          value: '25',
          label: 'monedas',
          icon: '🪙',
        ),
        const SizedBox(height: 16),
        const InfoRow(
          icon: Icons.description_rounded,
          text: 'Ducha, lavabo, espejo y suelo',
        ),
        const SizedBox(height: 12),
        const InfoRow(
          icon: Icons.schedule_rounded,
          text: 'Quedan 23 h 42 min',
        ),
        const SizedBox(height: 20),
        const Text(
          'Votos · 0 de 1',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        const LinearProgressIndicator(
          value: 0,
          minHeight: 8,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ],
      actions: [
        FilledButton.icon(
          onPressed: () => showSnack(context, 'Has aprobado la propuesta'),
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
          onPressed: () => showSnack(context, 'Propuesta rechazada'),
          style: TextButton.styleFrom(foregroundColor: AppColors.coral),
          child: const Text('Rechazar'),
        ),
      ],
    );
  }

  Future<void> _counterOffer(BuildContext context) async {
    final sent = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CounterOfferSheet(),
    );
    if (sent == true && context.mounted) {
      pushPage(context, const CounterOfferDecisionScreen());
    }
  }
}
