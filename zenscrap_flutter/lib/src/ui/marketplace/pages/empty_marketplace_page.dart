import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';

class EmptyMarketplacePage extends ConsumerWidget {
  final bool isSearchResult;
  final String searchQuery;

  const EmptyMarketplacePage({
    super.key,
    required this.isSearchResult,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: context.responsiveValue(
            compact: double.infinity,
            medium: 400.0,
            expanded: 400.0,
          ),
        ),
        padding: EdgeInsets.all(
          context.responsiveValue(
            compact: 24.0,
            medium: 32.0,
            expanded: 32.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(
                context.responsiveValue(
                  compact: 20.0,
                  medium: 24.0,
                  expanded: 24.0,
                ),
              ),
              decoration: BoxDecoration(
                color: context.c.surfaceContainerHighest.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearchResult
                    ? Icons.search_off_rounded
                    : Icons.shopping_bag_outlined,
                size: context.responsiveValue(
                  compact: 40.0,
                  medium: 48.0,
                  expanded: 48.0,
                ),
                color: context.c.onSurfaceVariant,
              ),
            ),
            SizedBox(
              height: context.responsiveValue(
                compact: 20.0,
                medium: 24.0,
                expanded: 24.0,
              ),
            ),
            Text(
              isSearchResult
                  ? AppLocalizations.of(context)!.marketplace_no_results_found
                  : AppLocalizations.of(context)!.marketplace_no_scrappables_available,
              style: context.t.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              isSearchResult
                  ? AppLocalizations.of(context)!.marketplace_no_scrappables_match(searchQuery)
                  : AppLocalizations.of(context)!.marketplace_empty_message,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSearchResult) ...[
              const SizedBox(height: 24),
              FilledButton.tonalIcon(
                onPressed: () {
                  ref.read(marketplaceProvider.notifier).search('');
                },
                icon: const Icon(Icons.clear_rounded),
                label: Text(AppLocalizations.of(context)!.marketplace_clear_search),
              ),
            ],
          ],
        ),
      ),
    );
  }
}