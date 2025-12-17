import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_provider.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/scrappable_analytics_card.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/scope_selector_dropdown.dart';

class ScrappablesGridView extends ConsumerStatefulWidget {
  final PaginatedScrappableRequestsAnalytics data;
  final ScrollController scrollController;
  final ValueNotifier<bool> isRefreshVN;
  final bool isLoadingMore;
  final bool loadMoreFailed;

  const ScrappablesGridView({
    super.key,
    required this.data,
    required this.scrollController,
    required this.isRefreshVN,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  @override
  ConsumerState<ScrappablesGridView> createState() =>
      _ScrappablesGridViewState();
}

class _ScrappablesGridViewState extends ConsumerState<ScrappablesGridView> {
  int? _selectedCardIndex;
  bool _wasLoadMoreFailed = false;

  String _getScopeExplanation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.data.scope) {
      case AnalyticsTimeScope.lastHour:
        return l10n.api_analytics_column_5_minutes;
      case AnalyticsTimeScope.last12Hours:
        return l10n.api_analytics_column_1_hour;
      case AnalyticsTimeScope.last24Hours:
        return l10n.api_analytics_column_2_hours;
      case AnalyticsTimeScope.last7Days:
        return l10n.api_analytics_column_1_day;
      case AnalyticsTimeScope.last30Days:
        return l10n.api_analytics_column_1_day;
    }
  }

  @override
  void initState() {
    super.initState();
    // Listen to selection changes to auto-scroll
    ref.listenManual(selectedScrappableProvider, (previous, next) {
      if (next != null && mounted) {
        // Find the index of the selected card
        final index = widget.data.items.indexWhere(
          (item) => item.scrappable.id == next.scrappable.id,
        );
        if (index != -1) {
          _selectedCardIndex = index;
          // Delay scroll to allow animation to complete
          Future.delayed(const Duration(milliseconds: 350), () {
            if (mounted) {
              _scrollToSelectedCard();
            }
          });
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant ScrappablesGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Show snackbar when load more fails
    if (widget.loadMoreFailed && !_wasLoadMoreFailed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.api_analytics_load_more_failed),
              action: SnackBarAction(
                label: l10n.api_analytics_retry,
                onPressed: () {
                  ref.read(analyticsProvider.notifier).clearLoadMoreError();
                  ref.read(analyticsProvider.notifier).loadMoreAnalytics();
                },
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      });
    }
    _wasLoadMoreFailed = widget.loadMoreFailed;
  }

  void _scrollToSelectedCard() {
    if (_selectedCardIndex == null || !widget.scrollController.hasClients) {
      return;
    }

    // Calculate the approximate position of the card in Wrap layout
    const padding = 16.0;
    const cardHeight = ScrappableAnalyticsCard.cardHeight;
    const cardWidth = ScrappableAnalyticsCard.cardWidth;
    const spacing = 16.0;

    // Get available width for wrap
    final screenWidth = MediaQuery.of(context).size.width;
    final selectedItem = ref.read(selectedScrappableProvider);
    final availableWidth = selectedItem != null
        ? screenWidth - 489 - 1 // subtract side panel width and divider
        : screenWidth;

    // Calculate cards per row in wrap
    final cardsPerRow =
        ((availableWidth - (padding * 2) + spacing) / (cardWidth + spacing))
            .floor();

    // Calculate row index
    final rowIndex = _selectedCardIndex! ~/ cardsPerRow;

    // Calculate scroll offset
    final scrollOffset = (rowIndex * (cardHeight + spacing));

    // Smoothly scroll to position
    widget.scrollController.animateTo(
      scrollOffset.clamp(
        0,
        widget.scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Track page view
    ref.read(analyticsServiceProvider).trackApiAnalyticsPageView(
      scrappableCount: widget.data.items.length,
      timeScope: widget.data.scope.name,
    );

    // Calculate the max count for normalizing bar heights
    double maxTotalCount = 0;
    for (final item in widget.data.items) {
      final totalCount = item.successTotalCount +
          item.clientErrorTotalCount +
          item.serverErrorTotalCount +
          item.insufficientCreditsTotalCount +
          item.maxConcurrencyExceededTotalCount +
          item.failedAtScrappingBeeTotalCount;
      if (totalCount > maxTotalCount) {
        maxTotalCount = totalCount.toDouble();
      }
    }

    return ValueListenableBuilder(
      valueListenable: widget.isRefreshVN,
      builder: (context, isRefresh, child) {
        return Opacity(
          opacity: isRefresh ? 0.5 : 1.0,
          child: IgnorePointer(
            ignoring: isRefresh,
            child: child!,
          ),
        );
      },
      child: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Column(
        children: [
          const SizedBox(height: 12),
          // Header with title, scope selector, and refresh button
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.api_analytics_title,
                      style: context.t.displaySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.api_analytics_subtitle,
                      style: context.t.bodyMedium?.copyWith(
                        color: context.c.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: widget.isRefreshVN,
                builder: (context, isRefresh, _) {
                  return FilledButton.tonalIcon(
                    onPressed: isRefresh
                        ? null
                        : () async {
                            // Track refresh click
                            ref.read(analyticsServiceProvider).trackApiAnalyticsRefreshClick(
                              timeScope: widget.data.scope.name,
                            );

                            widget.isRefreshVN.value = true;
                            try {
                              await Future.delayed(
                                  const Duration(milliseconds: 600));
                              await ref.globalLoadingSetter(() async {
                                await ref
                                    .read(analyticsProvider.notifier)
                                    .getAnalyticsData();
                              });
                            } finally {
                              widget.isRefreshVN.value = false;
                            }
                          },
                    label: Text(l10n.api_analytics_refresh),
                    icon: isRefresh
                        ? const CupertinoActivityIndicator()
                        : const Icon(Icons.refresh),
                  );
                },
              ),
              const SizedBox(width: 12),
              const ScopeSelectorDropdown(),
              const SizedBox(width: 12),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.c.primaryContainer.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.c.primary.withAlpha(40),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      color: context.c.primary.withAlpha(180),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.api_analytics_request_delay_warning,
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: context.c.surfaceContainerLow.withAlpha(60),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.c.outline.withAlpha(40),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: context.c.onSurface.withAlpha(120),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getScopeExplanation(context),
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.onSurface.withAlpha(150),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Wrap with cards
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Align(
                alignment: Alignment.topLeft,
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  runAlignment: WrapAlignment.start,
                  alignment: WrapAlignment.start,
                  children: [
                    ...widget.data.items.map((item) {
                      return ScrappableAnalyticsCard(
                        item: item,
                        maxTotalCount: maxTotalCount,
                      );
                    }),
                    if (widget.isLoadingMore)
                      const SizedBox(
                        width: ScrappableAnalyticsCard.cardWidth,
                        height: ScrappableAnalyticsCard.cardHeight,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (widget.loadMoreFailed)
                      SizedBox(
                        width: ScrappableAnalyticsCard.cardWidth,
                        height: ScrappableAnalyticsCard.cardHeight,
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              ref.read(analyticsProvider.notifier).clearLoadMoreError();
                              ref.read(analyticsProvider.notifier).loadMoreAnalytics();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    size: 32,
                                    color: context.c.error,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.api_analytics_load_more_failed,
                                    textAlign: TextAlign.center,
                                    style: context.t.bodySmall?.copyWith(
                                      color: context.c.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
        },
      ),
    );
  }
}
