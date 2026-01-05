import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';

class CreditHistoryList extends ConsumerWidget {
  final List<ApiCreditHistoryItem> creditHistory;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;

  const CreditHistoryList({
    super.key,
    required this.creditHistory,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final emptyStatePadding = context.responsiveValue(
      compact: 24.0,
      medium: 32.0,
      expanded: 32.0,
    );
    final spacing = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );
    final borderRadius = context.responsiveValue(
      compact: 6.0,
      medium: 8.0,
      expanded: 8.0,
    );

    if (creditHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(emptyStatePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: context.c.onSurface.withAlpha(100),
              ),
              SizedBox(height: spacing),
              Text(
                l10n.api_usage_no_credit_history,
                style: context.t.bodyLarge?.copyWith(
                  color: context.c.onSurface.withAlpha(150),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.api_usage_credit_transactions_appear_here,
                style: context.t.bodySmall?.copyWith(
                  color: context.c.onSurface.withAlpha(100),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isUnbounded = constraints.maxHeight == double.infinity;

        final listView = ListView.separated(
          shrinkWrap: isUnbounded,
          physics: isUnbounded ? const NeverScrollableScrollPhysics() : null,
          itemCount: creditHistory.length,
          separatorBuilder: (context, index) => Divider(
            color: context.c.outline.withAlpha(50),
            height: 1,
          ),
          itemBuilder: (context, index) {
            final item = creditHistory[index];
            return _CreditHistoryItem(item: item);
          },
        );

        final loadMoreButton = hasMore
            ? SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: isLoadingMore
                      ? null
                      : () {
                          // Track load more history click
                          ref.read(analyticsServiceProvider).trackApiUsageLoadMoreHistoryClick(
                            currentCount: creditHistory.length,
                            hasMore: hasMore,
                          );
                          onLoadMore();
                        },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  child: isLoadingMore
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.c.primary,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.expand_more,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(l10n.api_usage_load_more),
                          ],
                        ),
                ),
              )
            : null;

        if (isUnbounded) {
          // In scrollable context (tablet mode) - shrink-wrap, no internal scrolling
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              listView,
              if (loadMoreButton != null) ...[
                SizedBox(height: spacing),
                loadMoreButton,
              ],
            ],
          );
        } else {
          // In bounded context (desktop mode) - expand to fill, scroll internally
          return Column(
            children: [
              Expanded(child: listView),
              if (loadMoreButton != null) ...[
                SizedBox(height: spacing),
                loadMoreButton,
              ],
            ],
          );
        }
      },
    );
  }
}

class _CreditHistoryItem extends StatelessWidget {
  final ApiCreditHistoryItem item;

  const _CreditHistoryItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Format date
    final dateFormatter = DateFormat('MMM d, y h:mm a');
    final dateStr = dateFormatter.format(item.date);

    IconData icon;
    String title;
    String subtitle;
    Color color;
    String? amount;

    switch (item.transactionType) {
      case ApiCreditTransactionType.initialAccountCredit:
        icon = Icons.card_giftcard;
        title = l10n.api_usage_initial_credit;
        subtitle = l10n.api_usage_welcome_bonus;
        color = context.c.tertiary;
        final deposit = item.monthlySubscriptionApiCreditDeposit;
        amount = deposit != null ? '+${deposit.creditsAmount}' : null;

      case ApiCreditTransactionType.monthlySubscriptionDeposit:
        icon = Icons.calendar_month;
        final deposit = item.monthlySubscriptionApiCreditDeposit;
        if (deposit != null) {
          final planName = deposit.planTier == PlanTier.none
              ? l10n.api_usage_plan_free
              : deposit.planTier.name.toUpperCase();
          title = l10n.api_usage_monthly_subscription;
          subtitle = l10n.api_usage_plan_date_subtitle(planName, dateStr);
          amount = '+${deposit.creditsAmount}';
        } else {
          title = l10n.api_usage_monthly_subscription;
          subtitle = dateStr;
          amount = null;
        }
        color = context.c.primary;

      case ApiCreditTransactionType.creditPackagePurchase:
        icon = Icons.shopping_cart;
        title = l10n.api_usage_credit_purchase;
        subtitle = dateStr;
        color = context.c.secondary;
        final purchase = item.apiCreditPackagePurchase;
        amount = purchase != null ? '+${purchase.value.toInt()}' : null;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: context.t.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.t.bodySmall?.copyWith(
          color: context.c.onSurface.withAlpha(150),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: amount != null
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: context.c.primaryContainer.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                amount,
                style: context.t.labelLarge?.copyWith(
                  color: context.c.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
