import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/consts.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/widgets/ai_usage_card.dart';

/// Displays the AI credits overview including remaining credits,
/// monthly limit, usage progress bar, and API key status.
class AiCreditsOverviewSection extends StatelessWidget {
  final AccountAIUsage aiUsage;

  const AiCreditsOverviewSection({
    super.key,
    required this.aiUsage,
  });

  @override
  Widget build(BuildContext context) {
    final remainingCredits = aiUsage.totalDollarsSpentFromTotalInUSD;
    final totalCredits = kDefaultMonthlyAICreditsInDollars;
    final usedCredits = totalCredits - remainingCredits;
    final usagePercentage = (usedCredits / totalCredits).clamp(0.0, 1.0);

    final hasOwnApiKey =
        aiUsage.userOpenAiApiKey != null && aiUsage.userOpenAiApiKey!.isNotEmpty;

    return AiUsageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AiUsageCardHeader(
            icon: Icons.auto_awesome,
            title: AppLocalizations.of(context)!.ai_usage_credits_overview,
          ),
          ResponsiveGap.vertical(
            compactSize: 16,
            mediumSize: 18,
            expandedSize: 20,
          ),
          ResponsiveBuilder(
            compact: (context, constraints) => Column(
              children: [
                _CreditStatCard(
                  label: AppLocalizations.of(context)!.ai_usage_remaining_credits,
                  value: '\$${remainingCredits.toStringAsFixed(2)}',
                  valueColor: remainingCredits > 0
                      ? context.c.primary
                      : context.c.error,
                ),
                const SizedBox(height: 12),
                _CreditStatCard(
                  label: AppLocalizations.of(context)!.ai_usage_monthly_limit,
                  value: '\$${totalCredits.toStringAsFixed(2)}',
                ),
              ],
            ),
            medium: (context, constraints) => Row(
              children: [
                Expanded(
                  child: _CreditStatCard(
                    label: AppLocalizations.of(context)!.ai_usage_remaining_credits,
                    value: '\$${remainingCredits.toStringAsFixed(2)}',
                    valueColor: remainingCredits > 0
                        ? context.c.primary
                        : context.c.error,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _CreditStatCard(
                    label: AppLocalizations.of(context)!.ai_usage_monthly_limit,
                    value: '\$${totalCredits.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
          ),
          ResponsiveGap.vertical(
            compactSize: 16,
            mediumSize: 18,
            expandedSize: 20,
          ),
          _UsageProgressBar(usagePercentage: usagePercentage),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.ai_usage_percentage_used(
              (usagePercentage * 100).toStringAsFixed(1),
            ),
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
          if (hasOwnApiKey) ...[
            const SizedBox(height: 16),
            _OwnApiKeyBadge(),
          ],
        ],
      ),
    );
  }
}

class _CreditStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _CreditStatCard({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.t.headlineMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _UsageProgressBar extends StatelessWidget {
  final double usagePercentage;

  const _UsageProgressBar({required this.usagePercentage});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: usagePercentage,
        minHeight: 10,
        backgroundColor: context.c.surfaceContainerHighest,
        valueColor: AlwaysStoppedAnimation<Color>(
          usagePercentage > 0.9
              ? context.c.error
              : usagePercentage > 0.7
                  ? context.c.tertiary
                  : context.c.primary,
        ),
      ),
    );
  }
}

class _OwnApiKeyBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.c.primaryContainer.withAlpha(80),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.key,
            size: 18,
            color: context.c.primary,
          ),
          const SizedBox(width: 10),
          Text(
            AppLocalizations.of(context)!.ai_usage_using_own_api_key,
            style: context.t.bodySmall?.copyWith(
              color: context.c.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
