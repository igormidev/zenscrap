import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'ai_usage_state.freezed.dart';

@freezed
class AIUsageState with _$AIUsageState {
  const factory AIUsageState.initial() = _Initial;
  const factory AIUsageState.loading() = _Loading;
  const factory AIUsageState.loaded({
    required AccountAIUsage aiUsage,
  }) = _Loaded;
  const factory AIUsageState.withError(
    ZenScrapException error,
  ) = _WithError;
}
