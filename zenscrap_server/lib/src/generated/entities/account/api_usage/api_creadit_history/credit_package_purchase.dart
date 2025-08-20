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

abstract class CreditPackagePurchase
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CreditPackagePurchase._({
    this.id,
    required this.value,
    this.stripePurchaseId,
  });

  factory CreditPackagePurchase({
    int? id,
    required double value,
    String? stripePurchaseId,
  }) = _CreditPackagePurchaseImpl;

  factory CreditPackagePurchase.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return CreditPackagePurchase(
      id: jsonSerialization['id'] as int?,
      value: (jsonSerialization['value'] as num).toDouble(),
      stripePurchaseId: jsonSerialization['stripePurchaseId'] as String?,
    );
  }

  static final t = CreditPackagePurchaseTable();

  static const db = CreditPackagePurchaseRepository._();

  @override
  int? id;

  double value;

  String? stripePurchaseId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CreditPackagePurchase]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CreditPackagePurchase copyWith({
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

  static CreditPackagePurchaseInclude include() {
    return CreditPackagePurchaseInclude._();
  }

  static CreditPackagePurchaseIncludeList includeList({
    _i1.WhereExpressionBuilder<CreditPackagePurchaseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreditPackagePurchaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreditPackagePurchaseTable>? orderByList,
    CreditPackagePurchaseInclude? include,
  }) {
    return CreditPackagePurchaseIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CreditPackagePurchase.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CreditPackagePurchase.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreditPackagePurchaseImpl extends CreditPackagePurchase {
  _CreditPackagePurchaseImpl({
    int? id,
    required double value,
    String? stripePurchaseId,
  }) : super._(
          id: id,
          value: value,
          stripePurchaseId: stripePurchaseId,
        );

  /// Returns a shallow copy of this [CreditPackagePurchase]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CreditPackagePurchase copyWith({
    Object? id = _Undefined,
    double? value,
    Object? stripePurchaseId = _Undefined,
  }) {
    return CreditPackagePurchase(
      id: id is int? ? id : this.id,
      value: value ?? this.value,
      stripePurchaseId: stripePurchaseId is String?
          ? stripePurchaseId
          : this.stripePurchaseId,
    );
  }
}

class CreditPackagePurchaseTable extends _i1.Table<int?> {
  CreditPackagePurchaseTable({super.tableRelation})
      : super(tableName: 'credit_package_purchase') {
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

class CreditPackagePurchaseInclude extends _i1.IncludeObject {
  CreditPackagePurchaseInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CreditPackagePurchase.t;
}

class CreditPackagePurchaseIncludeList extends _i1.IncludeList {
  CreditPackagePurchaseIncludeList._({
    _i1.WhereExpressionBuilder<CreditPackagePurchaseTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CreditPackagePurchase.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CreditPackagePurchase.t;
}

class CreditPackagePurchaseRepository {
  const CreditPackagePurchaseRepository._();

  /// Returns a list of [CreditPackagePurchase]s matching the given query parameters.
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
  Future<List<CreditPackagePurchase>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreditPackagePurchaseTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreditPackagePurchaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreditPackagePurchaseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CreditPackagePurchase>(
      where: where?.call(CreditPackagePurchase.t),
      orderBy: orderBy?.call(CreditPackagePurchase.t),
      orderByList: orderByList?.call(CreditPackagePurchase.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CreditPackagePurchase] matching the given query parameters.
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
  Future<CreditPackagePurchase?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreditPackagePurchaseTable>? where,
    int? offset,
    _i1.OrderByBuilder<CreditPackagePurchaseTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreditPackagePurchaseTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CreditPackagePurchase>(
      where: where?.call(CreditPackagePurchase.t),
      orderBy: orderBy?.call(CreditPackagePurchase.t),
      orderByList: orderByList?.call(CreditPackagePurchase.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CreditPackagePurchase] by its [id] or null if no such row exists.
  Future<CreditPackagePurchase?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CreditPackagePurchase>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CreditPackagePurchase]s in the list and returns the inserted rows.
  ///
  /// The returned [CreditPackagePurchase]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CreditPackagePurchase>> insert(
    _i1.Session session,
    List<CreditPackagePurchase> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CreditPackagePurchase>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CreditPackagePurchase] and returns the inserted row.
  ///
  /// The returned [CreditPackagePurchase] will have its `id` field set.
  Future<CreditPackagePurchase> insertRow(
    _i1.Session session,
    CreditPackagePurchase row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CreditPackagePurchase>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CreditPackagePurchase]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CreditPackagePurchase>> update(
    _i1.Session session,
    List<CreditPackagePurchase> rows, {
    _i1.ColumnSelections<CreditPackagePurchaseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CreditPackagePurchase>(
      rows,
      columns: columns?.call(CreditPackagePurchase.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CreditPackagePurchase]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CreditPackagePurchase> updateRow(
    _i1.Session session,
    CreditPackagePurchase row, {
    _i1.ColumnSelections<CreditPackagePurchaseTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CreditPackagePurchase>(
      row,
      columns: columns?.call(CreditPackagePurchase.t),
      transaction: transaction,
    );
  }

  /// Deletes all [CreditPackagePurchase]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CreditPackagePurchase>> delete(
    _i1.Session session,
    List<CreditPackagePurchase> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CreditPackagePurchase>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CreditPackagePurchase].
  Future<CreditPackagePurchase> deleteRow(
    _i1.Session session,
    CreditPackagePurchase row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CreditPackagePurchase>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CreditPackagePurchase>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CreditPackagePurchaseTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CreditPackagePurchase>(
      where: where(CreditPackagePurchase.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreditPackagePurchaseTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CreditPackagePurchase>(
      where: where?.call(CreditPackagePurchase.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
