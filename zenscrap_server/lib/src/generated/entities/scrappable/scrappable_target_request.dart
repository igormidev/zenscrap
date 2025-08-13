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
import '../../entities/scrappable/scrappable.dart' as _i2;

abstract class ScrappableTargetRequestStructure
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ScrappableTargetRequestStructure._({
    this.id,
    required this.url,
    required this.queryParams,
    required this.pathParams,
    this.scrappable,
  });

  factory ScrappableTargetRequestStructure({
    int? id,
    required String url,
    required Map<String, String?> queryParams,
    required List<String> pathParams,
    _i2.Scrappable? scrappable,
  }) = _ScrappableTargetRequestStructureImpl;

  factory ScrappableTargetRequestStructure.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ScrappableTargetRequestStructure(
      id: jsonSerialization['id'] as int?,
      url: jsonSerialization['url'] as String,
      queryParams:
          (jsonSerialization['queryParams'] as Map).map((k, v) => MapEntry(
                k as String,
                v as String?,
              )),
      pathParams: (jsonSerialization['pathParams'] as List)
          .map((e) => e as String)
          .toList(),
      scrappable: jsonSerialization['scrappable'] == null
          ? null
          : _i2.Scrappable.fromJson(
              (jsonSerialization['scrappable'] as Map<String, dynamic>)),
    );
  }

  static final t = ScrappableTargetRequestStructureTable();

  static const db = ScrappableTargetRequestStructureRepository._();

  @override
  int? id;

  String url;

  Map<String, String?> queryParams;

  List<String> pathParams;

  _i2.Scrappable? scrappable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScrappableTargetRequestStructure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableTargetRequestStructure copyWith({
    int? id,
    String? url,
    Map<String, String?>? queryParams,
    List<String>? pathParams,
    _i2.Scrappable? scrappable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'url': url,
      'queryParams': queryParams.toJson(),
      'pathParams': pathParams.toJson(),
      if (scrappable != null) 'scrappable': scrappable?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'url': url,
      'queryParams': queryParams.toJson(),
      'pathParams': pathParams.toJson(),
      if (scrappable != null) 'scrappable': scrappable?.toJsonForProtocol(),
    };
  }

  static ScrappableTargetRequestStructureInclude include(
      {_i2.ScrappableInclude? scrappable}) {
    return ScrappableTargetRequestStructureInclude._(scrappable: scrappable);
  }

  static ScrappableTargetRequestStructureIncludeList includeList({
    _i1.WhereExpressionBuilder<ScrappableTargetRequestStructureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableTargetRequestStructureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTargetRequestStructureTable>? orderByList,
    ScrappableTargetRequestStructureInclude? include,
  }) {
    return ScrappableTargetRequestStructureIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScrappableTargetRequestStructure.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScrappableTargetRequestStructure.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableTargetRequestStructureImpl
    extends ScrappableTargetRequestStructure {
  _ScrappableTargetRequestStructureImpl({
    int? id,
    required String url,
    required Map<String, String?> queryParams,
    required List<String> pathParams,
    _i2.Scrappable? scrappable,
  }) : super._(
          id: id,
          url: url,
          queryParams: queryParams,
          pathParams: pathParams,
          scrappable: scrappable,
        );

  /// Returns a shallow copy of this [ScrappableTargetRequestStructure]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableTargetRequestStructure copyWith({
    Object? id = _Undefined,
    String? url,
    Map<String, String?>? queryParams,
    List<String>? pathParams,
    Object? scrappable = _Undefined,
  }) {
    return ScrappableTargetRequestStructure(
      id: id is int? ? id : this.id,
      url: url ?? this.url,
      queryParams: queryParams ??
          this.queryParams.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      pathParams: pathParams ?? this.pathParams.map((e0) => e0).toList(),
      scrappable: scrappable is _i2.Scrappable?
          ? scrappable
          : this.scrappable?.copyWith(),
    );
  }
}

class ScrappableTargetRequestStructureTable extends _i1.Table<int?> {
  ScrappableTargetRequestStructureTable({super.tableRelation})
      : super(tableName: 'scrappable_target_request') {
    url = _i1.ColumnString(
      'url',
      this,
    );
    queryParams = _i1.ColumnSerializable(
      'queryParams',
      this,
    );
    pathParams = _i1.ColumnSerializable(
      'pathParams',
      this,
    );
  }

  late final _i1.ColumnString url;

  late final _i1.ColumnSerializable queryParams;

  late final _i1.ColumnSerializable pathParams;

  _i2.ScrappableTable? _scrappable;

  _i2.ScrappableTable get scrappable {
    if (_scrappable != null) return _scrappable!;
    _scrappable = _i1.createRelationTable(
      relationFieldName: 'scrappable',
      field: ScrappableTargetRequestStructure.t.id,
      foreignField: _i2.Scrappable.t.targetRequestId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ScrappableTable(tableRelation: foreignTableRelation),
    );
    return _scrappable!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        url,
        queryParams,
        pathParams,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'scrappable') {
      return scrappable;
    }
    return null;
  }
}

class ScrappableTargetRequestStructureInclude extends _i1.IncludeObject {
  ScrappableTargetRequestStructureInclude._(
      {_i2.ScrappableInclude? scrappable}) {
    _scrappable = scrappable;
  }

