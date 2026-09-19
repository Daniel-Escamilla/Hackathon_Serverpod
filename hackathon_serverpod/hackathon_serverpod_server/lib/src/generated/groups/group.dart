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
import '../groups/group_type.dart' as _ig74uogb;

/// A household group: shared flat, couple or family (PRODUCT.md §10.2).
abstract class Group implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Group._({
    this.id,
    required this.name,
    required this.type,
    required this.inviteCode,
    int? finePercent,
    DateTime? createdAt,
  }) : finePercent = finePercent ?? 20,
       createdAt = createdAt ?? DateTime.now();

  factory Group({
    int? id,
    required String name,
    required _ig74uogb.GroupType type,
    required String inviteCode,
    int? finePercent,
    DateTime? createdAt,
  }) = _GroupImpl;

  factory Group.fromJson(Map<String, dynamic> jsonSerialization) {
    return Group(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      type: _ig74uogb.GroupType.fromJson((jsonSerialization['type'] as String)),
      inviteCode: jsonSerialization['inviteCode'] as String,
      finePercent: jsonSerialization['finePercent'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = GroupTable();

  static const db = GroupRepository._();

  @override
  int? id;

  String name;

  _ig74uogb.GroupType type;

  /// Shared to join the group without approval. Unique.
  String inviteCode;

  /// Fine percentage applied to task/purchase penalties, PRODUCT.md §4.4.
  int finePercent;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Group]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Group copyWith({
    int? id,
    String? name,
    _ig74uogb.GroupType? type,
    String? inviteCode,
    int? finePercent,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Group',
      if (id != null) 'id': id,
      'name': name,
      'type': type.toJson(),
      'inviteCode': inviteCode,
      'finePercent': finePercent,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Group',
      if (id != null) 'id': id,
      'name': name,
      'type': type.toJson(),
      'inviteCode': inviteCode,
      'finePercent': finePercent,
      'createdAt': createdAt.toJson(),
    };
  }

  static GroupInclude include() {
    return GroupInclude._();
  }

  static GroupIncludeList includeList({
    _is.WhereExpressionBuilder<GroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GroupTable>? orderBy,
    _is.OrderByListBuilder<GroupTable>? orderByList,
    GroupInclude? include,
  }) {
    return GroupIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Group.t),
      orderByList: orderByList?.call(Group.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GroupImpl extends Group {
  _GroupImpl({
    int? id,
    required String name,
    required _ig74uogb.GroupType type,
    required String inviteCode,
    int? finePercent,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         type: type,
         inviteCode: inviteCode,
         finePercent: finePercent,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Group]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Group copyWith({
    Object? id = _Undefined,
    String? name,
    _ig74uogb.GroupType? type,
    String? inviteCode,
    int? finePercent,
    DateTime? createdAt,
  }) {
    return Group(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      inviteCode: inviteCode ?? this.inviteCode,
      finePercent: finePercent ?? this.finePercent,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GroupUpdateTable extends _is.UpdateTable<GroupTable> {
  GroupUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_ig74uogb.GroupType, _ig74uogb.GroupType> type(
    _ig74uogb.GroupType value,
  ) => _is.ColumnValue(
    table.type,
    value,
  );

  _is.ColumnValue<String, String> inviteCode(String value) => _is.ColumnValue(
    table.inviteCode,
    value,
  );

  _is.ColumnValue<int, int> finePercent(int value) => _is.ColumnValue(
    table.finePercent,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class GroupTable extends _is.Table<int?> {
  GroupTable({super.tableRelation}) : super(tableName: 'group') {
    updateTable = GroupUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    type = _is.ColumnEnum(
      'type',
      this,
      _is.EnumSerialization.byName,
    );
    inviteCode = _is.ColumnString(
      'inviteCode',
      this,
    );
    finePercent = _is.ColumnInt(
      'finePercent',
      this,
      hasDefault: true,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final GroupUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnEnum<_ig74uogb.GroupType> type;

  /// Shared to join the group without approval. Unique.
  late final _is.ColumnString inviteCode;

  /// Fine percentage applied to task/purchase penalties, PRODUCT.md §4.4.
  late final _is.ColumnInt finePercent;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    type,
    inviteCode,
    finePercent,
    createdAt,
  ];
}

class GroupInclude extends _is.IncludeObject {
  GroupInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Group.t;
}

class GroupIncludeList extends _is.IncludeList {
  GroupIncludeList._({
    _is.WhereExpressionBuilder<GroupTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Group.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Group.t;
}

class GroupRepository {
  const GroupRepository._();

  /// Returns a list of [Group]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Group>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GroupTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GroupTable>? orderBy,
    _is.OrderByListBuilder<GroupTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Group>(
      where: where?.call(Group.t),
      orderBy: orderBy?.call(Group.t),
      orderByList: orderByList?.call(Group.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Group] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Group?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GroupTable>? where,
    int? offset,
    _is.OrderByBuilder<GroupTable>? orderBy,
    _is.OrderByListBuilder<GroupTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Group>(
      where: where?.call(Group.t),
      orderBy: orderBy?.call(Group.t),
      orderByList: orderByList?.call(Group.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Group] by its [id] or null if no such row exists.
  Future<Group?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Group>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Group]s in the list and returns the inserted rows.
  ///
  /// The returned [Group]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Group>> insert(
    _is.DatabaseSession session,
    List<Group> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Group>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Group] and returns the inserted row.
  ///
  /// The returned [Group] will have its `id` field set.
  Future<Group> insertRow(
    _is.DatabaseSession session,
    Group row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Group>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Group]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Group]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Group>> upsert(
    _is.DatabaseSession session,
    List<Group> rows, {
    required _is.ColumnSelections<GroupTable> conflictColumns,
    _is.ColumnSelections<GroupTable>? updateColumns,
    _is.WhereExpressionBuilder<GroupTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Group>(
      rows,
      conflictColumns: conflictColumns(Group.t),
      updateColumns: updateColumns?.call(Group.t),
      updateWhere: updateWhere?.call(Group.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Group] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Group] will have its `id` field set.
  Future<Group?> upsertRow(
    _is.DatabaseSession session,
    Group row, {
    required _is.ColumnSelections<GroupTable> conflictColumns,
    _is.ColumnSelections<GroupTable>? updateColumns,
    _is.WhereExpressionBuilder<GroupTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Group>(
      row,
      conflictColumns: conflictColumns(Group.t),
      updateColumns: updateColumns?.call(Group.t),
      updateWhere: updateWhere?.call(Group.t),
      transaction: transaction,
    );
  }

  /// Updates all [Group]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Group>> update(
    _is.DatabaseSession session,
    List<Group> rows, {
    _is.ColumnSelections<GroupTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Group>(
      rows,
      columns: columns?.call(Group.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Group]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Group> updateRow(
    _is.DatabaseSession session,
    Group row, {
    _is.ColumnSelections<GroupTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Group>(
      row,
      columns: columns?.call(Group.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Group] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Group?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<GroupUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Group>(
      id,
      columnValues: columnValues(Group.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Group]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Group>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<GroupUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<GroupTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GroupTable>? orderBy,
    _is.OrderByListBuilder<GroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Group>(
      columnValues: columnValues(Group.t.updateTable),
      where: where(Group.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Group.t),
      orderByList: orderByList?.call(Group.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Group]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Group>> delete(
    _is.DatabaseSession session,
    List<Group> rows, {
    _is.OrderByBuilder<GroupTable>? orderBy,
    _is.OrderByListBuilder<GroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Group>(
      rows,
      orderBy: orderBy?.call(Group.t),
      orderByList: orderByList?.call(Group.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Group].
  Future<Group> deleteRow(
    _is.DatabaseSession session,
    Group row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Group>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Group>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GroupTable> where,
    _is.OrderByBuilder<GroupTable>? orderBy,
    _is.OrderByListBuilder<GroupTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Group>(
      where: where(Group.t),
      orderBy: orderBy?.call(Group.t),
      orderByList: orderByList?.call(Group.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GroupTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Group>(
      where: where?.call(Group.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Group] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GroupTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Group>(
      where: where(Group.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
