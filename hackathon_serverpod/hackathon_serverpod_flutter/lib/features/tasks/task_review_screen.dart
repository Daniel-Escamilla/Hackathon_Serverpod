import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/app_animation.dart';
import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/result_screen.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/feedback.dart';
import '../../ui/weekday_picker.dart';
import 'tasks_controller.dart';

class TaskReviewScreen extends StatelessWidget {
  const TaskReviewScreen({
    required this.title,
    required this.description,
    required this.reward,
    this.icon,
    this.weekdays,
    super.key,
  });

  final String title;
  final String description;
  final int reward;
  final String? icon;

  /// Set for a task that repeats on these weekdays (1 = Monday).
  final List<int>? weekdays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DetailScaffold(
      status: StatusPill(label: l10n.reviewDealStatus, color: AppColors.sky),
      title: title,
      content: [
        BigValueCard(
          color: AppColors.lime,
          value: '$reward',
          label: l10n.coinsLabel,
          icon: '🪙',
        ),
        const SizedBox(height: 16),
        if (weekdays case final days?) ...[
          InfoRow(
            icon: Icons.event_repeat_rounded,
            text: l10n.repeatsOn(weekdayList(context, days)),
          ),
          const SizedBox(height: 10),
        ],
        InfoRow(icon: Icons.schedule_rounded, text: l10n.voteWindowNotice),
        const SizedBox(height: 10),
        InfoRow(icon: Icons.warning_amber_rounded, text: l10n.rejectFineNotice),
      ],
      actions: [
        AppButton(label: l10n.submitToVote, onPressed: () => _submit(context)),
      ],
    );
  }

  Future<void> _submit(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<TasksController>();
    try {
      await controller.proposeTask(
        title,
        description,
        reward,
        icon: icon,
        weekdays: weekdays,
      );
      if (context.mounted) {
        pushPage(
          context,
          ResultScreen(
            animation: AppAnimation.approved,
            title: l10n.sentToVoteTitle,
            message: l10n.sentToVoteMessage,
            value: l10n.rewardAmount(reward),
            button: l10n.backToTasks,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(context, l10n.proposeError, isError: true);
      }
    }
  }
}
