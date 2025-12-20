import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pricing_page/pricing_page.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

class EmptyScrappableListageIndicatorPage extends StatelessWidget {
  const EmptyScrappableListageIndicatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Responsive sizing values
    final lottieSize = context.responsiveValue(
      compact: 280.0,
      medium: 340.0,
      expanded: 380.0,
    );
    final horizontalPadding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 20.0,
    );
    final textSpacing = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 20.0,
    );
    final buttonSpacing = context.responsiveValue(
      compact: 24.0,
      medium: 28.0,
      expanded: 32.0,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: LottieBuilder.network(
              'https://lottie.host/3c4defca-fca7-4045-a13e-2a92f5f397fe/5G9WkNELtD.lottie',
              decoder: customDecoder,
              height: lottieSize,
              width: lottieSize,
              fit: BoxFit.contain,
            ),
          ).animate().fadeIn(delay: 500.ms),
          SizedBox(height: textSpacing),
          Text(
            AppLocalizations.of(context)!.scrappables_empty_title,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: buttonSpacing),
          FilledButton.icon(
            onPressed: () {
              context.push('/scrappable-form');
            },
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.scrappables_create_first),
          ),
          SizedBox(height: buttonSpacing),
        ],
      ),
    );
  }
}
