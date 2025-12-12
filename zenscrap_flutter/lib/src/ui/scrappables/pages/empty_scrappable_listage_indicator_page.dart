import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pricing_page/pricing_page.dart';

class EmptyScrappableListageIndicatorPage extends StatelessWidget {
  const EmptyScrappableListageIndicatorPage({super.key});

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
            AppLocalizations.of(context)!.scrappables_empty_title,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              context.push('/scrappable-form');
            },
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.scrappables_create_first),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
