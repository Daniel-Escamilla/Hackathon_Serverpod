import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import 'app_failure.dart';
import 'group_repository.dart' show clientProvider;

/// The only place in the app that talks to `WalletEndpoint`.
class WalletRepository {
  const WalletRepository(this._client);

  final Client _client;

  /// The caller's balance in their group. Can be negative (PRODUCT.md §4.6).
  Future<int> balance() async {
    try {
      return await _client.wallet.getBalance();
    } catch (error) {
      throw mapServerError(error);
    }
  }

  /// The caller's coin movements, most recent first.
  ///
  /// A movement carries its reason and the id of the task or purchase behind
  /// it, but not their titles, so the list can say what kind of movement it
  /// was and not which task it was for.
  Future<List<CoinTransaction>> history({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      return await _client.wallet.getHistory(limit: limit, offset: offset);
    } catch (error) {
      throw mapServerError(error);
    }
  }
}

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => WalletRepository(ref.watch(clientProvider)),
);

/// The balance, cached and shared by every widget that shows it. Anything that
/// moves coins should `ref.invalidate` this so the figure refreshes once,
/// rather than each screen asking for it again.
final walletBalanceProvider = FutureProvider<int>(
  (ref) => ref.watch(walletRepositoryProvider).balance(),
);

/// The movement history. Invalidated alongside the balance, since anything
/// that changes one changes the other.
final walletHistoryProvider = FutureProvider<List<CoinTransaction>>(
  (ref) => ref.watch(walletRepositoryProvider).history(),
);
