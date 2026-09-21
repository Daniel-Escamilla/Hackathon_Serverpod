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
