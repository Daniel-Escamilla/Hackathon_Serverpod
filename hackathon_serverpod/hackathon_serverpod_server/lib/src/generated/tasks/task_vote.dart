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
import '../tasks/task_vote_phase.dart' as _iyz5tyfe;

/// One member's vote on a Task, in one of its two phases (PRODUCT.md §3, §10.2). Same shape as
/// RewardVote, plus the phase and the counter-offer.
abstract class TaskVote
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  TaskVote._({
    this.id,
    required this.taskId,
    required this.memberId,
    required this.phase,
    required this.approve,
    this.counterReward,
  });

  factory TaskVote({
    int? id,
    required int taskId,
    required int memberId,
    required _iyz5tyfe.TaskVotePhase phase,
    required bool approve,
    int? counterReward,
  }) = _TaskVoteImpl;

  factory TaskVote.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskVote(
      id: jsonSerialization['id'] as int?,
      taskId: jsonSerialization['taskId'] as int,
      memberId: jsonSerialization['memberId'] as int,
      phase: _iyz5tyfe.TaskVotePhase.fromJson(
        (jsonSerialization['phase'] as String),
      ),
      approve: _is.BoolJsonExtension.fromJson(jsonSerialization['approve']),
      counterReward: jsonSerialization['counterReward'] as int?,
    );
  }

  static final t = TaskVoteTable();

  static const db = TaskVoteRepository._();

  @override
  int? id;

  int taskId;

  /// One vote per member per task per phase; a vote round that restarts after an accepted
  /// counter-offer (PRODUCT.md §4.3) needs its old proposal-phase rows cleared first.
  int memberId;

  _iyz5tyfe.TaskVotePhase phase;

  bool approve;

  /// A different price offered instead of a plain reject, proposal phase only (PRODUCT.md §4.3).
  int? counterReward;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [TaskVote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TaskVote copyWith({
    int? id,
    int? taskId,
    int? memberId,
    _iyz5tyfe.TaskVotePhase? phase,
    bool? approve,
    int? counterReward,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskVote',
      if (id != null) 'id': id,
      'taskId': taskId,
      'memberId': memberId,
      'phase': phase.toJson(),
      'approve': approve,
      if (counterReward != null) 'counterReward': counterReward,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaskVote',
      if (id != null) 'id': id,
      'taskId': taskId,
      'memberId': memberId,
      'phase': phase.toJson(),
      'approve': approve,
      if (counterReward != null) 'counterReward': counterReward,
    };
  }

  static TaskVoteInclude include() {
    return TaskVoteInclude._();
  }

  static TaskVoteIncludeList includeList({
    _is.WhereExpressionBuilder<TaskVoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaskVoteTable>? orderBy,
    _is.OrderByListBuilder<TaskVoteTable>? orderByList,
    TaskVoteInclude? include,
  }) {
    return TaskVoteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaskVote.t),
      orderByList: orderByList?.call(TaskVote.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskVoteImpl extends TaskVote {
  _TaskVoteImpl({
    int? id,
    required int taskId,
    required int memberId,
    required _iyz5tyfe.TaskVotePhase phase,
    required bool approve,
    int? counterReward,
  }) : super._(
         id: id,
         taskId: taskId,
         memberId: memberId,
         phase: phase,
         approve: approve,
         counterReward: counterReward,
       );

  /// Returns a shallow copy of this [TaskVote]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TaskVote copyWith({
    Object? id = _Undefined,
    int? taskId,
    int? memberId,
    _iyz5tyfe.TaskVotePhase? phase,
    bool? approve,
    Object? counterReward = _Undefined,
  }) {
    return TaskVote(
      id: id is int? ? id : this.id,
      taskId: taskId ?? this.taskId,
      memberId: memberId ?? this.memberId,
      phase: phase ?? this.phase,
      approve: approve ?? this.approve,
      counterReward: counterReward is int? ? counterReward : this.counterReward,
    );
  }
}

class TaskVoteUpdateTable extends _is.UpdateTable<TaskVoteTable> {
  TaskVoteUpdateTable(super.table);

  _is.ColumnValue<int, int> taskId(int value) => _is.ColumnValue(
    table.taskId,
    value,
  );

  _is.ColumnValue<int, int> memberId(int value) => _is.ColumnValue(
    table.memberId,
    value,
  );

  _is.ColumnValue<_iyz5tyfe.TaskVotePhase, _iyz5tyfe.TaskVotePhase> phase(
    _iyz5tyfe.TaskVotePhase value,
  ) => _is.ColumnValue(
    table.phase,
    value,
  );

  _is.ColumnValue<bool, bool> approve(bool value) => _is.ColumnValue(
    table.approve,
    value,
  );

  _is.ColumnValue<int, int> counterReward(int? value) => _is.ColumnValue(
    table.counterReward,
    value,
  );
}

class TaskVoteTable extends _is.Table<int?> {
  TaskVoteTable({super.tableRelation}) : super(tableName: 'task_vote') {
    updateTable = TaskVoteUpdateTable(this);
    taskId = _is.ColumnInt(
      'taskId',
      this,
    );
    memberId = _is.ColumnInt(
      'memberId',
      this,
    );
    phase = _is.ColumnEnum(
      'phase',
      this,
      _is.EnumSerialization.byName,
    );
    approve = _is.ColumnBool(
      'approve',
      this,
    );
    counterReward = _is.ColumnInt(
      'counterReward',
      this,
    );
  }

  late final TaskVoteUpdateTable updateTable;

  late final _is.ColumnInt taskId;

