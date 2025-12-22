import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/scrappables_search_bar.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/category_filter_section.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';

class MarketplaceHeader extends ConsumerWidget {
  const MarketplaceHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketplaceState = ref.watch(marketplaceProvider);
    final selectedCategories = marketplaceState.mapOrNull(
          loaded: (state) => state.selectedCategories,
        ) ??
        {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: context.responsiveValue(
            compact: 16.0,
            medium: 20.0,
            expanded: 20.0,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.marketplace_title,
                style: context.t.displaySmall,
              ),
            ),
            SizedBox(
              width: context.responsiveValue(
                compact: 8.0,
                medium: 16.0,
                expanded: 16.0,
              ),
            ),
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
                AppLocalizations.of(context)!.marketplace_public_scrappables,
                style: context.t.labelLarge?.copyWith(
                  color: context.c.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              tooltip: AppLocalizations.of(context)!.marketplace_refresh_page,
              onPressed: () {
                // Track refresh click
                ref
                    .read(analyticsServiceProvider)
                    .trackMarketplaceRefreshClick();

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
        SizedBox(
          width: double.infinity,
          child: ScrappablesSearchBar(
            hintText: AppLocalizations.of(context)!.marketplace_search_hint,
            onSearch: (query) {
              ref.read(marketplaceProvider.notifier).search(query);
            },
            onSearchStart: (query) {
              ref.read(analyticsServiceProvider).trackMarketplaceSearchStart(
                    searchQuery: query,
                    queryLength: query.length,
                  );
            },
            onSearchClear: () {
              ref.read(analyticsServiceProvider).trackMarketplaceSearchClear();
            },
          ),
        ),
        const SizedBox(height: 16),
        CategoryFilterSection(
          selectedCategories: selectedCategories,
          onCategoriesChanged: (categories) {
            ref
                .read(marketplaceProvider.notifier)
                .filterByCategories(categories);
          },
        ),
      ],
    );
  }
}
