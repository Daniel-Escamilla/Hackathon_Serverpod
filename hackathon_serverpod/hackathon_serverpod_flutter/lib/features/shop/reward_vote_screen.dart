import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/failure_messages.dart';
import '../../ui/feedback.dart';
import '../../ui/sounds.dart';
import 'shop_controller.dart';

class RewardVoteScreen extends StatelessWidget {
  const RewardVoteScreen({required this.reward, super.key});

  final RewardItem reward;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DetailScaffold(
      status: StatusPill(
        label: l10n.awaitingYourVote,
        color: const Color(0xFFE2DCFF),
      ),
      title: reward.title,
      content: [
        BigValueCard(
          color: AppColors.sky,
          value: '${reward.price}',
          label: l10n.coinsLabel,
          icon: '🪙',
        ),
        const SizedBox(height: 14),
        InfoRow(icon: Icons.description_rounded, text: reward.description),
      ],
      actions: [
        AppButton(
          label: l10n.approveReward,
          onPressed: () => _vote(context, true),
        ),
        const SizedBox(height: 10),
        AppButton(
          label: l10n.reject,
          kind: AppButtonKind.danger,
          onPressed: () => _vote(context, false),
        ),
      ],
    );
  }

  Future<void> _vote(BuildContext context, bool approve) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<ShopController>();
    try {
      await controller.voteReward(reward.id!, approve);
      if (context.mounted) {
        showMessage(
          context,
          approve ? l10n.rewardApproved : l10n.rewardRejected,
          sound: AppSound.success,
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(
          context,
          failureMessage(e, l10n, fallback: l10n.voteError),
          isError: true,
        );
      }
    }
  }
}
