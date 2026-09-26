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
import '../shop/shop_error_reason.dart' as _i0ks1dfm;

/// A shop call refused for a reason the app can act on.
///
/// Serialisable for the same reason as `GroupException`: a `StateError`
/// reaches the client as a generic failure.
abstract class ShopException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  ShopException._({required this.reason});

  factory ShopException({required _i0ks1dfm.ShopErrorReason reason}) =
      _ShopExceptionImpl;

  factory ShopException.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShopException(
      reason: _i0ks1dfm.ShopErrorReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
    );
  }

  _i0ks1dfm.ShopErrorReason reason;

  /// Returns a shallow copy of this [ShopException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ShopException copyWith({_i0ks1dfm.ShopErrorReason? reason});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopException',
      'reason': reason.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShopException',
      'reason': reason.toJson(),
    };
  }

  @override
  String toString() {
    return 'ShopException(reason: $reason)';
  }
}

class _ShopExceptionImpl extends ShopException {
  _ShopExceptionImpl({required _i0ks1dfm.ShopErrorReason reason})
    : super._(reason: reason);

  /// Returns a shallow copy of this [ShopException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ShopException copyWith({_i0ks1dfm.ShopErrorReason? reason}) {
    return ShopException(reason: reason ?? this.reason);
  }
}
