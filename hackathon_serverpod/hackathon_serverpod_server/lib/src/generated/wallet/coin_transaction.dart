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
import '../wallet/coin_transaction_reason.dart' as _iling76c;

/// One entry in a member's coin history. Balance and ranking are derived from summing these
/// (PRODUCT.md §4.6, §10.2). Positive amount = coins in, negative = coins out.
abstract class CoinTransaction
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CoinTransaction._({
    this.id,
    required this.groupId,
    required this.memberId,
    required this.amount,
    required this.reason,
    this.taskId,
    this.purchaseId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CoinTransaction({
    int? id,
    required int groupId,
    required int memberId,
    required int amount,
    required _iling76c.CoinTransactionReason reason,
    int? taskId,
    int? purchaseId,
    DateTime? createdAt,
  }) = _CoinTransactionImpl;

  factory CoinTransaction.fromJson(Map<String, dynamic> jsonSerialization) {
    return CoinTransaction(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      memberId: jsonSerialization['memberId'] as int,
      amount: jsonSerialization['amount'] as int,
      reason: _iling76c.CoinTransactionReason.fromJson(
        (jsonSerialization['reason'] as String),
      ),
      taskId: jsonSerialization['taskId'] as int?,
      purchaseId: jsonSerialization['purchaseId'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = CoinTransactionTable();

  static const db = CoinTransactionRepository._();

  @override
  int? id;

  int groupId;

  int memberId;

  int amount;

  _iling76c.CoinTransactionReason reason;

  /// Set when the transaction comes from a task (earned, or the fine for a denied/expired vote).
  /// Left as a plain id, not a relation: Task does not exist yet, and a transaction references at
  /// most one of taskId/purchaseId, never both.
  int? taskId;

  /// Set when the transaction comes from the shop (spent on a purchase, refunded, or the fine for
  /// refusing to fulfil one). Same reasoning as taskId: plain id, not a relation.
  int? purchaseId;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CoinTransaction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CoinTransaction copyWith({
    int? id,
    int? groupId,
    int? memberId,
    int? amount,
    _iling76c.CoinTransactionReason? reason,
    int? taskId,
    int? purchaseId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CoinTransaction',
      if (id != null) 'id': id,
      'groupId': groupId,
      'memberId': memberId,
      'amount': amount,
      'reason': reason.toJson(),
      if (taskId != null) 'taskId': taskId,
      if (purchaseId != null) 'purchaseId': purchaseId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CoinTransaction',
      if (id != null) 'id': id,
      'groupId': groupId,
      'memberId': memberId,
      'amount': amount,
      'reason': reason.toJson(),
      if (taskId != null) 'taskId': taskId,
      if (purchaseId != null) 'purchaseId': purchaseId,
      'createdAt': createdAt.toJson(),
    };
  }

  static CoinTransactionInclude include() {
    return CoinTransactionInclude._();
  }

  static CoinTransactionIncludeList includeList({
    _is.WhereExpressionBuilder<CoinTransactionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CoinTransactionTable>? orderBy,
    _is.OrderByListBuilder<CoinTransactionTable>? orderByList,
    CoinTransactionInclude? include,
  }) {
    return CoinTransactionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CoinTransaction.t),
      orderByList: orderByList?.call(CoinTransaction.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CoinTransactionImpl extends CoinTransaction {
  _CoinTransactionImpl({
    int? id,
    required int groupId,
    required int memberId,
    required int amount,
    required _iling76c.CoinTransactionReason reason,
    int? taskId,
    int? purchaseId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         groupId: groupId,
         memberId: memberId,
         amount: amount,
         reason: reason,
         taskId: taskId,
         purchaseId: purchaseId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CoinTransaction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CoinTransaction copyWith({
    Object? id = _Undefined,
    int? groupId,
    int? memberId,
    int? amount,
    _iling76c.CoinTransactionReason? reason,
    Object? taskId = _Undefined,
    Object? purchaseId = _Undefined,
    DateTime? createdAt,
  }) {
    return CoinTransaction(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      taskId: taskId is int? ? taskId : this.taskId,
      purchaseId: purchaseId is int? ? purchaseId : this.purchaseId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CoinTransactionUpdateTable extends _is.UpdateTable<CoinTransactionTable> {
  CoinTransactionUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<int, int> memberId(int value) => _is.ColumnValue(
    table.memberId,
    value,
  );

  _is.ColumnValue<int, int> amount(int value) => _is.ColumnValue(
    table.amount,
    value,
  );

  _is.ColumnValue<
    _iling76c.CoinTransactionReason,
    _iling76c.CoinTransactionReason
  >
  reason(_iling76c.CoinTransactionReason value) => _is.ColumnValue(
    table.reason,
    value,
  );

  _is.ColumnValue<int, int> taskId(int? value) => _is.ColumnValue(
    table.taskId,
    value,
  );

  _is.ColumnValue<int, int> purchaseId(int? value) => _is.ColumnValue(
    table.purchaseId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class CoinTransactionTable extends _is.Table<int?> {
  CoinTransactionTable({super.tableRelation})
    : super(tableName: 'coin_transaction') {
    updateTable = CoinTransactionUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    memberId = _is.ColumnInt(
      'memberId',
      this,
    );
    amount = _is.ColumnInt(
      'amount',
      this,
    );
    reason = _is.ColumnEnum(
      'reason',
      this,
      _is.EnumSerialization.byName,
    );
    taskId = _is.ColumnInt(
      'taskId',
      this,
    );
    purchaseId = _is.ColumnInt(
      'purchaseId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
      hasDefault: true,
    );
  }

  late final CoinTransactionUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnInt memberId;

  late final _is.ColumnInt amount;

  late final _is.ColumnEnum<_iling76c.CoinTransactionReason> reason;

  /// Set when the transaction comes from a task (earned, or the fine for a denied/expired vote).
  /// Left as a plain id, not a relation: Task does not exist yet, and a transaction references at
  /// most one of taskId/purchaseId, never both.
  late final _is.ColumnInt taskId;

  /// Set when the transaction comes from the shop (spent on a purchase, refunded, or the fine for
  /// refusing to fulfil one). Same reasoning as taskId: plain id, not a relation.
  late final _is.ColumnInt purchaseId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    memberId,
    amount,
    reason,
    taskId,
    purchaseId,
    createdAt,
  ];
}

class CoinTransactionInclude extends _is.IncludeObject {
  CoinTransactionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CoinTransaction.t;
}

class CoinTransactionIncludeList extends _is.IncludeList {
  CoinTransactionIncludeList._({
    _is.WhereExpressionBuilder<CoinTransactionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CoinTransaction.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CoinTransaction.t;
}

class CoinTransactionRepository {
  const CoinTransactionRepository._();

  /// Returns a list of [CoinTransaction]s matching the given query parameters.
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
  Future<List<CoinTransaction>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CoinTransactionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CoinTransactionTable>? orderBy,
    _is.OrderByListBuilder<CoinTransactionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CoinTransaction>(
      where: where?.call(CoinTransaction.t),
      orderBy: orderBy?.call(CoinTransaction.t),
      orderByList: orderByList?.call(CoinTransaction.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CoinTransaction] matching the given query parameters.
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
  Future<CoinTransaction?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CoinTransactionTable>? where,
    int? offset,
    _is.OrderByBuilder<CoinTransactionTable>? orderBy,
    _is.OrderByListBuilder<CoinTransactionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CoinTransaction>(
      where: where?.call(CoinTransaction.t),
      orderBy: orderBy?.call(CoinTransaction.t),
      orderByList: orderByList?.call(CoinTransaction.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CoinTransaction] by its [id] or null if no such row exists.
  Future<CoinTransaction?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CoinTransaction>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CoinTransaction]s in the list and returns the inserted rows.
  ///
  /// The returned [CoinTransaction]s will have their `id` fields set.
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
  Future<List<CoinTransaction>> insert(
    _is.DatabaseSession session,
    List<CoinTransaction> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CoinTransaction>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CoinTransaction] and returns the inserted row.
  ///
  /// The returned [CoinTransaction] will have its `id` field set.
  Future<CoinTransaction> insertRow(
    _is.DatabaseSession session,
    CoinTransaction row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CoinTransaction>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CoinTransaction]s in the list and returns the resulting rows.
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
  /// The returned [CoinTransaction]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CoinTransaction>> upsert(
    _is.DatabaseSession session,
    List<CoinTransaction> rows, {
    required _is.ColumnSelections<CoinTransactionTable> conflictColumns,
    _is.ColumnSelections<CoinTransactionTable>? updateColumns,
    _is.WhereExpressionBuilder<CoinTransactionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CoinTransaction>(
      rows,
      conflictColumns: conflictColumns(CoinTransaction.t),
      updateColumns: updateColumns?.call(CoinTransaction.t),
      updateWhere: updateWhere?.call(CoinTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CoinTransaction] and returns the resulting row.
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
  /// The returned [CoinTransaction] will have its `id` field set.
  Future<CoinTransaction?> upsertRow(
    _is.DatabaseSession session,
    CoinTransaction row, {
    required _is.ColumnSelections<CoinTransactionTable> conflictColumns,
    _is.ColumnSelections<CoinTransactionTable>? updateColumns,
    _is.WhereExpressionBuilder<CoinTransactionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CoinTransaction>(
      row,
      conflictColumns: conflictColumns(CoinTransaction.t),
      updateColumns: updateColumns?.call(CoinTransaction.t),
      updateWhere: updateWhere?.call(CoinTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates all [CoinTransaction]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CoinTransaction>> update(
    _is.DatabaseSession session,
    List<CoinTransaction> rows, {
    _is.ColumnSelections<CoinTransactionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CoinTransaction>(
      rows,
      columns: columns?.call(CoinTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CoinTransaction]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CoinTransaction> updateRow(
    _is.DatabaseSession session,
    CoinTransaction row, {
    _is.ColumnSelections<CoinTransactionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CoinTransaction>(
      row,
      columns: columns?.call(CoinTransaction.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CoinTransaction] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CoinTransaction?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CoinTransactionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CoinTransaction>(
      id,
      columnValues: columnValues(CoinTransaction.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CoinTransaction]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CoinTransaction>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CoinTransactionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CoinTransactionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CoinTransactionTable>? orderBy,
    _is.OrderByListBuilder<CoinTransactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CoinTransaction>(
      columnValues: columnValues(CoinTransaction.t.updateTable),
      where: where(CoinTransaction.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CoinTransaction.t),
      orderByList: orderByList?.call(CoinTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CoinTransaction]s in the list and returns the deleted rows.
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
  Future<List<CoinTransaction>> delete(
    _is.DatabaseSession session,
    List<CoinTransaction> rows, {
    _is.OrderByBuilder<CoinTransactionTable>? orderBy,
    _is.OrderByListBuilder<CoinTransactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CoinTransaction>(
      rows,
      orderBy: orderBy?.call(CoinTransaction.t),
      orderByList: orderByList?.call(CoinTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CoinTransaction].
  Future<CoinTransaction> deleteRow(
    _is.DatabaseSession session,
    CoinTransaction row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CoinTransaction>(
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
  Future<List<CoinTransaction>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CoinTransactionTable> where,
    _is.OrderByBuilder<CoinTransactionTable>? orderBy,
    _is.OrderByListBuilder<CoinTransactionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CoinTransaction>(
      where: where(CoinTransaction.t),
      orderBy: orderBy?.call(CoinTransaction.t),
      orderByList: orderByList?.call(CoinTransaction.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CoinTransactionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CoinTransaction>(
      where: where?.call(CoinTransaction.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CoinTransaction] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CoinTransactionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CoinTransaction>(
      where: where(CoinTransaction.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
