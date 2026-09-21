import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';

/// One line of the coin history: what it was for, what kind of movement, when,
/// and how much it moved.
///
/// The title is the task's or the reward's. A movement that points at nothing
/// — a fine for letting a vote expire — has none, and leads with its kind
/// instead.
class MovementRow extends StatelessWidget {
  const MovementRow({super.key, required this.movement});

  final CoinMovement movement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final materialL10n = MaterialLocalizations.of(context);
    final at = movement.createdAt.toLocal();
    final positive = movement.amount >= 0;

    final reason = _reason(l10n);
    final when = l10n.movementAt(
      materialL10n.formatShortDate(at),
      materialL10n.formatTimeOfDay(TimeOfDay.fromDateTime(at)),
    );
    final title = movement.title;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? reason, style: text.titleMedium),
                const SizedBox(height: 2),
                Text(
                  title == null ? when : l10n.movementDetail(reason, when),
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
