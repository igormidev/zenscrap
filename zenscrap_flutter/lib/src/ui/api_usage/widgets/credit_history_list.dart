import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class CreditHistoryList extends StatelessWidget {
  final List<CreditHistoryItem> creditHistory;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const CreditHistoryList({
    super.key,
    required this.creditHistory,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (creditHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: context.c.onSurface.withAlpha(100),
              ),
              const SizedBox(height: 16),
              Text(
                'No credit history yet',
                style: context.t.bodyLarge?.copyWith(
                  color: context.c.onSurface.withAlpha(150),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your credit transactions will appear here',
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

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: creditHistory.length,
            separatorBuilder: (context, index) => Divider(
              color: context.c.outline.withAlpha(50),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final item = creditHistory[index];
              return _buildHistoryItem(context, item);
            },
          ),
        ),
        if (creditHistory.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: isLoadingMore ? null : onLoadMore,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
                        Text('Load More'),
                      ],
                    ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, CreditHistoryItem item) {
    final isSubscription = item.monthlySubscriptionCreditDeposit != null;
    final isPurchase = item.creaditPackagePurchase != null;

    IconData icon;
    String title;
    String subtitle;
    Color color;
    String? amount;

    if (isSubscription) {
      icon = Icons.calendar_month;
      title = 'Monthly Subscription';
      subtitle = 'Subscription credits added';
      color = context.c.primary;
      amount = '+${item.monthlySubscriptionCreditDeposit!.value.toInt()}';
    } else if (isPurchase) {
      icon = Icons.shopping_cart;
      title = 'Credit Purchase';
      subtitle =
          item.creaditPackagePurchase!.stripePurchaseId ?? 'Manual purchase';
      color = context.c.secondary;
      amount = '+${item.creaditPackagePurchase!.value.toInt()}';
    } else {
      icon = Icons.help_outline;
      title = 'Unknown Transaction';
      subtitle = 'Transaction details unavailable';
      color = context.c.onSurface.withAlpha(150);
      amount = null;
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
