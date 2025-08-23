import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/pages/empty_marketplace_page.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_pagination_controls.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_scrappable_card.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_search_bar.dart';

class MarketplaceView extends ConsumerStatefulWidget {
  const MarketplaceView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MarketplaceViewState();
}

class _MarketplaceViewState extends ConsumerState<MarketplaceView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(marketplaceProvider.notifier).loadMarketplace());
    });
  }

  @override
  Widget build(BuildContext context) {
    final marketplaceState = ref.watch(marketplaceProvider);
    
    return Column(
      children: [
        _buildHeader(context),
        Divider(height: 1),
        Expanded(
          child: marketplaceState.when(
            initial: () => const Center(
              child: Text('Loading marketplace...'),
            ),
            loading: () => const SizedBox.shrink(),
            loaded: (response, searchQuery) {
              if (response.data.isEmpty) {
                return EmptyMarketplacePage(
                  isSearchResult: searchQuery.isNotEmpty,
                  searchQuery: searchQuery,
                );
              }
              
              return Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      itemCount: response.data.length,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        childAspectRatio: 1.4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      itemBuilder: (context, index) {
                        final scrappable = response.data[index];
                        return MarketplaceScrappableCard(
                          scrappable: scrappable,
                          onTap: () {
                            _showScrappableDetails(context, scrappable);
                          },
                        );
                      },
                    ),
                  ),
                  const MarketplacePaginationControls(),
                ],
              );
            },
            withError: (error) => const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Marketplace',
                style: context.t.displaySmall,
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: context.c.tertiary.withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Public Scrappables',
                  style: context.t.labelSmall?.copyWith(
                    color: context.c.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref.read(marketplaceProvider.notifier).refresh();
                },
                icon: Icon(
                  Icons.refresh_rounded,
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(
            width: double.infinity,
            child: MarketplaceSearchBar(),
          ),
        ],
      ),
    );
  }

  void _showScrappableDetails(BuildContext context, Scrappable scrappable) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(scrappable.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description',
                style: context.t.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                scrappable.description,
                style: context.t.bodyMedium,
              ),
              if (scrappable.targetRequest?.url != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Target URL',
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  scrappable.targetRequest!.url,
                  style: context.t.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    color: context.c.primary,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Created: ${_formatFullDate(scrappable.createdAt)}',
                style: context.t.bodySmall?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/scrappable-form?clone=${scrappable.id}');
            },
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Clone to My Endpoints'),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
