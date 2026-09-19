import '../generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// Balance, history and ranking (PRODUCT.md §10.3). Bodies are stubs: the contract
/// (issue #53) lands ahead of the implementation (issues #62-65).
class WalletEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Current balance of the signed-in member, in their group. Can be negative.
  Future<int> getBalance(Session session) async => throw UnimplementedError();

  /// Movement history (earned/fined/spent/refunded), most recent first.
  Future<List<CoinTransaction>> getHistory(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) async => throw UnimplementedError();

  /// This week's ranking: coins earned minus fines, spending excluded.
  Future<List<RankingEntry>> getWeeklyRanking(Session session) async =>
      throw UnimplementedError();
}
