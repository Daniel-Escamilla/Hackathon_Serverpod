/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'groups/group.dart' as _i9ztykbt;
import 'groups/group_member.dart' as _iio6btzp;
import 'groups/group_member_role.dart' as _ixnaxhon;
import 'groups/group_member_status.dart' as _ivrm4l0w;
import 'groups/group_type.dart' as _iskz3t6h;
import 'wallet/coin_transaction.dart' as _iyltnat0;
import 'wallet/coin_transaction_reason.dart' as _inbrsz7i;
export 'greetings/greeting.dart';
export 'groups/group.dart';
export 'groups/group_member.dart';
export 'groups/group_member_role.dart';
export 'groups/group_member_status.dart';
export 'groups/group_type.dart';
export 'wallet/coin_transaction.dart';
export 'wallet/coin_transaction_reason.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _i9ztykbt.Group) {
      return _i9ztykbt.Group.fromJson(data) as T;
    }
    if (t == _iio6btzp.GroupMember) {
      return _iio6btzp.GroupMember.fromJson(data) as T;
    }
    if (t == _ixnaxhon.GroupMemberRole) {
      return _ixnaxhon.GroupMemberRole.fromJson(data) as T;
    }
    if (t == _ivrm4l0w.GroupMemberStatus) {
      return _ivrm4l0w.GroupMemberStatus.fromJson(data) as T;
    }
    if (t == _iskz3t6h.GroupType) {
      return _iskz3t6h.GroupType.fromJson(data) as T;
    }
    if (t == _iyltnat0.CoinTransaction) {
      return _iyltnat0.CoinTransaction.fromJson(data) as T;
    }
    if (t == _inbrsz7i.CoinTransactionReason) {
      return _inbrsz7i.CoinTransactionReason.fromJson(data) as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i9ztykbt.Group?>()) {
      return (data != null ? _i9ztykbt.Group.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iio6btzp.GroupMember?>()) {
      return (data != null ? _iio6btzp.GroupMember.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixnaxhon.GroupMemberRole?>()) {
      return (data != null ? _ixnaxhon.GroupMemberRole.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivrm4l0w.GroupMemberStatus?>()) {
      return (data != null ? _ivrm4l0w.GroupMemberStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iskz3t6h.GroupType?>()) {
      return (data != null ? _iskz3t6h.GroupType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iyltnat0.CoinTransaction?>()) {
      return (data != null ? _iyltnat0.CoinTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_inbrsz7i.CoinTransactionReason?>()) {
      return (data != null
              ? _inbrsz7i.CoinTransactionReason.fromJson(data)
              : null)
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _izw8z7ou.Greeting => 'Greeting',
      _i9ztykbt.Group => 'Group',
      _iio6btzp.GroupMember => 'GroupMember',
      _ixnaxhon.GroupMemberRole => 'GroupMemberRole',
      _ivrm4l0w.GroupMemberStatus => 'GroupMemberStatus',
      _iskz3t6h.GroupType => 'GroupType',
      _iyltnat0.CoinTransaction => 'CoinTransaction',
      _inbrsz7i.CoinTransactionReason => 'CoinTransactionReason',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'hackathon_serverpod.',
        '',
      );
    }

    switch (data) {
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _i9ztykbt.Group():
        return 'Group';
      case _iio6btzp.GroupMember():
        return 'GroupMember';
      case _ixnaxhon.GroupMemberRole():
        return 'GroupMemberRole';
      case _ivrm4l0w.GroupMemberStatus():
        return 'GroupMemberStatus';
      case _iskz3t6h.GroupType():
        return 'GroupType';
      case _iyltnat0.CoinTransaction():
        return 'CoinTransaction';
      case _inbrsz7i.CoinTransactionReason():
        return 'CoinTransactionReason';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'Group') {
      return deserialize<_i9ztykbt.Group>(data['data']);
    }
    if (dataClassName == 'GroupMember') {
      return deserialize<_iio6btzp.GroupMember>(data['data']);
    }
    if (dataClassName == 'GroupMemberRole') {
      return deserialize<_ixnaxhon.GroupMemberRole>(data['data']);
    }
    if (dataClassName == 'GroupMemberStatus') {
      return deserialize<_ivrm4l0w.GroupMemberStatus>(data['data']);
    }
    if (dataClassName == 'GroupType') {
      return deserialize<_iskz3t6h.GroupType>(data['data']);
    }
    if (dataClassName == 'CoinTransaction') {
      return deserialize<_iyltnat0.CoinTransaction>(data['data']);
    }
    if (dataClassName == 'CoinTransactionReason') {
      return deserialize<_inbrsz7i.CoinTransactionReason>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('hackathon_serverpod', this);
    _iacc.Protocol().registerHostProtocol('hackathon_serverpod', this);
  }

  @override
  String getModuleName() => 'hackathon_serverpod';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
