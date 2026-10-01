import 'package:flutter/foundation.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';

import '../../data/wallet_repository.dart';
import '../../ui/app_animation.dart';
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
    if (arrived.any((m) => _coinsIn.contains(m.reason))) {
      uiSounds.play(AppSound.coin);
      _arrive(AppAnimation.coins);
    }
    // After the coins, so a fine that came with them is what stays on screen.
    if (arrived.any((m) => _fines.contains(m.reason))) {
      uiSounds.play(AppSound.fine);
      _arrive(AppAnimation.fine);
    }
  }

  /// Every reason that takes coins as a fine: the shop's and the three of
  /// the task cycle (PRODUCT.md §4.4).
  static const _fines = {
    CoinTransactionReason.fined,
    CoinTransactionReason.proposalDenied,
    CoinTransactionReason.validationDenied,
    CoinTransactionReason.voteExpired,
  };
  static const _coinsIn = {
    CoinTransactionReason.earned,
    CoinTransactionReason.refunded,
  };

  /// What the wallet should play for the movements that just arrived, until
  /// it has played it. [arrivalCount] changes with every new one, so the same
  /// animation twice in a row plays twice.
  AppAnimation? arrival;
  int arrivalCount = 0;

  void _arrive(AppAnimation animation) {
    arrival = animation;
    arrivalCount++;
  }

  /// Called by the wallet once the animation has played.
  void arrivalShown() {
    if (arrival == null) return;
    arrival = null;
    notifyListeners();
  }
}
