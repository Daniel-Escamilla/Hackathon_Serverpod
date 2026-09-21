import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';

/// There is no endpoint yet for the completion vote — TaskEndpoint's
/// voteTaskProposal only accepts tasks in `proposed` status, so it can't be
/// reused here. Shows the real task while the action is blocked, instead of
/// wiring buttons that would always fail.
class ValidationScreen extends StatelessWidget {
  const ValidationScreen({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
        const SizedBox(height: 16),
        InfoRow(
          icon: Icons.construction_rounded,
          text: l10n.validationPendingNotice,
        ),
      ],
      actions: const [],
    );
  }
}
