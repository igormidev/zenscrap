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

abstract class AnalyticsRequestDetails
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AnalyticsRequestDetails._({
    this.id,
    DateTime? timeStamp,
    this.title,
    this.description,
    this.errorObjectAsString,
    this.errorStackTraceAsString,
    required this.stringifiedPayload,
    this.stringifiedResponse,
  }) : timeStamp = timeStamp ?? DateTime.now();

  factory AnalyticsRequestDetails({
    int? id,
    DateTime? timeStamp,
    String? title,
    String? description,
    String? errorObjectAsString,
    String? errorStackTraceAsString,
    required String stringifiedPayload,
    String? stringifiedResponse,
  }) = _AnalyticsRequestDetailsImpl;

  factory AnalyticsRequestDetails.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AnalyticsRequestDetails(
      id: jsonSerialization['id'] as int?,
      timeStamp: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['timeStamp'],
      ),
      title: jsonSerialization['title'] as String?,
      description: jsonSerialization['description'] as String?,
      errorObjectAsString: jsonSerialization['errorObjectAsString'] as String?,
      errorStackTraceAsString:
          jsonSerialization['errorStackTraceAsString'] as String?,
      stringifiedPayload: jsonSerialization['stringifiedPayload'] as String,
      stringifiedResponse: jsonSerialization['stringifiedResponse'] as String?,
    );
  }

  static final t = AnalyticsRequestDetailsTable();

  static const db = AnalyticsRequestDetailsRepository._();

  @override
  int? id;

  DateTime timeStamp;

  String? title;

  String? description;

  String? errorObjectAsString;

  String? errorStackTraceAsString;

  String stringifiedPayload;

  String? stringifiedResponse;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AnalyticsRequestDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnalyticsRequestDetails copyWith({
    int? id,
    DateTime? timeStamp,
    String? title,
    String? description,
    String? errorObjectAsString,
    String? errorStackTraceAsString,
    String? stringifiedPayload,
    String? stringifiedResponse,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AnalyticsRequestDetails',
      if (id != null) 'id': id,
      'timeStamp': timeStamp.toJson(),
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (errorObjectAsString != null)
        'errorObjectAsString': errorObjectAsString,
      if (errorStackTraceAsString != null)
        'errorStackTraceAsString': errorStackTraceAsString,
      'stringifiedPayload': stringifiedPayload,
      if (stringifiedResponse != null)
        'stringifiedResponse': stringifiedResponse,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AnalyticsRequestDetails',
      if (id != null) 'id': id,
      'timeStamp': timeStamp.toJson(),
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (errorObjectAsString != null)
        'errorObjectAsString': errorObjectAsString,
      if (errorStackTraceAsString != null)
        'errorStackTraceAsString': errorStackTraceAsString,
      'stringifiedPayload': stringifiedPayload,
      if (stringifiedResponse != null)
        'stringifiedResponse': stringifiedResponse,
    };
  }

  static AnalyticsRequestDetailsInclude include() {
    return AnalyticsRequestDetailsInclude._();
  }

  static AnalyticsRequestDetailsIncludeList includeList({
    _i1.WhereExpressionBuilder<AnalyticsRequestDetailsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnalyticsRequestDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnalyticsRequestDetailsTable>? orderByList,
    AnalyticsRequestDetailsInclude? include,
  }) {
    return AnalyticsRequestDetailsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnalyticsRequestDetails.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AnalyticsRequestDetails.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnalyticsRequestDetailsImpl extends AnalyticsRequestDetails {
  _AnalyticsRequestDetailsImpl({
    int? id,
    DateTime? timeStamp,
    String? title,
    String? description,
    String? errorObjectAsString,
    String? errorStackTraceAsString,
    required String stringifiedPayload,
    String? stringifiedResponse,
  }) : super._(
         id: id,
         timeStamp: timeStamp,
         title: title,
         description: description,
         errorObjectAsString: errorObjectAsString,
         errorStackTraceAsString: errorStackTraceAsString,
         stringifiedPayload: stringifiedPayload,
         stringifiedResponse: stringifiedResponse,
       );

  /// Returns a shallow copy of this [AnalyticsRequestDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnalyticsRequestDetails copyWith({
    Object? id = _Undefined,
    DateTime? timeStamp,
    Object? title = _Undefined,
    Object? description = _Undefined,
    Object? errorObjectAsString = _Undefined,
    Object? errorStackTraceAsString = _Undefined,
    String? stringifiedPayload,
    Object? stringifiedResponse = _Undefined,
  }) {
    return AnalyticsRequestDetails(
      id: id is int? ? id : this.id,
      timeStamp: timeStamp ?? this.timeStamp,
      title: title is String? ? title : this.title,
      description: description is String? ? description : this.description,
      errorObjectAsString: errorObjectAsString is String?
          ? errorObjectAsString
          : this.errorObjectAsString,
      errorStackTraceAsString: errorStackTraceAsString is String?
          ? errorStackTraceAsString
          : this.errorStackTraceAsString,
      stringifiedPayload: stringifiedPayload ?? this.stringifiedPayload,
      stringifiedResponse: stringifiedResponse is String?
          ? stringifiedResponse
          : this.stringifiedResponse,
    );
  }
}

