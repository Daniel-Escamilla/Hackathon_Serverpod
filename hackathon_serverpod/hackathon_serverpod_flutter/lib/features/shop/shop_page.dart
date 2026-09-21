import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import 'buy_reward_screen.dart';
import 'pending_purchase_screen.dart';
import 'propose_reward_screen.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(
          title: 'Tienda',
          subtitle: 'Convierte tus monedas en planes',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
            children: [
              Row(
                children: [
                  const FilterPill('Todo', selected: true),
                  const FilterPill('Mis compras'),
                  const Spacer(),
                  IconButton.filled(
                    onPressed: () =>
                        pushPage(context, const ProposeRewardScreen()),
                    icon: const Icon(Icons.add_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _RewardCard(
                color: const Color(0xFFE9E3FF),
                emoji: '🍿',
                title: 'Elijo yo la serie esta noche',
                price: 20,
                onTap: () => pushPage(context, const BuyRewardScreen()),
              ),
              const SizedBox(height: 14),
              _RewardCard(
                color: AppColors.sky.withValues(alpha: .55),
                emoji: '💆🏽',
                title: 'Un masaje',
                price: 50,
                onTap: () => pushPage(context, const BuyRewardScreen()),
              ),
              const SizedBox(height: 14),
              _RewardCard(
                color: AppColors.coral.withValues(alpha: .25),
                emoji: '🍝',
                title: 'Cena fuera, pago yo',
                price: 150,
                onTap: () => pushPage(context, const BuyRewardScreen()),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: () =>
                    pushPage(context, const PendingPurchaseScreen()),
                icon: const Icon(Icons.redeem_rounded),
                label: const Text('Ver compra pendiente'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.color,
    required this.emoji,
    required this.title,
    required this.price,
    required this.onTap,
  });

  final Color color;
  final String emoji;
  final String title;
  final int price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      color: color,
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 55)),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  '🪙 $price monedas',
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
