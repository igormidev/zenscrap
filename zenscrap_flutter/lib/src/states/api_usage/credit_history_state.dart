import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'credit_history_state.freezed.dart';

@freezed
class CreditHistoryState with _$CreditHistoryState {
  const factory CreditHistoryState.initial() = _Initial;
  const factory CreditHistoryState.loading() = _Loading;
  const factory CreditHistoryState.loaded({
    required List<CreditHistoryItem> creditHistory,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = _Loaded;
  const factory CreditHistoryState.withError(
    ZenScrapException error,
  ) = _WithError;
}