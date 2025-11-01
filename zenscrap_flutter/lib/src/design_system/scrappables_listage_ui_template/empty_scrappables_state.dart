import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

/// Generic empty state widget for scrappables
class EmptyScrappablesState extends StatelessWidget {
  const EmptyScrappablesState({
    super.key,
    required this.isSearchResult,
    this.searchQuery,
    this.onClearSearch,
    this.icon,
    this.title,
    this.description,
  });

  /// Whether this is an empty search result
  final bool isSearchResult;

  /// The search query that returned no results
  final String? searchQuery;

  /// Callback to clear the search
  final VoidCallback? onClearSearch;

  /// Custom icon (defaults to search_off for search results, shopping_bag otherwise)
  final IconData? icon;

  /// Custom title
  final String? title;

  /// Custom description
  final String? description;

  @override
  Widget build(BuildContext context) {
    final displayIcon = icon ??
        (isSearchResult
            ? Icons.search_off_rounded
            : Icons.shopping_bag_outlined);

    final displayTitle = title ??
        (isSearchResult ? 'No results found' : 'No scrappables available');

    final displayDescription = description ??
        (isSearchResult
            ? 'No scrappables match "${searchQuery ?? 'your search'}". Try adjusting your search or filters.'
            : 'The list is currently empty. Check back later for new scrappables.');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            displayIcon,
            size: 64,
            color: context.c.onSurfaceVariant.withAlpha(128),
          ),
          const SizedBox(height: 16),
          Text(
            displayTitle,
            style: context.t.titleLarge?.copyWith(
              color: context.c.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              displayDescription,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant.withAlpha(179),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (isSearchResult && onClearSearch != null) ...[
            const SizedBox(height: 24),
            FilledButton.tonalIcon(
              onPressed: onClearSearch,
              icon: const Icon(Icons.clear_rounded),
              label: const Text('Clear Search'),
            ),
          ],
        ],
      ),
    );
  }
}
