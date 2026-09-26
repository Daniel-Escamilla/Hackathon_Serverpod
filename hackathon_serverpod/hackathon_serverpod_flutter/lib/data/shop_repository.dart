import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../client.dart';
import 'app_failure.dart';

/// The group's shop (PRODUCT.md §6), as `ShopEndpoint` exposes it. Every call
/// throws [AppException].
class ShopRepository {
  const ShopRepository();

  Future<List<RewardItem>> listRewards() =>
      guardServerCall(client.shop.listRewards);

  /// The purchases the signed-in member made or has to fulfil.
  Future<List<Purchase>> listPurchases() =>
      guardServerCall(client.shop.listPurchases);

  Future<RewardItem> proposeReward(
    String title,
    String description,
    int price,
  ) => guardServerCall(
    () => client.shop.proposeReward(title, description, price),
  );

  Future<void> voteReward(int itemId, bool approve) =>
      guardServerCall(() => client.shop.voteReward(itemId, approve));

  Future<Purchase> purchaseReward(int itemId, int providerId) =>
      guardServerCall(() => client.shop.purchaseReward(itemId, providerId));

  Future<void> respondToPurchase(int purchaseId, bool accept) =>
      guardServerCall(() => client.shop.respondToPurchase(purchaseId, accept));

  Future<void> markDelivered(int purchaseId) =>
      guardServerCall(() => client.shop.markDelivered(purchaseId));
}
