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
import '../tasks/task_error_reason.dart' as _inzqcz0q;

/// A task call refused for a reason the app can act on.
///
/// Serialisable for the same reason as `GroupException`: a `StateError`
/// reaches the client as a generic failure.
abstract class TaskException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  TaskException._({required this.reason});

  factory TaskException({required _inzqcz0q.TaskErrorReason reason}) =
      _TaskExceptionImpl;

  factory TaskException.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskException(
      reason: _inzqcz0q.TaskErrorReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _inzqcz0q.TaskErrorReason reason;

  /// Returns a shallow copy of this [TaskException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TaskException copyWith({_inzqcz0q.TaskErrorReason? reason});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaskException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'TaskException(reason: $reason)';
  }
}

class _TaskExceptionImpl extends TaskException {
  _TaskExceptionImpl({required _inzqcz0q.TaskErrorReason reason})
    : super._(reason: reason);

  /// Returns a shallow copy of this [TaskException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TaskException copyWith({_inzqcz0q.TaskErrorReason? reason}) {
    return TaskException(reason: reason ?? this.reason);
  }
}
