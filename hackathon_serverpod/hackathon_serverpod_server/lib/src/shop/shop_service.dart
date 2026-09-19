import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../wallet/wallet_service.dart';
import 'reward_templates.dart';

/// Voting, buying and fulfilling rewards (PRODUCT.md §4.1, §4.4, §6).
class ShopService {
  const ShopService({this.walletService = const WalletService()});

  final WalletService walletService;

  /// Copies the profile's reward templates into [group] as `active` items — they
  /// skip the vote that member-proposed rewards go through (PRODUCT.md §6). Family
  /// has no templates: out of MVP scope (PLAN.md §1).
  Future<void> seedRewardTemplates(
    Session session, {
    required Group group,
    required GroupMember createdBy,
    Transaction? transaction,
  }) async {
    final templates = rewardTemplatesByGroupType[group.type] ?? const [];
    for (final template in templates) {
      await RewardItem.db.insertRow(
        session,
        RewardItem(
          groupId: group.id!,
          title: template.title,
          description: '',
          price: template.price,
          status: RewardItemStatus.active,
          createdById: createdBy.id!,
        ),
        transaction: transaction,
      );
    }
  }

  /// Records [voter]'s vote on [item] and resolves it to `active`/`rejected` once
  /// the result can no longer change — the same majority rule as a task
  /// (PRODUCT.md §4.1: `ceil((members - 1) / 2)` approvals). A rejected reward
  /// carries no fine (PRODUCT.md §6).
  Future<RewardItem> castVote(
    Session session, {
    required RewardItem item,
    required GroupMember voter,
    required bool approve,
  }) async {
    if (item.status != RewardItemStatus.proposed) {
      throw StateError('This reward is not open for voting.');
    }
    if (voter.id == item.createdById) {
      throw StateError('The proposer cannot vote on their own reward.');
    }

    final existingVote = await RewardVote.db.findFirstRow(
      session,
      where: (t) => t.itemId.equals(item.id!) & t.memberId.equals(voter.id!),
    );
    if (existingVote == null) {
      await RewardVote.db.insertRow(
        session,
        RewardVote(itemId: item.id!, memberId: voter.id!, approve: approve),
      );
    } else {
      await RewardVote.db.updateRow(
        session,
        existingVote.copyWith(approve: approve),
      );
    }

    final otherMembers = await GroupMember.db.count(
      session,
      where: (t) =>
          t.groupId.equals(item.groupId) &
          t.leftAt.equals(null) &
          t.id.notEquals(item.createdById),
    );
    final needed = (otherMembers / 2).ceil();

    final votes = await RewardVote.db.find(
      session,
      where: (t) => t.itemId.equals(item.id!),
    );
    final approveCount = votes.where((v) => v.approve).length;
    final denyCount = votes.length - approveCount;

    RewardItemStatus? resolution;
    if (approveCount >= needed) {
      resolution = RewardItemStatus.active;
    } else if (denyCount > otherMembers - needed) {
      resolution = RewardItemStatus.rejected;
    }

    if (resolution == null) return item;
    return RewardItem.db.updateRow(session, item.copyWith(status: resolution));
  }

  /// Buys [item] for [buyer], to be fulfilled by [provider]. Decrements stock (if
  /// limited) and charges [buyer] in the same transaction as the [Purchase] row
  /// (PRODUCT.md §6).
  Future<Purchase> purchase(
    Session session, {
    required RewardItem item,
    required GroupMember buyer,
    required GroupMember provider,
  }) {
    if (item.status != RewardItemStatus.active) {
      throw StateError('This reward is not available.');
    }
    if (provider.id == buyer.id) {
      throw StateError('Choose someone else to fulfil the reward.');
    }
    if (buyer.balance < 0) {
      throw StateError('Cannot buy with a negative balance.');
    }
    if (item.stock != null && item.stock! <= 0) {
      throw StateError('This reward is out of stock.');
    }

    return session.db.transaction((transaction) async {
      if (item.stock != null) {
        await RewardItem.db.updateRow(
          session,
          item.copyWith(stock: item.stock! - 1),
          transaction: transaction,
        );
      }

      final purchase = await Purchase.db.insertRow(
        session,
        Purchase(
          groupId: item.groupId,
          itemId: item.id!,
          buyerId: buyer.id!,
          providerId: provider.id!,
        ),
        transaction: transaction,
      );

      await walletService.recordTransaction(
        session,
        groupId: item.groupId,
        memberId: buyer.id!,
        amount: -item.price,
        reason: CoinTransactionReason.spent,
        purchaseId: purchase.id,
        transaction: transaction,
      );

      return purchase;
    });
  }

  /// The provider accepts or refuses [purchase]. Refusing fines the provider,
  /// refunds the buyer and restores stock (PRODUCT.md §4.4, §6).
  Future<void> respond(
    Session session, {
    required Purchase purchase,
    required RewardItem item,
    required Group group,
    required bool accept,
  }) async {
    if (purchase.status != PurchaseStatus.pending) {
      throw StateError('This purchase is not pending a response.');
    }

    if (accept) {
      await Purchase.db.updateRow(
        session,
        purchase.copyWith(status: PurchaseStatus.accepted),
      );
      return;
    }

    await session.db.transaction((transaction) async {
      await Purchase.db.updateRow(
        session,
        purchase.copyWith(status: PurchaseStatus.refused),
        transaction: transaction,
      );

      if (item.stock != null) {
        await RewardItem.db.updateRow(
          session,
          item.copyWith(stock: item.stock! + 1),
          transaction: transaction,
        );
      }

      final fine = (item.price * group.finePercent / 100).ceil();
      await walletService.recordTransaction(
        session,
        groupId: item.groupId,
        memberId: purchase.providerId,
        amount: -fine,
        reason: CoinTransactionReason.fined,
        purchaseId: purchase.id,
        transaction: transaction,
      );

      await walletService.recordTransaction(
        session,
        groupId: item.groupId,
        memberId: purchase.buyerId,
        amount: item.price,
        reason: CoinTransactionReason.refunded,
        purchaseId: purchase.id,
        transaction: transaction,
      );
    });
  }

  /// The provider marks an accepted purchase as fulfilled.
  Future<Purchase> markDelivered(Session session, Purchase purchase) {
    if (purchase.status != PurchaseStatus.accepted) {
      throw StateError('Only an accepted purchase can be marked delivered.');
    }
    return Purchase.db.updateRow(
      session,
      purchase.copyWith(status: PurchaseStatus.delivered),
    );
  }
}
