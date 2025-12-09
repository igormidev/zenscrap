import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/consts.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
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
          const AiUsageCardHeader(
            icon: Icons.auto_awesome,
            title: 'AI Credits Overview',
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _CreditStatCard(
                  label: 'Remaining Credits',
                  value: '\$${remainingCredits.toStringAsFixed(2)}',
                  valueColor: remainingCredits > 0
                      ? context.c.primary
                      : context.c.error,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _CreditStatCard(
                  label: 'Monthly Limit',
                  value: '\$${totalCredits.toStringAsFixed(2)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _UsageProgressBar(usagePercentage: usagePercentage),
          const SizedBox(height: 8),
          Text(
            '${(usagePercentage * 100).toStringAsFixed(1)}% used this month',
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
            'Using your own OpenAI API key',
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
