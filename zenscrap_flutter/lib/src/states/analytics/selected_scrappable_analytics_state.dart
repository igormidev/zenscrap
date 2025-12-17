import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'selected_scrappable_analytics_state.freezed.dart';

@freezed
abstract class SelectedScrappableAnalyticsState
    with _$SelectedScrappableAnalyticsState {
  factory SelectedScrappableAnalyticsState.none() =
      _SelectedScrappableAnalyticsStateNone;
  factory SelectedScrappableAnalyticsState.loading() =
      _SelectedScrappableAnalyticsStateLoading;
  factory SelectedScrappableAnalyticsState.loadingMore({
    required PaginatedScrappableAnalytics currentData,
  }) = _SelectedScrappableAnalyticsStateLoadingMore;
  factory SelectedScrappableAnalyticsState.withData({
    required PaginatedScrappableAnalytics data,
  }) = _SelectedScrappableAnalyticsStateWithData;
  factory SelectedScrappableAnalyticsState.withError({
    required ZenScrapException error,
  }) = _SelectedScrappableAnalyticsStateWithError;
}
