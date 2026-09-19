import '../generated/protocol.dart';
import '../groups/current_member.dart';
import 'package:serverpod/serverpod.dart';

import 'shop_service.dart';

/// List, propose, vote, buy and fulfil rewards (PRODUCT.md §6, §10.3).
class ShopEndpoint extends Endpoint {
  final ShopService _shopService = const ShopService();

  @override
  bool get requireLogin => true;

  /// All rewards visible in the signed-in member's group shop.
  Future<List<RewardItem>> listRewards(Session session) async {
    final member = await currentGroupMember(session);
    return RewardItem.db.find(
      session,
      where: (t) => t.groupId.equals(member.groupId),
    );
  }

  /// Propose a new reward. Starts `proposed` and goes to a vote in piso/pareja.
  Future<RewardItem> proposeReward(
    Session session,
    String title,
    String description,
    int price, {
    int? stock,
  }) async {
    final member = await currentGroupMember(session);
    return RewardItem.db.insertRow(
      session,
      RewardItem(
        groupId: member.groupId,
        title: title,
        description: description,
        price: price,
        createdById: member.id!,
        stock: stock,
      ),
    );
  }

  /// Vote on a proposed reward.
  Future<void> voteReward(Session session, int itemId, bool approve) async {
    final member = await currentGroupMember(session);
    final item = await _findGroupReward(session, member, itemId);
    await _shopService.castVote(
      session,
      item: item,
      voter: member,
      approve: approve,
    );
  }

  /// A child asks for a reward with no price yet; a guardian sets it and publishes
  /// (PRODUCT.md §8). Family mode is out of MVP scope (PLAN.md §1).
  Future<RewardItem> requestWish(
    Session session,
    String title,
    String description,
  ) async => throw UnimplementedError();

  /// Buy a reward, choosing who among the other members fulfils it.
  Future<Purchase> purchaseReward(
    Session session,
    int itemId,
    int providerId,
  ) async {
    final member = await currentGroupMember(session);
    final item = await _findGroupReward(session, member, itemId);

    final provider = await GroupMember.db.findById(session, providerId);
    if (provider == null || provider.groupId != member.groupId) {
      throw StateError('Provider not found in your group.');
    }

    return _shopService.purchase(
      session,
      item: item,
      buyer: member,
      provider: provider,
    );
  }

  /// A guardian approves or denies a child's pending purchase. Family mode is out
  /// of MVP scope (PLAN.md §1).
  Future<void> approveChildPurchase(
    Session session,
    int purchaseId,
    bool approve,
  ) async => throw UnimplementedError();

  /// The chosen provider accepts or refuses a purchase. Refusing pays the fine and
  /// refunds the buyer.
  Future<void> respondToPurchase(
    Session session,
    int purchaseId,
    bool accept,
  ) async {
    final member = await currentGroupMember(session);
    final purchase = await _findGroupPurchase(session, member, purchaseId);
    if (purchase.providerId != member.id) {
      throw StateError(
        'Only the assigned provider can respond to this purchase.',
      );
    }

    final item = await RewardItem.db.findById(session, purchase.itemId);
    final group = await Group.db.findById(session, member.groupId);
    if (item == null || group == null) {
      throw StateError('Reward or group not found.');
    }

    await _shopService.respond(
      session,
      purchase: purchase,
      item: item,
      group: group,
      accept: accept,
    );
  }

  /// The provider marks an accepted purchase as fulfilled.
  Future<void> markDelivered(Session session, int purchaseId) async {
    final member = await currentGroupMember(session);
    final purchase = await _findGroupPurchase(session, member, purchaseId);
    if (purchase.providerId != member.id) {
      throw StateError(
        'Only the assigned provider can mark this purchase delivered.',
      );
    }

    await _shopService.markDelivered(session, purchase);
  }

  Future<RewardItem> _findGroupReward(
    Session session,
    GroupMember member,
    int itemId,
  ) async {
    final item = await RewardItem.db.findById(session, itemId);
    if (item == null || item.groupId != member.groupId) {
      throw StateError('Reward not found in your group.');
    }
    return item;
  }

  Future<Purchase> _findGroupPurchase(
    Session session,
    GroupMember member,
    int purchaseId,
  ) async {
    final purchase = await Purchase.db.findById(session, purchaseId);
    if (purchase == null || purchase.groupId != member.groupId) {
      throw StateError('Purchase not found in your group.');
    }
    return purchase;
  }
}
