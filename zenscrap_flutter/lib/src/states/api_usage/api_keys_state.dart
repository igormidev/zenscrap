import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'api_keys_state.freezed.dart';

@freezed
class ApiKeysState with _$ApiKeysState {
  const factory ApiKeysState.initial() = _Initial;
  const factory ApiKeysState.loading() = _Loading;
  const factory ApiKeysState.loaded({
    required List<AccountApiKey> apiKeys,
    required Map<int, int> usageStats,
  }) = _Loaded;
  const factory ApiKeysState.withError(
    ZenScrapException error,
  ) = _WithError;
}