import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/mixins/curl_builder_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/scrappables_listage_template.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/pagination_controls.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/empty_scrappables_state.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/loading_scrappables_state.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';
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
    final analytics = ref.read(analyticsServiceProvider);
    final accountId = ref.watch(accountProvider).mapOrNull(
          withData: (value) => value.accountInfo.id,
        );
    final marketplaceState = ref.watch(marketplaceProvider);

    return Padding(
      padding: EdgeInsets.only(
        right: context.responsiveValue(
          compact: 0.0,
          medium: 16.0,
          expanded: 20.0,
        ),
      ),
      child: Column(
        children: [
          const MarketplaceHeader(),
          SizedBox(
            height: context.responsiveValue(
              compact: 12.0,
              medium: 16.0,
              expanded: 16.0,
            ),
          ),
          Expanded(
            child: marketplaceState.when(
              initial: () => const LoadingScrappablesState(),
              loading: () => const LoadingScrappablesState(),
              loaded: (response, searchQuery, selectedCategories) {
                // Track marketplace page view
                analytics.trackMarketplacePageView(
                  scrappableCount: response.data.length,
                  currentPage: response.pagination.currentPage,
                  hasSearchQuery: searchQuery.isNotEmpty,
                );

                if (response.data.isEmpty) {
                  return EmptyScrappablesState(
                    isSearchResult: searchQuery.isNotEmpty,
                    searchQuery: searchQuery,
                    onClearSearch: () {
                      ref.read(marketplaceProvider.notifier).search('');
                    },
                  );
                }

                // Create a map of scrappable to usage count for quick lookup
                final usageCountMap = <int, int>{};
                for (final item in response.data) {
                  if (item.scrappable.id != null) {
                    usageCountMap[item.scrappable.id!] = item.usageCount;
                  }
                }

                return ScrappablesListageTemplate(
                  scrappables: response.data.map((e) => e.scrappable).toList(),
                  pagination: response.pagination,
                  accountId: accountId,
                  source: ScrappableCardSource.marketplace,
                  usageCountProvider: (scrappable) {
                    if (scrappable.id == null) return null;
                    return usageCountMap[scrappable.id];
                  },
                  paginationControls: PaginationControls(
                    pagination: response.pagination,
                    onPageChanged: (page) {
                      ref.read(marketplaceProvider.notifier).changePage(page);
                    },
                    mode: PaginationMode.pageNumbers,
                    onPreviousPageAnalytics: () {
                      analytics.trackMarketplacePaginationPrevious(
                        fromPage: response.pagination.currentPage,
                        toPage: response.pagination.currentPage - 1,
                      );
                    },
                    onNextPageAnalytics: () {
                      analytics.trackMarketplacePaginationNext(
                        fromPage: response.pagination.currentPage,
                        toPage: response.pagination.currentPage + 1,
                      );
                    },
                    onPageNumberAnalytics: (toPage) {
                      analytics.trackMarketplacePaginationPage(
                        fromPage: response.pagination.currentPage,
                        toPage: toPage,
                      );
                    },
                  ),
                );
              },
              withError: (error) => EmptyScrappablesState(
                isSearchResult: false,
                title: AppLocalizations.of(context)!.marketplace_error_loading,
                description: error.description,
                icon: Icons.error_outline_rounded,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
