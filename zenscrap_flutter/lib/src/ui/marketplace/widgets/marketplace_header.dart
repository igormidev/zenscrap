import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_search_bar.dart';

class MarketplaceHeader extends ConsumerWidget {
  const MarketplaceHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Marketplace',
              style: context.t.displaySmall,
            ),
            const SizedBox(width: 16),
            Container(
              margin: EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: context.c.tertiary.withAlpha(26),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Public Scrappables',
                style: context.t.labelLarge?.copyWith(
                  color: context.c.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Refresh page',
              onPressed: () {
                // Track refresh click
                ref.read(analyticsServiceProvider).trackMarketplaceRefreshClick();

                ref.read(marketplaceProvider.notifier).refresh();
              },
              icon: Icon(
                Icons.refresh_rounded,
                color: context.c.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const SizedBox(
          width: double.infinity,
          child: MarketplaceSearchBar(),
        ),
      ],
    );
  }
}
