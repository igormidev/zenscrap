import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/request_status_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:intl/intl.dart';

class ScrappableRequestsAnalyticsCard extends StatelessWidget {
  final ScrappableRequestsAnalyticsItem item;
  final VoidCallback onTap;
  final bool isSelected;
  
  const ScrappableRequestsAnalyticsCard({
    super.key,
    required this.item,
    required this.onTap,
    this.isSelected = false,
  });

  int _calculateMaxCount() {
    return item.data.map((hourData) {
      return hourData.successCount +
          hourData.clientErrorCount +
          hourData.serverErrorCount +
          hourData.insufficientCreditsCount +
          hourData.maxConcurrencyExceededCount;
    }).reduce(math.max);
  }

  @override
  Widget build(BuildContext context) {
    final maxCount = _calculateMaxCount();

    return Card(
      elevation: isSelected ? 2 : 0,
      shadowColor: isSelected ? context.c.primary.withAlpha(50) : Colors.transparent,
      color: isSelected
          ? context.c.primaryContainer.withAlpha(40)
          : context.c.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? context.c.primary.withAlpha(100)
              : context.c.outline.withAlpha(30),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(item: item),
              const SizedBox(height: 16),
              _StatusChipsSection(item: item),
              const SizedBox(height: 16),
              _ChartSection(item: item, maxCount: maxCount),
              const SizedBox(height: 8),
              _TimeLabelsRow(item: item),
            ],
          ),
        ),
      ),
    );
  }
}

/// Header section displaying scrappable name and description
class _Header extends StatelessWidget {
  final ScrappableRequestsAnalyticsItem item;

  const _Header({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.scrappable.name,
                style: context.t.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (item.scrappable.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.scrappable.description,
                  style: context.t.bodySmall?.copyWith(
                    color: context.c.onSurface.withAlpha(150),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.c.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            l10n.api_analytics_last_12_hours,
            style: context.t.bodySmall,
          ),
        ),
      ],
    );
  }
}

/// Status chips section showing request counts by status
class _StatusChipsSection extends StatelessWidget {
  final ScrappableRequestsAnalyticsItem item;

  const _StatusChipsSection({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (item.maxConcurrencyExceededTotalCount > 0)
          _StatusChip(
            label: l10n.api_analytics_max_concurrency_exceeded,
            count: item.maxConcurrencyExceededTotalCount,
            color: RequestStatus.maxConcurrencyExceeded.color,
          ),
        if (item.insufficientCreditsTotalCount > 0)
          _StatusChip(
            label: l10n.api_analytics_insufficient_credits_chip,
            count: item.insufficientCreditsTotalCount,
            color: RequestStatus.insufficientCredits.color,
          ),
        _StatusChip(
          label: l10n.api_analytics_status_2xx,
          count: item.successTotalCount,
          color: RequestStatus.success.color,
        ),
        if (item.clientErrorTotalCount > 0)
          _StatusChip(
            label: l10n.api_analytics_status_4xx,
            count: item.clientErrorTotalCount,
            color: RequestStatus.clientError.color,
          ),
        if (item.serverErrorTotalCount > 0)
          _StatusChip(
            label: l10n.api_analytics_status_5xx,
            count: item.serverErrorTotalCount,
            color: RequestStatus.serverError.color,
          ),
      ],
    );
  }
}

