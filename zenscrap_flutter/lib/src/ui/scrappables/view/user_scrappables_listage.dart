import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/plan_tier_extension.dart';
import 'package:zenscrap_flutter/src/core/mixins/edit_scrappable.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/scrappables_listage_template.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/pagination_controls.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/scrappables_search_bar.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/category_filter_section.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/empty_scrappables_state.dart';
import 'package:zenscrap_flutter/src/design_system/scrappables_listage_ui_template/loading_scrappables_state.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/dialogs/upgrade_plan_dialog.dart';
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
      loading: (data) {
        // Check if we have previous data to show while loading
        final hasData = data.response != null;

        if (!hasData) {
          // First load - show the empty page with loading
          return const EmptyScrappableListageIndicatorPage();
        }

        // We have previous data - show header with loading indicator
        return _UserScrappablesLayout(
          analytics: analytics,
          searchQuery: data.searchQuery,
          selectedCategories: data.selectedCategories,
          contentWidget: const LoadingScrappablesState(),
        );
      },
      withError: (data) {
        final response = data.response;

        if (response == null) {
          return const EmptyScrappableListageIndicatorPage();
        }

        return _UserScrappablesLayout(
          analytics: analytics,
          searchQuery: data.searchQuery,
          selectedCategories: data.selectedCategories,
          contentWidget: EmptyScrappablesState(
            isSearchResult: false,
            title: AppLocalizations.of(context)!.scrappables_error_loading,
            description: data.error.description,
            icon: Icons.error_outline_rounded,
          ),
        );
      },
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

        // Content widget based on whether we have scrappables
        final l10n = AppLocalizations.of(context)!;
        final contentWidget = scrappables.isEmpty
            ? EmptyScrappablesState(
                isSearchResult: true,
                searchQuery: searchQuery.isNotEmpty
                    ? searchQuery
                    : (selectedCategories.length == 1
                        ? l10n.scrappables_selected_category
                        : l10n.scrappables_selected_categories),
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
                title: l10n.scrappables_no_results,
                description: searchQuery.isNotEmpty
                    ? l10n.scrappables_try_different_keywords
                    : l10n.scrappables_try_different_categories,
              )
            : ScrappablesListageTemplate(
                scrappables: scrappables,
                pagination: pagination,
                accountId: accountId,
                source: ScrappableCardSource.userScrappables,
                paginationControls: PaginationControls(
                  pagination: pagination,
                  onPageChanged: (page) {
                    ref.read(userScrappablesProvider.notifier).changePage(page);
                  },
                  mode: PaginationMode.pageNumbers,
                  onLoadMoreAnalytics: () {
                    analytics.trackUserScrappablesLoadMoreClick(
                      currentPage: pagination.currentPage,
                      totalPages: pagination.totalPages,
                    );
                  },
                ),
              );

        return _UserScrappablesLayout(
          analytics: analytics,
          searchQuery: searchQuery,
          selectedCategories: selectedCategories,
          contentWidget: contentWidget,
        );
      },
    );
  }
}

/// Layout widget that always shows header, search, and filters
class _UserScrappablesLayout extends ConsumerWidget {
  const _UserScrappablesLayout({
    required this.analytics,
    required this.searchQuery,
    required this.selectedCategories,
    required this.contentWidget,
  });

  final dynamic analytics;
  final String searchQuery;
  final Set<ScraperCategory> selectedCategories;
  final Widget contentWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get account info for plan tier
    final accountState = ref.watch(accountProvider);
    final planTier = accountState.mapOrNull(
          withData: (data) => data.accountInfo.planTier,
        ) ??
        PlanTier.none;

    // Get total user scrappables count from state
    final scrappablesState = ref.watch(userScrappablesProvider);
    final totalUserScrappables = scrappablesState.mapOrNull(
          withData: (data) => data.response.pagination.totalUserScrappables,
          loading: (data) => data.response?.pagination.totalUserScrappables,
          withError: (data) => data.response?.pagination.totalUserScrappables,
        ) ??
        0;

    final maxAllowed = planTier.maxScrappables;
    final isAtLimit = totalUserScrappables >= maxAllowed;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                l10n.scrappables_your_endpoints,
                style: context.t.displaySmall,
              ),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: () async {
                  // Track create new click
                  await analytics.trackUserScrappablesCreateNewClick();

                  // Check if user is at their endpoint limit
                  if (isAtLimit) {
                    if (!context.mounted) return;
                    await showEndpointLimitUpgradeDialog(
                      context,
                      currentCount: totalUserScrappables,
                      maxAllowed: maxAllowed,
                      currentPlan: planTier,
                      nextPlan: planTier.nextTier,
                    );
                    return;
                  }

                  ref.read(scrapChatProvider.notifier).reset();
                  if (!context.mounted) return;
                  final result = await context.push('/scrappable-form');
                  if (result == true) {
                    unawaited(ref
                        .read(userScrappablesProvider.notifier)
                        .getScrappables());
                  }
                },
                label: Text(l10n.scrappables_create_new),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ScrappablesSearchBar(
            hintText: l10n.scrappables_search_hint,
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
          Expanded(child: contentWidget),
        ],
      ),
    );
  }
}
