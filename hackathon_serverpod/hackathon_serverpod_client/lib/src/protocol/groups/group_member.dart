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
import '../groups/group_member_role.dart' as _iboql8hx;
import '../groups/group_member_status.dart' as _ik3oel1z;

/// One person's membership in a group. The wallet balance lives here (PRODUCT.md §10.2, §4.6).
abstract class GroupMember
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  GroupMember._({
    this.id,
    required this.groupId,
    required this.authUserId,
    required this.displayName,
    this.avatarEmoji,
    this.avatarColor,
    required this.role,
    _ik3oel1z.GroupMemberStatus? status,
    int? balance,
    DateTime? joinedAt,
    this.leftAt,
  }) : status = status ?? _ik3oel1z.GroupMemberStatus.active,
       balance = balance ?? 0,
       joinedAt = joinedAt ?? DateTime.now();

  factory GroupMember({
    int? id,
    required int groupId,
    required _isc.UuidValue authUserId,
    required String displayName,
    String? avatarEmoji,
    String? avatarColor,
    required _iboql8hx.GroupMemberRole role,
    _ik3oel1z.GroupMemberStatus? status,
    int? balance,
    DateTime? joinedAt,
    DateTime? leftAt,
  }) = _GroupMemberImpl;

  factory GroupMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return GroupMember(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      displayName: jsonSerialization['displayName'] as String,
      avatarEmoji: jsonSerialization['avatarEmoji'] as String?,
      avatarColor: jsonSerialization['avatarColor'] as String?,
      role: _iboql8hx.GroupMemberRole.fromJson(
        (jsonSerialization['role'] as String),
      ),
      status: jsonSerialization['status'] == null
          ? null
          : _ik3oel1z.GroupMemberStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      balance: jsonSerialization['balance'] as int?,
      joinedAt: jsonSerialization['joinedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
      leftAt: jsonSerialization['leftAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['leftAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int groupId;

  _isc.UuidValue authUserId;

  String displayName;

  /// The house character the member picked as their picture (`taza`, `planta`... see the app's MemberAvatar), or an emoji from before the characters. Null until they pick one: the app shows their initial instead. The name stays for the column it maps to.
  String? avatarEmoji;

  /// The avatar's background, a colour name from the app's palette (sky, lime, coral...). Null means the default. The app owns the palette, so an unknown name falls back to the default rather than failing.
  String? avatarColor;

  _iboql8hx.GroupMemberRole role;

  _ik3oel1z.GroupMemberStatus status;

  /// Result of the CoinTransaction history, kept here for fast reads (PRODUCT.md §10.2).
  int balance;

  DateTime joinedAt;

  /// Set when the member leaves or is expelled. The row itself is kept so past activity is not lost.
  DateTime? leftAt;

  /// Returns a shallow copy of this [GroupMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  GroupMember copyWith({
    int? id,
    int? groupId,
    _isc.UuidValue? authUserId,
    String? displayName,
    String? avatarEmoji,
    String? avatarColor,
    _iboql8hx.GroupMemberRole? role,
    _ik3oel1z.GroupMemberStatus? status,
    int? balance,
    DateTime? joinedAt,
    DateTime? leftAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GroupMember',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      if (avatarEmoji != null) 'avatarEmoji': avatarEmoji,
      if (avatarColor != null) 'avatarColor': avatarColor,
      'role': role.toJson(),
      'status': status.toJson(),
      'balance': balance,
      'joinedAt': joinedAt.toJson(),
      if (leftAt != null) 'leftAt': leftAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GroupMember',
      if (id != null) 'id': id,
      'groupId': groupId,
      'authUserId': authUserId.toJson(),
      'displayName': displayName,
      if (avatarEmoji != null) 'avatarEmoji': avatarEmoji,
      if (avatarColor != null) 'avatarColor': avatarColor,
      'role': role.toJson(),
      'status': status.toJson(),
      'balance': balance,
      'joinedAt': joinedAt.toJson(),
      if (leftAt != null) 'leftAt': leftAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GroupMemberImpl extends GroupMember {
  _GroupMemberImpl({
    int? id,
    required int groupId,
    required _isc.UuidValue authUserId,
    required String displayName,
    String? avatarEmoji,
    String? avatarColor,
    required _iboql8hx.GroupMemberRole role,
    _ik3oel1z.GroupMemberStatus? status,
    int? balance,
    DateTime? joinedAt,
    DateTime? leftAt,
  }) : super._(
         id: id,
         groupId: groupId,
         authUserId: authUserId,
         displayName: displayName,
         avatarEmoji: avatarEmoji,
         avatarColor: avatarColor,
         role: role,
         status: status,
         balance: balance,
         joinedAt: joinedAt,
         leftAt: leftAt,
       );

  /// Returns a shallow copy of this [GroupMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  GroupMember copyWith({
    Object? id = _Undefined,
    int? groupId,
    _isc.UuidValue? authUserId,
    String? displayName,
    Object? avatarEmoji = _Undefined,
    Object? avatarColor = _Undefined,
    _iboql8hx.GroupMemberRole? role,
    _ik3oel1z.GroupMemberStatus? status,
    int? balance,
    DateTime? joinedAt,
    Object? leftAt = _Undefined,
  }) {
    return GroupMember(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      authUserId: authUserId ?? this.authUserId,
      displayName: displayName ?? this.displayName,
      avatarEmoji: avatarEmoji is String? ? avatarEmoji : this.avatarEmoji,
      avatarColor: avatarColor is String? ? avatarColor : this.avatarColor,
      role: role ?? this.role,
      status: status ?? this.status,
      balance: balance ?? this.balance,
      joinedAt: joinedAt ?? this.joinedAt,
      leftAt: leftAt is DateTime? ? leftAt : this.leftAt,
    );
  }
}
