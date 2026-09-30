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
import '../shop/purchase_status.dart' as _ifzoyvo9;

/// A bought RewardItem, pending until the chosen provider marks it delivered (PRODUCT.md §6,
/// §10.2).
abstract class Purchase
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Purchase._({
    this.id,
    required this.groupId,
    required this.itemId,
    required this.buyerId,
    required this.providerId,
    _ifzoyvo9.PurchaseStatus? status,
  }) : status = status ?? _ifzoyvo9.PurchaseStatus.pending;

  factory Purchase({
    int? id,
    required int groupId,
    required int itemId,
    required int buyerId,
    required int providerId,
    _ifzoyvo9.PurchaseStatus? status,
  }) = _PurchaseImpl;

  factory Purchase.fromJson(Map<String, dynamic> jsonSerialization) {
    return Purchase(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      itemId: jsonSerialization['itemId'] as int,
      buyerId: jsonSerialization['buyerId'] as int,
      providerId: jsonSerialization['providerId'] as int,
      status: jsonSerialization['status'] == null
          ? null
          : _ifzoyvo9.PurchaseStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  int itemId;

  int buyerId;

  /// Who has to fulfil it, chosen by the buyer among the other members.
  int providerId;

  _ifzoyvo9.PurchaseStatus status;

  /// Returns a shallow copy of this [Purchase]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Purchase copyWith({
    int? id,
    int? groupId,
    int? itemId,
    int? buyerId,
    int? providerId,
    _ifzoyvo9.PurchaseStatus? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Purchase',
      if (id != null) 'id': id,
      'groupId': groupId,
      'itemId': itemId,
      'buyerId': buyerId,
      'providerId': providerId,
      'status': status.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Purchase',
      if (id != null) 'id': id,
      'groupId': groupId,
      'itemId': itemId,
      'buyerId': buyerId,
      'providerId': providerId,
      'status': status.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PurchaseImpl extends Purchase {
  _PurchaseImpl({
    int? id,
    required int groupId,
    required int itemId,
    required int buyerId,
    required int providerId,
    _ifzoyvo9.PurchaseStatus? status,
  }) : super._(
         id: id,
         groupId: groupId,
         itemId: itemId,
         buyerId: buyerId,
         providerId: providerId,
         status: status,
       );

  /// Returns a shallow copy of this [Purchase]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Purchase copyWith({
    Object? id = _Undefined,
    int? groupId,
    int? itemId,
    int? buyerId,
    int? providerId,
    _ifzoyvo9.PurchaseStatus? status,
  }) {
    return Purchase(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      itemId: itemId ?? this.itemId,
      buyerId: buyerId ?? this.buyerId,
      providerId: providerId ?? this.providerId,
      status: status ?? this.status,
    );
  }
}