  /// One vote per member per task per phase; a vote round that restarts after an accepted
  /// counter-offer (PRODUCT.md §4.3) needs its old proposal-phase rows cleared first.
  late final _is.ColumnInt memberId;

  late final _is.ColumnEnum<_iyz5tyfe.TaskVotePhase> phase;

  late final _is.ColumnBool approve;

  /// A different price offered instead of a plain reject, proposal phase only (PRODUCT.md §4.3).
  late final _is.ColumnInt counterReward;

  @override
  List<_is.Column> get columns => [
    id,
    taskId,
    memberId,
    phase,
    approve,
    counterReward,
  ];
}

class TaskVoteInclude extends _is.IncludeObject {
  TaskVoteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => TaskVote.t;
}

class TaskVoteIncludeList extends _is.IncludeList {
  TaskVoteIncludeList._({
    _is.WhereExpressionBuilder<TaskVoteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TaskVote.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => TaskVote.t;
}

class TaskVoteRepository {
  const TaskVoteRepository._();

  /// Returns a list of [TaskVote]s matching the given query parameters.
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
  Future<List<TaskVote>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaskVoteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaskVoteTable>? orderBy,
    _is.OrderByListBuilder<TaskVoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TaskVote>(
      where: where?.call(TaskVote.t),
      orderBy: orderBy?.call(TaskVote.t),
      orderByList: orderByList?.call(TaskVote.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TaskVote] matching the given query parameters.
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
  Future<TaskVote?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaskVoteTable>? where,
    int? offset,
    _is.OrderByBuilder<TaskVoteTable>? orderBy,
    _is.OrderByListBuilder<TaskVoteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TaskVote>(
      where: where?.call(TaskVote.t),
      orderBy: orderBy?.call(TaskVote.t),
      orderByList: orderByList?.call(TaskVote.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TaskVote] by its [id] or null if no such row exists.
  Future<TaskVote?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TaskVote>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TaskVote]s in the list and returns the inserted rows.
  ///
  /// The returned [TaskVote]s will have their `id` fields set.
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
  Future<List<TaskVote>> insert(
    _is.DatabaseSession session,
    List<TaskVote> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TaskVote>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TaskVote] and returns the inserted row.
  ///
  /// The returned [TaskVote] will have its `id` field set.
  Future<TaskVote> insertRow(
    _is.DatabaseSession session,
    TaskVote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TaskVote>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TaskVote]s in the list and returns the resulting rows.
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
  /// The returned [TaskVote]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TaskVote>> upsert(
    _is.DatabaseSession session,
    List<TaskVote> rows, {
    required _is.ColumnSelections<TaskVoteTable> conflictColumns,
    _is.ColumnSelections<TaskVoteTable>? updateColumns,
    _is.WhereExpressionBuilder<TaskVoteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TaskVote>(
      rows,
      conflictColumns: conflictColumns(TaskVote.t),
      updateColumns: updateColumns?.call(TaskVote.t),
      updateWhere: updateWhere?.call(TaskVote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TaskVote] and returns the resulting row.
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
  /// The returned [TaskVote] will have its `id` field set.
  Future<TaskVote?> upsertRow(
    _is.DatabaseSession session,
    TaskVote row, {
    required _is.ColumnSelections<TaskVoteTable> conflictColumns,
    _is.ColumnSelections<TaskVoteTable>? updateColumns,
    _is.WhereExpressionBuilder<TaskVoteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TaskVote>(
      row,
      conflictColumns: conflictColumns(TaskVote.t),
      updateColumns: updateColumns?.call(TaskVote.t),
      updateWhere: updateWhere?.call(TaskVote.t),
      transaction: transaction,
    );
  }

  /// Updates all [TaskVote]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TaskVote>> update(
    _is.DatabaseSession session,
    List<TaskVote> rows, {
    _is.ColumnSelections<TaskVoteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TaskVote>(
      rows,
      columns: columns?.call(TaskVote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TaskVote]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TaskVote> updateRow(
    _is.DatabaseSession session,
    TaskVote row, {
    _is.ColumnSelections<TaskVoteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TaskVote>(
      row,
      columns: columns?.call(TaskVote.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TaskVote] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TaskVote?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TaskVoteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TaskVote>(
      id,
      columnValues: columnValues(TaskVote.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TaskVote]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TaskVote>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TaskVoteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TaskVoteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TaskVoteTable>? orderBy,
    _is.OrderByListBuilder<TaskVoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TaskVote>(
      columnValues: columnValues(TaskVote.t.updateTable),
      where: where(TaskVote.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaskVote.t),
      orderByList: orderByList?.call(TaskVote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TaskVote]s in the list and returns the deleted rows.
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
  Future<List<TaskVote>> delete(
    _is.DatabaseSession session,
    List<TaskVote> rows, {
    _is.OrderByBuilder<TaskVoteTable>? orderBy,
    _is.OrderByListBuilder<TaskVoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TaskVote>(
      rows,
      orderBy: orderBy?.call(TaskVote.t),
      orderByList: orderByList?.call(TaskVote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TaskVote].
  Future<TaskVote> deleteRow(
    _is.DatabaseSession session,
    TaskVote row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TaskVote>(
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
  Future<List<TaskVote>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TaskVoteTable> where,
    _is.OrderByBuilder<TaskVoteTable>? orderBy,
    _is.OrderByListBuilder<TaskVoteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TaskVote>(
      where: where(TaskVote.t),
      orderBy: orderBy?.call(TaskVote.t),
      orderByList: orderByList?.call(TaskVote.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TaskVoteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TaskVote>(
      where: where?.call(TaskVote.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TaskVote] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TaskVoteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TaskVote>(
      where: where(TaskVote.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
