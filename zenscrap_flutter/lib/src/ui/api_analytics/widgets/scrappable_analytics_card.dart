import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/request_status_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_provider.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/segmented_column_bar.dart';

class ScrappableAnalyticsCard extends ConsumerWidget {
  final ScrappableRequestsAnalyticsItem item;
  final double maxTotalCount;
  // Fixed dimensions for the card
  static const double cardWidth = 320;
  static const double cardHeight = 245;

  const ScrappableAnalyticsCard({
    super.key,
    required this.item,
    required this.maxTotalCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedScrappableProvider);
    final isSelected = selectedItem?.scrappable.id == item.scrappable.id;

    final totalRequests = item.successTotalCount +
        item.clientErrorTotalCount +
        item.serverErrorTotalCount +
        item.insufficientCreditsTotalCount +
        item.maxConcurrencyExceededTotalCount +
        item.failedAtScrappingBeeTotalCount;

    final hasData = totalRequests > 0;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: GestureDetector(
        onTap: () {
          // Track scrappable card click
          ref.read(analyticsServiceProvider).trackApiAnalyticsScrappableCardClick(
            scrappableId: item.scrappable.id!,
            scrappableName: item.scrappable.name,
            isSelecting: !isSelected,
          );

          if (isSelected) {
            ref.read(selectedScrappableProvider.notifier).state = null;
          } else {
            ref.read(selectedScrappableProvider.notifier).state = item;
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? context.c.primaryContainer.withAlpha(80)
                : context.c.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? context.c.primary.withAlpha(150)
                  : context.c.outline.withAlpha(50),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: hasData
              ? _buildCardWithData(context, isSelected, totalRequests)
              : EmptyIndicatorOfRequests(item: item, isSelected: isSelected),
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.95, 0.95), duration: 200.ms),
    );
  }

  Widget _buildCardWithData(
      BuildContext context, bool isSelected, int totalRequests) {
    // Fixed heights to prevent overflow
    const headerHeight = 28.0;
    const statusHeight = 20.0;
    const spacing = 8.0;
    const barsHeight = 152.0; // Remaining space for bars

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Compact header - FIXED HEIGHT
        SizedBox(
          height: headerHeight,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.c.primary.withAlpha(150)
                      : context.c.primaryContainer.withAlpha(100),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.api,
                  color: isSelected ? Colors.white : context.c.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.scrappable.name,
                  style: context.t.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? context.c.primary : context.c.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: context.c.primary,
                  size: 18,
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: 200.ms,
                    )
                    .fadeIn(),
            ],
          ),
        ),
        const SizedBox(height: spacing),

        // Compact status indicators - FIXED HEIGHT
        SizedBox(
          height: statusHeight,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _CompactStatusIndicator(
                    status: RequestStatus.success,
                    count: item.successTotalCount,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _CompactStatusIndicator(
                    status: RequestStatus.clientError,
                    count: item.clientErrorTotalCount,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _CompactStatusIndicator(
                    status: RequestStatus.serverError,
                    count: item.serverErrorTotalCount,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _CompactStatusIndicator(
                    status: RequestStatus.failedAtScrappingBee,
                    count: item.failedAtScrappingBeeTotalCount,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _CompactStatusIndicator(
                    status: RequestStatus.insufficientCredits,
                    count: item.insufficientCreditsTotalCount,
                  ),
                ),
                _CompactStatusIndicator(
                  status: RequestStatus.maxConcurrencyExceeded,
                  count: item.maxConcurrencyExceededTotalCount,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: spacing),

        // Compact column bars - FIXED HEIGHT (percentage-based)
        SizedBox(
          height: barsHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: item.data.asMap().entries.map((entry) {
              final index = entry.key;
              final timeScope = entry.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 1,
                    right: index == item.data.length - 1 ? 0 : 1,
                  ),
                  child: SegmentedColumnBar(
                    timeScope: timeScope,
                    maxCount: maxTotalCount,
                  )
                      .animate()
                      .slideY(
                        begin: 1,
                        end: 0,
                        duration: 400.ms,
                        delay: Duration(milliseconds: index * 20),
                        curve: Curves.easeOutCubic,
                      )
                      .fadeIn(
                        duration: 300.ms,
                        delay: Duration(milliseconds: index * 20),
                      ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class EmptyIndicatorOfRequests extends StatelessWidget {
  const EmptyIndicatorOfRequests({
    super.key,
    required this.item,
    required this.isSelected,
  });
  final bool isSelected;

  final ScrappableRequestsAnalyticsItem item;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_chart_outlined,
            size: 48,
            color: context.c.onSurfaceVariant.withAlpha(100),
          ),
          const SizedBox(height: 8),
          Text(
            item.scrappable.name,
            style: context.t.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isSelected ? context.c.primary : context.c.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'No requests',
            style: context.t.labelSmall?.copyWith(
              color: context.c.onSurfaceVariant.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactStatusIndicator extends StatelessWidget {
  final RequestStatus status;
  final int count;

  const _CompactStatusIndicator({
    required this.status,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: status.label,
      preferBelow: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: status.color.withAlpha(30),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: status.color.withAlpha(80),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              status.icon,
              size: 12,
              color: status.color,
            ),
            const SizedBox(width: 3),
            Text(
              count.toString(),
              style: context.t.labelSmall?.copyWith(
                color: status.color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
