import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class NoSelectedScrappableIndicatorPage extends StatelessWidget {
  const NoSelectedScrappableIndicatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: context.c.onSurface.withAlpha(100),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.api_analytics_no_scrappable_selected,
            style: context.t.headlineSmall?.copyWith(
              color: context.c.onSurface.withAlpha(200),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.api_analytics_select_scrappable_hint,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}