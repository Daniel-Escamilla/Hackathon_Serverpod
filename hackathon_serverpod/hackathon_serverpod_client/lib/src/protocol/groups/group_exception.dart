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
import '../groups/group_error_reason.dart' as _iocljrt8;

/// A group call refused for a reason the app can act on.
///
/// Serialisable on purpose: a `StateError` reaches the client as a generic
/// failure, which leaves the app unable to tell "that code does not exist"
/// from "the server is down". This carries the reason across.
abstract class GroupException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  GroupException._({required this.reason});

  factory GroupException({required _iocljrt8.GroupErrorReason reason}) =
      _GroupExceptionImpl;

  factory GroupException.fromJson(Map<String, dynamic> jsonSerialization) {
    return GroupException(
      reason: _iocljrt8.GroupErrorReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _iocljrt8.GroupErrorReason reason;

  /// Returns a shallow copy of this [GroupException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  GroupException copyWith({_iocljrt8.GroupErrorReason? reason});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GroupException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GroupException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'GroupException(reason: $reason)';
  }
}

class _GroupExceptionImpl extends GroupException {
  _GroupExceptionImpl({required _iocljrt8.GroupErrorReason reason})
    : super._(reason: reason);

  /// Returns a shallow copy of this [GroupException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  GroupException copyWith({_iocljrt8.GroupErrorReason? reason}) {
    return GroupException(reason: reason ?? this.reason);
  }
}
