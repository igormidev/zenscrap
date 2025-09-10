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
import '../../entities/scrappable/byte_test_data.dart' as _i2;
import '../../entities/scrappable/scrappable.dart' as _i3;

abstract class ReferenceTestData
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ReferenceTestData._({
    this.id,
    required this.referenceLinkUsed,
    required this.referenceQueryParametersJson,
    required this.byteDataId,
    this.byteData,
    this.testExtractJsonResult,
    this.scrappable,
  });

  factory ReferenceTestData({
    int? id,
    required String referenceLinkUsed,
    required String referenceQueryParametersJson,
    required int byteDataId,
    _i2.ByteTestData? byteData,
    String? testExtractJsonResult,
    _i3.Scrappable? scrappable,
  }) = _ReferenceTestDataImpl;

  factory ReferenceTestData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReferenceTestData(
      id: jsonSerialization['id'] as int?,
      referenceLinkUsed: jsonSerialization['referenceLinkUsed'] as String,
      referenceQueryParametersJson:
          jsonSerialization['referenceQueryParametersJson'] as String,
      byteDataId: jsonSerialization['byteDataId'] as int,
      byteData: jsonSerialization['byteData'] == null
          ? null
          : _i2.ByteTestData.fromJson(
              (jsonSerialization['byteData'] as Map<String, dynamic>)),
      testExtractJsonResult:
          jsonSerialization['testExtractJsonResult'] as String?,
      scrappable: jsonSerialization['scrappable'] == null
          ? null
          : _i3.Scrappable.fromJson(
              (jsonSerialization['scrappable'] as Map<String, dynamic>)),
    );
  }

  static final t = ReferenceTestDataTable();

  static const db = ReferenceTestDataRepository._();

  @override
  int? id;

  String referenceLinkUsed;

  String referenceQueryParametersJson;

  int byteDataId;

  _i2.ByteTestData? byteData;

  String? testExtractJsonResult;

  _i3.Scrappable? scrappable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReferenceTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReferenceTestData copyWith({
    int? id,
    String? referenceLinkUsed,
    String? referenceQueryParametersJson,
    int? byteDataId,
    _i2.ByteTestData? byteData,
    String? testExtractJsonResult,
    _i3.Scrappable? scrappable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'referenceLinkUsed': referenceLinkUsed,
      'referenceQueryParametersJson': referenceQueryParametersJson,
      'byteDataId': byteDataId,
      if (byteData != null) 'byteData': byteData?.toJson(),
      if (testExtractJsonResult != null)
        'testExtractJsonResult': testExtractJsonResult,
      if (scrappable != null) 'scrappable': scrappable?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'referenceLinkUsed': referenceLinkUsed,
      'referenceQueryParametersJson': referenceQueryParametersJson,
      'byteDataId': byteDataId,
      if (byteData != null) 'byteData': byteData?.toJsonForProtocol(),
      if (testExtractJsonResult != null)
        'testExtractJsonResult': testExtractJsonResult,
      if (scrappable != null) 'scrappable': scrappable?.toJsonForProtocol(),
    };
  }

  static ReferenceTestDataInclude include({
    _i2.ByteTestDataInclude? byteData,
    _i3.ScrappableInclude? scrappable,
  }) {
    return ReferenceTestDataInclude._(
      byteData: byteData,
      scrappable: scrappable,
    );
  }

  static ReferenceTestDataIncludeList includeList({
    _i1.WhereExpressionBuilder<ReferenceTestDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReferenceTestDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReferenceTestDataTable>? orderByList,
    ReferenceTestDataInclude? include,
  }) {
    return ReferenceTestDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReferenceTestData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ReferenceTestData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReferenceTestDataImpl extends ReferenceTestData {
  _ReferenceTestDataImpl({
    int? id,
    required String referenceLinkUsed,
    required String referenceQueryParametersJson,
    required int byteDataId,
    _i2.ByteTestData? byteData,
    String? testExtractJsonResult,
    _i3.Scrappable? scrappable,
  }) : super._(
          id: id,
          referenceLinkUsed: referenceLinkUsed,
          referenceQueryParametersJson: referenceQueryParametersJson,
          byteDataId: byteDataId,
          byteData: byteData,
          testExtractJsonResult: testExtractJsonResult,
          scrappable: scrappable,
        );

  /// Returns a shallow copy of this [ReferenceTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReferenceTestData copyWith({
    Object? id = _Undefined,
    String? referenceLinkUsed,
    String? referenceQueryParametersJson,
    int? byteDataId,
    Object? byteData = _Undefined,
    Object? testExtractJsonResult = _Undefined,
    Object? scrappable = _Undefined,
  }) {
    return ReferenceTestData(
      id: id is int? ? id : this.id,
      referenceLinkUsed: referenceLinkUsed ?? this.referenceLinkUsed,
      referenceQueryParametersJson:
          referenceQueryParametersJson ?? this.referenceQueryParametersJson,
      byteDataId: byteDataId ?? this.byteDataId,
      byteData:
          byteData is _i2.ByteTestData? ? byteData : this.byteData?.copyWith(),
      testExtractJsonResult: testExtractJsonResult is String?
          ? testExtractJsonResult
          : this.testExtractJsonResult,
      scrappable: scrappable is _i3.Scrappable?
          ? scrappable
          : this.scrappable?.copyWith(),
    );
  }
}

