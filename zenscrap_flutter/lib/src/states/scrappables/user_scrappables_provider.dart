import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';

final userScrappablesProvider =
    StateNotifierProvider<UserScrappablesNotifier, UserScrappablesState>(
        UserScrappablesNotifier.new);

class UserScrappablesNotifier extends StateNotifier<UserScrappablesState> {
  final Ref ref;
  UserScrappablesNotifier(this.ref) : super(UserScrappablesState.initial());

  String _currentSearchQuery = '';
  Set<ScraperCategory> _currentCategories = {};
  int _currentPage = 1;

  Future<void> loadScrappables({
    int page = 1,
    String searchQuery = '',
    Set<ScraperCategory>? categories,
  }) async {
    final sessionManager = ref.read(sessionManagerProvider);
    final signedInUser = sessionManager.signedInUser;
    if (signedInUser == null) return;

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

      final result = await ref
          .read(clientProvider)
          .privateUserScrappables(
            page: page,
            searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
            categories: _currentCategories.isEmpty
                ? null
                : _currentCategories.toList(),
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
