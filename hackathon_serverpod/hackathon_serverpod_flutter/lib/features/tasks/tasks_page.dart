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

    final me = context.watch<GroupController>().myMemberId;
    bool voted(Task t) => controller.hasVoted(t, me);
    bool mine(Task t) => me != null && t.proposedById == me;
    bool claimedByMe(Task t) => me != null && t.doneById == me;

    // What needs something from this member comes first (PRODUCT.md §11):
    // proposals and validations they can still vote on, and counter-offers
    // on their own proposals, which only they can answer.
    final yourTurn = controller.tasks
        .where(
          (t) => switch (t.status) {
            TaskStatus.proposed => !mine(t) && !voted(t),
            TaskStatus.inValidation => !claimedByMe(t) && !voted(t),
            TaskStatus.counterOffered => mine(t),
            _ => false,
          },
        )
        .toList();
    final available = controller.tasks
        .where((t) => t.status == TaskStatus.open)
        .toList();
    final yoursInValidation = controller.tasks
        .where((t) => t.status == TaskStatus.inValidation && claimedByMe(t))
        .toList();
    // Still being decided, but nothing left for this member to do.
    final inVoting = controller.tasks
        .where(
          (t) =>
              const {
                TaskStatus.proposed,
                TaskStatus.counterOffered,
                TaskStatus.inValidation,
              }.contains(t.status) &&
              !yourTurn.contains(t) &&
              !yoursInValidation.contains(t),
        )
        .toList();

    if (yourTurn.isEmpty &&
        available.isEmpty &&
        yoursInValidation.isEmpty &&
        inVoting.isEmpty) {
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

    Widget card(Task task) => _TaskCard(
      task: task,
      statusLabel: _statusLabel(l10n, task.status),
      statusColor: _statusColor(task.status),
      onTap: () => pushPage(context, _detailFor(task, me)),
    );

    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        children: [
          if (yourTurn.isNotEmpty) ...[
            _SectionTitle(l10n.sectionAwaitingVote),
            for (final task in yourTurn) card(task),
          ],
          if (available.isNotEmpty) ...[
            _SectionTitle(l10n.sectionAvailable),
            for (final task in available) card(task),
          ],
          if (yoursInValidation.isNotEmpty) ...[
            _SectionTitle(l10n.sectionYoursInValidation),
            for (final task in yoursInValidation) card(task),
          ],
          if (inVoting.isNotEmpty) ...[
            _SectionTitle(l10n.sectionInVoting),
            for (final task in inVoting) card(task),
          ],
        ],
      ),
    );
  }

  Widget _detailFor(Task task, int? me) => switch (task.status) {
    TaskStatus.counterOffered => CounterOfferDecisionScreen(
      task: task,
      myMemberId: me,
    ),
    TaskStatus.open => AvailableTaskScreen(task: task),
    TaskStatus.inValidation => ValidationScreen(task: task, myMemberId: me),
    _ => TaskVoteScreen(task: task, myMemberId: me),
  };

  String _statusLabel(AppLocalizations l10n, TaskStatus status) =>
      switch (status) {
        TaskStatus.counterOffered => l10n.statusCounterOffer,
        TaskStatus.open => l10n.statusAvailable,
        TaskStatus.inValidation => l10n.statusValidation,
        _ => l10n.statusProposal,
      };

  Color _statusColor(TaskStatus status) => switch (status) {
    TaskStatus.counterOffered => const Color(0xFFFFDFA0),
    TaskStatus.open => AppColors.lime,
    TaskStatus.inValidation => AppColors.coral.withValues(alpha: .35),
    _ => AppColors.sky,
  };
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
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      StatusPill(label: statusLabel, color: statusColor),
                      if (task.voteClosesAt != null)
                        Text(
                          _timeLeft(
                            AppLocalizations.of(context),
                            task.voteClosesAt!,
                          ),
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            fontFeatures: AppFonts.tabularFigures,
                          ),
                        ),
                    ],
                  ),
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

String _timeLeft(AppLocalizations l10n, DateTime closesAt) {
  final left = closesAt.difference(DateTime.now());
  if (left.isNegative) return l10n.votingClosingSoon;
  return l10n.remainingTime(left.inHours, left.inMinutes % 60);
}
