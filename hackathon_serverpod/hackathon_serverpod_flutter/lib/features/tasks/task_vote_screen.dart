import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/feedback.dart';
import '../../ui/sounds.dart';
import 'counter_offer_decision_screen.dart';
import 'counter_offer_sheet.dart';
import 'tasks_controller.dart';

class TaskVoteScreen extends StatelessWidget {
  const TaskVoteScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DetailScaffold(
      status: StatusPill(
        label: l10n.waitingYourVote,
        color: const Color(0xFFE2DCFF),
      ),
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
        if (task.voteClosesAt != null) ...[
          const SizedBox(height: 12),
          InfoRow(
            icon: Icons.schedule_rounded,
            text: _remaining(l10n, task.voteClosesAt!),
          ),
        ],
      ],
      actions: [
        AppButton(label: l10n.approve, onPressed: () => _vote(context, true)),
        const SizedBox(height: 10),
        AppButton(
          label: l10n.counterOffer,
          kind: AppButtonKind.secondary,
          onPressed: () => _counterOffer(context),
        ),
        AppButton(
          label: l10n.reject,
          kind: AppButtonKind.danger,
          onPressed: () => _vote(context, false),
        ),
      ],
    );
  }

  String _remaining(AppLocalizations l10n, DateTime closesAt) {
    final left = closesAt.difference(DateTime.now());
    if (left.isNegative) return l10n.votingClosingSoon;
    return l10n.remainingTime(left.inHours, left.inMinutes % 60);
  }

  Future<void> _vote(BuildContext context, bool approve) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<TasksController>();
    try {
      await controller.voteTaskProposal(task.id!, approve);
      if (context.mounted) {
        showMessage(
          context,
          approve ? l10n.voteApproved : l10n.voteRejected,
          sound: AppSound.success,
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) showMessage(context, l10n.voteError, isError: true);
    }
  }

  Future<void> _counterOffer(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<TasksController>();
    final sent = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CounterOfferSheet(initialValue: task.reward),
    );
    if (sent == null || !context.mounted) return;
    try {
      final updated = await controller.counterOfferTask(task.id!, sent);
      if (context.mounted) {
        pushPage(context, CounterOfferDecisionScreen(task: updated));
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(context, l10n.counterOfferError, isError: true);
      }
    }
  }
}
