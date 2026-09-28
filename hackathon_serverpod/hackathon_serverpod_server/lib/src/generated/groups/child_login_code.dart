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

/// A one-use code a guardian generates so a child can sign in on their phone without an
/// email (PRODUCT.md §8 "Menores", §10.2). Only the hash is stored, never the code.
/// Family mode is out of MVP scope (PLAN.md §1): the table exists, nothing uses it yet.
abstract class ChildLoginCode
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ChildLoginCode._({
    this.id,
    required this.memberId,
    required this.codeHash,
    required this.expiresAt,
    this.usedAt,
  });

  factory ChildLoginCode({
    int? id,
    required int memberId,
    required String codeHash,
    required DateTime expiresAt,
    DateTime? usedAt,
  }) = _ChildLoginCodeImpl;

  factory ChildLoginCode.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildLoginCode(
      id: jsonSerialization['id'] as int?,
      memberId: jsonSerialization['memberId'] as int,
      codeHash: jsonSerialization['codeHash'] as String,
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      usedAt: jsonSerialization['usedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['usedAt']),
    );
  }

  static final t = ChildLoginCodeTable();

  static const db = ChildLoginCodeRepository._();

  @override
  int? id;

  /// The child's membership this code signs in as.
  int memberId;

  /// Hash of the code the guardian reads out; the code itself is never stored.
  String codeHash;

  /// 24 hours after it is generated (§8).
  DateTime expiresAt;

  /// Set when the child signs in with it. A used code never works again.
  DateTime? usedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ChildLoginCode]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ChildLoginCode copyWith({
    int? id,
    int? memberId,
    String? codeHash,
    DateTime? expiresAt,
    DateTime? usedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChildLoginCode',
      if (id != null) 'id': id,
      'memberId': memberId,
      'codeHash': codeHash,
      'expiresAt': expiresAt.toJson(),
      if (usedAt != null) 'usedAt': usedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChildLoginCode',
      if (id != null) 'id': id,
      'memberId': memberId,
      'codeHash': codeHash,
      'expiresAt': expiresAt.toJson(),
      if (usedAt != null) 'usedAt': usedAt?.toJson(),
    };
  }

  static ChildLoginCodeInclude include() {
    return ChildLoginCodeInclude._();
  }

  static ChildLoginCodeIncludeList includeList({
    _is.WhereExpressionBuilder<ChildLoginCodeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<ChildLoginCodeTable>? orderByList,
    ChildLoginCodeInclude? include,
  }) {
    return ChildLoginCodeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildLoginCode.t),
      orderByList: orderByList?.call(ChildLoginCode.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildLoginCodeImpl extends ChildLoginCode {
  _ChildLoginCodeImpl({
    int? id,
    required int memberId,
    required String codeHash,
    required DateTime expiresAt,
    DateTime? usedAt,
  }) : super._(
         id: id,
         memberId: memberId,
         codeHash: codeHash,
         expiresAt: expiresAt,
         usedAt: usedAt,
       );

  /// Returns a shallow copy of this [ChildLoginCode]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChildLoginCode copyWith({
    Object? id = _Undefined,
    int? memberId,
    String? codeHash,
    DateTime? expiresAt,
    Object? usedAt = _Undefined,
  }) {
    return ChildLoginCode(
      id: id is int? ? id : this.id,
      memberId: memberId ?? this.memberId,
      codeHash: codeHash ?? this.codeHash,
      expiresAt: expiresAt ?? this.expiresAt,
      usedAt: usedAt is DateTime? ? usedAt : this.usedAt,
    );
  }
}

class ChildLoginCodeUpdateTable extends _is.UpdateTable<ChildLoginCodeTable> {
  ChildLoginCodeUpdateTable(super.table);

  _is.ColumnValue<int, int> memberId(int value) => _is.ColumnValue(
    table.memberId,
    value,
  );

