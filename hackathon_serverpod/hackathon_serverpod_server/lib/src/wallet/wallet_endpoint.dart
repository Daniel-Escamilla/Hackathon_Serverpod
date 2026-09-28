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

  /// Movement history (earned/fined/spent/refunded), most recent first, each
  /// with the title of the task or reward behind it.
  ///
  /// Three queries whatever the page size — the transactions, then every task
  /// and every reward they point at in one go each — rather than one per row.
  Future<List<CoinMovement>> getHistory(
    Session session, {
    int limit = 50,
    int offset = 0,
  }) async {
    final member = await currentGroupMember(session);
    final transactions = await CoinTransaction.db.find(
      session,
      where: (t) => t.memberId.equals(member.id!),
      orderBy: (t) => t.createdAt.desc(),
      limit: limit,
      offset: offset,
    );

    final taskTitles = await _taskTitles(session, transactions);
    final rewardTitles = await _rewardTitlesByPurchase(session, transactions);

    return [
      for (final t in transactions)
        CoinMovement(
          id: t.id!,
          amount: t.amount,
          reason: t.reason,
          title: t.taskId != null
              ? taskTitles[t.taskId]
              : rewardTitles[t.purchaseId],
          createdAt: t.createdAt,
        ),
    ];
  }

  Future<Map<int, String>> _taskTitles(
    Session session,
    List<CoinTransaction> transactions,
  ) async {
    final ids = <int>{for (final t in transactions) ?t.taskId};
    if (ids.isEmpty) return const {};
    final tasks = await Task.db.find(session, where: (t) => t.id.inSet(ids));
    return {for (final task in tasks) task.id!: task.title};
  }

  /// A purchase has no title of its own; its reward does.
  Future<Map<int, String>> _rewardTitlesByPurchase(
    Session session,
    List<CoinTransaction> transactions,
  ) async {
    final purchaseIds = <int>{for (final t in transactions) ?t.purchaseId};
    if (purchaseIds.isEmpty) return const {};

    final purchases = await Purchase.db.find(
      session,
      where: (t) => t.id.inSet(purchaseIds),
    );
    // Built as a typed variable, not inline: `id` is a nullable column, so an
    // inline literal is inferred as Set<int?> from `inSet`'s parameter and then
    // fails at runtime inside Serverpod, which wants a Set<int>.
    final itemIds = <int>{for (final p in purchases) p.itemId};
    final items = await RewardItem.db.find(
      session,
      where: (t) => t.id.inSet(itemIds),
    );
    final titleByItem = {for (final item in items) item.id!: item.title};

    return {for (final p in purchases) p.id!: ?titleByItem[p.itemId]};
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
              t.reason.equals(CoinTransactionReason.fined) |
              t.reason.equals(CoinTransactionReason.proposalDenied) |
              t.reason.equals(CoinTransactionReason.validationDenied) |
              t.reason.equals(CoinTransactionReason.voteExpired)),
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
