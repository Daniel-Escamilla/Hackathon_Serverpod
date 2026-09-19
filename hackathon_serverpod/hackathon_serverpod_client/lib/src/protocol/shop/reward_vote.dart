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

/// One member's vote on a proposed RewardItem, same shape as TaskVote (PRODUCT.md §10.2).
abstract class RewardVote
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RewardVote._({
    this.id,
    required this.itemId,
    required this.memberId,
    required this.approve,
  });

  factory RewardVote({
    int? id,
    required int itemId,
    required int memberId,
    required bool approve,
  }) = _RewardVoteImpl;

  factory RewardVote.fromJson(Map<String, dynamic> jsonSerialization) {
    return RewardVote(
      id: jsonSerialization['id'] as int?,
      itemId: jsonSerialization['itemId'] as int,
      memberId: jsonSerialization['memberId'] as int,
      approve: _isc.BoolJsonExtension.fromJson(jsonSerialization['approve']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int itemId;

  /// One vote per member per item.
  int memberId;

  bool approve;

  /// Returns a shallow copy of this [RewardVote]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RewardVote copyWith({
    int? id,
    int? itemId,
    int? memberId,
    bool? approve,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RewardVote',
      if (id != null) 'id': id,
      'itemId': itemId,
      'memberId': memberId,
      'approve': approve,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RewardVote',
      if (id != null) 'id': id,
      'itemId': itemId,
      'memberId': memberId,
      'approve': approve,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RewardVoteImpl extends RewardVote {
  _RewardVoteImpl({
    int? id,
    required int itemId,
    required int memberId,
    required bool approve,
  }) : super._(
         id: id,
         itemId: itemId,
         memberId: memberId,
         approve: approve,
       );

  /// Returns a shallow copy of this [RewardVote]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RewardVote copyWith({
    Object? id = _Undefined,
    int? itemId,
    int? memberId,
    bool? approve,
  }) {
    return RewardVote(
      id: id is int? ? id : this.id,
      itemId: itemId ?? this.itemId,
      memberId: memberId ?? this.memberId,
      approve: approve ?? this.approve,
    );
  }
}
