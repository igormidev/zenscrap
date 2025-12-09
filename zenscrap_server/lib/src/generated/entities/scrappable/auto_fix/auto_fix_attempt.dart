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
import '../../../entities/scrappable/auto_fix/auto_fix_attempt_status.dart'
    as _i2;

abstract class AutoFixAttempt
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AutoFixAttempt._({
    this.id,
    required this.startedAt,
    this.completedAt,
    required this.attemptNumber,
    bool? succeeded,
    _i2.AutoFixAttemptStatus? status,
    this.errorMessage,
    this.aiThinkingLog,
    this.generatedExtractRules,
    this.generatedJsScenario,
    this.validationPassed,
    this.validationError,
    double? costUsd,
    int? inputTokens,
    int? outputTokens,
    int? reasoningTokens,
    required this.sessionId,
  })  : succeeded = succeeded ?? false,
        status = status ?? _i2.AutoFixAttemptStatus.in_progress,
        costUsd = costUsd ?? 0.0,
        inputTokens = inputTokens ?? 0,
        outputTokens = outputTokens ?? 0,
        reasoningTokens = reasoningTokens ?? 0;

  factory AutoFixAttempt({
    int? id,
    required DateTime startedAt,
    DateTime? completedAt,
    required int attemptNumber,
    bool? succeeded,
    _i2.AutoFixAttemptStatus? status,
    String? errorMessage,
    String? aiThinkingLog,
    String? generatedExtractRules,
    String? generatedJsScenario,
    bool? validationPassed,
    String? validationError,
    double? costUsd,
    int? inputTokens,
    int? outputTokens,
    int? reasoningTokens,
    required int sessionId,
  }) = _AutoFixAttemptImpl;

  factory AutoFixAttempt.fromJson(Map<String, dynamic> jsonSerialization) {
    return AutoFixAttempt(
      id: jsonSerialization['id'] as int?,
      startedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt']),
      attemptNumber: jsonSerialization['attemptNumber'] as int,
      succeeded: jsonSerialization['succeeded'] as bool,
      status: _i2.AutoFixAttemptStatus.fromJson(
          (jsonSerialization['status'] as int)),
      errorMessage: jsonSerialization['errorMessage'] as String?,
      aiThinkingLog: jsonSerialization['aiThinkingLog'] as String?,
      generatedExtractRules:
          jsonSerialization['generatedExtractRules'] as String?,
      generatedJsScenario: jsonSerialization['generatedJsScenario'] as String?,
      validationPassed: jsonSerialization['validationPassed'] as bool?,
      validationError: jsonSerialization['validationError'] as String?,
      costUsd: (jsonSerialization['costUsd'] as num).toDouble(),
      inputTokens: jsonSerialization['inputTokens'] as int,
      outputTokens: jsonSerialization['outputTokens'] as int,
      reasoningTokens: jsonSerialization['reasoningTokens'] as int,
      sessionId: jsonSerialization['sessionId'] as int,
    );
  }

  static final t = AutoFixAttemptTable();

  static const db = AutoFixAttemptRepository._();

  @override
  int? id;

  DateTime startedAt;

  DateTime? completedAt;

  int attemptNumber;

  bool succeeded;

  _i2.AutoFixAttemptStatus status;

  String? errorMessage;

  String? aiThinkingLog;

  String? generatedExtractRules;

  String? generatedJsScenario;

  bool? validationPassed;

  String? validationError;

  double costUsd;

  int inputTokens;

  int outputTokens;

  int reasoningTokens;

  int sessionId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AutoFixAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AutoFixAttempt copyWith({
    int? id,
    DateTime? startedAt,
    DateTime? completedAt,
    int? attemptNumber,
    bool? succeeded,
    _i2.AutoFixAttemptStatus? status,
    String? errorMessage,
    String? aiThinkingLog,
    String? generatedExtractRules,
    String? generatedJsScenario,
    bool? validationPassed,
    String? validationError,
    double? costUsd,
    int? inputTokens,
    int? outputTokens,
    int? reasoningTokens,
    int? sessionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'startedAt': startedAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'attemptNumber': attemptNumber,
      'succeeded': succeeded,
      'status': status.toJson(),
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (aiThinkingLog != null) 'aiThinkingLog': aiThinkingLog,
      if (generatedExtractRules != null)
        'generatedExtractRules': generatedExtractRules,
      if (generatedJsScenario != null)
        'generatedJsScenario': generatedJsScenario,
      if (validationPassed != null) 'validationPassed': validationPassed,
      if (validationError != null) 'validationError': validationError,
      'costUsd': costUsd,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
      'reasoningTokens': reasoningTokens,
      'sessionId': sessionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'startedAt': startedAt.toJson(),
      if (completedAt != null) 'completedAt': completedAt?.toJson(),
      'attemptNumber': attemptNumber,
      'succeeded': succeeded,
      'status': status.toJson(),
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (aiThinkingLog != null) 'aiThinkingLog': aiThinkingLog,
      if (generatedExtractRules != null)
        'generatedExtractRules': generatedExtractRules,
      if (generatedJsScenario != null)
        'generatedJsScenario': generatedJsScenario,
      if (validationPassed != null) 'validationPassed': validationPassed,
      if (validationError != null) 'validationError': validationError,
      'costUsd': costUsd,
      'inputTokens': inputTokens,
      'outputTokens': outputTokens,
      'reasoningTokens': reasoningTokens,
      'sessionId': sessionId,
    };
  }

  static AutoFixAttemptInclude include() {
    return AutoFixAttemptInclude._();
  }

  static AutoFixAttemptIncludeList includeList({
    _i1.WhereExpressionBuilder<AutoFixAttemptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AutoFixAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoFixAttemptTable>? orderByList,
    AutoFixAttemptInclude? include,
  }) {
    return AutoFixAttemptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AutoFixAttempt.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AutoFixAttempt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AutoFixAttemptImpl extends AutoFixAttempt {
  _AutoFixAttemptImpl({
    int? id,
    required DateTime startedAt,
    DateTime? completedAt,
    required int attemptNumber,
    bool? succeeded,
    _i2.AutoFixAttemptStatus? status,
    String? errorMessage,
    String? aiThinkingLog,
    String? generatedExtractRules,
    String? generatedJsScenario,
    bool? validationPassed,
    String? validationError,
    double? costUsd,
    int? inputTokens,
    int? outputTokens,
    int? reasoningTokens,
    required int sessionId,
  }) : super._(
          id: id,
          startedAt: startedAt,
          completedAt: completedAt,
          attemptNumber: attemptNumber,
          succeeded: succeeded,
          status: status,
          errorMessage: errorMessage,
          aiThinkingLog: aiThinkingLog,
          generatedExtractRules: generatedExtractRules,
          generatedJsScenario: generatedJsScenario,
          validationPassed: validationPassed,
          validationError: validationError,
          costUsd: costUsd,
          inputTokens: inputTokens,
          outputTokens: outputTokens,
          reasoningTokens: reasoningTokens,
          sessionId: sessionId,
        );

  /// Returns a shallow copy of this [AutoFixAttempt]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AutoFixAttempt copyWith({
    Object? id = _Undefined,
    DateTime? startedAt,
    Object? completedAt = _Undefined,
    int? attemptNumber,
    bool? succeeded,
    _i2.AutoFixAttemptStatus? status,
    Object? errorMessage = _Undefined,
    Object? aiThinkingLog = _Undefined,
    Object? generatedExtractRules = _Undefined,
    Object? generatedJsScenario = _Undefined,
    Object? validationPassed = _Undefined,
    Object? validationError = _Undefined,
    double? costUsd,
    int? inputTokens,
    int? outputTokens,
    int? reasoningTokens,
    int? sessionId,
  }) {
    return AutoFixAttempt(
      id: id is int? ? id : this.id,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt is DateTime? ? completedAt : this.completedAt,
      attemptNumber: attemptNumber ?? this.attemptNumber,
      succeeded: succeeded ?? this.succeeded,
      status: status ?? this.status,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      aiThinkingLog:
          aiThinkingLog is String? ? aiThinkingLog : this.aiThinkingLog,
      generatedExtractRules: generatedExtractRules is String?
          ? generatedExtractRules
          : this.generatedExtractRules,
      generatedJsScenario: generatedJsScenario is String?
          ? generatedJsScenario
          : this.generatedJsScenario,
      validationPassed:
          validationPassed is bool? ? validationPassed : this.validationPassed,
      validationError:
          validationError is String? ? validationError : this.validationError,
      costUsd: costUsd ?? this.costUsd,
      inputTokens: inputTokens ?? this.inputTokens,
      outputTokens: outputTokens ?? this.outputTokens,
      reasoningTokens: reasoningTokens ?? this.reasoningTokens,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

class AutoFixAttemptTable extends _i1.Table<int?> {
  AutoFixAttemptTable({super.tableRelation})
      : super(tableName: 'auto_fix_attempt') {
    startedAt = _i1.ColumnDateTime(
      'startedAt',
      this,
    );
    completedAt = _i1.ColumnDateTime(
      'completedAt',
      this,
    );
    attemptNumber = _i1.ColumnInt(
      'attemptNumber',
      this,
    );
    succeeded = _i1.ColumnBool(
      'succeeded',
      this,
      hasDefault: true,
    );
    status = _i1.ColumnEnum(
      'status',
      this,
      _i1.EnumSerialization.byIndex,
      hasDefault: true,
    );
    errorMessage = _i1.ColumnString(
      'errorMessage',
      this,
    );
    aiThinkingLog = _i1.ColumnString(
      'aiThinkingLog',
      this,
    );
    generatedExtractRules = _i1.ColumnString(
      'generatedExtractRules',
      this,
    );
    generatedJsScenario = _i1.ColumnString(
      'generatedJsScenario',
      this,
    );
    validationPassed = _i1.ColumnBool(
      'validationPassed',
      this,
    );
    validationError = _i1.ColumnString(
      'validationError',
      this,
    );
    costUsd = _i1.ColumnDouble(
      'costUsd',
      this,
      hasDefault: true,
    );
    inputTokens = _i1.ColumnInt(
      'inputTokens',
      this,
      hasDefault: true,
    );
    outputTokens = _i1.ColumnInt(
      'outputTokens',
      this,
      hasDefault: true,
    );
    reasoningTokens = _i1.ColumnInt(
      'reasoningTokens',
      this,
      hasDefault: true,
    );
    sessionId = _i1.ColumnInt(
      'sessionId',
      this,
    );
  }

  late final _i1.ColumnDateTime startedAt;

  late final _i1.ColumnDateTime completedAt;

  late final _i1.ColumnInt attemptNumber;

  late final _i1.ColumnBool succeeded;

  late final _i1.ColumnEnum<_i2.AutoFixAttemptStatus> status;

  late final _i1.ColumnString errorMessage;

  late final _i1.ColumnString aiThinkingLog;

  late final _i1.ColumnString generatedExtractRules;

  late final _i1.ColumnString generatedJsScenario;

  late final _i1.ColumnBool validationPassed;

  late final _i1.ColumnString validationError;

  late final _i1.ColumnDouble costUsd;

  late final _i1.ColumnInt inputTokens;

  late final _i1.ColumnInt outputTokens;

  late final _i1.ColumnInt reasoningTokens;

  late final _i1.ColumnInt sessionId;

  @override
  List<_i1.Column> get columns => [
        id,
        startedAt,
        completedAt,
        attemptNumber,
        succeeded,
        status,
        errorMessage,
        aiThinkingLog,
        generatedExtractRules,
        generatedJsScenario,
        validationPassed,
        validationError,
        costUsd,
        inputTokens,
        outputTokens,
        reasoningTokens,
        sessionId,
      ];
}

class AutoFixAttemptInclude extends _i1.IncludeObject {
  AutoFixAttemptInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AutoFixAttempt.t;
}

class AutoFixAttemptIncludeList extends _i1.IncludeList {
  AutoFixAttemptIncludeList._({
    _i1.WhereExpressionBuilder<AutoFixAttemptTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AutoFixAttempt.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AutoFixAttempt.t;
}

class AutoFixAttemptRepository {
  const AutoFixAttemptRepository._();

  /// Returns a list of [AutoFixAttempt]s matching the given query parameters.
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
  Future<List<AutoFixAttempt>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AutoFixAttemptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AutoFixAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoFixAttemptTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AutoFixAttempt>(
      where: where?.call(AutoFixAttempt.t),
      orderBy: orderBy?.call(AutoFixAttempt.t),
      orderByList: orderByList?.call(AutoFixAttempt.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AutoFixAttempt] matching the given query parameters.
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
  Future<AutoFixAttempt?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AutoFixAttemptTable>? where,
    int? offset,
    _i1.OrderByBuilder<AutoFixAttemptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AutoFixAttemptTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AutoFixAttempt>(
      where: where?.call(AutoFixAttempt.t),
      orderBy: orderBy?.call(AutoFixAttempt.t),
      orderByList: orderByList?.call(AutoFixAttempt.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AutoFixAttempt] by its [id] or null if no such row exists.
  Future<AutoFixAttempt?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AutoFixAttempt>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AutoFixAttempt]s in the list and returns the inserted rows.
  ///
  /// The returned [AutoFixAttempt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AutoFixAttempt>> insert(
    _i1.Session session,
    List<AutoFixAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AutoFixAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AutoFixAttempt] and returns the inserted row.
  ///
  /// The returned [AutoFixAttempt] will have its `id` field set.
  Future<AutoFixAttempt> insertRow(
    _i1.Session session,
    AutoFixAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AutoFixAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AutoFixAttempt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AutoFixAttempt>> update(
    _i1.Session session,
    List<AutoFixAttempt> rows, {
    _i1.ColumnSelections<AutoFixAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AutoFixAttempt>(
      rows,
      columns: columns?.call(AutoFixAttempt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AutoFixAttempt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AutoFixAttempt> updateRow(
    _i1.Session session,
    AutoFixAttempt row, {
    _i1.ColumnSelections<AutoFixAttemptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AutoFixAttempt>(
      row,
      columns: columns?.call(AutoFixAttempt.t),
      transaction: transaction,
    );
  }

  /// Deletes all [AutoFixAttempt]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AutoFixAttempt>> delete(
    _i1.Session session,
    List<AutoFixAttempt> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AutoFixAttempt>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AutoFixAttempt].
  Future<AutoFixAttempt> deleteRow(
    _i1.Session session,
    AutoFixAttempt row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AutoFixAttempt>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AutoFixAttempt>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AutoFixAttemptTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AutoFixAttempt>(
      where: where(AutoFixAttempt.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AutoFixAttemptTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AutoFixAttempt>(
      where: where?.call(AutoFixAttempt.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
