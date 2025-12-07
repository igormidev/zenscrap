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

abstract class MonthlySubscriptionAICreditDeposit
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  MonthlySubscriptionAICreditDeposit._({
    this.id,
    required this.creditsAmountInDollars,
    required this.planTier,
  });

  factory MonthlySubscriptionAICreditDeposit({
    int? id,
    required double creditsAmountInDollars,
    required _i2.PlanTier planTier,
  }) = _MonthlySubscriptionAICreditDepositImpl;

  factory MonthlySubscriptionAICreditDeposit.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return MonthlySubscriptionAICreditDeposit(
      id: jsonSerialization['id'] as int?,
      creditsAmountInDollars:
          (jsonSerialization['creditsAmountInDollars'] as num).toDouble(),
      planTier: _i2.PlanTier.fromJson((jsonSerialization['planTier'] as int)),
    );
  }

  static final t = MonthlySubscriptionAICreditDepositTable();

  static const db = MonthlySubscriptionAICreditDepositRepository._();

  @override
  int? id;

  double creditsAmountInDollars;

  _i2.PlanTier planTier;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [MonthlySubscriptionAICreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MonthlySubscriptionAICreditDeposit copyWith({
    int? id,
    double? creditsAmountInDollars,
    _i2.PlanTier? planTier,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'creditsAmountInDollars': creditsAmountInDollars,
      'planTier': planTier.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'creditsAmountInDollars': creditsAmountInDollars,
      'planTier': planTier.toJson(),
    };
  }

  static MonthlySubscriptionAICreditDepositInclude include() {
    return MonthlySubscriptionAICreditDepositInclude._();
  }

  static MonthlySubscriptionAICreditDepositIncludeList includeList({
    _i1.WhereExpressionBuilder<MonthlySubscriptionAICreditDepositTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlySubscriptionAICreditDepositTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlySubscriptionAICreditDepositTable>?
        orderByList,
    MonthlySubscriptionAICreditDepositInclude? include,
  }) {
    return MonthlySubscriptionAICreditDepositIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MonthlySubscriptionAICreditDeposit.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MonthlySubscriptionAICreditDeposit.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MonthlySubscriptionAICreditDepositImpl
    extends MonthlySubscriptionAICreditDeposit {
  _MonthlySubscriptionAICreditDepositImpl({
    int? id,
    required double creditsAmountInDollars,
    required _i2.PlanTier planTier,
  }) : super._(
          id: id,
          creditsAmountInDollars: creditsAmountInDollars,
          planTier: planTier,
        );

  /// Returns a shallow copy of this [MonthlySubscriptionAICreditDeposit]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MonthlySubscriptionAICreditDeposit copyWith({
    Object? id = _Undefined,
    double? creditsAmountInDollars,
    _i2.PlanTier? planTier,
  }) {
    return MonthlySubscriptionAICreditDeposit(
      id: id is int? ? id : this.id,
      creditsAmountInDollars:
          creditsAmountInDollars ?? this.creditsAmountInDollars,
      planTier: planTier ?? this.planTier,
    );
  }
}

class MonthlySubscriptionAICreditDepositTable extends _i1.Table<int?> {
  MonthlySubscriptionAICreditDepositTable({super.tableRelation})
      : super(tableName: 'monthly_subscription_ai_credit_deposit') {
    creditsAmountInDollars = _i1.ColumnDouble(
      'creditsAmountInDollars',
      this,
    );
    planTier = _i1.ColumnEnum(
      'planTier',
      this,
      _i1.EnumSerialization.byIndex,
    );
  }

  late final _i1.ColumnDouble creditsAmountInDollars;

  late final _i1.ColumnEnum<_i2.PlanTier> planTier;

  @override
  List<_i1.Column> get columns => [
        id,
        creditsAmountInDollars,
        planTier,
      ];
}

class MonthlySubscriptionAICreditDepositInclude extends _i1.IncludeObject {
  MonthlySubscriptionAICreditDepositInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => MonthlySubscriptionAICreditDeposit.t;
}

