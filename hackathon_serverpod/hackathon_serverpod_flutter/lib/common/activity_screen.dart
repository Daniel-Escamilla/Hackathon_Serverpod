import 'package:flutter/material.dart';

import '../app_theme.dart';

/// The notification feed had canned, hardcoded entries pointing at task/shop
/// detail screens that now require a real Task/RewardItem. There's no
/// endpoint yet to list a member's actual activity, so this is an honest
/// empty state instead of fake notifications.
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Actividad')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: 48,
                color: AppColors.muted,
              ),
              SizedBox(height: 12),
              Text(
                'Todavía no hay un listado de actividad del servidor.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
