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
import '../../../entities/account/api_usage/api_creadit_history/api_creadit_history_item.dart'
    as _i3;
import '../../../entities/account/account_api_key.dart' as _i4;

abstract class AccountApiUsage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountApiUsage._({
    this.id,
    required this.nanoId,
    required this.subscriptionCredits,
    required this.purchasedCredits,
    this.accountInfo,
    this.history,
    this.apiKeys,
  });

  factory AccountApiUsage({
    int? id,
    required String nanoId,
    required int subscriptionCredits,
    required int purchasedCredits,
    _i2.AccountInfo? accountInfo,
    List<_i3.CreditHistoryItem>? history,
    List<_i4.AccountApiKey>? apiKeys,
  }) = _AccountApiUsageImpl;

  factory AccountApiUsage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountApiUsage(
      id: jsonSerialization['id'] as int?,
      nanoId: jsonSerialization['nanoId'] as String,
      subscriptionCredits: jsonSerialization['subscriptionCredits'] as int,
      purchasedCredits: jsonSerialization['purchasedCredits'] as int,
      accountInfo: jsonSerialization['accountInfo'] == null
          ? null
          : _i2.AccountInfo.fromJson(
              (jsonSerialization['accountInfo'] as Map<String, dynamic>)),
      history: (jsonSerialization['history'] as List?)
          ?.map((e) =>
              _i3.CreditHistoryItem.fromJson((e as Map<String, dynamic>)))
          .toList(),
      apiKeys: (jsonSerialization['apiKeys'] as List?)
          ?.map((e) => _i4.AccountApiKey.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = AccountApiUsageTable();

  static const db = AccountApiUsageRepository._();

  @override
  int? id;

  String nanoId;

  int subscriptionCredits;

  int purchasedCredits;

  _i2.AccountInfo? accountInfo;

  List<_i3.CreditHistoryItem>? history;

  List<_i4.AccountApiKey>? apiKeys;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountApiUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountApiUsage copyWith({
    int? id,
    String? nanoId,
    int? subscriptionCredits,
    int? purchasedCredits,
    _i2.AccountInfo? accountInfo,
    List<_i3.CreditHistoryItem>? history,
    List<_i4.AccountApiKey>? apiKeys,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nanoId': nanoId,
      'subscriptionCredits': subscriptionCredits,
      'purchasedCredits': purchasedCredits,
      if (accountInfo != null) 'accountInfo': accountInfo?.toJson(),
      if (history != null)
        'history': history?.toJson(valueToJson: (v) => v.toJson()),
      if (apiKeys != null)
        'apiKeys': apiKeys?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'nanoId': nanoId,
      'subscriptionCredits': subscriptionCredits,
      'purchasedCredits': purchasedCredits,
      if (accountInfo != null) 'accountInfo': accountInfo?.toJsonForProtocol(),
      if (history != null)
        'history': history?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (apiKeys != null)
        'apiKeys': apiKeys?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static AccountApiUsageInclude include({
    _i2.AccountInfoInclude? accountInfo,
    _i3.CreditHistoryItemIncludeList? history,
    _i4.AccountApiKeyIncludeList? apiKeys,
  }) {
    return AccountApiUsageInclude._(
      accountInfo: accountInfo,
      history: history,
      apiKeys: apiKeys,
    );
  }

  static AccountApiUsageIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountApiUsageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountApiUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountApiUsageTable>? orderByList,
    AccountApiUsageInclude? include,
  }) {
    return AccountApiUsageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountApiUsage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountApiUsage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountApiUsageImpl extends AccountApiUsage {
  _AccountApiUsageImpl({
    int? id,
    required String nanoId,
    required int subscriptionCredits,
    required int purchasedCredits,
    _i2.AccountInfo? accountInfo,
    List<_i3.CreditHistoryItem>? history,
    List<_i4.AccountApiKey>? apiKeys,
  }) : super._(
          id: id,
          nanoId: nanoId,
          subscriptionCredits: subscriptionCredits,
          purchasedCredits: purchasedCredits,
          accountInfo: accountInfo,
          history: history,
          apiKeys: apiKeys,
        );

  /// Returns a shallow copy of this [AccountApiUsage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountApiUsage copyWith({
    Object? id = _Undefined,
    String? nanoId,
    int? subscriptionCredits,
    int? purchasedCredits,
    Object? accountInfo = _Undefined,
    Object? history = _Undefined,
    Object? apiKeys = _Undefined,
  }) {
    return AccountApiUsage(
      id: id is int? ? id : this.id,
      nanoId: nanoId ?? this.nanoId,
      subscriptionCredits: subscriptionCredits ?? this.subscriptionCredits,
      purchasedCredits: purchasedCredits ?? this.purchasedCredits,
      accountInfo: accountInfo is _i2.AccountInfo?
          ? accountInfo
          : this.accountInfo?.copyWith(),
      history: history is List<_i3.CreditHistoryItem>?
          ? history
          : this.history?.map((e0) => e0.copyWith()).toList(),
      apiKeys: apiKeys is List<_i4.AccountApiKey>?
          ? apiKeys
          : this.apiKeys?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class AccountApiUsageTable extends _i1.Table<int?> {
  AccountApiUsageTable({super.tableRelation})
      : super(tableName: 'account_api_usage') {
    nanoId = _i1.ColumnString(
      'nanoId',
      this,
    );
    subscriptionCredits = _i1.ColumnInt(
      'subscriptionCredits',
      this,
    );
    purchasedCredits = _i1.ColumnInt(
      'purchasedCredits',
      this,
    );
  }

  late final _i1.ColumnString nanoId;

  late final _i1.ColumnInt subscriptionCredits;

  late final _i1.ColumnInt purchasedCredits;

  _i2.AccountInfoTable? _accountInfo;

  _i3.CreditHistoryItemTable? ___history;

  _i1.ManyRelation<_i3.CreditHistoryItemTable>? _history;

  _i4.AccountApiKeyTable? ___apiKeys;

  _i1.ManyRelation<_i4.AccountApiKeyTable>? _apiKeys;

  _i2.AccountInfoTable get accountInfo {
    if (_accountInfo != null) return _accountInfo!;
    _accountInfo = _i1.createRelationTable(
      relationFieldName: 'accountInfo',
      field: AccountApiUsage.t.id,
      foreignField: _i2.AccountInfo.t.accountApiUsageId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.AccountInfoTable(tableRelation: foreignTableRelation),
    );
    return _accountInfo!;
  }

  _i3.CreditHistoryItemTable get __history {
    if (___history != null) return ___history!;
    ___history = _i1.createRelationTable(
      relationFieldName: '__history',
      field: AccountApiUsage.t.id,
      foreignField: _i3.CreditHistoryItem.t.accountApiUsageId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.CreditHistoryItemTable(tableRelation: foreignTableRelation),
    );
    return ___history!;
  }

  _i4.AccountApiKeyTable get __apiKeys {
    if (___apiKeys != null) return ___apiKeys!;
    ___apiKeys = _i1.createRelationTable(
      relationFieldName: '__apiKeys',
      field: AccountApiUsage.t.id,
      foreignField: _i4.AccountApiKey.t.accountApiUsageId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.AccountApiKeyTable(tableRelation: foreignTableRelation),
    );
    return ___apiKeys!;
  }

  _i1.ManyRelation<_i3.CreditHistoryItemTable> get history {
    if (_history != null) return _history!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'history',
      field: AccountApiUsage.t.id,
      foreignField: _i3.CreditHistoryItem.t.accountApiUsageId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.CreditHistoryItemTable(tableRelation: foreignTableRelation),
    );
    _history = _i1.ManyRelation<_i3.CreditHistoryItemTable>(
      tableWithRelations: relationTable,
      table: _i3.CreditHistoryItemTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _history!;
  }

  _i1.ManyRelation<_i4.AccountApiKeyTable> get apiKeys {
    if (_apiKeys != null) return _apiKeys!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'apiKeys',
      field: AccountApiUsage.t.id,
      foreignField: _i4.AccountApiKey.t.accountApiUsageId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.AccountApiKeyTable(tableRelation: foreignTableRelation),
    );
    _apiKeys = _i1.ManyRelation<_i4.AccountApiKeyTable>(
      tableWithRelations: relationTable,
      table: _i4.AccountApiKeyTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _apiKeys!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        nanoId,
        subscriptionCredits,
        purchasedCredits,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'accountInfo') {
      return accountInfo;
    }
    if (relationField == 'history') {
      return __history;
    }
    if (relationField == 'apiKeys') {
      return __apiKeys;
    }
    return null;
  }
}

class AccountApiUsageInclude extends _i1.IncludeObject {
  AccountApiUsageInclude._({
    _i2.AccountInfoInclude? accountInfo,
    _i3.CreditHistoryItemIncludeList? history,
    _i4.AccountApiKeyIncludeList? apiKeys,
  }) {
    _accountInfo = accountInfo;
    _history = history;
    _apiKeys = apiKeys;
  }

  _i2.AccountInfoInclude? _accountInfo;

  _i3.CreditHistoryItemIncludeList? _history;

  _i4.AccountApiKeyIncludeList? _apiKeys;

  @override
  Map<String, _i1.Include?> get includes => {
        'accountInfo': _accountInfo,
        'history': _history,
        'apiKeys': _apiKeys,
      };

  @override
  _i1.Table<int?> get table => AccountApiUsage.t;
}

class AccountApiUsageIncludeList extends _i1.IncludeList {
  AccountApiUsageIncludeList._({
    _i1.WhereExpressionBuilder<AccountApiUsageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountApiUsage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountApiUsage.t;
}

class AccountApiUsageRepository {
  const AccountApiUsageRepository._();

  final attach = const AccountApiUsageAttachRepository._();

  final attachRow = const AccountApiUsageAttachRowRepository._();

  final detach = const AccountApiUsageDetachRepository._();

  final detachRow = const AccountApiUsageDetachRowRepository._();

  /// Returns a list of [AccountApiUsage]s matching the given query parameters.
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
  Future<List<AccountApiUsage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountApiUsageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountApiUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountApiUsageTable>? orderByList,
    _i1.Transaction? transaction,
    AccountApiUsageInclude? include,
  }) async {
    return session.db.find<AccountApiUsage>(
      where: where?.call(AccountApiUsage.t),
      orderBy: orderBy?.call(AccountApiUsage.t),
      orderByList: orderByList?.call(AccountApiUsage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AccountApiUsage] matching the given query parameters.
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
  Future<AccountApiUsage?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountApiUsageTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountApiUsageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountApiUsageTable>? orderByList,
    _i1.Transaction? transaction,
    AccountApiUsageInclude? include,
  }) async {
    return session.db.findFirstRow<AccountApiUsage>(
      where: where?.call(AccountApiUsage.t),
      orderBy: orderBy?.call(AccountApiUsage.t),
      orderByList: orderByList?.call(AccountApiUsage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AccountApiUsage] by its [id] or null if no such row exists.
  Future<AccountApiUsage?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AccountApiUsageInclude? include,
  }) async {
    return session.db.findById<AccountApiUsage>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AccountApiUsage]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountApiUsage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AccountApiUsage>> insert(
    _i1.Session session,
    List<AccountApiUsage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AccountApiUsage>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AccountApiUsage] and returns the inserted row.
  ///
  /// The returned [AccountApiUsage] will have its `id` field set.
  Future<AccountApiUsage> insertRow(
    _i1.Session session,
    AccountApiUsage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountApiUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountApiUsage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountApiUsage>> update(
    _i1.Session session,
    List<AccountApiUsage> rows, {
    _i1.ColumnSelections<AccountApiUsageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountApiUsage>(
      rows,
      columns: columns?.call(AccountApiUsage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountApiUsage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountApiUsage> updateRow(
    _i1.Session session,
    AccountApiUsage row, {
    _i1.ColumnSelections<AccountApiUsageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountApiUsage>(
      row,
      columns: columns?.call(AccountApiUsage.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AccountApiUsage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountApiUsage>> delete(
    _i1.Session session,
    List<AccountApiUsage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountApiUsage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountApiUsage].
  Future<AccountApiUsage> deleteRow(
    _i1.Session session,
    AccountApiUsage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountApiUsage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountApiUsage>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AccountApiUsageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountApiUsage>(
      where: where(AccountApiUsage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountApiUsageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountApiUsage>(
      where: where?.call(AccountApiUsage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AccountApiUsageAttachRepository {
  const AccountApiUsageAttachRepository._();

  /// Creates a relation between this [AccountApiUsage] and the given [CreditHistoryItem]s
  /// by setting each [CreditHistoryItem]'s foreign key `accountApiUsageId` to refer to this [AccountApiUsage].
  Future<void> history(
    _i1.Session session,
    AccountApiUsage accountApiUsage,
    List<_i3.CreditHistoryItem> creditHistoryItem, {
    _i1.Transaction? transaction,
  }) async {
    if (creditHistoryItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('creditHistoryItem.id');
    }
    if (accountApiUsage.id == null) {
      throw ArgumentError.notNull('accountApiUsage.id');
    }

    var $creditHistoryItem = creditHistoryItem
        .map((e) => e.copyWith(accountApiUsageId: accountApiUsage.id))
        .toList();
    await session.db.update<_i3.CreditHistoryItem>(
      $creditHistoryItem,
      columns: [_i3.CreditHistoryItem.t.accountApiUsageId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [AccountApiUsage] and the given [AccountApiKey]s
  /// by setting each [AccountApiKey]'s foreign key `accountApiUsageId` to refer to this [AccountApiUsage].
  Future<void> apiKeys(
    _i1.Session session,
    AccountApiUsage accountApiUsage,
    List<_i4.AccountApiKey> accountApiKey, {
    _i1.Transaction? transaction,
  }) async {
    if (accountApiKey.any((e) => e.id == null)) {
      throw ArgumentError.notNull('accountApiKey.id');
    }
    if (accountApiUsage.id == null) {
      throw ArgumentError.notNull('accountApiUsage.id');
    }

    var $accountApiKey = accountApiKey
        .map((e) => e.copyWith(accountApiUsageId: accountApiUsage.id))
        .toList();
    await session.db.update<_i4.AccountApiKey>(
      $accountApiKey,
      columns: [_i4.AccountApiKey.t.accountApiUsageId],
      transaction: transaction,
    );
  }
}

class AccountApiUsageAttachRowRepository {
  const AccountApiUsageAttachRowRepository._();

  /// Creates a relation between the given [AccountApiUsage] and [AccountInfo]
  /// by setting the [AccountApiUsage]'s foreign key `id` to refer to the [AccountInfo].
  Future<void> accountInfo(
    _i1.Session session,
    AccountApiUsage accountApiUsage,
    _i2.AccountInfo accountInfo, {
    _i1.Transaction? transaction,
  }) async {
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }
    if (accountApiUsage.id == null) {
      throw ArgumentError.notNull('accountApiUsage.id');
    }

    var $accountInfo =
        accountInfo.copyWith(accountApiUsageId: accountApiUsage.id);
    await session.db.updateRow<_i2.AccountInfo>(
      $accountInfo,
      columns: [_i2.AccountInfo.t.accountApiUsageId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [AccountApiUsage] and the given [CreditHistoryItem]
  /// by setting the [CreditHistoryItem]'s foreign key `accountApiUsageId` to refer to this [AccountApiUsage].
  Future<void> history(
    _i1.Session session,
    AccountApiUsage accountApiUsage,
    _i3.CreditHistoryItem creditHistoryItem, {
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
    await session.db.updateRow<_i3.CreditHistoryItem>(
      $creditHistoryItem,
      columns: [_i3.CreditHistoryItem.t.accountApiUsageId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [AccountApiUsage] and the given [AccountApiKey]
  /// by setting the [AccountApiKey]'s foreign key `accountApiUsageId` to refer to this [AccountApiUsage].
  Future<void> apiKeys(
    _i1.Session session,
    AccountApiUsage accountApiUsage,
    _i4.AccountApiKey accountApiKey, {
    _i1.Transaction? transaction,
  }) async {
    if (accountApiKey.id == null) {
      throw ArgumentError.notNull('accountApiKey.id');
    }
    if (accountApiUsage.id == null) {
      throw ArgumentError.notNull('accountApiUsage.id');
    }

    var $accountApiKey =
        accountApiKey.copyWith(accountApiUsageId: accountApiUsage.id);
    await session.db.updateRow<_i4.AccountApiKey>(
      $accountApiKey,
      columns: [_i4.AccountApiKey.t.accountApiUsageId],
      transaction: transaction,
    );
  }
}

class AccountApiUsageDetachRepository {
  const AccountApiUsageDetachRepository._();

  /// Detaches the relation between this [AccountApiUsage] and the given [CreditHistoryItem]
  /// by setting the [CreditHistoryItem]'s foreign key `accountApiUsageId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> history(
    _i1.Session session,
    List<_i3.CreditHistoryItem> creditHistoryItem, {
    _i1.Transaction? transaction,
  }) async {
    if (creditHistoryItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('creditHistoryItem.id');
    }

    var $creditHistoryItem = creditHistoryItem
        .map((e) => e.copyWith(accountApiUsageId: null))
        .toList();
    await session.db.update<_i3.CreditHistoryItem>(
      $creditHistoryItem,
      columns: [_i3.CreditHistoryItem.t.accountApiUsageId],
      transaction: transaction,
    );
  }
}

class AccountApiUsageDetachRowRepository {
  const AccountApiUsageDetachRowRepository._();

  /// Detaches the relation between this [AccountApiUsage] and the given [CreditHistoryItem]
  /// by setting the [CreditHistoryItem]'s foreign key `accountApiUsageId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> history(
    _i1.Session session,
    _i3.CreditHistoryItem creditHistoryItem, {
    _i1.Transaction? transaction,
  }) async {
    if (creditHistoryItem.id == null) {
      throw ArgumentError.notNull('creditHistoryItem.id');
    }

    var $creditHistoryItem =
        creditHistoryItem.copyWith(accountApiUsageId: null);
    await session.db.updateRow<_i3.CreditHistoryItem>(
      $creditHistoryItem,
      columns: [_i3.CreditHistoryItem.t.accountApiUsageId],
      transaction: transaction,
    );
  }
}
