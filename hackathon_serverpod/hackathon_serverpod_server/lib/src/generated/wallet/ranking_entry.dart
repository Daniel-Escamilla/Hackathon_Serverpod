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

/// One row of the weekly ranking: coins earned minus fines, spending excluded
/// (PRODUCT.md §4.6). Computed on request, not a table.
abstract class RankingEntry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RankingEntry._({
    required this.memberId,
    required this.displayName,
    this.avatarEmoji,
    this.avatarColor,
    required this.netCoins,
  });

  factory RankingEntry({
    required int memberId,
    required String displayName,
    String? avatarEmoji,
    String? avatarColor,
    required int netCoins,
  }) = _RankingEntryImpl;

  factory RankingEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return RankingEntry(
      memberId: jsonSerialization['memberId'] as int,
      displayName: jsonSerialization['displayName'] as String,
      avatarEmoji: jsonSerialization['avatarEmoji'] as String?,
      avatarColor: jsonSerialization['avatarColor'] as String?,
      netCoins: jsonSerialization['netCoins'] as int,
    );
  }

  int memberId;

  String displayName;

  /// The member's picture, as GroupMember keeps it, so the ranking draws them.
  String? avatarEmoji;

  String? avatarColor;

  int netCoins;

  /// Returns a shallow copy of this [RankingEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RankingEntry copyWith({
    int? memberId,
    String? displayName,
    String? avatarEmoji,
    String? avatarColor,
    int? netCoins,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RankingEntry',
      'memberId': memberId,
      'displayName': displayName,
      if (avatarEmoji != null) 'avatarEmoji': avatarEmoji,
      if (avatarColor != null) 'avatarColor': avatarColor,
      'netCoins': netCoins,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RankingEntry',
      'memberId': memberId,
      'displayName': displayName,
      if (avatarEmoji != null) 'avatarEmoji': avatarEmoji,
      if (avatarColor != null) 'avatarColor': avatarColor,
      'netCoins': netCoins,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RankingEntryImpl extends RankingEntry {
  _RankingEntryImpl({
    required int memberId,
    required String displayName,
    String? avatarEmoji,
    String? avatarColor,
    required int netCoins,
  }) : super._(
         memberId: memberId,
         displayName: displayName,
         avatarEmoji: avatarEmoji,
         avatarColor: avatarColor,
         netCoins: netCoins,
       );

  /// Returns a shallow copy of this [RankingEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RankingEntry copyWith({
    int? memberId,
    String? displayName,
    Object? avatarEmoji = _Undefined,
    Object? avatarColor = _Undefined,
    int? netCoins,
  }) {
    return RankingEntry(
      memberId: memberId ?? this.memberId,
      displayName: displayName ?? this.displayName,
      avatarEmoji: avatarEmoji is String? ? avatarEmoji : this.avatarEmoji,
      avatarColor: avatarColor is String? ? avatarColor : this.avatarColor,
      netCoins: netCoins ?? this.netCoins,
    );
  }
}
