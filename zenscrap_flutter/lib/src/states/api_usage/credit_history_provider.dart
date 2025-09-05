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
  static const int _historyLimit = 20;
  int _historyOffset = 0;
  List<CreditHistoryItem> _allHistory = [];

  CreditHistoryNotifier(this._client)
      : super(const CreditHistoryState.initial());

  Future<void> loadCreditHistory() async {
    try {
      state = const CreditHistoryState.loading();
      _historyOffset = 0;
      _allHistory = [];

      final creditHistory = await _client.privateApiUsage.getCreditHistory(
        offset: 0,
        limit: _historyLimit,
      );

      _allHistory = creditHistory;
      _historyOffset = _historyLimit;

      state = CreditHistoryState.loaded(
        creditHistory: creditHistory,
        hasMore: creditHistory.length == _historyLimit,
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

      final moreHistory = await _client.privateApiUsage.getCreditHistory(
        offset: _historyOffset,
        limit: _historyLimit,
      );

      _allHistory.addAll(moreHistory);
      _historyOffset += _historyLimit;

      state = CreditHistoryState.loaded(
        creditHistory: _allHistory,
        hasMore: moreHistory.length == _historyLimit,
        isLoadingMore: false,
      );
    } on ZenScrapException catch (e) {
      // Reset loading state on error
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
      // Reset loading state on error
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