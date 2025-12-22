import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/credit_history_list.dart';

class HistorySection extends StatelessWidget {
  final List<ApiCreditHistoryItem> creditHistory;
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
    final padding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 20.0,
    );
    final verticalSpacing = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );
    final borderRadius = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: context.c.outline.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.api_usage_credit_history,
            style: context.t.titleLarge,
          ),
          SizedBox(height: verticalSpacing),
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
