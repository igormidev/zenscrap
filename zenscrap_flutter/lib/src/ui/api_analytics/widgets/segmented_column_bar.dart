import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
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
      preferBelow: false,
      verticalOffset: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: (300 * heightPercentage).toDouble(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: context.c.outline.withAlpha(30),
                width: 0.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Column(
                children: [
                  // Success segment (tertiary/green)
                  if (timeScope.successCount > 0)
                    Expanded(
                      flex: (successPercentage * 1000).toInt(),
                      child: _BarSegment(
                        color: context.c.tertiary,
                        count: timeScope.successCount,
                        label: 'Success',
                        percentage: successPercentage,
                      ),
                    ),
                  // Client error segment (orange)
                  if (timeScope.clientErrorCount > 0)
                    Expanded(
                      flex: (clientErrorPercentage * 1000).toInt(),
                      child: _BarSegment(
                        color: Colors.orange,
                        count: timeScope.clientErrorCount,
                        label: '4xx Error',
                        percentage: clientErrorPercentage,
                      ),
                    ),
                  // Server error segment (red)
                  if (timeScope.serverErrorCount > 0)
                    Expanded(
                      flex: (serverErrorPercentage * 1000).toInt(),
                      child: _BarSegment(
                        color: context.c.error,
                        count: timeScope.serverErrorCount,
                        label: '5xx Error',
                        percentage: serverErrorPercentage,
                      ),
                    ),
                  // Insufficient credits segment (purple)
                  if (timeScope.insufficientCreditsCount > 0)
                    Expanded(
                      flex: (insufficientCreditsPercentage * 1000).toInt(),
                      child: _BarSegment(
                        color: Colors.purple,
                        count: timeScope.insufficientCreditsCount,
                        label: 'No Credits',
                        percentage: insufficientCreditsPercentage,
                      ),
                    ),
                  // Max concurrency segment (cyan)
                  if (timeScope.maxConcurrencyExceededCount > 0)
                    Expanded(
                      flex: (maxConcurrencyPercentage * 1000).toInt(),
                      child: _BarSegment(
                        color: Colors.cyan,
                        count: timeScope.maxConcurrencyExceededCount,
                        label: 'Max Concurrency',
                        percentage: maxConcurrencyPercentage,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
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
        child: Center(
          child: _isHovered && widget.percentage > 0.15
              ? Text(
                  '${(widget.percentage * 100).toStringAsFixed(0)}%',
                  style: context.t.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
