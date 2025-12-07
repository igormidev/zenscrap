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
import '../../../../entities/account/api_usage/api_credit_history/monthly_subscription_api_credit_deposit.dart'
    as _i2;
import '../../../../entities/account/api_usage/api_credit_history/api_credit_package_purchase.dart'
    as _i3;
import '../../../../entities/account/api_usage/account_api_usage.dart' as _i4;

abstract class ApiCreditHistoryItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ApiCreditHistoryItem._({
    this.id,
    required this.date,
    this.monthlySubscriptionApiCreditDepositId,
    this.monthlySubscriptionApiCreditDeposit,
    this.apiCreditPackagePurchaseId,
    this.apiCreditPackagePurchase,
    required this.accountApiUsageId,
    this.accountApiUsage,
  });

  factory ApiCreditHistoryItem({
    int? id,
    required DateTime date,
    int? monthlySubscriptionApiCreditDepositId,
    _i2.MonthlySubscriptionApiCreditDeposit?
        monthlySubscriptionApiCreditDeposit,
    int? apiCreditPackagePurchaseId,
    _i3.ApiCreditPackagePurchase? apiCreditPackagePurchase,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  }) = _ApiCreditHistoryItemImpl;

  factory ApiCreditHistoryItem.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ApiCreditHistoryItem(
      id: jsonSerialization['id'] as int?,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      monthlySubscriptionApiCreditDepositId:
          jsonSerialization['monthlySubscriptionApiCreditDepositId'] as int?,
      monthlySubscriptionApiCreditDeposit:
          jsonSerialization['monthlySubscriptionApiCreditDeposit'] == null
              ? null
              : _i2.MonthlySubscriptionApiCreditDeposit.fromJson(
                  (jsonSerialization['monthlySubscriptionApiCreditDeposit']
                      as Map<String, dynamic>)),
      apiCreditPackagePurchaseId:
          jsonSerialization['apiCreditPackagePurchaseId'] as int?,
      apiCreditPackagePurchase:
          jsonSerialization['apiCreditPackagePurchase'] == null
              ? null
              : _i3.ApiCreditPackagePurchase.fromJson(
                  (jsonSerialization['apiCreditPackagePurchase']
                      as Map<String, dynamic>)),
      accountApiUsageId: jsonSerialization['accountApiUsageId'] as int,
      accountApiUsage: jsonSerialization['accountApiUsage'] == null
          ? null
          : _i4.AccountApiUsage.fromJson(
              (jsonSerialization['accountApiUsage'] as Map<String, dynamic>)),
    );
  }

  static final t = ApiCreditHistoryItemTable();

  static const db = ApiCreditHistoryItemRepository._();

  @override
  int? id;

  DateTime date;

  int? monthlySubscriptionApiCreditDepositId;

  _i2.MonthlySubscriptionApiCreditDeposit? monthlySubscriptionApiCreditDeposit;

  int? apiCreditPackagePurchaseId;

  _i3.ApiCreditPackagePurchase? apiCreditPackagePurchase;

  int accountApiUsageId;

  _i4.AccountApiUsage? accountApiUsage;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ApiCreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ApiCreditHistoryItem copyWith({
    int? id,
    DateTime? date,
    int? monthlySubscriptionApiCreditDepositId,
    _i2.MonthlySubscriptionApiCreditDeposit?
        monthlySubscriptionApiCreditDeposit,
    int? apiCreditPackagePurchaseId,
    _i3.ApiCreditPackagePurchase? apiCreditPackagePurchase,
    int? accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date.toJson(),
      if (monthlySubscriptionApiCreditDepositId != null)
        'monthlySubscriptionApiCreditDepositId':
            monthlySubscriptionApiCreditDepositId,
      if (monthlySubscriptionApiCreditDeposit != null)
        'monthlySubscriptionApiCreditDeposit':
            monthlySubscriptionApiCreditDeposit?.toJson(),
      if (apiCreditPackagePurchaseId != null)
        'apiCreditPackagePurchaseId': apiCreditPackagePurchaseId,
      if (apiCreditPackagePurchase != null)
        'apiCreditPackagePurchase': apiCreditPackagePurchase?.toJson(),
      'accountApiUsageId': accountApiUsageId,
      if (accountApiUsage != null) 'accountApiUsage': accountApiUsage?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'date': date.toJson(),
      if (monthlySubscriptionApiCreditDepositId != null)
        'monthlySubscriptionApiCreditDepositId':
            monthlySubscriptionApiCreditDepositId,
      if (monthlySubscriptionApiCreditDeposit != null)
        'monthlySubscriptionApiCreditDeposit':
            monthlySubscriptionApiCreditDeposit?.toJsonForProtocol(),
      if (apiCreditPackagePurchaseId != null)
        'apiCreditPackagePurchaseId': apiCreditPackagePurchaseId,
      if (apiCreditPackagePurchase != null)
        'apiCreditPackagePurchase':
            apiCreditPackagePurchase?.toJsonForProtocol(),
      'accountApiUsageId': accountApiUsageId,
      if (accountApiUsage != null)
        'accountApiUsage': accountApiUsage?.toJsonForProtocol(),
    };
  }

  static ApiCreditHistoryItemInclude include({
    _i2.MonthlySubscriptionApiCreditDepositInclude?
        monthlySubscriptionApiCreditDeposit,
    _i3.ApiCreditPackagePurchaseInclude? apiCreditPackagePurchase,
    _i4.AccountApiUsageInclude? accountApiUsage,
  }) {
    return ApiCreditHistoryItemInclude._(
      monthlySubscriptionApiCreditDeposit: monthlySubscriptionApiCreditDeposit,
      apiCreditPackagePurchase: apiCreditPackagePurchase,
      accountApiUsage: accountApiUsage,
    );
  }

  static ApiCreditHistoryItemIncludeList includeList({
    _i1.WhereExpressionBuilder<ApiCreditHistoryItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ApiCreditHistoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiCreditHistoryItemTable>? orderByList,
    ApiCreditHistoryItemInclude? include,
  }) {
    return ApiCreditHistoryItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ApiCreditHistoryItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ApiCreditHistoryItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiCreditHistoryItemImpl extends ApiCreditHistoryItem {
  _ApiCreditHistoryItemImpl({
    int? id,
    required DateTime date,
    int? monthlySubscriptionApiCreditDepositId,
    _i2.MonthlySubscriptionApiCreditDeposit?
        monthlySubscriptionApiCreditDeposit,
    int? apiCreditPackagePurchaseId,
    _i3.ApiCreditPackagePurchase? apiCreditPackagePurchase,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  }) : super._(
          id: id,
          date: date,
          monthlySubscriptionApiCreditDepositId:
              monthlySubscriptionApiCreditDepositId,
          monthlySubscriptionApiCreditDeposit:
              monthlySubscriptionApiCreditDeposit,
          apiCreditPackagePurchaseId: apiCreditPackagePurchaseId,
          apiCreditPackagePurchase: apiCreditPackagePurchase,
          accountApiUsageId: accountApiUsageId,
          accountApiUsage: accountApiUsage,
        );

  /// Returns a shallow copy of this [ApiCreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ApiCreditHistoryItem copyWith({
    Object? id = _Undefined,
    DateTime? date,
    Object? monthlySubscriptionApiCreditDepositId = _Undefined,
    Object? monthlySubscriptionApiCreditDeposit = _Undefined,
    Object? apiCreditPackagePurchaseId = _Undefined,
    Object? apiCreditPackagePurchase = _Undefined,
    int? accountApiUsageId,
    Object? accountApiUsage = _Undefined,
  }) {
    return ApiCreditHistoryItem(
      id: id is int? ? id : this.id,
      date: date ?? this.date,
      monthlySubscriptionApiCreditDepositId:
          monthlySubscriptionApiCreditDepositId is int?
              ? monthlySubscriptionApiCreditDepositId
              : this.monthlySubscriptionApiCreditDepositId,
      monthlySubscriptionApiCreditDeposit: monthlySubscriptionApiCreditDeposit
              is _i2.MonthlySubscriptionApiCreditDeposit?
          ? monthlySubscriptionApiCreditDeposit
          : this.monthlySubscriptionApiCreditDeposit?.copyWith(),
      apiCreditPackagePurchaseId: apiCreditPackagePurchaseId is int?
          ? apiCreditPackagePurchaseId
          : this.apiCreditPackagePurchaseId,
      apiCreditPackagePurchase:
          apiCreditPackagePurchase is _i3.ApiCreditPackagePurchase?
              ? apiCreditPackagePurchase
              : this.apiCreditPackagePurchase?.copyWith(),
      accountApiUsageId: accountApiUsageId ?? this.accountApiUsageId,
      accountApiUsage: accountApiUsage is _i4.AccountApiUsage?
          ? accountApiUsage
          : this.accountApiUsage?.copyWith(),
    );
  }
}

