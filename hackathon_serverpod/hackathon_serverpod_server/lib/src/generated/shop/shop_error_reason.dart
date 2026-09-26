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

/// Why a shop call was refused. The app picks the sentence it shows from this,
/// so the server never sends display text (PRODUCT.md §7).
enum ShopErrorReason implements _is.SerializableModel {
  /// No reward with that id in the caller's group.
  rewardNotFound,

  /// The reward is no longer being voted on.
  rewardNotOpen,

  /// Nobody votes on a reward they proposed.
  ownReward,

  /// The reward is not in the shop: still being voted on, or withdrawn.
  rewardNotAvailable,

  /// No stock left.
  outOfStock,

  /// Nothing can be bought with a negative balance (PRODUCT.md §4).
  negativeBalance,

  /// The provider has to be another member of the caller's group.
  invalidProvider,

  /// No purchase with that id in the caller's group.
  purchaseNotFound,

  /// The purchase is no longer where this action needs it: already answered,
  /// or not accepted yet.
  purchaseNotOpen,

  /// Only the member chosen to fulfil a purchase answers it or delivers it.
  notProvider;

  static ShopErrorReason fromJson(String name) {
    switch (name) {
      case 'rewardNotFound':
        return ShopErrorReason.rewardNotFound;
      case 'rewardNotOpen':
        return ShopErrorReason.rewardNotOpen;
      case 'ownReward':
        return ShopErrorReason.ownReward;
      case 'rewardNotAvailable':
        return ShopErrorReason.rewardNotAvailable;
      case 'outOfStock':
        return ShopErrorReason.outOfStock;
      case 'negativeBalance':
        return ShopErrorReason.negativeBalance;
      case 'invalidProvider':
        return ShopErrorReason.invalidProvider;
      case 'purchaseNotFound':
        return ShopErrorReason.purchaseNotFound;
      case 'purchaseNotOpen':
        return ShopErrorReason.purchaseNotOpen;
      case 'notProvider':
        return ShopErrorReason.notProvider;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "ShopErrorReason"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
