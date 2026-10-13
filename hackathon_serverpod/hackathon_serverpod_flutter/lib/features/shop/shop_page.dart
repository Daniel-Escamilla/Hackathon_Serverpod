import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../ui/empty_state.dart';
import '../../ui/app_animation.dart';
import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/feedback.dart';
import '../../ui/failure_messages.dart';
import '../../ui/sounds.dart';
import '../../ui/trash_button.dart';
import '../group/group_controller.dart';
import 'buy_reward_screen.dart';
import 'propose_reward_screen.dart';
import 'purchase_screen.dart';
import 'reward_vote_screen.dart';
import 'shop_controller.dart';
import 'reward_titles.dart';

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
      return const AppLoading();
    }
    if (controller.error != null && controller.rewards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLottie(AppAnimation.offline, size: 140),
              Text(l10n.shopLoadError, textAlign: TextAlign.center),
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

    final group = context.watch<GroupController>();
    final myMemberId = group.myMemberId;
    final isAdmin = group.myMember?.role == GroupMemberRole.admin;
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
        title: switch (controller.rewardFor(purchase)) {
          final reward? => rewardTitle(l10n, reward.title),
          null => l10n.purchaseUnknownReward,
        },
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
              padding: const EdgeInsets.only(top: 20),
              child: Center(child: EmptyState(l10n.shopEmpty)),
            ),
          _RewardGrid(
            children: [
              for (final reward in active)
                _RewardCard(
                  color: AppColors.skyTint,
                  reward: reward,
                  onTap: () =>
                      pushPage(context, BuyRewardScreen(reward: reward)),
                ),
            ],
          ),
          if (proposed.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 6),
              child: Text(
                l10n.awaitingVoteSection,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _RewardGrid(
              children: [
                for (final reward in proposed)
                  _RewardCard(
                    color: const Color(0xFFE9E3FF),
                    reward: reward,
                    onTap: () =>
                        pushPage(context, RewardVoteScreen(reward: reward)),
                    // Whoever proposed it, or the admin, can take it back.
                    onWithdraw: reward.createdById == myMemberId || isAdmin
                        ? () => _withdraw(context, reward)
                        : null,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _withdraw(BuildContext context, RewardItem reward) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmAction(
      context,
      title: l10n.withdrawRewardTitle,
      body: l10n.withdrawRewardBody,
      action: l10n.withdrawAction,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await controller.withdrawReward(reward.id!);
      if (context.mounted) {
        showMessage(context, l10n.proposalWithdrawn, sound: AppSound.success);
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(
          context,
          failureMessage(e, l10n, fallback: l10n.withdrawError),
          isError: true,
        );
      }
    }
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

/// Rewards two to a row, each the same width whatever the screen and the
/// same height as its neighbour, so more of the shop fits at once.
class _RewardGrid extends StatelessWidget {
  const _RewardGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < children.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: children[i]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: i + 1 < children.length
                        ? children[i + 1]
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// A reward as a square-ish tile: its icon, its name and its price. The bin
/// sits in the corner for whoever may withdraw a proposal.
class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.color,
    required this.reward,
    required this.onTap,
    this.onWithdraw,
  });

  final Color color;
  final RewardItem reward;
  final VoidCallback onTap;

  /// Null when this member cannot withdraw the proposal.
  final VoidCallback? onWithdraw;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 168),
      child: SoftCard(
        color: color,
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        // A Builder so the circle and the title read the theme SoftCard sets
        // for the pastel, not the page's.
        child: Builder(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: context.palette.card,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: reward.icon == null
                        ? const Icon(
                            Icons.card_giftcard_rounded,
                            color: AppColors.violet,
                          )
                        : Text(
                            reward.icon!,
                            style: const TextStyle(fontSize: 26),
                          ),
                  ),
                  const Spacer(),
                  if (onWithdraw case final withdraw?)
                    TrashButton(
                      tooltip: l10n.withdrawProposalTooltip,
                      onTap: withdraw,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                rewardTitle(l10n, reward.title),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              const SizedBox(height: 8),
              Text(
                '🪙 ${l10n.rewardAmount(reward.price)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontFeatures: AppFonts.tabularFigures,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