class ReferenceTestDataTable extends _i1.Table<int?> {
  ReferenceTestDataTable({super.tableRelation})
      : super(tableName: 'scrappable_test_data') {
    referenceLinkUsed = _i1.ColumnString(
      'referenceLinkUsed',
      this,
    );
    referenceQueryParametersJson = _i1.ColumnString(
      'referenceQueryParametersJson',
      this,
    );
    byteDataId = _i1.ColumnInt(
      'byteDataId',
      this,
    );
    testExtractJsonResult = _i1.ColumnString(
      'testExtractJsonResult',
      this,
    );
  }

  late final _i1.ColumnString referenceLinkUsed;

  late final _i1.ColumnString referenceQueryParametersJson;

  late final _i1.ColumnInt byteDataId;

  _i2.ByteTestDataTable? _byteData;

  late final _i1.ColumnString testExtractJsonResult;

  _i3.ScrappableTable? _scrappable;

  _i2.ByteTestDataTable get byteData {
    if (_byteData != null) return _byteData!;
    _byteData = _i1.createRelationTable(
      relationFieldName: 'byteData',
      field: ReferenceTestData.t.byteDataId,
      foreignField: _i2.ByteTestData.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ByteTestDataTable(tableRelation: foreignTableRelation),
    );
    return _byteData!;
  }

  _i3.ScrappableTable get scrappable {
    if (_scrappable != null) return _scrappable!;
    _scrappable = _i1.createRelationTable(
      relationFieldName: 'scrappable',
      field: ReferenceTestData.t.id,
      foreignField: _i3.Scrappable.t.referenceTestDataId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ScrappableTable(tableRelation: foreignTableRelation),
    );
    return _scrappable!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        referenceLinkUsed,
        referenceQueryParametersJson,
        byteDataId,
        testExtractJsonResult,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'byteData') {
      return byteData;
    }
    if (relationField == 'scrappable') {
      return scrappable;
    }
    return null;
  }
}

class ReferenceTestDataInclude extends _i1.IncludeObject {
  ReferenceTestDataInclude._({
    _i2.ByteTestDataInclude? byteData,
    _i3.ScrappableInclude? scrappable,
  }) {
    _byteData = byteData;
    _scrappable = scrappable;
  }

  _i2.ByteTestDataInclude? _byteData;

  _i3.ScrappableInclude? _scrappable;

  @override
  Map<String, _i1.Include?> get includes => {
        'byteData': _byteData,
        'scrappable': _scrappable,
      };

  @override
  _i1.Table<int?> get table => ReferenceTestData.t;
}

