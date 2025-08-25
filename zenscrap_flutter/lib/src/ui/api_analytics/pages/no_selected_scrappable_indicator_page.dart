import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:pricing_page/pricing_page.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class NoSelectedScrappableIndicatorPage extends StatelessWidget {
  const NoSelectedScrappableIndicatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LottieBuilder.network(
              'https://lottie.host/3c4defca-fca7-4045-a13e-2a92f5f397fe/5G9WkNELtD.lottie',
              decoder: customDecoder,
              height: 380,
              width: 380,
              fit: BoxFit.contain,
            ),
          ).animate().fadeIn(delay: 500.ms),
          SizedBox(height: 20),
          Text(
            'Select a scrappable',
            textAlign: TextAlign.center,
            style: context.t.headlineSmall,
          ),
          Text(
            'You will be able to see all\nrequests made by that scrappable',
            textAlign: TextAlign.center,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
