import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/widgets/ai_usage_card.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/widgets/load_more_button.dart';

/// Displays the paginated credit history list.
class AiCreditsHistorySection extends StatelessWidget {
  final List<AICreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final bool hasMoreHistory;
  final VoidCallback onLoadMoreHistory;

  const AiCreditsHistorySection({
    super.key,
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.hasMoreHistory,
    required this.onLoadMoreHistory,
  });

  @override
  Widget build(BuildContext context) {
    return AiUsageCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: AiUsageCardHeader(
              icon: Icons.history,
              title: AppLocalizations.of(context)!.ai_usage_credit_history,
            ),
          ),
          Expanded(
            child: _CreditHistoryList(
              creditHistory: creditHistory,
              isLoadingMore: isLoadingMoreHistory,
              hasMore: hasMoreHistory,
              onLoadMore: onLoadMoreHistory,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreditHistoryList extends StatelessWidget {
  final List<AICreditHistoryItem> creditHistory;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;

  const _CreditHistoryList({
    required this.creditHistory,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (creditHistory.isEmpty) {
      return _EmptyHistoryState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: creditHistory.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == creditHistory.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: LoadMoreButton(
              isLoading: isLoadingMore,
              onPressed: onLoadMore,
            ),
          );
        }

        final item = creditHistory[index];
        return _CreditHistoryItem(item: item);
      },
    );
  }
}

class _EmptyHistoryState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: context.c.onSurface.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.ai_usage_no_credit_history,
              style: context.t.bodyLarge?.copyWith(
                color: context.c.onSurface.withAlpha(150),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.ai_usage_credit_history_empty_description,
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
}

class _CreditHistoryItem extends StatelessWidget {
  final AICreditHistoryItem item;

  const _CreditHistoryItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final isSubscription = item.monthlySubscriptionAICreditDeposit != null;
    final dateFormatter = DateFormat('MMM d, y h:mm a');
    final dateStr = dateFormatter.format(item.date);

    IconData icon;
    String title;
    String subtitle;
    Color color;
    String? amount;

    if (isSubscription) {
      icon = Icons.calendar_month;
      final deposit = item.monthlySubscriptionAICreditDeposit!;
      final planName = deposit.planTier == PlanTier.none
          ? AppLocalizations.of(context)!.ai_usage_plan_name_free
          : deposit.planTier.name.toUpperCase();
      title = AppLocalizations.of(context)!.ai_usage_monthly_ai_credits;
      subtitle = AppLocalizations.of(context)!.ai_usage_plan_subtitle(planName);
      color = context.c.primary;
      amount = '+\$${deposit.creditsAmountInDollars.toStringAsFixed(2)}';
    } else {
      icon = Icons.help_outline;
      title = AppLocalizations.of(context)!.ai_usage_unknown_transaction;
      subtitle = dateStr;
      color = context.c.onSurface.withAlpha(150);
      amount = null;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.t.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$subtitle • $dateStr',
                  style: context.t.bodySmall?.copyWith(
                    color: context.c.onSurface.withAlpha(150),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (amount != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: context.c.primaryContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                amount,
                style: context.t.labelLarge?.copyWith(
                  color: context.c.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
