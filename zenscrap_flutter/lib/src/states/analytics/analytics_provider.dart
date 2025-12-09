import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_state.dart';

/// Notifier for managing analytics state.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class AnalyticsNotifier extends Notifier<AnalyticsState> {
  int _currentPage = 1;
  AnalyticsTimeScope _currentScope = AnalyticsTimeScope.last12Hours;

  @override
  AnalyticsState build() => AnalyticsState.initial();

  Future<void> getAnalyticsData({AnalyticsTimeScope? scope}) async {
    if (scope != null) {
      _currentScope = scope;
    }
    _currentPage = 1;
    state = AnalyticsState.loading();

    try {
      final result = await ref
          .read(clientProvider)
          .privateScrappableAnalytics
          .getScrappableAnalyticsWithScope(
            page: _currentPage,
            scope: _currentScope,
          );

      if (result.items.isEmpty) {
        state = AnalyticsState.emptyData();
      } else {
        state = AnalyticsState.withData(result);
      }
    } catch (error) {
      state = AnalyticsState.withError(
        error: error is ZenScrapException
            ? error
            : ZenScrapException(
                title: 'Error',
                description: error.toString(),
              ),
      );
    }
  }

  Future<void> loadMoreAnalytics() async {
    final currentData = state.whenOrNull(
      withData: (data) => data,
    );
    if (currentData == null) return;
    if (!currentData.hasNextPage) return;

    state = AnalyticsState.loadingMore(currentData: currentData);

    try {
      _currentPage++;
      final result = await ref
          .read(clientProvider)
          .privateScrappableAnalytics
          .getScrappableAnalyticsWithScope(
            page: _currentPage,
            scope: _currentScope,
          );

      // Merge the new data with existing data
      final mergedData = PaginatedScrappableRequestsAnalytics(
        scope: result.scope,
        items: [...currentData.items, ...result.items],
        hasNextPage: result.hasNextPage,
        totalCount: result.totalCount,
        currentPage: result.currentPage,
        pageSize: result.pageSize,
      );

      state = AnalyticsState.withData(mergedData);
    } catch (error) {
      // Revert to previous data on error
      state = AnalyticsState.withData(currentData);
    }
  }

  AnalyticsTimeScope get currentScope => _currentScope;
}

final analyticsProvider =
    NotifierProvider<AnalyticsNotifier, AnalyticsState>(AnalyticsNotifier.new);
