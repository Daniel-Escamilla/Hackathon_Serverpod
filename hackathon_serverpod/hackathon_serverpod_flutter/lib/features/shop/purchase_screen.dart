import 'package:collection/collection.dart';
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
import '../group/group_controller.dart';
import 'shop_controller.dart';

/// One purchase, seen by whoever bought it or whoever has to fulfil it
/// (PRODUCT.md §6). Only the provider acts on it: accept or refuse while it
/// is pending, and mark it delivered once accepted. The buyer just follows
/// where it stands.
class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({
    required this.purchase,
    required this.myMemberId,
    super.key,
  });

  final Purchase purchase;
  final int? myMemberId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reward = context.watch<ShopController>().rewardFor(purchase);
    final members = context.watch<GroupController>().members;
    String nameOf(int id) =>
        members.firstWhereOrNull((m) => m.id == id)?.displayName ??
        l10n.purchaseSomeone;

    final isProvider = purchase.providerId == myMemberId;

    return DetailScaffold(
      status: StatusPill(
        label: purchaseStatusLabel(l10n, purchase.status),
        color: purchaseStatusColor(purchase.status),
      ),
      title: reward?.title ?? l10n.purchaseUnknownReward,
      content: [
        if (reward != null) ...[
          BigValueCard(
            color: AppColors.sky,
            value: '${reward.price}',
            label: l10n.coinsLabel,
            icon: '🪙',
          ),
          const SizedBox(height: 16),
        ],
        InfoRow(
          icon: Icons.shopping_bag_rounded,
          text: l10n.purchaseBoughtBy(nameOf(purchase.buyerId)),
        ),
        const SizedBox(height: 10),
        InfoRow(
          icon: Icons.volunteer_activism_rounded,
          text: l10n.purchaseProvidedBy(nameOf(purchase.providerId)),
        ),
        if (isProvider && purchase.status == PurchaseStatus.pending) ...[
          const SizedBox(height: 10),
          InfoRow(
            icon: Icons.warning_amber_rounded,
            text: l10n.purchaseRefuseNotice,
          ),
        ],
      ],
      actions: [
        if (isProvider && purchase.status == PurchaseStatus.pending) ...[
          AppButton(
            label: l10n.purchaseAccept,
            onPressed: () => _respond(context, true),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: l10n.purchaseRefuse,
            kind: AppButtonKind.danger,
            onPressed: () => _refuse(context),
          ),
        ],
        if (isProvider && purchase.status == PurchaseStatus.accepted)
          AppButton(
            label: l10n.purchaseMarkDelivered,
            onPressed: () => _deliver(context),
          ),
      ],
    );
  }

  Future<void> _refuse(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await confirmAction(
      context,
      title: l10n.purchaseRefuseTitle,
      body: l10n.purchaseRefuseNotice,
      action: l10n.purchaseRefuse,
      destructive: true,
    );
    if (confirmed && context.mounted) await _respond(context, false);
  }

  Future<void> _respond(BuildContext context, bool accept) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<ShopController>();
    try {
      await controller.respondToPurchase(purchase.id!, accept);
      if (context.mounted) {
        showMessage(
          context,
          accept ? l10n.purchaseAccepted : l10n.purchaseRefused,
          sound: accept ? AppSound.success : AppSound.fine,
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(context, failureMessage(e, l10n), isError: true);
      }
    }
  }

  Future<void> _deliver(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = context.read<ShopController>();
    try {
      await controller.markDelivered(purchase.id!);
      if (context.mounted) {
        showMessage(context, l10n.purchaseDelivered, sound: AppSound.success);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        showMessage(context, failureMessage(e, l10n), isError: true);
      }
    }
  }
}

String purchaseStatusLabel(AppLocalizations l10n, PurchaseStatus status) =>
    switch (status) {
      PurchaseStatus.pendingApproval => l10n.purchaseStatusPendingApproval,
      PurchaseStatus.pending => l10n.purchaseStatusPending,
      PurchaseStatus.accepted => l10n.purchaseStatusAccepted,
      PurchaseStatus.delivered => l10n.purchaseStatusDelivered,
      PurchaseStatus.refused => l10n.purchaseStatusRefused,
    };

Color purchaseStatusColor(PurchaseStatus status) => switch (status) {
  PurchaseStatus.pendingApproval || PurchaseStatus.pending => AppColors.sky,
  PurchaseStatus.accepted => AppColors.lime,
  PurchaseStatus.delivered => Colors.white,
  PurchaseStatus.refused => AppColors.coral.withValues(alpha: .35),
};
