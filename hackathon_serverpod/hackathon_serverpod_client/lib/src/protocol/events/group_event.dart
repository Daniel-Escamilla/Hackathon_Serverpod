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
import '../events/group_event_kind.dart' as _iis0559s;

/// Something happened in a group that every member's app should see right away,
/// over the per-group Stream (PRODUCT.md §10.4, issue #65). Not a table:
/// published, never queried back.
abstract class GroupEvent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  GroupEvent._({
    required this.groupId,
    required this.kind,
    this.taskId,
    this.purchaseId,
    this.rewardId,
    this.memberId,
    this.actorMemberId,
    required this.occurredAt,
  });

  factory GroupEvent({
    required int groupId,
    required _iis0559s.GroupEventKind kind,
    int? taskId,
    int? purchaseId,
    int? rewardId,
    int? memberId,
    int? actorMemberId,
    required DateTime occurredAt,
  }) = _GroupEventImpl;

  factory GroupEvent.fromJson(Map<String, dynamic> jsonSerialization) {
    return GroupEvent(
      groupId: jsonSerialization['groupId'] as int,
      kind: _iis0559s.GroupEventKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      taskId: jsonSerialization['taskId'] as int?,
      purchaseId: jsonSerialization['purchaseId'] as int?,
      rewardId: jsonSerialization['rewardId'] as int?,
      memberId: jsonSerialization['memberId'] as int?,
      actorMemberId: jsonSerialization['actorMemberId'] as int?,
      occurredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
    );
  }

  int groupId;

  _iis0559s.GroupEventKind kind;

  /// The task [kind] is about; null for `purchased` and `memberExpelled`.
  int? taskId;

  /// The purchase, for `purchased`, `purchaseResponded` and `purchaseDelivered`;
  /// null otherwise.
  int? purchaseId;

  /// The reward, for `rewardProposed` and `rewardVoteCast`; null otherwise.
  int? rewardId;

  /// The member who left, when [kind] is `memberExpelled`, or who changed
  /// their name or avatar, when it is `memberUpdated`, or who left, when it is
  /// `memberLeft`; null otherwise.
  int? memberId;

  /// The member who did it: the proposer, the voter, the buyer, the admin who
  /// expelled... Null only for an event nobody triggers. The
  /// app uses it to tell its own actions from everyone else's (#154).
  int? actorMemberId;

  DateTime occurredAt;

  /// Returns a shallow copy of this [GroupEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  GroupEvent copyWith({
    int? groupId,
    _iis0559s.GroupEventKind? kind,
    int? taskId,
    int? purchaseId,
    int? rewardId,
    int? memberId,
    int? actorMemberId,
    DateTime? occurredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GroupEvent',
      'groupId': groupId,
      'kind': kind.toJson(),
      if (taskId != null) 'taskId': taskId,
      if (purchaseId != null) 'purchaseId': purchaseId,
      if (rewardId != null) 'rewardId': rewardId,
      if (memberId != null) 'memberId': memberId,
      if (actorMemberId != null) 'actorMemberId': actorMemberId,
      'occurredAt': occurredAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GroupEvent',
      'groupId': groupId,
      'kind': kind.toJson(),
      if (taskId != null) 'taskId': taskId,
      if (purchaseId != null) 'purchaseId': purchaseId,
      if (rewardId != null) 'rewardId': rewardId,
      if (memberId != null) 'memberId': memberId,
      if (actorMemberId != null) 'actorMemberId': actorMemberId,
      'occurredAt': occurredAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GroupEventImpl extends GroupEvent {
  _GroupEventImpl({
    required int groupId,
    required _iis0559s.GroupEventKind kind,
    int? taskId,
    int? purchaseId,
    int? rewardId,
    int? memberId,
    int? actorMemberId,
    required DateTime occurredAt,
  }) : super._(
         groupId: groupId,
         kind: kind,
         taskId: taskId,
         purchaseId: purchaseId,
         rewardId: rewardId,
         memberId: memberId,
         actorMemberId: actorMemberId,
         occurredAt: occurredAt,
       );

  /// Returns a shallow copy of this [GroupEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  GroupEvent copyWith({
    int? groupId,
    _iis0559s.GroupEventKind? kind,
    Object? taskId = _Undefined,
    Object? purchaseId = _Undefined,
    Object? rewardId = _Undefined,
    Object? memberId = _Undefined,
    Object? actorMemberId = _Undefined,
    DateTime? occurredAt,
  }) {
    return GroupEvent(
      groupId: groupId ?? this.groupId,
      kind: kind ?? this.kind,
      taskId: taskId is int? ? taskId : this.taskId,
      purchaseId: purchaseId is int? ? purchaseId : this.purchaseId,
      rewardId: rewardId is int? ? rewardId : this.rewardId,
      memberId: memberId is int? ? memberId : this.memberId,
      actorMemberId: actorMemberId is int? ? actorMemberId : this.actorMemberId,
      occurredAt: occurredAt ?? this.occurredAt,
    );
  }
}
