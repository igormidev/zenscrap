import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/mixins/curl_builder_mixin.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/pages/empty_marketplace_page.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/pages/scrappable_details_dialog.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_pagination_controls.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_scrappable_card.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_header.dart';

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
        const MarketplaceHeader(),
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
                        final MarketPlacePaginatedItem marketPlaceItem =
                            response.data[index];
                        // final scrappable = response.data[index];

                        return MarketplaceScrappableCard(
                          scrappable: marketPlaceItem.scrappable,
                          usedCount: marketPlaceItem.usageCount,
                          onTap: () {
                            _showScrappableDetails(
                                context, marketPlaceItem.scrappable);
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
