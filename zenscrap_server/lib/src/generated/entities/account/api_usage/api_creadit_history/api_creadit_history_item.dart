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
import '../../../../entities/account/api_usage/api_creadit_history/monthly_subscription_credit_deposit.dart'
    as _i2;
import '../../../../entities/account/api_usage/api_creadit_history/credit_package_purchase.dart'
    as _i3;
import '../../../../entities/account/api_usage/account_api_usage.dart' as _i4;

abstract class CreditHistoryItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CreditHistoryItem._({
    this.id,
    required this.date,
    this.monthlySubscriptionCreditDepositId,
    this.monthlySubscriptionCreditDeposit,
    this.creaditPackagePurchaseId,
    this.creaditPackagePurchase,
    required this.accountApiUsageId,
    this.accountApiUsage,
  });

  factory CreditHistoryItem({
    int? id,
    required DateTime date,
    int? monthlySubscriptionCreditDepositId,
    _i2.MonthlySubscriptionCreditDeposit? monthlySubscriptionCreditDeposit,
    int? creaditPackagePurchaseId,
    _i3.CreditPackagePurchase? creaditPackagePurchase,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  }) = _CreditHistoryItemImpl;

  factory CreditHistoryItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CreditHistoryItem(
      id: jsonSerialization['id'] as int?,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      monthlySubscriptionCreditDepositId:
          jsonSerialization['monthlySubscriptionCreditDepositId'] as int?,
      monthlySubscriptionCreditDeposit:
          jsonSerialization['monthlySubscriptionCreditDeposit'] == null
              ? null
              : _i2.MonthlySubscriptionCreditDeposit.fromJson(
                  (jsonSerialization['monthlySubscriptionCreditDeposit']
                      as Map<String, dynamic>)),
      creaditPackagePurchaseId:
          jsonSerialization['creaditPackagePurchaseId'] as int?,
      creaditPackagePurchase:
          jsonSerialization['creaditPackagePurchase'] == null
              ? null
              : _i3.CreditPackagePurchase.fromJson(
                  (jsonSerialization['creaditPackagePurchase']
                      as Map<String, dynamic>)),
      accountApiUsageId: jsonSerialization['accountApiUsageId'] as int,
      accountApiUsage: jsonSerialization['accountApiUsage'] == null
          ? null
          : _i4.AccountApiUsage.fromJson(
              (jsonSerialization['accountApiUsage'] as Map<String, dynamic>)),
    );
  }

  static final t = CreditHistoryItemTable();

  static const db = CreditHistoryItemRepository._();

  @override
  int? id;

  DateTime date;

  int? monthlySubscriptionCreditDepositId;

  _i2.MonthlySubscriptionCreditDeposit? monthlySubscriptionCreditDeposit;

  int? creaditPackagePurchaseId;

  _i3.CreditPackagePurchase? creaditPackagePurchase;

  int accountApiUsageId;

  _i4.AccountApiUsage? accountApiUsage;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CreditHistoryItem copyWith({
    int? id,
    DateTime? date,
    int? monthlySubscriptionCreditDepositId,
    _i2.MonthlySubscriptionCreditDeposit? monthlySubscriptionCreditDeposit,
    int? creaditPackagePurchaseId,
    _i3.CreditPackagePurchase? creaditPackagePurchase,
    int? accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date.toJson(),
      if (monthlySubscriptionCreditDepositId != null)
        'monthlySubscriptionCreditDepositId':
            monthlySubscriptionCreditDepositId,
      if (monthlySubscriptionCreditDeposit != null)
        'monthlySubscriptionCreditDeposit':
            monthlySubscriptionCreditDeposit?.toJson(),
      if (creaditPackagePurchaseId != null)
        'creaditPackagePurchaseId': creaditPackagePurchaseId,
      if (creaditPackagePurchase != null)
        'creaditPackagePurchase': creaditPackagePurchase?.toJson(),
      'accountApiUsageId': accountApiUsageId,
      if (accountApiUsage != null) 'accountApiUsage': accountApiUsage?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'date': date.toJson(),
      if (monthlySubscriptionCreditDepositId != null)
        'monthlySubscriptionCreditDepositId':
            monthlySubscriptionCreditDepositId,
      if (monthlySubscriptionCreditDeposit != null)
        'monthlySubscriptionCreditDeposit':
            monthlySubscriptionCreditDeposit?.toJsonForProtocol(),
      if (creaditPackagePurchaseId != null)
        'creaditPackagePurchaseId': creaditPackagePurchaseId,
      if (creaditPackagePurchase != null)
        'creaditPackagePurchase': creaditPackagePurchase?.toJsonForProtocol(),
      'accountApiUsageId': accountApiUsageId,
      if (accountApiUsage != null)
        'accountApiUsage': accountApiUsage?.toJsonForProtocol(),
    };
  }

  static CreditHistoryItemInclude include({
    _i2.MonthlySubscriptionCreditDepositInclude?
        monthlySubscriptionCreditDeposit,
    _i3.CreditPackagePurchaseInclude? creaditPackagePurchase,
    _i4.AccountApiUsageInclude? accountApiUsage,
  }) {
    return CreditHistoryItemInclude._(
      monthlySubscriptionCreditDeposit: monthlySubscriptionCreditDeposit,
      creaditPackagePurchase: creaditPackagePurchase,
      accountApiUsage: accountApiUsage,
    );
  }

  static CreditHistoryItemIncludeList includeList({
    _i1.WhereExpressionBuilder<CreditHistoryItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreditHistoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreditHistoryItemTable>? orderByList,
    CreditHistoryItemInclude? include,
  }) {
    return CreditHistoryItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CreditHistoryItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CreditHistoryItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CreditHistoryItemImpl extends CreditHistoryItem {
  _CreditHistoryItemImpl({
    int? id,
    required DateTime date,
    int? monthlySubscriptionCreditDepositId,
    _i2.MonthlySubscriptionCreditDeposit? monthlySubscriptionCreditDeposit,
    int? creaditPackagePurchaseId,
    _i3.CreditPackagePurchase? creaditPackagePurchase,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
  }) : super._(
          id: id,
          date: date,
          monthlySubscriptionCreditDepositId:
              monthlySubscriptionCreditDepositId,
          monthlySubscriptionCreditDeposit: monthlySubscriptionCreditDeposit,
          creaditPackagePurchaseId: creaditPackagePurchaseId,
          creaditPackagePurchase: creaditPackagePurchase,
          accountApiUsageId: accountApiUsageId,
          accountApiUsage: accountApiUsage,
        );

  /// Returns a shallow copy of this [CreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CreditHistoryItem copyWith({
    Object? id = _Undefined,
    DateTime? date,
    Object? monthlySubscriptionCreditDepositId = _Undefined,
    Object? monthlySubscriptionCreditDeposit = _Undefined,
    Object? creaditPackagePurchaseId = _Undefined,
    Object? creaditPackagePurchase = _Undefined,
    int? accountApiUsageId,
    Object? accountApiUsage = _Undefined,
  }) {
    return CreditHistoryItem(
      id: id is int? ? id : this.id,
      date: date ?? this.date,
      monthlySubscriptionCreditDepositId:
          monthlySubscriptionCreditDepositId is int?
              ? monthlySubscriptionCreditDepositId
              : this.monthlySubscriptionCreditDepositId,
      monthlySubscriptionCreditDeposit: monthlySubscriptionCreditDeposit
              is _i2.MonthlySubscriptionCreditDeposit?
          ? monthlySubscriptionCreditDeposit
          : this.monthlySubscriptionCreditDeposit?.copyWith(),
      creaditPackagePurchaseId: creaditPackagePurchaseId is int?
          ? creaditPackagePurchaseId
          : this.creaditPackagePurchaseId,
      creaditPackagePurchase:
          creaditPackagePurchase is _i3.CreditPackagePurchase?
              ? creaditPackagePurchase
              : this.creaditPackagePurchase?.copyWith(),
      accountApiUsageId: accountApiUsageId ?? this.accountApiUsageId,
      accountApiUsage: accountApiUsage is _i4.AccountApiUsage?
          ? accountApiUsage
          : this.accountApiUsage?.copyWith(),
    );
  }
}

