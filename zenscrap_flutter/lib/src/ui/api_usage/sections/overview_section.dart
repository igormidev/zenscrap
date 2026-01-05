import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/plan_tier_extension.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

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

    final horizontalPadding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 20.0,
    );
    final verticalSpacing = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );
    final itemSpacing = context.responsiveValue(
      compact: 8.0,
      medium: 12.0,
      expanded: 12.0,
    );
    final borderRadius = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );

    return Container(
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: context.c.outline.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: verticalSpacing + 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: horizontalPadding),
              Expanded(
                child: Text(
                  l10n.api_usage_credits_overview,
                  style: context.t.titleLarge,
                ),
              ),
              Icon(Icons.generating_tokens, color: context.c.primary, size: 28),
              SizedBox(width: horizontalPadding),
            ],
          ),
          SizedBox(height: verticalSpacing),
          Expanded(
            child: LayoutBuilder(
              builder: (context, contraints) {
                final isSmallHeight = contraints.maxHeight < 140;
                if (isSmallHeight) {
                  return SizedBox(
                    height: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 20),
                      children: [
                        SizedBox(
                          width: 160,
                          child: _CreditItem(
                            label: l10n.api_usage_total_available,
                            description:
                                l10n.api_usage_credits_combined_description,
                            value: totalCredits.toString(),
                            icon: Icons.check_circle,
                            isHighlighted: true,
                          ),
                        ),
                        SizedBox(width: itemSpacing),
                        SizedBox(
                          width: 170,
                          child: _CreditItem(
                            label: l10n.api_usage_subscription,
                            description: planTier == PlanTier.none
                                ? l10n.api_usage_subscribe_to_unlock
                                : l10n.api_usage_will_renew_monthly(
                                    creditsOwnedPerMonth,
                                  ),
                            value: subscriptionCredits.toString(),
                            icon: Icons.calendar_month,
                          ),
                        ),
                        SizedBox(width: itemSpacing),
                        SizedBox(
                          width: 200,
                          child: _CreditItem(
                            label: l10n.api_usage_purchased,
                            description: l10n.api_usage_purchased_description,
                            value: purchasedCredits.toString(),
                            icon: Icons.shopping_cart,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  children: [
                    _CreditItem(
                      label: l10n.api_usage_total_available,
                      description: l10n.api_usage_credits_combined_description,
                      value: totalCredits.toString(),
                      icon: Icons.check_circle,
                      isHighlighted: true,
                    ),
                    SizedBox(height: itemSpacing),
                    _CreditItem(
                      label: l10n.api_usage_subscription,
                      description: planTier == PlanTier.none
                          ? l10n.api_usage_subscribe_to_unlock
                          : l10n.api_usage_will_renew_monthly(
                              creditsOwnedPerMonth,
                            ),
                      value: subscriptionCredits.toString(),
                      icon: Icons.calendar_month,
                    ),
                    SizedBox(height: itemSpacing),
                    _CreditItem(
                      label: l10n.api_usage_purchased,
                      description: l10n.api_usage_purchased_description,
                      value: purchasedCredits.toString(),
                      icon: Icons.shopping_cart,
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: verticalSpacing),
          Row(
            children: [
              SizedBox(width: horizontalPadding),
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
          SizedBox(height: verticalSpacing),
        ],
      ),
    );
  }
}

class _CreditItem extends StatelessWidget {
  final String label;
  final String value;
  final String description;
  final IconData icon;
  final bool isHighlighted;

  const _CreditItem({
    required this.label,
    required this.value,
    required this.description,
    required this.icon,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );
    final borderRadius = context.responsiveValue(
      compact: 8.0,
      medium: 12.0,
      expanded: 12.0,
    );
    final iconSize = context.responsiveValue(
      compact: 16.0,
      medium: 18.0,
      expanded: 18.0,
    );

    final style = context.t.labelSmall?.copyWith(
      color: context.c.onSurfaceVariant.withAlpha(150),
    );

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: isHighlighted
            ? context.c.primaryContainer.withAlpha(100)
            : context.c.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(borderRadius),
        border: isHighlighted
            ? Border.all(color: context.c.primary.withAlpha(100), width: 1.5)
            : Border.all(color: context.c.outline.withAlpha(30), width: 1),
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
                size: iconSize,
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
          Expanded(child: Text(description, maxLines: 2, style: style)),
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
