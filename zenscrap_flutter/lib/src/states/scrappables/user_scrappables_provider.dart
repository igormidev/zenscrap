import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';

final userScrappables =
    StateNotifierProvider<UserScrappablesNotifier, UserScrappablesState>(
        UserScrappablesNotifier.new);

class UserScrappablesNotifier extends StateNotifier<UserScrappablesState> {
  final Ref ref;
  UserScrappablesNotifier(this.ref) : super(UserScrappablesState.initial());

  String _currentSearchQuery = '';
  int _currentPage = 1;

  Future<void> loadScrappables({
    int page = 1,
    String searchQuery = '',
  }) async {
    final sessionManager = ref.read(sessionManagerProvider);
    final signedInUser = sessionManager.signedInUser;
    if (signedInUser == null) return;

    try {
      state = UserScrappablesState.loading();
      _currentPage = page;
      _currentSearchQuery = searchQuery;

      final result = await ref
          .read(clientProvider)
          .privateUserScrappables(
            page: page,
            searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
          )
          .toResult;

      result.fold((response) {
        state = UserScrappablesState.withData(
          response: response,
          searchQuery: searchQuery,
        );
      }, (error) {
        state = UserScrappablesState.withError(error: error);
      });
    } on ZenScrapException catch (e) {
      state = UserScrappablesState.withError(error: e);
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
      );
    }
  }

  Future<void> changePage(int page) async {
    await loadScrappables(
      page: page,
      searchQuery: _currentSearchQuery,
    );
  }

  Future<void> search(String query) async {
    await loadScrappables(
      page: 1,
      searchQuery: query,
    );
  }

  Future<void> refresh() async {
    await loadScrappables(
      page: _currentPage,
      searchQuery: _currentSearchQuery,
    );
  }

  Future<void> getScrappables() async {
    await loadScrappables(page: 1, searchQuery: '');
  }
}