  _i2.ScrappableInclude? _scrappable;

  @override
  Map<String, _i1.Include?> get includes => {'scrappable': _scrappable};

  @override
  _i1.Table<int?> get table => ScrappableTargetRequestStructure.t;
}

class ScrappableTargetRequestStructureIncludeList extends _i1.IncludeList {
  ScrappableTargetRequestStructureIncludeList._({
    _i1.WhereExpressionBuilder<ScrappableTargetRequestStructureTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScrappableTargetRequestStructure.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ScrappableTargetRequestStructure.t;
}

class ScrappableTargetRequestStructureRepository {
  const ScrappableTargetRequestStructureRepository._();

  final attachRow =
      const ScrappableTargetRequestStructureAttachRowRepository._();

  /// Returns a list of [ScrappableTargetRequestStructure]s matching the given query parameters.
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
  Future<List<ScrappableTargetRequestStructure>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTargetRequestStructureTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableTargetRequestStructureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTargetRequestStructureTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableTargetRequestStructureInclude? include,
  }) async {
    return session.db.find<ScrappableTargetRequestStructure>(
      where: where?.call(ScrappableTargetRequestStructure.t),
      orderBy: orderBy?.call(ScrappableTargetRequestStructure.t),
      orderByList: orderByList?.call(ScrappableTargetRequestStructure.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ScrappableTargetRequestStructure] matching the given query parameters.
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
  Future<ScrappableTargetRequestStructure?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTargetRequestStructureTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScrappableTargetRequestStructureTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableTargetRequestStructureTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableTargetRequestStructureInclude? include,
  }) async {
    return session.db.findFirstRow<ScrappableTargetRequestStructure>(
      where: where?.call(ScrappableTargetRequestStructure.t),
      orderBy: orderBy?.call(ScrappableTargetRequestStructure.t),
      orderByList: orderByList?.call(ScrappableTargetRequestStructure.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ScrappableTargetRequestStructure] by its [id] or null if no such row exists.
  Future<ScrappableTargetRequestStructure?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ScrappableTargetRequestStructureInclude? include,
  }) async {
    return session.db.findById<ScrappableTargetRequestStructure>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ScrappableTargetRequestStructure]s in the list and returns the inserted rows.
  ///
  /// The returned [ScrappableTargetRequestStructure]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ScrappableTargetRequestStructure>> insert(
    _i1.Session session,
    List<ScrappableTargetRequestStructure> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ScrappableTargetRequestStructure>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ScrappableTargetRequestStructure] and returns the inserted row.
  ///
  /// The returned [ScrappableTargetRequestStructure] will have its `id` field set.
  Future<ScrappableTargetRequestStructure> insertRow(
    _i1.Session session,
    ScrappableTargetRequestStructure row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScrappableTargetRequestStructure>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ScrappableTargetRequestStructure]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ScrappableTargetRequestStructure>> update(
    _i1.Session session,
    List<ScrappableTargetRequestStructure> rows, {
    _i1.ColumnSelections<ScrappableTargetRequestStructureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScrappableTargetRequestStructure>(
      rows,
      columns: columns?.call(ScrappableTargetRequestStructure.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScrappableTargetRequestStructure]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScrappableTargetRequestStructure> updateRow(
    _i1.Session session,
    ScrappableTargetRequestStructure row, {
    _i1.ColumnSelections<ScrappableTargetRequestStructureTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScrappableTargetRequestStructure>(
      row,
      columns: columns?.call(ScrappableTargetRequestStructure.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ScrappableTargetRequestStructure]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ScrappableTargetRequestStructure>> delete(
    _i1.Session session,
    List<ScrappableTargetRequestStructure> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScrappableTargetRequestStructure>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ScrappableTargetRequestStructure].
  Future<ScrappableTargetRequestStructure> deleteRow(
    _i1.Session session,
    ScrappableTargetRequestStructure row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScrappableTargetRequestStructure>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ScrappableTargetRequestStructure>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScrappableTargetRequestStructureTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScrappableTargetRequestStructure>(
      where: where(ScrappableTargetRequestStructure.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableTargetRequestStructureTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScrappableTargetRequestStructure>(
      where: where?.call(ScrappableTargetRequestStructure.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ScrappableTargetRequestStructureAttachRowRepository {
  const ScrappableTargetRequestStructureAttachRowRepository._();

  /// Creates a relation between the given [ScrappableTargetRequestStructure] and [Scrappable]
  /// by setting the [ScrappableTargetRequestStructure]'s foreign key `id` to refer to the [Scrappable].
  Future<void> scrappable(
    _i1.Session session,
    ScrappableTargetRequestStructure scrappableTargetRequestStructure,
    _i2.Scrappable scrappable, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }
    if (scrappableTargetRequestStructure.id == null) {
      throw ArgumentError.notNull('scrappableTargetRequestStructure.id');
    }

    var $scrappable = scrappable.copyWith(
        targetRequestId: scrappableTargetRequestStructure.id);
    await session.db.updateRow<_i2.Scrappable>(
      $scrappable,
      columns: [_i2.Scrappable.t.targetRequestId],
      transaction: transaction,
    );
  }
}
