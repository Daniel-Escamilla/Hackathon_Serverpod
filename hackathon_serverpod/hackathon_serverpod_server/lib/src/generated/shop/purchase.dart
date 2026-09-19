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
import '../shop/purchase_status.dart' as _ifzoyvo9;

/// A bought RewardItem, pending until the chosen provider marks it delivered (PRODUCT.md §6,
/// §10.2).
abstract class Purchase
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Purchase._({
    this.id,
    required this.groupId,
    required this.itemId,
    required this.buyerId,
    required this.providerId,
    _ifzoyvo9.PurchaseStatus? status,
  }) : status = status ?? _ifzoyvo9.PurchaseStatus.pending;

  factory Purchase({
    int? id,
    required int groupId,
    required int itemId,
    required int buyerId,
    required int providerId,
    _ifzoyvo9.PurchaseStatus? status,
  }) = _PurchaseImpl;

  factory Purchase.fromJson(Map<String, dynamic> jsonSerialization) {
    return Purchase(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      itemId: jsonSerialization['itemId'] as int,
      buyerId: jsonSerialization['buyerId'] as int,
      providerId: jsonSerialization['providerId'] as int,
      status: jsonSerialization['status'] == null
          ? null
          : _ifzoyvo9.PurchaseStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
    );
  }

  static final t = PurchaseTable();

  static const db = PurchaseRepository._();

  @override
  int? id;

  int groupId;

  int itemId;

  int buyerId;

  /// Who has to fulfil it, chosen by the buyer among the other members.
  int providerId;

  _ifzoyvo9.PurchaseStatus status;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Purchase]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Purchase copyWith({
    int? id,
    int? groupId,
    int? itemId,
    int? buyerId,
    int? providerId,
    _ifzoyvo9.PurchaseStatus? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Purchase',
      if (id != null) 'id': id,
      'groupId': groupId,
      'itemId': itemId,
      'buyerId': buyerId,
      'providerId': providerId,
      'status': status.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Purchase',
      if (id != null) 'id': id,
      'groupId': groupId,
      'itemId': itemId,
      'buyerId': buyerId,
      'providerId': providerId,
      'status': status.toJson(),
    };
  }

  static PurchaseInclude include() {
    return PurchaseInclude._();
  }

  static PurchaseIncludeList includeList({
    _is.WhereExpressionBuilder<PurchaseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PurchaseTable>? orderBy,
    _is.OrderByListBuilder<PurchaseTable>? orderByList,
    PurchaseInclude? include,
  }) {
    return PurchaseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Purchase.t),
      orderByList: orderByList?.call(Purchase.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PurchaseImpl extends Purchase {
  _PurchaseImpl({
    int? id,
    required int groupId,
    required int itemId,
    required int buyerId,
    required int providerId,
    _ifzoyvo9.PurchaseStatus? status,
  }) : super._(
         id: id,
         groupId: groupId,
         itemId: itemId,
         buyerId: buyerId,
         providerId: providerId,
         status: status,
       );

  /// Returns a shallow copy of this [Purchase]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Purchase copyWith({
    Object? id = _Undefined,
    int? groupId,
    int? itemId,
    int? buyerId,
    int? providerId,
    _ifzoyvo9.PurchaseStatus? status,
  }) {
    return Purchase(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      itemId: itemId ?? this.itemId,
      buyerId: buyerId ?? this.buyerId,
      providerId: providerId ?? this.providerId,
      status: status ?? this.status,
    );
  }
}

class PurchaseUpdateTable extends _is.UpdateTable<PurchaseTable> {
  PurchaseUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<int, int> itemId(int value) => _is.ColumnValue(
    table.itemId,
    value,
  );

  _is.ColumnValue<int, int> buyerId(int value) => _is.ColumnValue(
    table.buyerId,
    value,
  );

  _is.ColumnValue<int, int> providerId(int value) => _is.ColumnValue(
    table.providerId,
    value,
  );

  _is.ColumnValue<_ifzoyvo9.PurchaseStatus, _ifzoyvo9.PurchaseStatus> status(
    _ifzoyvo9.PurchaseStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );
}

class PurchaseTable extends _is.Table<int?> {
  PurchaseTable({super.tableRelation}) : super(tableName: 'purchase') {
    updateTable = PurchaseUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    itemId = _is.ColumnInt(
      'itemId',
      this,
    );
    buyerId = _is.ColumnInt(
      'buyerId',
      this,
    );
    providerId = _is.ColumnInt(
      'providerId',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
  }

  late final PurchaseUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnInt itemId;

  late final _is.ColumnInt buyerId;

  /// Who has to fulfil it, chosen by the buyer among the other members.
  late final _is.ColumnInt providerId;

  late final _is.ColumnEnum<_ifzoyvo9.PurchaseStatus> status;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    itemId,
    buyerId,
    providerId,
    status,
  ];
}