class ApiCreditHistoryItemTable extends _i1.Table<int?> {
  ApiCreditHistoryItemTable({super.tableRelation})
      : super(tableName: 'api_credit_history_item') {
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    monthlySubscriptionApiCreditDepositId = _i1.ColumnInt(
      'monthlySubscriptionApiCreditDepositId',
      this,
    );
    apiCreditPackagePurchaseId = _i1.ColumnInt(
      'apiCreditPackagePurchaseId',
      this,
    );
    accountApiUsageId = _i1.ColumnInt(
      'accountApiUsageId',
      this,
    );
  }

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnInt monthlySubscriptionApiCreditDepositId;

  _i2.MonthlySubscriptionApiCreditDepositTable?
      _monthlySubscriptionApiCreditDeposit;

  late final _i1.ColumnInt apiCreditPackagePurchaseId;

  _i3.ApiCreditPackagePurchaseTable? _apiCreditPackagePurchase;

  late final _i1.ColumnInt accountApiUsageId;

  _i4.AccountApiUsageTable? _accountApiUsage;

  _i2.MonthlySubscriptionApiCreditDepositTable
      get monthlySubscriptionApiCreditDeposit {
    if (_monthlySubscriptionApiCreditDeposit != null)
      return _monthlySubscriptionApiCreditDeposit!;
    _monthlySubscriptionApiCreditDeposit = _i1.createRelationTable(
      relationFieldName: 'monthlySubscriptionApiCreditDeposit',
      field: ApiCreditHistoryItem.t.monthlySubscriptionApiCreditDepositId,
      foreignField: _i2.MonthlySubscriptionApiCreditDeposit.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MonthlySubscriptionApiCreditDepositTable(
              tableRelation: foreignTableRelation),
    );
    return _monthlySubscriptionApiCreditDeposit!;
  }

