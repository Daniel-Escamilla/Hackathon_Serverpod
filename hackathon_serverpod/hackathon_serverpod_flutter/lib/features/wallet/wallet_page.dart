import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_animation.dart';
import '../../ui/app_button.dart';
import '../../ui/coin_amount.dart';
import 'wallet_controller.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletController>();
    return Column(
      children: [
        PageHeader(
          title: AppLocalizations.of(context).navWallet,
          showBalance: false,
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(child: _Body(wallet: wallet)),
              // Coins coming in, or a fine, played once over the balance.
              if (wallet.arrival case final arrival?)
                Align(
                  alignment: Alignment.topCenter,
                  child: IgnorePointer(
                    child: AppLottie(
                      arrival,
                      key: ValueKey(wallet.arrivalCount),
                      size: 180,
                      onFinished: wallet.arrivalShown,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.wallet});

  final WalletController wallet;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!wallet.hasLoaded) {
      return const AppLoading();
    }
    if (wallet.error != null && wallet.history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLottie(AppAnimation.offline, size: 140),
              Text(l10n.walletLoadError, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              AppButton(
                label: l10n.retry,
                kind: AppButtonKind.secondary,
                onPressed: wallet.load,
              ),
            ],
          ),
        ),
      );
    }
    final negative = wallet.balance < 0;
    return RefreshIndicator(
      onRefresh: wallet.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: negative ? AppColors.coral : AppColors.violet,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CoinAmount(
                        coins: wallet.balance,
                        size: 40,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        l10n.coinsLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const AppLottie(AppAnimation.karma, size: 104, repeat: true),
              ],
            ),
          ),
          if (negative) ...[
            const SizedBox(height: 14),
            InfoRow(
              icon: Icons.info_outline_rounded,
              text: l10n.negativeBalanceNotice,
            ),
          ],
          const SizedBox(height: 28),
          Text(
            l10n.recentMovements,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (wallet.history.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(child: Text(l10n.noMovements)),
            ),
          for (final movement in wallet.history)
            _MovementRow(movement: movement),
        ],
      ),
    );
  }
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({required this.movement});

  final CoinMovement movement;

  @override
  Widget build(BuildContext context) {
    final positive = movement.amount >= 0;
    final l10n = AppLocalizations.of(context);
    final badge = _badgeColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: badge, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Icon(
                _icon,
                size: 22,
                color: badge == AppColors.coral ? Colors.white : AppColors.ink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movement.title ?? _label(l10n),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    // The reason is the title already when there is no task
                    // or reward to name.
                    movement.title == null
                        ? _formatDate(movement.createdAt)
                        : '${_label(l10n)} · ${_formatDate(movement.createdAt)}',
                    style: TextStyle(
                      color: context.palette.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${positive ? '+' : ''}${movement.amount}',
              style: TextStyle(
                color: positive
                    ? context.palette.positive
                    : context.palette.danger,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                fontFeatures: AppFonts.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Lime for karma coming in, sky for karma spent in the shop, coral for
  /// every kind of fine.
  Color get _badgeColor => switch (movement.reason) {
    CoinTransactionReason.earned ||
    CoinTransactionReason.refunded => AppColors.lime,
    CoinTransactionReason.spent => AppColors.skyTint,
    CoinTransactionReason.fined ||
    CoinTransactionReason.proposalDenied ||
    CoinTransactionReason.validationDenied ||
    CoinTransactionReason.voteExpired => AppColors.coral,
  };

  IconData get _icon => switch (movement.reason) {
    CoinTransactionReason.earned => Icons.task_alt_rounded,
    CoinTransactionReason.fined => Icons.warning_amber_rounded,
    CoinTransactionReason.spent => Icons.storefront_rounded,
    CoinTransactionReason.refunded => Icons.replay_rounded,
    CoinTransactionReason.proposalDenied => Icons.thumb_down_alt_rounded,
    CoinTransactionReason.validationDenied => Icons.rule_rounded,
    CoinTransactionReason.voteExpired => Icons.timer_off_rounded,
  };

  String _label(AppLocalizations l10n) => switch (movement.reason) {
    CoinTransactionReason.earned => l10n.reasonEarned,
    CoinTransactionReason.fined => l10n.reasonFined,
    CoinTransactionReason.spent => l10n.reasonSpent,
    CoinTransactionReason.refunded => l10n.reasonRefunded,
    CoinTransactionReason.proposalDenied => l10n.reasonProposalDenied,
    CoinTransactionReason.validationDenied => l10n.reasonValidationDenied,
    CoinTransactionReason.voteExpired => l10n.reasonVoteExpired,
  };

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}, ${two(local.hour)}:${two(local.minute)}';
  }
}
