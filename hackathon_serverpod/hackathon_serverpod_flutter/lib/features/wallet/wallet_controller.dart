import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../client.dart';

class WalletController extends ChangeNotifier {
  int balance = 0;
  List<CoinTransaction> history = [];
  bool loading = false;
  bool hasLoaded = false;
  Object? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        client.wallet.getBalance(),
        client.wallet.getHistory(limit: 50, offset: 0),
      ]);
      balance = results[0] as int;
      history = results[1] as List<CoinTransaction>;
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      hasLoaded = true;
      notifyListeners();
    }
  }
}
