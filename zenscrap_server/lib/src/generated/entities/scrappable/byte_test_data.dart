/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;

abstract class ByteTestData
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ByteTestData._({
    this.id,
    required this.referenceHtmlPage,
    required this.referenceSiteScreenshot,
  });

  factory ByteTestData({
    int? id,
    required _i2.ByteData referenceHtmlPage,
    required _i2.ByteData referenceSiteScreenshot,
  }) = _ByteTestDataImpl;

  factory ByteTestData.fromJson(Map<String, dynamic> jsonSerialization) {
    return ByteTestData(
      id: jsonSerialization['id'] as int?,
      referenceHtmlPage: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['referenceHtmlPage']),
      referenceSiteScreenshot: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['referenceSiteScreenshot']),
    );
  }

  static final t = ByteTestDataTable();

  static const db = ByteTestDataRepository._();

  @override
  int? id;

  _i2.ByteData referenceHtmlPage;

  _i2.ByteData referenceSiteScreenshot;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ByteTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ByteTestData copyWith({
    int? id,
    _i2.ByteData? referenceHtmlPage,
    _i2.ByteData? referenceSiteScreenshot,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'referenceHtmlPage': referenceHtmlPage.toJson(),
      'referenceSiteScreenshot': referenceSiteScreenshot.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'referenceHtmlPage': referenceHtmlPage.toJson(),
      'referenceSiteScreenshot': referenceSiteScreenshot.toJson(),
    };
  }

  static ByteTestDataInclude include() {
    return ByteTestDataInclude._();
  }

  static ByteTestDataIncludeList includeList({
    _i1.WhereExpressionBuilder<ByteTestDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ByteTestDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ByteTestDataTable>? orderByList,
    ByteTestDataInclude? include,
  }) {
    return ByteTestDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ByteTestData.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ByteTestData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ByteTestDataImpl extends ByteTestData {
  _ByteTestDataImpl({
    int? id,
    required _i2.ByteData referenceHtmlPage,
    required _i2.ByteData referenceSiteScreenshot,
  }) : super._(
          id: id,
          referenceHtmlPage: referenceHtmlPage,
          referenceSiteScreenshot: referenceSiteScreenshot,
        );

  /// Returns a shallow copy of this [ByteTestData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ByteTestData copyWith({
    Object? id = _Undefined,
    _i2.ByteData? referenceHtmlPage,
    _i2.ByteData? referenceSiteScreenshot,
  }) {
    return ByteTestData(
      id: id is int? ? id : this.id,
      referenceHtmlPage: referenceHtmlPage ?? this.referenceHtmlPage.clone(),
      referenceSiteScreenshot:
          referenceSiteScreenshot ?? this.referenceSiteScreenshot.clone(),
    );
  }
}

class ByteTestDataTable extends _i1.Table<int?> {
  ByteTestDataTable({super.tableRelation})
      : super(tableName: 'byte_test_data') {
    referenceHtmlPage = _i1.ColumnByteData(
      'referenceHtmlPage',
      this,
    );
    referenceSiteScreenshot = _i1.ColumnByteData(
      'referenceSiteScreenshot',
      this,
    );
  }

  late final _i1.ColumnByteData referenceHtmlPage;

  late final _i1.ColumnByteData referenceSiteScreenshot;

  @override
  List<_i1.Column> get columns => [
        id,
        referenceHtmlPage,
        referenceSiteScreenshot,
      ];
}

class ByteTestDataInclude extends _i1.IncludeObject {
  ByteTestDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ByteTestData.t;
}

class ByteTestDataIncludeList extends _i1.IncludeList {
  ByteTestDataIncludeList._({
    _i1.WhereExpressionBuilder<ByteTestDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ByteTestData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ByteTestData.t;
}

class ByteTestDataRepository {
  const ByteTestDataRepository._();

  /// Returns a list of [ByteTestData]s matching the given query parameters.
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
  Future<List<ByteTestData>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ByteTestDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ByteTestDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ByteTestDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ByteTestData>(
      where: where?.call(ByteTestData.t),
      orderBy: orderBy?.call(ByteTestData.t),
      orderByList: orderByList?.call(ByteTestData.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ByteTestData] matching the given query parameters.
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
  Future<ByteTestData?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ByteTestDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<ByteTestDataTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ByteTestDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ByteTestData>(
      where: where?.call(ByteTestData.t),
      orderBy: orderBy?.call(ByteTestData.t),
      orderByList: orderByList?.call(ByteTestData.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ByteTestData] by its [id] or null if no such row exists.
  Future<ByteTestData?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ByteTestData>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ByteTestData]s in the list and returns the inserted rows.
  ///
  /// The returned [ByteTestData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ByteTestData>> insert(
    _i1.Session session,
    List<ByteTestData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ByteTestData>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ByteTestData] and returns the inserted row.
  ///
  /// The returned [ByteTestData] will have its `id` field set.
  Future<ByteTestData> insertRow(
    _i1.Session session,
    ByteTestData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ByteTestData>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ByteTestData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ByteTestData>> update(
    _i1.Session session,
    List<ByteTestData> rows, {
    _i1.ColumnSelections<ByteTestDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ByteTestData>(
      rows,
      columns: columns?.call(ByteTestData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ByteTestData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ByteTestData> updateRow(
    _i1.Session session,
    ByteTestData row, {
    _i1.ColumnSelections<ByteTestDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ByteTestData>(
      row,
      columns: columns?.call(ByteTestData.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ByteTestData]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ByteTestData>> delete(
    _i1.Session session,
    List<ByteTestData> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ByteTestData>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ByteTestData].
  Future<ByteTestData> deleteRow(
    _i1.Session session,
    ByteTestData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ByteTestData>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ByteTestData>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ByteTestDataTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ByteTestData>(
      where: where(ByteTestData.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ByteTestDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ByteTestData>(
      where: where?.call(ByteTestData.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
