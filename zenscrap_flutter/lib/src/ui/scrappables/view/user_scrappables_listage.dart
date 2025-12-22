import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/plan_tier_extension.dart';
import 'package:zenscrap_flutter/src/core/mixins/create_new_scrappable_mixin.dart';
import 'package:zenscrap_flutter/src/core/mixins/edit_scrappable.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
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
    with EditScrappable, CreateNewScrappableMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(userScrappablesProvider.notifier).getScrappables());
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountId = ref
        .watch(accountProvider)
        .mapOrNull(withData: (value) => value.accountInfo.id);
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
          onTapCreateNew: _handleCreateNew,
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
          onTapCreateNew: _handleCreateNew,
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
        ref.read(analyticsServiceProvider).trackUserScrappablesPageView(
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
        final analytics = ref.read(analyticsServiceProvider);
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
          onTapCreateNew: _handleCreateNew,
          searchQuery: searchQuery,
          selectedCategories: selectedCategories,
          contentWidget: contentWidget,
        );
      },
    );
  }

  Future<void> _handleCreateNew(
    BuildContext context, {
    required bool isAtLimit,
    required int totalUserScrappables,
    required int maxAllowed,
    required PlanTier planTier,
  }) async {
    await onTapCreateNewScrappable(
      context,
      isAtLimit: isAtLimit,
      totalUserScrappables: totalUserScrappables,
      maxAllowed: maxAllowed,
      planTier: planTier,
    );
  }
}

/// Callback signature for the create new scrappable action.
typedef OnTapCreateNewCallback = Future<void> Function(
  BuildContext context, {
  required bool isAtLimit,
  required int totalUserScrappables,
  required int maxAllowed,
  required PlanTier planTier,
});

/// Layout widget that always shows header, search, and filters
class _UserScrappablesLayout extends ConsumerWidget {
  const _UserScrappablesLayout({
    required this.onTapCreateNew,
    required this.searchQuery,
    required this.selectedCategories,
    required this.contentWidget,
  });

  final OnTapCreateNewCallback onTapCreateNew;
  final String searchQuery;
  final Set<ScraperCategory> selectedCategories;
  final Widget contentWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(analyticsServiceProvider);

    // Get account info for plan tier
    final accountState = ref.watch(accountProvider);
    final planTier =
        accountState.mapOrNull(withData: (data) => data.accountInfo.planTier) ??
        PlanTier.none;

    // Get total user scrappables count from state
    final scrappablesState = ref.watch(userScrappablesProvider);
    final totalUserScrappables =
        scrappablesState.mapOrNull(
          withData: (data) => data.response.pagination.totalUserScrappables,
          loading: (data) => data.response?.pagination.totalUserScrappables,
          withError: (data) => data.response?.pagination.totalUserScrappables,
        ) ??
        0;

    final maxAllowed = planTier.maxScrappables;
    final isAtLimit = totalUserScrappables >= maxAllowed;
    final l10n = AppLocalizations.of(context)!;

    // Responsive spacing values
    final horizontalPadding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 20.0,
    );
    final topSpacing = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 20.0,
    );
    final sectionSpacing = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );

    return Padding(
      padding: EdgeInsets.only(right: horizontalPadding),
      child: Column(
        children: [
          SizedBox(height: topSpacing),
          Row(
            children: [
              Text(
                l10n.scrappables_your_endpoints,
                style: context.t.displaySmall,
              ),
              const Spacer(),
              CreateNewScrappable(
                onPressed: () => onTapCreateNew(
                  context,
                  isAtLimit: isAtLimit,
                  totalUserScrappables: totalUserScrappables,
                  maxAllowed: maxAllowed,
                  planTier: planTier,
                ),
                label: l10n.scrappables_create_new,
              ),
            ],
          ),
          SizedBox(height: sectionSpacing),
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
          SizedBox(height: sectionSpacing),
          CategoryFilterSection(
            selectedCategories: selectedCategories,
            onCategoriesChanged: (categories) {
              ref
                  .read(userScrappablesProvider.notifier)
                  .filterByCategories(categories);
            },
          ),
          SizedBox(height: sectionSpacing),
          Expanded(child: contentWidget),
        ],
      ),
    );
  }
}

class CreateNewScrappable extends StatelessWidget {
  const CreateNewScrappable({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      label: Text(label),
      icon: const Icon(Icons.add),
    );
  }
}
