import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/duration_extension.dart';
import 'package:zenscrap_flutter/src/core/extensions/request_status_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
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

    // Get current user's account ID to determine ownership
    final currentAccountId = ref.watch(accountProvider).mapOrNull(
      withData: (value) => value.accountInfo.id,
    );
    final isOwnedByUser = currentAccountId != null &&
        item.scrappable.accountId == currentAccountId;

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
            ref.read(selectedScrappableProvider.notifier).clear();
          } else {
            ref.read(selectedScrappableProvider.notifier).select(item);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? context.c.primaryContainer.withAlpha(50)
                : context.c.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? context.c.primary.withAlpha(100)
                  : context.c.outline.withAlpha(30),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.c.primary.withAlpha(15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: hasData
              ? _CardWithDataContent(
                  item: item,
                  isSelected: isSelected,
                  totalRequests: totalRequests,
                  isOwnedByUser: isOwnedByUser,
                  maxTotalCount: maxTotalCount,
                )
              : _EmptyIndicatorOfRequests(item: item, isSelected: isSelected, isOwnedByUser: isOwnedByUser),
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms)
          .scale(begin: const Offset(0.95, 0.95), duration: 200.ms),
    );
  }

}

/// Widget that displays the card content when there is data
class _CardWithDataContent extends StatelessWidget {
  final ScrappableRequestsAnalyticsItem item;
  final bool isSelected;
  final int totalRequests;
  final bool isOwnedByUser;
  final double maxTotalCount;

  const _CardWithDataContent({
    required this.item,
    required this.isSelected,
    required this.totalRequests,
    required this.isOwnedByUser,
    required this.maxTotalCount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Fixed heights to prevent overflow
    const headerHeight = 28.0;
    const ownershipBadgeHeight = 18.0;
    const statusHeight = 20.0;
    const spacing = 8.0;
    const barsHeight = 126.0; // Remaining space for bars (reduced to accommodate ownership badge)

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
                      ? context.c.primary.withAlpha(100)
                      : context.c.primaryContainer.withAlpha(60),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.api,
                  color: isSelected ? context.c.onPrimary : context.c.primary.withAlpha(200),
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
        const SizedBox(height: 4),
        // Ownership badge and average duration - FIXED HEIGHT
        SizedBox(
          height: ownershipBadgeHeight,
          child: Row(
            children: [
              _OwnershipBadge(
                isOwnedByUser: isOwnedByUser,
                l10n: l10n,
              ),
              if (item.scrappable.averageDurationInfo != null) ...[
                const SizedBox(width: 6),
                _AverageDurationBadge(
                  averageDuration: item.scrappable.averageDurationInfo!.averageDuration,
                  l10n: l10n,
                ),
              ],
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

class _EmptyIndicatorOfRequests extends StatelessWidget {
  const _EmptyIndicatorOfRequests({
    required this.item,
    required this.isSelected,
    required this.isOwnedByUser,
  });
  final bool isSelected;
  final bool isOwnedByUser;

  final ScrappableRequestsAnalyticsItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
          _OwnershipBadge(isOwnedByUser: isOwnedByUser, l10n: l10n),
          const SizedBox(height: 4),
          Text(
            l10n.api_analytics_no_requests,
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: status.color.withAlpha(18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: status.color.withAlpha(50),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              status.icon,
              size: 11,
              color: status.color.withAlpha(200),
            ),
            const SizedBox(width: 4),
            Text(
              count.toString(),
              style: context.t.labelSmall?.copyWith(
                color: status.color.withAlpha(230),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small badge indicating whether the endpoint belongs to the user or is from the marketplace.
class _OwnershipBadge extends StatelessWidget {
  final bool isOwnedByUser;
  final AppLocalizations l10n;

  const _OwnershipBadge({
    required this.isOwnedByUser,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = isOwnedByUser
        ? context.c.primary
        : context.c.tertiary;
    final badgeText = isOwnedByUser
        ? l10n.api_analytics_badge_yours
        : l10n.api_analytics_badge_marketplace;
    final badgeIcon = isOwnedByUser
        ? Icons.person_outline
        : Icons.storefront_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: badgeColor.withAlpha(40),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            badgeIcon,
            size: 10,
            color: badgeColor.withAlpha(200),
          ),
          const SizedBox(width: 4),
          Text(
            badgeText,
            style: context.t.labelSmall?.copyWith(
              color: badgeColor.withAlpha(220),
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/// A small badge showing the average request duration.
class _AverageDurationBadge extends StatelessWidget {
  final Duration averageDuration;
  final AppLocalizations l10n;

  const _AverageDurationBadge({
    required this.averageDuration,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = context.c.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: badgeColor.withAlpha(40),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 10,
            color: badgeColor.withAlpha(200),
          ),
          const SizedBox(width: 4),
          Text(
            '${l10n.api_analytics_average_duration_prefix}${averageDuration.shortFormat}',
            style: context.t.labelSmall?.copyWith(
              color: badgeColor.withAlpha(220),
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
