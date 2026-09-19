/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../wallet/coin_transaction_reason.dart' as _iling76c;

/// One entry in a member's coin history. Balance and ranking are derived from summing these
/// (PRODUCT.md §4.6, §10.2). Positive amount = coins in, negative = coins out.
abstract class CoinTransaction
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CoinTransaction._({
    this.id,
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.reason,
    this.taskId,
    this.purchaseId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CoinTransaction({
    int? id,
    required int groupId,
    required int memberId,
    required int amount,
    required _iling76c.CoinTransactionReason reason,
    int? taskId,
    int? purchaseId,
    DateTime? createdAt,
  }) = _CoinTransactionImpl;

  factory CoinTransaction.fromJson(Map<String, dynamic> jsonSerialization) {
    return CoinTransaction(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      memberId: jsonSerialization['memberId'] as int,
      amount: jsonSerialization['amount'] as int,
      reason: _iling76c.CoinTransactionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
      taskId: jsonSerialization['taskId'] as int?,
      purchaseId: jsonSerialization['purchaseId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  int memberId;

  int amount;

  _iling76c.CoinTransactionReason reason;

  /// Set when the transaction comes from a task (earned, or the fine for a denied/expired vote).
  /// Left as a plain id, not a relation: Task does not exist yet, and a transaction references at
  /// most one of taskId/purchaseId, never both.
  int? taskId;

  /// Set when the transaction comes from the shop (spent on a purchase, refunded, or the fine for
  /// refusing to fulfil one). Same reasoning as taskId: plain id, Purchase does not exist yet.
  int? purchaseId;

  DateTime createdAt;

  /// Returns a shallow copy of this [CoinTransaction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CoinTransaction copyWith({
    int? id,
    int? groupId,
    int? memberId,
    int? amount,
    _iling76c.CoinTransactionReason? reason,
    int? taskId,
    int? purchaseId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CoinTransaction',
      if (id != null) 'id': id,
      'groupId': groupId,
      'memberId': memberId,
      'amount': amount,
      'reason': reason.toJson(),
      if (taskId != null) 'taskId': taskId,
      if (purchaseId != null) 'purchaseId': purchaseId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CoinTransaction',
      if (id != null) 'id': id,
      'groupId': groupId,
      'memberId': memberId,
      'amount': amount,
      'reason': reason.toJson(),
      if (taskId != null) 'taskId': taskId,
      if (purchaseId != null) 'purchaseId': purchaseId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CoinTransactionImpl extends CoinTransaction {
  _CoinTransactionImpl({
    int? id,
    required int groupId,
    required int memberId,
    required int amount,
    required _iling76c.CoinTransactionReason reason,
    int? taskId,
    int? purchaseId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         memberId: memberId,
         amount: amount,
         reason: reason,
         taskId: taskId,
         purchaseId: purchaseId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CoinTransaction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CoinTransaction copyWith({
    Object? id = _Undefined,
    int? groupId,
    int? memberId,
    int? amount,
    _iling76c.CoinTransactionReason? reason,
    Object? taskId = _Undefined,
    Object? purchaseId = _Undefined,
    DateTime? createdAt,
  }) {
    return CoinTransaction(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      taskId: taskId is int? ? taskId : this.taskId,
      purchaseId: purchaseId is int? ? purchaseId : this.purchaseId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