class CreditHistoryItemTable extends _i1.Table<int?> {
  CreditHistoryItemTable({super.tableRelation})
      : super(tableName: 'credit_history_item') {
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    monthlySubscriptionCreditDepositId = _i1.ColumnInt(
      'monthlySubscriptionCreditDepositId',
      this,
    );
    creaditPackagePurchaseId = _i1.ColumnInt(
      'creaditPackagePurchaseId',
      this,
    );
    accountApiUsageId = _i1.ColumnInt(
      'accountApiUsageId',
      this,
    );
  }

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnInt monthlySubscriptionCreditDepositId;

  _i2.MonthlySubscriptionCreditDepositTable? _monthlySubscriptionCreditDeposit;

  late final _i1.ColumnInt creaditPackagePurchaseId;

  _i3.CreditPackagePurchaseTable? _creaditPackagePurchase;

  late final _i1.ColumnInt accountApiUsageId;

  _i4.AccountApiUsageTable? _accountApiUsage;

  _i2.MonthlySubscriptionCreditDepositTable
      get monthlySubscriptionCreditDeposit {
    if (_monthlySubscriptionCreditDeposit != null)
      return _monthlySubscriptionCreditDeposit!;
    _monthlySubscriptionCreditDeposit = _i1.createRelationTable(
      relationFieldName: 'monthlySubscriptionCreditDeposit',
      field: CreditHistoryItem.t.monthlySubscriptionCreditDepositId,
      foreignField: _i2.MonthlySubscriptionCreditDeposit.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MonthlySubscriptionCreditDepositTable(
              tableRelation: foreignTableRelation),
    );
    return _monthlySubscriptionCreditDeposit!;
  }

