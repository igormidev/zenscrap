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
import '../../../../entities/account/ai_usage/ai_credit_history/monthly_subscription_ai_credit_deposit.dart'
    as _i2;
import '../../../../entities/account/ai_usage/account_ai_usage.dart' as _i3;

abstract class AICreditHistoryItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AICreditHistoryItem._({
    this.id,
    required this.date,
    this.monthlySubscriptionAICreditDepositId,
    this.monthlySubscriptionAICreditDeposit,
    required this.accountAIUsageId,
    this.accountAIUsage,
  });

  factory AICreditHistoryItem({
    int? id,
    required DateTime date,
    int? monthlySubscriptionAICreditDepositId,
    _i2.MonthlySubscriptionAICreditDeposit? monthlySubscriptionAICreditDeposit,
    required int accountAIUsageId,
    _i3.AccountAIUsage? accountAIUsage,
  }) = _AICreditHistoryItemImpl;

  factory AICreditHistoryItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return AICreditHistoryItem(
      id: jsonSerialization['id'] as int?,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      monthlySubscriptionAICreditDepositId:
          jsonSerialization['monthlySubscriptionAICreditDepositId'] as int?,
      monthlySubscriptionAICreditDeposit:
          jsonSerialization['monthlySubscriptionAICreditDeposit'] == null
              ? null
              : _i2.MonthlySubscriptionAICreditDeposit.fromJson(
                  (jsonSerialization['monthlySubscriptionAICreditDeposit']
                      as Map<String, dynamic>)),
      accountAIUsageId: jsonSerialization['accountAIUsageId'] as int,
      accountAIUsage: jsonSerialization['accountAIUsage'] == null
          ? null
          : _i3.AccountAIUsage.fromJson(
              (jsonSerialization['accountAIUsage'] as Map<String, dynamic>)),
    );
  }

  static final t = AICreditHistoryItemTable();

  static const db = AICreditHistoryItemRepository._();

  @override
  int? id;

  DateTime date;

  int? monthlySubscriptionAICreditDepositId;

  _i2.MonthlySubscriptionAICreditDeposit? monthlySubscriptionAICreditDeposit;

  int accountAIUsageId;

  _i3.AccountAIUsage? accountAIUsage;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AICreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AICreditHistoryItem copyWith({
    int? id,
    DateTime? date,
    int? monthlySubscriptionAICreditDepositId,
    _i2.MonthlySubscriptionAICreditDeposit? monthlySubscriptionAICreditDeposit,
    int? accountAIUsageId,
    _i3.AccountAIUsage? accountAIUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'date': date.toJson(),
      if (monthlySubscriptionAICreditDepositId != null)
        'monthlySubscriptionAICreditDepositId':
            monthlySubscriptionAICreditDepositId,
      if (monthlySubscriptionAICreditDeposit != null)
        'monthlySubscriptionAICreditDeposit':
            monthlySubscriptionAICreditDeposit?.toJson(),
      'accountAIUsageId': accountAIUsageId,
      if (accountAIUsage != null) 'accountAIUsage': accountAIUsage?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'date': date.toJson(),
      if (monthlySubscriptionAICreditDepositId != null)
        'monthlySubscriptionAICreditDepositId':
            monthlySubscriptionAICreditDepositId,
      if (monthlySubscriptionAICreditDeposit != null)
        'monthlySubscriptionAICreditDeposit':
            monthlySubscriptionAICreditDeposit?.toJsonForProtocol(),
      'accountAIUsageId': accountAIUsageId,
      if (accountAIUsage != null)
        'accountAIUsage': accountAIUsage?.toJsonForProtocol(),
    };
  }

  static AICreditHistoryItemInclude include({
    _i2.MonthlySubscriptionAICreditDepositInclude?
        monthlySubscriptionAICreditDeposit,
    _i3.AccountAIUsageInclude? accountAIUsage,
  }) {
    return AICreditHistoryItemInclude._(
      monthlySubscriptionAICreditDeposit: monthlySubscriptionAICreditDeposit,
      accountAIUsage: accountAIUsage,
    );
  }

  static AICreditHistoryItemIncludeList includeList({
    _i1.WhereExpressionBuilder<AICreditHistoryItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AICreditHistoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AICreditHistoryItemTable>? orderByList,
    AICreditHistoryItemInclude? include,
  }) {
    return AICreditHistoryItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AICreditHistoryItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AICreditHistoryItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AICreditHistoryItemImpl extends AICreditHistoryItem {
  _AICreditHistoryItemImpl({
    int? id,
    required DateTime date,
    int? monthlySubscriptionAICreditDepositId,
    _i2.MonthlySubscriptionAICreditDeposit? monthlySubscriptionAICreditDeposit,
    required int accountAIUsageId,
    _i3.AccountAIUsage? accountAIUsage,
  }) : super._(
          id: id,
          date: date,
          monthlySubscriptionAICreditDepositId:
              monthlySubscriptionAICreditDepositId,
          monthlySubscriptionAICreditDeposit:
              monthlySubscriptionAICreditDeposit,
          accountAIUsageId: accountAIUsageId,
          accountAIUsage: accountAIUsage,
        );

  /// Returns a shallow copy of this [AICreditHistoryItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AICreditHistoryItem copyWith({
    Object? id = _Undefined,
    DateTime? date,
    Object? monthlySubscriptionAICreditDepositId = _Undefined,
    Object? monthlySubscriptionAICreditDeposit = _Undefined,
    int? accountAIUsageId,
    Object? accountAIUsage = _Undefined,
  }) {
    return AICreditHistoryItem(
      id: id is int? ? id : this.id,
      date: date ?? this.date,
      monthlySubscriptionAICreditDepositId:
          monthlySubscriptionAICreditDepositId is int?
              ? monthlySubscriptionAICreditDepositId
              : this.monthlySubscriptionAICreditDepositId,
      monthlySubscriptionAICreditDeposit: monthlySubscriptionAICreditDeposit
              is _i2.MonthlySubscriptionAICreditDeposit?
          ? monthlySubscriptionAICreditDeposit
          : this.monthlySubscriptionAICreditDeposit?.copyWith(),
      accountAIUsageId: accountAIUsageId ?? this.accountAIUsageId,
      accountAIUsage: accountAIUsage is _i3.AccountAIUsage?
          ? accountAIUsage
          : this.accountAIUsage?.copyWith(),
    );
  }
}

