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

abstract class ApiCreditPackagePurchase
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ApiCreditPackagePurchase._({
    this.id,
    required this.value,
    this.stripePurchaseId,
  });

  factory ApiCreditPackagePurchase({
    int? id,
    required double value,
    String? stripePurchaseId,
  }) = _ApiCreditPackagePurchaseImpl;

  factory ApiCreditPackagePurchase.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ApiCreditPackagePurchase(
      id: jsonSerialization['id'] as int?,
      value: (jsonSerialization['value'] as num).toDouble(),
      stripePurchaseId: jsonSerialization['stripePurchaseId'] as String?,
    );
  }

  static final t = ApiCreditPackagePurchaseTable();

  static const db = ApiCreditPackagePurchaseRepository._();

  @override
  int? id;

  double value;

  String? stripePurchaseId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ApiCreditPackagePurchase]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiCreditPackagePurchase copyWith({
    int? id,
    double? value,
    String? stripePurchaseId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'value': value,
      if (stripePurchaseId != null) 'stripePurchaseId': stripePurchaseId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'value': value,
      if (stripePurchaseId != null) 'stripePurchaseId': stripePurchaseId,
    };
  }

  static ApiCreditPackagePurchaseInclude include() {
    return ApiCreditPackagePurchaseInclude._();
  }

  static ApiCreditPackagePurchaseIncludeList includeList({
    _i1.WhereExpressionBuilder<ApiCreditPackagePurchaseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ApiCreditPackagePurchaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiCreditPackagePurchaseTable>? orderByList,
    ApiCreditPackagePurchaseInclude? include,
  }) {
    return ApiCreditPackagePurchaseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ApiCreditPackagePurchase.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ApiCreditPackagePurchase.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiCreditPackagePurchaseImpl extends ApiCreditPackagePurchase {
  _ApiCreditPackagePurchaseImpl({
    int? id,
    required double value,
    String? stripePurchaseId,
  }) : super._(
          id: id,
          value: value,
          stripePurchaseId: stripePurchaseId,
        );

  /// Returns a shallow copy of this [ApiCreditPackagePurchase]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiCreditPackagePurchase copyWith({
    Object? id = _Undefined,
    double? value,
    Object? stripePurchaseId = _Undefined,
  }) {
    return ApiCreditPackagePurchase(
      id: id is int? ? id : this.id,
      value: value ?? this.value,
      stripePurchaseId: stripePurchaseId is String?
          ? stripePurchaseId
          : this.stripePurchaseId,
    );
  }
}

class ApiCreditPackagePurchaseTable extends _i1.Table<int?> {
  ApiCreditPackagePurchaseTable({super.tableRelation})
      : super(tableName: 'api_credit_package_purchase') {
    value = _i1.ColumnDouble(
      'value',
      this,
    );
    stripePurchaseId = _i1.ColumnString(
      'stripePurchaseId',
      this,
    );
  }

  late final _i1.ColumnDouble value;

  late final _i1.ColumnString stripePurchaseId;

  @override
  List<_i1.Column> get columns => [
        id,
        value,
        stripePurchaseId,
      ];
}

class ApiCreditPackagePurchaseInclude extends _i1.IncludeObject {
  ApiCreditPackagePurchaseInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ApiCreditPackagePurchase.t;
}

class ApiCreditPackagePurchaseIncludeList extends _i1.IncludeList {
  ApiCreditPackagePurchaseIncludeList._({
    _i1.WhereExpressionBuilder<ApiCreditPackagePurchaseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ApiCreditPackagePurchase.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ApiCreditPackagePurchase.t;
}

class ApiCreditPackagePurchaseRepository {
  const ApiCreditPackagePurchaseRepository._();

  /// Returns a list of [ApiCreditPackagePurchase]s matching the given query parameters.
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
  Future<List<ApiCreditPackagePurchase>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiCreditPackagePurchaseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ApiCreditPackagePurchaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiCreditPackagePurchaseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ApiCreditPackagePurchase>(
      where: where?.call(ApiCreditPackagePurchase.t),
      orderBy: orderBy?.call(ApiCreditPackagePurchase.t),
      orderByList: orderByList?.call(ApiCreditPackagePurchase.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ApiCreditPackagePurchase] matching the given query parameters.
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
  Future<ApiCreditPackagePurchase?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiCreditPackagePurchaseTable>? where,
    int? offset,
    _i1.OrderByBuilder<ApiCreditPackagePurchaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiCreditPackagePurchaseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ApiCreditPackagePurchase>(
      where: where?.call(ApiCreditPackagePurchase.t),
      orderBy: orderBy?.call(ApiCreditPackagePurchase.t),
      orderByList: orderByList?.call(ApiCreditPackagePurchase.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ApiCreditPackagePurchase] by its [id] or null if no such row exists.
  Future<ApiCreditPackagePurchase?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ApiCreditPackagePurchase>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ApiCreditPackagePurchase]s in the list and returns the inserted rows.
  ///
  /// The returned [ApiCreditPackagePurchase]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ApiCreditPackagePurchase>> insert(
    _i1.Session session,
    List<ApiCreditPackagePurchase> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ApiCreditPackagePurchase>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ApiCreditPackagePurchase] and returns the inserted row.
  ///
  /// The returned [ApiCreditPackagePurchase] will have its `id` field set.
  Future<ApiCreditPackagePurchase> insertRow(
    _i1.Session session,
    ApiCreditPackagePurchase row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ApiCreditPackagePurchase>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ApiCreditPackagePurchase]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ApiCreditPackagePurchase>> update(
    _i1.Session session,
    List<ApiCreditPackagePurchase> rows, {
    _i1.ColumnSelections<ApiCreditPackagePurchaseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ApiCreditPackagePurchase>(
      rows,
      columns: columns?.call(ApiCreditPackagePurchase.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ApiCreditPackagePurchase]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ApiCreditPackagePurchase> updateRow(
    _i1.Session session,
    ApiCreditPackagePurchase row, {
    _i1.ColumnSelections<ApiCreditPackagePurchaseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ApiCreditPackagePurchase>(
      row,
      columns: columns?.call(ApiCreditPackagePurchase.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ApiCreditPackagePurchase]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ApiCreditPackagePurchase>> delete(
    _i1.Session session,
    List<ApiCreditPackagePurchase> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ApiCreditPackagePurchase>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ApiCreditPackagePurchase].
  Future<ApiCreditPackagePurchase> deleteRow(
    _i1.Session session,
    ApiCreditPackagePurchase row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ApiCreditPackagePurchase>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ApiCreditPackagePurchase>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ApiCreditPackagePurchaseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ApiCreditPackagePurchase>(
      where: where(ApiCreditPackagePurchase.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiCreditPackagePurchaseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ApiCreditPackagePurchase>(
      where: where?.call(ApiCreditPackagePurchase.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
