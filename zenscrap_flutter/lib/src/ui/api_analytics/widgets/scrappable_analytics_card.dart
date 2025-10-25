import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_provider.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/segmented_column_bar.dart';

class ScrappableAnalyticsCard extends ConsumerWidget {
  final ScrappableRequestsAnalyticsItem item;
  final double maxTotalCount;

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
        item.maxConcurrencyExceededTotalCount;

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          ref.read(selectedScrappableProvider.notifier).state = null;
        } else {
          ref.read(selectedScrappableProvider.notifier).state = item;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.c.primaryContainer.withAlpha(80)
              : context.c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? context.c.primary.withAlpha(150)
                : context.c.outline.withAlpha(50),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with scrappable name and icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.c.primary.withAlpha(150)
                        : context.c.primaryContainer.withAlpha(100),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.api,
                    color: isSelected ? Colors.white : context.c.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.scrappable.name,
                        style: context.t.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? context.c.primary
                              : context.c.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$totalRequests total requests',
                        style: context.t.labelSmall?.copyWith(
                          color: context.c.onSurfaceVariant.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: context.c.primary,
                    size: 24,
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
            const SizedBox(height: 16),

            // Status counts row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (item.successTotalCount > 0)
                  _StatusChip(
                    label: 'Success',
                    count: item.successTotalCount,
                    color: context.c.tertiary,
                    icon: Icons.check_circle,
                  ),
                if (item.clientErrorTotalCount > 0)
                  _StatusChip(
                    label: '4xx',
                    count: item.clientErrorTotalCount,
                    color: Colors.orange,
                    icon: Icons.warning,
                  ),
                if (item.serverErrorTotalCount > 0)
                  _StatusChip(
                    label: '5xx',
                    count: item.serverErrorTotalCount,
                    color: context.c.error,
                    icon: Icons.error,
                  ),
                if (item.insufficientCreditsTotalCount > 0)
                  _StatusChip(
                    label: 'No Credits',
                    count: item.insufficientCreditsTotalCount,
                    color: Colors.purple,
                    icon: Icons.money_off,
                  ),
                if (item.maxConcurrencyExceededTotalCount > 0)
                  _StatusChip(
                    label: 'Max Concurrency',
                    count: item.maxConcurrencyExceededTotalCount,
                    color: Colors.cyan,
                    icon: Icons.speed,
                  ),
                if (totalRequests == 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.c.surfaceContainerHighest.withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: context.c.onSurfaceVariant.withAlpha(150),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'No requests in this period',
                          style: context.t.labelSmall?.copyWith(
                            color: context.c.onSurfaceVariant.withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Column bars visualization
            if (item.data.isNotEmpty)
              SizedBox(
                height: 300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: item.data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final timeScope = entry.value;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 0 : 2,
                          right: index == item.data.length - 1 ? 0 : 2,
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
                              delay: Duration(milliseconds: index * 30),
                              curve: Curves.easeOutCubic,
                            )
                            .fadeIn(
                              duration: 300.ms,
                              delay: Duration(milliseconds: index * 30),
                            ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.2, end: 0, duration: 300.ms, curve: Curves.easeOut),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha(80),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.t.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: context.t.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
