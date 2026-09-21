import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../tasks/tasks_controller.dart';
import 'wallet_controller.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletController>();
    final tasks = context.watch<TasksController>();
    return Column(
      children: [
        PageHeader(
          title: AppLocalizations.of(context).navWallet,
          showBalance: false,
        ),
        Expanded(
          child: _Body(wallet: wallet, tasks: tasks),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.wallet, required this.tasks});

  final WalletController wallet;
  final TasksController tasks;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (wallet.loading && wallet.history.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (wallet.error != null && wallet.history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.walletLoadError),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: wallet.load,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: wallet.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.violet,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${wallet.balance}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 54,
                          fontWeight: FontWeight.w900,
                          fontFeatures: AppFonts.tabularFigures,
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
                const Text('🪙', style: TextStyle(fontSize: 88)),
              ],
            ),
          ),
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
          for (final entry in wallet.history)
            _MovementRow(
              entry: entry,
              taskTitle: entry.taskId == null
                  ? null
                  : _taskTitle(entry.taskId!),
            ),
        ],
      ),
    );
  }

  String? _taskTitle(int taskId) {
    for (final task in tasks.tasks) {
      if (task.id == taskId) return task.title;
    }
    return null;
  }
}

class _MovementRow extends StatelessWidget {
  const _MovementRow({required this.entry, this.taskTitle});

  final CoinTransaction entry;
  final String? taskTitle;

  @override
  Widget build(BuildContext context) {
    final positive = entry.amount >= 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        child: Row(
          children: [
            Icon(_icon, color: AppColors.violet),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskTitle ?? _label(AppLocalizations.of(context)),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    _formatDate(entry.createdAt),
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${positive ? '+' : ''}${entry.amount}',
              style: TextStyle(
                color: positive ? const Color(0xFF16853C) : AppColors.coral,
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

  IconData get _icon => switch (entry.reason) {
    CoinTransactionReason.earned => Icons.task_alt_rounded,
    CoinTransactionReason.fined => Icons.warning_amber_rounded,
    CoinTransactionReason.spent => Icons.storefront_rounded,
    CoinTransactionReason.refunded => Icons.replay_rounded,
  };

  String _label(AppLocalizations l10n) => switch (entry.reason) {
    CoinTransactionReason.earned => l10n.reasonEarned,
    CoinTransactionReason.fined => l10n.reasonFined,
    CoinTransactionReason.spent => l10n.reasonSpent,
    CoinTransactionReason.refunded => l10n.reasonRefunded,
  };

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}, ${two(local.hour)}:${two(local.minute)}';
  }
}
