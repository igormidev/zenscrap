import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'analytics_state.freezed.dart';

@freezed
abstract class AnalyticsState with _$AnalyticsState {
  factory AnalyticsState.initial() = _Initial;
  factory AnalyticsState.loading() = _Loading;
  factory AnalyticsState.loadingMore({
    required PaginatedScrappableRequestsAnalytics currentData,
  }) = _LoadingMore;
  factory AnalyticsState.emptyData() = _EmptyData;
  factory AnalyticsState.withData(PaginatedScrappableRequestsAnalytics data) =
      _Loaded;
  factory AnalyticsState.withError({required ZenScrapException error}) = _Error;
}