class ReferenceTestDataIncludeList extends _i1.IncludeList {
  ReferenceTestDataIncludeList._({
    _i1.WhereExpressionBuilder<ReferenceTestDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReferenceTestData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ReferenceTestData.t;
}

class ReferenceTestDataRepository {
  const ReferenceTestDataRepository._();

  final attachRow = const ReferenceTestDataAttachRowRepository._();

  final detachRow = const ReferenceTestDataDetachRowRepository._();

  /// Returns a list of [ReferenceTestData]s matching the given query parameters.
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
  Future<List<ReferenceTestData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReferenceTestDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReferenceTestDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReferenceTestDataTable>? orderByList,
    _i1.Transaction? transaction,
    ReferenceTestDataInclude? include,
  }) async {
    return session.db.find<ReferenceTestData>(
      where: where?.call(ReferenceTestData.t),
      orderBy: orderBy?.call(ReferenceTestData.t),
      orderByList: orderByList?.call(ReferenceTestData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ReferenceTestData] matching the given query parameters.
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
  Future<ReferenceTestData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReferenceTestDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReferenceTestDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReferenceTestDataTable>? orderByList,
    _i1.Transaction? transaction,
    ReferenceTestDataInclude? include,
  }) async {
    return session.db.findFirstRow<ReferenceTestData>(
      where: where?.call(ReferenceTestData.t),
      orderBy: orderBy?.call(ReferenceTestData.t),
      orderByList: orderByList?.call(ReferenceTestData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ReferenceTestData] by its [id] or null if no such row exists.
  Future<ReferenceTestData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ReferenceTestDataInclude? include,
  }) async {
    return session.db.findById<ReferenceTestData>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ReferenceTestData]s in the list and returns the inserted rows.
  ///
  /// The returned [ReferenceTestData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ReferenceTestData>> insert(
    _i1.Session session,
    List<ReferenceTestData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ReferenceTestData>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ReferenceTestData] and returns the inserted row.
  ///
  /// The returned [ReferenceTestData] will have its `id` field set.
  Future<ReferenceTestData> insertRow(
    _i1.Session session,
    ReferenceTestData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReferenceTestData>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReferenceTestData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReferenceTestData>> update(
    _i1.Session session,
    List<ReferenceTestData> rows, {
    _i1.ColumnSelections<ReferenceTestDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReferenceTestData>(
      rows,
      columns: columns?.call(ReferenceTestData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReferenceTestData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReferenceTestData> updateRow(
    _i1.Session session,
    ReferenceTestData row, {
    _i1.ColumnSelections<ReferenceTestDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReferenceTestData>(
      row,
      columns: columns?.call(ReferenceTestData.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ReferenceTestData]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReferenceTestData>> delete(
    _i1.Session session,
    List<ReferenceTestData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReferenceTestData>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReferenceTestData].
  Future<ReferenceTestData> deleteRow(
    _i1.Session session,
    ReferenceTestData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReferenceTestData>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ReferenceTestData>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ReferenceTestDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReferenceTestData>(
      where: where(ReferenceTestData.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ReferenceTestDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReferenceTestData>(
      where: where?.call(ReferenceTestData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ReferenceTestDataAttachRowRepository {
  const ReferenceTestDataAttachRowRepository._();

  /// Creates a relation between the given [ReferenceTestData] and [ByteTestData]
  /// by setting the [ReferenceTestData]'s foreign key `byteDataId` to refer to the [ByteTestData].
  Future<void> byteData(
    _i1.Session session,
    ReferenceTestData referenceTestData,
    _i2.ByteTestData byteData, {
    _i1.Transaction? transaction,
  }) async {
    if (referenceTestData.id == null) {
      throw ArgumentError.notNull('referenceTestData.id');
    }
    if (byteData.id == null) {
      throw ArgumentError.notNull('byteData.id');
    }

    var $referenceTestData =
        referenceTestData.copyWith(byteDataId: byteData.id);
    await session.db.updateRow<ReferenceTestData>(
      $referenceTestData,
      columns: [ReferenceTestData.t.byteDataId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ReferenceTestData] and [Scrappable]
  /// by setting the [ReferenceTestData]'s foreign key `id` to refer to the [Scrappable].
  Future<void> scrappable(
    _i1.Session session,
    ReferenceTestData referenceTestData,
    _i3.Scrappable scrappable, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }
    if (referenceTestData.id == null) {
      throw ArgumentError.notNull('referenceTestData.id');
    }

    var $scrappable =
        scrappable.copyWith(referenceTestDataId: referenceTestData.id);
    await session.db.updateRow<_i3.Scrappable>(
      $scrappable,
      columns: [_i3.Scrappable.t.referenceTestDataId],
      transaction: transaction,
    );
  }
}

class ReferenceTestDataDetachRowRepository {
  const ReferenceTestDataDetachRowRepository._();

  /// Detaches the relation between this [ReferenceTestData] and the [Scrappable] set in `scrappable`
  /// by setting the [ReferenceTestData]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> scrappable(
    _i1.Session session,
    ReferenceTestData referencetestdata, {
    _i1.Transaction? transaction,
  }) async {
    var $scrappable = referencetestdata.scrappable;

    if ($scrappable == null) {
      throw ArgumentError.notNull('referencetestdata.scrappable');
    }
    if ($scrappable.id == null) {
      throw ArgumentError.notNull('referencetestdata.scrappable.id');
    }
    if (referencetestdata.id == null) {
      throw ArgumentError.notNull('referencetestdata.id');
    }

    var $$scrappable = $scrappable.copyWith(referenceTestDataId: null);
    await session.db.updateRow<_i3.Scrappable>(
      $$scrappable,
      columns: [_i3.Scrappable.t.referenceTestDataId],
      transaction: transaction,
    );
  }
}
