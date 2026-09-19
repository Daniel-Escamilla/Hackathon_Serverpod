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

/// Why a CoinTransaction happened (PRODUCT.md §4.6: ganado, multado, gastado, devuelto).
enum CoinTransactionReason implements _is.SerializableModel {
  earned,
  fined,
  spent,
  refunded;

  static CoinTransactionReason fromJson(String name) {
    switch (name) {
      case 'earned':
        return CoinTransactionReason.earned;
      case 'fined':
        return CoinTransactionReason.fined;
      case 'spent':
        return CoinTransactionReason.spent;
      case 'refunded':
        return CoinTransactionReason.refunded;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "CoinTransactionReason"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
