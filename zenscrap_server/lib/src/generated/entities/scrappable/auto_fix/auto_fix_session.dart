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
import '../../../entities/scrappable/auto_fix/auto_fix_session_status.dart'
    as _i2;
import '../../../entities/scrappable/ai_model.dart' as _i3;
import '../../../entities/scrappable/auto_fix/auto_fix_attempt.dart' as _i4;
import 'package:zenscrap_server/src/generated/protocol.dart' as _i5;

abstract class AutoFixSession
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AutoFixSession._({
    this.id,
    required this.createdAt,
    this.completedAt,
    _i2.AutoFixSessionStatus? status,
    required this.triggeredAtErrorCount,
    required this.configuredThreshold,
    required this.usedAiModel,
    bool? usedUserApiKey,
    this.successSummary,
    this.failureReason,
    double? totalCostUsd,
    int? totalInputTokens,
    int? totalOutputTokens,
    required this.scrappableId,
    this.attempts,
  }) : status = status ?? _i2.AutoFixSessionStatus.pending,
       usedUserApiKey = usedUserApiKey ?? false,
       totalCostUsd = totalCostUsd ?? 0.0,
       totalInputTokens = totalInputTokens ?? 0,
       totalOutputTokens = totalOutputTokens ?? 0;

  factory AutoFixSession({
    int? id,
    required DateTime createdAt,
    DateTime? completedAt,
    _i2.AutoFixSessionStatus? status,
    required int triggeredAtErrorCount,
    required int configuredThreshold,
    required _i3.AiModel usedAiModel,
    bool? usedUserApiKey,
    String? successSummary,
    String? failureReason,
    double? totalCostUsd,
    int? totalInputTokens,
    int? totalOutputTokens,
    required int scrappableId,
    List<_i4.AutoFixAttempt>? attempts,
  }) = _AutoFixSessionImpl;

  factory AutoFixSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return AutoFixSession(
      id: jsonSerialization['id'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt'],
            ),
      status: _i2.AutoFixSessionStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      triggeredAtErrorCount: jsonSerialization['triggeredAtErrorCount'] as int,
      configuredThreshold: jsonSerialization['configuredThreshold'] as int,
      usedAiModel: _i3.AiModel.fromJson(
        (jsonSerialization['usedAiModel'] as String),
      ),
      usedUserApiKey: jsonSerialization['usedUserApiKey'] as bool,
      successSummary: jsonSerialization['successSummary'] as String?,
      failureReason: jsonSerialization['failureReason'] as String?,
      totalCostUsd: (jsonSerialization['totalCostUsd'] as num).toDouble(),
      totalInputTokens: jsonSerialization['totalInputTokens'] as int,
      totalOutputTokens: jsonSerialization['totalOutputTokens'] as int,
      scrappableId: jsonSerialization['scrappableId'] as int,
      attempts: jsonSerialization['attempts'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i4.AutoFixAttempt>>(
              jsonSerialization['attempts'],
            ),
    );
  }

  static final t = AutoFixSessionTable();

  static const db = AutoFixSessionRepository._();

  @override
  int? id;

  DateTime createdAt;

  DateTime? completedAt;

  _i2.AutoFixSessionStatus status;

  int triggeredAtErrorCount;

  int configuredThreshold;

  _i3.AiModel usedAiModel;

  bool usedUserApiKey;

  String? successSummary;

  String? failureReason;

  double totalCostUsd;

  int totalInputTokens;

  int totalOutputTokens;

  int scrappableId;

  List<_i4.AutoFixAttempt>? attempts;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AutoFixSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AutoFixSession copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? completedAt,
    _i2.AutoFixSessionStatus? status,
    int? triggeredAtErrorCount,
    int? configuredThreshold,
    _i3.AiModel? usedAiModel,
    bool? usedUserApiKey,
    String? successSummary,
    String? failureReason,
    double? totalCostUsd,
    int? totalInputTokens,
    int? totalOutputTokens,
    int? scrappableId,
    List<_i4.AutoFixAttempt>? attempts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AutoFixSession',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'status': status.toJson(),
      'triggeredAtErrorCount': triggeredAtErrorCount,
      'configuredThreshold': configuredThreshold,
      'usedAiModel': usedAiModel.toJson(),
      'usedUserApiKey': usedUserApiKey,
      if (successSummary != null) 'successSummary': successSummary,
      if (failureReason != null) 'failureReason': failureReason,
      'totalCostUsd': totalCostUsd,
      'totalInputTokens': totalInputTokens,
      'totalOutputTokens': totalOutputTokens,
      'scrappableId': scrappableId,
      if (attempts != null)
        'attempts': attempts?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AutoFixSession',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'status': status.toJson(),
      'triggeredAtErrorCount': triggeredAtErrorCount,
      'configuredThreshold': configuredThreshold,
      'usedAiModel': usedAiModel.toJson(),
      'usedUserApiKey': usedUserApiKey,
      if (successSummary != null) 'successSummary': successSummary,
      if (failureReason != null) 'failureReason': failureReason,
      'totalCostUsd': totalCostUsd,
      'totalInputTokens': totalInputTokens,
      'totalOutputTokens': totalOutputTokens,
      'scrappableId': scrappableId,
      if (attempts != null)
        'attempts': attempts?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static AutoFixSessionInclude include({
    _i4.AutoFixAttemptIncludeList? attempts,
  }) {
    return AutoFixSessionInclude._(attempts: attempts);
  }

  static AutoFixSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<AutoFixSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AutoFixSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoFixSessionTable>? orderByList,
    AutoFixSessionInclude? include,
  }) {
    return AutoFixSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AutoFixSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AutoFixSession.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AutoFixSessionImpl extends AutoFixSession {
  _AutoFixSessionImpl({
    int? id,
    required DateTime createdAt,
    DateTime? completedAt,
    _i2.AutoFixSessionStatus? status,
    required int triggeredAtErrorCount,
    required int configuredThreshold,
    required _i3.AiModel usedAiModel,
    bool? usedUserApiKey,
    String? successSummary,
    String? failureReason,
    double? totalCostUsd,
    int? totalInputTokens,
    int? totalOutputTokens,
    required int scrappableId,
    List<_i4.AutoFixAttempt>? attempts,
  }) : super._(
         id: id,
         createdAt: createdAt,
         completedAt: completedAt,
         status: status,
         triggeredAtErrorCount: triggeredAtErrorCount,
         configuredThreshold: configuredThreshold,
         usedAiModel: usedAiModel,
         usedUserApiKey: usedUserApiKey,
         successSummary: successSummary,
         failureReason: failureReason,
         totalCostUsd: totalCostUsd,
         totalInputTokens: totalInputTokens,
         totalOutputTokens: totalOutputTokens,
         scrappableId: scrappableId,
         attempts: attempts,
       );

  /// Returns a shallow copy of this [AutoFixSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AutoFixSession copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    Object? completedAt = _Undefined,
    _i2.AutoFixSessionStatus? status,
    int? triggeredAtErrorCount,
    int? configuredThreshold,
    _i3.AiModel? usedAiModel,
    bool? usedUserApiKey,
    Object? successSummary = _Undefined,
    Object? failureReason = _Undefined,
    double? totalCostUsd,
    int? totalInputTokens,
    int? totalOutputTokens,
    int? scrappableId,
    Object? attempts = _Undefined,
  }) {
    return AutoFixSession(
      id: id is int? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      status: status ?? this.status,
      triggeredAtErrorCount:
          triggeredAtErrorCount ?? this.triggeredAtErrorCount,
      configuredThreshold: configuredThreshold ?? this.configuredThreshold,
      usedAiModel: usedAiModel ?? this.usedAiModel,
      usedUserApiKey: usedUserApiKey ?? this.usedUserApiKey,
      successSummary: successSummary is String?
          ? successSummary
          : this.successSummary,
      failureReason: failureReason is String?
          ? failureReason
          : this.failureReason,
      totalCostUsd: totalCostUsd ?? this.totalCostUsd,
      totalInputTokens: totalInputTokens ?? this.totalInputTokens,
      totalOutputTokens: totalOutputTokens ?? this.totalOutputTokens,
      scrappableId: scrappableId ?? this.scrappableId,
      attempts: attempts is List<_i4.AutoFixAttempt>?
          ? attempts
          : this.attempts?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class AutoFixSessionUpdateTable extends _i1.UpdateTable<AutoFixSessionTable> {
  AutoFixSessionUpdateTable(super.table);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> completedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.completedAt,
        value,
      );

  _i1.ColumnValue<_i2.AutoFixSessionStatus, _i2.AutoFixSessionStatus> status(
    _i2.AutoFixSessionStatus value,
  ) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<int, int> triggeredAtErrorCount(int value) => _i1.ColumnValue(
    table.triggeredAtErrorCount,
    value,
  );

  _i1.ColumnValue<int, int> configuredThreshold(int value) => _i1.ColumnValue(
    table.configuredThreshold,
    value,
  );

  _i1.ColumnValue<_i3.AiModel, _i3.AiModel> usedAiModel(_i3.AiModel value) =>
      _i1.ColumnValue(
        table.usedAiModel,
        value,
      );

  _i1.ColumnValue<bool, bool> usedUserApiKey(bool value) => _i1.ColumnValue(
    table.usedUserApiKey,
    value,
  );

  _i1.ColumnValue<String, String> successSummary(String? value) =>
      _i1.ColumnValue(
        table.successSummary,
        value,
      );

  _i1.ColumnValue<String, String> failureReason(String? value) =>
      _i1.ColumnValue(
        table.failureReason,
        value,
      );

  _i1.ColumnValue<double, double> totalCostUsd(double value) => _i1.ColumnValue(
    table.totalCostUsd,
    value,
  );

  _i1.ColumnValue<int, int> totalInputTokens(int value) => _i1.ColumnValue(
    table.totalInputTokens,
    value,
  );

  _i1.ColumnValue<int, int> totalOutputTokens(int value) => _i1.ColumnValue(
    table.totalOutputTokens,
    value,
  );

  _i1.ColumnValue<int, int> scrappableId(int value) => _i1.ColumnValue(
    table.scrappableId,
    value,
  );
}

class AutoFixSessionTable extends _i1.Table<int?> {
  AutoFixSessionTable({super.tableRelation})
    : super(tableName: 'auto_fix_session') {
    updateTable = AutoFixSessionUpdateTable(this);
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    completedAt = _i1.ColumnDateTime(
      'completedAt',
      this,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    triggeredAtErrorCount = _i1.ColumnInt(
      'triggeredAtErrorCount',
      this,
    );
    configuredThreshold = _i1.ColumnInt(
      'configuredThreshold',
      this,
    );
    usedAiModel = _i1.ColumnEnum(
      'usedAiModel',
      this,
      _i1.EnumSerialization.byName,
    );
    usedUserApiKey = _i1.ColumnBool(
      'usedUserApiKey',
      this,
      hasDefault: true,
    );
    successSummary = _i1.ColumnString(
      'successSummary',
      this,
    );
    failureReason = _i1.ColumnString(
      'failureReason',
      this,
    );
    totalCostUsd = _i1.ColumnDouble(
      'totalCostUsd',
      this,
      hasDefault: true,
    );
    totalInputTokens = _i1.ColumnInt(
      'totalInputTokens',
      this,
      hasDefault: true,
    );
    totalOutputTokens = _i1.ColumnInt(
      'totalOutputTokens',
      this,
      hasDefault: true,
    );
    scrappableId = _i1.ColumnInt(
      'scrappableId',
      this,
    );
  }

  late final AutoFixSessionUpdateTable updateTable;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime completedAt;

  late final _i1.ColumnEnum<_i2.AutoFixSessionStatus> status;

  late final _i1.ColumnInt triggeredAtErrorCount;

  late final _i1.ColumnInt configuredThreshold;

  late final _i1.ColumnEnum<_i3.AiModel> usedAiModel;

  late final _i1.ColumnBool usedUserApiKey;

  late final _i1.ColumnString successSummary;

  late final _i1.ColumnString failureReason;

  late final _i1.ColumnDouble totalCostUsd;

  late final _i1.ColumnInt totalInputTokens;

  late final _i1.ColumnInt totalOutputTokens;

  late final _i1.ColumnInt scrappableId;

  _i4.AutoFixAttemptTable? ___attempts;

  _i1.ManyRelation<_i4.AutoFixAttemptTable>? _attempts;

  _i4.AutoFixAttemptTable get __attempts {
    if (___attempts != null) return ___attempts!;
    ___attempts = _i1.createRelationTable(
      relationFieldName: '__attempts',
      field: AutoFixSession.t.id,
      foreignField: _i4.AutoFixAttempt.t.sessionId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.AutoFixAttemptTable(tableRelation: foreignTableRelation),
    );
    return ___attempts!;
  }

  _i1.ManyRelation<_i4.AutoFixAttemptTable> get attempts {
    if (_attempts != null) return _attempts!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'attempts',
      field: AutoFixSession.t.id,
      foreignField: _i4.AutoFixAttempt.t.sessionId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.AutoFixAttemptTable(tableRelation: foreignTableRelation),
    );
    _attempts = _i1.ManyRelation<_i4.AutoFixAttemptTable>(
      tableWithRelations: relationTable,
      table: _i4.AutoFixAttemptTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _attempts!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    createdAt,
    completedAt,
    status,
    triggeredAtErrorCount,
    configuredThreshold,
    usedAiModel,
    usedUserApiKey,
    successSummary,
    failureReason,
    totalCostUsd,
    totalInputTokens,
    totalOutputTokens,
    scrappableId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'attempts') {
      return __attempts;
    }
    return null;
  }
}

class AutoFixSessionInclude extends _i1.IncludeObject {
  AutoFixSessionInclude._({_i4.AutoFixAttemptIncludeList? attempts}) {
    _attempts = attempts;
  }

  _i4.AutoFixAttemptIncludeList? _attempts;

  @override
  Map<String, _i1.Include?> get includes => {'attempts': _attempts};

  @override
  _i1.Table<int?> get table => AutoFixSession.t;
}

class AutoFixSessionIncludeList extends _i1.IncludeList {
  AutoFixSessionIncludeList._({
    _i1.WhereExpressionBuilder<AutoFixSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AutoFixSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AutoFixSession.t;
}

class AutoFixSessionRepository {
  const AutoFixSessionRepository._();

  final attach = const AutoFixSessionAttachRepository._();

  final attachRow = const AutoFixSessionAttachRowRepository._();

  /// Returns a list of [AutoFixSession]s matching the given query parameters.
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
  Future<List<AutoFixSession>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AutoFixSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AutoFixSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoFixSessionTable>? orderByList,
    _i1.Transaction? transaction,
    AutoFixSessionInclude? include,
  }) async {
    return session.db.find<AutoFixSession>(
      where: where?.call(AutoFixSession.t),
      orderBy: orderBy?.call(AutoFixSession.t),
      orderByList: orderByList?.call(AutoFixSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [AutoFixSession] matching the given query parameters.
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
  Future<AutoFixSession?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AutoFixSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<AutoFixSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoFixSessionTable>? orderByList,
    _i1.Transaction? transaction,
    AutoFixSessionInclude? include,
  }) async {
    return session.db.findFirstRow<AutoFixSession>(
      where: where?.call(AutoFixSession.t),
      orderBy: orderBy?.call(AutoFixSession.t),
      orderByList: orderByList?.call(AutoFixSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [AutoFixSession] by its [id] or null if no such row exists.
  Future<AutoFixSession?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    AutoFixSessionInclude? include,
  }) async {
    return session.db.findById<AutoFixSession>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [AutoFixSession]s in the list and returns the inserted rows.
  ///
  /// The returned [AutoFixSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AutoFixSession>> insert(
    _i1.Session session,
    List<AutoFixSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AutoFixSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AutoFixSession] and returns the inserted row.
  ///
  /// The returned [AutoFixSession] will have its `id` field set.
  Future<AutoFixSession> insertRow(
    _i1.Session session,
    AutoFixSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AutoFixSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AutoFixSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AutoFixSession>> update(
    _i1.Session session,
    List<AutoFixSession> rows, {
    _i1.ColumnSelections<AutoFixSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AutoFixSession>(
      rows,
      columns: columns?.call(AutoFixSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AutoFixSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AutoFixSession> updateRow(
    _i1.Session session,
    AutoFixSession row, {
    _i1.ColumnSelections<AutoFixSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AutoFixSession>(
      row,
      columns: columns?.call(AutoFixSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AutoFixSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AutoFixSession?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AutoFixSessionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AutoFixSession>(
      id,
      columnValues: columnValues(AutoFixSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AutoFixSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AutoFixSession>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AutoFixSessionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<AutoFixSessionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AutoFixSessionTable>? orderBy,
    _i1.OrderByListBuilder<AutoFixSessionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AutoFixSession>(
      columnValues: columnValues(AutoFixSession.t.updateTable),
      where: where(AutoFixSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AutoFixSession.t),
      orderByList: orderByList?.call(AutoFixSession.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AutoFixSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AutoFixSession>> delete(
    _i1.Session session,
    List<AutoFixSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AutoFixSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AutoFixSession].
  Future<AutoFixSession> deleteRow(
    _i1.Session session,
    AutoFixSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AutoFixSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AutoFixSession>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AutoFixSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AutoFixSession>(
      where: where(AutoFixSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AutoFixSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AutoFixSession>(
      where: where?.call(AutoFixSession.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class AutoFixSessionAttachRepository {
  const AutoFixSessionAttachRepository._();

  /// Creates a relation between this [AutoFixSession] and the given [AutoFixAttempt]s
  /// by setting each [AutoFixAttempt]'s foreign key `sessionId` to refer to this [AutoFixSession].
  Future<void> attempts(
    _i1.Session session,
    AutoFixSession autoFixSession,
    List<_i4.AutoFixAttempt> autoFixAttempt, {
    _i1.Transaction? transaction,
  }) async {
    if (autoFixAttempt.any((e) => e.id == null)) {
      throw ArgumentError.notNull('autoFixAttempt.id');
    }
    if (autoFixSession.id == null) {
      throw ArgumentError.notNull('autoFixSession.id');
    }

    var $autoFixAttempt = autoFixAttempt
        .map((e) => e.copyWith(sessionId: autoFixSession.id))
        .toList();
    await session.db.update<_i4.AutoFixAttempt>(
      $autoFixAttempt,
      columns: [_i4.AutoFixAttempt.t.sessionId],
      transaction: transaction,
    );
  }
}

class AutoFixSessionAttachRowRepository {
  const AutoFixSessionAttachRowRepository._();

  /// Creates a relation between this [AutoFixSession] and the given [AutoFixAttempt]
  /// by setting the [AutoFixAttempt]'s foreign key `sessionId` to refer to this [AutoFixSession].
  Future<void> attempts(
    _i1.Session session,
    AutoFixSession autoFixSession,
    _i4.AutoFixAttempt autoFixAttempt, {
    _i1.Transaction? transaction,
  }) async {
    if (autoFixAttempt.id == null) {
      throw ArgumentError.notNull('autoFixAttempt.id');
    }
    if (autoFixSession.id == null) {
      throw ArgumentError.notNull('autoFixSession.id');
    }

    var $autoFixAttempt = autoFixAttempt.copyWith(sessionId: autoFixSession.id);
    await session.db.updateRow<_i4.AutoFixAttempt>(
      $autoFixAttempt,
      columns: [_i4.AutoFixAttempt.t.sessionId],
      transaction: transaction,
    );
  }
}
