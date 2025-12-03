import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/credit_history_list.dart';

class HistorySection extends StatelessWidget {
  final List<CreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final bool hasMoreHistory;
  final VoidCallback onLoadMoreHistory;

  const HistorySection({
    super.key,
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.hasMoreHistory,
    required this.onLoadMoreHistory,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Credit History',
            style: context.t.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CreditHistoryList(
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
