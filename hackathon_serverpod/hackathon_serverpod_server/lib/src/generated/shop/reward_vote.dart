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

/// One member's vote on a proposed RewardItem, same shape as TaskVote (PRODUCT.md §10.2).
abstract class RewardVote
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RewardVote._({
    this.id,
    required this.itemId,
    required this.memberId,
    required this.approve,
  });

  factory RewardVote({
    int? id,
    required int itemId,
    required int memberId,
    required bool approve,
  }) = _RewardVoteImpl;

  factory RewardVote.fromJson(Map<String, dynamic> jsonSerialization) {
    return RewardVote(
      id: jsonSerialization['id'] as int?,
      itemId: jsonSerialization['itemId'] as int,
      memberId: jsonSerialization['memberId'] as int,
      approve: _is.BoolJsonExtension.fromJson(jsonSerialization['approve']),
    );
  }

  static final t = RewardVoteTable();

  static const db = RewardVoteRepository._();

  @override
  int? id;

  int itemId;

  /// One vote per member per item.
  int memberId;

  bool approve;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RewardVote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RewardVote copyWith({
    int? id,
    int? itemId,
    int? memberId,
    bool? approve,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RewardVote',
      if (id != null) 'id': id,
      'itemId': itemId,
      'memberId': memberId,
      'approve': approve,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RewardVote',
      if (id != null) 'id': id,
      'itemId': itemId,
      'memberId': memberId,
      'approve': approve,
    };
  }

  static RewardVoteInclude include() {
    return RewardVoteInclude._();
  }

  static RewardVoteIncludeList includeList({
    _is.WhereExpressionBuilder<RewardVoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RewardVoteTable>? orderBy,
    _is.OrderByListBuilder<RewardVoteTable>? orderByList,
    RewardVoteInclude? include,
  }) {
    return RewardVoteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RewardVote.t),
      orderByList: orderByList?.call(RewardVote.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RewardVoteImpl extends RewardVote {
  _RewardVoteImpl({
    int? id,
    required int itemId,
    required int memberId,
    required bool approve,
  }) : super._(
         id: id,
         itemId: itemId,
         memberId: memberId,
         approve: approve,
       );

  /// Returns a shallow copy of this [RewardVote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RewardVote copyWith({
    Object? id = _Undefined,
    int? itemId,
    int? memberId,
    bool? approve,
  }) {
    return RewardVote(
      id: id is int? ? id : this.id,
      itemId: itemId ?? this.itemId,
      memberId: memberId ?? this.memberId,
      approve: approve ?? this.approve,
    );
  }
}

class RewardVoteUpdateTable extends _is.UpdateTable<RewardVoteTable> {
  RewardVoteUpdateTable(super.table);

  _is.ColumnValue<int, int> itemId(int value) => _is.ColumnValue(
    table.itemId,
    value,
  );

  _is.ColumnValue<int, int> memberId(int value) => _is.ColumnValue(
    table.memberId,
    value,
  );

  _is.ColumnValue<bool, bool> approve(bool value) => _is.ColumnValue(
    table.approve,
    value,
  );
}

class RewardVoteTable extends _is.Table<int?> {
  RewardVoteTable({super.tableRelation}) : super(tableName: 'reward_vote') {
    updateTable = RewardVoteUpdateTable(this);
    itemId = _is.ColumnInt(
      'itemId',
      this,
    );
    memberId = _is.ColumnInt(
      'memberId',
      this,
    );
    approve = _is.ColumnBool(
      'approve',
      this,
    );
  }

  late final RewardVoteUpdateTable updateTable;

  late final _is.ColumnInt itemId;

  /// One vote per member per item.
  late final _is.ColumnInt memberId;

  late final _is.ColumnBool approve;

  @override
  List<_is.Column> get columns => [
    id,
    itemId,
    memberId,
    approve,
  ];
}

class RewardVoteInclude extends _is.IncludeObject {
  RewardVoteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => RewardVote.t;
}