class AnalyticsRequestDetailsUpdateTable
    extends _i1.UpdateTable<AnalyticsRequestDetailsTable> {
  AnalyticsRequestDetailsUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> timeStamp(DateTime value) =>
      _i1.ColumnValue(
        table.timeStamp,
        value,
      );

  _i1.ColumnValue<String, String> title(String? value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> errorObjectAsString(String? value) =>
      _i1.ColumnValue(
        table.errorObjectAsString,
        value,
      );

  _i1.ColumnValue<String, String> errorStackTraceAsString(String? value) =>
      _i1.ColumnValue(
        table.errorStackTraceAsString,
        value,
      );

  _i1.ColumnValue<String, String> stringifiedPayload(String value) =>
      _i1.ColumnValue(
        table.stringifiedPayload,
        value,
      );

  _i1.ColumnValue<String, String> stringifiedResponse(String? value) =>
      _i1.ColumnValue(
        table.stringifiedResponse,
        value,
      );
}

class AnalyticsRequestDetailsTable extends _i1.Table<int?> {
  AnalyticsRequestDetailsTable({super.tableRelation})
    : super(tableName: 'analytics_request_details') {
    updateTable = AnalyticsRequestDetailsUpdateTable(this);
    timeStamp = _i1.ColumnDateTime(
      'timeStamp',
      this,
      hasDefault: true,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    errorObjectAsString = _i1.ColumnString(
      'errorObjectAsString',
      this,
    );
    errorStackTraceAsString = _i1.ColumnString(
      'errorStackTraceAsString',
      this,
    );
    stringifiedPayload = _i1.ColumnString(
      'stringifiedPayload',
      this,
    );
    stringifiedResponse = _i1.ColumnString(
      'stringifiedResponse',
      this,
    );
  }

  late final AnalyticsRequestDetailsUpdateTable updateTable;

  late final _i1.ColumnDateTime timeStamp;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnString errorObjectAsString;

  late final _i1.ColumnString errorStackTraceAsString;

  late final _i1.ColumnString stringifiedPayload;

  late final _i1.ColumnString stringifiedResponse;

  @override
  List<_i1.Column> get columns => [
    id,
    timeStamp,
    title,
    description,
    errorObjectAsString,
    errorStackTraceAsString,
    stringifiedPayload,
    stringifiedResponse,
  ];
}

class AnalyticsRequestDetailsInclude extends _i1.IncludeObject {
  AnalyticsRequestDetailsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AnalyticsRequestDetails.t;
}

class AnalyticsRequestDetailsIncludeList extends _i1.IncludeList {
  AnalyticsRequestDetailsIncludeList._({
    _i1.WhereExpressionBuilder<AnalyticsRequestDetailsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AnalyticsRequestDetails.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AnalyticsRequestDetails.t;
}

class AnalyticsRequestDetailsRepository {
  const AnalyticsRequestDetailsRepository._();

  /// Returns a list of [AnalyticsRequestDetails]s matching the given query parameters.
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
  Future<List<AnalyticsRequestDetails>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnalyticsRequestDetailsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnalyticsRequestDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnalyticsRequestDetailsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AnalyticsRequestDetails>(
      where: where?.call(AnalyticsRequestDetails.t),
      orderBy: orderBy?.call(AnalyticsRequestDetails.t),
      orderByList: orderByList?.call(AnalyticsRequestDetails.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AnalyticsRequestDetails] matching the given query parameters.
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
  Future<AnalyticsRequestDetails?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnalyticsRequestDetailsTable>? where,
    int? offset,
    _i1.OrderByBuilder<AnalyticsRequestDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnalyticsRequestDetailsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AnalyticsRequestDetails>(
      where: where?.call(AnalyticsRequestDetails.t),
      orderBy: orderBy?.call(AnalyticsRequestDetails.t),
      orderByList: orderByList?.call(AnalyticsRequestDetails.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AnalyticsRequestDetails] by its [id] or null if no such row exists.
  Future<AnalyticsRequestDetails?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AnalyticsRequestDetails>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AnalyticsRequestDetails]s in the list and returns the inserted rows.
  ///
  /// The returned [AnalyticsRequestDetails]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AnalyticsRequestDetails>> insert(
    _i1.Session session,
    List<AnalyticsRequestDetails> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AnalyticsRequestDetails>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AnalyticsRequestDetails] and returns the inserted row.
  ///
  /// The returned [AnalyticsRequestDetails] will have its `id` field set.
  Future<AnalyticsRequestDetails> insertRow(
    _i1.Session session,
    AnalyticsRequestDetails row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AnalyticsRequestDetails>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AnalyticsRequestDetails]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AnalyticsRequestDetails>> update(
    _i1.Session session,
    List<AnalyticsRequestDetails> rows, {
    _i1.ColumnSelections<AnalyticsRequestDetailsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AnalyticsRequestDetails>(
      rows,
      columns: columns?.call(AnalyticsRequestDetails.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnalyticsRequestDetails]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AnalyticsRequestDetails> updateRow(
    _i1.Session session,
    AnalyticsRequestDetails row, {
    _i1.ColumnSelections<AnalyticsRequestDetailsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AnalyticsRequestDetails>(
      row,
      columns: columns?.call(AnalyticsRequestDetails.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnalyticsRequestDetails] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AnalyticsRequestDetails?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AnalyticsRequestDetailsUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AnalyticsRequestDetails>(
      id,
      columnValues: columnValues(AnalyticsRequestDetails.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AnalyticsRequestDetails]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AnalyticsRequestDetails>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AnalyticsRequestDetailsUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AnalyticsRequestDetailsTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnalyticsRequestDetailsTable>? orderBy,
    _i1.OrderByListBuilder<AnalyticsRequestDetailsTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AnalyticsRequestDetails>(
      columnValues: columnValues(AnalyticsRequestDetails.t.updateTable),
      where: where(AnalyticsRequestDetails.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnalyticsRequestDetails.t),
      orderByList: orderByList?.call(AnalyticsRequestDetails.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AnalyticsRequestDetails]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AnalyticsRequestDetails>> delete(
    _i1.Session session,
    List<AnalyticsRequestDetails> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AnalyticsRequestDetails>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AnalyticsRequestDetails].
  Future<AnalyticsRequestDetails> deleteRow(
    _i1.Session session,
    AnalyticsRequestDetails row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AnalyticsRequestDetails>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AnalyticsRequestDetails>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnalyticsRequestDetailsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AnalyticsRequestDetails>(
      where: where(AnalyticsRequestDetails.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnalyticsRequestDetailsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AnalyticsRequestDetails>(
      where: where?.call(AnalyticsRequestDetails.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
