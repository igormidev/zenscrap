import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_analytics_state.dart';

final selectedScrappableAnalyticsProvider = StateNotifierProvider<
    SelectedScrappableAnalyticsNotifier,
    SelectedScrappableAnalyticsState>(SelectedScrappableAnalyticsNotifier.new);

class SelectedScrappableAnalyticsNotifier
    extends StateNotifier<SelectedScrappableAnalyticsState> {
  final Ref ref;
  SelectedScrappableAnalyticsNotifier(this.ref)
      : super(SelectedScrappableAnalyticsState.none());

  Future<void> getAnalyticsOfSpecificScrappable(Scrappable scrappable) async {
    state = SelectedScrappableAnalyticsState.loading();
  }
}
