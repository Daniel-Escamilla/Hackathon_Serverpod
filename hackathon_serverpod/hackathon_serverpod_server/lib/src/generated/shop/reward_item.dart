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
import '../shop/reward_item_status.dart' as _iezbc0vz;

/// A reward in a group's shop, from the profile template or proposed by a member
/// (PRODUCT.md §6, §10.2).
abstract class RewardItem
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  RewardItem._({
    this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.price,
    _iezbc0vz.RewardItemStatus? status,
    required this.createdById,
    this.stock,
  }) : status = status ?? _iezbc0vz.RewardItemStatus.proposed;

  factory RewardItem({
    int? id,
    required int groupId,
    required String title,
    required String description,
    required int price,
    _iezbc0vz.RewardItemStatus? status,
    required int createdById,
    int? stock,
  }) = _RewardItemImpl;

  factory RewardItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return RewardItem(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      price: jsonSerialization['price'] as int,
      status: jsonSerialization['status'] == null
          ? null
          : _iezbc0vz.RewardItemStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      createdById: jsonSerialization['createdById'] as int,
      stock: jsonSerialization['stock'] as int?,
    );
  }

  static final t = RewardItemTable();

  static const db = RewardItemRepository._();

  @override
  int? id;

  int groupId;

  String title;

  String description;

  int price;

  _iezbc0vz.RewardItemStatus status;

  int createdById;

  /// Null means unlimited (the default per PRODUCT.md §6); a number caps how many times it can
  /// be bought.
  int? stock;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [RewardItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RewardItem copyWith({
    int? id,
    int? groupId,
    String? title,
    String? description,
    int? price,
    _iezbc0vz.RewardItemStatus? status,
    int? createdById,
    int? stock,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RewardItem',
      if (id != null) 'id': id,
      'groupId': groupId,
      'title': title,
      'description': description,
      'price': price,
      'status': status.toJson(),
      'createdById': createdById,
      if (stock != null) 'stock': stock,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RewardItem',
      if (id != null) 'id': id,
      'groupId': groupId,
      'title': title,
      'description': description,
      'price': price,
      'status': status.toJson(),
      'createdById': createdById,
      if (stock != null) 'stock': stock,
    };
  }

  static RewardItemInclude include() {
    return RewardItemInclude._();
  }

  static RewardItemIncludeList includeList({
    _is.WhereExpressionBuilder<RewardItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RewardItemTable>? orderBy,
    _is.OrderByListBuilder<RewardItemTable>? orderByList,
    RewardItemInclude? include,
  }) {
    return RewardItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RewardItem.t),
      orderByList: orderByList?.call(RewardItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RewardItemImpl extends RewardItem {
  _RewardItemImpl({
    int? id,
    required int groupId,
    required String title,
    required String description,
    required int price,
    _iezbc0vz.RewardItemStatus? status,
    required int createdById,
    int? stock,
  }) : super._(
         id: id,
         groupId: groupId,
         title: title,
         description: description,
         price: price,
         status: status,
         createdById: createdById,
         stock: stock,
       );

  /// Returns a shallow copy of this [RewardItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RewardItem copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? title,
    String? description,
    int? price,
    _iezbc0vz.RewardItemStatus? status,
    int? createdById,
    Object? stock = _Undefined,
  }) {
    return RewardItem(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      status: status ?? this.status,
      createdById: createdById ?? this.createdById,
      stock: stock is int? ? stock : this.stock,
    );
  }
}

class RewardItemUpdateTable extends _is.UpdateTable<RewardItemTable> {
  RewardItemUpdateTable(super.table);