class AICreditHistoryItemTable extends _i1.Table<int?> {
  AICreditHistoryItemTable({super.tableRelation})
      : super(tableName: 'ai_credit_history_item') {
    date = _i1.ColumnDateTime(
      'date',
      this,
    );
    monthlySubscriptionAICreditDepositId = _i1.ColumnInt(
      'monthlySubscriptionAICreditDepositId',
      this,
    );
    accountAIUsageId = _i1.ColumnInt(
      'accountAIUsageId',
      this,
    );
  }

  late final _i1.ColumnDateTime date;

  late final _i1.ColumnInt monthlySubscriptionAICreditDepositId;

  _i2.MonthlySubscriptionAICreditDepositTable?
      _monthlySubscriptionAICreditDeposit;

  late final _i1.ColumnInt accountAIUsageId;

  _i3.AccountAIUsageTable? _accountAIUsage;

  _i2.MonthlySubscriptionAICreditDepositTable
      get monthlySubscriptionAICreditDeposit {
    if (_monthlySubscriptionAICreditDeposit != null)
      return _monthlySubscriptionAICreditDeposit!;
    _monthlySubscriptionAICreditDeposit = _i1.createRelationTable(
      relationFieldName: 'monthlySubscriptionAICreditDeposit',
      field: AICreditHistoryItem.t.monthlySubscriptionAICreditDepositId,
      foreignField: _i2.MonthlySubscriptionAICreditDeposit.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.MonthlySubscriptionAICreditDepositTable(
              tableRelation: foreignTableRelation),
    );
    return _monthlySubscriptionAICreditDeposit!;
  }

