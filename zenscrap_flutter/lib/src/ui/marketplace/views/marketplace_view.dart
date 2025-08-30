import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/mixins/curl_builder_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/pages/empty_marketplace_page.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/pages/scrappable_details_dialog.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_pagination_controls.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_scrappable_card.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_search_bar.dart';

class MarketplaceView extends ConsumerStatefulWidget {
  const MarketplaceView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MarketplaceViewState();
}

class _MarketplaceViewState extends ConsumerState<MarketplaceView>
    with CurlBuilderMixin {
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
        // Divider(height: 1),
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
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 480,
                        childAspectRatio: 1.72,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      padding: const EdgeInsets.only(
                        // vertical: 20,
                        // horizontal: 20,
                        top: 8,
                        bottom: 20,
                        left: 20,
                        right: 20,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Marketplace',
                style: context.t.displaySmall,
              ),
              const SizedBox(width: 16),
              Container(
                margin: EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.c.tertiary.withAlpha(26),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Public Scrappables',
                  style: context.t.labelLarge?.copyWith(
                    color: context.c.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh page',
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
      builder: (context) => ScrappableDetailsDialog(
        scrappable: scrappable,
        curlBuilderMixin: this,
      ),
    );
  }
}
