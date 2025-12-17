import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_provider.dart';

class ScopeSelectorDropdown extends ConsumerWidget {
  const ScopeSelectorDropdown({super.key});

  String _getScopeLabel(BuildContext context, AnalyticsTimeScope scope) {
    final l10n = AppLocalizations.of(context)!;
    switch (scope) {
      case AnalyticsTimeScope.lastHour:
        return l10n.api_analytics_scope_last_hour;
      case AnalyticsTimeScope.last12Hours:
        return l10n.api_analytics_scope_last_12_hours;
      case AnalyticsTimeScope.last24Hours:
        return l10n.api_analytics_scope_last_24_hours;
      case AnalyticsTimeScope.last7Days:
        return l10n.api_analytics_scope_last_7_days;
      case AnalyticsTimeScope.last30Days:
        return l10n.api_analytics_scope_last_30_days;
    }
  }

  IconData _getScopeIcon(AnalyticsTimeScope scope) {
    switch (scope) {
      case AnalyticsTimeScope.lastHour:
        return Icons.schedule;
      case AnalyticsTimeScope.last12Hours:
        return Icons.access_time;
      case AnalyticsTimeScope.last24Hours:
        return Icons.today;
      case AnalyticsTimeScope.last7Days:
        return Icons.date_range;
      case AnalyticsTimeScope.last30Days:
        return Icons.calendar_month;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentScope = ref.watch(analyticsProvider.notifier).currentScope;
    final l10n = AppLocalizations.of(context)!;

    return Tooltip(
      message: l10n.api_analytics_scope_tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 43,
        decoration: BoxDecoration(
          color: context.c.surfaceContainerHighest.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.c.outline.withAlpha(50),
          ),
        ),
        child: DropdownButton<AnalyticsTimeScope>(
          value: currentScope,
          underline: const SizedBox.shrink(),
          icon: Icon(
            Icons.arrow_drop_down,
            color: context.c.onSurface,
          ),
          dropdownColor: context.c.surface,
          borderRadius: BorderRadius.circular(12),
          items: AnalyticsTimeScope.values.map((scope) {
            return DropdownMenuItem<AnalyticsTimeScope>(
              value: scope,
              child: Row(
                children: [
                  Icon(
                    _getScopeIcon(scope),
                    size: 18,
                    color: context.c.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getScopeLabel(context, scope),
                    style: context.t.labelLarge?.copyWith(
                      color: context.c.onSurface,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (AnalyticsTimeScope? newScope) {
            if (newScope != null) {
              // Track time scope change
              ref.read(analyticsServiceProvider).trackApiAnalyticsTimeScopeChange(
                fromScope: currentScope.name,
                toScope: newScope.name,
              );

              ref
                  .read(analyticsProvider.notifier)
                  .getAnalyticsData(scope: newScope);
            }
          },
        ),
      ),
    );
  }
}
