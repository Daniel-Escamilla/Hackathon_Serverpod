import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/result_screen.dart';
import '../../common/widgets.dart';
import '../../data/app_failure.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import '../../ui/feedback.dart';
import 'tasks_controller.dart';

class AvailableTaskScreen extends StatelessWidget {
  const AvailableTaskScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DetailScaffold(
      status: StatusPill(label: l10n.statusAvailable, color: AppColors.lime),
      title: task.title,
      content: [
        BigValueCard(
          color: AppColors.lime,
          value: '${task.reward}',
          label: l10n.coinsLabel,
          icon: '🪙',
        ),
        const SizedBox(height: 16),
        InfoRow(icon: Icons.description_rounded, text: task.description),
        const SizedBox(height: 12),
        InfoRow(icon: Icons.info_outline_rounded, text: l10n.notReserved),
      ],
      actions: [
        AppButton(label: l10n.markDone, onPressed: () => _markDone(context)),
      ],
    );
  }

  Future<void> _markDone(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<TasksController>();
    try {
      await controller.markTaskDone(task.id!);
      if (context.mounted) {
        pushPage(
          context,
          ResultScreen(
            emoji: '✅',
            title: l10n.claimedTitle,
            message: l10n.claimedMessage,
            value: l10n.inValidationValue(task.reward),
            button: l10n.backToTasks,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(
          context,
          failureOf(e) == AppFailure.taskNotOpen
              ? l10n.claimTaken
              : failureMessage(e, l10n, fallback: l10n.claimError),
          isError: true,
        );
      }
    }
  }
}
