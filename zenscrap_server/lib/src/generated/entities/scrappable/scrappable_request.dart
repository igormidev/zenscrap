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

abstract class ScrappableRequest
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ScrappableRequest._({
    this.id,
    required this.url,
    required this.queryParams,
    required this.queryParamsNotRelatedToUrl,
    required this.pathParams,
    this.scrappable,
  });

  factory ScrappableRequest({
    int? id,
    required String url,
    required Map<String, String?> queryParams,
    required Map<String, String?> queryParamsNotRelatedToUrl,
    required List<String> pathParams,
    _i2.Scrappable? scrappable,
  }) = _ScrappableRequestImpl;

  factory ScrappableRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScrappableRequest(
      id: jsonSerialization['id'] as int?,
      url: jsonSerialization['url'] as String,
      queryParams:
          (jsonSerialization['queryParams'] as Map).map((k, v) => MapEntry(
                k as String,
                v as String?,
              )),
      queryParamsNotRelatedToUrl:
          (jsonSerialization['queryParamsNotRelatedToUrl'] as Map)
              .map((k, v) => MapEntry(
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

  static final t = ScrappableRequestTable();

  static const db = ScrappableRequestRepository._();

  @override
  int? id;

  String url;

  Map<String, String?> queryParams;

  Map<String, String?> queryParamsNotRelatedToUrl;

  List<String> pathParams;

  _i2.Scrappable? scrappable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScrappableRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ScrappableRequest copyWith({
    int? id,
    String? url,
    Map<String, String?>? queryParams,
    Map<String, String?>? queryParamsNotRelatedToUrl,
    List<String>? pathParams,
    _i2.Scrappable? scrappable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'url': url,
      'queryParams': queryParams.toJson(),
      'queryParamsNotRelatedToUrl': queryParamsNotRelatedToUrl.toJson(),
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
      'queryParamsNotRelatedToUrl': queryParamsNotRelatedToUrl.toJson(),
      'pathParams': pathParams.toJson(),
      if (scrappable != null) 'scrappable': scrappable?.toJsonForProtocol(),
    };
  }

  static ScrappableRequestInclude include({_i2.ScrappableInclude? scrappable}) {
    return ScrappableRequestInclude._(scrappable: scrappable);
  }

  static ScrappableRequestIncludeList includeList({
    _i1.WhereExpressionBuilder<ScrappableRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableRequestTable>? orderByList,
    ScrappableRequestInclude? include,
  }) {
    return ScrappableRequestIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScrappableRequest.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ScrappableRequest.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScrappableRequestImpl extends ScrappableRequest {
  _ScrappableRequestImpl({
    int? id,
    required String url,
    required Map<String, String?> queryParams,
    required Map<String, String?> queryParamsNotRelatedToUrl,
    required List<String> pathParams,
    _i2.Scrappable? scrappable,
  }) : super._(
          id: id,
          url: url,
          queryParams: queryParams,
          queryParamsNotRelatedToUrl: queryParamsNotRelatedToUrl,
          pathParams: pathParams,
          scrappable: scrappable,
        );

  /// Returns a shallow copy of this [ScrappableRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ScrappableRequest copyWith({
    Object? id = _Undefined,
    String? url,
    Map<String, String?>? queryParams,
    Map<String, String?>? queryParamsNotRelatedToUrl,
    List<String>? pathParams,
    Object? scrappable = _Undefined,
  }) {
    return ScrappableRequest(
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
      queryParamsNotRelatedToUrl: queryParamsNotRelatedToUrl ??
          this.queryParamsNotRelatedToUrl.map((
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

class ScrappableRequestTable extends _i1.Table<int?> {
  ScrappableRequestTable({super.tableRelation})
      : super(tableName: 'scrappable_target_request') {
    url = _i1.ColumnString(
      'url',
      this,
    );
    queryParams = _i1.ColumnSerializable(
      'queryParams',
      this,
    );
    queryParamsNotRelatedToUrl = _i1.ColumnSerializable(
      'queryParamsNotRelatedToUrl',
      this,
    );
    pathParams = _i1.ColumnSerializable(
      'pathParams',
      this,
    );
  }

  late final _i1.ColumnString url;

  late final _i1.ColumnSerializable queryParams;

  late final _i1.ColumnSerializable queryParamsNotRelatedToUrl;

  late final _i1.ColumnSerializable pathParams;

  _i2.ScrappableTable? _scrappable;

  _i2.ScrappableTable get scrappable {
    if (_scrappable != null) return _scrappable!;
    _scrappable = _i1.createRelationTable(
      relationFieldName: 'scrappable',
      field: ScrappableRequest.t.id,
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
        queryParamsNotRelatedToUrl,
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

class ScrappableRequestInclude extends _i1.IncludeObject {
  ScrappableRequestInclude._({_i2.ScrappableInclude? scrappable}) {
    _scrappable = scrappable;
  }

  _i2.ScrappableInclude? _scrappable;

  @override
  Map<String, _i1.Include?> get includes => {'scrappable': _scrappable};

  @override
  _i1.Table<int?> get table => ScrappableRequest.t;
}

class ScrappableRequestIncludeList extends _i1.IncludeList {
  ScrappableRequestIncludeList._({
    _i1.WhereExpressionBuilder<ScrappableRequestTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ScrappableRequest.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ScrappableRequest.t;
}

class ScrappableRequestRepository {
  const ScrappableRequestRepository._();

  final attachRow = const ScrappableRequestAttachRowRepository._();

  /// Returns a list of [ScrappableRequest]s matching the given query parameters.
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
  Future<List<ScrappableRequest>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableRequestTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ScrappableRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableRequestTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableRequestInclude? include,
  }) async {
    return session.db.find<ScrappableRequest>(
      where: where?.call(ScrappableRequest.t),
      orderBy: orderBy?.call(ScrappableRequest.t),
      orderByList: orderByList?.call(ScrappableRequest.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ScrappableRequest] matching the given query parameters.
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
  Future<ScrappableRequest?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableRequestTable>? where,
    int? offset,
    _i1.OrderByBuilder<ScrappableRequestTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ScrappableRequestTable>? orderByList,
    _i1.Transaction? transaction,
    ScrappableRequestInclude? include,
  }) async {
    return session.db.findFirstRow<ScrappableRequest>(
      where: where?.call(ScrappableRequest.t),
      orderBy: orderBy?.call(ScrappableRequest.t),
      orderByList: orderByList?.call(ScrappableRequest.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ScrappableRequest] by its [id] or null if no such row exists.
  Future<ScrappableRequest?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ScrappableRequestInclude? include,
  }) async {
    return session.db.findById<ScrappableRequest>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ScrappableRequest]s in the list and returns the inserted rows.
  ///
  /// The returned [ScrappableRequest]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ScrappableRequest>> insert(
    _i1.Session session,
    List<ScrappableRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ScrappableRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ScrappableRequest] and returns the inserted row.
  ///
  /// The returned [ScrappableRequest] will have its `id` field set.
  Future<ScrappableRequest> insertRow(
    _i1.Session session,
    ScrappableRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScrappableRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ScrappableRequest]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ScrappableRequest>> update(
    _i1.Session session,
    List<ScrappableRequest> rows, {
    _i1.ColumnSelections<ScrappableRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ScrappableRequest>(
      rows,
      columns: columns?.call(ScrappableRequest.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScrappableRequest]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScrappableRequest> updateRow(
    _i1.Session session,
    ScrappableRequest row, {
    _i1.ColumnSelections<ScrappableRequestTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScrappableRequest>(
      row,
      columns: columns?.call(ScrappableRequest.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ScrappableRequest]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ScrappableRequest>> delete(
    _i1.Session session,
    List<ScrappableRequest> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ScrappableRequest>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ScrappableRequest].
  Future<ScrappableRequest> deleteRow(
    _i1.Session session,
    ScrappableRequest row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScrappableRequest>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ScrappableRequest>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ScrappableRequestTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ScrappableRequest>(
      where: where(ScrappableRequest.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ScrappableRequestTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ScrappableRequest>(
      where: where?.call(ScrappableRequest.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ScrappableRequestAttachRowRepository {
  const ScrappableRequestAttachRowRepository._();

  /// Creates a relation between the given [ScrappableRequest] and [Scrappable]
  /// by setting the [ScrappableRequest]'s foreign key `id` to refer to the [Scrappable].
  Future<void> scrappable(
    _i1.Session session,
    ScrappableRequest scrappableRequest,
    _i2.Scrappable scrappable, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }
    if (scrappableRequest.id == null) {
      throw ArgumentError.notNull('scrappableRequest.id');
    }

    var $scrappable =
        scrappable.copyWith(targetRequestId: scrappableRequest.id);
    await session.db.updateRow<_i2.Scrappable>(
      $scrappable,
      columns: [_i2.Scrappable.t.targetRequestId],
      transaction: transaction,
    );
  }
}