  _i3.AccountAIUsageTable get accountAIUsage {
    if (_accountAIUsage != null) return _accountAIUsage!;
    _accountAIUsage = _i1.createRelationTable(
      relationFieldName: 'accountAIUsage',
      field: AICreditHistoryItem.t.accountAIUsageId,
      foreignField: _i3.AccountAIUsage.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.AccountAIUsageTable(tableRelation: foreignTableRelation),
    );
    return _accountAIUsage!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        date,
        monthlySubscriptionAICreditDepositId,
        accountAIUsageId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'monthlySubscriptionAICreditDeposit') {
      return monthlySubscriptionAICreditDeposit;
    }
    if (relationField == 'accountAIUsage') {
      return accountAIUsage;
    }
    return null;
  }
}

class AICreditHistoryItemInclude extends _i1.IncludeObject {
  AICreditHistoryItemInclude._({
    _i2.MonthlySubscriptionAICreditDepositInclude?
        monthlySubscriptionAICreditDeposit,
    _i3.AccountAIUsageInclude? accountAIUsage,
  }) {
    _monthlySubscriptionAICreditDeposit = monthlySubscriptionAICreditDeposit;
    _accountAIUsage = accountAIUsage;
  }

  _i2.MonthlySubscriptionAICreditDepositInclude?
      _monthlySubscriptionAICreditDeposit;

  _i3.AccountAIUsageInclude? _accountAIUsage;

  @override
  Map<String, _i1.Include?> get includes => {
        'monthlySubscriptionAICreditDeposit':
            _monthlySubscriptionAICreditDeposit,
        'accountAIUsage': _accountAIUsage,
      };

  @override
  _i1.Table<int?> get table => AICreditHistoryItem.t;
}

