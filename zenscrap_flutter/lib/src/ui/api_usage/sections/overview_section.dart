import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class CreditsOverviewSection extends StatelessWidget {
  final int subscriptionCredits;
  final int purchasedCredits;

  const CreditsOverviewSection({
    super.key,
    required this.subscriptionCredits,
    required this.purchasedCredits,
  });

  @override
  Widget build(BuildContext context) {
    final totalCredits = subscriptionCredits + purchasedCredits;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.outline.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'API Credits Overview',
                style: context.t.titleLarge,
              ),
              Icon(
                Icons.generating_tokens,
                color: context.c.primary,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CreditItem(
                  label: 'Total Available',
                  value: totalCredits.toString(),
                  icon: Icons.check_circle,
                  isHighlighted: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CreditItem(
                  label: 'Subscription',
                  value: subscriptionCredits.toString(),
                  icon: Icons.calendar_month,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CreditItem(
                  label: 'Purchased',
                  value: purchasedCredits.toString(),
                  icon: Icons.shopping_cart,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CreditItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isHighlighted;

  const CreditItem({
    super.key,
    required this.label,
    required this.value,
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
