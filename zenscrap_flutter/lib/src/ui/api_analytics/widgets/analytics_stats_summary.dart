import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/widgets/stat_card.dart';

class AnalyticsStatsSummary extends StatelessWidget {
  final PaginatedScrappableAnalytics data;

  const AnalyticsStatsSummary({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate totals from all loaded items
    int totalSuccess = 0;
    int totalClientError = 0;
    int totalServerError = 0;
    int totalInsufficientCredits = 0;
    int totalMaxConcurrency = 0;

    for (final item in data.items) {
      switch (item.requestStatus) {
        case RequestStatus.success:
          totalSuccess++;
          break;
        case RequestStatus.clientError:
          totalClientError++;
          break;
        case RequestStatus.serverError:
          totalServerError++;
          break;
        case RequestStatus.insufficientCredits:
          totalInsufficientCredits++;
          break;
        case RequestStatus.maxConcurrencyExceeded:
          totalMaxConcurrency++;
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withAlpha(50),
      ),
      child: Row(
        children: [
          StatCard(label: 'Success', count: totalSuccess, color: Colors.green),
          const SizedBox(width: 16),
          StatCard(label: '4xx', count: totalClientError, color: Colors.orange),
          const SizedBox(width: 16),
          StatCard(label: '5xx', count: totalServerError, color: Colors.red),
          const SizedBox(width: 16),
          StatCard(label: 'No Credits', count: totalInsufficientCredits, color: Colors.purple),
          const SizedBox(width: 16),
          StatCard(label: 'Max Concurrency', count: totalMaxConcurrency, color: Colors.cyan),
          const Spacer(),
          Text(
            'Showing ${data.items.length} of ${data.totalCount}',
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}
