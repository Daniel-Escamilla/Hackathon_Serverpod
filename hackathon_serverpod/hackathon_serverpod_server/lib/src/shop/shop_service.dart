import 'package:serverpod/serverpod.dart';

import '../events/event_service.dart';
import '../generated/protocol.dart';
import '../wallet/wallet_service.dart';
import 'reward_templates.dart';

/// Voting, buying and fulfilling rewards (PRODUCT.md §4.1, §4.4, §6).
class ShopService {
  const ShopService({
    this.walletService = const WalletService(),
    this.eventService = const EventService(),
  });

  final WalletService walletService;
  final EventService eventService;

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
  ///
  /// Reads [item] locked, in the same transaction as the vote and the
  /// recount: otherwise on a double tap both calls find no vote yet, both
  /// insert, and the second fails on the unique (itemId, memberId) index
  /// with a server error instead of just updating the vote (#101).
  Future<RewardItem> castVote(
    Session session, {
    required RewardItem item,
    required GroupMember voter,
    required bool approve,
  }) {
    return session.db.transaction((transaction) async {
      final locked = await RewardItem.db.findById(
        session,
        item.id!,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (locked == null || locked.status != RewardItemStatus.proposed) {
        throw ShopException(reason: ShopErrorReason.rewardNotOpen);
      }
      if (voter.id == locked.createdById) {
        throw ShopException(reason: ShopErrorReason.ownReward);
      }

      final existingVote = await RewardVote.db.findFirstRow(
        session,
        where: (t) =>
            t.itemId.equals(locked.id!) & t.memberId.equals(voter.id!),
        transaction: transaction,
      );
      if (existingVote == null) {
        await RewardVote.db.insertRow(
          session,
          RewardVote(itemId: locked.id!, memberId: voter.id!, approve: approve),
          transaction: transaction,
        );
      } else {
        await RewardVote.db.updateRow(
          session,
          existingVote.copyWith(approve: approve),
          transaction: transaction,
        );
      }

      final otherMembers = await GroupMember.db.count(
        session,
        where: (t) =>
            t.groupId.equals(locked.groupId) &
            t.leftAt.equals(null) &
            t.id.notEquals(locked.createdById),
        transaction: transaction,
      );
      final needed = (otherMembers / 2).ceil();

      final votes = await RewardVote.db.find(
        session,
        where: (t) => t.itemId.equals(locked.id!),
        transaction: transaction,
      );
      final approveCount = votes.where((v) => v.approve).length;
      final denyCount = votes.length - approveCount;

      RewardItemStatus? resolution;
      if (approveCount >= needed) {
        resolution = RewardItemStatus.active;
      } else if (denyCount > otherMembers - needed) {
        resolution = RewardItemStatus.rejected;
      }

      if (resolution == null) return locked;
      return RewardItem.db.updateRow(
        session,
        locked.copyWith(status: resolution),
        transaction: transaction,
      );
    });
  }

  /// Buys [item] for [buyer], to be fulfilled by [provider]. Decrements stock (if
  /// limited) and charges [buyer] in the same transaction as the [Purchase] row
  /// (PRODUCT.md §6).
  Future<Purchase> purchase(
    Session session, {
    required RewardItem item,
    required GroupMember buyer,
    required GroupMember provider,
  }) async {
    if (item.status != RewardItemStatus.active) {
      throw ShopException(reason: ShopErrorReason.rewardNotAvailable);
    }
    if (provider.id == buyer.id) {
      throw ShopException(reason: ShopErrorReason.invalidProvider);
    }
    if (buyer.balance < 0) {
      throw ShopException(reason: ShopErrorReason.negativeBalance);
    }
    if (item.stock != null && item.stock! <= 0) {
      throw ShopException(reason: ShopErrorReason.outOfStock);
    }

    final purchase = await session.db.transaction((transaction) async {
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
    await eventService.publish(
      session,
      groupId: item.groupId,
      kind: GroupEventKind.purchased,
      purchaseId: purchase.id,
    );
    return purchase;
  }

  /// The provider accepts or refuses [purchase]. Refusing fines the provider,
  /// refunds the buyer and restores stock (PRODUCT.md §4.4, §6).
  ///
  /// Reads the purchase locked and checks `pending` on that row: a double tap
  /// on "refuse" otherwise lets both calls pass the check before either
  /// commits, fining the provider and refunding the buyer twice (#101).
  Future<void> respond(
    Session session, {
    required Purchase purchase,
    required RewardItem item,
    required Group group,
    required bool accept,
  }) async {
    await session.db.transaction((transaction) async {
      final locked = await Purchase.db.findById(
        session,
        purchase.id!,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (locked == null || locked.status != PurchaseStatus.pending) {
        throw ShopException(reason: ShopErrorReason.purchaseNotOpen);
      }

      if (accept) {
        await Purchase.db.updateRow(
          session,
          locked.copyWith(status: PurchaseStatus.accepted),
          transaction: transaction,
        );
        return;
      }

      await Purchase.db.updateRow(
        session,
        locked.copyWith(status: PurchaseStatus.refused),
        transaction: transaction,
      );

      final lockedItem = await RewardItem.db.findById(
        session,
        item.id!,
        transaction: transaction,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (lockedItem?.stock != null) {
        await RewardItem.db.updateRow(
          session,
          lockedItem!.copyWith(stock: lockedItem.stock! + 1),
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
      throw ShopException(reason: ShopErrorReason.purchaseNotOpen);
    }
    return Purchase.db.updateRow(
      session,
      purchase.copyWith(status: PurchaseStatus.delivered),
    );
  }
}
