import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/api_usage/credit_history_state.dart';

final creditHistoryProvider =
    StateNotifierProvider<CreditHistoryNotifier, CreditHistoryState>((ref) {
  final client = ref.watch(clientProvider);
  return CreditHistoryNotifier(client);
});

class CreditHistoryNotifier extends StateNotifier<CreditHistoryState> {
  final Client _client;
  int _currentPage = 1;
  List<CreditHistoryItem> _allHistory = [];

  CreditHistoryNotifier(this._client)
      : super(const CreditHistoryState.initial());

  Future<void> loadCreditHistory() async {
    try {
      state = const CreditHistoryState.loading();
      _currentPage = 1;
      _allHistory = [];

      final response = await _client.privateApiUsage.getCreditHistory(
        page: 1,
      );

      _allHistory = response.data;

      state = CreditHistoryState.loaded(
        creditHistory: response.data,
        hasMore: response.pagination.hasNextPage,
      );
    } on ZenScrapException catch (e) {
      state = CreditHistoryState.withError(e);
    } catch (error, stackTrace) {
      talker.log(
        'Error loading credit history',
        exception: error,
        stackTrace: stackTrace,
        logLevel: LogLevel.error,
      );
      state = CreditHistoryState.withError(
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
          state = CreditHistoryState.loaded(
            creditHistory: creditHistory,
            hasMore: hasMore,
            isLoadingMore: true,
          );
        },
        orElse: () {},
      );

      _currentPage++;
      final response = await _client.privateApiUsage.getCreditHistory(
        page: _currentPage,
      );

      _allHistory.addAll(response.data);

      state = CreditHistoryState.loaded(
        creditHistory: _allHistory,
        hasMore: response.pagination.hasNextPage,
        isLoadingMore: false,
      );
    } on ZenScrapException catch (e) {
      // Reset loading state and page on error
      _currentPage--;
      state.maybeWhen(
        loaded: (creditHistory, hasMore, _) {
          state = CreditHistoryState.loaded(
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
          state = CreditHistoryState.loaded(
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