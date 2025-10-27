import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/category_filter.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_search_bar.dart';

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
        SizedBox(height: 20),
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
        const SizedBox(
          width: double.infinity,
          child: MarketplaceSearchBar(),
        ),
        const SizedBox(height: 16),
        _CategoryFilterSection(
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

class _CategoryFilterSection extends StatefulWidget {
  const _CategoryFilterSection({
    required this.selectedCategories,
    required this.onCategoriesChanged,
  });

  final Set<ScraperCategory> selectedCategories;
  final ValueChanged<Set<ScraperCategory>> onCategoriesChanged;

  @override
  State<_CategoryFilterSection> createState() => _CategoryFilterSectionState();
}

class _CategoryFilterSectionState extends State<_CategoryFilterSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.c.outlineVariant.withAlpha(128),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    size: 20,
                    color: context.c.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.selectedCategories.isEmpty
                        ? 'Filter by category'
                        : '${widget.selectedCategories.length} ${widget.selectedCategories.length == 1 ? 'category' : 'categories'} selected',
                    style: context.t.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.c.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: context.c.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: CategoryFilter(
                selectedCategories: widget.selectedCategories,
                onCategoriesChanged: widget.onCategoriesChanged,
              ),
            ),
        ],
      ),
    );
  }
}
