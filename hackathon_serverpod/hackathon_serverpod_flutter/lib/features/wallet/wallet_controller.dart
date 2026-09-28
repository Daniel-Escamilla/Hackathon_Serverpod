import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../data/wallet_repository.dart';
import '../../ui/sounds.dart';

class WalletController extends ChangeNotifier {
  WalletController({this.repository = const WalletRepository()});

  final WalletRepository repository;

  int balance = 0;
  List<CoinMovement> history = [];
  bool loading = false;
  bool hasLoaded = false;
  Object? error;

  /// Ids seen on the previous successful load. Null until then, so the first
  /// load — where every movement looks "new" — never triggers a sound.
  Set<int>? _knownMovementIds;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      // Future.wait rethrows the first failure as it is; a record's `.wait`
      // would wrap it in a ParallelWaitError.
      final results = await Future.wait<Object>([
        repository.getBalance(),
        repository.getHistory(),
      ]);
      final loadedBalance = results[0] as int;
      final loadedHistory = results[1] as List<CoinMovement>;
      balance = loadedBalance;
      history = loadedHistory;
      _playNewMovementSounds();
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      hasLoaded = true;
      notifyListeners();
    }
  }

  /// Nobody is notified in real time when someone else's vote pays or fines
  /// them (there is no stream endpoint), so opening the wallet is the first
  /// moment they can actually see it land — this is that moment (DESIGN.md
  /// "Pendiente", #61/#63).
  void _playNewMovementSounds() {
    final previouslyKnown = _knownMovementIds;
    _knownMovementIds = history.map((m) => m.id).toSet();
    if (previouslyKnown == null) return;

    final arrived = history.where((m) => !previouslyKnown.contains(m.id));
    if (arrived.any((m) => m.reason == CoinTransactionReason.earned)) {
      uiSounds.play(AppSound.coin);
    }
    if (arrived.any((m) => m.reason == CoinTransactionReason.fined)) {
      uiSounds.play(AppSound.fine);
    }
  }
}
