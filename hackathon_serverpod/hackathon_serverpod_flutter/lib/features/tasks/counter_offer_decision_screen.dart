import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/feedback.dart';
import '../../ui/sounds.dart';
import 'task_voters.dart';
import 'tasks_controller.dart';

/// Shown to a task's author to accept or withdraw a pending counter-offer.
/// The counter's actual amount lives on a TaskVote row, which has no read
/// endpoint yet — so this can drive the real decision, but can't yet show
/// what price was offered.
class CounterOfferDecisionScreen extends StatelessWidget {
  const CounterOfferDecisionScreen({
    required this.task,
    required this.myMemberId,
    super.key,
  });

  final Task task;
  final int? myMemberId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Only whoever proposed the task decides; everyone else waits (§4.3).
    final canDecide = myMemberId != null && task.proposedById == myMemberId;
    return DetailScaffold(
      status: StatusPill(
        label: l10n.counterOfferPausedStatus,
        color: const Color(0xFFFFDFA0),
      ),
      title: task.title,
      content: [
        InfoRow(
          icon: Icons.restart_alt_rounded,
          text: canDecide
              ? l10n.counterOfferDecisionNotice
              : l10n.counterOfferWaitingNotice,
        ),
        const SizedBox(height: 20),
        TaskVoters(task: task),
      ],
      actions: [
        if (canDecide) ...[
          AppButton(
            label: l10n.acceptCounterOffer,
            onPressed: () => _respond(context, true),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: l10n.withdrawNoFine,
            kind: AppButtonKind.secondary,
            onPressed: () => _respond(context, false),
          ),
        ],
      ],
    );
  }

  Future<void> _respond(BuildContext context, bool accept) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<TasksController>();
    try {
      await controller.respondToCounterOffer(task.id!, accept);
      if (context.mounted) {
        showMessage(
          context,
          accept ? l10n.counterOfferAccepted : l10n.proposalWithdrawn,
          sound: AppSound.success,
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(context, l10n.counterOfferDecisionError, isError: true);
      }
    }
  }
}
