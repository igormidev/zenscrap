import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/request_status_extension.dart';
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
    final l10n = AppLocalizations.of(context)!;
    // Calculate totals from all loaded items
    int totalSuccess = 0;
    int totalClientError = 0;
    int totalServerError = 0;
    int totalInsufficientCredits = 0;
    int totalMaxConcurrency = 0;
    int totalFailedAtScrappingBee = 0;

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
        case RequestStatus.failedAtScrappingBee:
          totalFailedAtScrappingBee++;
          break;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withAlpha(30),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 64,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(width: 16),
                StatCard(
                  label: l10n.api_analytics_status_success,
                  count: totalSuccess,
                  color: RequestStatus.success.color,
                  tooltip: l10n.api_analytics_tooltip_success,
                ),
                const SizedBox(width: 12),
                StatCard(
                  label: l10n.api_analytics_status_4xx,
                  count: totalClientError,
                  color: RequestStatus.clientError.color,
                  tooltip: l10n.api_analytics_tooltip_client_error,
                ),
                const SizedBox(width: 12),
                StatCard(
                  label: l10n.api_analytics_status_5xx,
                  count: totalServerError,
                  color: RequestStatus.serverError.color,
                  tooltip: l10n.api_analytics_tooltip_server_error,
                ),
                const SizedBox(width: 12),
                StatCard(
                  label: l10n.api_analytics_stat_extract_rules_errors,
                  count: totalFailedAtScrappingBee,
                  color: RequestStatus.failedAtScrappingBee.color,
                  tooltip: l10n.api_analytics_tooltip_extract_rules_error,
                ),
                const SizedBox(width: 12),
                StatCard(
                  label: l10n.api_analytics_stat_no_credits,
                  count: totalInsufficientCredits,
                  color: RequestStatus.insufficientCredits.color,
                  tooltip: l10n.api_analytics_tooltip_insufficient_credits,
                ),
                const SizedBox(width: 12),
                StatCard(
                  label: l10n.api_analytics_status_max_concurrency,
                  count: totalMaxConcurrency,
                  color: RequestStatus.maxConcurrencyExceeded.color,
                  tooltip: l10n.api_analytics_tooltip_max_concurrency,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: context.c.surfaceContainerLow.withAlpha(80),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.c.outline.withAlpha(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: context.c.onSurface.withAlpha(120),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.api_analytics_showing_count(data.items.length, data.totalCount),
                    style: context.t.bodySmall?.copyWith(
                      color: context.c.onSurface.withAlpha(150),
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
}
