import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/elements/scrappable_grid_listage.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrappable_card_indicator.dart';

/// Generic template for displaying paginated scrappables
/// Used by both Marketplace and User Scrappables pages
class ScrappablesListageTemplate extends StatelessWidget {
  const ScrappablesListageTemplate({
    super.key,
    required this.scrappables,
    required this.pagination,
    required this.accountId,
    required this.source,
    required this.paginationControls,
    this.usageCountProvider,
  });

  /// List of scrappables to display
  final List<Scrappable> scrappables;

  /// Pagination metadata
  final PaginationMetadata pagination;

  /// Current account ID (can be null)
  final int? accountId;

  /// Source context for analytics tracking
  final ScrappableCardSource source;

  /// Widget to display pagination controls at the bottom
  final Widget paginationControls;

  /// Optional provider for usage count (used in marketplace)
  /// Function that takes a scrappable and returns its usage count
  final int? Function(Scrappable)? usageCountProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ScrappableGridListage(
            itemCount: scrappables.length,
            itemBuilder: (context, index) {
              final scrappable = scrappables[index];
              final usageCount = usageCountProvider?.call(scrappable);

              return ScrappableCardIndicator(
                accountId: accountId,
                scrappable: scrappable,
                usageCount: usageCount,
                source: source,
              );
            },
          ),
        ),
        paginationControls,
      ],
    );
  }
}
