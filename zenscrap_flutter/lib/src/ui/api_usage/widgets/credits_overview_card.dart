import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';

class CreditsOverviewCard extends ConsumerWidget {
  final int subscriptionCredits;
  final int purchasedCredits;
  final String accountId;

  const CreditsOverviewCard({
    super.key,
    required this.subscriptionCredits,
    required this.purchasedCredits,
    required this.accountId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final totalCredits = subscriptionCredits + purchasedCredits;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.c.primary,
            context.c.primary.withAlpha(180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.c.primary.withAlpha(50),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.api_usage_credits_overview,
                style: context.t.headlineSmall?.copyWith(
                  color: context.c.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.account_balance_wallet,
                color: context.c.onPrimary,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildCreditItem(
                  context,
                  l10n.api_usage_total_available,
                  totalCredits.toString(),
                  Icons.check_circle,
                  isHighlighted: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCreditItem(
                  context,
                  l10n.api_usage_subscription,
                  subscriptionCredits.toString(),
                  Icons.calendar_month,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCreditItem(
                  context,
                  l10n.api_usage_purchased,
                  purchasedCredits.toString(),
                  Icons.shopping_cart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.c.onPrimary.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.fingerprint,
                  color: context.c.onPrimary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.api_usage_account_id,
                        style: context.t.labelSmall?.copyWith(
                          color: context.c.onPrimary.withAlpha(200),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        accountId,
                        style: context.t.bodyMedium?.copyWith(
                          color: context.c.onPrimary,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    color: context.c.onPrimary,
                    size: 20,
                  ),
                  onPressed: () {
                    // Track copy account ID
                    ref.read(analyticsServiceProvider).trackApiUsageCopyAccountId(
                      accountId: accountId,
                    );

                    Clipboard.setData(ClipboardData(text: accountId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.api_usage_account_id_copied),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  tooltip: l10n.api_usage_copy_account_id,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isHighlighted = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted
            ? context.c.onPrimary.withAlpha(40)
            : context.c.onPrimary.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: isHighlighted
            ? Border.all(
                color: context.c.onPrimary.withAlpha(100),
                width: 2,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: context.c.onPrimary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: context.t.labelSmall?.copyWith(
                  color: context.c.onPrimary.withAlpha(200),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: context.t.headlineMedium?.copyWith(
              color: context.c.onPrimary,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
