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
import '../auth/registration_error_reason.dart' as _iizb7125;

/// A registration refused for a reason the app can act on.
///
/// Serverpod's own `EmailAccountRequestException` hides whether an email is
/// taken, on purpose. We trade that for sending a known email straight to
/// sign-in, so this carries the one reason it does not.
abstract class RegistrationException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  RegistrationException._({required this.reason});

  factory RegistrationException({
    required _iizb7125.RegistrationErrorReason reason,
  }) = _RegistrationExceptionImpl;

  factory RegistrationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RegistrationException(
      reason: _iizb7125.RegistrationErrorReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _iizb7125.RegistrationErrorReason reason;

  /// Returns a shallow copy of this [RegistrationException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RegistrationException copyWith({_iizb7125.RegistrationErrorReason? reason});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RegistrationException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RegistrationException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'RegistrationException(reason: $reason)';
  }
}

class _RegistrationExceptionImpl extends RegistrationException {
  _RegistrationExceptionImpl({
    required _iizb7125.RegistrationErrorReason reason,
  }) : super._(reason: reason);

  /// Returns a shallow copy of this [RegistrationException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RegistrationException copyWith({_iizb7125.RegistrationErrorReason? reason}) {
    return RegistrationException(reason: reason ?? this.reason);
  }
}
