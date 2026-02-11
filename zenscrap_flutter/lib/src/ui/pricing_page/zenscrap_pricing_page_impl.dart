import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/raw_pricing_component.dart';
import 'package:zenscrap_flutter/src/ui/pricing_page/pricing_background.dart';

class ZenScrapPricingPageImpl extends ConsumerWidget {
  /// When true, clicking a plan will redirect to auth page instead of Stripe.
  /// Used when embedding the pricing page in the landing page.
  final bool isInsideLandingPage;

  const ZenScrapPricingPageImpl({super.key, this.isInsideLandingPage = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 224, 240, 255),
            body: PricingBackground(
              child: RawPricingPageComponent(
                isInsideLandingPage: isInsideLandingPage,
              ),
            ),
          );
        },
      ),
    );
  }
}
