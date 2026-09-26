import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../client.dart';
import 'app_failure.dart';

/// The signed-in member's coins, as `WalletEndpoint` exposes them. Every call
/// throws [AppException].
class WalletRepository {
  const WalletRepository();

  Future<int> getBalance() => guardServerCall(client.wallet.getBalance);

  /// The latest movements, newest first.
  Future<List<CoinMovement>> getHistory({int limit = 50, int offset = 0}) =>
      guardServerCall(
        () => client.wallet.getHistory(limit: limit, offset: offset),
      );
}
