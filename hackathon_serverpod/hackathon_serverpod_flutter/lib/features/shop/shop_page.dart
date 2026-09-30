import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../group/group_controller.dart';
import 'buy_reward_screen.dart';
import 'propose_reward_screen.dart';
import 'purchase_screen.dart';
import 'reward_vote_screen.dart';
import 'shop_controller.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ShopController>();
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        PageHeader(title: l10n.navShop, subtitle: l10n.shopSubtitle),
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
    final l10n = AppLocalizations.of(context);
    if (!controller.hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.error != null && controller.rewards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.shopLoadError),
              const SizedBox(height: 12),
              AppButton(
                label: l10n.retry,
                kind: AppButtonKind.secondary,
                onPressed: controller.load,
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

    final myMemberId = context.watch<GroupController>().myMemberId;
    final live = controller.purchases.where(
      (p) =>
          p.status == PurchaseStatus.pendingApproval ||
          p.status == PurchaseStatus.pending ||
          p.status == PurchaseStatus.accepted,
    );
    final toFulfil = live.where((p) => p.providerId == myMemberId).toList();
    final bought = live.where((p) => p.buyerId == myMemberId).toList();
    Widget purchaseTile(Purchase purchase) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: _PurchaseTile(
        purchase: purchase,
        title:
            controller.rewardFor(purchase)?.title ?? l10n.purchaseUnknownReward,
        onTap: () => pushPage(
          context,
          PurchaseScreen(purchase: purchase, myMemberId: myMemberId),
        ),
      ),
    );

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton.filled(
              onPressed: () => pushPage(context, const ProposeRewardScreen()),
              tooltip: l10n.newRewardTitle,
              icon: const Icon(Icons.add_rounded),
            ),
          ),
          const SizedBox(height: 8),
          if (toFulfil.isNotEmpty) ...[
            _SectionTitle(l10n.purchasesToFulfil),
            for (final purchase in toFulfil) purchaseTile(purchase),
            const SizedBox(height: 8),
          ],
          if (bought.isNotEmpty) ...[
            _SectionTitle(l10n.purchasesMine),
            for (final purchase in bought) purchaseTile(purchase),
            const SizedBox(height: 8),
          ],
          if (active.isEmpty && proposed.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(child: Text(l10n.shopEmpty)),
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
                l10n.awaitingVoteSection,
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 6),
    child: Text(label, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _PurchaseTile extends StatelessWidget {
  const _PurchaseTile({
    required this.purchase,
    required this.title,
    required this.onTap,
  });

  final Purchase purchase;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          StatusPill(
            label: purchaseStatusLabel(l10n, purchase.status),
            color: purchaseStatusColor(purchase.status),
          ),
          const Icon(Icons.chevron_right_rounded),
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
                  '🪙 ${AppLocalizations.of(context).rewardAmount(reward.price)}',
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
