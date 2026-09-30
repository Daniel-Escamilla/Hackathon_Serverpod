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
import 'package:serverpod/serverpod.dart' as _is;
import '../wallet/coin_transaction_reason.dart' as _iling76c;

/// One line of the wallet history: the movement, plus the title of whatever
/// caused it.
///
/// `CoinTransaction` holds `taskId` and `purchaseId` but not their titles, so
/// on its own it can only say what kind of movement happened, never what it was
/// for. Built per request from the transaction and the row it points at; not a
/// table of its own.
abstract class CoinMovement
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CoinMovement._({
    required this.id,
    required this.amount,
    required this.reason,
    this.title,
    required this.createdAt,
  });

  factory CoinMovement({
    required int id,
    required int amount,
    required _iling76c.CoinTransactionReason reason,
    String? title,
    required DateTime createdAt,
  }) = _CoinMovementImpl;

  factory CoinMovement.fromJson(Map<String, dynamic> jsonSerialization) {
    return CoinMovement(
      id: jsonSerialization['id'] as int,
      amount: jsonSerialization['amount'] as int,
      reason: _iling76c.CoinTransactionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
      title: jsonSerialization['title'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  int amount;

  _iling76c.CoinTransactionReason reason;

  /// The task's or the reward's title. Null when whatever it pointed at is
  /// gone, or when the movement points at nothing.
  String? title;

  DateTime createdAt;

  /// Returns a shallow copy of this [CoinMovement]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CoinMovement copyWith({
    int? id,
    int? amount,
    _iling76c.CoinTransactionReason? reason,
    String? title,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CoinMovement',
      'id': id,
      'amount': amount,
      'reason': reason.toJson(),
      if (title != null) 'title': title,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CoinMovement',
      'id': id,
      'amount': amount,
      'reason': reason.toJson(),
      if (title != null) 'title': title,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CoinMovementImpl extends CoinMovement {
  _CoinMovementImpl({
    required int id,
    required int amount,
    required _iling76c.CoinTransactionReason reason,
    String? title,
    required DateTime createdAt,
  }) : super._(
         id: id,
         amount: amount,
         reason: reason,
         title: title,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CoinMovement]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CoinMovement copyWith({
    int? id,
    int? amount,
    _iling76c.CoinTransactionReason? reason,
    Object? title = _Undefined,
    DateTime? createdAt,
  }) {
    return CoinMovement(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      title: title is String? ? title : this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
