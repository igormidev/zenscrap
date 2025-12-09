/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../../entities/account/api_usage/account_api_usage.dart' as _i2;
import 'package:zenscrap_server/src/generated/protocol.dart' as _i3;

abstract class CreditUsage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CreditUsage._({
    this.id,
    required this.subscriptionCredits,
    required this.purchasedCredits,
    this.accountApiUsage,
  });

  factory CreditUsage({
    int? id,
    required int subscriptionCredits,
    required int purchasedCredits,
    _i2.AccountApiUsage? accountApiUsage,
  }) = _CreditUsageImpl;

  factory CreditUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return CreditUsage(
      id: jsonSerialization['id'] as int?,
      subscriptionCredits: jsonSerialization['subscriptionCredits'] as int,
      purchasedCredits: jsonSerialization['purchasedCredits'] as int,
      accountApiUsage: jsonSerialization['accountApiUsage'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.AccountApiUsage>(
              jsonSerialization['accountApiUsage'],
            ),
    );
  }

  static final t = CreditUsageTable();

  static const db = CreditUsageRepository._();

  @override
  int? id;

  int subscriptionCredits;

  int purchasedCredits;

  _i2.AccountApiUsage? accountApiUsage;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CreditUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CreditUsage copyWith({
    int? id,
    int? subscriptionCredits,
    int? purchasedCredits,
    _i2.AccountApiUsage? accountApiUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CreditUsage',
      if (id != null) 'id': id,
      'subscriptionCredits': subscriptionCredits,
      'purchasedCredits': purchasedCredits,
      if (accountApiUsage != null) 'accountApiUsage': accountApiUsage?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CreditUsage',
      if (id != null) 'id': id,
      'subscriptionCredits': subscriptionCredits,
      'purchasedCredits': purchasedCredits,
      if (accountApiUsage != null)
        'accountApiUsage': accountApiUsage?.toJsonForProtocol(),
    };
  }

  static CreditUsageInclude include({
    _i2.AccountApiUsageInclude? accountApiUsage,
  }) {
    return CreditUsageInclude._(accountApiUsage: accountApiUsage);
  }

  static CreditUsageIncludeList includeList({
    _i1.WhereExpressionBuilder<CreditUsageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreditUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreditUsageTable>? orderByList,
    CreditUsageInclude? include,
  }) {
    return CreditUsageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CreditUsage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CreditUsage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreditUsageImpl extends CreditUsage {
  _CreditUsageImpl({
    int? id,
    required int subscriptionCredits,
    required int purchasedCredits,
    _i2.AccountApiUsage? accountApiUsage,
  }) : super._(
         id: id,
         subscriptionCredits: subscriptionCredits,
         purchasedCredits: purchasedCredits,
         accountApiUsage: accountApiUsage,
       );

  /// Returns a shallow copy of this [CreditUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CreditUsage copyWith({
    Object? id = _Undefined,
    int? subscriptionCredits,
    int? purchasedCredits,
    Object? accountApiUsage = _Undefined,
  }) {
    return CreditUsage(
      id: id is int? ? id : this.id,
      subscriptionCredits: subscriptionCredits ?? this.subscriptionCredits,
      purchasedCredits: purchasedCredits ?? this.purchasedCredits,
      accountApiUsage: accountApiUsage is _i2.AccountApiUsage?
          ? accountApiUsage
          : this.accountApiUsage?.copyWith(),
    );
  }
}

class CreditUsageUpdateTable extends _i1.UpdateTable<CreditUsageTable> {
  CreditUsageUpdateTable(super.table);

  _i1.ColumnValue<int, int> subscriptionCredits(int value) => _i1.ColumnValue(
    table.subscriptionCredits,
    value,
  );

  _i1.ColumnValue<int, int> purchasedCredits(int value) => _i1.ColumnValue(
    table.purchasedCredits,
    value,
  );
}

class CreditUsageTable extends _i1.Table<int?> {
  CreditUsageTable({super.tableRelation}) : super(tableName: 'credit_usage') {
    updateTable = CreditUsageUpdateTable(this);
    subscriptionCredits = _i1.ColumnInt(
      'subscriptionCredits',
      this,
    );
    purchasedCredits = _i1.ColumnInt(
      'purchasedCredits',
      this,
    );
  }

  late final CreditUsageUpdateTable updateTable;

  late final _i1.ColumnInt subscriptionCredits;

  late final _i1.ColumnInt purchasedCredits;

  _i2.AccountApiUsageTable? _accountApiUsage;

  _i2.AccountApiUsageTable get accountApiUsage {
    if (_accountApiUsage != null) return _accountApiUsage!;
    _accountApiUsage = _i1.createRelationTable(
      relationFieldName: 'accountApiUsage',
      field: CreditUsage.t.id,
      foreignField: _i2.AccountApiUsage.t.creditUsageId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AccountApiUsageTable(tableRelation: foreignTableRelation),
    );
    return _accountApiUsage!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    subscriptionCredits,
    purchasedCredits,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'accountApiUsage') {
      return accountApiUsage;
    }
    return null;
  }
}

