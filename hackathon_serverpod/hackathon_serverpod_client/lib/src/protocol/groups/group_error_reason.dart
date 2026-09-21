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

/// Why a group call was refused. The app picks the sentence it shows from this,
/// so the server never sends display text (PRODUCT.md §7).
enum GroupErrorReason implements _isc.SerializableModel {
  /// No group has that invite code.
  inviteCodeNotFound,

  /// The caller already has an active membership. One group per person.
  alreadyInGroup,

  /// The caller belongs to no group, so the call was refused.
  noMembership,

  /// Only the admin may do this: expel someone, or replace the invite code.
  notAdmin,

  /// That member is not in the caller's group, or has already left it.
  memberNotFound,

  /// The admin tried to expel themselves. Handing the role over is the way out.
  cannotExpelSelf;

  static GroupErrorReason fromJson(String name) {
    switch (name) {
      case 'inviteCodeNotFound':
        return GroupErrorReason.inviteCodeNotFound;
      case 'alreadyInGroup':
        return GroupErrorReason.alreadyInGroup;
      case 'noMembership':
        return GroupErrorReason.noMembership;
      case 'notAdmin':
        return GroupErrorReason.notAdmin;
      case 'memberNotFound':
        return GroupErrorReason.memberNotFound;
      case 'cannotExpelSelf':
        return GroupErrorReason.cannotExpelSelf;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "GroupErrorReason"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
