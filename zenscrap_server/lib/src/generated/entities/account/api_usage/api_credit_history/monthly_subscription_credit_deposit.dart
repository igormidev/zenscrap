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

abstract class MonthlySubscriptionCreditDeposit
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MonthlySubscriptionCreditDeposit._({
    this.id,
    required this.creditsAmount,
    required this.planTier,
  });

  factory MonthlySubscriptionCreditDeposit({
    int? id,
    required int creditsAmount,
    required _i2.PlanTier planTier,
  }) = _MonthlySubscriptionCreditDepositImpl;

  factory MonthlySubscriptionCreditDeposit.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return MonthlySubscriptionCreditDeposit(
      id: jsonSerialization['id'] as int?,
      creditsAmount: jsonSerialization['creditsAmount'] as int,
      planTier: _i2.PlanTier.fromJson((jsonSerialization['planTier'] as int)),
    );
  }

  static final t = MonthlySubscriptionCreditDepositTable();

  static const db = MonthlySubscriptionCreditDepositRepository._();

  @override
  int? id;

  int creditsAmount;

  _i2.PlanTier planTier;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MonthlySubscriptionCreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonthlySubscriptionCreditDeposit copyWith({
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

  static MonthlySubscriptionCreditDepositInclude include() {
    return MonthlySubscriptionCreditDepositInclude._();
  }

  static MonthlySubscriptionCreditDepositIncludeList includeList({
    _i1.WhereExpressionBuilder<MonthlySubscriptionCreditDepositTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlySubscriptionCreditDepositTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlySubscriptionCreditDepositTable>? orderByList,
    MonthlySubscriptionCreditDepositInclude? include,
  }) {
    return MonthlySubscriptionCreditDepositIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MonthlySubscriptionCreditDeposit.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MonthlySubscriptionCreditDeposit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MonthlySubscriptionCreditDepositImpl
    extends MonthlySubscriptionCreditDeposit {
  _MonthlySubscriptionCreditDepositImpl({
    int? id,
    required int creditsAmount,
    required _i2.PlanTier planTier,
  }) : super._(
          id: id,
          creditsAmount: creditsAmount,
          planTier: planTier,
        );

  /// Returns a shallow copy of this [MonthlySubscriptionCreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonthlySubscriptionCreditDeposit copyWith({
    Object? id = _Undefined,
    int? creditsAmount,
    _i2.PlanTier? planTier,
  }) {
    return MonthlySubscriptionCreditDeposit(
      id: id is int? ? id : this.id,
      creditsAmount: creditsAmount ?? this.creditsAmount,
      planTier: planTier ?? this.planTier,
    );
  }
}

class MonthlySubscriptionCreditDepositTable extends _i1.Table<int?> {
  MonthlySubscriptionCreditDepositTable({super.tableRelation})
      : super(tableName: 'monthly_subscription_credit_deposit') {
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

class MonthlySubscriptionCreditDepositInclude extends _i1.IncludeObject {
  MonthlySubscriptionCreditDepositInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MonthlySubscriptionCreditDeposit.t;
}

class MonthlySubscriptionCreditDepositIncludeList extends _i1.IncludeList {
  MonthlySubscriptionCreditDepositIncludeList._({
    _i1.WhereExpressionBuilder<MonthlySubscriptionCreditDepositTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MonthlySubscriptionCreditDeposit.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MonthlySubscriptionCreditDeposit.t;
}

class MonthlySubscriptionCreditDepositRepository {
  const MonthlySubscriptionCreditDepositRepository._();

  /// Returns a list of [MonthlySubscriptionCreditDeposit]s matching the given query parameters.
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
  Future<List<MonthlySubscriptionCreditDeposit>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlySubscriptionCreditDepositTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlySubscriptionCreditDepositTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlySubscriptionCreditDepositTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MonthlySubscriptionCreditDeposit>(
      where: where?.call(MonthlySubscriptionCreditDeposit.t),
      orderBy: orderBy?.call(MonthlySubscriptionCreditDeposit.t),
      orderByList: orderByList?.call(MonthlySubscriptionCreditDeposit.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MonthlySubscriptionCreditDeposit] matching the given query parameters.
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
  Future<MonthlySubscriptionCreditDeposit?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlySubscriptionCreditDepositTable>? where,
    int? offset,
    _i1.OrderByBuilder<MonthlySubscriptionCreditDepositTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlySubscriptionCreditDepositTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MonthlySubscriptionCreditDeposit>(
      where: where?.call(MonthlySubscriptionCreditDeposit.t),
      orderBy: orderBy?.call(MonthlySubscriptionCreditDeposit.t),
      orderByList: orderByList?.call(MonthlySubscriptionCreditDeposit.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MonthlySubscriptionCreditDeposit] by its [id] or null if no such row exists.
  Future<MonthlySubscriptionCreditDeposit?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MonthlySubscriptionCreditDeposit>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MonthlySubscriptionCreditDeposit]s in the list and returns the inserted rows.
  ///
  /// The returned [MonthlySubscriptionCreditDeposit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MonthlySubscriptionCreditDeposit>> insert(
    _i1.Session session,
    List<MonthlySubscriptionCreditDeposit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MonthlySubscriptionCreditDeposit>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MonthlySubscriptionCreditDeposit] and returns the inserted row.
  ///
  /// The returned [MonthlySubscriptionCreditDeposit] will have its `id` field set.
  Future<MonthlySubscriptionCreditDeposit> insertRow(
    _i1.Session session,
    MonthlySubscriptionCreditDeposit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MonthlySubscriptionCreditDeposit>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MonthlySubscriptionCreditDeposit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MonthlySubscriptionCreditDeposit>> update(
    _i1.Session session,
    List<MonthlySubscriptionCreditDeposit> rows, {
    _i1.ColumnSelections<MonthlySubscriptionCreditDepositTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MonthlySubscriptionCreditDeposit>(
      rows,
      columns: columns?.call(MonthlySubscriptionCreditDeposit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MonthlySubscriptionCreditDeposit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MonthlySubscriptionCreditDeposit> updateRow(
    _i1.Session session,
    MonthlySubscriptionCreditDeposit row, {
    _i1.ColumnSelections<MonthlySubscriptionCreditDepositTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MonthlySubscriptionCreditDeposit>(
      row,
      columns: columns?.call(MonthlySubscriptionCreditDeposit.t),
      transaction: transaction,
    );
  }

  /// Deletes all [MonthlySubscriptionCreditDeposit]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MonthlySubscriptionCreditDeposit>> delete(
    _i1.Session session,
    List<MonthlySubscriptionCreditDeposit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MonthlySubscriptionCreditDeposit>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MonthlySubscriptionCreditDeposit].
  Future<MonthlySubscriptionCreditDeposit> deleteRow(
    _i1.Session session,
    MonthlySubscriptionCreditDeposit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MonthlySubscriptionCreditDeposit>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MonthlySubscriptionCreditDeposit>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MonthlySubscriptionCreditDepositTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MonthlySubscriptionCreditDeposit>(
      where: where(MonthlySubscriptionCreditDeposit.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlySubscriptionCreditDepositTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MonthlySubscriptionCreditDeposit>(
      where: where?.call(MonthlySubscriptionCreditDeposit.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
