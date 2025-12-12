import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/plan_tier_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class CreditsOverviewSection extends StatelessWidget {
  final int subscriptionCredits;
  final int purchasedCredits;
  final PlanTier planTier;

  const CreditsOverviewSection({
    super.key,
    required this.subscriptionCredits,
    required this.purchasedCredits,
    required this.planTier,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalCredits = subscriptionCredits + purchasedCredits;
    final creditsOwnedPerMonth = planTier.apiCreditsAddedPerMonthInt;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.outline.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.api_usage_credits_overview,
                style: context.t.titleLarge,
              ),
              Icon(
                Icons.generating_tokens,
                color: context.c.primary,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CreditItem(
                  label: l10n.api_usage_total_available,
                  description: l10n.api_usage_credits_combined_description,
                  value: totalCredits.toString(),
                  icon: Icons.check_circle,
                  isHighlighted: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CreditItem(
                  label: l10n.api_usage_subscription,
                  description: planTier == PlanTier.none
                      ? l10n.api_usage_subscribe_to_unlock
                      : l10n.api_usage_will_renew_monthly(creditsOwnedPerMonth),
                  value: subscriptionCredits.toString(),
                  icon: Icons.calendar_month,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CreditItem(
                  label: l10n.api_usage_purchased,
                  description: l10n.api_usage_purchased_description,
                  value: purchasedCredits.toString(),
                  icon: Icons.shopping_cart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: context.c.onSurfaceVariant.withAlpha(150),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.api_usage_credits_info,
                  style: context.t.labelSmall?.copyWith(
                    color: context.c.onSurfaceVariant.withAlpha(150),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class CreditItem extends StatelessWidget {
  final String label;
  final String value;
  final String description;
  final IconData icon;
  final bool isHighlighted;

  const CreditItem({
    super.key,
    required this.label,
    required this.value,
    required this.description,
    required this.icon,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted
            ? context.c.primaryContainer.withAlpha(100)
            : context.c.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
        border: isHighlighted
            ? Border.all(
                color: context.c.primary.withAlpha(100),
                width: 1.5,
              )
            : Border.all(
                color: context.c.outline.withAlpha(30),
                width: 1,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isHighlighted
                    ? context.c.primary
                    : context.c.onSurfaceVariant,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: context.t.labelMedium?.copyWith(
                    color: context.c.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            maxLines: 2,
            style: context.t.labelSmall?.copyWith(
              color: context.c.onSurfaceVariant.withAlpha(150),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: context.t.headlineSmall?.copyWith(
              color: isHighlighted ? context.c.primary : context.c.onSurface,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
