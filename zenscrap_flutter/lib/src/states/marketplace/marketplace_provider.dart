import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';

/// Notifier for managing marketplace state.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class MarketplaceNotifier extends Notifier<MarketplaceState> {
  String _currentSearchQuery = '';
  Set<ScraperCategory> _currentCategories = {};
  int _currentPage = 1;

  @override
  MarketplaceState build() => const MarketplaceState.initial();

  Client get _client => ref.read(clientProvider);

  Future<void> loadMarketplace({
    int page = 1,
    String searchQuery = '',
    Set<ScraperCategory>? categories,
  }) async {
    try {
      state = const MarketplaceState.loading();
      _currentPage = page;
      _currentSearchQuery = searchQuery;
      _currentCategories = categories ?? _currentCategories;

      final response = await _client.marketplace.getItems(
        page: page,
        searchQuery: searchQuery.isNotEmpty ? searchQuery : null,
        categories:
            _currentCategories.isEmpty ? null : _currentCategories.toList(),
      );

      state = MarketplaceState.loaded(
        response: response,
        searchQuery: searchQuery,
        selectedCategories: _currentCategories,
      );
    } on ZenScrapException catch (e) {
      state = MarketplaceState.withError(e);
    } catch (error, stackTrace) {
      talker.log(
        'Error loading marketplace',
        exception: error,
        stackTrace: stackTrace,
        logLevel: LogLevel.error,
      );
      state = MarketplaceState.withError(
        ZenScrapException(
          title: 'Error loading marketplace',
          description: 'An unexpected error occurred:\n$error',
        ),
      );
    }
  }

  Future<void> changePage(int page) async {
    await loadMarketplace(
      page: page,
      searchQuery: _currentSearchQuery,
      categories: _currentCategories,
    );
  }

  Future<void> search(String query) async {
    await loadMarketplace(
      page: 1,
      searchQuery: query,
      categories: _currentCategories,
    );
  }

  Future<void> filterByCategories(Set<ScraperCategory> categories) async {
    await loadMarketplace(
      page: 1,
      searchQuery: _currentSearchQuery,
      categories: categories,
    );
  }

  Future<void> refresh() async {
    await loadMarketplace(
      page: _currentPage,
      searchQuery: _currentSearchQuery,
      categories: _currentCategories,
    );
  }
}

final marketplaceProvider =
    NotifierProvider<MarketplaceNotifier, MarketplaceState>(
        MarketplaceNotifier.new);
