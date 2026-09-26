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
    this.memberId,
    required this.occurredAt,
  });

  factory GroupEvent({
    required int groupId,
    required _iis0559s.GroupEventKind kind,
    int? taskId,
    int? purchaseId,
    int? memberId,
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
      memberId: jsonSerialization['memberId'] as int?,
      occurredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['occurredAt'],
      ),
    );
  }

  int groupId;

  _iis0559s.GroupEventKind kind;

  /// The task [kind] is about; null for `purchased` and `memberExpelled`.
  int? taskId;

  /// The purchase, when [kind] is `purchased`; null otherwise.
  int? purchaseId;

  /// The member who left, when [kind] is `memberExpelled`; null otherwise.
  int? memberId;

  DateTime occurredAt;

  /// Returns a shallow copy of this [GroupEvent]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  GroupEvent copyWith({
    int? groupId,
    _iis0559s.GroupEventKind? kind,
    int? taskId,
    int? purchaseId,
    int? memberId,
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
      if (memberId != null) 'memberId': memberId,
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
      if (memberId != null) 'memberId': memberId,
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
    int? memberId,
    required DateTime occurredAt,
  }) : super._(
         groupId: groupId,
         kind: kind,
         taskId: taskId,
         purchaseId: purchaseId,
         memberId: memberId,
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
    Object? memberId = _Undefined,
    DateTime? occurredAt,
  }) {
    return GroupEvent(
      groupId: groupId ?? this.groupId,
      kind: kind ?? this.kind,
      taskId: taskId is int? ? taskId : this.taskId,
      purchaseId: purchaseId is int? ? purchaseId : this.purchaseId,
      memberId: memberId is int? ? memberId : this.memberId,
      occurredAt: occurredAt ?? this.occurredAt,
    );
  }
}
