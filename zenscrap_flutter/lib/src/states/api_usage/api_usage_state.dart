import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'api_usage_state.freezed.dart';

@freezed
class ApiUsageState with _$ApiUsageState {
  const factory ApiUsageState.initial() = _Initial;
  const factory ApiUsageState.loading() = _Loading;
  const factory ApiUsageState.loaded({
    required AccountApiUsage apiUsage,
  }) = _Loaded;
  const factory ApiUsageState.withError(
    ZenScrapException error,
  ) = _WithError;
}