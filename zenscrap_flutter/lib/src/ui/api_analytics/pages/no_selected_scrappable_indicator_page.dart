import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

class NoSelectedScrappableIndicatorPage extends StatelessWidget {
  const NoSelectedScrappableIndicatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
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
            Icon(
              Icons.analytics_outlined,
              size: context.responsiveValue(
                compact: 48.0,
                medium: 64.0,
                expanded: 64.0,
              ),
              color: context.c.onSurface.withAlpha(100),
            ),
            SizedBox(
              height: context.responsiveValue(
                compact: 12.0,
                medium: 16.0,
                expanded: 16.0,
              ),
            ),
            Text(
              l10n.api_analytics_no_scrappable_selected,
              style: context.t.headlineSmall?.copyWith(
                color: context.c.onSurface.withAlpha(200),
              ),
              textAlign: TextAlign.center,
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
      ),
    );
  }
}