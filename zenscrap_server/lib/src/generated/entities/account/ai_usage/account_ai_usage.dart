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
import '../../../entities/account/account.dart' as _i2;
import '../../../entities/account/ai_usage/ai_credit_history/ai_usage_history_item.dart'
    as _i3;

abstract class AccountAIUsage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountAIUsage._({
    this.id,
    this.userOpenAiApiKey,
    required this.totalDollarsSpentFromTotalInUSD,
    this.accountInfo,
    this.history,
  });

  factory AccountAIUsage({
    int? id,
    String? userOpenAiApiKey,
    required double totalDollarsSpentFromTotalInUSD,
    _i2.AccountInfo? accountInfo,
    List<_i3.AICreditHistoryItem>? history,
  }) = _AccountAIUsageImpl;

  factory AccountAIUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountAIUsage(
      id: jsonSerialization['id'] as int?,
      userOpenAiApiKey: jsonSerialization['userOpenAiApiKey'] as String?,
      totalDollarsSpentFromTotalInUSD:
          (jsonSerialization['totalDollarsSpentFromTotalInUSD'] as num)
              .toDouble(),
      accountInfo: jsonSerialization['accountInfo'] == null
          ? null
          : _i2.AccountInfo.fromJson(
              (jsonSerialization['accountInfo'] as Map<String, dynamic>)),
      history: (jsonSerialization['history'] as List?)
          ?.map((e) =>
              _i3.AICreditHistoryItem.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = AccountAIUsageTable();

  static const db = AccountAIUsageRepository._();

  @override
  int? id;

  String? userOpenAiApiKey;

  double totalDollarsSpentFromTotalInUSD;

  _i2.AccountInfo? accountInfo;

  List<_i3.AICreditHistoryItem>? history;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountAIUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountAIUsage copyWith({
    int? id,
    String? userOpenAiApiKey,
    double? totalDollarsSpentFromTotalInUSD,
    _i2.AccountInfo? accountInfo,
    List<_i3.AICreditHistoryItem>? history,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userOpenAiApiKey != null) 'userOpenAiApiKey': userOpenAiApiKey,
      'totalDollarsSpentFromTotalInUSD': totalDollarsSpentFromTotalInUSD,
      if (accountInfo != null) 'accountInfo': accountInfo?.toJson(),
      if (history != null)
        'history': history?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (userOpenAiApiKey != null) 'userOpenAiApiKey': userOpenAiApiKey,
      'totalDollarsSpentFromTotalInUSD': totalDollarsSpentFromTotalInUSD,
      if (accountInfo != null) 'accountInfo': accountInfo?.toJsonForProtocol(),
      if (history != null)
        'history': history?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static AccountAIUsageInclude include({
    _i2.AccountInfoInclude? accountInfo,
    _i3.AICreditHistoryItemIncludeList? history,
  }) {
    return AccountAIUsageInclude._(
      accountInfo: accountInfo,
      history: history,
    );
  }

  static AccountAIUsageIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountAIUsageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountAIUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountAIUsageTable>? orderByList,
    AccountAIUsageInclude? include,
  }) {
    return AccountAIUsageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountAIUsage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountAIUsage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountAIUsageImpl extends AccountAIUsage {
  _AccountAIUsageImpl({
    int? id,
    String? userOpenAiApiKey,
    required double totalDollarsSpentFromTotalInUSD,
    _i2.AccountInfo? accountInfo,
    List<_i3.AICreditHistoryItem>? history,
  }) : super._(
          id: id,
          userOpenAiApiKey: userOpenAiApiKey,
          totalDollarsSpentFromTotalInUSD: totalDollarsSpentFromTotalInUSD,
          accountInfo: accountInfo,
          history: history,
        );

  /// Returns a shallow copy of this [AccountAIUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountAIUsage copyWith({
    Object? id = _Undefined,
    Object? userOpenAiApiKey = _Undefined,
    double? totalDollarsSpentFromTotalInUSD,
    Object? accountInfo = _Undefined,
    Object? history = _Undefined,
  }) {
    return AccountAIUsage(
      id: id is int? ? id : this.id,
      userOpenAiApiKey: userOpenAiApiKey is String?
          ? userOpenAiApiKey
          : this.userOpenAiApiKey,
      totalDollarsSpentFromTotalInUSD: totalDollarsSpentFromTotalInUSD ??
          this.totalDollarsSpentFromTotalInUSD,
      accountInfo: accountInfo is _i2.AccountInfo?
          ? accountInfo
          : this.accountInfo?.copyWith(),
      history: history is List<_i3.AICreditHistoryItem>?
          ? history
          : this.history?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class AccountAIUsageTable extends _i1.Table<int?> {
  AccountAIUsageTable({super.tableRelation})
      : super(tableName: 'account_ai_usage') {
    userOpenAiApiKey = _i1.ColumnString(
      'userOpenAiApiKey',
      this,
    );
    totalDollarsSpentFromTotalInUSD = _i1.ColumnDouble(
      'totalDollarsSpentFromTotalInUSD',
      this,
    );
  }

  late final _i1.ColumnString userOpenAiApiKey;

  late final _i1.ColumnDouble totalDollarsSpentFromTotalInUSD;

  _i2.AccountInfoTable? _accountInfo;

  _i3.AICreditHistoryItemTable? ___history;

  _i1.ManyRelation<_i3.AICreditHistoryItemTable>? _history;

  _i2.AccountInfoTable get accountInfo {
    if (_accountInfo != null) return _accountInfo!;
    _accountInfo = _i1.createRelationTable(
      relationFieldName: 'accountInfo',
      field: AccountAIUsage.t.id,
      foreignField: _i2.AccountInfo.t.accountAIUsageId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AccountInfoTable(tableRelation: foreignTableRelation),
    );
    return _accountInfo!;
  }

  _i3.AICreditHistoryItemTable get __history {
    if (___history != null) return ___history!;
    ___history = _i1.createRelationTable(
      relationFieldName: '__history',
      field: AccountAIUsage.t.id,
      foreignField: _i3.AICreditHistoryItem.t.accountAIUsageId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.AICreditHistoryItemTable(tableRelation: foreignTableRelation),
    );
    return ___history!;
  }

  _i1.ManyRelation<_i3.AICreditHistoryItemTable> get history {
    if (_history != null) return _history!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'history',
      field: AccountAIUsage.t.id,
      foreignField: _i3.AICreditHistoryItem.t.accountAIUsageId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.AICreditHistoryItemTable(tableRelation: foreignTableRelation),
    );
    _history = _i1.ManyRelation<_i3.AICreditHistoryItemTable>(
      tableWithRelations: relationTable,
      table: _i3.AICreditHistoryItemTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _history!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        userOpenAiApiKey,
        totalDollarsSpentFromTotalInUSD,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'accountInfo') {
      return accountInfo;
    }
    if (relationField == 'history') {
      return __history;
    }
    return null;
  }
}

class AccountAIUsageInclude extends _i1.IncludeObject {
  AccountAIUsageInclude._({
    _i2.AccountInfoInclude? accountInfo,
    _i3.AICreditHistoryItemIncludeList? history,
  }) {
    _accountInfo = accountInfo;
    _history = history;
  }

  _i2.AccountInfoInclude? _accountInfo;

  _i3.AICreditHistoryItemIncludeList? _history;

  @override
  Map<String, _i1.Include?> get includes => {
        'accountInfo': _accountInfo,
        'history': _history,
      };

  @override
  _i1.Table<int?> get table => AccountAIUsage.t;
}

class AccountAIUsageIncludeList extends _i1.IncludeList {
  AccountAIUsageIncludeList._({
    _i1.WhereExpressionBuilder<AccountAIUsageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountAIUsage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountAIUsage.t;
}

class AccountAIUsageRepository {
  const AccountAIUsageRepository._();

  final attach = const AccountAIUsageAttachRepository._();

  final attachRow = const AccountAIUsageAttachRowRepository._();

  final detach = const AccountAIUsageDetachRepository._();

  final detachRow = const AccountAIUsageDetachRowRepository._();

  /// Returns a list of [AccountAIUsage]s matching the given query parameters.
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
  Future<List<AccountAIUsage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountAIUsageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountAIUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountAIUsageTable>? orderByList,
    _i1.Transaction? transaction,
    AccountAIUsageInclude? include,
  }) async {
    return session.db.find<AccountAIUsage>(
      where: where?.call(AccountAIUsage.t),
      orderBy: orderBy?.call(AccountAIUsage.t),
      orderByList: orderByList?.call(AccountAIUsage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AccountAIUsage] matching the given query parameters.
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
  Future<AccountAIUsage?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountAIUsageTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountAIUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountAIUsageTable>? orderByList,
    _i1.Transaction? transaction,
    AccountAIUsageInclude? include,
  }) async {
    return session.db.findFirstRow<AccountAIUsage>(
      where: where?.call(AccountAIUsage.t),
      orderBy: orderBy?.call(AccountAIUsage.t),
      orderByList: orderByList?.call(AccountAIUsage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AccountAIUsage] by its [id] or null if no such row exists.
  Future<AccountAIUsage?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AccountAIUsageInclude? include,
  }) async {
    return session.db.findById<AccountAIUsage>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AccountAIUsage]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountAIUsage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AccountAIUsage>> insert(
    _i1.Session session,
    List<AccountAIUsage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AccountAIUsage>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AccountAIUsage] and returns the inserted row.
  ///
  /// The returned [AccountAIUsage] will have its `id` field set.
  Future<AccountAIUsage> insertRow(
    _i1.Session session,
    AccountAIUsage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountAIUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountAIUsage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountAIUsage>> update(
    _i1.Session session,
    List<AccountAIUsage> rows, {
    _i1.ColumnSelections<AccountAIUsageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountAIUsage>(
      rows,
      columns: columns?.call(AccountAIUsage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountAIUsage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountAIUsage> updateRow(
    _i1.Session session,
    AccountAIUsage row, {
    _i1.ColumnSelections<AccountAIUsageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountAIUsage>(
      row,
      columns: columns?.call(AccountAIUsage.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AccountAIUsage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountAIUsage>> delete(
    _i1.Session session,
    List<AccountAIUsage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountAIUsage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountAIUsage].
  Future<AccountAIUsage> deleteRow(
    _i1.Session session,
    AccountAIUsage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountAIUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountAIUsage>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AccountAIUsageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountAIUsage>(
      where: where(AccountAIUsage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountAIUsageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountAIUsage>(
      where: where?.call(AccountAIUsage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AccountAIUsageAttachRepository {
  const AccountAIUsageAttachRepository._();

  /// Creates a relation between this [AccountAIUsage] and the given [AICreditHistoryItem]s
  /// by setting each [AICreditHistoryItem]'s foreign key `accountAIUsageId` to refer to this [AccountAIUsage].
  Future<void> history(
    _i1.Session session,
    AccountAIUsage accountAIUsage,
    List<_i3.AICreditHistoryItem> aICreditHistoryItem, {
    _i1.Transaction? transaction,
  }) async {
    if (aICreditHistoryItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('aICreditHistoryItem.id');
    }
    if (accountAIUsage.id == null) {
      throw ArgumentError.notNull('accountAIUsage.id');
    }

    var $aICreditHistoryItem = aICreditHistoryItem
        .map((e) => e.copyWith(accountAIUsageId: accountAIUsage.id))
        .toList();
    await session.db.update<_i3.AICreditHistoryItem>(
      $aICreditHistoryItem,
      columns: [_i3.AICreditHistoryItem.t.accountAIUsageId],
      transaction: transaction,
    );
  }
}

class AccountAIUsageAttachRowRepository {
  const AccountAIUsageAttachRowRepository._();

  /// Creates a relation between the given [AccountAIUsage] and [AccountInfo]
  /// by setting the [AccountAIUsage]'s foreign key `id` to refer to the [AccountInfo].
  Future<void> accountInfo(
    _i1.Session session,
    AccountAIUsage accountAIUsage,
    _i2.AccountInfo accountInfo, {
    _i1.Transaction? transaction,
  }) async {
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }
    if (accountAIUsage.id == null) {
      throw ArgumentError.notNull('accountAIUsage.id');
    }

    var $accountInfo =
        accountInfo.copyWith(accountAIUsageId: accountAIUsage.id);
    await session.db.updateRow<_i2.AccountInfo>(
      $accountInfo,
      columns: [_i2.AccountInfo.t.accountAIUsageId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [AccountAIUsage] and the given [AICreditHistoryItem]
  /// by setting the [AICreditHistoryItem]'s foreign key `accountAIUsageId` to refer to this [AccountAIUsage].
  Future<void> history(
    _i1.Session session,
    AccountAIUsage accountAIUsage,
    _i3.AICreditHistoryItem aICreditHistoryItem, {
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
    await session.db.updateRow<_i3.AICreditHistoryItem>(
      $aICreditHistoryItem,
      columns: [_i3.AICreditHistoryItem.t.accountAIUsageId],
      transaction: transaction,
    );
  }
}

class AccountAIUsageDetachRepository {
  const AccountAIUsageDetachRepository._();

  /// Detaches the relation between this [AccountAIUsage] and the given [AICreditHistoryItem]
  /// by setting the [AICreditHistoryItem]'s foreign key `accountAIUsageId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> history(
    _i1.Session session,
    List<_i3.AICreditHistoryItem> aICreditHistoryItem, {
    _i1.Transaction? transaction,
  }) async {
    if (aICreditHistoryItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('aICreditHistoryItem.id');
    }

    var $aICreditHistoryItem = aICreditHistoryItem
        .map((e) => e.copyWith(accountAIUsageId: null))
        .toList();
    await session.db.update<_i3.AICreditHistoryItem>(
      $aICreditHistoryItem,
      columns: [_i3.AICreditHistoryItem.t.accountAIUsageId],
      transaction: transaction,
    );
  }
}

class AccountAIUsageDetachRowRepository {
  const AccountAIUsageDetachRowRepository._();

  /// Detaches the relation between this [AccountAIUsage] and the given [AICreditHistoryItem]
  /// by setting the [AICreditHistoryItem]'s foreign key `accountAIUsageId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> history(
    _i1.Session session,
    _i3.AICreditHistoryItem aICreditHistoryItem, {
    _i1.Transaction? transaction,
  }) async {
    if (aICreditHistoryItem.id == null) {
      throw ArgumentError.notNull('aICreditHistoryItem.id');
    }

    var $aICreditHistoryItem =
        aICreditHistoryItem.copyWith(accountAIUsageId: null);
    await session.db.updateRow<_i3.AICreditHistoryItem>(
      $aICreditHistoryItem,
      columns: [_i3.AICreditHistoryItem.t.accountAIUsageId],
      transaction: transaction,
    );
  }
}
