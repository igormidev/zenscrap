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
import '../../../entities/scrappable/ai_model.dart' as _i2;

abstract class AutoFixConfig implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  bool enabled;

  int consecutiveErrorThreshold;

  int currentConsecutiveErrors;

  DateTime? lastAttemptAt;

  bool inProgress;

  int attemptCount;

  _i2.AiModel? preferredAiModel;

  int scrappableId;

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
