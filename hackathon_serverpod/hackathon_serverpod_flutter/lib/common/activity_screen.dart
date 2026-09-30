import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../l10n/generated/app_localizations.dart';

/// The notification feed had canned, hardcoded entries pointing at task/shop
/// detail screens that now require a real Task/RewardItem. There's no
/// endpoint yet to list a member's actual activity, so this is an honest
/// empty state instead of fake notifications.
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.activityTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                size: 48,
                color: AppColors.muted,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.activityEmptyMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
