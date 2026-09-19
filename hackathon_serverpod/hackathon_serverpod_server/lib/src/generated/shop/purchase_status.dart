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

/// PRODUCT.md §6, §10.2. `pendingApproval` is a child's purchase still waiting on a guardian;
/// `pending` is waiting on the provider to accept.
enum PurchaseStatus implements _is.SerializableModel {
  pendingApproval,
  pending,
  accepted,
  delivered,
  refused;

  static PurchaseStatus fromJson(String name) {
    switch (name) {
      case 'pendingApproval':
        return PurchaseStatus.pendingApproval;
      case 'pending':
        return PurchaseStatus.pending;
      case 'accepted':
        return PurchaseStatus.accepted;
      case 'delivered':
        return PurchaseStatus.delivered;
      case 'refused':
        return PurchaseStatus.refused;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "PurchaseStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
