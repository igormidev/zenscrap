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
import '../../../entities/scrappable/auto_fix/auto_fix_session_status.dart'
    as _i2;
import '../../../entities/scrappable/ai_model.dart' as _i3;
import '../../../entities/scrappable/auto_fix/auto_fix_attempt.dart' as _i4;

abstract class AutoFixSession implements _i1.SerializableModel {
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
  })  : status = status ?? _i2.AutoFixSessionStatus.pending,
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
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      completedAt: jsonSerialization['completedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['completedAt']),
      status: _i2.AutoFixSessionStatus.fromJson(
          (jsonSerialization['status'] as int)),
      triggeredAtErrorCount: jsonSerialization['triggeredAtErrorCount'] as int,
      configuredThreshold: jsonSerialization['configuredThreshold'] as int,
      usedAiModel:
          _i3.AiModel.fromJson((jsonSerialization['usedAiModel'] as int)),
      usedUserApiKey: jsonSerialization['usedUserApiKey'] as bool,
      successSummary: jsonSerialization['successSummary'] as String?,
      failureReason: jsonSerialization['failureReason'] as String?,
      totalCostUsd: (jsonSerialization['totalCostUsd'] as num).toDouble(),
      totalInputTokens: jsonSerialization['totalInputTokens'] as int,
      totalOutputTokens: jsonSerialization['totalOutputTokens'] as int,
      scrappableId: jsonSerialization['scrappableId'] as int,
      attempts: (jsonSerialization['attempts'] as List?)
          ?.map((e) => _i4.AutoFixAttempt.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
      successSummary:
          successSummary is String? ? successSummary : this.successSummary,
      failureReason:
          failureReason is String? ? failureReason : this.failureReason,
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
