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
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import '../../entities/account/account_api_key.dart' as _i4;
import '../../entities/account/api_usage/account_api_usage.dart' as _i5;
import '../../entities/account/plan_tier.dart' as _i6;

abstract class AccountInfo
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountInfo._({
    this.id,
    this.scrappables,
    required this.userInfoId,
    this.userInfo,
    required this.accountApiKeyId,
    this.accountApiKey,
    required this.accountApiUsageId,
    this.accountApiUsage,
    required this.planTier,
  });

  factory AccountInfo({
    int? id,
    List<_i2.Scrappable>? scrappables,
    required int userInfoId,
    _i3.UserInfo? userInfo,
    required int accountApiKeyId,
    _i4.AccountApiKey? accountApiKey,
    required int accountApiUsageId,
    _i5.AccountApiUsage? accountApiUsage,
    required _i6.PlanTier planTier,
  }) = _AccountInfoImpl;

  factory AccountInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountInfo(
      id: jsonSerialization['id'] as int?,
      scrappables: (jsonSerialization['scrappables'] as List?)
          ?.map((e) => _i2.Scrappable.fromJson((e as Map<String, dynamic>)))
          .toList(),
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i3.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
      accountApiKeyId: jsonSerialization['accountApiKeyId'] as int,
      accountApiKey: jsonSerialization['accountApiKey'] == null
          ? null
          : _i4.AccountApiKey.fromJson(
              (jsonSerialization['accountApiKey'] as Map<String, dynamic>)),
      accountApiUsageId: jsonSerialization['accountApiUsageId'] as int,
      accountApiUsage: jsonSerialization['accountApiUsage'] == null
          ? null
          : _i5.AccountApiUsage.fromJson(
              (jsonSerialization['accountApiUsage'] as Map<String, dynamic>)),
      planTier: _i6.PlanTier.fromJson((jsonSerialization['planTier'] as int)),
    );
  }

  static final t = AccountInfoTable();

  static const db = AccountInfoRepository._();

  @override
  int? id;

  List<_i2.Scrappable>? scrappables;

  int userInfoId;

  _i3.UserInfo? userInfo;

  int accountApiKeyId;

  _i4.AccountApiKey? accountApiKey;

  int accountApiUsageId;

  _i5.AccountApiUsage? accountApiUsage;

  _i6.PlanTier planTier;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountInfo copyWith({
    int? id,
    List<_i2.Scrappable>? scrappables,
    int? userInfoId,
    _i3.UserInfo? userInfo,
    int? accountApiKeyId,
    _i4.AccountApiKey? accountApiKey,
    int? accountApiUsageId,
    _i5.AccountApiUsage? accountApiUsage,
    _i6.PlanTier? planTier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (scrappables != null)
        'scrappables': scrappables?.toJson(valueToJson: (v) => v.toJson()),
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
      'accountApiKeyId': accountApiKeyId,
      if (accountApiKey != null) 'accountApiKey': accountApiKey?.toJson(),
      'accountApiUsageId': accountApiUsageId,
      if (accountApiUsage != null) 'accountApiUsage': accountApiUsage?.toJson(),
      'planTier': planTier.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      if (scrappables != null)
        'scrappables':
            scrappables?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJsonForProtocol(),
      'accountApiKeyId': accountApiKeyId,
      if (accountApiKey != null)
        'accountApiKey': accountApiKey?.toJsonForProtocol(),
      'accountApiUsageId': accountApiUsageId,
      if (accountApiUsage != null)
        'accountApiUsage': accountApiUsage?.toJsonForProtocol(),
      'planTier': planTier.toJson(),
    };
  }

  static AccountInfoInclude include({
    _i2.ScrappableIncludeList? scrappables,
    _i3.UserInfoInclude? userInfo,
    _i4.AccountApiKeyInclude? accountApiKey,
    _i5.AccountApiUsageInclude? accountApiUsage,
  }) {
    return AccountInfoInclude._(
      scrappables: scrappables,
      userInfo: userInfo,
      accountApiKey: accountApiKey,
      accountApiUsage: accountApiUsage,
    );
  }

  static AccountInfoIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountInfoTable>? orderByList,
    AccountInfoInclude? include,
  }) {
    return AccountInfoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountInfo.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountInfo.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountInfoImpl extends AccountInfo {
  _AccountInfoImpl({
    int? id,
    List<_i2.Scrappable>? scrappables,
    required int userInfoId,
    _i3.UserInfo? userInfo,
    required int accountApiKeyId,
    _i4.AccountApiKey? accountApiKey,
    required int accountApiUsageId,
    _i5.AccountApiUsage? accountApiUsage,
    required _i6.PlanTier planTier,
  }) : super._(
          id: id,
          scrappables: scrappables,
          userInfoId: userInfoId,
          userInfo: userInfo,
          accountApiKeyId: accountApiKeyId,
          accountApiKey: accountApiKey,
          accountApiUsageId: accountApiUsageId,
          accountApiUsage: accountApiUsage,
          planTier: planTier,
        );

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountInfo copyWith({
    Object? id = _Undefined,
    Object? scrappables = _Undefined,
    int? userInfoId,
    Object? userInfo = _Undefined,
    int? accountApiKeyId,
    Object? accountApiKey = _Undefined,
    int? accountApiUsageId,
    Object? accountApiUsage = _Undefined,
    _i6.PlanTier? planTier,
  }) {
    return AccountInfo(
      id: id is int? ? id : this.id,
      scrappables: scrappables is List<_i2.Scrappable>?
          ? scrappables
          : this.scrappables?.map((e0) => e0.copyWith()).toList(),
      userInfoId: userInfoId ?? this.userInfoId,
      userInfo:
          userInfo is _i3.UserInfo? ? userInfo : this.userInfo?.copyWith(),
      accountApiKeyId: accountApiKeyId ?? this.accountApiKeyId,
      accountApiKey: accountApiKey is _i4.AccountApiKey?
          ? accountApiKey
          : this.accountApiKey?.copyWith(),
      accountApiUsageId: accountApiUsageId ?? this.accountApiUsageId,
      accountApiUsage: accountApiUsage is _i5.AccountApiUsage?
          ? accountApiUsage
          : this.accountApiUsage?.copyWith(),
      planTier: planTier ?? this.planTier,
    );
  }
}

class AccountInfoTable extends _i1.Table<int?> {
  AccountInfoTable({super.tableRelation}) : super(tableName: 'account_info') {
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    accountApiKeyId = _i1.ColumnInt(
      'accountApiKeyId',
      this,
    );
    accountApiUsageId = _i1.ColumnInt(
      'accountApiUsageId',
      this,
    );
    planTier = _i1.ColumnEnum(
      'planTier',
      this,
      _i1.EnumSerialization.byIndex,
    );
  }

  _i2.ScrappableTable? ___scrappables;

  _i1.ManyRelation<_i2.ScrappableTable>? _scrappables;

  late final _i1.ColumnInt userInfoId;

  _i3.UserInfoTable? _userInfo;

  late final _i1.ColumnInt accountApiKeyId;

  _i4.AccountApiKeyTable? _accountApiKey;

  late final _i1.ColumnInt accountApiUsageId;

  _i5.AccountApiUsageTable? _accountApiUsage;

  late final _i1.ColumnEnum<_i6.PlanTier> planTier;

  _i2.ScrappableTable get __scrappables {
    if (___scrappables != null) return ___scrappables!;
    ___scrappables = _i1.createRelationTable(
      relationFieldName: '__scrappables',
      field: AccountInfo.t.id,
      foreignField: _i2.Scrappable.t.accountId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ScrappableTable(tableRelation: foreignTableRelation),
    );
    return ___scrappables!;
  }

  _i3.UserInfoTable get userInfo {
    if (_userInfo != null) return _userInfo!;
    _userInfo = _i1.createRelationTable(
      relationFieldName: 'userInfo',
      field: AccountInfo.t.userInfoId,
      foreignField: _i3.UserInfo.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.UserInfoTable(tableRelation: foreignTableRelation),
    );
    return _userInfo!;
  }

  _i4.AccountApiKeyTable get accountApiKey {
    if (_accountApiKey != null) return _accountApiKey!;
    _accountApiKey = _i1.createRelationTable(
      relationFieldName: 'accountApiKey',
      field: AccountInfo.t.accountApiKeyId,
      foreignField: _i4.AccountApiKey.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.AccountApiKeyTable(tableRelation: foreignTableRelation),
    );
    return _accountApiKey!;
  }

  _i5.AccountApiUsageTable get accountApiUsage {
    if (_accountApiUsage != null) return _accountApiUsage!;
    _accountApiUsage = _i1.createRelationTable(
      relationFieldName: 'accountApiUsage',
      field: AccountInfo.t.accountApiUsageId,
      foreignField: _i5.AccountApiUsage.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.AccountApiUsageTable(tableRelation: foreignTableRelation),
    );
    return _accountApiUsage!;
  }

  _i1.ManyRelation<_i2.ScrappableTable> get scrappables {
    if (_scrappables != null) return _scrappables!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'scrappables',
      field: AccountInfo.t.id,
      foreignField: _i2.Scrappable.t.accountId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ScrappableTable(tableRelation: foreignTableRelation),
    );
    _scrappables = _i1.ManyRelation<_i2.ScrappableTable>(
      tableWithRelations: relationTable,
      table: _i2.ScrappableTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _scrappables!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        userInfoId,
        accountApiKeyId,
        accountApiUsageId,
        planTier,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'scrappables') {
      return __scrappables;
    }
    if (relationField == 'userInfo') {
      return userInfo;
    }
    if (relationField == 'accountApiKey') {
      return accountApiKey;
    }
    if (relationField == 'accountApiUsage') {
      return accountApiUsage;
    }
    return null;
  }
}

