import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';

/// Buying needs to pick who fulfils the reward, which needs the group's
/// member list — GroupEndpoint has no read endpoint for that yet (see
/// group_page.dart). Shows the real reward and blocks the purchase instead
/// of picking from fake people.
class BuyRewardScreen extends StatelessWidget {
  const BuyRewardScreen({required this.reward, super.key});

  final RewardItem reward;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        children: [
          Text(
            '¿Quién la cumplirá?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 22),
          SoftCard(
            color: const Color(0xFFE9E3FF),
            child: Row(
              children: [
                const Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.violet,
                  size: 40,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    reward.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  '🪙 ${reward.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFeatures: AppFonts.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const InfoRow(
            icon: Icons.construction_rounded,
            text:
                'Elegir a quién le toca necesita el listado de miembros del '
                'grupo, que todavía no tiene endpoint.',
          ),
          const SizedBox(height: 8),
          const Text(
            'La compra se activará en cuanto el backend lo exponga.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
