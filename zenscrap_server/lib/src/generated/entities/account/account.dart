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
import '../../entities/scrappable/scrappable.dart' as _i2;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i3;
import '../../entities/account/api_usage/account_api_usage.dart' as _i4;
import '../../entities/account/plan_tier.dart' as _i5;
import '../../entities/account/ai_usage/account_ai_usage.dart' as _i6;
import 'package:zenscrap_server/src/generated/protocol.dart' as _i7;

abstract class AccountInfo
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountInfo._({
    this.id,
    this.scrappables,
    required this.authUserId,
    this.authUser,
    required this.accountApiUsageId,
    this.accountApiUsage,
    required this.planTier,
    this.stripeCustomerId,
    this.stripeSubscriptionId,
    this.subscriptionStatus,
    this.subscriptionEndDate,
    required this.accountAIUsageId,
    this.accountAIUsage,
  });

  factory AccountInfo({
    int? id,
    List<_i2.Scrappable>? scrappables,
    required _i1.UuidValue authUserId,
    _i3.AuthUser? authUser,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
    required _i5.PlanTier planTier,
    String? stripeCustomerId,
    String? stripeSubscriptionId,
    String? subscriptionStatus,
    DateTime? subscriptionEndDate,
    required int accountAIUsageId,
    _i6.AccountAIUsage? accountAIUsage,
  }) = _AccountInfoImpl;

  factory AccountInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountInfo(
      id: jsonSerialization['id'] as int?,
      scrappables: jsonSerialization['scrappables'] == null
          ? null
          : _i7.Protocol().deserialize<List<_i2.Scrappable>>(
              jsonSerialization['scrappables'],
            ),
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _i7.Protocol().deserialize<_i3.AuthUser>(
              jsonSerialization['authUser'],
            ),
      accountApiUsageId: jsonSerialization['accountApiUsageId'] as int,
      accountApiUsage: jsonSerialization['accountApiUsage'] == null
          ? null
          : _i7.Protocol().deserialize<_i4.AccountApiUsage>(
              jsonSerialization['accountApiUsage'],
            ),
      planTier: _i5.PlanTier.fromJson((jsonSerialization['planTier'] as int)),
      stripeCustomerId: jsonSerialization['stripeCustomerId'] as String?,
      stripeSubscriptionId:
          jsonSerialization['stripeSubscriptionId'] as String?,
      subscriptionStatus: jsonSerialization['subscriptionStatus'] as String?,
      subscriptionEndDate: jsonSerialization['subscriptionEndDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['subscriptionEndDate'],
            ),
      accountAIUsageId: jsonSerialization['accountAIUsageId'] as int,
      accountAIUsage: jsonSerialization['accountAIUsage'] == null
          ? null
          : _i7.Protocol().deserialize<_i6.AccountAIUsage>(
              jsonSerialization['accountAIUsage'],
            ),
    );
  }

  static final t = AccountInfoTable();

  static const db = AccountInfoRepository._();

  @override
  int? id;

  List<_i2.Scrappable>? scrappables;

  _i1.UuidValue authUserId;

  _i3.AuthUser? authUser;

  int accountApiUsageId;

  _i4.AccountApiUsage? accountApiUsage;

  _i5.PlanTier planTier;

  String? stripeCustomerId;

  String? stripeSubscriptionId;

  String? subscriptionStatus;

  DateTime? subscriptionEndDate;

  int accountAIUsageId;

  _i6.AccountAIUsage? accountAIUsage;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountInfo copyWith({
    int? id,
    List<_i2.Scrappable>? scrappables,
    _i1.UuidValue? authUserId,
    _i3.AuthUser? authUser,
    int? accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
    _i5.PlanTier? planTier,
    String? stripeCustomerId,
    String? stripeSubscriptionId,
    String? subscriptionStatus,
    DateTime? subscriptionEndDate,
    int? accountAIUsageId,
    _i6.AccountAIUsage? accountAIUsage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AccountInfo',
      if (id != null) 'id': id,
      if (scrappables != null)
        'scrappables': scrappables?.toJson(valueToJson: (v) => v.toJson()),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'accountApiUsageId': accountApiUsageId,
      if (accountApiUsage != null) 'accountApiUsage': accountApiUsage?.toJson(),
      'planTier': planTier.toJson(),
      if (stripeCustomerId != null) 'stripeCustomerId': stripeCustomerId,
      if (stripeSubscriptionId != null)
        'stripeSubscriptionId': stripeSubscriptionId,
      if (subscriptionStatus != null) 'subscriptionStatus': subscriptionStatus,
      if (subscriptionEndDate != null)
        'subscriptionEndDate': subscriptionEndDate?.toJson(),
      'accountAIUsageId': accountAIUsageId,
      if (accountAIUsage != null) 'accountAIUsage': accountAIUsage?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AccountInfo',
      if (id != null) 'id': id,
      if (scrappables != null)
        'scrappables': scrappables?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJsonForProtocol(),
      'accountApiUsageId': accountApiUsageId,
      if (accountApiUsage != null)
        'accountApiUsage': accountApiUsage?.toJsonForProtocol(),
      'planTier': planTier.toJson(),
      if (stripeCustomerId != null) 'stripeCustomerId': stripeCustomerId,
      if (stripeSubscriptionId != null)
        'stripeSubscriptionId': stripeSubscriptionId,
      if (subscriptionStatus != null) 'subscriptionStatus': subscriptionStatus,
      if (subscriptionEndDate != null)
        'subscriptionEndDate': subscriptionEndDate?.toJson(),
      'accountAIUsageId': accountAIUsageId,
      if (accountAIUsage != null)
        'accountAIUsage': accountAIUsage?.toJsonForProtocol(),
    };
  }

  static AccountInfoInclude include({
    _i2.ScrappableIncludeList? scrappables,
    _i3.AuthUserInclude? authUser,
    _i4.AccountApiUsageInclude? accountApiUsage,
    _i6.AccountAIUsageInclude? accountAIUsage,
  }) {
    return AccountInfoInclude._(
      scrappables: scrappables,
      authUser: authUser,
      accountApiUsage: accountApiUsage,
      accountAIUsage: accountAIUsage,
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
    required _i1.UuidValue authUserId,
    _i3.AuthUser? authUser,
    required int accountApiUsageId,
    _i4.AccountApiUsage? accountApiUsage,
    required _i5.PlanTier planTier,
    String? stripeCustomerId,
    String? stripeSubscriptionId,
    String? subscriptionStatus,
    DateTime? subscriptionEndDate,
    required int accountAIUsageId,
    _i6.AccountAIUsage? accountAIUsage,
  }) : super._(
         id: id,
         scrappables: scrappables,
         authUserId: authUserId,
         authUser: authUser,
         accountApiUsageId: accountApiUsageId,
         accountApiUsage: accountApiUsage,
         planTier: planTier,
         stripeCustomerId: stripeCustomerId,
         stripeSubscriptionId: stripeSubscriptionId,
         subscriptionStatus: subscriptionStatus,
         subscriptionEndDate: subscriptionEndDate,
         accountAIUsageId: accountAIUsageId,
         accountAIUsage: accountAIUsage,
       );

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountInfo copyWith({
    Object? id = _Undefined,
    Object? scrappables = _Undefined,
    _i1.UuidValue? authUserId,
    Object? authUser = _Undefined,
    int? accountApiUsageId,
    Object? accountApiUsage = _Undefined,
    _i5.PlanTier? planTier,
    Object? stripeCustomerId = _Undefined,
    Object? stripeSubscriptionId = _Undefined,
    Object? subscriptionStatus = _Undefined,
    Object? subscriptionEndDate = _Undefined,
    int? accountAIUsageId,
    Object? accountAIUsage = _Undefined,
  }) {
    return AccountInfo(
      id: id is int? ? id : this.id,
      scrappables: scrappables is List<_i2.Scrappable>?
          ? scrappables
          : this.scrappables?.map((e0) => e0.copyWith()).toList(),
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _i3.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      accountApiUsageId: accountApiUsageId ?? this.accountApiUsageId,
      accountApiUsage: accountApiUsage is _i4.AccountApiUsage?
          ? accountApiUsage
          : this.accountApiUsage?.copyWith(),
      planTier: planTier ?? this.planTier,
      stripeCustomerId: stripeCustomerId is String?
          ? stripeCustomerId
          : this.stripeCustomerId,
      stripeSubscriptionId: stripeSubscriptionId is String?
          ? stripeSubscriptionId
          : this.stripeSubscriptionId,
      subscriptionStatus: subscriptionStatus is String?
          ? subscriptionStatus
          : this.subscriptionStatus,
      subscriptionEndDate: subscriptionEndDate is DateTime?
          ? subscriptionEndDate
          : this.subscriptionEndDate,
      accountAIUsageId: accountAIUsageId ?? this.accountAIUsageId,
      accountAIUsage: accountAIUsage is _i6.AccountAIUsage?
          ? accountAIUsage
          : this.accountAIUsage?.copyWith(),
    );
  }
}