  _is.ColumnValue<int, int> groupId(int value) => _is.ColumnValue(
    table.groupId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<int, int> price(int value) => _is.ColumnValue(
    table.price,
    value,
  );

  _is.ColumnValue<_iezbc0vz.RewardItemStatus, _iezbc0vz.RewardItemStatus>
  status(_iezbc0vz.RewardItemStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> createdById(int value) => _is.ColumnValue(
    table.createdById,
    value,
  );

  _is.ColumnValue<int, int> stock(int? value) => _is.ColumnValue(
    table.stock,
    value,
  );
}

class RewardItemTable extends _is.Table<int?> {
  RewardItemTable({super.tableRelation}) : super(tableName: 'reward_item') {
    updateTable = RewardItemUpdateTable(this);
    groupId = _is.ColumnInt(
      'groupId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    price = _is.ColumnInt(
      'price',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    createdById = _is.ColumnInt(
      'createdById',
      this,
    );
    stock = _is.ColumnInt(
      'stock',
      this,
    );
  }

  late final RewardItemUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  late final _is.ColumnInt price;

  late final _is.ColumnEnum<_iezbc0vz.RewardItemStatus> status;

  late final _is.ColumnInt createdById;

  /// Null means unlimited (the default per PRODUCT.md §6); a number caps how many times it can
  /// be bought.
  late final _is.ColumnInt stock;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    title,
    description,
    price,
    status,
    createdById,
    stock,
  ];
}

class RewardItemInclude extends _is.IncludeObject {
  RewardItemInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => RewardItem.t;
}

class RewardItemIncludeList extends _is.IncludeList {
  RewardItemIncludeList._({
    _is.WhereExpressionBuilder<RewardItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RewardItem.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => RewardItem.t;
}

class RewardItemRepository {
  const RewardItemRepository._();

  /// Returns a list of [RewardItem]s matching the given query parameters.
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
  Future<List<RewardItem>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RewardItemTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RewardItemTable>? orderBy,
    _is.OrderByListBuilder<RewardItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RewardItem>(
      where: where?.call(RewardItem.t),
      orderBy: orderBy?.call(RewardItem.t),
      orderByList: orderByList?.call(RewardItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RewardItem] matching the given query parameters.
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
  Future<RewardItem?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RewardItemTable>? where,
    int? offset,
    _is.OrderByBuilder<RewardItemTable>? orderBy,
    _is.OrderByListBuilder<RewardItemTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RewardItem>(
      where: where?.call(RewardItem.t),
      orderBy: orderBy?.call(RewardItem.t),
      orderByList: orderByList?.call(RewardItem.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RewardItem] by its [id] or null if no such row exists.
  Future<RewardItem?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RewardItem>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RewardItem]s in the list and returns the inserted rows.
  ///
  /// The returned [RewardItem]s will have their `id` fields set.
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
  Future<List<RewardItem>> insert(
    _is.DatabaseSession session,
    List<RewardItem> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RewardItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RewardItem] and returns the inserted row.
  ///
  /// The returned [RewardItem] will have its `id` field set.
  Future<RewardItem> insertRow(
    _is.DatabaseSession session,
    RewardItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<RewardItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RewardItem]s in the list and returns the resulting rows.
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
  /// The returned [RewardItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RewardItem>> upsert(
    _is.DatabaseSession session,
    List<RewardItem> rows, {
    required _is.ColumnSelections<RewardItemTable> conflictColumns,
    _is.ColumnSelections<RewardItemTable>? updateColumns,
    _is.WhereExpressionBuilder<RewardItemTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RewardItem>(
      rows,
      conflictColumns: conflictColumns(RewardItem.t),
      updateColumns: updateColumns?.call(RewardItem.t),
      updateWhere: updateWhere?.call(RewardItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RewardItem] and returns the resulting row.
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
  /// The returned [RewardItem] will have its `id` field set.
  Future<RewardItem?> upsertRow(
    _is.DatabaseSession session,
    RewardItem row, {
    required _is.ColumnSelections<RewardItemTable> conflictColumns,
    _is.ColumnSelections<RewardItemTable>? updateColumns,
    _is.WhereExpressionBuilder<RewardItemTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RewardItem>(
      row,
      conflictColumns: conflictColumns(RewardItem.t),
      updateColumns: updateColumns?.call(RewardItem.t),
      updateWhere: updateWhere?.call(RewardItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [RewardItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RewardItem>> update(
    _is.DatabaseSession session,
    List<RewardItem> rows, {
    _is.ColumnSelections<RewardItemTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RewardItem>(
      rows,
      columns: columns?.call(RewardItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RewardItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RewardItem> updateRow(
    _is.DatabaseSession session,
    RewardItem row, {
    _is.ColumnSelections<RewardItemTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<RewardItem>(
      row,
      columns: columns?.call(RewardItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RewardItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RewardItem?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<RewardItemUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<RewardItem>(
      id,
      columnValues: columnValues(RewardItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RewardItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RewardItem>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<RewardItemUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<RewardItemTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<RewardItemTable>? orderBy,
    _is.OrderByListBuilder<RewardItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RewardItem>(
      columnValues: columnValues(RewardItem.t.updateTable),
      where: where(RewardItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RewardItem.t),
      orderByList: orderByList?.call(RewardItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RewardItem]s in the list and returns the deleted rows.
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
  Future<List<RewardItem>> delete(
    _is.DatabaseSession session,
    List<RewardItem> rows, {
    _is.OrderByBuilder<RewardItemTable>? orderBy,
    _is.OrderByListBuilder<RewardItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RewardItem>(
      rows,
      orderBy: orderBy?.call(RewardItem.t),
      orderByList: orderByList?.call(RewardItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RewardItem].
  Future<RewardItem> deleteRow(
    _is.DatabaseSession session,
    RewardItem row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RewardItem>(
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
  Future<List<RewardItem>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RewardItemTable> where,
    _is.OrderByBuilder<RewardItemTable>? orderBy,
    _is.OrderByListBuilder<RewardItemTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RewardItem>(
      where: where(RewardItem.t),
      orderBy: orderBy?.call(RewardItem.t),
      orderByList: orderByList?.call(RewardItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<RewardItemTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<RewardItem>(
      where: where?.call(RewardItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RewardItem] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<RewardItemTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RewardItem>(
      where: where(RewardItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
