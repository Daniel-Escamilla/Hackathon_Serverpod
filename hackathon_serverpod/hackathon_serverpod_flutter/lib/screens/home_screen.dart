import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_failure.dart';
import '../data/wallet_repository.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../ui/coin_amount.dart';
import '../ui/failure_messages.dart';
import 'create_group_screen.dart';
import 'join_group_screen.dart';
import 'wallet_screen.dart';

/// What a signed-in member sees. Everything here comes from the server: the
/// balance is `WalletEndpoint.getBalance`, not a number typed into the widget.
///
/// The three tabs (Tareas, Tienda, Grupo) land next, each against its own
/// endpoint.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final balance = ref.watch(walletBalanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          // The balance rides the app bar wherever you are (PRODUCT.md §11),
          // and opens the wallet. It only appears once there is a figure:
          // before that there is nothing true to show.
          if (balance.value case final coins?)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const WalletScreen()),
                ),
                tooltip: l10n.walletTitle,
                icon: CoinAmount(
                  coins: coins,
                  size: 20,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: balance.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _onError(context, ref, error),
            data: (coins) => _Balance(coins: coins),
          ),
        ),
      ),
    );
  }

  /// The server refuses every call from someone with no active membership, so
  /// that failure is not an error to report — it is the "you have no group
  /// yet" state, and the way out of it is on screen.
  Widget _onError(BuildContext context, WidgetRef ref, Object error) {
    final noGroup =
        error is AppException && error.failure == AppFailure.noGroup;
    void reload() {
      ref.invalidate(walletBalanceProvider);
      ref.invalidate(walletHistoryProvider);
    }

    return noGroup
        ? _NoGroupYet(onJoined: reload)
        : _Failed(error: error, onRetry: reload);
  }
}

class _Balance extends StatelessWidget {
  const _Balance({required this.coins});

  final int coins;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CoinAmount(coins: coins, style: text.displaySmall, size: 40),
        const SizedBox(height: 8),
        Text(
          coins < 0 ? l10n.walletNegative : l10n.walletCoins,
          style: text.bodyLarge?.copyWith(color: appMuted),
        ),
      ],
    );
  }
}

class _NoGroupYet extends StatelessWidget {
  const _NoGroupYet({required this.onJoined});

  final VoidCallback onJoined;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.noGroupTitle, style: text.headlineMedium),
        const SizedBox(height: 12),
        Text(
          l10n.noGroupBody,
          style: text.bodyLarge?.copyWith(color: appMuted),
        ),
        const SizedBox(height: 28),
        FilledButton(
          onPressed: () => _open(context, const CreateGroupScreen()),
          child: Text(l10n.createGroupAction),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _open(context, const JoinGroupScreen()),
          child: Text(l10n.joinGroupAction),
        ),
      ],
    );
  }

  /// Both routes return true once the member belongs to a group, which is the
  /// signal to ask the server for the balance again.
  Future<void> _open(BuildContext context, Widget screen) async {
    final joined = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => screen));
    if (joined ?? false) onJoined();
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          failureMessage(error, l10n),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        TextButton(onPressed: onRetry, child: Text(l10n.retry)),
      ],
    );
  }
}
