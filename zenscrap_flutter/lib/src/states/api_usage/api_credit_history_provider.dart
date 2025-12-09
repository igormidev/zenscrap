import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_credit_history_state.dart';

/// Notifier for managing API credit history state.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class ApiCreditHistoryNotifier extends Notifier<ApiCreditHistoryState> {
  int _currentPage = 1;
  List<ApiCreditHistoryItem> _allHistory = [];

  @override
  ApiCreditHistoryState build() => const ApiCreditHistoryState.initial();

  Client get _client => ref.read(clientProvider);

  Future<void> loadCreditHistory() async {
    try {
      state = const ApiCreditHistoryState.loading();
      _currentPage = 1;
      _allHistory = [];

      final response = await _client.privateApiUsage.getApiCreditHistory(
        page: 1,
      );

      _allHistory = response.data;

      state = ApiCreditHistoryState.loaded(
        creditHistory: response.data,
        hasMore: response.pagination.hasNextPage,
      );
    } on ZenScrapException catch (e) {
      state = ApiCreditHistoryState.withError(e);
    } catch (error, stackTrace) {
      talker.log(
        'Error loading credit history',
        exception: error,
        stackTrace: stackTrace,
        logLevel: LogLevel.error,
      );
      state = ApiCreditHistoryState.withError(
        ZenScrapException(
          title: 'Error loading credit history',
          description: 'An unexpected error occurred:\n$error',
        ),
      );
    }
  }

  Future<void> loadMoreHistory() async {
    // Use pattern matching to check if state is loaded
    final canLoadMore = state.maybeWhen(
      loaded: (creditHistory, hasMore, isLoadingMore) =>
          !isLoadingMore && hasMore,
      orElse: () => false,
    );

    if (!canLoadMore) return;

    try {
      // Update state to show loading more
      state.maybeWhen(
        loaded: (creditHistory, hasMore, _) {
          state = ApiCreditHistoryState.loaded(
            creditHistory: creditHistory,
            hasMore: hasMore,
            isLoadingMore: true,
          );
        },
        orElse: () {},
      );

      _currentPage++;
      final response = await _client.privateApiUsage.getApiCreditHistory(
        page: _currentPage,
      );

      _allHistory.addAll(response.data);

      state = ApiCreditHistoryState.loaded(
        creditHistory: _allHistory,
        hasMore: response.pagination.hasNextPage,
        isLoadingMore: false,
      );
    } on ZenScrapException catch (e) {
      // Reset loading state and page on error
      _currentPage--;
      state.maybeWhen(
        loaded: (creditHistory, hasMore, _) {
          state = ApiCreditHistoryState.loaded(
            creditHistory: creditHistory,
            hasMore: hasMore,
            isLoadingMore: false,
          );
        },
        orElse: () {},
      );
      talker.log(
        'Error loading more credit history',
        exception: e,
        logLevel: LogLevel.error,
      );
    } catch (error, stackTrace) {
      // Reset loading state and page on error
      _currentPage--;
      state.maybeWhen(
        loaded: (creditHistory, hasMore, _) {
          state = ApiCreditHistoryState.loaded(
            creditHistory: creditHistory,
            hasMore: hasMore,
            isLoadingMore: false,
          );
        },
        orElse: () {},
      );
      talker.log(
        'Error loading more credit history',
        exception: error,
        stackTrace: stackTrace,
        logLevel: LogLevel.error,
      );
    }
  }

  Future<void> refresh() async {
    await loadCreditHistory();
  }
}

final apiCreditHistoryProvider =
    NotifierProvider<ApiCreditHistoryNotifier, ApiCreditHistoryState>(
        ApiCreditHistoryNotifier.new);
