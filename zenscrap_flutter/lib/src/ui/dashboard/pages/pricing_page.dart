import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pricing_page/pricing_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';

class ZenScrapPricingPage extends ConsumerWidget {
  const ZenScrapPricingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(analyticsServiceProvider);

    // Track page view when pricing page is displayed
    analytics.trackPricingPageView();

    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 224, 240, 255),
          body: PricingBackground(
            child: PricingPage(
              width: 865,
              childAspectRatio: 0.45,
              perMonthText: 'Per month',
              perYearText: 'Per year',
              subtitle:
                  "We have you covered, whether you're an unique person running\na side-project, a startup or even an enterprise company.",
              decorationMapper: (decoration) {
                return decoration.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                );
              },
              pricesList: [
                PricesModel(
                  title: 'BASIC',
                  subTitle: 'FOR SIDE-PROJECTS',
                  monthlyPrice: 100,
                  yearlyPrice: 1050,
                  advantagesListage: [
                    '<b><u><tC>250.000<tC><u><b> api credits',
                    '<b><u><tC>10<tC><u><b> concurrent requests',
                    '<b><u><tC>3<tC><u><b> active endpoints',
                  ],
                  onTap: (bool isYearly) async {
                    // Track plan click
                    await analytics.trackPricingPlanClick(
                      planTier: 'basic',
                      isYearly: isYearly,
                      price: isYearly ? 1050.0 : 100.0,
                    );

                    await ref.globalLoadingSetter(() async {
                      await _handleSubscription(ref, context, 'basic', isYearly,
                          isYearly ? 1050.0 : 100.0);
                    });
                  },
                ),
                PricesModel(
                  title: 'PRO',
                  subTitle: 'FOR STARTUP',
                  emphasisText: 'MOST POPULAR',
                  monthlyPrice: 199,
                  yearlyPrice: 1999,
                  advantagesListage: [
                    '<b><u><tC>1.000.000<tC><u><b> api credits',
                    '<b><u><tC>30<tC><u><b> concurrent requests',
                    '<b><u><tC>10<tC><u><b> active endpoints',
                    'Access a best AI model',
                  ],
                  onTap: (bool isYearly) async {
                    // Track plan click
                    await analytics.trackPricingPlanClick(
                      planTier: 'pro',
                      isYearly: isYearly,
                      price: isYearly ? 1999.0 : 199.0,
                    );

                    await ref.globalLoadingSetter(() async {
                      await _handleSubscription(ref, context, 'pro', isYearly,
                          isYearly ? 1999.0 : 199.0);
                    });
                  },
                ),
                PricesModel(
                  title: 'ULTRA',
                  subTitle: 'ENTERPRISE USAGE',
                  monthlyPrice: 500,
                  yearlyPrice: 5500,
                  advantagesListage: [
                    '<b><u><tC>4.000.000<tC><u><b> api credits',
                    '<b><u><tC>100<tC><u><b> concurrent requests',
                    '<b><u><tC>100<tC><u><b> active endpoints',
                    'Access a best AI model',
                    'Priority Support',
                    'Hide your endpoints from marketplace',
                    'Copy endpoints from marketplace',
                    'Ability to purchase one time add-on api credits',
                  ],
                  onTap: (bool isYearly) async {
                    // Track plan click
                    await analytics.trackPricingPlanClick(
                      planTier: 'ultra',
                      isYearly: isYearly,
                      price: isYearly ? 5500.0 : 500.0,
                    );

                    await ref.globalLoadingSetter(() async {
                      await _handleSubscription(ref, context, 'ultra', isYearly,
                          isYearly ? 5500.0 : 500.0);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _handleSubscription(
    WidgetRef ref,
    BuildContext context,
    String planTier,
    bool isYearly,
    double price,
  ) async {
    final analytics = ref.read(analyticsServiceProvider);
    try {
      // Check if user is logged in
      final isSignedIn = ref.read(sessionManagerProvider).isSignedIn;
      if (!isSignedIn) {
        // Track unauthenticated attempt
        await analytics.trackPricingUnauthenticatedAttempt(
          planTier: planTier,
          isYearly: isYearly,
        );
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please sign in to subscribe'),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        // ignore: use_build_context_synchronously
        context.go('/auth');
        return;
      }

      // Create checkout session
      final checkoutUrl = await ref
          .read(clientProvider)
          .privateSubscription
          .createCheckoutSession(
            planTier: planTier,
            isYearly: isYearly,
          );

      // Track successful checkout session creation
      if (checkoutUrl.isNotEmpty) {
        await analytics.trackPricingCheckoutSessionCreated(
          planTier: planTier,
          isYearly: isYearly,
          price: price,
        );
      }

      // Launch Stripe checkout
      if (checkoutUrl.isNotEmpty) {
        final uri = Uri.parse(checkoutUrl);
        if (await canLaunchUrl(uri)) {
          // Track checkout opened
          await analytics.trackPricingCheckoutOpened(
            planTier: planTier,
            isYearly: isYearly,
          );

          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          // Track checkout failure - can't launch URL
          await analytics.trackPricingCheckoutFailure(
            planTier: planTier,
            isYearly: isYearly,
            errorMessage: 'Could not open checkout page',
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open checkout page'),
              ),
            );
          }
        }
      } else {
        // Track checkout failure - empty URL
        await analytics.trackPricingCheckoutFailure(
          planTier: planTier,
          isYearly: isYearly,
          errorMessage: 'Empty checkout URL',
        );
      }
    } catch (e) {
      // Track checkout failure - exception
      await analytics.trackPricingCheckoutFailure(
        planTier: planTier,
        isYearly: isYearly,
        errorMessage: e.toString(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
          ),
        );
      }
    }
  }
}
