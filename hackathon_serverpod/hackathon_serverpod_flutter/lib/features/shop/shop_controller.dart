import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../data/shop_repository.dart';

class ShopController extends ChangeNotifier {
  ShopController({this.repository = const ShopRepository()});

  final ShopRepository repository;

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
      // Future.wait rethrows the first failure as it is; a record's `.wait`
      // would wrap it in a ParallelWaitError.
      final results = await Future.wait<Object>([
        repository.listRewards(),
        repository.listPurchases(),
      ]);
      final loadedRewards = results[0] as List<RewardItem>;
      final loadedPurchases = results[1] as List<Purchase>;
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
    final reward = await repository.proposeReward(title, description, price);
    await load();
    return reward;
  }

  Future<void> voteReward(int itemId, bool approve) async {
    await repository.voteReward(itemId, approve);
    await load();
  }

  Future<Purchase> purchaseReward(int itemId, int providerId) async {
    final purchase = await repository.purchaseReward(itemId, providerId);
    await load();
    return purchase;
  }

  /// The chosen provider takes the purchase on, or refuses it and pays the
  /// fine; refusing refunds the buyer (PRODUCT.md §6).
  Future<void> respondToPurchase(int purchaseId, bool accept) async {
    await repository.respondToPurchase(purchaseId, accept);
    await load();
  }

  Future<void> markDelivered(int purchaseId) async {
    await repository.markDelivered(purchaseId);
    await load();
  }

  /// The reward a purchase is for, if it is still in the shop's list.
  RewardItem? rewardFor(Purchase purchase) =>
      rewards.where((r) => r.id == purchase.itemId).firstOrNull;
}