  _i3.ApiCreditPackagePurchaseTable get apiCreditPackagePurchase {
    if (_apiCreditPackagePurchase != null) return _apiCreditPackagePurchase!;
    _apiCreditPackagePurchase = _i1.createRelationTable(
      relationFieldName: 'apiCreditPackagePurchase',
      field: ApiCreditHistoryItem.t.apiCreditPackagePurchaseId,
      foreignField: _i3.ApiCreditPackagePurchase.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i3.ApiCreditPackagePurchaseTable(
          tableRelation: foreignTableRelation),
    );
    return _apiCreditPackagePurchase!;
  }

  _i4.AccountApiUsageTable get accountApiUsage {
    if (_accountApiUsage != null) return _accountApiUsage!;
    _accountApiUsage = _i1.createRelationTable(
      relationFieldName: 'accountApiUsage',
      field: ApiCreditHistoryItem.t.accountApiUsageId,
      foreignField: _i4.AccountApiUsage.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.AccountApiUsageTable(tableRelation: foreignTableRelation),
    );
    return _accountApiUsage!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        date,
        monthlySubscriptionApiCreditDepositId,
        apiCreditPackagePurchaseId,
        accountApiUsageId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'monthlySubscriptionApiCreditDeposit') {
      return monthlySubscriptionApiCreditDeposit;
    }
    if (relationField == 'apiCreditPackagePurchase') {
      return apiCreditPackagePurchase;
    }
    if (relationField == 'accountApiUsage') {
      return accountApiUsage;
    }
    return null;
  }
}

class ApiCreditHistoryItemInclude extends _i1.IncludeObject {
  ApiCreditHistoryItemInclude._({
    _i2.MonthlySubscriptionApiCreditDepositInclude?
        monthlySubscriptionApiCreditDeposit,
    _i3.ApiCreditPackagePurchaseInclude? apiCreditPackagePurchase,
    _i4.AccountApiUsageInclude? accountApiUsage,
  }) {
    _monthlySubscriptionApiCreditDeposit = monthlySubscriptionApiCreditDeposit;
    _apiCreditPackagePurchase = apiCreditPackagePurchase;
    _accountApiUsage = accountApiUsage;
  }

  _i2.MonthlySubscriptionApiCreditDepositInclude?
      _monthlySubscriptionApiCreditDeposit;

  _i3.ApiCreditPackagePurchaseInclude? _apiCreditPackagePurchase;

  _i4.AccountApiUsageInclude? _accountApiUsage;

  @override
  Map<String, _i1.Include?> get includes => {
        'monthlySubscriptionApiCreditDeposit':
            _monthlySubscriptionApiCreditDeposit,
        'apiCreditPackagePurchase': _apiCreditPackagePurchase,
        'accountApiUsage': _accountApiUsage,
      };

  @override
  _i1.Table<int?> get table => ApiCreditHistoryItem.t;
}

