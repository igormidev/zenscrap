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
  factory SelectedScrappableAnalyticsState.withData({
    required List<ScrappableAnalytics> result,
  }) = _SelectedScrappableAnalyticsStateWithData;
}
