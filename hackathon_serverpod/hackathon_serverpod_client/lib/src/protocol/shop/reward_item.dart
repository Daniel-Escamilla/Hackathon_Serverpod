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
import '../shop/reward_item_status.dart' as _iezbc0vz;

/// A reward in a group's shop, from the profile template or proposed by a member
/// (PRODUCT.md §6, §10.2).
abstract class RewardItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RewardItem._({
    this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.price,
    _iezbc0vz.RewardItemStatus? status,
    required this.createdById,
    this.stock,
  }) : status = status ?? _iezbc0vz.RewardItemStatus.proposed;

  factory RewardItem({
    int? id,
    required int groupId,
    required String title,
    required String description,
    required int price,
    _iezbc0vz.RewardItemStatus? status,
    required int createdById,
    int? stock,
  }) = _RewardItemImpl;

  factory RewardItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return RewardItem(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      price: jsonSerialization['price'] as int,
      status: jsonSerialization['status'] == null
          ? null
          : _iezbc0vz.RewardItemStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      createdById: jsonSerialization['createdById'] as int,
      stock: jsonSerialization['stock'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  String title;

  String description;

  int price;

  _iezbc0vz.RewardItemStatus status;

  int createdById;

  /// Null means unlimited (the default per PRODUCT.md §6); a number caps how many times it can
  /// be bought.
  int? stock;

  /// Returns a shallow copy of this [RewardItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RewardItem copyWith({
    int? id,
    int? groupId,
    String? title,
    String? description,
    int? price,
    _iezbc0vz.RewardItemStatus? status,
    int? createdById,
    int? stock,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RewardItem',
      if (id != null) 'id': id,
      'groupId': groupId,
      'title': title,
      'description': description,
      'price': price,
      'status': status.toJson(),
      'createdById': createdById,
      if (stock != null) 'stock': stock,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RewardItem',
      if (id != null) 'id': id,
      'groupId': groupId,
      'title': title,
      'description': description,
      'price': price,
      'status': status.toJson(),
      'createdById': createdById,
      if (stock != null) 'stock': stock,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RewardItemImpl extends RewardItem {
  _RewardItemImpl({
    int? id,
    required int groupId,
    required String title,
    required String description,
    required int price,
    _iezbc0vz.RewardItemStatus? status,
    required int createdById,
    int? stock,
  }) : super._(
         id: id,
         groupId: groupId,
         title: title,
         description: description,
         price: price,
         status: status,
         createdById: createdById,
         stock: stock,
       );

  /// Returns a shallow copy of this [RewardItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RewardItem copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? title,
    String? description,
    int? price,
    _iezbc0vz.RewardItemStatus? status,
    int? createdById,
    Object? stock = _Undefined,
  }) {
    return RewardItem(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      status: status ?? this.status,
      createdById: createdById ?? this.createdById,
      stock: stock is int? ? stock : this.stock,
    );
  }
}
