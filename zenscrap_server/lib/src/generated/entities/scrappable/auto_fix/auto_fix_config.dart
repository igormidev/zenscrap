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
import '../../../entities/scrappable/ai_model.dart' as _i2;

abstract class AutoFixConfig
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AutoFixConfig._({
    this.id,
    bool? enabled,
    int? consecutiveErrorThreshold,
    int? currentConsecutiveErrors,
    this.lastAttemptAt,
    bool? inProgress,
    int? attemptCount,
    this.preferredAiModel,
    required this.scrappableId,
  })  : enabled = enabled ?? true,
        consecutiveErrorThreshold = consecutiveErrorThreshold ?? 100,
        currentConsecutiveErrors = currentConsecutiveErrors ?? 0,
        inProgress = inProgress ?? false,
        attemptCount = attemptCount ?? 0;

  factory AutoFixConfig({
    int? id,
    bool? enabled,
    int? consecutiveErrorThreshold,
    int? currentConsecutiveErrors,
    DateTime? lastAttemptAt,
    bool? inProgress,
    int? attemptCount,
    _i2.AiModel? preferredAiModel,
    required int scrappableId,
  }) = _AutoFixConfigImpl;

  factory AutoFixConfig.fromJson(Map<String, dynamic> jsonSerialization) {
    return AutoFixConfig(
      id: jsonSerialization['id'] as int?,
      enabled: jsonSerialization['enabled'] as bool,
      consecutiveErrorThreshold:
          jsonSerialization['consecutiveErrorThreshold'] as int,
      currentConsecutiveErrors:
          jsonSerialization['currentConsecutiveErrors'] as int,
      lastAttemptAt: jsonSerialization['lastAttemptAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastAttemptAt']),
      inProgress: jsonSerialization['inProgress'] as bool,
      attemptCount: jsonSerialization['attemptCount'] as int,
      preferredAiModel: jsonSerialization['preferredAiModel'] == null
          ? null
          : _i2.AiModel.fromJson(
              (jsonSerialization['preferredAiModel'] as int)),
      scrappableId: jsonSerialization['scrappableId'] as int,
    );
  }

  static final t = AutoFixConfigTable();

  static const db = AutoFixConfigRepository._();

  @override
  int? id;

  bool enabled;

  int consecutiveErrorThreshold;

  int currentConsecutiveErrors;

  DateTime? lastAttemptAt;

  bool inProgress;

  int attemptCount;

  _i2.AiModel? preferredAiModel;

  int scrappableId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AutoFixConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AutoFixConfig copyWith({
    int? id,
    bool? enabled,
    int? consecutiveErrorThreshold,
    int? currentConsecutiveErrors,
    DateTime? lastAttemptAt,
    bool? inProgress,
    int? attemptCount,
    _i2.AiModel? preferredAiModel,
    int? scrappableId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'enabled': enabled,
      'consecutiveErrorThreshold': consecutiveErrorThreshold,
      'currentConsecutiveErrors': currentConsecutiveErrors,
      if (lastAttemptAt != null) 'lastAttemptAt': lastAttemptAt?.toJson(),
      'inProgress': inProgress,
      'attemptCount': attemptCount,
      if (preferredAiModel != null)
        'preferredAiModel': preferredAiModel?.toJson(),
      'scrappableId': scrappableId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'enabled': enabled,
      'consecutiveErrorThreshold': consecutiveErrorThreshold,
      'currentConsecutiveErrors': currentConsecutiveErrors,
      if (lastAttemptAt != null) 'lastAttemptAt': lastAttemptAt?.toJson(),
      'inProgress': inProgress,
      'attemptCount': attemptCount,
      if (preferredAiModel != null)
        'preferredAiModel': preferredAiModel?.toJson(),
      'scrappableId': scrappableId,
    };
  }

  static AutoFixConfigInclude include() {
    return AutoFixConfigInclude._();
  }

  static AutoFixConfigIncludeList includeList({
    _i1.WhereExpressionBuilder<AutoFixConfigTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AutoFixConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoFixConfigTable>? orderByList,
    AutoFixConfigInclude? include,
  }) {
    return AutoFixConfigIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AutoFixConfig.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AutoFixConfig.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AutoFixConfigImpl extends AutoFixConfig {
  _AutoFixConfigImpl({
    int? id,
    bool? enabled,
    int? consecutiveErrorThreshold,
    int? currentConsecutiveErrors,
    DateTime? lastAttemptAt,
    bool? inProgress,
    int? attemptCount,
    _i2.AiModel? preferredAiModel,
    required int scrappableId,
  }) : super._(
          id: id,
          enabled: enabled,
          consecutiveErrorThreshold: consecutiveErrorThreshold,
          currentConsecutiveErrors: currentConsecutiveErrors,
          lastAttemptAt: lastAttemptAt,
          inProgress: inProgress,
          attemptCount: attemptCount,
          preferredAiModel: preferredAiModel,
          scrappableId: scrappableId,
        );

  /// Returns a shallow copy of this [AutoFixConfig]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AutoFixConfig copyWith({
    Object? id = _Undefined,
    bool? enabled,
    int? consecutiveErrorThreshold,
    int? currentConsecutiveErrors,
    Object? lastAttemptAt = _Undefined,
    bool? inProgress,
    int? attemptCount,
    Object? preferredAiModel = _Undefined,
    int? scrappableId,
  }) {
    return AutoFixConfig(
      id: id is int? ? id : this.id,
      enabled: enabled ?? this.enabled,
      consecutiveErrorThreshold:
          consecutiveErrorThreshold ?? this.consecutiveErrorThreshold,
      currentConsecutiveErrors:
          currentConsecutiveErrors ?? this.currentConsecutiveErrors,
      lastAttemptAt:
          lastAttemptAt is DateTime? ? lastAttemptAt : this.lastAttemptAt,
      inProgress: inProgress ?? this.inProgress,
      attemptCount: attemptCount ?? this.attemptCount,
      preferredAiModel: preferredAiModel is _i2.AiModel?
          ? preferredAiModel
          : this.preferredAiModel,
      scrappableId: scrappableId ?? this.scrappableId,
    );
  }
}

