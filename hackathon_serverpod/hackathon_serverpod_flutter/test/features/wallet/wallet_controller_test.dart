import 'package:flutter_test/flutter_test.dart';
import 'package:hackathon_serverpod_client/hackathon_serverpod_client.dart';
import 'package:hackathon_serverpod_flutter/data/app_failure.dart';
import 'package:hackathon_serverpod_flutter/data/wallet_repository.dart';
import 'package:hackathon_serverpod_flutter/features/wallet/wallet_controller.dart';
import 'package:hackathon_serverpod_flutter/home_shell.dart';

CoinMovement movement(int id, int amount, CoinTransactionReason reason) =>
    CoinMovement(
      id: id,
      amount: amount,
      reason: reason,
      createdAt: DateTime.utc(2026, 9, 26),
    );

/// Answers with whatever the test put in it, or fails the balance on demand.
class FakeWalletRepository extends WalletRepository {
  int balance = 0;
  List<CoinMovement> history = [];
  AppFailure? failWith;

  @override
  Future<int> getBalance() async {
    if (failWith != null) throw AppException(failWith!);
    return balance;
  }

  @override
  Future<List<CoinMovement>> getHistory({
    int limit = 50,
    int offset = 0,
  }) async => history;
}

void main() {
  late FakeWalletRepository repository;
  late WalletController wallet;

  setUp(() {
    repository = FakeWalletRepository();
    wallet = WalletController(repository: repository);
  });
  tearDown(() => wallet.dispose());

  test('loading brings the balance and the history', () async {
    repository
      ..balance = 25
      ..history = [movement(1, 25, CoinTransactionReason.earned)];

    await wallet.load();

    expect(wallet.balance, 25);
    expect(wallet.history.map((m) => m.id), [1]);
    expect(wallet.error, isNull);
    expect(wallet.hasLoaded, isTrue);
  });

  test('a later load picks up what changed', () async {
    await wallet.load();
    repository
      ..balance = -5
      ..history = [movement(2, -5, CoinTransactionReason.fined)];

    await wallet.load();

    expect(wallet.balance, -5);
    expect(wallet.history.single.reason, CoinTransactionReason.fined);
  });

  test('a refused load keeps the failure itself, not a wrapper', () async {
    repository.failWith = AppFailure.noGroup;

    await wallet.load();

    expect(wallet.error, isA<AppException>());
    expect(meansNoGroup(wallet.error), isTrue);
    expect(wallet.loading, isFalse);
  });
}