class AccountInfoUpdateTable extends _i1.UpdateTable<AccountInfoTable> {
  AccountInfoUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> authUserId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.authUserId,
    value,
  );

  _i1.ColumnValue<int, int> accountApiUsageId(int value) => _i1.ColumnValue(
    table.accountApiUsageId,
    value,
  );

  _i1.ColumnValue<_i5.PlanTier, _i5.PlanTier> planTier(_i5.PlanTier value) =>
      _i1.ColumnValue(
        table.planTier,
        value,
      );

  _i1.ColumnValue<String, String> stripeCustomerId(String? value) =>
      _i1.ColumnValue(
        table.stripeCustomerId,
        value,
      );

  _i1.ColumnValue<String, String> stripeSubscriptionId(String? value) =>
      _i1.ColumnValue(
        table.stripeSubscriptionId,
        value,
      );

  _i1.ColumnValue<String, String> subscriptionStatus(String? value) =>
      _i1.ColumnValue(
        table.subscriptionStatus,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> subscriptionEndDate(DateTime? value) =>
      _i1.ColumnValue(
        table.subscriptionEndDate,
        value,
      );

  _i1.ColumnValue<int, int> accountAIUsageId(int value) => _i1.ColumnValue(
    table.accountAIUsageId,
    value,
  );
}

