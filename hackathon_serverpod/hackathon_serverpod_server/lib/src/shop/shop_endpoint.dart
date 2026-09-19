import '../generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// List, propose, vote, buy and fulfil rewards (PRODUCT.md §6, §10.3). Bodies are stubs:
/// the contract (issue #53) lands ahead of the implementation.
class ShopEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// All rewards visible in the signed-in member's group shop.
  Future<List<RewardItem>> listRewards(Session session) async =>
      throw UnimplementedError();

  /// Propose a new reward. Starts `proposed` and goes to a vote in piso/pareja.
  Future<RewardItem> proposeReward(
    Session session,
    String title,
    String description,
    int price, {
    int? stock,
  }) async => throw UnimplementedError();

  /// Vote on a proposed reward.
  Future<void> voteReward(Session session, int itemId, bool approve) async =>
      throw UnimplementedError();

  /// A child asks for a reward with no price yet; a guardian sets it and publishes
  /// (PRODUCT.md §8).
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
  ) async => throw UnimplementedError();

  /// A guardian approves or denies a child's pending purchase.
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
  ) async => throw UnimplementedError();

  /// The provider marks an accepted purchase as fulfilled.
  Future<void> markDelivered(Session session, int purchaseId) async =>
      throw UnimplementedError();
}
