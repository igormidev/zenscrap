import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/request_status_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class SegmentedColumnBar extends StatelessWidget {
  final ScrappableRequestPerTimeScope timeScope;
  final double maxCount;

  const SegmentedColumnBar({
    super.key,
    required this.timeScope,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final totalCount = timeScope.successCount +
        timeScope.clientErrorCount +
        timeScope.serverErrorCount +
        timeScope.insufficientCreditsCount +
        timeScope.maxConcurrencyExceededCount;

    // Calculate the percentage height based on maxCount
    final heightPercentage = maxCount > 0 ? totalCount / maxCount : 0;

    // If there are no requests, show a minimal bar
    if (totalCount == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: context.c.outline.withAlpha(50),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      );
    }

    // Calculate segment percentages
    final successPercentage = timeScope.successCount / totalCount;
    final clientErrorPercentage = timeScope.clientErrorCount / totalCount;
    final serverErrorPercentage = timeScope.serverErrorCount / totalCount;
    final insufficientCreditsPercentage =
        timeScope.insufficientCreditsCount / totalCount;
    final maxConcurrencyPercentage =
        timeScope.maxConcurrencyExceededCount / totalCount;

    return Tooltip(
      message: _buildTooltipMessage(),
      preferBelow: true,
      verticalOffset: 20,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use the actual available height from parent constraints
          final availableHeight = constraints.maxHeight;
          final barHeight = availableHeight * heightPercentage;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: barHeight,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  border: Border.all(
                    color: context.c.outline.withAlpha(30),
                    width: 0.5,
                  ),
                ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              child: Column(
                children: [
                  // Max concurrency segment (top)
                  if (timeScope.maxConcurrencyExceededCount > 0)
                    Expanded(
                      flex: (maxConcurrencyPercentage * 1000).toInt(),
                      child: _BarSegment(
                        color: RequestStatus.maxConcurrencyExceeded.color,
                        count: timeScope.maxConcurrencyExceededCount,
                        label: RequestStatus.maxConcurrencyExceeded.label,
                        percentage: maxConcurrencyPercentage,
                      ),
                    ),
                  // Insufficient credits segment
                  if (timeScope.insufficientCreditsCount > 0)
                    Expanded(
                      flex: (insufficientCreditsPercentage * 1000).toInt(),
                      child: _BarSegment(
                        color: RequestStatus.insufficientCredits.color,
                        count: timeScope.insufficientCreditsCount,
                        label: RequestStatus.insufficientCredits.label,
                        percentage: insufficientCreditsPercentage,
                      ),
                    ),
                  // Server error segment
                  if (timeScope.serverErrorCount > 0)
                    Expanded(
                      flex: (serverErrorPercentage * 1000).toInt(),
                      child: _BarSegment(
                        color: RequestStatus.serverError.color,
                        count: timeScope.serverErrorCount,
                        label: RequestStatus.serverError.label,
                        percentage: serverErrorPercentage,
                      ),
                    ),
                  // Client error segment
                  if (timeScope.clientErrorCount > 0)
                    Expanded(
                      flex: (clientErrorPercentage * 1000).toInt(),
                      child: _BarSegment(
                        color: RequestStatus.clientError.color,
                        count: timeScope.clientErrorCount,
                        label: RequestStatus.clientError.label,
                        percentage: clientErrorPercentage,
                      ),
                    ),
                  // Success segment (bottom - green at the base)
                  if (timeScope.successCount > 0)
                    Expanded(
                      flex: (successPercentage * 1000).toInt(),
                      child: _BarSegment(
                        color: RequestStatus.success.color,
                        count: timeScope.successCount,
                        label: RequestStatus.success.label,
                        percentage: successPercentage,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  ),
);
  }

  String _buildTooltipMessage() {
    final dateFormat = DateFormat('MMM d, HH:mm');
    final totalCount = timeScope.successCount +
        timeScope.clientErrorCount +
        timeScope.serverErrorCount +
        timeScope.insufficientCreditsCount +
        timeScope.maxConcurrencyExceededCount;

    final buffer = StringBuffer();
    buffer.writeln('${dateFormat.format(timeScope.start)} - ${dateFormat.format(timeScope.end)}');
    buffer.writeln('Total: $totalCount requests');
    buffer.writeln('');

    if (timeScope.successCount > 0) {
      final percentage =
          (timeScope.successCount / totalCount * 100).toStringAsFixed(1);
      buffer.writeln('✓ Success: ${timeScope.successCount} ($percentage%)');
    }
    if (timeScope.clientErrorCount > 0) {
      final percentage =
          (timeScope.clientErrorCount / totalCount * 100).toStringAsFixed(1);
      buffer.writeln('⚠ 4xx: ${timeScope.clientErrorCount} ($percentage%)');
    }
    if (timeScope.serverErrorCount > 0) {
      final percentage =
          (timeScope.serverErrorCount / totalCount * 100).toStringAsFixed(1);
      buffer.writeln('✗ 5xx: ${timeScope.serverErrorCount} ($percentage%)');
    }
    if (timeScope.insufficientCreditsCount > 0) {
      final percentage = (timeScope.insufficientCreditsCount / totalCount * 100)
          .toStringAsFixed(1);
      buffer.writeln(
          '\$ No Credits: ${timeScope.insufficientCreditsCount} ($percentage%)');
    }
    if (timeScope.maxConcurrencyExceededCount > 0) {
      final percentage =
          (timeScope.maxConcurrencyExceededCount / totalCount * 100)
              .toStringAsFixed(1);
      buffer.writeln(
          '⚡ Max Concurrency: ${timeScope.maxConcurrencyExceededCount} ($percentage%)');
    }

    return buffer.toString().trim();
  }
}

class _BarSegment extends StatefulWidget {
  final Color color;
  final int count;
  final String label;
  final double percentage;

  const _BarSegment({
    required this.color,
    required this.count,
    required this.label,
    required this.percentage,
  });

  @override
  State<_BarSegment> createState() => _BarSegmentState();
}

class _BarSegmentState extends State<_BarSegment> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered ? widget.color : widget.color.withAlpha(200),
          border: _isHovered
              ? Border.all(color: Colors.white.withAlpha(100), width: 1)
              : null,
        ),
      ),
    );
  }
}
