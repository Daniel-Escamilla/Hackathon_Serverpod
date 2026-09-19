import '../generated/protocol.dart';
import '../groups/current_member.dart';
import 'package:serverpod/serverpod.dart';

/// Balance, history and ranking (PRODUCT.md §10.3, §4.6).
class WalletEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Current balance of the signed-in member, in their group. Can be negative.
  Future<int> getBalance(Session session) async {
    final member = await currentGroupMember(session);
    return member.balance;
  }

  /// Movement history (earned/fined/spent/refunded), most recent first.
  Future<List<CoinTransaction>> getHistory(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) async {
    final member = await currentGroupMember(session);
    return CoinTransaction.db.find(
      session,
      where: (t) => t.memberId.equals(member.id!),
      orderBy: (t) => t.createdAt.desc(),
      limit: limit,
      offset: offset,
    );
  }

  /// This week's ranking: coins earned minus fines, spending excluded. Resets every
  /// Monday (PRODUCT.md §4.6).
  Future<List<RankingEntry>> getWeeklyRanking(Session session) async {
    final member = await currentGroupMember(session);
    final weekStart = _startOfWeekUtc(DateTime.now().toUtc());

    final members = await GroupMember.db.find(
      session,
      where: (t) => t.groupId.equals(member.groupId) & t.leftAt.equals(null),
    );

    final transactions = await CoinTransaction.db.find(
      session,
      where: (t) =>
          t.groupId.equals(member.groupId) &
          (t.createdAt >= weekStart) &
          (t.reason.equals(CoinTransactionReason.earned) |
              t.reason.equals(CoinTransactionReason.fined)),
    );

    final netByMember = <int, int>{};
    for (final transaction in transactions) {
      netByMember[transaction.memberId] =
          (netByMember[transaction.memberId] ?? 0) + transaction.amount;
    }

    final ranking = [
      for (final m in members)
        RankingEntry(
          memberId: m.id!,
          displayName: m.displayName,
          netCoins: netByMember[m.id!] ?? 0,
        ),
    ]..sort((a, b) => b.netCoins.compareTo(a.netCoins));

    return ranking;
  }

  DateTime _startOfWeekUtc(DateTime now) {
    final daysSinceMonday = now.weekday - DateTime.monday;
    final today = DateTime.utc(now.year, now.month, now.day);
    return today.subtract(Duration(days: daysSinceMonday));
  }
}
