import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/mixins/edit_scrappable.dart';
import 'package:zenscrap_flutter/src/design_system/elements/scrappable_grid_listage.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/category_filter.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/pages/empty_scrappable_listage_indicator_page.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/widgets/user_scrappables_search_bar.dart';

class UserScrappablesListage extends ConsumerStatefulWidget {
  const UserScrappablesListage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserScrappablesListageState();
}

class _UserScrappablesListageState extends ConsumerState<UserScrappablesListage>
    with EditScrappable {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(userScrappablesProvider.notifier).getScrappables());
    });
  }

  @override
  Widget build(BuildContext context) {
    final analytics = ref.read(analyticsServiceProvider);
    final accountId = ref.watch(accountProvider).mapOrNull(
          withData: (value) => value.accountInfo.id,
        );
    final state = ref.watch(userScrappablesProvider);

    return state.map(
      initial: (_) => EmptyScrappableListageIndicatorPage(),
      loading: (_) => EmptyScrappableListageIndicatorPage(),
      withError: (_) => EmptyScrappableListageIndicatorPage(),
      withData: (data) {
        final response = data.response;
        final searchQuery = data.searchQuery;
        final selectedCategories = data.selectedCategories;
        final scrappables = response.data;
        final pagination = response.pagination;

        // Track page view
        analytics.trackUserScrappablesPageView(
          scrappableCount: scrappables.length,
          hasSearchQuery: searchQuery.isNotEmpty,
        );

        if (scrappables.isEmpty && searchQuery.isEmpty) {
          return EmptyScrappableListageIndicatorPage();
        }

        return Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Your endpoints',
                  style: context.t.displaySmall,
                ),
                Spacer(),
                FilledButton.tonalIcon(
                  onPressed: () async {
                    // Track create new click
                    await analytics.trackUserScrappablesCreateNewClick();

                    ref.read(scrapChatProvider.notifier).reset();
                    final result = await context.push('/scrappable-form');
                    if (result == true) {
                      unawaited(ref
                          .read(userScrappablesProvider.notifier)
                          .getScrappables());
                    }
                  },
                  label: Text('Create new endpoint'),
                  icon: Icon(Icons.add),
                ),
                SizedBox(width: 20),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: UserScrappablesSearchBar(),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _CategoryFilterSection(
                selectedCategories: selectedCategories,
                onCategoriesChanged: (categories) {
                  ref
                      .read(userScrappablesProvider.notifier)
                      .filterByCategories(categories);
                },
              ),
            ),
            SizedBox(height: 16),
            if (scrappables.isEmpty && searchQuery.isNotEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: context.c.onSurfaceVariant.withAlpha(128),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No endpoints found',
                        style: context.t.titleLarge?.copyWith(
                          color: context.c.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try searching with different keywords',
                        style: context.t.bodyMedium?.copyWith(
                          color: context.c.onSurfaceVariant.withAlpha(179),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ScrappableGridListage(
                        itemCount: scrappables.length,
                        itemBuilder: (context, index) {
                          final scrappable = scrappables[index];
                          return ScrappableCardIndicator(
                            accountId: accountId,
                            scrappable: scrappable,
                          );
                        },
                      ),
                    ),
                    if (pagination.hasNextPage) ...[
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FilledButton.tonal(
                          onPressed: () async {
                            // Track load more click
                            await analytics.trackUserScrappablesLoadMoreClick(
                              currentPage: pagination.currentPage,
                              totalPages: pagination.totalPages,
                            );

                            ref
                                .read(userScrappablesProvider.notifier)
                                .changePage(pagination.currentPage + 1);
                          },
                          child: Text(
                            'Load more (${pagination.currentPage}/${pagination.totalPages})',
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
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
