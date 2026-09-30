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

/// One row of the weekly ranking: coins earned minus fines, spending excluded
/// (PRODUCT.md §4.6). Computed on request, not a table.
abstract class RankingEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RankingEntry._({
    required this.memberId,
    required this.displayName,
    required this.netCoins,
  });

  factory RankingEntry({
    required int memberId,
    required String displayName,
    required int netCoins,
  }) = _RankingEntryImpl;

  factory RankingEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return RankingEntry(
      memberId: jsonSerialization['memberId'] as int,
      displayName: jsonSerialization['displayName'] as String,
      netCoins: jsonSerialization['netCoins'] as int,
    );
  }

  int memberId;

  String displayName;

  int netCoins;

  /// Returns a shallow copy of this [RankingEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RankingEntry copyWith({
    int? memberId,
    String? displayName,
    int? netCoins,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RankingEntry',
      'memberId': memberId,
      'displayName': displayName,
      'netCoins': netCoins,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RankingEntry',
      'memberId': memberId,
      'displayName': displayName,
      'netCoins': netCoins,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _RankingEntryImpl extends RankingEntry {
  _RankingEntryImpl({
    required int memberId,
    required String displayName,
    required int netCoins,
  }) : super._(
         memberId: memberId,
         displayName: displayName,
         netCoins: netCoins,
       );

  /// Returns a shallow copy of this [RankingEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RankingEntry copyWith({
    int? memberId,
    String? displayName,
    int? netCoins,
  }) {
    return RankingEntry(
      memberId: memberId ?? this.memberId,
      displayName: displayName ?? this.displayName,
      netCoins: netCoins ?? this.netCoins,
    );
  }
}