class AICreditHistoryItemIncludeList extends _i1.IncludeList {
  AICreditHistoryItemIncludeList._({
    _i1.WhereExpressionBuilder<AICreditHistoryItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AICreditHistoryItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AICreditHistoryItem.t;
}

class AICreditHistoryItemRepository {
  const AICreditHistoryItemRepository._();

  final attachRow = const AICreditHistoryItemAttachRowRepository._();

  final detachRow = const AICreditHistoryItemDetachRowRepository._();

  /// Returns a list of [AICreditHistoryItem]s matching the given query parameters.
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
  Future<List<AICreditHistoryItem>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AICreditHistoryItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AICreditHistoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AICreditHistoryItemTable>? orderByList,
    _i1.Transaction? transaction,
    AICreditHistoryItemInclude? include,
  }) async {
    return session.db.find<AICreditHistoryItem>(
      where: where?.call(AICreditHistoryItem.t),
      orderBy: orderBy?.call(AICreditHistoryItem.t),
      orderByList: orderByList?.call(AICreditHistoryItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AICreditHistoryItem] matching the given query parameters.
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
  Future<AICreditHistoryItem?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AICreditHistoryItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<AICreditHistoryItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AICreditHistoryItemTable>? orderByList,
    _i1.Transaction? transaction,
    AICreditHistoryItemInclude? include,
  }) async {
    return session.db.findFirstRow<AICreditHistoryItem>(
      where: where?.call(AICreditHistoryItem.t),
      orderBy: orderBy?.call(AICreditHistoryItem.t),
      orderByList: orderByList?.call(AICreditHistoryItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AICreditHistoryItem] by its [id] or null if no such row exists.
  Future<AICreditHistoryItem?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AICreditHistoryItemInclude? include,
  }) async {
    return session.db.findById<AICreditHistoryItem>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AICreditHistoryItem]s in the list and returns the inserted rows.
  ///
  /// The returned [AICreditHistoryItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AICreditHistoryItem>> insert(
    _i1.Session session,
    List<AICreditHistoryItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AICreditHistoryItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AICreditHistoryItem] and returns the inserted row.
  ///
  /// The returned [AICreditHistoryItem] will have its `id` field set.
  Future<AICreditHistoryItem> insertRow(
    _i1.Session session,
    AICreditHistoryItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AICreditHistoryItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AICreditHistoryItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AICreditHistoryItem>> update(
    _i1.Session session,
    List<AICreditHistoryItem> rows, {
    _i1.ColumnSelections<AICreditHistoryItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AICreditHistoryItem>(
      rows,
      columns: columns?.call(AICreditHistoryItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AICreditHistoryItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AICreditHistoryItem> updateRow(
    _i1.Session session,
    AICreditHistoryItem row, {
    _i1.ColumnSelections<AICreditHistoryItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AICreditHistoryItem>(
      row,
      columns: columns?.call(AICreditHistoryItem.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AICreditHistoryItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AICreditHistoryItem>> delete(
    _i1.Session session,
    List<AICreditHistoryItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AICreditHistoryItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AICreditHistoryItem].
  Future<AICreditHistoryItem> deleteRow(
    _i1.Session session,
    AICreditHistoryItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AICreditHistoryItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AICreditHistoryItem>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AICreditHistoryItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AICreditHistoryItem>(
      where: where(AICreditHistoryItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AICreditHistoryItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AICreditHistoryItem>(
      where: where?.call(AICreditHistoryItem.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AICreditHistoryItemAttachRowRepository {
  const AICreditHistoryItemAttachRowRepository._();

  /// Creates a relation between the given [AICreditHistoryItem] and [MonthlySubscriptionAICreditDeposit]
  /// by setting the [AICreditHistoryItem]'s foreign key `monthlySubscriptionAICreditDepositId` to refer to the [MonthlySubscriptionAICreditDeposit].
  Future<void> monthlySubscriptionAICreditDeposit(
    _i1.Session session,
    AICreditHistoryItem aICreditHistoryItem,
    _i2.MonthlySubscriptionAICreditDeposit monthlySubscriptionAICreditDeposit, {
    _i1.Transaction? transaction,
  }) async {
    if (aICreditHistoryItem.id == null) {
      throw ArgumentError.notNull('aICreditHistoryItem.id');
    }
    if (monthlySubscriptionAICreditDeposit.id == null) {
      throw ArgumentError.notNull('monthlySubscriptionAICreditDeposit.id');
    }

    var $aICreditHistoryItem = aICreditHistoryItem.copyWith(
        monthlySubscriptionAICreditDepositId:
            monthlySubscriptionAICreditDeposit.id);
    await session.db.updateRow<AICreditHistoryItem>(
      $aICreditHistoryItem,
      columns: [AICreditHistoryItem.t.monthlySubscriptionAICreditDepositId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AICreditHistoryItem] and [AccountAIUsage]
  /// by setting the [AICreditHistoryItem]'s foreign key `accountAIUsageId` to refer to the [AccountAIUsage].
  Future<void> accountAIUsage(
    _i1.Session session,
    AICreditHistoryItem aICreditHistoryItem,
    _i3.AccountAIUsage accountAIUsage, {
    _i1.Transaction? transaction,
  }) async {
    if (aICreditHistoryItem.id == null) {
      throw ArgumentError.notNull('aICreditHistoryItem.id');
    }
    if (accountAIUsage.id == null) {
      throw ArgumentError.notNull('accountAIUsage.id');
    }

    var $aICreditHistoryItem =
        aICreditHistoryItem.copyWith(accountAIUsageId: accountAIUsage.id);
    await session.db.updateRow<AICreditHistoryItem>(
      $aICreditHistoryItem,
      columns: [AICreditHistoryItem.t.accountAIUsageId],
      transaction: transaction,
    );
  }
}

class AICreditHistoryItemDetachRowRepository {
  const AICreditHistoryItemDetachRowRepository._();

  /// Detaches the relation between this [AICreditHistoryItem] and the [MonthlySubscriptionAICreditDeposit] set in `monthlySubscriptionAICreditDeposit`
  /// by setting the [AICreditHistoryItem]'s foreign key `monthlySubscriptionAICreditDepositId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> monthlySubscriptionAICreditDeposit(
    _i1.Session session,
    AICreditHistoryItem aicredithistoryitem, {
    _i1.Transaction? transaction,
  }) async {
    if (aicredithistoryitem.id == null) {
      throw ArgumentError.notNull('aicredithistoryitem.id');
    }

    var $aicredithistoryitem = aicredithistoryitem.copyWith(
        monthlySubscriptionAICreditDepositId: null);
    await session.db.updateRow<AICreditHistoryItem>(
      $aicredithistoryitem,
      columns: [AICreditHistoryItem.t.monthlySubscriptionAICreditDepositId],
      transaction: transaction,
    );
  }
}