class PurchaseInclude extends _is.IncludeObject {
  PurchaseInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Purchase.t;
}

class PurchaseIncludeList extends _is.IncludeList {
  PurchaseIncludeList._({
    _is.WhereExpressionBuilder<PurchaseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Purchase.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Purchase.t;
}

class PurchaseRepository {
  const PurchaseRepository._();

  /// Returns a list of [Purchase]s matching the given query parameters.
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
  Future<List<Purchase>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PurchaseTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PurchaseTable>? orderBy,
    _is.OrderByListBuilder<PurchaseTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Purchase>(
      where: where?.call(Purchase.t),
      orderBy: orderBy?.call(Purchase.t),
      orderByList: orderByList?.call(Purchase.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Purchase] matching the given query parameters.
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
  Future<Purchase?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PurchaseTable>? where,
    int? offset,
    _is.OrderByBuilder<PurchaseTable>? orderBy,
    _is.OrderByListBuilder<PurchaseTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Purchase>(
      where: where?.call(Purchase.t),
      orderBy: orderBy?.call(Purchase.t),
      orderByList: orderByList?.call(Purchase.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Purchase] by its [id] or null if no such row exists.
  Future<Purchase?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Purchase>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Purchase]s in the list and returns the inserted rows.
  ///
  /// The returned [Purchase]s will have their `id` fields set.
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
  Future<List<Purchase>> insert(
    _is.DatabaseSession session,
    List<Purchase> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Purchase>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Purchase] and returns the inserted row.
  ///
  /// The returned [Purchase] will have its `id` field set.
  Future<Purchase> insertRow(
    _is.DatabaseSession session,
    Purchase row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Purchase>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Purchase]s in the list and returns the resulting rows.
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
  /// The returned [Purchase]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Purchase>> upsert(
    _is.DatabaseSession session,
    List<Purchase> rows, {
    required _is.ColumnSelections<PurchaseTable> conflictColumns,
    _is.ColumnSelections<PurchaseTable>? updateColumns,
    _is.WhereExpressionBuilder<PurchaseTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Purchase>(
      rows,
      conflictColumns: conflictColumns(Purchase.t),
      updateColumns: updateColumns?.call(Purchase.t),
      updateWhere: updateWhere?.call(Purchase.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Purchase] and returns the resulting row.
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
  /// The returned [Purchase] will have its `id` field set.
  Future<Purchase?> upsertRow(
    _is.DatabaseSession session,
    Purchase row, {
    required _is.ColumnSelections<PurchaseTable> conflictColumns,
    _is.ColumnSelections<PurchaseTable>? updateColumns,
    _is.WhereExpressionBuilder<PurchaseTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Purchase>(
      row,
      conflictColumns: conflictColumns(Purchase.t),
      updateColumns: updateColumns?.call(Purchase.t),
      updateWhere: updateWhere?.call(Purchase.t),
      transaction: transaction,
    );
  }

  /// Updates all [Purchase]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Purchase>> update(
    _is.DatabaseSession session,
    List<Purchase> rows, {
    _is.ColumnSelections<PurchaseTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Purchase>(
      rows,
      columns: columns?.call(Purchase.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Purchase]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Purchase> updateRow(
    _is.DatabaseSession session,
    Purchase row, {
    _is.ColumnSelections<PurchaseTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Purchase>(
      row,
      columns: columns?.call(Purchase.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Purchase] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Purchase?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PurchaseUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Purchase>(
      id,
      columnValues: columnValues(Purchase.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Purchase]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Purchase>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PurchaseUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PurchaseTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PurchaseTable>? orderBy,
    _is.OrderByListBuilder<PurchaseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Purchase>(
      columnValues: columnValues(Purchase.t.updateTable),
      where: where(Purchase.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Purchase.t),
      orderByList: orderByList?.call(Purchase.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Purchase]s in the list and returns the deleted rows.
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
  Future<List<Purchase>> delete(
    _is.DatabaseSession session,
    List<Purchase> rows, {
    _is.OrderByBuilder<PurchaseTable>? orderBy,
    _is.OrderByListBuilder<PurchaseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Purchase>(
      rows,
      orderBy: orderBy?.call(Purchase.t),
      orderByList: orderByList?.call(Purchase.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Purchase].
  Future<Purchase> deleteRow(
    _is.DatabaseSession session,
    Purchase row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Purchase>(
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
  Future<List<Purchase>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PurchaseTable> where,
    _is.OrderByBuilder<PurchaseTable>? orderBy,
    _is.OrderByListBuilder<PurchaseTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Purchase>(
      where: where(Purchase.t),
      orderBy: orderBy?.call(Purchase.t),
      orderByList: orderByList?.call(Purchase.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PurchaseTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Purchase>(
      where: where?.call(Purchase.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Purchase] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PurchaseTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Purchase>(
      where: where(Purchase.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
