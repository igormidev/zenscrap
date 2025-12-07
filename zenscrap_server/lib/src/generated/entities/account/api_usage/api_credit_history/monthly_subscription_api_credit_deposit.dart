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
import '../../../../entities/account/plan_tier.dart' as _i2;

abstract class MonthlySubscriptionApiCreditDeposit
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MonthlySubscriptionApiCreditDeposit._({
    this.id,
    required this.creditsAmount,
    required this.planTier,
  });

  factory MonthlySubscriptionApiCreditDeposit({
    int? id,
    required int creditsAmount,
    required _i2.PlanTier planTier,
  }) = _MonthlySubscriptionApiCreditDepositImpl;

  factory MonthlySubscriptionApiCreditDeposit.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return MonthlySubscriptionApiCreditDeposit(
      id: jsonSerialization['id'] as int?,
      creditsAmount: jsonSerialization['creditsAmount'] as int,
      planTier: _i2.PlanTier.fromJson((jsonSerialization['planTier'] as int)),
    );
  }

  static final t = MonthlySubscriptionApiCreditDepositTable();

  static const db = MonthlySubscriptionApiCreditDepositRepository._();

  @override
  int? id;

  int creditsAmount;

  _i2.PlanTier planTier;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MonthlySubscriptionApiCreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonthlySubscriptionApiCreditDeposit copyWith({
    int? id,
    int? creditsAmount,
    _i2.PlanTier? planTier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'creditsAmount': creditsAmount,
      'planTier': planTier.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'creditsAmount': creditsAmount,
      'planTier': planTier.toJson(),
    };
  }

  static MonthlySubscriptionApiCreditDepositInclude include() {
    return MonthlySubscriptionApiCreditDepositInclude._();
  }

  static MonthlySubscriptionApiCreditDepositIncludeList includeList({
    _i1.WhereExpressionBuilder<MonthlySubscriptionApiCreditDepositTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlySubscriptionApiCreditDepositTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlySubscriptionApiCreditDepositTable>?
        orderByList,
    MonthlySubscriptionApiCreditDepositInclude? include,
  }) {
    return MonthlySubscriptionApiCreditDepositIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MonthlySubscriptionApiCreditDeposit.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MonthlySubscriptionApiCreditDeposit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MonthlySubscriptionApiCreditDepositImpl
    extends MonthlySubscriptionApiCreditDeposit {
  _MonthlySubscriptionApiCreditDepositImpl({
    int? id,
    required int creditsAmount,
    required _i2.PlanTier planTier,
  }) : super._(
          id: id,
          creditsAmount: creditsAmount,
          planTier: planTier,
        );

  /// Returns a shallow copy of this [MonthlySubscriptionApiCreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonthlySubscriptionApiCreditDeposit copyWith({
    Object? id = _Undefined,
    int? creditsAmount,
    _i2.PlanTier? planTier,
  }) {
    return MonthlySubscriptionApiCreditDeposit(
      id: id is int? ? id : this.id,
      creditsAmount: creditsAmount ?? this.creditsAmount,
      planTier: planTier ?? this.planTier,
    );
  }
}

class MonthlySubscriptionApiCreditDepositTable extends _i1.Table<int?> {
  MonthlySubscriptionApiCreditDepositTable({super.tableRelation})
      : super(tableName: 'monthly_subscription_api_credit_deposit') {
    creditsAmount = _i1.ColumnInt(
      'creditsAmount',
      this,
    );
    planTier = _i1.ColumnEnum(
      'planTier',
      this,
      _i1.EnumSerialization.byIndex,
    );
  }

  late final _i1.ColumnInt creditsAmount;

  late final _i1.ColumnEnum<_i2.PlanTier> planTier;

  @override
  List<_i1.Column> get columns => [
        id,
        creditsAmount,
        planTier,
      ];
}

class MonthlySubscriptionApiCreditDepositInclude extends _i1.IncludeObject {
  MonthlySubscriptionApiCreditDepositInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MonthlySubscriptionApiCreditDeposit.t;
}

