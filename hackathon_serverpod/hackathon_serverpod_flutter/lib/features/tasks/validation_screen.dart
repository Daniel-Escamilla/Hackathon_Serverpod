import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/feedback.dart';
import '../../ui/sounds.dart';
import 'tasks_controller.dart';

/// A task someone has claimed as done, waiting for the group to confirm it
/// (PRODUCT.md §3). Approval pays the claimant; denial fines them and
/// reopens the task. The claimant cannot vote on their own claim.
class ValidationScreen extends StatelessWidget {
  const ValidationScreen({
    required this.task,
    required this.myMemberId,
    super.key,
  });

  final Task task;
  final int? myMemberId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isClaimant = myMemberId != null && myMemberId == task.doneById;

    return DetailScaffold(
      status: StatusPill(label: l10n.statusValidation, color: AppColors.lime),
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
        InfoRow(
          icon: Icons.how_to_vote_rounded,
          text: isClaimant ? l10n.validationYourOwn : l10n.validationQuestion,
        ),
      ],
      actions: isClaimant
          ? const []
          : [
              AppButton(
                label: l10n.validationApprove,
                onPressed: () => _vote(context, true),
              ),
              const SizedBox(height: 10),
              AppButton(
                label: l10n.validationDeny,
                kind: AppButtonKind.danger,
                onPressed: () => _deny(context),
              ),
            ],
    );
  }

  Future<void> _deny(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmAction(
      context,
      title: l10n.validationDenyTitle,
      body: l10n.validationDenyBody,
      action: l10n.validationDeny,
      destructive: true,
    );
    if (confirmed && context.mounted) await _vote(context, false);
  }

  Future<void> _vote(BuildContext context, bool approve) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<TasksController>();
    try {
      await controller.voteTaskCompletion(task.id!, approve);
      if (context.mounted) {
        showMessage(
          context,
          approve ? l10n.validationApproved : l10n.validationDenied,
          sound: AppSound.success,
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) showMessage(context, l10n.voteError, isError: true);
    }
  }
}
