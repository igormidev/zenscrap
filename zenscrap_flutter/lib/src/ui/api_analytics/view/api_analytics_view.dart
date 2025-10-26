import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_state.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_provider.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/pages/selected_scrappable_page.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/scrappables_grid_view.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/pages/empty_scrappable_listage_indicator_page.dart';

class ApiAnalyticsView extends ConsumerStatefulWidget {
  const ApiAnalyticsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ApiAnalyticsViewState();
}

class _ApiAnalyticsViewState extends ConsumerState<ApiAnalyticsView> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isRefreshVN = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(ref.read(analyticsProvider.notifier).getAnalyticsData());
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isRefreshVN.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 500) {
      final analyticsState = ref.read(analyticsProvider);
      final hasNextPage = analyticsState.whenOrNull(
        withData: (data) => data.hasNextPage,
      );
      if (hasNextPage == true) {
        ref.read(analyticsProvider.notifier).loadMoreAnalytics();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final analyticsState = ref.watch(analyticsProvider);

    return analyticsState.when(
      initial: () => const Center(child: CircularProgressIndicator()),
      loading: () => const Center(child: CircularProgressIndicator()),
      loadingMore: (currentData) => _AnalyticsContent(
        data: currentData,
        scrollController: _scrollController,
        isRefreshVN: _isRefreshVN,
        isLoadingMore: true,
      ),
      emptyData: () => const EmptyScrappableListageIndicatorPage(),
      withData: (data) => _AnalyticsContent(
        data: data,
        scrollController: _scrollController,
        isRefreshVN: _isRefreshVN,
      ),
      withError: (error) => _AnalyticsErrorView(error: error),
    );
  }
}

class _AnalyticsContent extends ConsumerWidget {
  final PaginatedScrappableRequestsAnalytics data;
  final ScrollController scrollController;
  final ValueNotifier<bool> isRefreshVN;
  final bool isLoadingMore;

  const _AnalyticsContent({
    required this.data,
    required this.scrollController,
    required this.isRefreshVN,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedScrappableProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      // Mobile layout with tabs
      return Scaffold(
        body: selectedItem == null
            ? ScrappablesGridView(
                data: data,
                scrollController: scrollController,
                isRefreshVN: isRefreshVN,
                isLoadingMore: isLoadingMore,
              )
            : const SelectedScrappablePage(),
        bottomNavigationBar: selectedItem != null
            ? BottomAppBar(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            ref
                                .read(selectedScrappableProvider.notifier)
                                .state = null;
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            selectedItem.scrappable.name,
                            style: context.t.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
      );
    }

    // Desktop layout with animated side panel
    return Row(
      children: [
        // Scrappables grid (left side)
        Expanded(
          child: ScrappablesGridView(
            data: data,
            scrollController: scrollController,
            isRefreshVN: isRefreshVN,
            isLoadingMore: isLoadingMore,
          ),
        ),
        const VerticalDivider(width: 1),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: selectedItem != null ? 489 : 0,
            child: const SelectedScrappablePage()
                .animate()
                .fadeIn(duration: 200.ms, delay: 100.ms)
                .slideX(begin: 0.1, end: 0, duration: 300.ms),
          ),
        ),
      ],
    );
  }
}

class _AnalyticsErrorView extends ConsumerWidget {
  final ZenScrapException error;

  const _AnalyticsErrorView({
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
            error.title,
            style: context.t.headlineSmall?.copyWith(
              color: context.c.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.description,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(analyticsProvider.notifier).getAnalyticsData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
