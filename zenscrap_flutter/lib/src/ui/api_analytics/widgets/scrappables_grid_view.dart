import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_provider.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/scrappable_analytics_card.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/scope_selector_dropdown.dart';

class ScrappablesGridView extends ConsumerStatefulWidget {
  final PaginatedScrappableRequestsAnalytics data;
  final ScrollController scrollController;
  final ValueNotifier<bool> isRefreshVN;
  final bool isLoadingMore;

  const ScrappablesGridView({
    super.key,
    required this.data,
    required this.scrollController,
    required this.isRefreshVN,
    this.isLoadingMore = false,
  });

  @override
  ConsumerState<ScrappablesGridView> createState() =>
      _ScrappablesGridViewState();
}

class _ScrappablesGridViewState extends ConsumerState<ScrappablesGridView> {
  int? _selectedCardIndex;

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
    // Calculate the max count for normalizing bar heights
    double maxTotalCount = 0;
    for (final item in widget.data.items) {
      final totalCount = item.successTotalCount +
          item.clientErrorTotalCount +
          item.serverErrorTotalCount +
          item.insufficientCreditsTotalCount +
          item.maxConcurrencyExceededTotalCount;
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
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Header with title, scope selector, and refresh button
          Row(
            children: [
              Expanded(
                child: Text(
                  'API Analytics',
                  style: context.t.displaySmall,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: widget.isRefreshVN,
                builder: (context, isRefresh, _) {
                  return FilledButton.tonalIcon(
                    onPressed: isRefresh
                        ? null
                        : () async {
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
                    label: const Text('Refresh'),
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
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: context.c.surface.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.c.outline.withAlpha(100),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info,
                    // Icons.storage_outlined,
                    color: context.c.onSurface.withAlpha(150),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'A request can take up to 10 minutes to appear here',
                    style: context.t.bodySmall?.copyWith(
                      color: context.c.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
