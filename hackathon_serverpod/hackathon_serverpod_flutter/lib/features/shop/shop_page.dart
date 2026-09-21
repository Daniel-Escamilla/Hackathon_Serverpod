import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'buy_reward_screen.dart';
import 'propose_reward_screen.dart';
import 'reward_vote_screen.dart';
import 'shop_controller.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ShopController>();
    return Column(
      children: [
        const PageHeader(
          title: 'Tienda',
          subtitle: 'Convierte tus monedas en planes',
        ),
        Expanded(child: _Body(controller: controller)),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller});

  final ShopController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.loading && controller.rewards.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.error != null && controller.rewards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No se pudo cargar la tienda.'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: controller.load,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    final active = controller.rewards
        .where((r) => r.status == RewardItemStatus.active)
        .toList();
    final proposed = controller.rewards
        .where((r) => r.status == RewardItemStatus.proposed)
        .toList();

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton.filled(
              onPressed: () => pushPage(context, const ProposeRewardScreen()),
              icon: const Icon(Icons.add_rounded),
            ),
          ),
          const SizedBox(height: 8),
          if (active.isEmpty && proposed.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Center(
                child: Text('Todavía no hay recompensas. Propón la primera.'),
              ),
            ),
          for (final reward in active)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _RewardCard(
                color: AppColors.sky.withValues(alpha: .45),
                reward: reward,
                onTap: () => pushPage(context, BuyRewardScreen(reward: reward)),
              ),
            ),
          if (proposed.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 6),
              child: Text(
                'Esperando votación',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final reward in proposed)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _RewardCard(
                  color: const Color(0xFFE9E3FF),
                  reward: reward,
                  onTap: () =>
                      pushPage(context, RewardVoteScreen(reward: reward)),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.color,
    required this.reward,
    required this.onTap,
  });

  final Color color;
  final RewardItem reward;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: color,
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.violet,
            ),
          ),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '🪙 ${reward.price} monedas',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFeatures: AppFonts.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