class AccountInfoTable extends _i1.Table<int?> {
  AccountInfoTable({super.tableRelation}) : super(tableName: 'account_info') {
    updateTable = AccountInfoUpdateTable(this);
    authUserId = _i1.ColumnUuid(
      'authUserId',
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
    stripeCustomerId = _i1.ColumnString(
      'stripeCustomerId',
      this,
    );
    stripeSubscriptionId = _i1.ColumnString(
      'stripeSubscriptionId',
      this,
    );
    subscriptionStatus = _i1.ColumnString(
      'subscriptionStatus',
      this,
    );
    subscriptionEndDate = _i1.ColumnDateTime(
      'subscriptionEndDate',
      this,
    );
    accountAIUsageId = _i1.ColumnInt(
      'accountAIUsageId',
      this,
    );
  }

  late final AccountInfoUpdateTable updateTable;

  _i2.ScrappableTable? ___scrappables;

  _i1.ManyRelation<_i2.ScrappableTable>? _scrappables;

  late final _i1.ColumnUuid authUserId;

  _i3.AuthUserTable? _authUser;

  late final _i1.ColumnInt accountApiUsageId;

  _i4.AccountApiUsageTable? _accountApiUsage;

  late final _i1.ColumnEnum<_i5.PlanTier> planTier;

  late final _i1.ColumnString stripeCustomerId;

  late final _i1.ColumnString stripeSubscriptionId;

  late final _i1.ColumnString subscriptionStatus;

  late final _i1.ColumnDateTime subscriptionEndDate;

  late final _i1.ColumnInt accountAIUsageId;

  _i6.AccountAIUsageTable? _accountAIUsage;

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

  _i3.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _i1.createRelationTable(
      relationFieldName: 'authUser',
      field: AccountInfo.t.authUserId,
      foreignField: _i3.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  _i4.AccountApiUsageTable get accountApiUsage {
    if (_accountApiUsage != null) return _accountApiUsage!;
    _accountApiUsage = _i1.createRelationTable(
      relationFieldName: 'accountApiUsage',
      field: AccountInfo.t.accountApiUsageId,
      foreignField: _i4.AccountApiUsage.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.AccountApiUsageTable(tableRelation: foreignTableRelation),
    );
    return _accountApiUsage!;
  }

  _i6.AccountAIUsageTable get accountAIUsage {
    if (_accountAIUsage != null) return _accountAIUsage!;
    _accountAIUsage = _i1.createRelationTable(
      relationFieldName: 'accountAIUsage',
      field: AccountInfo.t.accountAIUsageId,
      foreignField: _i6.AccountAIUsage.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6.AccountAIUsageTable(tableRelation: foreignTableRelation),
    );
    return _accountAIUsage!;
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
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _scrappables!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    authUserId,
    accountApiUsageId,
    planTier,
    stripeCustomerId,
    stripeSubscriptionId,
    subscriptionStatus,
    subscriptionEndDate,
    accountAIUsageId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'scrappables') {
      return __scrappables;
    }
    if (relationField == 'authUser') {
      return authUser;
    }
    if (relationField == 'accountApiUsage') {
      return accountApiUsage;
    }
    if (relationField == 'accountAIUsage') {
      return accountAIUsage;
    }
    return null;
  }
}

class AccountInfoInclude extends _i1.IncludeObject {
  AccountInfoInclude._({
    _i2.ScrappableIncludeList? scrappables,
    _i3.AuthUserInclude? authUser,
    _i4.AccountApiUsageInclude? accountApiUsage,
    _i6.AccountAIUsageInclude? accountAIUsage,
  }) {
    _scrappables = scrappables;
    _authUser = authUser;
    _accountApiUsage = accountApiUsage;
    _accountAIUsage = accountAIUsage;
  }

