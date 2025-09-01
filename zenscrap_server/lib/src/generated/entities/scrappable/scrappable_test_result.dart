/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../entities/scrappable/reference_test_data.dart' as _i2;

abstract class ScrappableTestResult
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ScrappableTestResult._({
    this.id,
    required this.testExtractRule,
    required this.extractJsonResult,
    required this.scrappableId,
    this.referenceTestDataId,
    this.referenceTestData,
  });

  factory ScrappableTestResult({
    int? id,
    required String testExtractRule,
    required String extractJsonResult,
    required int scrappableId,
    int? referenceTestDataId,
    _i2.ReferenceTestData? referenceTestData,
  }) = _ScrappableTestResultImpl;

  factory ScrappableTestResult.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ScrappableTestResult(
      id: jsonSerialization['id'] as int?,
      testExtractRule: jsonSerialization['testExtractRule'] as String,
      extractJsonResult: jsonSerialization['extractJsonResult'] as String,
      scrappableId: jsonSerialization['scrappableId'] as int,
      referenceTestDataId: jsonSerialization['referenceTestDataId'] as int?,
      referenceTestData: jsonSerialization['referenceTestData'] == null
          ? null
          : _i2.ReferenceTestData.fromJson(
              (jsonSerialization['referenceTestData'] as Map<String, dynamic>)),
    );
  }

  static final t = ScrappableTestResultTable();

  static const db = ScrappableTestResultRepository._();

  @override
  int? id;

  String testExtractRule;

  String extractJsonResult;

  int scrappableId;

  int? referenceTestDataId;

  _i2.ReferenceTestData? referenceTestData;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScrappableTestResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableTestResult copyWith({
    int? id,
    String? testExtractRule,
    String? extractJsonResult,
    int? scrappableId,
    int? referenceTestDataId,
    _i2.ReferenceTestData? referenceTestData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'testExtractRule': testExtractRule,
      'extractJsonResult': extractJsonResult,
      'scrappableId': scrappableId,
      if (referenceTestDataId != null)
        'referenceTestDataId': referenceTestDataId,
      if (referenceTestData != null)
        'referenceTestData': referenceTestData?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'testExtractRule': testExtractRule,
      'extractJsonResult': extractJsonResult,
      'scrappableId': scrappableId,
      if (referenceTestDataId != null)
        'referenceTestDataId': referenceTestDataId,
      if (referenceTestData != null)
        'referenceTestData': referenceTestData?.toJsonForProtocol(),
    };
  }

  static ScrappableTestResultInclude include(
      {_i2.ReferenceTestDataInclude? referenceTestData}) {
    return ScrappableTestResultInclude._(referenceTestData: referenceTestData);
  }

  static ScrappableTestResultIncludeList includeList({
    _i1.WhereExpressionBuilder<ScrappableTestResultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableTestResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTestResultTable>? orderByList,
    ScrappableTestResultInclude? include,
  }) {
    return ScrappableTestResultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScrappableTestResult.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScrappableTestResult.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableTestResultImpl extends ScrappableTestResult {
  _ScrappableTestResultImpl({
    int? id,
    required String testExtractRule,
    required String extractJsonResult,
    required int scrappableId,
    int? referenceTestDataId,
    _i2.ReferenceTestData? referenceTestData,
  }) : super._(
          id: id,
          testExtractRule: testExtractRule,
          extractJsonResult: extractJsonResult,
          scrappableId: scrappableId,
          referenceTestDataId: referenceTestDataId,
          referenceTestData: referenceTestData,
        );

  /// Returns a shallow copy of this [ScrappableTestResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableTestResult copyWith({
    Object? id = _Undefined,
    String? testExtractRule,
    String? extractJsonResult,
    int? scrappableId,
    Object? referenceTestDataId = _Undefined,
    Object? referenceTestData = _Undefined,
  }) {
    return ScrappableTestResult(
      id: id is int? ? id : this.id,
      testExtractRule: testExtractRule ?? this.testExtractRule,
      extractJsonResult: extractJsonResult ?? this.extractJsonResult,
      scrappableId: scrappableId ?? this.scrappableId,
      referenceTestDataId: referenceTestDataId is int?
          ? referenceTestDataId
          : this.referenceTestDataId,
      referenceTestData: referenceTestData is _i2.ReferenceTestData?
          ? referenceTestData
          : this.referenceTestData?.copyWith(),
    );
  }
}

class ScrappableTestResultTable extends _i1.Table<int?> {
  ScrappableTestResultTable({super.tableRelation})
      : super(tableName: 'scrappable_test_result') {
    testExtractRule = _i1.ColumnString(
      'testExtractRule',
      this,
    );
    extractJsonResult = _i1.ColumnString(
      'extractJsonResult',
      this,
    );
    scrappableId = _i1.ColumnInt(
      'scrappableId',
      this,
    );
    referenceTestDataId = _i1.ColumnInt(
      'referenceTestDataId',
      this,
    );
  }

  late final _i1.ColumnString testExtractRule;

  late final _i1.ColumnString extractJsonResult;

  late final _i1.ColumnInt scrappableId;

  late final _i1.ColumnInt referenceTestDataId;

  _i2.ReferenceTestDataTable? _referenceTestData;

  _i2.ReferenceTestDataTable get referenceTestData {
    if (_referenceTestData != null) return _referenceTestData!;
    _referenceTestData = _i1.createRelationTable(
      relationFieldName: 'referenceTestData',
      field: ScrappableTestResult.t.referenceTestDataId,
      foreignField: _i2.ReferenceTestData.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ReferenceTestDataTable(tableRelation: foreignTableRelation),
    );
    return _referenceTestData!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        testExtractRule,
        extractJsonResult,
        scrappableId,
        referenceTestDataId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'referenceTestData') {
      return referenceTestData;
    }
    return null;
  }
}

