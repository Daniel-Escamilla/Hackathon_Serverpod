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

/// A one-use code a guardian generates so a child can sign in on their phone without an
/// email (PRODUCT.md §8 "Menores", §10.2). Only the hash is stored, never the code.
/// Family mode is out of MVP scope (PLAN.md §1): the table exists, nothing uses it yet.
abstract class ChildLoginCode
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ChildLoginCode._({
    this.id,
    required this.memberId,
    required this.codeHash,
    required this.expiresAt,
    this.usedAt,
  });

  factory ChildLoginCode({
    int? id,
    required int memberId,
    required String codeHash,
    required DateTime expiresAt,
    DateTime? usedAt,
  }) = _ChildLoginCodeImpl;

  factory ChildLoginCode.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildLoginCode(
      id: jsonSerialization['id'] as int?,
      memberId: jsonSerialization['memberId'] as int,
      codeHash: jsonSerialization['codeHash'] as String,
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      usedAt: jsonSerialization['usedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['usedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The child's membership this code signs in as.
  int memberId;

  /// Hash of the code the guardian reads out; the code itself is never stored.
  String codeHash;

  /// 24 hours after it is generated (§8).
  DateTime expiresAt;

  /// Set when the child signs in with it. A used code never works again.
  DateTime? usedAt;

  /// Returns a shallow copy of this [ChildLoginCode]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ChildLoginCode copyWith({
    int? id,
    int? memberId,
    String? codeHash,
    DateTime? expiresAt,
    DateTime? usedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChildLoginCode',
      if (id != null) 'id': id,
      'memberId': memberId,
      'codeHash': codeHash,
      'expiresAt': expiresAt.toJson(),
      if (usedAt != null) 'usedAt': usedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChildLoginCode',
      if (id != null) 'id': id,
      'memberId': memberId,
      'codeHash': codeHash,
      'expiresAt': expiresAt.toJson(),
      if (usedAt != null) 'usedAt': usedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildLoginCodeImpl extends ChildLoginCode {
  _ChildLoginCodeImpl({
    int? id,
    required int memberId,
    required String codeHash,
    required DateTime expiresAt,
    DateTime? usedAt,
  }) : super._(
         id: id,
         memberId: memberId,
         codeHash: codeHash,
         expiresAt: expiresAt,
         usedAt: usedAt,
       );

  /// Returns a shallow copy of this [ChildLoginCode]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ChildLoginCode copyWith({
    Object? id = _Undefined,
    int? memberId,
    String? codeHash,
    DateTime? expiresAt,
    Object? usedAt = _Undefined,
  }) {
    return ChildLoginCode(
      id: id is int? ? id : this.id,
      memberId: memberId ?? this.memberId,
      codeHash: codeHash ?? this.codeHash,
      expiresAt: expiresAt ?? this.expiresAt,
      usedAt: usedAt is DateTime? ? usedAt : this.usedAt,
    );
  }
}
