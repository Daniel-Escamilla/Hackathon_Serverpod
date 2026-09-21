import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';
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
        const PageHeader(title: 'Cartera', showBalance: false),
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
              const Text('No se pudo cargar la cartera.'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: wallet.load,
                child: const Text('Reintentar'),
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
                      const Text(
                        'monedas',
                        style: TextStyle(
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
            'Últimos movimientos',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          if (wallet.history.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: Text('Todavía no hay movimientos.')),
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
                    taskTitle ?? _label,
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

  String get _label => switch (entry.reason) {
    CoinTransactionReason.earned => 'Tarea completada',
    CoinTransactionReason.fined => 'Multa',
    CoinTransactionReason.spent => 'Compra en la tienda',
    CoinTransactionReason.refunded => 'Devolución',
  };

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}, ${two(local.hour)}:${two(local.minute)}';
  }
}
