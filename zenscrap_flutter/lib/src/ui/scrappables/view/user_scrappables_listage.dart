import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/src/core/mixins/edit_scrappable.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/scrappables_listage_template.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/pagination_controls.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/scrappables_search_bar.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/category_filter_section.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/empty_scrappables_state.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/pages/empty_scrappable_listage_indicator_page.dart';

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
      initial: (_) => const EmptyScrappableListageIndicatorPage(),
      loading: (_) => const EmptyScrappableListageIndicatorPage(),
      withError: (_) => const EmptyScrappableListageIndicatorPage(),
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

        // If no scrappables at all (initial state), show the special empty page
        if (scrappables.isEmpty &&
            searchQuery.isEmpty &&
            selectedCategories.isEmpty) {
          return const EmptyScrappableListageIndicatorPage();
        }

        // Otherwise, show the main layout with search/filter always visible
        return Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Your endpoints',
                  style: context.t.displaySmall,
                ),
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: () async {
                    // Track create new click
                    await analytics.trackUserScrappablesCreateNewClick();

                    ref.read(scrapChatProvider.notifier).reset();
                    if (!context.mounted) return;
                    final result = await context.push('/scrappable-form');
                    if (result == true) {
                      unawaited(ref
                          .read(userScrappablesProvider.notifier)
                          .getScrappables());
                    }
                  },
                  label: const Text('Create new endpoint'),
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 16),
            ScrappablesSearchBar(
              hintText: 'Search your endpoints by name or description...',
              onSearch: (query) {
                ref.read(userScrappablesProvider.notifier).search(query);
              },
              onSearchStart: (query) {
                analytics.trackUserScrappablesSearchStart(
                  searchQuery: query,
                  queryLength: query.length,
                );
              },
              onSearchClear: () {
                analytics.trackUserScrappablesSearchClear();
              },
            ),

            const SizedBox(height: 16),
            CategoryFilterSection(
              selectedCategories: selectedCategories,
              onCategoriesChanged: (categories) {
                ref
                    .read(userScrappablesProvider.notifier)
                    .filterByCategories(categories);
              },
            ),

            const SizedBox(height: 16),
            // Show empty state if no results, but keep it below filters (FIX for the bug)
            if (scrappables.isEmpty)
              Expanded(
                child: EmptyScrappablesState(
                  isSearchResult: true,
                  searchQuery: searchQuery.isNotEmpty
                      ? searchQuery
                      : 'the selected ${selectedCategories.length == 1 ? 'category' : 'categories'}',
                  onClearSearch: () {
                    if (searchQuery.isNotEmpty) {
                      ref.read(userScrappablesProvider.notifier).search('');
                    }
                    if (selectedCategories.isNotEmpty) {
                      ref
                          .read(userScrappablesProvider.notifier)
                          .filterByCategories({});
                    }
                  },
                  title: 'No endpoints found',
                  description: searchQuery.isNotEmpty
                      ? 'Try searching with different keywords or adjust your filters.'
                      : 'Try selecting different categories or clear your filters.',
                ),
              )
            else
              Expanded(
                child: ScrappablesListageTemplate(
                  scrappables: scrappables,
                  pagination: pagination,
                  accountId: accountId,
                  source: ScrappableCardSource.userScrappables,
                  paginationControls: PaginationControls(
                    pagination: pagination,
                    onPageChanged: (page) {
                      ref
                          .read(userScrappablesProvider.notifier)
                          .changePage(page);
                    },
                    mode: PaginationMode.pageNumbers,
                    onLoadMoreAnalytics: () {
                      analytics.trackUserScrappablesLoadMoreClick(
                        currentPage: pagination.currentPage,
                        totalPages: pagination.totalPages,
                      );
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