class MonthlySubscriptionAICreditDepositIncludeList extends _i1.IncludeList {
  MonthlySubscriptionAICreditDepositIncludeList._({
    _i1.WhereExpressionBuilder<MonthlySubscriptionAICreditDepositTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MonthlySubscriptionAICreditDeposit.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => MonthlySubscriptionAICreditDeposit.t;
}

class MonthlySubscriptionAICreditDepositRepository {
  const MonthlySubscriptionAICreditDepositRepository._();

  /// Returns a list of [MonthlySubscriptionAICreditDeposit]s matching the given query parameters.
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
  Future<List<MonthlySubscriptionAICreditDeposit>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlySubscriptionAICreditDepositTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MonthlySubscriptionAICreditDepositTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlySubscriptionAICreditDepositTable>?
        orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MonthlySubscriptionAICreditDeposit>(
      where: where?.call(MonthlySubscriptionAICreditDeposit.t),
      orderBy: orderBy?.call(MonthlySubscriptionAICreditDeposit.t),
      orderByList: orderByList?.call(MonthlySubscriptionAICreditDeposit.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [MonthlySubscriptionAICreditDeposit] matching the given query parameters.
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
  Future<MonthlySubscriptionAICreditDeposit?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlySubscriptionAICreditDepositTable>? where,
    int? offset,
    _i1.OrderByBuilder<MonthlySubscriptionAICreditDepositTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MonthlySubscriptionAICreditDepositTable>?
        orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MonthlySubscriptionAICreditDeposit>(
      where: where?.call(MonthlySubscriptionAICreditDeposit.t),
      orderBy: orderBy?.call(MonthlySubscriptionAICreditDeposit.t),
      orderByList: orderByList?.call(MonthlySubscriptionAICreditDeposit.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [MonthlySubscriptionAICreditDeposit] by its [id] or null if no such row exists.
  Future<MonthlySubscriptionAICreditDeposit?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MonthlySubscriptionAICreditDeposit>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [MonthlySubscriptionAICreditDeposit]s in the list and returns the inserted rows.
  ///
  /// The returned [MonthlySubscriptionAICreditDeposit]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<MonthlySubscriptionAICreditDeposit>> insert(
    _i1.Session session,
    List<MonthlySubscriptionAICreditDeposit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MonthlySubscriptionAICreditDeposit>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [MonthlySubscriptionAICreditDeposit] and returns the inserted row.
  ///
  /// The returned [MonthlySubscriptionAICreditDeposit] will have its `id` field set.
  Future<MonthlySubscriptionAICreditDeposit> insertRow(
    _i1.Session session,
    MonthlySubscriptionAICreditDeposit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MonthlySubscriptionAICreditDeposit>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [MonthlySubscriptionAICreditDeposit]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<MonthlySubscriptionAICreditDeposit>> update(
    _i1.Session session,
    List<MonthlySubscriptionAICreditDeposit> rows, {
    _i1.ColumnSelections<MonthlySubscriptionAICreditDepositTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MonthlySubscriptionAICreditDeposit>(
      rows,
      columns: columns?.call(MonthlySubscriptionAICreditDeposit.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MonthlySubscriptionAICreditDeposit]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MonthlySubscriptionAICreditDeposit> updateRow(
    _i1.Session session,
    MonthlySubscriptionAICreditDeposit row, {
    _i1.ColumnSelections<MonthlySubscriptionAICreditDepositTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MonthlySubscriptionAICreditDeposit>(
      row,
      columns: columns?.call(MonthlySubscriptionAICreditDeposit.t),
      transaction: transaction,
    );
  }

  /// Deletes all [MonthlySubscriptionAICreditDeposit]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<MonthlySubscriptionAICreditDeposit>> delete(
    _i1.Session session,
    List<MonthlySubscriptionAICreditDeposit> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MonthlySubscriptionAICreditDeposit>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [MonthlySubscriptionAICreditDeposit].
  Future<MonthlySubscriptionAICreditDeposit> deleteRow(
    _i1.Session session,
    MonthlySubscriptionAICreditDeposit row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MonthlySubscriptionAICreditDeposit>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<MonthlySubscriptionAICreditDeposit>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MonthlySubscriptionAICreditDepositTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MonthlySubscriptionAICreditDeposit>(
      where: where(MonthlySubscriptionAICreditDeposit.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MonthlySubscriptionAICreditDepositTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MonthlySubscriptionAICreditDeposit>(
      where: where?.call(MonthlySubscriptionAICreditDeposit.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
