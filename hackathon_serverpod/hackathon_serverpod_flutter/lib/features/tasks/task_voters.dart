import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../group/group_controller.dart';
import 'tasks_controller.dart';

/// Who has voted in [task]'s open vote and how (PRODUCT.md §11). Follows the
/// controller, so a vote cast on another phone shows up as the stream
/// reloads it.
class TaskVoters extends StatelessWidget {
  const TaskVoters({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final votes = context.watch<TasksController>().votesFor(task.id!);
    final members = context.watch<GroupController>().members;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.votersTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (votes.isEmpty)
          Text(l10n.votersNone, style: const TextStyle(color: AppColors.muted))
        else
          for (final vote in votes)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    vote.approve
                        ? Icons.thumb_up_alt_rounded
                        : Icons.thumb_down_alt_rounded,
                    size: 18,
                    color: vote.approve ? AppColors.violet : AppColors.coral,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      members
                              .firstWhereOrNull((m) => m.id == vote.memberId)
                              ?.displayName ??
                          l10n.purchaseSomeone,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  StatusPill(
                    label: vote.counterReward != null
                        ? l10n.voteCounterOffer(vote.counterReward!)
                        : vote.approve
                        ? l10n.voteInFavour
                        : l10n.voteAgainst,
                    color: vote.approve
                        ? AppColors.lime
                        : AppColors.coral.withValues(alpha: .35),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