class RewardVoteIncludeList extends _is.IncludeList {
  RewardVoteIncludeList._({
    _is.WhereExpressionBuilder<RewardVoteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RewardVote.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RewardVote.t;
}

class RewardVoteRepository {
  const RewardVoteRepository._();

  /// Returns a list of [RewardVote]s matching the given query parameters.
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
  Future<List<RewardVote>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RewardVoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RewardVoteTable>? orderBy,
    _is.OrderByListBuilder<RewardVoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RewardVote>(
      where: where?.call(RewardVote.t),
      orderBy: orderBy?.call(RewardVote.t),
      orderByList: orderByList?.call(RewardVote.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RewardVote] matching the given query parameters.
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
  Future<RewardVote?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RewardVoteTable>? where,
    int? offset,
    _is.OrderByBuilder<RewardVoteTable>? orderBy,
    _is.OrderByListBuilder<RewardVoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RewardVote>(
      where: where?.call(RewardVote.t),
      orderBy: orderBy?.call(RewardVote.t),
      orderByList: orderByList?.call(RewardVote.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RewardVote] by its [id] or null if no such row exists.
  Future<RewardVote?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RewardVote>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RewardVote]s in the list and returns the inserted rows.
  ///
  /// The returned [RewardVote]s will have their `id` fields set.
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
  Future<List<RewardVote>> insert(
    _is.DatabaseSession session,
    List<RewardVote> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RewardVote>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RewardVote] and returns the inserted row.
  ///
  /// The returned [RewardVote] will have its `id` field set.
  Future<RewardVote> insertRow(
    _is.DatabaseSession session,
    RewardVote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RewardVote>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RewardVote]s in the list and returns the resulting rows.
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
  /// The returned [RewardVote]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RewardVote>> upsert(
    _is.DatabaseSession session,
    List<RewardVote> rows, {
    required _is.ColumnSelections<RewardVoteTable> conflictColumns,
    _is.ColumnSelections<RewardVoteTable>? updateColumns,
    _is.WhereExpressionBuilder<RewardVoteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RewardVote>(
      rows,
      conflictColumns: conflictColumns(RewardVote.t),
      updateColumns: updateColumns?.call(RewardVote.t),
      updateWhere: updateWhere?.call(RewardVote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RewardVote] and returns the resulting row.
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
  /// The returned [RewardVote] will have its `id` field set.
  Future<RewardVote?> upsertRow(
    _is.DatabaseSession session,
    RewardVote row, {
    required _is.ColumnSelections<RewardVoteTable> conflictColumns,
    _is.ColumnSelections<RewardVoteTable>? updateColumns,
    _is.WhereExpressionBuilder<RewardVoteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RewardVote>(
      row,
      conflictColumns: conflictColumns(RewardVote.t),
      updateColumns: updateColumns?.call(RewardVote.t),
      updateWhere: updateWhere?.call(RewardVote.t),
      transaction: transaction,
    );
  }

  /// Updates all [RewardVote]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RewardVote>> update(
    _is.DatabaseSession session,
    List<RewardVote> rows, {
    _is.ColumnSelections<RewardVoteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RewardVote>(
      rows,
      columns: columns?.call(RewardVote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RewardVote]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RewardVote> updateRow(
    _is.DatabaseSession session,
    RewardVote row, {
    _is.ColumnSelections<RewardVoteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RewardVote>(
      row,
      columns: columns?.call(RewardVote.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RewardVote] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RewardVote?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RewardVoteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RewardVote>(
      id,
      columnValues: columnValues(RewardVote.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RewardVote]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RewardVote>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RewardVoteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RewardVoteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RewardVoteTable>? orderBy,
    _is.OrderByListBuilder<RewardVoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RewardVote>(
      columnValues: columnValues(RewardVote.t.updateTable),
      where: where(RewardVote.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RewardVote.t),
      orderByList: orderByList?.call(RewardVote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RewardVote]s in the list and returns the deleted rows.
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
  Future<List<RewardVote>> delete(
    _is.DatabaseSession session,
    List<RewardVote> rows, {
    _is.OrderByBuilder<RewardVoteTable>? orderBy,
    _is.OrderByListBuilder<RewardVoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RewardVote>(
      rows,
      orderBy: orderBy?.call(RewardVote.t),
      orderByList: orderByList?.call(RewardVote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RewardVote].
  Future<RewardVote> deleteRow(
    _is.DatabaseSession session,
    RewardVote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RewardVote>(
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
  Future<List<RewardVote>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RewardVoteTable> where,
    _is.OrderByBuilder<RewardVoteTable>? orderBy,
    _is.OrderByListBuilder<RewardVoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RewardVote>(
      where: where(RewardVote.t),
      orderBy: orderBy?.call(RewardVote.t),
      orderByList: orderByList?.call(RewardVote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RewardVoteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RewardVote>(
      where: where?.call(RewardVote.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RewardVote] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RewardVoteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RewardVote>(
      where: where(RewardVote.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
