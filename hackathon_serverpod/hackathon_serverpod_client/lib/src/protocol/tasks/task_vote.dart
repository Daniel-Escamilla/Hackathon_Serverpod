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
import '../tasks/task_vote_phase.dart' as _iyz5tyfe;

/// One member's vote on a Task, in one of its two phases (PRODUCT.md §3, §10.2). Same shape as
/// RewardVote, plus the phase and the counter-offer.
abstract class TaskVote
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TaskVote._({
    this.id,
    required this.taskId,
    required this.memberId,
    required this.phase,
    required this.approve,
    this.counterReward,
  });

  factory TaskVote({
    int? id,
    required int taskId,
    required int memberId,
    required _iyz5tyfe.TaskVotePhase phase,
    required bool approve,
    int? counterReward,
  }) = _TaskVoteImpl;

  factory TaskVote.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskVote(
      id: jsonSerialization['id'] as int?,
      taskId: jsonSerialization['taskId'] as int,
      memberId: jsonSerialization['memberId'] as int,
      phase: _iyz5tyfe.TaskVotePhase.fromJson(
        (jsonSerialization['phase'] as String),
      ),
      approve: _isc.BoolJsonExtension.fromJson(jsonSerialization['approve']),
      counterReward: jsonSerialization['counterReward'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int taskId;

  /// One vote per member per task per phase; a vote round that restarts after an accepted
  /// counter-offer (PRODUCT.md §4.3) needs its old proposal-phase rows cleared first.
  int memberId;

  _iyz5tyfe.TaskVotePhase phase;

  bool approve;

  /// A different price offered instead of a plain reject, proposal phase only (PRODUCT.md §4.3).
  int? counterReward;

  /// Returns a shallow copy of this [TaskVote]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TaskVote copyWith({
    int? id,
    int? taskId,
    int? memberId,
    _iyz5tyfe.TaskVotePhase? phase,
    bool? approve,
    int? counterReward,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskVote',
      if (id != null) 'id': id,
      'taskId': taskId,
      'memberId': memberId,
      'phase': phase.toJson(),
      'approve': approve,
      if (counterReward != null) 'counterReward': counterReward,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaskVote',
      if (id != null) 'id': id,
      'taskId': taskId,
      'memberId': memberId,
      'phase': phase.toJson(),
      'approve': approve,
      if (counterReward != null) 'counterReward': counterReward,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskVoteImpl extends TaskVote {
  _TaskVoteImpl({
    int? id,
    required int taskId,
    required int memberId,
    required _iyz5tyfe.TaskVotePhase phase,
    required bool approve,
    int? counterReward,
  }) : super._(
         id: id,
         taskId: taskId,
         memberId: memberId,
         phase: phase,
         approve: approve,
         counterReward: counterReward,
       );

  /// Returns a shallow copy of this [TaskVote]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TaskVote copyWith({
    Object? id = _Undefined,
    int? taskId,
    int? memberId,
    _iyz5tyfe.TaskVotePhase? phase,
    bool? approve,
    Object? counterReward = _Undefined,
  }) {
    return TaskVote(
      id: id is int? ? id : this.id,
      taskId: taskId ?? this.taskId,
      memberId: memberId ?? this.memberId,
      phase: phase ?? this.phase,
      approve: approve ?? this.approve,
      counterReward: counterReward is int? ? counterReward : this.counterReward,
    );
  }
}
