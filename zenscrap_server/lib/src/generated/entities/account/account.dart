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
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i2;
import '../../entities/account/account_api_key.dart' as _i3;

abstract class AccountInfo
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountInfo._({
    this.id,
    required this.userInfoId,
    this.userInfo,
    required this.accountApiKeyId,
    this.accountApiKey,
  });

  factory AccountInfo({
    int? id,
    required int userInfoId,
    _i2.UserInfo? userInfo,
    required int accountApiKeyId,
    _i3.AccountApiKey? accountApiKey,
  }) = _AccountInfoImpl;

  factory AccountInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountInfo(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      userInfo: jsonSerialization['userInfo'] == null
          ? null
          : _i2.UserInfo.fromJson(
              (jsonSerialization['userInfo'] as Map<String, dynamic>)),
      accountApiKeyId: jsonSerialization['accountApiKeyId'] as int,
      accountApiKey: jsonSerialization['accountApiKey'] == null
          ? null
          : _i3.AccountApiKey.fromJson(
              (jsonSerialization['accountApiKey'] as Map<String, dynamic>)),
    );
  }

  static final t = AccountInfoTable();

  static const db = AccountInfoRepository._();

  @override
  int? id;

  int userInfoId;

  _i2.UserInfo? userInfo;

  int accountApiKeyId;

  _i3.AccountApiKey? accountApiKey;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountInfo copyWith({
    int? id,
    int? userInfoId,
    _i2.UserInfo? userInfo,
    int? accountApiKeyId,
    _i3.AccountApiKey? accountApiKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJson(),
      'accountApiKeyId': accountApiKeyId,
      if (accountApiKey != null) 'accountApiKey': accountApiKey?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      if (userInfo != null) 'userInfo': userInfo?.toJsonForProtocol(),
      'accountApiKeyId': accountApiKeyId,
      if (accountApiKey != null)
        'accountApiKey': accountApiKey?.toJsonForProtocol(),
    };
  }

  static AccountInfoInclude include({
    _i2.UserInfoInclude? userInfo,
    _i3.AccountApiKeyInclude? accountApiKey,
  }) {
    return AccountInfoInclude._(
      userInfo: userInfo,
      accountApiKey: accountApiKey,
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
    required int userInfoId,
    _i2.UserInfo? userInfo,
    required int accountApiKeyId,
    _i3.AccountApiKey? accountApiKey,
  }) : super._(
          id: id,
          userInfoId: userInfoId,
          userInfo: userInfo,
          accountApiKeyId: accountApiKeyId,
          accountApiKey: accountApiKey,
        );

  /// Returns a shallow copy of this [AccountInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountInfo copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    Object? userInfo = _Undefined,
    int? accountApiKeyId,
    Object? accountApiKey = _Undefined,
  }) {
    return AccountInfo(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      userInfo:
          userInfo is _i2.UserInfo? ? userInfo : this.userInfo?.copyWith(),
      accountApiKeyId: accountApiKeyId ?? this.accountApiKeyId,
      accountApiKey: accountApiKey is _i3.AccountApiKey?
          ? accountApiKey
          : this.accountApiKey?.copyWith(),
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
  }

  late final _i1.ColumnInt userInfoId;

  _i2.UserInfoTable? _userInfo;

  late final _i1.ColumnInt accountApiKeyId;

  _i3.AccountApiKeyTable? _accountApiKey;

  _i2.UserInfoTable get userInfo {
    if (_userInfo != null) return _userInfo!;
    _userInfo = _i1.createRelationTable(
      relationFieldName: 'userInfo',
      field: AccountInfo.t.userInfoId,
      foreignField: _i2.UserInfo.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.UserInfoTable(tableRelation: foreignTableRelation),
    );
    return _userInfo!;
  }

  _i3.AccountApiKeyTable get accountApiKey {
    if (_accountApiKey != null) return _accountApiKey!;
    _accountApiKey = _i1.createRelationTable(
      relationFieldName: 'accountApiKey',
      field: AccountInfo.t.accountApiKeyId,
      foreignField: _i3.AccountApiKey.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.AccountApiKeyTable(tableRelation: foreignTableRelation),
    );
    return _accountApiKey!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        userInfoId,
        accountApiKeyId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'userInfo') {
      return userInfo;
    }
    if (relationField == 'accountApiKey') {
      return accountApiKey;
    }
    return null;
  }
}

class AccountInfoInclude extends _i1.IncludeObject {
  AccountInfoInclude._({
    _i2.UserInfoInclude? userInfo,
    _i3.AccountApiKeyInclude? accountApiKey,
  }) {
    _userInfo = userInfo;
    _accountApiKey = accountApiKey;
  }

  _i2.UserInfoInclude? _userInfo;

  _i3.AccountApiKeyInclude? _accountApiKey;

  @override
  Map<String, _i1.Include?> get includes => {
        'userInfo': _userInfo,
        'accountApiKey': _accountApiKey,
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

  final attachRow = const AccountInfoAttachRowRepository._();

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

class AccountInfoAttachRowRepository {
  const AccountInfoAttachRowRepository._();

  /// Creates a relation between the given [AccountInfo] and [UserInfo]
  /// by setting the [AccountInfo]'s foreign key `userInfoId` to refer to the [UserInfo].
  Future<void> userInfo(
    _i1.Session session,
    AccountInfo accountInfo,
    _i2.UserInfo userInfo, {
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
    _i3.AccountApiKey accountApiKey, {
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
}
