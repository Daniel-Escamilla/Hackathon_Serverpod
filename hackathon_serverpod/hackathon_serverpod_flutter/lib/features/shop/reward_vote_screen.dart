import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'shop_controller.dart';

class RewardVoteScreen extends StatelessWidget {
  const RewardVoteScreen({required this.reward, super.key});

  final RewardItem reward;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      status: const StatusPill(
        label: 'Espera tu voto',
        color: Color(0xFFE2DCFF),
      ),
      title: reward.title,
      content: [
        BigValueCard(
          color: AppColors.sky,
          value: '${reward.price}',
          label: 'monedas',
          icon: '🪙',
        ),
        const SizedBox(height: 14),
        InfoRow(icon: Icons.description_rounded, text: reward.description),
      ],
      actions: [
        FilledButton(
          onPressed: () => _vote(context, true),
          child: const Text('Aprobar recompensa'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => _vote(context, false),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.coral,
            side: const BorderSide(color: AppColors.coral),
          ),
          child: const Text('Rechazar'),
        ),
      ],
    );
  }

  Future<void> _vote(BuildContext context, bool approve) async {
    final controller = context.read<ShopController>();
    try {
      await controller.voteReward(reward.id!, approve);
      if (context.mounted) {
        showSnack(
          context,
          approve ? 'Recompensa aprobada' : 'Recompensa rechazada',
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) showSnack(context, 'No se pudo registrar tu voto');
    }
  }
}
