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

abstract class AccountApiKey
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AccountApiKey._({
    this.id,
    required this.apiKey,
  });

  factory AccountApiKey({
    int? id,
    required String apiKey,
  }) = _AccountApiKeyImpl;

  factory AccountApiKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return AccountApiKey(
      id: jsonSerialization['id'] as int?,
      apiKey: jsonSerialization['apiKey'] as String,
    );
  }

  static final t = AccountApiKeyTable();

  static const db = AccountApiKeyRepository._();

  @override
  int? id;

  String apiKey;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AccountApiKey]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AccountApiKey copyWith({
    int? id,
    String? apiKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'apiKey': apiKey,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'apiKey': apiKey,
    };
  }

  static AccountApiKeyInclude include() {
    return AccountApiKeyInclude._();
  }

  static AccountApiKeyIncludeList includeList({
    _i1.WhereExpressionBuilder<AccountApiKeyTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountApiKeyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountApiKeyTable>? orderByList,
    AccountApiKeyInclude? include,
  }) {
    return AccountApiKeyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AccountApiKey.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AccountApiKey.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountApiKeyImpl extends AccountApiKey {
  _AccountApiKeyImpl({
    int? id,
    required String apiKey,
  }) : super._(
          id: id,
          apiKey: apiKey,
        );

  /// Returns a shallow copy of this [AccountApiKey]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AccountApiKey copyWith({
    Object? id = _Undefined,
    String? apiKey,
  }) {
    return AccountApiKey(
      id: id is int? ? id : this.id,
      apiKey: apiKey ?? this.apiKey,
    );
  }
}

class AccountApiKeyTable extends _i1.Table<int?> {
  AccountApiKeyTable({super.tableRelation})
      : super(tableName: 'account_api_key') {
    apiKey = _i1.ColumnString(
      'apiKey',
      this,
    );
  }

  late final _i1.ColumnString apiKey;

  @override
  List<_i1.Column> get columns => [
        id,
        apiKey,
      ];
}

class AccountApiKeyInclude extends _i1.IncludeObject {
  AccountApiKeyInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AccountApiKey.t;
}

class AccountApiKeyIncludeList extends _i1.IncludeList {
  AccountApiKeyIncludeList._({
    _i1.WhereExpressionBuilder<AccountApiKeyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AccountApiKey.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AccountApiKey.t;
}

class AccountApiKeyRepository {
  const AccountApiKeyRepository._();

  /// Returns a list of [AccountApiKey]s matching the given query parameters.
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
  Future<List<AccountApiKey>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountApiKeyTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AccountApiKeyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountApiKeyTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AccountApiKey>(
      where: where?.call(AccountApiKey.t),
      orderBy: orderBy?.call(AccountApiKey.t),
      orderByList: orderByList?.call(AccountApiKey.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AccountApiKey] matching the given query parameters.
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
  Future<AccountApiKey?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountApiKeyTable>? where,
    int? offset,
    _i1.OrderByBuilder<AccountApiKeyTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AccountApiKeyTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AccountApiKey>(
      where: where?.call(AccountApiKey.t),
      orderBy: orderBy?.call(AccountApiKey.t),
      orderByList: orderByList?.call(AccountApiKey.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AccountApiKey] by its [id] or null if no such row exists.
  Future<AccountApiKey?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AccountApiKey>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AccountApiKey]s in the list and returns the inserted rows.
  ///
  /// The returned [AccountApiKey]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AccountApiKey>> insert(
    _i1.Session session,
    List<AccountApiKey> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AccountApiKey>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AccountApiKey] and returns the inserted row.
  ///
  /// The returned [AccountApiKey] will have its `id` field set.
  Future<AccountApiKey> insertRow(
    _i1.Session session,
    AccountApiKey row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AccountApiKey>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AccountApiKey]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AccountApiKey>> update(
    _i1.Session session,
    List<AccountApiKey> rows, {
    _i1.ColumnSelections<AccountApiKeyTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AccountApiKey>(
      rows,
      columns: columns?.call(AccountApiKey.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AccountApiKey]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AccountApiKey> updateRow(
    _i1.Session session,
    AccountApiKey row, {
    _i1.ColumnSelections<AccountApiKeyTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AccountApiKey>(
      row,
      columns: columns?.call(AccountApiKey.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AccountApiKey]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AccountApiKey>> delete(
    _i1.Session session,
    List<AccountApiKey> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AccountApiKey>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AccountApiKey].
  Future<AccountApiKey> deleteRow(
    _i1.Session session,
    AccountApiKey row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AccountApiKey>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AccountApiKey>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AccountApiKeyTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AccountApiKey>(
      where: where(AccountApiKey.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AccountApiKeyTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AccountApiKey>(
      where: where?.call(AccountApiKey.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
