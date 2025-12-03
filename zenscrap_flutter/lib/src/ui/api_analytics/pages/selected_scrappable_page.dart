import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_analytics_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_analytics_state.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/pages/no_selected_scrappable_indicator_page.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/analytics_item_card.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/analytics_stats_summary.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/scrappable_header.dart';
import 'package:intl/intl.dart';

class SelectedScrappablePage extends ConsumerStatefulWidget {
  const SelectedScrappablePage({super.key});

  @override
  ConsumerState<SelectedScrappablePage> createState() =>
      _SelectedScrappablePageState();
}

class _SelectedScrappablePageState
    extends ConsumerState<SelectedScrappablePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      // User is near the bottom, we could trigger load more
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = ref.watch(selectedScrappableProvider);
    final state = ref.watch(selectedScrappableAnalyticsProvider);

    // When a scrappable is selected, load its detailed analytics
    ref.listen(selectedScrappableProvider, (previous, next) {
      if (next == null) {
        // Reset state when nothing is selected
        ref.read(selectedScrappableAnalyticsProvider.notifier).resetState();
      } else if (next.scrappable.id != previous?.scrappable.id) {
        // Track selected scrappable view
        ref.read(analyticsServiceProvider).trackApiAnalyticsSelectedScrappableView(
          scrappableId: next.scrappable.id!,
          scrappableName: next.scrappable.name,
        );

        // Load analytics for the newly selected scrappable
        unawaited(
          ref
              .read(selectedScrappableAnalyticsProvider.notifier)
              .selectScrappable(next.scrappable),
        );
      }
    });

    if (selectedItem == null) {
      return const NoSelectedScrappableIndicatorPage();
    }

    // Check if we need to trigger initial load (ref.listen doesn't fire on first build)
    final needsInitialLoad = state.whenOrNull(
          none: () => true,
          withData: (data) => data.scrappable.id != selectedItem.scrappable.id,
          loadingMore: (data) =>
              data.scrappable.id != selectedItem.scrappable.id,
        ) ??
        false;

    if (needsInitialLoad) {
      // Trigger load after this frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref
              .read(selectedScrappableAnalyticsProvider.notifier)
              .selectScrappable(selectedItem.scrappable);
        }
      });
    }

    // Show the state
    return state.when(
      none: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      loadingMore: (currentData) {
        // Check if data is for the current selection
        if (currentData.scrappable.id == selectedItem.scrappable.id) {
          return _AnalyticsListView(
            data: currentData,
            scrollController: _scrollController,
            isLoadingMore: true,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
      withData: (data) {
        // Check if data is for the current selection
        if (data.scrappable.id == selectedItem.scrappable.id) {
          return _AnalyticsListView(
            data: data,
            scrollController: _scrollController,
          );
        }
        // Data is for a different scrappable, show loading while new data loads
        return const Center(child: CircularProgressIndicator());
      },
      withError: (error) => _AnalyticsErrorState(error: error),
    );
  }
}

class _AnalyticsListView extends StatelessWidget {
  final PaginatedScrappableAnalytics data;
  final ScrollController scrollController;
  final bool isLoadingMore;

  const _AnalyticsListView({
    required this.data,
    required this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm:ss');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrappableHeader(scrappable: data.scrappable),
        AnalyticsStatsSummary(data: data),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: data.items.length + 1,
            itemBuilder: (context, index) {
              if (index == data.items.length) {
                return _LoadMoreSection(
                  data: data,
                  isLoadingMore: isLoadingMore,
                );
              }

              final analytics = data.items[index];
              return AnalyticsItemCard(
                analytics: analytics,
                dateFormat: dateFormat,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LoadMoreSection extends ConsumerWidget {
  final PaginatedScrappableAnalytics data;
  final bool isLoadingMore;

  const _LoadMoreSection({
    required this.data,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!data.hasNextPage) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'No more analytics to load',
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: isLoadingMore
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: () {
                  // Track load more details click
                  ref.read(analyticsServiceProvider).trackApiAnalyticsLoadMoreDetailsClick(
                    scrappableId: data.scrappable.id!,
                    currentCount: data.items.length,
                  );

                  ref
                      .read(selectedScrappableAnalyticsProvider.notifier)
                      .loadMoreAnalytics();
                },
                icon: const Icon(Icons.add),
                label: const Text('Load More'),
              ),
      ),
    );
  }
}

class _AnalyticsErrorState extends ConsumerWidget {
  final String error;

  const _AnalyticsErrorState({
    required this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.c.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error Loading Analytics',
            style: context.t.headlineSmall?.copyWith(
              color: context.c.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(selectedScrappableAnalyticsProvider.notifier)
                  .resetState();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
