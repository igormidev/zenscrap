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

abstract class AnonymousIpSpending
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AnonymousIpSpending._({
    this.id,
    required this.ipAddress,
    required this.totalSpentUsd,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  factory AnonymousIpSpending({
    int? id,
    required String ipAddress,
    required double totalSpentUsd,
    required DateTime createdAt,
    required DateTime lastUpdatedAt,
  }) = _AnonymousIpSpendingImpl;

  factory AnonymousIpSpending.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnonymousIpSpending(
      id: jsonSerialization['id'] as int?,
      ipAddress: jsonSerialization['ipAddress'] as String,
      totalSpentUsd: (jsonSerialization['totalSpentUsd'] as num).toDouble(),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastUpdatedAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['lastUpdatedAt']),
    );
  }

  static final t = AnonymousIpSpendingTable();

  static const db = AnonymousIpSpendingRepository._();

  @override
  int? id;

  String ipAddress;

  double totalSpentUsd;

  DateTime createdAt;

  DateTime lastUpdatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AnonymousIpSpending]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnonymousIpSpending copyWith({
    int? id,
    String? ipAddress,
    double? totalSpentUsd,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'ipAddress': ipAddress,
      'totalSpentUsd': totalSpentUsd,
      'createdAt': createdAt.toJson(),
      'lastUpdatedAt': lastUpdatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'ipAddress': ipAddress,
      'totalSpentUsd': totalSpentUsd,
      'createdAt': createdAt.toJson(),
      'lastUpdatedAt': lastUpdatedAt.toJson(),
    };
  }

  static AnonymousIpSpendingInclude include() {
    return AnonymousIpSpendingInclude._();
  }

  static AnonymousIpSpendingIncludeList includeList({
    _i1.WhereExpressionBuilder<AnonymousIpSpendingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnonymousIpSpendingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousIpSpendingTable>? orderByList,
    AnonymousIpSpendingInclude? include,
  }) {
    return AnonymousIpSpendingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AnonymousIpSpending.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AnonymousIpSpending.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnonymousIpSpendingImpl extends AnonymousIpSpending {
  _AnonymousIpSpendingImpl({
    int? id,
    required String ipAddress,
    required double totalSpentUsd,
    required DateTime createdAt,
    required DateTime lastUpdatedAt,
  }) : super._(
          id: id,
          ipAddress: ipAddress,
          totalSpentUsd: totalSpentUsd,
          createdAt: createdAt,
          lastUpdatedAt: lastUpdatedAt,
        );

  /// Returns a shallow copy of this [AnonymousIpSpending]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnonymousIpSpending copyWith({
    Object? id = _Undefined,
    String? ipAddress,
    double? totalSpentUsd,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
  }) {
    return AnonymousIpSpending(
      id: id is int? ? id : this.id,
      ipAddress: ipAddress ?? this.ipAddress,
      totalSpentUsd: totalSpentUsd ?? this.totalSpentUsd,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}

class AnonymousIpSpendingTable extends _i1.Table<int?> {
  AnonymousIpSpendingTable({super.tableRelation})
      : super(tableName: 'anonymous_ip_spending') {
    ipAddress = _i1.ColumnString(
      'ipAddress',
      this,
    );
    totalSpentUsd = _i1.ColumnDouble(
      'totalSpentUsd',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    lastUpdatedAt = _i1.ColumnDateTime(
      'lastUpdatedAt',
      this,
    );
  }

  late final _i1.ColumnString ipAddress;

  late final _i1.ColumnDouble totalSpentUsd;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime lastUpdatedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        ipAddress,
        totalSpentUsd,
        createdAt,
        lastUpdatedAt,
      ];
}

class AnonymousIpSpendingInclude extends _i1.IncludeObject {
  AnonymousIpSpendingInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AnonymousIpSpending.t;
}

class AnonymousIpSpendingIncludeList extends _i1.IncludeList {
  AnonymousIpSpendingIncludeList._({
    _i1.WhereExpressionBuilder<AnonymousIpSpendingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AnonymousIpSpending.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AnonymousIpSpending.t;
}

class AnonymousIpSpendingRepository {
  const AnonymousIpSpendingRepository._();

  /// Returns a list of [AnonymousIpSpending]s matching the given query parameters.
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
  Future<List<AnonymousIpSpending>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousIpSpendingTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AnonymousIpSpendingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousIpSpendingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AnonymousIpSpending>(
      where: where?.call(AnonymousIpSpending.t),
      orderBy: orderBy?.call(AnonymousIpSpending.t),
      orderByList: orderByList?.call(AnonymousIpSpending.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AnonymousIpSpending] matching the given query parameters.
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
  Future<AnonymousIpSpending?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousIpSpendingTable>? where,
    int? offset,
    _i1.OrderByBuilder<AnonymousIpSpendingTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AnonymousIpSpendingTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AnonymousIpSpending>(
      where: where?.call(AnonymousIpSpending.t),
      orderBy: orderBy?.call(AnonymousIpSpending.t),
      orderByList: orderByList?.call(AnonymousIpSpending.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AnonymousIpSpending] by its [id] or null if no such row exists.
  Future<AnonymousIpSpending?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AnonymousIpSpending>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AnonymousIpSpending]s in the list and returns the inserted rows.
  ///
  /// The returned [AnonymousIpSpending]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AnonymousIpSpending>> insert(
    _i1.Session session,
    List<AnonymousIpSpending> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AnonymousIpSpending>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AnonymousIpSpending] and returns the inserted row.
  ///
  /// The returned [AnonymousIpSpending] will have its `id` field set.
  Future<AnonymousIpSpending> insertRow(
    _i1.Session session,
    AnonymousIpSpending row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AnonymousIpSpending>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AnonymousIpSpending]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AnonymousIpSpending>> update(
    _i1.Session session,
    List<AnonymousIpSpending> rows, {
    _i1.ColumnSelections<AnonymousIpSpendingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AnonymousIpSpending>(
      rows,
      columns: columns?.call(AnonymousIpSpending.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AnonymousIpSpending]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AnonymousIpSpending> updateRow(
    _i1.Session session,
    AnonymousIpSpending row, {
    _i1.ColumnSelections<AnonymousIpSpendingTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AnonymousIpSpending>(
      row,
      columns: columns?.call(AnonymousIpSpending.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AnonymousIpSpending]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AnonymousIpSpending>> delete(
    _i1.Session session,
    List<AnonymousIpSpending> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AnonymousIpSpending>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AnonymousIpSpending].
  Future<AnonymousIpSpending> deleteRow(
    _i1.Session session,
    AnonymousIpSpending row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AnonymousIpSpending>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AnonymousIpSpending>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AnonymousIpSpendingTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AnonymousIpSpending>(
      where: where(AnonymousIpSpending.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AnonymousIpSpendingTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AnonymousIpSpending>(
      where: where?.call(AnonymousIpSpending.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
