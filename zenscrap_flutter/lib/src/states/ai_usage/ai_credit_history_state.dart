import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'ai_credit_history_state.freezed.dart';

@freezed
class AICreditHistoryState with _$AICreditHistoryState {
  const factory AICreditHistoryState.initial() = _Initial;
  const factory AICreditHistoryState.loading() = _Loading;
  const factory AICreditHistoryState.loaded({
    required List<AICreditHistoryItem> creditHistory,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = _Loaded;
  const factory AICreditHistoryState.withError(
    ZenScrapException error,
  ) = _WithError;
}
