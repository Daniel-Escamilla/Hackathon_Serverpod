import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';

/// One line of the coin history: what kind of movement it was, when, and how
/// much it moved.
///
/// The server sends the reason and the id of the task or purchase behind it,
/// but not their titles, so this says "Tarea cobrada" rather than naming the
/// task. Give it a richer row the day the endpoint returns one.
class MovementRow extends StatelessWidget {
  const MovementRow({super.key, required this.movement});

  final CoinTransaction movement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final materialL10n = MaterialLocalizations.of(context);
    final at = movement.createdAt.toLocal();
    final positive = movement.amount >= 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_reason(l10n), style: text.titleMedium),
                const SizedBox(height: 2),
                Text(
                  l10n.movementAt(
                    materialL10n.formatShortDate(at),
                    materialL10n.formatTimeOfDay(TimeOfDay.fromDateTime(at)),
                  ),
                  style: text.bodyLarge?.copyWith(
                    fontSize: 14,
                    color: appMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${positive ? '+' : '−'}${movement.amount.abs()}',
            style: text.titleLarge?.copyWith(
              color: positive ? appInk : appCoral,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  String _reason(AppLocalizations l10n) => switch (movement.reason) {
    CoinTransactionReason.earned => l10n.reasonEarned,
    CoinTransactionReason.fined => l10n.reasonFined,
    CoinTransactionReason.spent => l10n.reasonSpent,
    CoinTransactionReason.refunded => l10n.reasonRefunded,
  };
}
