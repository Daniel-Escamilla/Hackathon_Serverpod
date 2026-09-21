import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/wallet_repository.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../ui/failure_messages.dart';
import '../ui/movement_row.dart';

/// The balance and where it came from, both read from `WalletEndpoint`.
class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final balance = ref.watch(walletBalanceProvider);
    final history = ref.watch(walletHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.walletTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(walletBalanceProvider);
            ref.invalidate(walletHistoryProvider);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            children: [
              _BalanceCard(coins: balance.value),
              const SizedBox(height: 28),
              Text(
                l10n.walletMovements,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              switch (history) {
                AsyncLoading() => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                AsyncError(:final error) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(failureMessage(error, l10n)),
                ),
                AsyncValue(:final value?) when value.isEmpty => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    l10n.walletEmpty,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: appMuted),
                  ),
                ),
                AsyncValue(:final value?) => Column(
                  children: [
                    for (final movement in value)
                      MovementRow(movement: movement),
                  ],
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}

/// The balance, on the violet card the prototype uses for it. Shows a dash
/// until the figure arrives rather than a zero, which would read as a real
/// empty wallet.
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.coins});

  final int? coins;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: appViolet,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            coins?.toString() ?? '—',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 54,
              height: 1,
              fontWeight: FontWeight.w900,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            (coins ?? 0) < 0 ? l10n.walletNegative : l10n.walletCoins,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
