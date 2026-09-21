import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../common/navigation.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import 'tasks_controller.dart';

/// Shown to a task's author to accept or withdraw a pending counter-offer.
/// The counter's actual amount lives on a TaskVote row, which has no read
/// endpoint yet — so this can drive the real decision, but can't yet show
/// what price was offered.
class CounterOfferDecisionScreen extends StatelessWidget {
  const CounterOfferDecisionScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DetailScaffold(
      status: StatusPill(
        label: l10n.counterOfferPausedStatus,
        color: const Color(0xFFFFDFA0),
      ),
      title: task.title,
      content: [
        InfoRow(
          icon: Icons.restart_alt_rounded,
          text: l10n.counterOfferDecisionNotice,
        ),
      ],
      actions: [
        FilledButton(
          onPressed: () => _respond(context, true),
          child: Text(l10n.acceptCounterOffer),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => _respond(context, false),
          child: Text(l10n.withdrawNoFine),
        ),
      ],
    );
  }

  Future<void> _respond(BuildContext context, bool accept) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<TasksController>();
    try {
      await controller.respondToCounterOffer(task.id!, accept);
      if (context.mounted) {
        showSnack(
          context,
          accept ? l10n.counterOfferAccepted : l10n.proposalWithdrawn,
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        showSnack(context, l10n.counterOfferDecisionError);
      }
    }
  }
}
