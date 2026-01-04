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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class PendingSessionCommit
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PendingSessionCommit._({
    this.id,
    required this.sessionId,
    required this.scrappableId,
    required this.createdAt,
  });

  factory PendingSessionCommit({
    int? id,
    required String sessionId,
    required int scrappableId,
    required DateTime createdAt,
  }) = _PendingSessionCommitImpl;

  factory PendingSessionCommit.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PendingSessionCommit(
      id: jsonSerialization['id'] as int?,
      sessionId: jsonSerialization['sessionId'] as String,
      scrappableId: jsonSerialization['scrappableId'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = PendingSessionCommitTable();

  static const db = PendingSessionCommitRepository._();

  @override
  int? id;

  String sessionId;

  int scrappableId;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PendingSessionCommit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PendingSessionCommit copyWith({
    int? id,
    String? sessionId,
    int? scrappableId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PendingSessionCommit',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'scrappableId': scrappableId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PendingSessionCommit',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'scrappableId': scrappableId,
      'createdAt': createdAt.toJson(),
    };
  }

  static PendingSessionCommitInclude include() {
    return PendingSessionCommitInclude._();
  }

  static PendingSessionCommitIncludeList includeList({
    _i1.WhereExpressionBuilder<PendingSessionCommitTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PendingSessionCommitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PendingSessionCommitTable>? orderByList,
    PendingSessionCommitInclude? include,
  }) {
    return PendingSessionCommitIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PendingSessionCommit.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PendingSessionCommit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PendingSessionCommitImpl extends PendingSessionCommit {
  _PendingSessionCommitImpl({
    int? id,
    required String sessionId,
    required int scrappableId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         sessionId: sessionId,
         scrappableId: scrappableId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PendingSessionCommit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PendingSessionCommit copyWith({
    Object? id = _Undefined,
    String? sessionId,
    int? scrappableId,
    DateTime? createdAt,
  }) {
    return PendingSessionCommit(
      id: id is int? ? id : this.id,
      sessionId: sessionId ?? this.sessionId,
      scrappableId: scrappableId ?? this.scrappableId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PendingSessionCommitUpdateTable
    extends _i1.UpdateTable<PendingSessionCommitTable> {
  PendingSessionCommitUpdateTable(super.table);

  _i1.ColumnValue<String, String> sessionId(String value) => _i1.ColumnValue(
    table.sessionId,
    value,
  );

  _i1.ColumnValue<int, int> scrappableId(int value) => _i1.ColumnValue(
    table.scrappableId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class PendingSessionCommitTable extends _i1.Table<int?> {
  PendingSessionCommitTable({super.tableRelation})
    : super(tableName: 'pending_session_commit') {
    updateTable = PendingSessionCommitUpdateTable(this);
    sessionId = _i1.ColumnString(
      'sessionId',
      this,
    );
    scrappableId = _i1.ColumnInt(
      'scrappableId',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final PendingSessionCommitUpdateTable updateTable;

  late final _i1.ColumnString sessionId;

  late final _i1.ColumnInt scrappableId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    sessionId,
    scrappableId,
    createdAt,
  ];
}

class PendingSessionCommitInclude extends _i1.IncludeObject {
  PendingSessionCommitInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PendingSessionCommit.t;
}

class PendingSessionCommitIncludeList extends _i1.IncludeList {
  PendingSessionCommitIncludeList._({
    _i1.WhereExpressionBuilder<PendingSessionCommitTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PendingSessionCommit.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PendingSessionCommit.t;
}

class PendingSessionCommitRepository {
  const PendingSessionCommitRepository._();

  /// Returns a list of [PendingSessionCommit]s matching the given query parameters.
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
  Future<List<PendingSessionCommit>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PendingSessionCommitTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PendingSessionCommitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PendingSessionCommitTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PendingSessionCommit>(
      where: where?.call(PendingSessionCommit.t),
      orderBy: orderBy?.call(PendingSessionCommit.t),
      orderByList: orderByList?.call(PendingSessionCommit.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PendingSessionCommit] matching the given query parameters.
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
  Future<PendingSessionCommit?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PendingSessionCommitTable>? where,
    int? offset,
    _i1.OrderByBuilder<PendingSessionCommitTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PendingSessionCommitTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PendingSessionCommit>(
      where: where?.call(PendingSessionCommit.t),
      orderBy: orderBy?.call(PendingSessionCommit.t),
      orderByList: orderByList?.call(PendingSessionCommit.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PendingSessionCommit] by its [id] or null if no such row exists.
  Future<PendingSessionCommit?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PendingSessionCommit>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PendingSessionCommit]s in the list and returns the inserted rows.
  ///
  /// The returned [PendingSessionCommit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PendingSessionCommit>> insert(
    _i1.Session session,
    List<PendingSessionCommit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PendingSessionCommit>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PendingSessionCommit] and returns the inserted row.
  ///
  /// The returned [PendingSessionCommit] will have its `id` field set.
  Future<PendingSessionCommit> insertRow(
    _i1.Session session,
    PendingSessionCommit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PendingSessionCommit>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PendingSessionCommit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PendingSessionCommit>> update(
    _i1.Session session,
    List<PendingSessionCommit> rows, {
    _i1.ColumnSelections<PendingSessionCommitTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PendingSessionCommit>(
      rows,
      columns: columns?.call(PendingSessionCommit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PendingSessionCommit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PendingSessionCommit> updateRow(
    _i1.Session session,
    PendingSessionCommit row, {
    _i1.ColumnSelections<PendingSessionCommitTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PendingSessionCommit>(
      row,
      columns: columns?.call(PendingSessionCommit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PendingSessionCommit] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PendingSessionCommit?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PendingSessionCommitUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PendingSessionCommit>(
      id,
      columnValues: columnValues(PendingSessionCommit.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PendingSessionCommit]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PendingSessionCommit>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PendingSessionCommitUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PendingSessionCommitTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PendingSessionCommitTable>? orderBy,
    _i1.OrderByListBuilder<PendingSessionCommitTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PendingSessionCommit>(
      columnValues: columnValues(PendingSessionCommit.t.updateTable),
      where: where(PendingSessionCommit.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PendingSessionCommit.t),
      orderByList: orderByList?.call(PendingSessionCommit.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PendingSessionCommit]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PendingSessionCommit>> delete(
    _i1.Session session,
    List<PendingSessionCommit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PendingSessionCommit>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PendingSessionCommit].
  Future<PendingSessionCommit> deleteRow(
    _i1.Session session,
    PendingSessionCommit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PendingSessionCommit>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PendingSessionCommit>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PendingSessionCommitTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PendingSessionCommit>(
      where: where(PendingSessionCommit.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PendingSessionCommitTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PendingSessionCommit>(
      where: where?.call(PendingSessionCommit.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