class MonthlySubscriptionApiCreditDepositIncludeList extends _i1.IncludeList {
  MonthlySubscriptionApiCreditDepositIncludeList._({
    _i1.WhereExpressionBuilder<MonthlySubscriptionApiCreditDepositTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MonthlySubscriptionApiCreditDeposit.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MonthlySubscriptionApiCreditDeposit.t;
}

class MonthlySubscriptionApiCreditDepositRepository {
  const MonthlySubscriptionApiCreditDepositRepository._();

  /// Returns a list of [MonthlySubscriptionApiCreditDeposit]s matching the given query parameters.
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
  Future<List<MonthlySubscriptionApiCreditDeposit>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlySubscriptionApiCreditDepositTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlySubscriptionApiCreditDepositTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlySubscriptionApiCreditDepositTable>?
        orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MonthlySubscriptionApiCreditDeposit>(
      where: where?.call(MonthlySubscriptionApiCreditDeposit.t),
      orderBy: orderBy?.call(MonthlySubscriptionApiCreditDeposit.t),
      orderByList: orderByList?.call(MonthlySubscriptionApiCreditDeposit.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MonthlySubscriptionApiCreditDeposit] matching the given query parameters.
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
  Future<MonthlySubscriptionApiCreditDeposit?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlySubscriptionApiCreditDepositTable>? where,
    int? offset,
    _i1.OrderByBuilder<MonthlySubscriptionApiCreditDepositTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlySubscriptionApiCreditDepositTable>?
        orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MonthlySubscriptionApiCreditDeposit>(
      where: where?.call(MonthlySubscriptionApiCreditDeposit.t),
      orderBy: orderBy?.call(MonthlySubscriptionApiCreditDeposit.t),
      orderByList: orderByList?.call(MonthlySubscriptionApiCreditDeposit.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MonthlySubscriptionApiCreditDeposit] by its [id] or null if no such row exists.
  Future<MonthlySubscriptionApiCreditDeposit?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MonthlySubscriptionApiCreditDeposit>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MonthlySubscriptionApiCreditDeposit]s in the list and returns the inserted rows.
  ///
  /// The returned [MonthlySubscriptionApiCreditDeposit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MonthlySubscriptionApiCreditDeposit>> insert(
    _i1.Session session,
    List<MonthlySubscriptionApiCreditDeposit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MonthlySubscriptionApiCreditDeposit>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MonthlySubscriptionApiCreditDeposit] and returns the inserted row.
  ///
  /// The returned [MonthlySubscriptionApiCreditDeposit] will have its `id` field set.
  Future<MonthlySubscriptionApiCreditDeposit> insertRow(
    _i1.Session session,
    MonthlySubscriptionApiCreditDeposit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MonthlySubscriptionApiCreditDeposit>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MonthlySubscriptionApiCreditDeposit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MonthlySubscriptionApiCreditDeposit>> update(
    _i1.Session session,
    List<MonthlySubscriptionApiCreditDeposit> rows, {
    _i1.ColumnSelections<MonthlySubscriptionApiCreditDepositTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MonthlySubscriptionApiCreditDeposit>(
      rows,
      columns: columns?.call(MonthlySubscriptionApiCreditDeposit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MonthlySubscriptionApiCreditDeposit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MonthlySubscriptionApiCreditDeposit> updateRow(
    _i1.Session session,
    MonthlySubscriptionApiCreditDeposit row, {
    _i1.ColumnSelections<MonthlySubscriptionApiCreditDepositTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MonthlySubscriptionApiCreditDeposit>(
      row,
      columns: columns?.call(MonthlySubscriptionApiCreditDeposit.t),
      transaction: transaction,
    );
  }

  /// Deletes all [MonthlySubscriptionApiCreditDeposit]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MonthlySubscriptionApiCreditDeposit>> delete(
    _i1.Session session,
    List<MonthlySubscriptionApiCreditDeposit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MonthlySubscriptionApiCreditDeposit>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MonthlySubscriptionApiCreditDeposit].
  Future<MonthlySubscriptionApiCreditDeposit> deleteRow(
    _i1.Session session,
    MonthlySubscriptionApiCreditDeposit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MonthlySubscriptionApiCreditDeposit>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MonthlySubscriptionApiCreditDeposit>> deleteWhere(
    _i1.Session session, {
    required _i1
        .WhereExpressionBuilder<MonthlySubscriptionApiCreditDepositTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MonthlySubscriptionApiCreditDeposit>(
      where: where(MonthlySubscriptionApiCreditDeposit.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlySubscriptionApiCreditDepositTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MonthlySubscriptionApiCreditDeposit>(
      where: where?.call(MonthlySubscriptionApiCreditDeposit.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
