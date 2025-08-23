import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';

class EmptyMarketplacePage extends ConsumerWidget {
  final bool isSearchResult;
  final String searchQuery;

  const EmptyMarketplacePage({
    super.key,
    required this.isSearchResult,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.c.surfaceContainerHighest.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearchResult
                    ? Icons.search_off_rounded
                    : Icons.shopping_bag_outlined,
                size: 48,
                color: context.c.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isSearchResult
                  ? 'No results found'
                  : 'No scrappables available',
              style: context.t.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isSearchResult
                  ? 'No scrappables match "$searchQuery". Try adjusting your search.'
                  : 'The marketplace is currently empty. Check back later for new scrappables.',
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSearchResult) ...[
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: () {
                  ref.read(marketplaceProvider.notifier).search('');
                },
                icon: const Icon(Icons.clear_rounded),
                label: const Text('Clear Search'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}