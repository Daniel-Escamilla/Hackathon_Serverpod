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

/// What happened, for the group's live Stream (PRODUCT.md §10.4, issue #65). One
/// value per thing the issue names: propuesta, voto, contraoferta, validación,
/// compra. `taskVoteCast` is a proposal-vote cast; `taskValidated` is a
/// completion-vote cast — the codebase's own names for the two phases.
/// `taskClaimed` came later: without it a task someone marked done only moved
/// to "in validation" on the other phones after a reload.
enum GroupEventKind implements _isc.SerializableModel {
  taskProposed,
  taskVoteCast,
  taskCounterOffered,
  taskValidated,
  taskClaimed,
  purchased;

  static GroupEventKind fromJson(String name) {
    switch (name) {
      case 'taskProposed':
        return GroupEventKind.taskProposed;
      case 'taskVoteCast':
        return GroupEventKind.taskVoteCast;
      case 'taskCounterOffered':
        return GroupEventKind.taskCounterOffered;
      case 'taskValidated':
        return GroupEventKind.taskValidated;
      case 'taskClaimed':
        return GroupEventKind.taskClaimed;
      case 'purchased':
        return GroupEventKind.purchased;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "GroupEventKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
