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
import '../tasks/task_kind.dart' as _ijul8zzi;
import '../tasks/task_recurrence.dart' as _irx5q63y;
import '../tasks/task_status.dart' as _i18yar27;

/// A proposed or in-progress household task, the core of the cycle (PRODUCT.md §3, §5, §10.2).
abstract class Task implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Task._({
    this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.reward,
    _ijul8zzi.TaskKind? kind,
    this.recurrence,
    _i18yar27.TaskStatus? status,
    required this.proposedById,
    this.doneById,
    this.voteClosesAt,
  }) : kind = kind ?? _ijul8zzi.TaskKind.oneOff,
       status = status ?? _i18yar27.TaskStatus.proposed;

  factory Task({
    int? id,
    required int groupId,
    required String title,
    required String description,
    required int reward,
    _ijul8zzi.TaskKind? kind,
    _irx5q63y.TaskRecurrence? recurrence,
    _i18yar27.TaskStatus? status,
    required int proposedById,
    int? doneById,
    DateTime? voteClosesAt,
  }) = _TaskImpl;

  factory Task.fromJson(Map<String, dynamic> jsonSerialization) {
    return Task(
      id: jsonSerialization['id'] as int?,
      groupId: jsonSerialization['groupId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      reward: jsonSerialization['reward'] as int,
      kind: jsonSerialization['kind'] == null
          ? null
          : _ijul8zzi.TaskKind.fromJson((jsonSerialization['kind'] as String)),
      recurrence: jsonSerialization['recurrence'] == null
          ? null
          : _irx5q63y.TaskRecurrence.fromJson(
              (jsonSerialization['recurrence'] as String),
            ),
      status: jsonSerialization['status'] == null
          ? null
          : _i18yar27.TaskStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      proposedById: jsonSerialization['proposedById'] as int,
      doneById: jsonSerialization['doneById'] as int?,
      voteClosesAt: jsonSerialization['voteClosesAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['voteClosesAt'],
            ),
    );
  }

  static final t = TaskTable();

  static const db = TaskRepository._();

  @override
  int? id;

  int groupId;

  String title;

  String description;

  /// Coins paid on validation, never on claiming (PRODUCT.md §3). Also the base the fines in §4.4
  /// are a percentage of.
  int reward;

  _ijul8zzi.TaskKind kind;

  /// Only set for `mission`-kind tasks (PRODUCT.md §5).
  _irx5q63y.TaskRecurrence? recurrence;

  _i18yar27.TaskStatus status;

  int proposedById;

  /// Who claimed the task by pressing "done". Null until then; whoever gets there first wins the
  /// race (PRODUCT.md §3, §10.2).
  int? doneById;

  /// When the open proposal or completion vote closes, for the FutureCall that expires it
  /// (PRODUCT.md §4.2, §10.5). Null outside an open vote.
  DateTime? voteClosesAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Task copyWith({
    int? id,
    int? groupId,
    String? title,
    String? description,
    int? reward,
    _ijul8zzi.TaskKind? kind,
    _irx5q63y.TaskRecurrence? recurrence,
    _i18yar27.TaskStatus? status,
    int? proposedById,
    int? doneById,
    DateTime? voteClosesAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'groupId': groupId,
      'title': title,
      'description': description,
      'reward': reward,
      'kind': kind.toJson(),
      if (recurrence != null) 'recurrence': recurrence?.toJson(),
      'status': status.toJson(),
      'proposedById': proposedById,
      if (doneById != null) 'doneById': doneById,
      if (voteClosesAt != null) 'voteClosesAt': voteClosesAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'groupId': groupId,
      'title': title,
      'description': description,
      'reward': reward,
      'kind': kind.toJson(),
      if (recurrence != null) 'recurrence': recurrence?.toJson(),
      'status': status.toJson(),
      'proposedById': proposedById,
      if (doneById != null) 'doneById': doneById,
      if (voteClosesAt != null) 'voteClosesAt': voteClosesAt?.toJson(),
    };
  }

  static TaskInclude include() {
    return TaskInclude._();
  }

  static TaskIncludeList includeList({
    _is.WhereExpressionBuilder<TaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    TaskInclude? include,
  }) {
    return TaskIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskImpl extends Task {
  _TaskImpl({
    int? id,
    required int groupId,
    required String title,
    required String description,
    required int reward,
    _ijul8zzi.TaskKind? kind,
    _irx5q63y.TaskRecurrence? recurrence,
    _i18yar27.TaskStatus? status,
    required int proposedById,
    int? doneById,
    DateTime? voteClosesAt,
  }) : super._(
         id: id,
         groupId: groupId,
         title: title,
         description: description,
         reward: reward,
         kind: kind,
         recurrence: recurrence,
         status: status,
         proposedById: proposedById,
         doneById: doneById,
         voteClosesAt: voteClosesAt,
       );

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Task copyWith({
    Object? id = _Undefined,
    int? groupId,
    String? title,
    String? description,
    int? reward,
    _ijul8zzi.TaskKind? kind,
    Object? recurrence = _Undefined,
    _i18yar27.TaskStatus? status,
    int? proposedById,
    Object? doneById = _Undefined,
    Object? voteClosesAt = _Undefined,
  }) {
    return Task(
      id: id is int? ? id : this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      reward: reward ?? this.reward,
      kind: kind ?? this.kind,
      recurrence: recurrence is _irx5q63y.TaskRecurrence?
          ? recurrence
          : this.recurrence,
      status: status ?? this.status,
      proposedById: proposedById ?? this.proposedById,
      doneById: doneById is int? ? doneById : this.doneById,
      voteClosesAt: voteClosesAt is DateTime?
          ? voteClosesAt
          : this.voteClosesAt,
    );
  }
}

class TaskUpdateTable extends _is.UpdateTable<TaskTable> {
  TaskUpdateTable(super.table);

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

  _is.ColumnValue<int, int> reward(int value) => _is.ColumnValue(
    table.reward,
    value,
  );

  _is.ColumnValue<_ijul8zzi.TaskKind, _ijul8zzi.TaskKind> kind(
    _ijul8zzi.TaskKind value,
  ) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<_irx5q63y.TaskRecurrence, _irx5q63y.TaskRecurrence>
  recurrence(_irx5q63y.TaskRecurrence? value) => _is.ColumnValue(
    table.recurrence,
    value,
  );

  _is.ColumnValue<_i18yar27.TaskStatus, _i18yar27.TaskStatus> status(
    _i18yar27.TaskStatus value,
  ) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> proposedById(int value) => _is.ColumnValue(
    table.proposedById,
    value,
  );

  _is.ColumnValue<int, int> doneById(int? value) => _is.ColumnValue(
    table.doneById,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> voteClosesAt(DateTime? value) =>
      _is.ColumnValue(
        table.voteClosesAt,
        value,
      );
}

class TaskTable extends _is.Table<int?> {
  TaskTable({super.tableRelation}) : super(tableName: 'task') {
    updateTable = TaskUpdateTable(this);
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
    reward = _is.ColumnInt(
      'reward',
      this,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    recurrence = _is.ColumnEnum(
      'recurrence',
      this,
      _is.EnumSerialization.byName,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    proposedById = _is.ColumnInt(
      'proposedById',
      this,
    );
    doneById = _is.ColumnInt(
      'doneById',
      this,
    );
    voteClosesAt = _is.ColumnDateTime(
      'voteClosesAt',
      this,
    );
  }

  late final TaskUpdateTable updateTable;

  late final _is.ColumnInt groupId;

  late final _is.ColumnString title;

  late final _is.ColumnString description;

  /// Coins paid on validation, never on claiming (PRODUCT.md §3). Also the base the fines in §4.4
  /// are a percentage of.
  late final _is.ColumnInt reward;

  late final _is.ColumnEnum<_ijul8zzi.TaskKind> kind;

  /// Only set for `mission`-kind tasks (PRODUCT.md §5).
  late final _is.ColumnEnum<_irx5q63y.TaskRecurrence> recurrence;

  late final _is.ColumnEnum<_i18yar27.TaskStatus> status;

  late final _is.ColumnInt proposedById;

  /// Who claimed the task by pressing "done". Null until then; whoever gets there first wins the
  /// race (PRODUCT.md §3, §10.2).
  late final _is.ColumnInt doneById;

  /// When the open proposal or completion vote closes, for the FutureCall that expires it
  /// (PRODUCT.md §4.2, §10.5). Null outside an open vote.
  late final _is.ColumnDateTime voteClosesAt;

  @override
  List<_is.Column> get columns => [
    id,
    groupId,
    title,
    description,
    reward,
    kind,
    recurrence,
    status,
    proposedById,
    doneById,
    voteClosesAt,
  ];
}

class TaskInclude extends _is.IncludeObject {
  TaskInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Task.t;
}

class TaskIncludeList extends _is.IncludeList {
  TaskIncludeList._({
    _is.WhereExpressionBuilder<TaskTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Task.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Task.t;
}

class TaskRepository {
  const TaskRepository._();

  /// Returns a list of [Task]s matching the given query parameters.
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
  Future<List<Task>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaskTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Task>(
      where: where?.call(Task.t),
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Task] matching the given query parameters.
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
  Future<Task?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaskTable>? where,
    int? offset,
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Task>(
      where: where?.call(Task.t),
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Task] by its [id] or null if no such row exists.
  Future<Task?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Task>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Task]s in the list and returns the inserted rows.
  ///
  /// The returned [Task]s will have their `id` fields set.
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
  Future<List<Task>> insert(
    _is.DatabaseSession session,
    List<Task> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Task>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Task] and returns the inserted row.
  ///
  /// The returned [Task] will have its `id` field set.
  Future<Task> insertRow(
    _is.DatabaseSession session,
    Task row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Task>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Task]s in the list and returns the resulting rows.
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
  /// The returned [Task]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Task>> upsert(
    _is.DatabaseSession session,
    List<Task> rows, {
    required _is.ColumnSelections<TaskTable> conflictColumns,
    _is.ColumnSelections<TaskTable>? updateColumns,
    _is.WhereExpressionBuilder<TaskTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Task>(
      rows,
      conflictColumns: conflictColumns(Task.t),
      updateColumns: updateColumns?.call(Task.t),
      updateWhere: updateWhere?.call(Task.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Task] and returns the resulting row.
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
  /// The returned [Task] will have its `id` field set.
  Future<Task?> upsertRow(
    _is.DatabaseSession session,
    Task row, {
    required _is.ColumnSelections<TaskTable> conflictColumns,
    _is.ColumnSelections<TaskTable>? updateColumns,
    _is.WhereExpressionBuilder<TaskTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Task>(
      row,
      conflictColumns: conflictColumns(Task.t),
      updateColumns: updateColumns?.call(Task.t),
      updateWhere: updateWhere?.call(Task.t),
      transaction: transaction,
    );
  }

  /// Updates all [Task]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Task>> update(
    _is.DatabaseSession session,
    List<Task> rows, {
    _is.ColumnSelections<TaskTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Task>(
      rows,
      columns: columns?.call(Task.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Task]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Task> updateRow(
    _is.DatabaseSession session,
    Task row, {
    _is.ColumnSelections<TaskTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Task>(
      row,
      columns: columns?.call(Task.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Task] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Task?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TaskUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Task>(
      id,
      columnValues: columnValues(Task.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Task]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Task>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TaskUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TaskTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Task>(
      columnValues: columnValues(Task.t.updateTable),
      where: where(Task.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Task]s in the list and returns the deleted rows.
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
  Future<List<Task>> delete(
    _is.DatabaseSession session,
    List<Task> rows, {
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Task>(
      rows,
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Task].
  Future<Task> deleteRow(
    _is.DatabaseSession session,
    Task row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Task>(
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
  Future<List<Task>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TaskTable> where,
    _is.OrderByBuilder<TaskTable>? orderBy,
    _is.OrderByListBuilder<TaskTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Task>(
      where: where(Task.t),
      orderBy: orderBy?.call(Task.t),
      orderByList: orderByList?.call(Task.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaskTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Task>(
      where: where?.call(Task.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Task] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TaskTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Task>(
      where: where(Task.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