class CreditUsageInclude extends _i1.IncludeObject {
  CreditUsageInclude._({_i2.AccountApiUsageInclude? accountApiUsage}) {
    _accountApiUsage = accountApiUsage;
  }

  _i2.AccountApiUsageInclude? _accountApiUsage;

  @override
  Map<String, _i1.Include?> get includes => {
    'accountApiUsage': _accountApiUsage,
  };

  @override
  _i1.Table<int?> get table => CreditUsage.t;
}

class CreditUsageIncludeList extends _i1.IncludeList {
  CreditUsageIncludeList._({
    _i1.WhereExpressionBuilder<CreditUsageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CreditUsage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CreditUsage.t;
}

class CreditUsageRepository {
  const CreditUsageRepository._();

  final attachRow = const CreditUsageAttachRowRepository._();

  /// Returns a list of [CreditUsage]s matching the given query parameters.
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
  Future<List<CreditUsage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreditUsageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreditUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreditUsageTable>? orderByList,
    _i1.Transaction? transaction,
    CreditUsageInclude? include,
  }) async {
    return session.db.find<CreditUsage>(
      where: where?.call(CreditUsage.t),
      orderBy: orderBy?.call(CreditUsage.t),
      orderByList: orderByList?.call(CreditUsage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [CreditUsage] matching the given query parameters.
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
  Future<CreditUsage?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreditUsageTable>? where,
    int? offset,
    _i1.OrderByBuilder<CreditUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreditUsageTable>? orderByList,
    _i1.Transaction? transaction,
    CreditUsageInclude? include,
  }) async {
    return session.db.findFirstRow<CreditUsage>(
      where: where?.call(CreditUsage.t),
      orderBy: orderBy?.call(CreditUsage.t),
      orderByList: orderByList?.call(CreditUsage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [CreditUsage] by its [id] or null if no such row exists.
  Future<CreditUsage?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CreditUsageInclude? include,
  }) async {
    return session.db.findById<CreditUsage>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [CreditUsage]s in the list and returns the inserted rows.
  ///
  /// The returned [CreditUsage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CreditUsage>> insert(
    _i1.Session session,
    List<CreditUsage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CreditUsage>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CreditUsage] and returns the inserted row.
  ///
  /// The returned [CreditUsage] will have its `id` field set.
  Future<CreditUsage> insertRow(
    _i1.Session session,
    CreditUsage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CreditUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CreditUsage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CreditUsage>> update(
    _i1.Session session,
    List<CreditUsage> rows, {
    _i1.ColumnSelections<CreditUsageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CreditUsage>(
      rows,
      columns: columns?.call(CreditUsage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CreditUsage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CreditUsage> updateRow(
    _i1.Session session,
    CreditUsage row, {
    _i1.ColumnSelections<CreditUsageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CreditUsage>(
      row,
      columns: columns?.call(CreditUsage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CreditUsage] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CreditUsage?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CreditUsageUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CreditUsage>(
      id,
      columnValues: columnValues(CreditUsage.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CreditUsage]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CreditUsage>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CreditUsageUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CreditUsageTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreditUsageTable>? orderBy,
    _i1.OrderByListBuilder<CreditUsageTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CreditUsage>(
      columnValues: columnValues(CreditUsage.t.updateTable),
      where: where(CreditUsage.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CreditUsage.t),
      orderByList: orderByList?.call(CreditUsage.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CreditUsage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CreditUsage>> delete(
    _i1.Session session,
    List<CreditUsage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CreditUsage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CreditUsage].
  Future<CreditUsage> deleteRow(
    _i1.Session session,
    CreditUsage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CreditUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CreditUsage>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CreditUsageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CreditUsage>(
      where: where(CreditUsage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreditUsageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CreditUsage>(
      where: where?.call(CreditUsage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CreditUsageAttachRowRepository {
  const CreditUsageAttachRowRepository._();

  /// Creates a relation between the given [CreditUsage] and [AccountApiUsage]
  /// by setting the [CreditUsage]'s foreign key `id` to refer to the [AccountApiUsage].
  Future<void> accountApiUsage(
    _i1.Session session,
    CreditUsage creditUsage,
    _i2.AccountApiUsage accountApiUsage, {
    _i1.Transaction? transaction,
  }) async {
    if (accountApiUsage.id == null) {
      throw ArgumentError.notNull('accountApiUsage.id');
    }
    if (creditUsage.id == null) {
      throw ArgumentError.notNull('creditUsage.id');
    }

    var $accountApiUsage = accountApiUsage.copyWith(
      creditUsageId: creditUsage.id,
    );
    await session.db.updateRow<_i2.AccountApiUsage>(
      $accountApiUsage,
      columns: [_i2.AccountApiUsage.t.creditUsageId],
      transaction: transaction,
    );
  }
}
