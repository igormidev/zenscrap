import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
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

  @override
  Widget build(BuildContext context) {
    final maxCount = _calculateMaxCount();
    
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected 
          ? context.c.primaryContainer.withAlpha(50)
          : context.c.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              _buildStatusChips(context),
              const SizedBox(height: 16),
              _buildChart(context, maxCount),
              const SizedBox(height: 8),
              _buildTimeLabels(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader(BuildContext context) {
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
            'Last 12 hours',
            style: context.t.bodySmall,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatusChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (item.maxConcurrencyExceededTotalCount > 0)
          _buildStatusChip(
            context: context,
            label: 'Max concurrency exceeded',
            count: item.maxConcurrencyExceededTotalCount,
            color: Colors.cyan,
          ),
        if (item.insufficientCreditsTotalCount > 0)
          _buildStatusChip(
            context: context,
            label: 'Insufficient credits',
            count: item.insufficientCreditsTotalCount,
            color: Colors.purple,
          ),
        _buildStatusChip(
          context: context,
          label: '2xx',
          count: item.successTotalCount,
          color: Colors.green,
        ),
        if (item.clientErrorTotalCount > 0)
          _buildStatusChip(
            context: context,
            label: '4xx',
            count: item.clientErrorTotalCount,
            color: Colors.orange,
          ),
        if (item.serverErrorTotalCount > 0)
          _buildStatusChip(
            context: context,
            label: '5xx',
            count: item.serverErrorTotalCount,
            color: Colors.red,
          ),
      ],
    );
  }
  
  Widget _buildStatusChip({
    required BuildContext context,
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withAlpha(100),
          width: 1.5,
        ),
      ),
      child: Text(
        '$label: $count',
        style: context.t.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  
  Widget _buildChart(BuildContext context, int maxCount) {
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: item.data.map((hourData) {
          return Expanded(
            child: _buildBar(context, hourData, maxCount),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildBar(BuildContext context, ScrappableRequestPerTimeScope hourData, int maxCount) {
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  if (hourData.serverErrorCount > 0)
                    Colors.red.withAlpha(150)
                  else if (hourData.clientErrorCount > 0)
                    Colors.orange.withAlpha(150)
                  else if (hourData.insufficientCreditsCount > 0)
                    Colors.purple.withAlpha(150)
                  else if (hourData.maxConcurrencyExceededCount > 0)
                    Colors.cyan.withAlpha(150)
                  else
                    Colors.green.withAlpha(150),
                  if (hourData.serverErrorCount > 0)
                    Colors.red
                  else if (hourData.clientErrorCount > 0)
                    Colors.orange
                  else if (hourData.insufficientCreditsCount > 0)
                    Colors.purple
                  else if (hourData.maxConcurrencyExceededCount > 0)
                    Colors.cyan
                  else
                    Colors.green,
                ],
              ),
            ),
            child: Stack(
              children: [
                _buildBarSegment(
                  height: barHeight,
                  value: hourData.successCount,
                  total: totalRequests,
                  color: Colors.green,
                  isBottom: true,
                ),
                _buildBarSegment(
                  height: barHeight,
                  value: hourData.clientErrorCount,
                  total: totalRequests,
                  color: Colors.orange,
                  offset: hourData.successCount,
                ),
                _buildBarSegment(
                  height: barHeight,
                  value: hourData.serverErrorCount,
                  total: totalRequests,
                  color: Colors.red,
                  offset: hourData.successCount + hourData.clientErrorCount,
                ),
                _buildBarSegment(
                  height: barHeight,
                  value: hourData.insufficientCreditsCount,
                  total: totalRequests,
                  color: Colors.purple,
                  offset: hourData.successCount + hourData.clientErrorCount + hourData.serverErrorCount,
                ),
                _buildBarSegment(
                  height: barHeight,
                  value: hourData.maxConcurrencyExceededCount,
                  total: totalRequests,
                  color: Colors.cyan,
                  offset: hourData.successCount + hourData.clientErrorCount + hourData.serverErrorCount + hourData.insufficientCreditsCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBarSegment({
    required double height,
    required int value,
    required int total,
    required Color color,
    int offset = 0,
    bool isBottom = false,
  }) {
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
  
  Widget _buildTimeLabels(BuildContext context) {
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
  
  int _calculateMaxCount() {
    return item.data.map((hourData) {
      return hourData.successCount +
          hourData.clientErrorCount +
          hourData.serverErrorCount +
          hourData.insufficientCreditsCount +
          hourData.maxConcurrencyExceededCount;
    }).reduce(math.max);
  }
}