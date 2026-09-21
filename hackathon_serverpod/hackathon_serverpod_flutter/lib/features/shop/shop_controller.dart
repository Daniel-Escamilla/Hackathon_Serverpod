import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../client.dart';

class ShopController extends ChangeNotifier {
  List<RewardItem> rewards = [];
  bool loading = false;
  Object? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      rewards = await client.shop.listRewards();
    } catch (e) {
      error = e;
    } finally {
      loading = false;
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
}
