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

/// Which of a Task's two votes this is (PRODUCT.md §3, §10.2): `proposal` decides whether the
/// task is accepted, `completion` decides whether it was actually done.
enum TaskVotePhase implements _isc.SerializableModel {
  proposal,
  completion;

  static TaskVotePhase fromJson(String name) {
    switch (name) {
      case 'proposal':
        return TaskVotePhase.proposal;
      case 'completion':
        return TaskVotePhase.completion;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "TaskVotePhase"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
