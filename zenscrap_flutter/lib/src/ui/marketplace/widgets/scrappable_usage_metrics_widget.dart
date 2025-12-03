import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';

class ScrappableUsageMetricsWidget extends ConsumerStatefulWidget {
  final int scrappableId;

  const ScrappableUsageMetricsWidget({
    super.key,
    required this.scrappableId,
  });

  @override
  ConsumerState<ScrappableUsageMetricsWidget> createState() =>
      _ScrappableUsageMetricsWidgetState();
}

class _ScrappableUsageMetricsWidgetState
    extends ConsumerState<ScrappableUsageMetricsWidget> {
  ScrappableUsageMetrics? _metrics;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final client = ref.read(clientProvider);
      final metrics = await client.privateScrappableAnalytics
          .getScrappableUsageMetrics(scrappableId: widget.scrappableId);

      if (mounted) {
        setState(() {
          _metrics = metrics;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage metrics (last 30 days)',
          style: context.t.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_error != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.c.errorContainer.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: context.c.error.withAlpha(51),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: context.c.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Failed to load metrics',
                    style: context.t.bodySmall?.copyWith(
                      color: context.c.error,
                    ),
                  ),
                ),
              ],
            ),
          )
        else if (_metrics != null)
          _MetricsDisplay(metrics: _metrics!),
      ],
    );
  }
}

class _MetricsDisplay extends StatelessWidget {
  final ScrappableUsageMetrics metrics;

  const _MetricsDisplay({
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = metrics.totalCount > 0;

    if (!hasData) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.c.surfaceContainerHighest.withAlpha(77),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: context.c.outline.withAlpha(51),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: context.c.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'No requests in the last 30 days',
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withAlpha(51),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.c.outline.withAlpha(51),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _MetricsNumbers(metrics: metrics),
          ),
          const SizedBox(width: 24),
          _DonutChart(metrics: metrics),
        ],
      ),
    );
  }
}

class _MetricsNumbers extends StatelessWidget {
  final ScrappableUsageMetrics metrics;

  const _MetricsNumbers({
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final successRate = metrics.totalCount > 0
        ? (metrics.successCount / metrics.totalCount * 100).toStringAsFixed(1)
        : '0.0';
    final errorRate = metrics.totalCount > 0
        ? (metrics.errorCount / metrics.totalCount * 100).toStringAsFixed(1)
        : '0.0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MetricRow(
          icon: Icons.check_circle,
          iconColor: const Color(0xFF81C784), // Pastel green
          label: 'Success',
          count: metrics.successCount,
          percentage: successRate,
        ),
        const SizedBox(height: 12),
        _MetricRow(
          icon: Icons.error,
          iconColor: const Color(0xFFE57373), // Pastel red
          label: 'Errors',
          count: metrics.errorCount,
          percentage: errorRate,
        ),
        const SizedBox(height: 12),
        Divider(color: context.c.outline.withAlpha(51)),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.analytics,
              size: 16,
              color: context.c.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              'Total',
              style: context.t.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.c.onSurface,
              ),
            ),
            const Spacer(),
            Text(
              metrics.totalCount.toString(),
              style: context.t.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.c.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final int count;
  final String percentage;

  const _MetricRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.count,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: context.t.bodyMedium?.copyWith(
            color: context.c.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          count.toString(),
          style: context.t.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.c.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '($percentage%)',
          style: context.t.bodySmall?.copyWith(
            color: context.c.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _DonutChart extends StatelessWidget {
  final ScrappableUsageMetrics metrics;

  const _DonutChart({
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final total = metrics.successCount + metrics.errorCount;

    if (total == 0) {
      return SizedBox(
        width: 100,
        height: 100,
        child: Center(
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.c.outline.withAlpha(51),
                width: 15,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 100,
      height: 100,
      child: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 30,
          startDegreeOffset: -90,
          sections: [
            if (metrics.successCount > 0)
              PieChartSectionData(
                value: metrics.successCount.toDouble(),
                color: const Color(0xFF81C784), // Pastel green
                radius: 20,
                showTitle: false,
              ),
            if (metrics.errorCount > 0)
              PieChartSectionData(
                value: metrics.errorCount.toDouble(),
                color: const Color(0xFFE57373), // Pastel red
                radius: 20,
                showTitle: false,
              ),
          ],
        ),
      ),
    );
  }
}