  _i2.ScrappableIncludeList? _scrappables;

  _i3.AuthUserInclude? _authUser;

  _i4.AccountApiUsageInclude? _accountApiUsage;

  _i6.AccountAIUsageInclude? _accountAIUsage;

  @override
  Map<String, _i1.Include?> get includes => {
    'scrappables': _scrappables,
    'authUser': _authUser,
    'accountApiUsage': _accountApiUsage,
    'accountAIUsage': _accountAIUsage,
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

  /// Updates a single [AccountInfo] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AccountInfo?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AccountInfoUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AccountInfo>(
      id,
      columnValues: columnValues(AccountInfo.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AccountInfo]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AccountInfo>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AccountInfoUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AccountInfoTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountInfoTable>? orderBy,
    _i1.OrderByListBuilder<AccountInfoTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AccountInfo>(
      columnValues: columnValues(AccountInfo.t.updateTable),
      where: where(AccountInfo.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountInfo.t),
      orderByList: orderByList?.call(AccountInfo.t),
      orderDescending: orderDescending,
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

    var $scrappable = scrappable
        .map((e) => e.copyWith(accountId: accountInfo.id))
        .toList();
    await session.db.update<_i2.Scrappable>(
      $scrappable,
      columns: [_i2.Scrappable.t.accountId],
      transaction: transaction,
    );
  }
}

class AccountInfoAttachRowRepository {
  const AccountInfoAttachRowRepository._();

  /// Creates a relation between the given [AccountInfo] and [AuthUser]
  /// by setting the [AccountInfo]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _i1.Session session,
    AccountInfo accountInfo,
    _i3.AuthUser authUser, {
    _i1.Transaction? transaction,
  }) async {
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $accountInfo = accountInfo.copyWith(authUserId: authUser.id);
    await session.db.updateRow<AccountInfo>(
      $accountInfo,
      columns: [AccountInfo.t.authUserId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AccountInfo] and [AccountApiUsage]
  /// by setting the [AccountInfo]'s foreign key `accountApiUsageId` to refer to the [AccountApiUsage].
  Future<void> accountApiUsage(
    _i1.Session session,
    AccountInfo accountInfo,
    _i4.AccountApiUsage accountApiUsage, {
    _i1.Transaction? transaction,
  }) async {
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }
    if (accountApiUsage.id == null) {
      throw ArgumentError.notNull('accountApiUsage.id');
    }

    var $accountInfo = accountInfo.copyWith(
      accountApiUsageId: accountApiUsage.id,
    );
    await session.db.updateRow<AccountInfo>(
      $accountInfo,
      columns: [AccountInfo.t.accountApiUsageId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AccountInfo] and [AccountAIUsage]
  /// by setting the [AccountInfo]'s foreign key `accountAIUsageId` to refer to the [AccountAIUsage].
  Future<void> accountAIUsage(
    _i1.Session session,
    AccountInfo accountInfo,
    _i6.AccountAIUsage accountAIUsage, {
    _i1.Transaction? transaction,
  }) async {
    if (accountInfo.id == null) {
      throw ArgumentError.notNull('accountInfo.id');
    }
    if (accountAIUsage.id == null) {
      throw ArgumentError.notNull('accountAIUsage.id');
    }

    var $accountInfo = accountInfo.copyWith(
      accountAIUsageId: accountAIUsage.id,
    );
    await session.db.updateRow<AccountInfo>(
      $accountInfo,
      columns: [AccountInfo.t.accountAIUsageId],
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

    var $scrappable = scrappable
        .map((e) => e.copyWith(accountId: null))
        .toList();
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
