import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../client.dart';

class ShopController extends ChangeNotifier {
  List<RewardItem> rewards = [];

  /// The purchases the signed-in member made or has to fulfil, newest first.
  List<Purchase> purchases = [];
  bool loading = false;
  bool hasLoaded = false;
  Object? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final (loadedRewards, loadedPurchases) = await (
        client.shop.listRewards(),
        client.shop.listPurchases(),
      ).wait;
      rewards = loadedRewards;
      purchases = loadedPurchases;
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      hasLoaded = true;
      notifyListeners();
    }
  }

  Future<RewardItem> proposeReward(
    String title,
    String description,
    int price,
  ) async {
    final reward = await client.shop.proposeReward(title, description, price);
    await load();
    return reward;
  }

  Future<void> voteReward(int itemId, bool approve) async {
    await client.shop.voteReward(itemId, approve);
    await load();
  }

  Future<Purchase> purchaseReward(int itemId, int providerId) async {
    final purchase = await client.shop.purchaseReward(itemId, providerId);
    await load();
    return purchase;
  }

  /// The chosen provider takes the purchase on, or refuses it and pays the
  /// fine; refusing refunds the buyer (PRODUCT.md §6).
  Future<void> respondToPurchase(int purchaseId, bool accept) async {
    await client.shop.respondToPurchase(purchaseId, accept);
    await load();
  }

  Future<void> markDelivered(int purchaseId) async {
    await client.shop.markDelivered(purchaseId);
    await load();
  }

  /// The reward a purchase is for, if it is still in the shop's list.
  RewardItem? rewardFor(Purchase purchase) =>
      rewards.where((r) => r.id == purchase.itemId).firstOrNull;
}
