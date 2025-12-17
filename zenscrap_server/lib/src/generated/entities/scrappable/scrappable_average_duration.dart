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

abstract class ScrappableAverageDuration
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ScrappableAverageDuration._({
    this.id,
    required this.updatedAt,
    required this.averageDuration,
  });

  factory ScrappableAverageDuration({
    int? id,
    required DateTime updatedAt,
    required Duration averageDuration,
  }) = _ScrappableAverageDurationImpl;

  factory ScrappableAverageDuration.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ScrappableAverageDuration(
      id: jsonSerialization['id'] as int?,
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      averageDuration: _i1.DurationJsonExtension.fromJson(
        jsonSerialization['averageDuration'],
      ),
    );
  }

  static final t = ScrappableAverageDurationTable();

  static const db = ScrappableAverageDurationRepository._();

  @override
  int? id;

  DateTime updatedAt;

  Duration averageDuration;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScrappableAverageDuration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableAverageDuration copyWith({
    int? id,
    DateTime? updatedAt,
    Duration? averageDuration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScrappableAverageDuration',
      if (id != null) 'id': id,
      'updatedAt': updatedAt.toJson(),
      'averageDuration': averageDuration.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScrappableAverageDuration',
      if (id != null) 'id': id,
      'updatedAt': updatedAt.toJson(),
      'averageDuration': averageDuration.toJson(),
    };
  }

  static ScrappableAverageDurationInclude include() {
    return ScrappableAverageDurationInclude._();
  }

  static ScrappableAverageDurationIncludeList includeList({
    _i1.WhereExpressionBuilder<ScrappableAverageDurationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableAverageDurationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableAverageDurationTable>? orderByList,
    ScrappableAverageDurationInclude? include,
  }) {
    return ScrappableAverageDurationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScrappableAverageDuration.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScrappableAverageDuration.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableAverageDurationImpl extends ScrappableAverageDuration {
  _ScrappableAverageDurationImpl({
    int? id,
    required DateTime updatedAt,
    required Duration averageDuration,
  }) : super._(
         id: id,
         updatedAt: updatedAt,
         averageDuration: averageDuration,
       );

  /// Returns a shallow copy of this [ScrappableAverageDuration]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableAverageDuration copyWith({
    Object? id = _Undefined,
    DateTime? updatedAt,
    Duration? averageDuration,
  }) {
    return ScrappableAverageDuration(
      id: id is int? ? id : this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      averageDuration: averageDuration ?? this.averageDuration,
    );
  }
}

class ScrappableAverageDurationUpdateTable
    extends _i1.UpdateTable<ScrappableAverageDurationTable> {
  ScrappableAverageDurationUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );

  _i1.ColumnValue<Duration, Duration> averageDuration(Duration value) =>
      _i1.ColumnValue(
        table.averageDuration,
        value,
      );
}

class ScrappableAverageDurationTable extends _i1.Table<int?> {
  ScrappableAverageDurationTable({super.tableRelation})
    : super(tableName: 'scrappable_average_duration') {
    updateTable = ScrappableAverageDurationUpdateTable(this);
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
    averageDuration = _i1.ColumnDuration(
      'averageDuration',
      this,
    );
  }

  late final ScrappableAverageDurationUpdateTable updateTable;

  late final _i1.ColumnDateTime updatedAt;

  late final _i1.ColumnDuration averageDuration;

  @override
  List<_i1.Column> get columns => [
    id,
    updatedAt,
    averageDuration,
  ];
}

class ScrappableAverageDurationInclude extends _i1.IncludeObject {
  ScrappableAverageDurationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ScrappableAverageDuration.t;
}

class ScrappableAverageDurationIncludeList extends _i1.IncludeList {
  ScrappableAverageDurationIncludeList._({
    _i1.WhereExpressionBuilder<ScrappableAverageDurationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScrappableAverageDuration.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ScrappableAverageDuration.t;
}

class ScrappableAverageDurationRepository {
  const ScrappableAverageDurationRepository._();

  /// Returns a list of [ScrappableAverageDuration]s matching the given query parameters.
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
  Future<List<ScrappableAverageDuration>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableAverageDurationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableAverageDurationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableAverageDurationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ScrappableAverageDuration>(
      where: where?.call(ScrappableAverageDuration.t),
      orderBy: orderBy?.call(ScrappableAverageDuration.t),
      orderByList: orderByList?.call(ScrappableAverageDuration.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ScrappableAverageDuration] matching the given query parameters.
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
  Future<ScrappableAverageDuration?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableAverageDurationTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScrappableAverageDurationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableAverageDurationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ScrappableAverageDuration>(
      where: where?.call(ScrappableAverageDuration.t),
      orderBy: orderBy?.call(ScrappableAverageDuration.t),
      orderByList: orderByList?.call(ScrappableAverageDuration.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ScrappableAverageDuration] by its [id] or null if no such row exists.
  Future<ScrappableAverageDuration?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ScrappableAverageDuration>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ScrappableAverageDuration]s in the list and returns the inserted rows.
  ///
  /// The returned [ScrappableAverageDuration]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ScrappableAverageDuration>> insert(
    _i1.Session session,
    List<ScrappableAverageDuration> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ScrappableAverageDuration>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ScrappableAverageDuration] and returns the inserted row.
  ///
  /// The returned [ScrappableAverageDuration] will have its `id` field set.
  Future<ScrappableAverageDuration> insertRow(
    _i1.Session session,
    ScrappableAverageDuration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScrappableAverageDuration>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ScrappableAverageDuration]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ScrappableAverageDuration>> update(
    _i1.Session session,
    List<ScrappableAverageDuration> rows, {
    _i1.ColumnSelections<ScrappableAverageDurationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScrappableAverageDuration>(
      rows,
      columns: columns?.call(ScrappableAverageDuration.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScrappableAverageDuration]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScrappableAverageDuration> updateRow(
    _i1.Session session,
    ScrappableAverageDuration row, {
    _i1.ColumnSelections<ScrappableAverageDurationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScrappableAverageDuration>(
      row,
      columns: columns?.call(ScrappableAverageDuration.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScrappableAverageDuration] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScrappableAverageDuration?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ScrappableAverageDurationUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ScrappableAverageDuration>(
      id,
      columnValues: columnValues(ScrappableAverageDuration.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScrappableAverageDuration]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ScrappableAverageDuration>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ScrappableAverageDurationUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ScrappableAverageDurationTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableAverageDurationTable>? orderBy,
    _i1.OrderByListBuilder<ScrappableAverageDurationTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ScrappableAverageDuration>(
      columnValues: columnValues(ScrappableAverageDuration.t.updateTable),
      where: where(ScrappableAverageDuration.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScrappableAverageDuration.t),
      orderByList: orderByList?.call(ScrappableAverageDuration.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ScrappableAverageDuration]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ScrappableAverageDuration>> delete(
    _i1.Session session,
    List<ScrappableAverageDuration> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScrappableAverageDuration>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ScrappableAverageDuration].
  Future<ScrappableAverageDuration> deleteRow(
    _i1.Session session,
    ScrappableAverageDuration row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScrappableAverageDuration>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ScrappableAverageDuration>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScrappableAverageDurationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScrappableAverageDuration>(
      where: where(ScrappableAverageDuration.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableAverageDurationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScrappableAverageDuration>(
      where: where?.call(ScrappableAverageDuration.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
