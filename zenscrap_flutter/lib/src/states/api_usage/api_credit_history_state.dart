import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'api_credit_history_state.freezed.dart';

@freezed
class ApiCreditHistoryState with _$ApiCreditHistoryState {
  const factory ApiCreditHistoryState.initial() = _Initial;
  const factory ApiCreditHistoryState.loading() = _Loading;
  const factory ApiCreditHistoryState.loaded({
    required List<ApiCreditHistoryItem> creditHistory,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = _Loaded;
  const factory ApiCreditHistoryState.withError(
    ZenScrapException error,
  ) = _WithError;
}
