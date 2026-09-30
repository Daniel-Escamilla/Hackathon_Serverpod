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
import '../groups/group_type.dart' as _ig74uogb;

/// A household group: shared flat, couple or family (PRODUCT.md §10.2).
abstract class Group
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Group._({
    this.id,
    required this.name,
    required this.type,
    required this.inviteCode,
    int? finePercent,
    DateTime? createdAt,
  }) : finePercent = finePercent ?? 20,
       createdAt = createdAt ?? DateTime.now();

  factory Group({
    int? id,
    required String name,
    required _ig74uogb.GroupType type,
    required String inviteCode,
    int? finePercent,
    DateTime? createdAt,
  }) = _GroupImpl;

  factory Group.fromJson(Map<String, dynamic> jsonSerialization) {
    return Group(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      type: _ig74uogb.GroupType.fromJson((jsonSerialization['type'] as String)),
      inviteCode: jsonSerialization['inviteCode'] as String,
      finePercent: jsonSerialization['finePercent'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  _ig74uogb.GroupType type;

  /// Shared to join the group without approval. Unique.
  String inviteCode;

  /// Fine percentage applied to task/purchase penalties, PRODUCT.md §4.4.
  int finePercent;

  DateTime createdAt;

  /// Returns a shallow copy of this [Group]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Group copyWith({
    int? id,
    String? name,
    _ig74uogb.GroupType? type,
    String? inviteCode,
    int? finePercent,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Group',
      if (id != null) 'id': id,
      'name': name,
      'type': type.toJson(),
      'inviteCode': inviteCode,
      'finePercent': finePercent,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Group',
      if (id != null) 'id': id,
      'name': name,
      'type': type.toJson(),
      'inviteCode': inviteCode,
      'finePercent': finePercent,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GroupImpl extends Group {
  _GroupImpl({
    int? id,
    required String name,
    required _ig74uogb.GroupType type,
    required String inviteCode,
    int? finePercent,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         type: type,
         inviteCode: inviteCode,
         finePercent: finePercent,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Group]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Group copyWith({
    Object? id = _Undefined,
    String? name,
    _ig74uogb.GroupType? type,
    String? inviteCode,
    int? finePercent,
    DateTime? createdAt,
  }) {
    return Group(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      inviteCode: inviteCode ?? this.inviteCode,
      finePercent: finePercent ?? this.finePercent,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