class ScrappableTestResultInclude extends _i1.IncludeObject {
  ScrappableTestResultInclude._(
      {_i2.ReferenceTestDataInclude? referenceTestData}) {
    _referenceTestData = referenceTestData;
  }

  _i2.ReferenceTestDataInclude? _referenceTestData;

  @override
  Map<String, _i1.Include?> get includes =>
      {'referenceTestData': _referenceTestData};

  @override
  _i1.Table<int?> get table => ScrappableTestResult.t;
}

class ScrappableTestResultIncludeList extends _i1.IncludeList {
  ScrappableTestResultIncludeList._({
    _i1.WhereExpressionBuilder<ScrappableTestResultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScrappableTestResult.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ScrappableTestResult.t;
}

class ScrappableTestResultRepository {
  const ScrappableTestResultRepository._();

  final attachRow = const ScrappableTestResultAttachRowRepository._();

  final detachRow = const ScrappableTestResultDetachRowRepository._();

  /// Returns a list of [ScrappableTestResult]s matching the given query parameters.
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
  Future<List<ScrappableTestResult>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTestResultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableTestResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTestResultTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableTestResultInclude? include,
  }) async {
    return session.db.find<ScrappableTestResult>(
      where: where?.call(ScrappableTestResult.t),
      orderBy: orderBy?.call(ScrappableTestResult.t),
      orderByList: orderByList?.call(ScrappableTestResult.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ScrappableTestResult] matching the given query parameters.
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
  Future<ScrappableTestResult?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTestResultTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScrappableTestResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTestResultTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableTestResultInclude? include,
  }) async {
    return session.db.findFirstRow<ScrappableTestResult>(
      where: where?.call(ScrappableTestResult.t),
      orderBy: orderBy?.call(ScrappableTestResult.t),
      orderByList: orderByList?.call(ScrappableTestResult.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ScrappableTestResult] by its [id] or null if no such row exists.
  Future<ScrappableTestResult?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ScrappableTestResultInclude? include,
  }) async {
    return session.db.findById<ScrappableTestResult>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ScrappableTestResult]s in the list and returns the inserted rows.
  ///
  /// The returned [ScrappableTestResult]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ScrappableTestResult>> insert(
    _i1.Session session,
    List<ScrappableTestResult> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ScrappableTestResult>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ScrappableTestResult] and returns the inserted row.
  ///
  /// The returned [ScrappableTestResult] will have its `id` field set.
  Future<ScrappableTestResult> insertRow(
    _i1.Session session,
    ScrappableTestResult row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScrappableTestResult>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ScrappableTestResult]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ScrappableTestResult>> update(
    _i1.Session session,
    List<ScrappableTestResult> rows, {
    _i1.ColumnSelections<ScrappableTestResultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScrappableTestResult>(
      rows,
      columns: columns?.call(ScrappableTestResult.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScrappableTestResult]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScrappableTestResult> updateRow(
    _i1.Session session,
    ScrappableTestResult row, {
    _i1.ColumnSelections<ScrappableTestResultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScrappableTestResult>(
      row,
      columns: columns?.call(ScrappableTestResult.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ScrappableTestResult]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ScrappableTestResult>> delete(
    _i1.Session session,
    List<ScrappableTestResult> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScrappableTestResult>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ScrappableTestResult].
  Future<ScrappableTestResult> deleteRow(
    _i1.Session session,
    ScrappableTestResult row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScrappableTestResult>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ScrappableTestResult>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScrappableTestResultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScrappableTestResult>(
      where: where(ScrappableTestResult.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTestResultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScrappableTestResult>(
      where: where?.call(ScrappableTestResult.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ScrappableTestResultAttachRowRepository {
  const ScrappableTestResultAttachRowRepository._();

  /// Creates a relation between the given [ScrappableTestResult] and [ReferenceTestData]
  /// by setting the [ScrappableTestResult]'s foreign key `referenceTestDataId` to refer to the [ReferenceTestData].
  Future<void> referenceTestData(
    _i1.Session session,
    ScrappableTestResult scrappableTestResult,
    _i2.ReferenceTestData referenceTestData, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappableTestResult.id == null) {
      throw ArgumentError.notNull('scrappableTestResult.id');
    }
    if (referenceTestData.id == null) {
      throw ArgumentError.notNull('referenceTestData.id');
    }

    var $scrappableTestResult = scrappableTestResult.copyWith(
        referenceTestDataId: referenceTestData.id);
    await session.db.updateRow<ScrappableTestResult>(
      $scrappableTestResult,
      columns: [ScrappableTestResult.t.referenceTestDataId],
      transaction: transaction,
    );
  }
}

class ScrappableTestResultDetachRowRepository {
  const ScrappableTestResultDetachRowRepository._();

  /// Detaches the relation between this [ScrappableTestResult] and the [ReferenceTestData] set in `referenceTestData`
  /// by setting the [ScrappableTestResult]'s foreign key `referenceTestDataId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> referenceTestData(
    _i1.Session session,
    ScrappableTestResult scrappabletestresult, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappabletestresult.id == null) {
      throw ArgumentError.notNull('scrappabletestresult.id');
    }

    var $scrappabletestresult =
        scrappabletestresult.copyWith(referenceTestDataId: null);
    await session.db.updateRow<ScrappableTestResult>(
      $scrappabletestresult,
      columns: [ScrappableTestResult.t.referenceTestDataId],
      transaction: transaction,
    );
  }
}
