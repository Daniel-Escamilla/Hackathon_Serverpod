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
import '../tasks/task_kind.dart' as _ijul8zzi;
import '../tasks/task_recurrence.dart' as _irx5q63y;
import '../tasks/task_status.dart' as _i18yar27;

/// A proposed or in-progress household task, the core of the cycle (PRODUCT.md §3, §5, §10.2).
abstract class Task
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Task._({
    this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.reward,
    _ijul8zzi.TaskKind? kind,
    this.recurrence,
    _i18yar27.TaskStatus? status,
    required this.proposedById,
    this.doneById,
    this.voteClosesAt,
  }) : kind = kind ?? _ijul8zzi.TaskKind.oneOff,
       status = status ?? _i18yar27.TaskStatus.proposed;

  factory Task({
    int? id,
    required int groupId,
    required String title,
    required String description,
    required int reward,
    _ijul8zzi.TaskKind? kind,
    _irx5q63y.TaskRecurrence? recurrence,
    _i18yar27.TaskStatus? status,
    required int proposedById,
    int? doneById,
    DateTime? voteClosesAt,
  }) = _TaskImpl;

  factory Task.fromJson(Map<String, dynamic> jsonSerialization) {
    return Task(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      reward: jsonSerialization['reward'] as int,
      kind: jsonSerialization['kind'] == null
          ? null
          : _ijul8zzi.TaskKind.fromJson((jsonSerialization['kind'] as String)),
      recurrence: jsonSerialization['recurrence'] == null
          ? null
          : _irx5q63y.TaskRecurrence.fromJson(
              (jsonSerialization['recurrence'] as String),
            ),
      status: jsonSerialization['status'] == null
          ? null
          : _i18yar27.TaskStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      proposedById: jsonSerialization['proposedById'] as int,
      doneById: jsonSerialization['doneById'] as int?,
      voteClosesAt: jsonSerialization['voteClosesAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['voteClosesAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  String title;

  String description;

  /// Coins paid on validation, never on claiming (PRODUCT.md §3). Also the base the fines in §4.4
  /// are a percentage of.
  int reward;

  _ijul8zzi.TaskKind kind;

  /// Only set for `mission`-kind tasks (PRODUCT.md §5).
  _irx5q63y.TaskRecurrence? recurrence;

  _i18yar27.TaskStatus status;

  int proposedById;

  /// Who claimed the task by pressing "done". Null until then; whoever gets there first wins the
  /// race (PRODUCT.md §3, §10.2).
  int? doneById;

  /// When the open proposal or completion vote closes, for the FutureCall that expires it
  /// (PRODUCT.md §4.2, §10.5). Null outside an open vote.
  DateTime? voteClosesAt;

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Task copyWith({
    int? id,
    int? groupId,
    String? title,
    String? description,
    int? reward,
    _ijul8zzi.TaskKind? kind,
    _irx5q63y.TaskRecurrence? recurrence,
    _i18yar27.TaskStatus? status,
    int? proposedById,
    int? doneById,
    DateTime? voteClosesAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'groupId': groupId,
      'title': title,
      'description': description,
      'reward': reward,
      'kind': kind.toJson(),
      if (recurrence != null) 'recurrence': recurrence?.toJson(),
      'status': status.toJson(),
      'proposedById': proposedById,
      if (doneById != null) 'doneById': doneById,
      if (voteClosesAt != null) 'voteClosesAt': voteClosesAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'groupId': groupId,
      'title': title,
      'description': description,
      'reward': reward,
      'kind': kind.toJson(),
      if (recurrence != null) 'recurrence': recurrence?.toJson(),
      'status': status.toJson(),
      'proposedById': proposedById,
      if (doneById != null) 'doneById': doneById,
      if (voteClosesAt != null) 'voteClosesAt': voteClosesAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskImpl extends Task {
  _TaskImpl({
    int? id,
    required int groupId,
    required String title,
    required String description,
    required int reward,
    _ijul8zzi.TaskKind? kind,
    _irx5q63y.TaskRecurrence? recurrence,
    _i18yar27.TaskStatus? status,
    required int proposedById,
    int? doneById,
    DateTime? voteClosesAt,
  }) : super._(
         id: id,
         groupId: groupId,
         title: title,
         description: description,
         reward: reward,
         kind: kind,
         recurrence: recurrence,
         status: status,
         proposedById: proposedById,
         doneById: doneById,
         voteClosesAt: voteClosesAt,
       );

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Task copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? title,
    String? description,
    int? reward,
    _ijul8zzi.TaskKind? kind,
    Object? recurrence = _Undefined,
    _i18yar27.TaskStatus? status,
    int? proposedById,
    Object? doneById = _Undefined,
    Object? voteClosesAt = _Undefined,
  }) {
    return Task(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      reward: reward ?? this.reward,
      kind: kind ?? this.kind,
      recurrence: recurrence is _irx5q63y.TaskRecurrence?
          ? recurrence
          : this.recurrence,
      status: status ?? this.status,
      proposedById: proposedById ?? this.proposedById,
      doneById: doneById is int? ? doneById : this.doneById,
      voteClosesAt: voteClosesAt is DateTime?
          ? voteClosesAt
          : this.voteClosesAt,
    );
  }
}