class ApiCreditHistoryItemIncludeList extends _i1.IncludeList {
  ApiCreditHistoryItemIncludeList._({
    _i1.WhereExpressionBuilder<ApiCreditHistoryItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ApiCreditHistoryItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ApiCreditHistoryItem.t;
}

class ApiCreditHistoryItemRepository {
  const ApiCreditHistoryItemRepository._();

  final attachRow = const ApiCreditHistoryItemAttachRowRepository._();

  final detachRow = const ApiCreditHistoryItemDetachRowRepository._();

  /// Returns a list of [ApiCreditHistoryItem]s matching the given query parameters.
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
  Future<List<ApiCreditHistoryItem>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiCreditHistoryItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ApiCreditHistoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiCreditHistoryItemTable>? orderByList,
    _i1.Transaction? transaction,
    ApiCreditHistoryItemInclude? include,
  }) async {
    return session.db.find<ApiCreditHistoryItem>(
      where: where?.call(ApiCreditHistoryItem.t),
      orderBy: orderBy?.call(ApiCreditHistoryItem.t),
      orderByList: orderByList?.call(ApiCreditHistoryItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [ApiCreditHistoryItem] matching the given query parameters.
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
  Future<ApiCreditHistoryItem?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiCreditHistoryItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<ApiCreditHistoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ApiCreditHistoryItemTable>? orderByList,
    _i1.Transaction? transaction,
    ApiCreditHistoryItemInclude? include,
  }) async {
    return session.db.findFirstRow<ApiCreditHistoryItem>(
      where: where?.call(ApiCreditHistoryItem.t),
      orderBy: orderBy?.call(ApiCreditHistoryItem.t),
      orderByList: orderByList?.call(ApiCreditHistoryItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [ApiCreditHistoryItem] by its [id] or null if no such row exists.
  Future<ApiCreditHistoryItem?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    ApiCreditHistoryItemInclude? include,
  }) async {
    return session.db.findById<ApiCreditHistoryItem>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [ApiCreditHistoryItem]s in the list and returns the inserted rows.
  ///
  /// The returned [ApiCreditHistoryItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ApiCreditHistoryItem>> insert(
    _i1.Session session,
    List<ApiCreditHistoryItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ApiCreditHistoryItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ApiCreditHistoryItem] and returns the inserted row.
  ///
  /// The returned [ApiCreditHistoryItem] will have its `id` field set.
  Future<ApiCreditHistoryItem> insertRow(
    _i1.Session session,
    ApiCreditHistoryItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ApiCreditHistoryItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ApiCreditHistoryItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ApiCreditHistoryItem>> update(
    _i1.Session session,
    List<ApiCreditHistoryItem> rows, {
    _i1.ColumnSelections<ApiCreditHistoryItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ApiCreditHistoryItem>(
      rows,
      columns: columns?.call(ApiCreditHistoryItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ApiCreditHistoryItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ApiCreditHistoryItem> updateRow(
    _i1.Session session,
    ApiCreditHistoryItem row, {
    _i1.ColumnSelections<ApiCreditHistoryItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ApiCreditHistoryItem>(
      row,
      columns: columns?.call(ApiCreditHistoryItem.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ApiCreditHistoryItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ApiCreditHistoryItem>> delete(
    _i1.Session session,
    List<ApiCreditHistoryItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ApiCreditHistoryItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ApiCreditHistoryItem].
  Future<ApiCreditHistoryItem> deleteRow(
    _i1.Session session,
    ApiCreditHistoryItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ApiCreditHistoryItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ApiCreditHistoryItem>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ApiCreditHistoryItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ApiCreditHistoryItem>(
      where: where(ApiCreditHistoryItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ApiCreditHistoryItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ApiCreditHistoryItem>(
      where: where?.call(ApiCreditHistoryItem.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class ApiCreditHistoryItemAttachRowRepository {
  const ApiCreditHistoryItemAttachRowRepository._();

  /// Creates a relation between the given [ApiCreditHistoryItem] and [MonthlySubscriptionApiCreditDeposit]
  /// by setting the [ApiCreditHistoryItem]'s foreign key `monthlySubscriptionApiCreditDepositId` to refer to the [MonthlySubscriptionApiCreditDeposit].
  Future<void> monthlySubscriptionApiCreditDeposit(
    _i1.Session session,
    ApiCreditHistoryItem apiCreditHistoryItem,
    _i2.MonthlySubscriptionApiCreditDeposit
        monthlySubscriptionApiCreditDeposit, {
    _i1.Transaction? transaction,
  }) async {
    if (apiCreditHistoryItem.id == null) {
      throw ArgumentError.notNull('apiCreditHistoryItem.id');
    }
    if (monthlySubscriptionApiCreditDeposit.id == null) {
      throw ArgumentError.notNull('monthlySubscriptionApiCreditDeposit.id');
    }

    var $apiCreditHistoryItem = apiCreditHistoryItem.copyWith(
        monthlySubscriptionApiCreditDepositId:
            monthlySubscriptionApiCreditDeposit.id);
    await session.db.updateRow<ApiCreditHistoryItem>(
      $apiCreditHistoryItem,
      columns: [ApiCreditHistoryItem.t.monthlySubscriptionApiCreditDepositId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ApiCreditHistoryItem] and [ApiCreditPackagePurchase]
  /// by setting the [ApiCreditHistoryItem]'s foreign key `apiCreditPackagePurchaseId` to refer to the [ApiCreditPackagePurchase].
  Future<void> apiCreditPackagePurchase(
    _i1.Session session,
    ApiCreditHistoryItem apiCreditHistoryItem,
    _i3.ApiCreditPackagePurchase apiCreditPackagePurchase, {
    _i1.Transaction? transaction,
  }) async {
    if (apiCreditHistoryItem.id == null) {
      throw ArgumentError.notNull('apiCreditHistoryItem.id');
    }
    if (apiCreditPackagePurchase.id == null) {
      throw ArgumentError.notNull('apiCreditPackagePurchase.id');
    }

    var $apiCreditHistoryItem = apiCreditHistoryItem.copyWith(
        apiCreditPackagePurchaseId: apiCreditPackagePurchase.id);
    await session.db.updateRow<ApiCreditHistoryItem>(
      $apiCreditHistoryItem,
      columns: [ApiCreditHistoryItem.t.apiCreditPackagePurchaseId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [ApiCreditHistoryItem] and [AccountApiUsage]
  /// by setting the [ApiCreditHistoryItem]'s foreign key `accountApiUsageId` to refer to the [AccountApiUsage].
  Future<void> accountApiUsage(
    _i1.Session session,
    ApiCreditHistoryItem apiCreditHistoryItem,
    _i4.AccountApiUsage accountApiUsage, {
    _i1.Transaction? transaction,
  }) async {
    if (apiCreditHistoryItem.id == null) {
      throw ArgumentError.notNull('apiCreditHistoryItem.id');
    }
    if (accountApiUsage.id == null) {
      throw ArgumentError.notNull('accountApiUsage.id');
    }

    var $apiCreditHistoryItem =
        apiCreditHistoryItem.copyWith(accountApiUsageId: accountApiUsage.id);
    await session.db.updateRow<ApiCreditHistoryItem>(
      $apiCreditHistoryItem,
      columns: [ApiCreditHistoryItem.t.accountApiUsageId],
      transaction: transaction,
    );
  }
}

class ApiCreditHistoryItemDetachRowRepository {
  const ApiCreditHistoryItemDetachRowRepository._();

  /// Detaches the relation between this [ApiCreditHistoryItem] and the [MonthlySubscriptionApiCreditDeposit] set in `monthlySubscriptionApiCreditDeposit`
  /// by setting the [ApiCreditHistoryItem]'s foreign key `monthlySubscriptionApiCreditDepositId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> monthlySubscriptionApiCreditDeposit(
    _i1.Session session,
    ApiCreditHistoryItem apicredithistoryitem, {
    _i1.Transaction? transaction,
  }) async {
    if (apicredithistoryitem.id == null) {
      throw ArgumentError.notNull('apicredithistoryitem.id');
    }

    var $apicredithistoryitem = apicredithistoryitem.copyWith(
        monthlySubscriptionApiCreditDepositId: null);
    await session.db.updateRow<ApiCreditHistoryItem>(
      $apicredithistoryitem,
      columns: [ApiCreditHistoryItem.t.monthlySubscriptionApiCreditDepositId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [ApiCreditHistoryItem] and the [ApiCreditPackagePurchase] set in `apiCreditPackagePurchase`
  /// by setting the [ApiCreditHistoryItem]'s foreign key `apiCreditPackagePurchaseId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> apiCreditPackagePurchase(
    _i1.Session session,
    ApiCreditHistoryItem apicredithistoryitem, {
    _i1.Transaction? transaction,
  }) async {
    if (apicredithistoryitem.id == null) {
      throw ArgumentError.notNull('apicredithistoryitem.id');
    }

    var $apicredithistoryitem =
        apicredithistoryitem.copyWith(apiCreditPackagePurchaseId: null);
    await session.db.updateRow<ApiCreditHistoryItem>(
      $apicredithistoryitem,
      columns: [ApiCreditHistoryItem.t.apiCreditPackagePurchaseId],
      transaction: transaction,
    );
  }
}