class AccountInfoInclude extends _i1.IncludeObject {
  AccountInfoInclude._({
    _i2.ScrappableIncludeList? scrappables,
    _i3.UserInfoInclude? userInfo,
    _i4.AccountApiKeyInclude? accountApiKey,
    _i5.AccountApiUsageInclude? accountApiUsage,
  }) {
    _scrappables = scrappables;
    _userInfo = userInfo;
    _accountApiKey = accountApiKey;
    _accountApiUsage = accountApiUsage;
  }

  _i2.ScrappableIncludeList? _scrappables;

  _i3.UserInfoInclude? _userInfo;

  _i4.AccountApiKeyInclude? _accountApiKey;

  _i5.AccountApiUsageInclude? _accountApiUsage;

  @override
  Map<String, _i1.Include?> get includes => {
        'scrappables': _scrappables,
        'userInfo': _userInfo,
        'accountApiKey': _accountApiKey,
        'accountApiUsage': _accountApiUsage,
      };

  @override
  _i1.Table<int?> get table => AccountInfo.t;
}

class AccountInfoIncludeList extends _i1.IncludeList {
  AccountInfoIncludeList._({
    _i1.WhereExpressionBuilder<AccountInfoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountInfo.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountInfo.t;
}

class AccountInfoRepository {
  const AccountInfoRepository._();

  final attach = const AccountInfoAttachRepository._();

  final attachRow = const AccountInfoAttachRowRepository._();

  final detach = const AccountInfoDetachRepository._();

  final detachRow = const AccountInfoDetachRowRepository._();

  /// Returns a list of [AccountInfo]s matching the given query parameters.
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
  Future<List<AccountInfo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountInfoTable>? orderByList,
    _i1.Transaction? transaction,
    AccountInfoInclude? include,
  }) async {
    return session.db.find<AccountInfo>(
      where: where?.call(AccountInfo.t),
      orderBy: orderBy?.call(AccountInfo.t),
      orderByList: orderByList?.call(AccountInfo.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AccountInfo] matching the given query parameters.
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
  Future<AccountInfo?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountInfoTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountInfoTable>? orderByList,
    _i1.Transaction? transaction,
    AccountInfoInclude? include,
  }) async {
    return session.db.findFirstRow<AccountInfo>(
      where: where?.call(AccountInfo.t),
      orderBy: orderBy?.call(AccountInfo.t),
      orderByList: orderByList?.call(AccountInfo.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AccountInfo] by its [id] or null if no such row exists.
  Future<AccountInfo?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AccountInfoInclude? include,
  }) async {
    return session.db.findById<AccountInfo>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AccountInfo]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountInfo]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AccountInfo>> insert(
    _i1.Session session,
    List<AccountInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AccountInfo>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AccountInfo] and returns the inserted row.
  ///
  /// The returned [AccountInfo] will have its `id` field set.
  Future<AccountInfo> insertRow(
    _i1.Session session,
    AccountInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountInfo>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountInfo]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountInfo>> update(
    _i1.Session session,
    List<AccountInfo> rows, {
    _i1.ColumnSelections<AccountInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountInfo>(
      rows,
      columns: columns?.call(AccountInfo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountInfo]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountInfo> updateRow(
    _i1.Session session,
    AccountInfo row, {
    _i1.ColumnSelections<AccountInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountInfo>(
      row,
      columns: columns?.call(AccountInfo.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AccountInfo]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountInfo>> delete(
    _i1.Session session,
    List<AccountInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountInfo>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountInfo].
  Future<AccountInfo> deleteRow(
    _i1.Session session,
    AccountInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountInfo>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountInfo>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AccountInfoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountInfo>(
      where: where(AccountInfo.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountInfoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountInfo>(
      where: where?.call(AccountInfo.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AccountInfoAttachRepository {
  const AccountInfoAttachRepository._();

  /// Creates a relation between this [AccountInfo] and the given [Scrappable]s
  /// by setting each [Scrappable]'s foreign key `accountId` to refer to this [AccountInfo].
  Future<void> scrappables(
    _i1.Session session,
    AccountInfo accountInfo,
    List<_i2.Scrappable> scrappable, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.any((e) => e.id == null)) {
      throw ArgumentError.notNull('scrappable.id');
    }
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }

    var $scrappable =
        scrappable.map((e) => e.copyWith(accountId: accountInfo.id)).toList();
    await session.db.update<_i2.Scrappable>(
      $scrappable,
      columns: [_i2.Scrappable.t.accountId],
      transaction: transaction,
    );
  }
}

class AccountInfoAttachRowRepository {
  const AccountInfoAttachRowRepository._();

  /// Creates a relation between the given [AccountInfo] and [UserInfo]
  /// by setting the [AccountInfo]'s foreign key `userInfoId` to refer to the [UserInfo].
  Future<void> userInfo(
    _i1.Session session,
    AccountInfo accountInfo,
    _i3.UserInfo userInfo, {
    _i1.Transaction? transaction,
  }) async {
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }
    if (userInfo.id == null) {
      throw ArgumentError.notNull('userInfo.id');
    }

    var $accountInfo = accountInfo.copyWith(userInfoId: userInfo.id);
    await session.db.updateRow<AccountInfo>(
      $accountInfo,
      columns: [AccountInfo.t.userInfoId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AccountInfo] and [AccountApiKey]
  /// by setting the [AccountInfo]'s foreign key `accountApiKeyId` to refer to the [AccountApiKey].
  Future<void> accountApiKey(
    _i1.Session session,
    AccountInfo accountInfo,
    _i4.AccountApiKey accountApiKey, {
    _i1.Transaction? transaction,
  }) async {
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }
    if (accountApiKey.id == null) {
      throw ArgumentError.notNull('accountApiKey.id');
    }

    var $accountInfo = accountInfo.copyWith(accountApiKeyId: accountApiKey.id);
    await session.db.updateRow<AccountInfo>(
      $accountInfo,
      columns: [AccountInfo.t.accountApiKeyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AccountInfo] and [AccountApiUsage]
  /// by setting the [AccountInfo]'s foreign key `accountApiUsageId` to refer to the [AccountApiUsage].
  Future<void> accountApiUsage(
    _i1.Session session,
    AccountInfo accountInfo,
    _i5.AccountApiUsage accountApiUsage, {
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
    await session.db.updateRow<AccountInfo>(
      $accountInfo,
      columns: [AccountInfo.t.accountApiUsageId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [AccountInfo] and the given [Scrappable]
  /// by setting the [Scrappable]'s foreign key `accountId` to refer to this [AccountInfo].
  Future<void> scrappables(
    _i1.Session session,
    AccountInfo accountInfo,
    _i2.Scrappable scrappable, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }

    var $scrappable = scrappable.copyWith(accountId: accountInfo.id);
    await session.db.updateRow<_i2.Scrappable>(
      $scrappable,
      columns: [_i2.Scrappable.t.accountId],
      transaction: transaction,
    );
  }
}

class AccountInfoDetachRepository {
  const AccountInfoDetachRepository._();

  /// Detaches the relation between this [AccountInfo] and the given [Scrappable]
  /// by setting the [Scrappable]'s foreign key `accountId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> scrappables(
    _i1.Session session,
    List<_i2.Scrappable> scrappable, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.any((e) => e.id == null)) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $scrappable =
        scrappable.map((e) => e.copyWith(accountId: null)).toList();
    await session.db.update<_i2.Scrappable>(
      $scrappable,
      columns: [_i2.Scrappable.t.accountId],
      transaction: transaction,
    );
  }
}

class AccountInfoDetachRowRepository {
  const AccountInfoDetachRowRepository._();

  /// Detaches the relation between this [AccountInfo] and the given [Scrappable]
  /// by setting the [Scrappable]'s foreign key `accountId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> scrappables(
    _i1.Session session,
    _i2.Scrappable scrappable, {
    _i1.Transaction? transaction,
  }) async {
    if (scrappable.id == null) {
      throw ArgumentError.notNull('scrappable.id');
    }

    var $scrappable = scrappable.copyWith(accountId: null);
    await session.db.updateRow<_i2.Scrappable>(
      $scrappable,
      columns: [_i2.Scrappable.t.accountId],
      transaction: transaction,
    );
  }
}