  _i3.CreditPackagePurchaseTable get creaditPackagePurchase {
    if (_creaditPackagePurchase != null) return _creaditPackagePurchase!;
    _creaditPackagePurchase = _i1.createRelationTable(
      relationFieldName: 'creaditPackagePurchase',
      field: CreditHistoryItem.t.creaditPackagePurchaseId,
      foreignField: _i3.CreditPackagePurchase.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.CreditPackagePurchaseTable(tableRelation: foreignTableRelation),
    );
    return _creaditPackagePurchase!;
  }

  _i4.AccountApiUsageTable get accountApiUsage {
    if (_accountApiUsage != null) return _accountApiUsage!;
    _accountApiUsage = _i1.createRelationTable(
      relationFieldName: 'accountApiUsage',
      field: CreditHistoryItem.t.accountApiUsageId,
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
        monthlySubscriptionCreditDepositId,
        creaditPackagePurchaseId,
        accountApiUsageId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'monthlySubscriptionCreditDeposit') {
      return monthlySubscriptionCreditDeposit;
    }
    if (relationField == 'creaditPackagePurchase') {
      return creaditPackagePurchase;
    }
    if (relationField == 'accountApiUsage') {
      return accountApiUsage;
    }
    return null;
  }
}

class CreditHistoryItemInclude extends _i1.IncludeObject {
  CreditHistoryItemInclude._({
    _i2.MonthlySubscriptionCreditDepositInclude?
        monthlySubscriptionCreditDeposit,
    _i3.CreditPackagePurchaseInclude? creaditPackagePurchase,
    _i4.AccountApiUsageInclude? accountApiUsage,
  }) {
    _monthlySubscriptionCreditDeposit = monthlySubscriptionCreditDeposit;
    _creaditPackagePurchase = creaditPackagePurchase;
    _accountApiUsage = accountApiUsage;
  }

  _i2.MonthlySubscriptionCreditDepositInclude?
      _monthlySubscriptionCreditDeposit;

  _i3.CreditPackagePurchaseInclude? _creaditPackagePurchase;

  _i4.AccountApiUsageInclude? _accountApiUsage;

  @override
  Map<String, _i1.Include?> get includes => {
        'monthlySubscriptionCreditDeposit': _monthlySubscriptionCreditDeposit,
        'creaditPackagePurchase': _creaditPackagePurchase,
        'accountApiUsage': _accountApiUsage,
      };

  @override
  _i1.Table<int?> get table => CreditHistoryItem.t;
}

