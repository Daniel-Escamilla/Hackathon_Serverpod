import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../group/group_controller.dart';
import 'available_task_screen.dart';
import 'counter_offer_decision_screen.dart';
import 'task_vote_screen.dart';
import 'tasks_controller.dart';
import 'validation_screen.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TasksController>();
    return Column(
      children: [
        PageHeader(title: AppLocalizations.of(context).navTasks),
        Expanded(child: _Body(controller: controller)),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (!controller.hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.error != null && controller.tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.tasksLoadError),
              const SizedBox(height: 12),
              AppButton(
                label: l10n.retry,
                kind: AppButtonKind.secondary,
                onPressed: controller.load,
              ),
            ],
          ),
        ),
      );
    }

    final proposed = controller.tasks
        .where((t) => t.status == TaskStatus.proposed)
        .toList();
    final counterOffered = controller.tasks
        .where((t) => t.status == TaskStatus.counterOffered)
        .toList();
    final open = controller.tasks
        .where((t) => t.status == TaskStatus.open)
        .toList();
    final inValidation = controller.tasks
        .where((t) => t.status == TaskStatus.inValidation)
        .toList();
    final myMemberId = context.watch<GroupController>().myMemberId;

    if (controller.tasks.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.load,
        child: ListView(
          children: [
            const SizedBox(height: 140),
            Center(child: Text(l10n.tasksEmpty)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          if (proposed.isNotEmpty) ...[
            _SectionTitle(l10n.sectionAwaitingVote),
            for (final task in proposed)
              _TaskCard(
                task: task,
                statusLabel: l10n.statusProposal,
                statusColor: AppColors.sky,
                onTap: () => pushPage(context, TaskVoteScreen(task: task)),
              ),
          ],
          if (counterOffered.isNotEmpty) ...[
            _SectionTitle(l10n.sectionCounterOffered),
            for (final task in counterOffered)
              _TaskCard(
                task: task,
                statusLabel: l10n.statusCounterOffer,
                statusColor: const Color(0xFFFFDFA0),
                onTap: () =>
                    pushPage(context, CounterOfferDecisionScreen(task: task)),
              ),
          ],
          if (open.isNotEmpty) ...[
            _SectionTitle(l10n.sectionAvailable),
            for (final task in open)
              _TaskCard(
                task: task,
                statusLabel: l10n.statusAvailable,
                statusColor: AppColors.lime,
                onTap: () => pushPage(context, AvailableTaskScreen(task: task)),
              ),
          ],
          if (inValidation.isNotEmpty) ...[
            _SectionTitle(l10n.sectionInValidation),
            for (final task in inValidation)
              _TaskCard(
                task: task,
                statusLabel: l10n.statusValidation,
                statusColor: AppColors.coral.withValues(alpha: .35),
                onTap: () => pushPage(
                  context,
                  ValidationScreen(task: task, myMemberId: myMemberId),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 6),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.statusLabel,
    required this.statusColor,
    required this.onTap,
  });

  final Task task;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SoftCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.sky.withValues(alpha: .36),
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.task_alt_rounded,
                color: AppColors.violet,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '🪙 ${AppLocalizations.of(context).rewardAmount(task.reward)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontFeatures: AppFonts.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: 9),
                  StatusPill(label: statusLabel, color: statusColor),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
          ],
        ),
      ),
    );
  }
}
