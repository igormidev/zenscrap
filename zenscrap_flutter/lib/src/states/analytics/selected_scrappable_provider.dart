import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

/// Notifier for managing the currently selected scrappable in analytics.
class SelectedScrappableNotifier
    extends Notifier<ScrappableRequestsAnalyticsItem?> {
  @override
  ScrappableRequestsAnalyticsItem? build() => null;

  void select(ScrappableRequestsAnalyticsItem? item) {
    state = item;
  }

  void clear() {
    state = null;
  }
}

final selectedScrappableProvider =
    NotifierProvider<SelectedScrappableNotifier, ScrappableRequestsAnalyticsItem?>(
        SelectedScrappableNotifier.new);
