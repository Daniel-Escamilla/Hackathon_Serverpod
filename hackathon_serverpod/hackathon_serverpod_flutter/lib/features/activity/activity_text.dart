import 'package:flutter/material.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../app_theme.dart';
import '../../home_shell.dart';
import '../../l10n/generated/app_localizations.dart';

/// What a notice says, shared by the Activity list and the live notice
/// (#158). The switches have no wildcard on purpose: a new event kind fails
/// the build here until someone decides how it reads.
extension GroupEventText on GroupEvent {
  String sentence(AppLocalizations l10n, String name) => switch (kind) {
    GroupEventKind.taskProposed => l10n.activityTaskProposed(name),
    GroupEventKind.taskVoteCast => l10n.activityTaskVoteCast(name),
    GroupEventKind.taskCounterOffered => l10n.activityTaskCounterOffered(name),
    GroupEventKind.taskClaimed => l10n.activityTaskClaimed(name),
    GroupEventKind.taskValidated => l10n.activityTaskValidated(name),
    GroupEventKind.rewardProposed => l10n.activityRewardProposed(name),
    GroupEventKind.rewardVoteCast => l10n.activityRewardVoteCast(name),
    GroupEventKind.purchased => l10n.activityPurchased(name),
    GroupEventKind.purchaseResponded => l10n.activityPurchaseResponded(name),
    GroupEventKind.purchaseDelivered => l10n.activityPurchaseDelivered(name),
    GroupEventKind.memberExpelled => l10n.activityMemberExpelled(name),
    GroupEventKind.memberUpdated => l10n.activityMemberUpdated(name),
    GroupEventKind.memberLeft => l10n.activityMemberLeft(name),
  };

  IconData get icon => switch (kind) {
    GroupEventKind.taskProposed => Icons.add_task_rounded,
    GroupEventKind.taskVoteCast ||
    GroupEventKind.taskValidated ||
    GroupEventKind.rewardVoteCast => Icons.how_to_vote_rounded,
    GroupEventKind.taskCounterOffered => Icons.swap_horiz_rounded,
    GroupEventKind.taskClaimed => Icons.task_alt_rounded,
    GroupEventKind.rewardProposed => Icons.card_giftcard_rounded,
    GroupEventKind.purchased ||
    GroupEventKind.purchaseResponded => Icons.shopping_bag_rounded,
    GroupEventKind.purchaseDelivered => Icons.redeem_rounded,
    GroupEventKind.memberExpelled => Icons.person_remove_rounded,
    GroupEventKind.memberUpdated => Icons.face_rounded,
    GroupEventKind.memberLeft => Icons.logout_rounded,
  };

  Color get color => switch (kind) {
    GroupEventKind.taskProposed ||
    GroupEventKind.taskVoteCast ||
    GroupEventKind.taskCounterOffered ||
    GroupEventKind.taskClaimed ||
    GroupEventKind.taskValidated => AppColors.violet,
    GroupEventKind.rewardProposed ||
    GroupEventKind.rewardVoteCast ||
    GroupEventKind.purchased ||
    GroupEventKind.purchaseResponded ||
    GroupEventKind.purchaseDelivered => AppColors.coral,
    GroupEventKind.memberExpelled ||
    GroupEventKind.memberUpdated ||
    GroupEventKind.memberLeft => AppColors.muted,
  };

  /// The tab where what the notice is about lives.
  int get tab => switch (kind) {
    GroupEventKind.taskProposed ||
    GroupEventKind.taskVoteCast ||
    GroupEventKind.taskCounterOffered ||
    GroupEventKind.taskClaimed ||
    GroupEventKind.taskValidated => HomeTabController.tasks,
    GroupEventKind.rewardProposed ||
    GroupEventKind.rewardVoteCast ||
    GroupEventKind.purchased ||
    GroupEventKind.purchaseResponded ||
    GroupEventKind.purchaseDelivered => HomeTabController.shop,
    GroupEventKind.memberExpelled ||
    GroupEventKind.memberUpdated ||
    GroupEventKind.memberLeft => HomeTabController.group,
  };
}

/// "Ahora mismo", "Hace 5 min", "Hace 2 h". A session is short, so no days.
String timeAgo(AppLocalizations l10n, DateTime when, DateTime now) {
  final elapsed = now.difference(when);
  if (elapsed.inMinutes < 1) return l10n.activityJustNow;
  if (elapsed.inHours < 1) return l10n.activityMinutesAgo(elapsed.inMinutes);
  return l10n.activityHoursAgo(elapsed.inHours);
}
