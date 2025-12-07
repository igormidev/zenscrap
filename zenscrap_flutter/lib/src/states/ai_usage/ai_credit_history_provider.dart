import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_credit_history_state.dart';

final aiCreditHistoryProvider =
    StateNotifierProvider<AICreditHistoryNotifier, AICreditHistoryState>((ref) {
  final client = ref.watch(clientProvider);
  return AICreditHistoryNotifier(client);
});

class AICreditHistoryNotifier extends StateNotifier<AICreditHistoryState> {
  final Client _client;
  int _currentPage = 1;
  List<AICreditHistoryItem> _allHistory = [];

  AICreditHistoryNotifier(this._client)
      : super(const AICreditHistoryState.initial());

  Future<void> loadCreditHistory() async {
    try {
      state = const AICreditHistoryState.loading();
      _currentPage = 1;
      _allHistory = [];

      final response = await _client.privateAiUsage.getAiCreditHistory(
        page: 1,
      );

      _allHistory = response.data;

      state = AICreditHistoryState.loaded(
        creditHistory: response.data,
        hasMore: response.pagination.hasNextPage,
      );
    } on ZenScrapException catch (e) {
      state = AICreditHistoryState.withError(e);
    } catch (error, stackTrace) {
      talker.log(
        'Error loading AI credit history',
        exception: error,
        stackTrace: stackTrace,
        logLevel: LogLevel.error,
      );
      state = AICreditHistoryState.withError(
        ZenScrapException(
          title: 'Error loading AI credit history',
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
          state = AICreditHistoryState.loaded(
            creditHistory: creditHistory,
            hasMore: hasMore,
            isLoadingMore: true,
          );
        },
        orElse: () {},
      );

      _currentPage++;
      final response = await _client.privateAiUsage.getAiCreditHistory(
        page: _currentPage,
      );

      _allHistory.addAll(response.data);

      state = AICreditHistoryState.loaded(
        creditHistory: _allHistory,
        hasMore: response.pagination.hasNextPage,
        isLoadingMore: false,
      );
    } on ZenScrapException catch (e) {
      // Reset loading state and page on error
      _currentPage--;
      state.maybeWhen(
        loaded: (creditHistory, hasMore, _) {
          state = AICreditHistoryState.loaded(
            creditHistory: creditHistory,
            hasMore: hasMore,
            isLoadingMore: false,
          );
        },
        orElse: () {},
      );
      talker.log(
        'Error loading more AI credit history',
        exception: e,
        logLevel: LogLevel.error,
      );
    } catch (error, stackTrace) {
      // Reset loading state and page on error
      _currentPage--;
      state.maybeWhen(
        loaded: (creditHistory, hasMore, _) {
          state = AICreditHistoryState.loaded(
            creditHistory: creditHistory,
            hasMore: hasMore,
            isLoadingMore: false,
          );
        },
        orElse: () {},
      );
      talker.log(
        'Error loading more AI credit history',
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
