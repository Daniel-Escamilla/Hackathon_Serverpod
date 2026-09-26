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

/// Why a task call was refused. The app picks the sentence it shows from this,
/// so the server never sends display text (PRODUCT.md §7).
enum TaskErrorReason implements _is.SerializableModel {
  /// No task with that id in the caller's group.
  taskNotFound,

  /// The task is no longer where this action needs it: the vote closed, the
  /// counter-offer was answered, or someone else claimed it first.
  notOpen,

  /// Nobody votes on or counter-offers their own proposal, nor votes on the
  /// completion of a task they claimed.
  ownTask,

  /// Only the proposer answers a counter-offer.
  notProposer;

  static TaskErrorReason fromJson(String name) {
    switch (name) {
      case 'taskNotFound':
        return TaskErrorReason.taskNotFound;
      case 'notOpen':
        return TaskErrorReason.notOpen;
      case 'ownTask':
        return TaskErrorReason.ownTask;
      case 'notProposer':
        return TaskErrorReason.notProposer;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "TaskErrorReason"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
