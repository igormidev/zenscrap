import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_analytics_state.dart';

final selectedScrappableAnalyticsProvider = StateNotifierProvider<
    SelectedScrappableAnalyticsNotifier,
    SelectedScrappableAnalyticsState>(SelectedScrappableAnalyticsNotifier.new);

class SelectedScrappableAnalyticsNotifier
    extends StateNotifier<SelectedScrappableAnalyticsState> {
  final Ref ref;
  SelectedScrappableAnalyticsNotifier(this.ref)
      : super(SelectedScrappableAnalyticsState.none());

  int _currentPage = 1;

  void resetState() {
    _currentPage = 1;
    state = SelectedScrappableAnalyticsState.none();
  }

  Future<void> selectScrappable(Scrappable scrappable) async {
    _currentPage = 1;
    state = SelectedScrappableAnalyticsState.loading();

    try {
      final result = await ref
          .read(clientProvider)
          .privateScrappableAnalytics
          .getScrappableAnalytics(
            scrappableId: scrappable.id,
            page: _currentPage,
          );

      state = SelectedScrappableAnalyticsState.withData(data: result);
    } catch (error) {
      state = SelectedScrappableAnalyticsState.withError(
        error: error.toString(),
      );
    }
  }

  Future<void> loadMoreAnalytics() async {
    final currentData = state.whenOrNull(
      withData: (data) => data,
    );
    if (currentData == null) return;
    if (!currentData.hasNextPage) return;

    state = SelectedScrappableAnalyticsState.loadingMore(
      currentData: currentData,
    );

    try {
      _currentPage++;
      final result = await ref
          .read(clientProvider)
          .privateScrappableAnalytics
          .getScrappableAnalytics(
            scrappableId: currentData.scrappable.id,
            page: _currentPage,
          );

      // Merge the new data with existing data
      final mergedData = PaginatedScrappableAnalytics(
        scrappable: result.scrappable,
        items: [...currentData.items, ...result.items],
        hasNextPage: result.hasNextPage,
        totalCount: result.totalCount,
        currentPage: result.currentPage,
        pageSize: result.pageSize,
      );

      state = SelectedScrappableAnalyticsState.withData(data: mergedData);
    } catch (error) {
      // Revert to previous data on error
      state = SelectedScrappableAnalyticsState.withData(data: currentData);
    }
  }
}
