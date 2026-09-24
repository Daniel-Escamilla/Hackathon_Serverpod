import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:provider/provider.dart';

import '../../app_theme.dart';
import '../../common/navigation.dart';
import '../../common/result_screen.dart';
import '../../common/widgets.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../ui/app_button.dart';
import '../../ui/feedback.dart';
import '../../ui/pressable.dart';
import '../group/group_controller.dart';
import 'shop_controller.dart';

class BuyRewardScreen extends StatefulWidget {
  const BuyRewardScreen({required this.reward, super.key});

  final RewardItem reward;

  @override
  State<BuyRewardScreen> createState() => _BuyRewardScreenState();
}

class _BuyRewardScreenState extends State<BuyRewardScreen> {
  int? _selectedMemberId;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final group = context.watch<GroupController>();
    final myMemberId = group.myMemberId;
    final others = group.members.where((m) => m.id != myMemberId).toList();

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
        children: [
          Text(
            l10n.whoWillFulfil,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 22),
          SoftCard(
            color: const Color(0xFFE9E3FF),
            child: Row(
              children: [
                const Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.violet,
                  size: 40,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.reward.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Text(
                  '🪙 ${widget.reward.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFeatures: AppFonts.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (!group.hasLoaded)
            const Center(child: CircularProgressIndicator())
          else if (others.isEmpty)
            InfoRow(icon: Icons.info_outline_rounded, text: l10n.noOtherMembers)
          else ...[
            FieldLabel(l10n.selectMember),
            for (final member in others)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Pressable(
                  onTap: () => setState(() => _selectedMemberId = member.id),
                  sound: null,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _selectedMemberId == member.id
                            ? AppColors.violet
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.sky,
                          child: Text(
                            member.displayName.substring(0, 1).toUpperCase(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            member.displayName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Icon(
                          _selectedMemberId == member.id
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: _selectedMemberId == member.id
                              ? AppColors.violet
                              : AppColors.muted,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
          const SizedBox(height: 8),
          AppButton(
            label: l10n.rewardAmount(widget.reward.price),
            loading: _loading,
            onPressed: _selectedMemberId == null ? null : _submit,
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final providerId = _selectedMemberId;
    if (providerId == null) return;
    setState(() => _loading = true);
    final controller = context.read<ShopController>();
    try {
      await controller.purchaseReward(widget.reward.id!, providerId);
      if (mounted) {
        pushPage(
          context,
          ResultScreen(
            emoji: '🎁',
            title: l10n.purchaseSentTitle,
            message: l10n.purchaseSentMessage,
            value: l10n.rewardAmount(widget.reward.price),
            button: l10n.backToShop,
            homeIndex: 1,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        showMessage(context, l10n.purchaseError, isError: true);
      }
    }
  }
}