class CreditHistoryItemIncludeList extends _i1.IncludeList {
  CreditHistoryItemIncludeList._({
    _i1.WhereExpressionBuilder<CreditHistoryItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CreditHistoryItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CreditHistoryItem.t;
}

class CreditHistoryItemRepository {
  const CreditHistoryItemRepository._();

  final attachRow = const CreditHistoryItemAttachRowRepository._();

  final detachRow = const CreditHistoryItemDetachRowRepository._();

  /// Returns a list of [CreditHistoryItem]s matching the given query parameters.
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
  Future<List<CreditHistoryItem>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreditHistoryItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CreditHistoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreditHistoryItemTable>? orderByList,
    _i1.Transaction? transaction,
    CreditHistoryItemInclude? include,
  }) async {
    return session.db.find<CreditHistoryItem>(
      where: where?.call(CreditHistoryItem.t),
      orderBy: orderBy?.call(CreditHistoryItem.t),
      orderByList: orderByList?.call(CreditHistoryItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [CreditHistoryItem] matching the given query parameters.
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
  Future<CreditHistoryItem?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreditHistoryItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<CreditHistoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CreditHistoryItemTable>? orderByList,
    _i1.Transaction? transaction,
    CreditHistoryItemInclude? include,
  }) async {
    return session.db.findFirstRow<CreditHistoryItem>(
      where: where?.call(CreditHistoryItem.t),
      orderBy: orderBy?.call(CreditHistoryItem.t),
      orderByList: orderByList?.call(CreditHistoryItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [CreditHistoryItem] by its [id] or null if no such row exists.
  Future<CreditHistoryItem?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CreditHistoryItemInclude? include,
  }) async {
    return session.db.findById<CreditHistoryItem>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [CreditHistoryItem]s in the list and returns the inserted rows.
  ///
  /// The returned [CreditHistoryItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CreditHistoryItem>> insert(
    _i1.Session session,
    List<CreditHistoryItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CreditHistoryItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CreditHistoryItem] and returns the inserted row.
  ///
  /// The returned [CreditHistoryItem] will have its `id` field set.
  Future<CreditHistoryItem> insertRow(
    _i1.Session session,
    CreditHistoryItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CreditHistoryItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CreditHistoryItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CreditHistoryItem>> update(
    _i1.Session session,
    List<CreditHistoryItem> rows, {
    _i1.ColumnSelections<CreditHistoryItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CreditHistoryItem>(
      rows,
      columns: columns?.call(CreditHistoryItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CreditHistoryItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CreditHistoryItem> updateRow(
    _i1.Session session,
    CreditHistoryItem row, {
    _i1.ColumnSelections<CreditHistoryItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CreditHistoryItem>(
      row,
      columns: columns?.call(CreditHistoryItem.t),
      transaction: transaction,
    );
  }

  /// Deletes all [CreditHistoryItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CreditHistoryItem>> delete(
    _i1.Session session,
    List<CreditHistoryItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CreditHistoryItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CreditHistoryItem].
  Future<CreditHistoryItem> deleteRow(
    _i1.Session session,
    CreditHistoryItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CreditHistoryItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CreditHistoryItem>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CreditHistoryItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CreditHistoryItem>(
      where: where(CreditHistoryItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CreditHistoryItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CreditHistoryItem>(
      where: where?.call(CreditHistoryItem.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CreditHistoryItemAttachRowRepository {
  const CreditHistoryItemAttachRowRepository._();

  /// Creates a relation between the given [CreditHistoryItem] and [MonthlySubscriptionCreditDeposit]
  /// by setting the [CreditHistoryItem]'s foreign key `monthlySubscriptionCreditDepositId` to refer to the [MonthlySubscriptionCreditDeposit].
  Future<void> monthlySubscriptionCreditDeposit(
    _i1.Session session,
    CreditHistoryItem creditHistoryItem,
    _i2.MonthlySubscriptionCreditDeposit monthlySubscriptionCreditDeposit, {
    _i1.Transaction? transaction,
  }) async {
    if (creditHistoryItem.id == null) {
      throw ArgumentError.notNull('creditHistoryItem.id');
    }
    if (monthlySubscriptionCreditDeposit.id == null) {
      throw ArgumentError.notNull('monthlySubscriptionCreditDeposit.id');
    }

    var $creditHistoryItem = creditHistoryItem.copyWith(
        monthlySubscriptionCreditDepositId:
            monthlySubscriptionCreditDeposit.id);
    await session.db.updateRow<CreditHistoryItem>(
      $creditHistoryItem,
      columns: [CreditHistoryItem.t.monthlySubscriptionCreditDepositId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [CreditHistoryItem] and [CreditPackagePurchase]
  /// by setting the [CreditHistoryItem]'s foreign key `creaditPackagePurchaseId` to refer to the [CreditPackagePurchase].
  Future<void> creaditPackagePurchase(
    _i1.Session session,
    CreditHistoryItem creditHistoryItem,
    _i3.CreditPackagePurchase creaditPackagePurchase, {
    _i1.Transaction? transaction,
  }) async {
    if (creditHistoryItem.id == null) {
      throw ArgumentError.notNull('creditHistoryItem.id');
    }
    if (creaditPackagePurchase.id == null) {
      throw ArgumentError.notNull('creaditPackagePurchase.id');
    }

    var $creditHistoryItem = creditHistoryItem.copyWith(
        creaditPackagePurchaseId: creaditPackagePurchase.id);
    await session.db.updateRow<CreditHistoryItem>(
      $creditHistoryItem,
      columns: [CreditHistoryItem.t.creaditPackagePurchaseId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [CreditHistoryItem] and [AccountApiUsage]
  /// by setting the [CreditHistoryItem]'s foreign key `accountApiUsageId` to refer to the [AccountApiUsage].
  Future<void> accountApiUsage(
    _i1.Session session,
    CreditHistoryItem creditHistoryItem,
    _i4.AccountApiUsage accountApiUsage, {
    _i1.Transaction? transaction,
  }) async {
    if (creditHistoryItem.id == null) {
      throw ArgumentError.notNull('creditHistoryItem.id');
    }
    if (accountApiUsage.id == null) {
      throw ArgumentError.notNull('accountApiUsage.id');
    }

    var $creditHistoryItem =
        creditHistoryItem.copyWith(accountApiUsageId: accountApiUsage.id);
    await session.db.updateRow<CreditHistoryItem>(
      $creditHistoryItem,
      columns: [CreditHistoryItem.t.accountApiUsageId],
      transaction: transaction,
    );
  }
}

class CreditHistoryItemDetachRowRepository {
  const CreditHistoryItemDetachRowRepository._();

  /// Detaches the relation between this [CreditHistoryItem] and the [MonthlySubscriptionCreditDeposit] set in `monthlySubscriptionCreditDeposit`
  /// by setting the [CreditHistoryItem]'s foreign key `monthlySubscriptionCreditDepositId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> monthlySubscriptionCreditDeposit(
    _i1.Session session,
    CreditHistoryItem credithistoryitem, {
    _i1.Transaction? transaction,
  }) async {
    if (credithistoryitem.id == null) {
      throw ArgumentError.notNull('credithistoryitem.id');
    }

    var $credithistoryitem =
        credithistoryitem.copyWith(monthlySubscriptionCreditDepositId: null);
    await session.db.updateRow<CreditHistoryItem>(
      $credithistoryitem,
      columns: [CreditHistoryItem.t.monthlySubscriptionCreditDepositId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [CreditHistoryItem] and the [CreditPackagePurchase] set in `creaditPackagePurchase`
  /// by setting the [CreditHistoryItem]'s foreign key `creaditPackagePurchaseId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> creaditPackagePurchase(
    _i1.Session session,
    CreditHistoryItem credithistoryitem, {
    _i1.Transaction? transaction,
  }) async {
    if (credithistoryitem.id == null) {
      throw ArgumentError.notNull('credithistoryitem.id');
    }

    var $credithistoryitem =
        credithistoryitem.copyWith(creaditPackagePurchaseId: null);
    await session.db.updateRow<CreditHistoryItem>(
      $credithistoryitem,
      columns: [CreditHistoryItem.t.creaditPackagePurchaseId],
      transaction: transaction,
    );
  }
}
