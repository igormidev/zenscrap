import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';

/// Notifier for managing user scrappables state.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class UserScrappablesNotifier extends Notifier<UserScrappablesState> {
  String _currentSearchQuery = '';
  Set<ScraperCategory> _currentCategories = {};
  int _currentPage = 1;

  @override
  UserScrappablesState build() => UserScrappablesState.initial();

  Future<void> loadScrappables({
    int page = 1,
    String searchQuery = '',
    Set<ScraperCategory>? categories,
  }) async {
    final client = ref.read(clientProvider);
    final isAuthenticated = client.auth.isAuthenticated;
    if (!isAuthenticated) return;

    _currentPage = page;
    _currentSearchQuery = searchQuery;
    _currentCategories = categories ?? _currentCategories;

    // Preserve previous response if available
    final previousResponse = state.mapOrNull(
      withData: (data) => data.response,
      loading: (loading) => loading.response,
      withError: (error) => error.response,
    );

    try {
      state = UserScrappablesState.loading(
        response: previousResponse,
        searchQuery: _currentSearchQuery,
        selectedCategories: _currentCategories,
      );

      final language = ref.read(currentLanguageProvider);
      final result = await ref
          .read(clientProvider)
          .privateUserScrappables(
            page: page,
            searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
            categories: _currentCategories.isEmpty
                ? null
                : _currentCategories.toList(),
            language: language,
          )
          .toResult;

      result.fold((response) {
        state = UserScrappablesState.withData(
          response: response,
          searchQuery: _currentSearchQuery,
          selectedCategories: _currentCategories,
        );
      }, (error) {
        state = UserScrappablesState.withError(
          error: error,
          response: previousResponse,
          searchQuery: _currentSearchQuery,
          selectedCategories: _currentCategories,
        );
      });
    } on ZenScrapException catch (e) {
      state = UserScrappablesState.withError(
        error: e,
        response: previousResponse,
        searchQuery: _currentSearchQuery,
        selectedCategories: _currentCategories,
      );
    } catch (error, stackTrace) {
      talker.log(
        'Error loading user scrappables',
        exception: error,
        stackTrace: stackTrace,
        logLevel: LogLevel.error,
      );
      state = UserScrappablesState.withError(
        error: ZenScrapException(
          title: 'Error loading scrappables',
          description: 'An unexpected error occurred:\n$error',
        ),
        response: previousResponse,
        searchQuery: _currentSearchQuery,
        selectedCategories: _currentCategories,
      );
    }
  }

  Future<void> changePage(int page) async {
    await loadScrappables(
      page: page,
      searchQuery: _currentSearchQuery,
      categories: _currentCategories,
    );
  }

  Future<void> search(String query) async {
    await loadScrappables(
      page: 1,
      searchQuery: query,
      categories: _currentCategories,
    );
  }

  Future<void> filterByCategories(Set<ScraperCategory> categories) async {
    await loadScrappables(
      page: 1,
      searchQuery: _currentSearchQuery,
      categories: categories,
    );
  }

  Future<void> refresh() async {
    await loadScrappables(
      page: _currentPage,
      searchQuery: _currentSearchQuery,
      categories: _currentCategories,
    );
  }

  Future<void> getScrappables() async {
    await loadScrappables(page: 1, searchQuery: '');
  }
}

final userScrappablesProvider =
    NotifierProvider<UserScrappablesNotifier, UserScrappablesState>(
        UserScrappablesNotifier.new);