class AutoFixConfigTable extends _i1.Table<int?> {
  AutoFixConfigTable({super.tableRelation})
      : super(tableName: 'auto_fix_config') {
    enabled = _i1.ColumnBool(
      'enabled',
      this,
      hasDefault: true,
    );
    consecutiveErrorThreshold = _i1.ColumnInt(
      'consecutiveErrorThreshold',
      this,
      hasDefault: true,
    );
    currentConsecutiveErrors = _i1.ColumnInt(
      'currentConsecutiveErrors',
      this,
      hasDefault: true,
    );
    lastAttemptAt = _i1.ColumnDateTime(
      'lastAttemptAt',
      this,
    );
    inProgress = _i1.ColumnBool(
      'inProgress',
      this,
      hasDefault: true,
    );
    attemptCount = _i1.ColumnInt(
      'attemptCount',
      this,
      hasDefault: true,
    );
    preferredAiModel = _i1.ColumnEnum(
      'preferredAiModel',
      this,
      _i1.EnumSerialization.byIndex,
    );
    scrappableId = _i1.ColumnInt(
      'scrappableId',
      this,
    );
  }

  late final _i1.ColumnBool enabled;

  late final _i1.ColumnInt consecutiveErrorThreshold;

  late final _i1.ColumnInt currentConsecutiveErrors;

  late final _i1.ColumnDateTime lastAttemptAt;

  late final _i1.ColumnBool inProgress;

  late final _i1.ColumnInt attemptCount;

  late final _i1.ColumnEnum<_i2.AiModel> preferredAiModel;

  late final _i1.ColumnInt scrappableId;

  @override
  List<_i1.Column> get columns => [
        id,
        enabled,
        consecutiveErrorThreshold,
        currentConsecutiveErrors,
        lastAttemptAt,
        inProgress,
        attemptCount,
        preferredAiModel,
        scrappableId,
      ];
}

class AutoFixConfigInclude extends _i1.IncludeObject {
  AutoFixConfigInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AutoFixConfig.t;
}

class AutoFixConfigIncludeList extends _i1.IncludeList {
  AutoFixConfigIncludeList._({
    _i1.WhereExpressionBuilder<AutoFixConfigTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AutoFixConfig.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AutoFixConfig.t;
}

class AutoFixConfigRepository {
  const AutoFixConfigRepository._();

  /// Returns a list of [AutoFixConfig]s matching the given query parameters.
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
  Future<List<AutoFixConfig>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AutoFixConfigTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AutoFixConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoFixConfigTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AutoFixConfig>(
      where: where?.call(AutoFixConfig.t),
      orderBy: orderBy?.call(AutoFixConfig.t),
      orderByList: orderByList?.call(AutoFixConfig.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AutoFixConfig] matching the given query parameters.
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
  Future<AutoFixConfig?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AutoFixConfigTable>? where,
    int? offset,
    _i1.OrderByBuilder<AutoFixConfigTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoFixConfigTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AutoFixConfig>(
      where: where?.call(AutoFixConfig.t),
      orderBy: orderBy?.call(AutoFixConfig.t),
      orderByList: orderByList?.call(AutoFixConfig.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AutoFixConfig] by its [id] or null if no such row exists.
  Future<AutoFixConfig?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AutoFixConfig>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AutoFixConfig]s in the list and returns the inserted rows.
  ///
  /// The returned [AutoFixConfig]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AutoFixConfig>> insert(
    _i1.Session session,
    List<AutoFixConfig> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AutoFixConfig>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AutoFixConfig] and returns the inserted row.
  ///
  /// The returned [AutoFixConfig] will have its `id` field set.
  Future<AutoFixConfig> insertRow(
    _i1.Session session,
    AutoFixConfig row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AutoFixConfig>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AutoFixConfig]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AutoFixConfig>> update(
    _i1.Session session,
    List<AutoFixConfig> rows, {
    _i1.ColumnSelections<AutoFixConfigTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AutoFixConfig>(
      rows,
      columns: columns?.call(AutoFixConfig.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AutoFixConfig]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AutoFixConfig> updateRow(
    _i1.Session session,
    AutoFixConfig row, {
    _i1.ColumnSelections<AutoFixConfigTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AutoFixConfig>(
      row,
      columns: columns?.call(AutoFixConfig.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AutoFixConfig]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AutoFixConfig>> delete(
    _i1.Session session,
    List<AutoFixConfig> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AutoFixConfig>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AutoFixConfig].
  Future<AutoFixConfig> deleteRow(
    _i1.Session session,
    AutoFixConfig row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AutoFixConfig>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AutoFixConfig>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AutoFixConfigTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AutoFixConfig>(
      where: where(AutoFixConfig.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AutoFixConfigTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AutoFixConfig>(
      where: where?.call(AutoFixConfig.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
