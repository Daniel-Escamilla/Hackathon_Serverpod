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

abstract class TaskVoteFutureCallExpireVoteModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TaskVoteFutureCallExpireVoteModel._({
    required this.taskId,
    required this.expectedVoteClosesAt,
  });

  factory TaskVoteFutureCallExpireVoteModel({
    required int taskId,
    required DateTime expectedVoteClosesAt,
  }) = _TaskVoteFutureCallExpireVoteModelImpl;

  factory TaskVoteFutureCallExpireVoteModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TaskVoteFutureCallExpireVoteModel(
      taskId: jsonSerialization['taskId'] as int,
      expectedVoteClosesAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expectedVoteClosesAt'],
      ),
    );
  }

  int taskId;

  DateTime expectedVoteClosesAt;

  /// Returns a shallow copy of this [TaskVoteFutureCallExpireVoteModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TaskVoteFutureCallExpireVoteModel copyWith({
    int? taskId,
    DateTime? expectedVoteClosesAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskVoteFutureCallExpireVoteModel',
      'taskId': taskId,
      'expectedVoteClosesAt': expectedVoteClosesAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TaskVoteFutureCallExpireVoteModelImpl
    extends TaskVoteFutureCallExpireVoteModel {
  _TaskVoteFutureCallExpireVoteModelImpl({
    required int taskId,
    required DateTime expectedVoteClosesAt,
  }) : super._(
         taskId: taskId,
         expectedVoteClosesAt: expectedVoteClosesAt,
       );

  /// Returns a shallow copy of this [TaskVoteFutureCallExpireVoteModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TaskVoteFutureCallExpireVoteModel copyWith({
    int? taskId,
    DateTime? expectedVoteClosesAt,
  }) {
    return TaskVoteFutureCallExpireVoteModel(
      taskId: taskId ?? this.taskId,
      expectedVoteClosesAt: expectedVoteClosesAt ?? this.expectedVoteClosesAt,
    );
  }
}
