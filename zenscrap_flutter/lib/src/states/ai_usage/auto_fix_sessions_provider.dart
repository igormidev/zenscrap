import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/auto_fix_sessions_state.dart';

final autoFixSessionsProvider =
    StateNotifierProvider<AutoFixSessionsNotifier, AutoFixSessionsState>((ref) {
  final client = ref.watch(clientProvider);
  return AutoFixSessionsNotifier(client);
});

class AutoFixSessionsNotifier extends StateNotifier<AutoFixSessionsState> {
  final Client _client;
  int _currentPage = 1;
  List<AutoFixSession> _allSessions = [];

  AutoFixSessionsNotifier(this._client)
      : super(const AutoFixSessionsState.initial());

  Future<void> loadSessions() async {
    try {
      state = const AutoFixSessionsState.loading();
      _currentPage = 1;
      _allSessions = [];

      final response = await _client.privateAiUsage.getAutoFixSessions(
        page: 1,
      );

      _allSessions = response.data;

      state = AutoFixSessionsState.loaded(
        sessions: response.data,
        hasMore: response.pagination.hasNextPage,
      );
    } on ZenScrapException catch (e) {
      state = AutoFixSessionsState.withError(e);
    } catch (error, stackTrace) {
      talker.log(
        'Error loading auto-fix sessions',
        exception: error,
        stackTrace: stackTrace,
        logLevel: LogLevel.error,
      );
      state = AutoFixSessionsState.withError(
        ZenScrapException(
          title: 'Error loading auto-fix sessions',
          description: 'An unexpected error occurred:\n$error',
        ),
      );
    }
  }

  Future<void> loadMoreSessions() async {
    // Use pattern matching to check if state is loaded
    final canLoadMore = state.maybeWhen(
      loaded: (sessions, hasMore, isLoadingMore) => !isLoadingMore && hasMore,
      orElse: () => false,
    );

    if (!canLoadMore) return;

    try {
      // Update state to show loading more
      state.maybeWhen(
        loaded: (sessions, hasMore, _) {
          state = AutoFixSessionsState.loaded(
            sessions: sessions,
            hasMore: hasMore,
            isLoadingMore: true,
          );
        },
        orElse: () {},
      );

      _currentPage++;
      final response = await _client.privateAiUsage.getAutoFixSessions(
        page: _currentPage,
      );

      _allSessions.addAll(response.data);

      state = AutoFixSessionsState.loaded(
        sessions: _allSessions,
        hasMore: response.pagination.hasNextPage,
        isLoadingMore: false,
      );
    } on ZenScrapException catch (e) {
      // Reset loading state and page on error
      _currentPage--;
      state.maybeWhen(
        loaded: (sessions, hasMore, _) {
          state = AutoFixSessionsState.loaded(
            sessions: sessions,
            hasMore: hasMore,
            isLoadingMore: false,
          );
        },
        orElse: () {},
      );
      talker.log(
        'Error loading more auto-fix sessions',
        exception: e,
        logLevel: LogLevel.error,
      );
    } catch (error, stackTrace) {
      // Reset loading state and page on error
      _currentPage--;
      state.maybeWhen(
        loaded: (sessions, hasMore, _) {
          state = AutoFixSessionsState.loaded(
            sessions: sessions,
            hasMore: hasMore,
            isLoadingMore: false,
          );
        },
        orElse: () {},
      );
      talker.log(
        'Error loading more auto-fix sessions',
        exception: error,
        stackTrace: stackTrace,
        logLevel: LogLevel.error,
      );
    }
  }

  Future<void> refresh() async {
    await loadSessions();
  }
}