  _is.ColumnValue<String, String> codeHash(String value) => _is.ColumnValue(
    table.codeHash,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> usedAt(DateTime? value) =>
      _is.ColumnValue(
        table.usedAt,
        value,
      );
}

class ChildLoginCodeTable extends _is.Table<int?> {
  ChildLoginCodeTable({super.tableRelation})
    : super(tableName: 'child_login_code') {
    updateTable = ChildLoginCodeUpdateTable(this);
    memberId = _is.ColumnInt(
      'memberId',
      this,
    );
    codeHash = _is.ColumnString(
      'codeHash',
      this,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    usedAt = _is.ColumnDateTime(
      'usedAt',
      this,
    );
  }

  late final ChildLoginCodeUpdateTable updateTable;

  /// The child's membership this code signs in as.
  late final _is.ColumnInt memberId;

  /// Hash of the code the guardian reads out; the code itself is never stored.
  late final _is.ColumnString codeHash;

  /// 24 hours after it is generated (§8).
  late final _is.ColumnDateTime expiresAt;

  /// Set when the child signs in with it. A used code never works again.
  late final _is.ColumnDateTime usedAt;

  @override
  List<_is.Column> get columns => [
    id,
    memberId,
    codeHash,
    expiresAt,
    usedAt,
  ];
}

class ChildLoginCodeInclude extends _is.IncludeObject {
  ChildLoginCodeInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ChildLoginCode.t;
}

class ChildLoginCodeIncludeList extends _is.IncludeList {
  ChildLoginCodeIncludeList._({
    _is.WhereExpressionBuilder<ChildLoginCodeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChildLoginCode.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ChildLoginCode.t;
}

class ChildLoginCodeRepository {
  const ChildLoginCodeRepository._();

  /// Returns a list of [ChildLoginCode]s matching the given query parameters.
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
  Future<List<ChildLoginCode>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildLoginCodeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<ChildLoginCodeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ChildLoginCode>(
      where: where?.call(ChildLoginCode.t),
      orderBy: orderBy?.call(ChildLoginCode.t),
      orderByList: orderByList?.call(ChildLoginCode.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ChildLoginCode] matching the given query parameters.
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
  Future<ChildLoginCode?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildLoginCodeTable>? where,
    int? offset,
    _is.OrderByBuilder<ChildLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<ChildLoginCodeTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ChildLoginCode>(
      where: where?.call(ChildLoginCode.t),
      orderBy: orderBy?.call(ChildLoginCode.t),
      orderByList: orderByList?.call(ChildLoginCode.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ChildLoginCode] by its [id] or null if no such row exists.
  Future<ChildLoginCode?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ChildLoginCode>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ChildLoginCode]s in the list and returns the inserted rows.
  ///
  /// The returned [ChildLoginCode]s will have their `id` fields set.
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
  Future<List<ChildLoginCode>> insert(
    _is.DatabaseSession session,
    List<ChildLoginCode> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ChildLoginCode>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ChildLoginCode] and returns the inserted row.
  ///
  /// The returned [ChildLoginCode] will have its `id` field set.
  Future<ChildLoginCode> insertRow(
    _is.DatabaseSession session,
    ChildLoginCode row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChildLoginCode>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ChildLoginCode]s in the list and returns the resulting rows.
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
  /// The returned [ChildLoginCode]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildLoginCode>> upsert(
    _is.DatabaseSession session,
    List<ChildLoginCode> rows, {
    required _is.ColumnSelections<ChildLoginCodeTable> conflictColumns,
    _is.ColumnSelections<ChildLoginCodeTable>? updateColumns,
    _is.WhereExpressionBuilder<ChildLoginCodeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ChildLoginCode>(
      rows,
      conflictColumns: conflictColumns(ChildLoginCode.t),
      updateColumns: updateColumns?.call(ChildLoginCode.t),
      updateWhere: updateWhere?.call(ChildLoginCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ChildLoginCode] and returns the resulting row.
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
  /// The returned [ChildLoginCode] will have its `id` field set.
  Future<ChildLoginCode?> upsertRow(
    _is.DatabaseSession session,
    ChildLoginCode row, {
    required _is.ColumnSelections<ChildLoginCodeTable> conflictColumns,
    _is.ColumnSelections<ChildLoginCodeTable>? updateColumns,
    _is.WhereExpressionBuilder<ChildLoginCodeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ChildLoginCode>(
      row,
      conflictColumns: conflictColumns(ChildLoginCode.t),
      updateColumns: updateColumns?.call(ChildLoginCode.t),
      updateWhere: updateWhere?.call(ChildLoginCode.t),
      transaction: transaction,
    );
  }

  /// Updates all [ChildLoginCode]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildLoginCode>> update(
    _is.DatabaseSession session,
    List<ChildLoginCode> rows, {
    _is.ColumnSelections<ChildLoginCodeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ChildLoginCode>(
      rows,
      columns: columns?.call(ChildLoginCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ChildLoginCode]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChildLoginCode> updateRow(
    _is.DatabaseSession session,
    ChildLoginCode row, {
    _is.ColumnSelections<ChildLoginCodeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChildLoginCode>(
      row,
      columns: columns?.call(ChildLoginCode.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildLoginCode] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChildLoginCode?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ChildLoginCodeUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ChildLoginCode>(
      id,
      columnValues: columnValues(ChildLoginCode.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChildLoginCode]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildLoginCode>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ChildLoginCodeUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ChildLoginCodeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<ChildLoginCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ChildLoginCode>(
      columnValues: columnValues(ChildLoginCode.t.updateTable),
      where: where(ChildLoginCode.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildLoginCode.t),
      orderByList: orderByList?.call(ChildLoginCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ChildLoginCode]s in the list and returns the deleted rows.
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
  Future<List<ChildLoginCode>> delete(
    _is.DatabaseSession session,
    List<ChildLoginCode> rows, {
    _is.OrderByBuilder<ChildLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<ChildLoginCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ChildLoginCode>(
      rows,
      orderBy: orderBy?.call(ChildLoginCode.t),
      orderByList: orderByList?.call(ChildLoginCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ChildLoginCode].
  Future<ChildLoginCode> deleteRow(
    _is.DatabaseSession session,
    ChildLoginCode row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChildLoginCode>(
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
  Future<List<ChildLoginCode>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChildLoginCodeTable> where,
    _is.OrderByBuilder<ChildLoginCodeTable>? orderBy,
    _is.OrderByListBuilder<ChildLoginCodeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ChildLoginCode>(
      where: where(ChildLoginCode.t),
      orderBy: orderBy?.call(ChildLoginCode.t),
      orderByList: orderByList?.call(ChildLoginCode.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildLoginCodeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ChildLoginCode>(
      where: where?.call(ChildLoginCode.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ChildLoginCode] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChildLoginCodeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ChildLoginCode>(
      where: where(ChildLoginCode.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
