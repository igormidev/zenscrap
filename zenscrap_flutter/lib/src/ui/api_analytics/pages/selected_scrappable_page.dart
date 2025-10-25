import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
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
    final state = ref.watch(selectedScrappableAnalyticsProvider);

    return state.when(
      none: () => const NoSelectedScrappableIndicatorPage(),
      loading: () => const Center(child: CircularProgressIndicator()),
      loadingMore: (currentData) => _AnalyticsListView(
        data: currentData,
        scrollController: _scrollController,
        isLoadingMore: true,
      ),
      withData: (data) => _AnalyticsListView(
        data: data,
        scrollController: _scrollController,
      ),
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
          child: ListView.builder(
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
