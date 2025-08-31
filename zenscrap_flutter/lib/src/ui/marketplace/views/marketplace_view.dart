import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/mixins/curl_builder_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/elements/scrappable_grid_listage.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/pages/empty_marketplace_page.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_pagination_controls.dart';
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
    final accountId = ref.watch(accountProvider).mapOrNull(
          withData: (value) => value.accountInfo.id,
        );
    final marketplaceState = ref.watch(marketplaceProvider);

    return Column(
      children: [
        const MarketplaceHeader(),
        SizedBox(height: 16),
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
                    child: ScrappableGridListage(
                      itemCount: response.data.length,
                      itemBuilder: (context, index) {
                        final MarketPlacePaginatedItem marketPlaceItem =
                            response.data[index];

                        return ScrappableCardIndicator(
                          accountId: accountId,
                          scrappable: marketPlaceItem.scrappable,
                          usageCount: marketPlaceItem.usageCount,
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
}
