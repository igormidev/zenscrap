/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../../entities/scrappable/auto_fix/auto_fix_attempt_status.dart'
    as _i2;

abstract class AutoFixAttempt implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
