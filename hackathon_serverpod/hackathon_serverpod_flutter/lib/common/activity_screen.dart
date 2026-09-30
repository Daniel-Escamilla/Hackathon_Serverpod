import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import '../features/activity/activity_controller.dart';
import '../features/activity/activity_text.dart';
import '../features/group/group_controller.dart';
import '../home_shell.dart';
import '../l10n/generated/app_localizations.dart';
import '../ui/pressable.dart';

/// What the other members did while the app was open (#157), newest first.
/// Opening it marks everything read, which clears the bell's dot (#156).
/// Tapping a notice goes to the tab where its task, reward or member is.
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ActivityController?>()?.markAllRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = context.watch<ActivityController?>()?.items ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.activityTitle)),
      body: items.isEmpty
          ? const _Empty()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _Notice(event: items[i]),
            ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.event});

  final GroupEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final members = context.watch<GroupController?>()?.members ?? const [];
    final name =
        members
            .firstWhereOrNull((m) => m.id == event.actorMemberId)
            ?.displayName ??
        l10n.activitySomeone;
    return Pressable(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.read<HomeTabController?>()?.goTo(event.tab);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.palette.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: event.color.withValues(alpha: .15),
              child: Icon(event.icon, color: event.color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.sentence(l10n, name),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeAgo(l10n, event.occurredAt, DateTime.now()),
                    style: TextStyle(color: context.palette.muted),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: context.palette.muted),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: context.palette.muted,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.activityEmptyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.palette.muted),
            ),
          ],
        ),
      ),
    );
  }
}
