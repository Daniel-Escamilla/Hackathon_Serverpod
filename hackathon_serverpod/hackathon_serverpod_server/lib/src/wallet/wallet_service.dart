import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Records coin movements. Used by any endpoint that moves coins (tasks, shop, fines).
class WalletService {
  const WalletService();

  /// Inserts a [CoinTransaction] and updates [GroupMember.balance] by [amount] in the
  /// same database transaction — the two can't be left half-done (PRODUCT.md §10.2).
  /// Locks the member row for the duration of the transaction so two concurrent
  /// transactions can't read the same stale balance.
  Future<CoinTransaction> recordTransaction(
    Session session, {
    required int groupId,
    required int memberId,
    required int amount,
    required CoinTransactionReason reason,
    int? taskId,
    int? purchaseId,
    Transaction? transaction,
  }) {
    Future<CoinTransaction> run(Transaction tx) async {
      final member = await GroupMember.db.findById(
        session,
        memberId,
        transaction: tx,
        lockMode: LockMode.forNoKeyUpdate,
      );
      if (member == null) {
        throw StateError('GroupMember $memberId not found');
      }

      await GroupMember.db.updateRow(
        session,
        member.copyWith(balance: member.balance + amount),
        transaction: tx,
      );

      return CoinTransaction.db.insertRow(
        session,
        CoinTransaction(
          groupId: groupId,
          memberId: memberId,
          amount: amount,
          reason: reason,
          taskId: taskId,
          purchaseId: purchaseId,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: tx,
      );
    }

    if (transaction != null) return run(transaction);
    return session.db.transaction(run);
  }
}
