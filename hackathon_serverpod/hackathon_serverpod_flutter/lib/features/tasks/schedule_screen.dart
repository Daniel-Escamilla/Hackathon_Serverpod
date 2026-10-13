import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import '../../ui/feedback.dart';
import '../../ui/sounds.dart';
import '../../ui/trash_button.dart';
import '../../ui/weekday_picker.dart';
import '../group/group_controller.dart';
import 'propose_task_screen.dart';
import 'tasks_controller.dart';

/// The home's schedule (PRODUCT.md §5): each weekday with the set tasks
/// that appear on the board that day, and those still being voted on.
/// Whoever proposed one, or the admin, takes it off with the bin.
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = context.watch<TasksController>();
    final group = context.watch<GroupController>();
    final me = group.myMemberId;
    final isAdmin = group.myMember?.role == GroupMemberRole.admin;
    bool canStop(Task t) => isAdmin || (me != null && t.proposedById == me);

    Widget row(Task task) => _ScheduledTile(
      task: task,
      onStop: canStop(task) ? () => _stop(context, task) : null,
    );

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  children: [
                    Text(
                      l10n.scheduleTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.scheduleSubtitle,
                      style: TextStyle(color: context.palette.muted),
                    ),
                    const SizedBox(height: 22),
                    for (var day = 1; day <= 7; day++) ...[
                      _DayHeader(weekdayName(context, day)),
                      ...switch (controller.scheduled
                          .where((t) => t.weekdays?.contains(day) ?? false)
                          .toList()) {
                        final tasks when tasks.isEmpty => [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              l10n.scheduleNothing,
                              style: TextStyle(color: context.palette.muted),
                            ),
                          ),
                        ],
                        final tasks => tasks.map(row),
                      },
                    ],
                    if (controller.schedulePending.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _DayHeader(l10n.schedulePending),
                      for (final task in controller.schedulePending)
                        _ScheduledTile(task: task, onStop: null),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 22),
              child: AppButton(
                label: l10n.scheduleAdd,
                onPressed: () =>
                    pushPage(context, const ProposeTaskScreen(repeats: true)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _stop(BuildContext context, Task task) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<TasksController>();
    final confirmed = await confirmAction(
      context,
      title: l10n.stopScheduleTitle,
      body: l10n.stopScheduleBody,
      action: l10n.stopScheduleAction,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    try {
      await controller.withdrawTask(task.id!);
      if (context.mounted) {
        showMessage(context, l10n.scheduleStopped, sound: AppSound.success);
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(
          context,
          failureMessage(e, l10n, fallback: l10n.withdrawError),
          isError: true,
        );
      }
    }
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, top: 4),
    child: Text(
      label[0].toUpperCase() + label.substring(1),
      style: Theme.of(context).textTheme.titleMedium,
    ),
  );
}

/// A set task: its icon, title, karmas and the days it comes back on. The
/// bin only for whoever may take it off the schedule.
class _ScheduledTile extends StatelessWidget {
  const _ScheduledTile({required this.task, required this.onStop});

  final Task task;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftCard(
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Center(
                child: task.icon == null
                    ? Icon(
                        Icons.event_repeat_rounded,
                        color: context.palette.accent,
                      )
                    : Text(task.icon!, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '🪙 ${l10n.rewardAmount(task.reward)} · '
                    '${weekdayList(context, task.weekdays ?? const [])}',
                    style: TextStyle(
                      color: context.palette.muted,
                      fontSize: 12,
                      fontFeatures: AppFonts.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
            if (onStop case final stop?)
              TrashButton(tooltip: l10n.stopScheduleAction, onTap: stop),
          ],
        ),
      ),
    );
  }
}