/// Individual status chip widget
class _StatusChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withAlpha(60),
          width: 1,
        ),
      ),
      child: Text(
        '$label: $count',
        style: context.t.bodySmall?.copyWith(
          color: color.withAlpha(220),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Chart section showing bar chart of requests over time
class _ChartSection extends StatelessWidget {
  final ScrappableRequestsAnalyticsItem item;
  final int maxCount;

  const _ChartSection({
    required this.item,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: item.data.map((hourData) {
          return Expanded(
            child: _BarColumn(hourData: hourData, maxCount: maxCount),
          );
        }).toList(),
      ),
    );
  }
}

/// Individual bar column in the chart
class _BarColumn extends StatelessWidget {
  final ScrappableRequestPerTimeScope hourData;
  final int maxCount;

  const _BarColumn({
    required this.hourData,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final totalRequests = hourData.successCount +
        hourData.clientErrorCount +
        hourData.serverErrorCount +
        hourData.insufficientCreditsCount +
        hourData.maxConcurrencyExceededCount;

    final barHeight = maxCount > 0 ? (totalRequests / maxCount) * 100 : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (totalRequests > 0) ...[
            Text(
              totalRequests.toString(),
              style: context.t.bodySmall?.copyWith(
                fontSize: 10,
                color: context.c.onSurface.withAlpha(180),
              ),
            ),
            const SizedBox(height: 2),
          ],
          Container(
            height: barHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  if (hourData.serverErrorCount > 0)
                    RequestStatus.serverError.color.withAlpha(150)
                  else if (hourData.clientErrorCount > 0)
                    RequestStatus.clientError.color.withAlpha(150)
                  else if (hourData.insufficientCreditsCount > 0)
                    RequestStatus.insufficientCredits.color.withAlpha(150)
                  else if (hourData.maxConcurrencyExceededCount > 0)
                    RequestStatus.maxConcurrencyExceeded.color.withAlpha(150)
                  else
                    RequestStatus.success.color.withAlpha(150),
                  if (hourData.serverErrorCount > 0)
                    RequestStatus.serverError.color
                  else if (hourData.clientErrorCount > 0)
                    RequestStatus.clientError.color
                  else if (hourData.insufficientCreditsCount > 0)
                    RequestStatus.insufficientCredits.color
                  else if (hourData.maxConcurrencyExceededCount > 0)
                    RequestStatus.maxConcurrencyExceeded.color
                  else
                    RequestStatus.success.color,
                ],
              ),
            ),
            child: Stack(
              children: [
                _BarSegmentWidget(
                  height: barHeight,
                  value: hourData.successCount,
                  total: totalRequests,
                  color: RequestStatus.success.color,
                  offset: 0,
                ),
                _BarSegmentWidget(
                  height: barHeight,
                  value: hourData.clientErrorCount,
                  total: totalRequests,
                  color: RequestStatus.clientError.color,
                  offset: hourData.successCount,
                ),
                _BarSegmentWidget(
                  height: barHeight,
                  value: hourData.serverErrorCount,
                  total: totalRequests,
                  color: RequestStatus.serverError.color,
                  offset: hourData.successCount + hourData.clientErrorCount,
                ),
                _BarSegmentWidget(
                  height: barHeight,
                  value: hourData.insufficientCreditsCount,
                  total: totalRequests,
                  color: RequestStatus.insufficientCredits.color,
                  offset: hourData.successCount + hourData.clientErrorCount + hourData.serverErrorCount,
                ),
                _BarSegmentWidget(
                  height: barHeight,
                  value: hourData.maxConcurrencyExceededCount,
                  total: totalRequests,
                  color: RequestStatus.maxConcurrencyExceeded.color,
                  offset: hourData.successCount + hourData.clientErrorCount + hourData.serverErrorCount + hourData.insufficientCreditsCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual segment within a bar
class _BarSegmentWidget extends StatelessWidget {
  final double height;
  final int value;
  final int total;
  final Color color;
  final int offset;

  const _BarSegmentWidget({
    required this.height,
    required this.value,
    required this.total,
    required this.color,
    required this.offset,
  });

  @override
  Widget build(BuildContext context) {
    if (value == 0) return const SizedBox.shrink();

    final segmentHeight = total > 0 ? (value / total) * height : 0.0;
    final offsetHeight = total > 0 ? (offset / total) * height : 0.0;

    return Positioned(
      bottom: offsetHeight,
      left: 0,
      right: 0,
      child: Container(
        height: segmentHeight,
        color: color.withAlpha(180),
      ),
    );
  }
}

/// Time labels row showing start and end times
class _TimeLabelsRow extends StatelessWidget {
  final ScrappableRequestsAnalyticsItem item;

  const _TimeLabelsRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('HH:mm');

    return Row(
      children: [
        Text(
          dateFormat.format(item.data.first.start),
          style: context.t.bodySmall?.copyWith(
            fontSize: 10,
            color: context.c.onSurface.withAlpha(150),
          ),
        ),
        const Spacer(),
        Text(
          dateFormat.format(item.data.last.end),
          style: context.t.bodySmall?.copyWith(
            fontSize: 10,
            color: context.c.onSurface.withAlpha(150),
          ),
        ),
      ],
    );
  }
}