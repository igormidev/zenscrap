import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pricing_page/pricing_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';

class ZenScrapPricingPage extends ConsumerWidget {
  const ZenScrapPricingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 224, 240, 255),
        body: PricingBackground(
          child: PricingPage(
            width: 832,
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
                  '<b><u><tC>50.000<tC><u><b> api calls',
                  '<b><u><tC>10<tC><u><b> concurrent requests',
                  '<b><u><tC>3<tC><u><b> active endpoints',
                ],
                onTap: (bool isYearly) async {
                  await ref.globalLoadingSetter(() async {
                    await _handleSubscription(ref, context, 'basic', isYearly);
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
                  '<b><u><tC>200.000<tC><u><b> api calls',
                  '<b><u><tC>30<tC><u><b> concurrent requests',
                  '<b><u><tC>10<tC><u><b> active endpoints',
                  'Access a best AI model',
                ],
                onTap: (bool isYearly) async {
                  await ref.globalLoadingSetter(() async {
                    await _handleSubscription(ref, context, 'pro', isYearly);
                  });
                },
              ),
              PricesModel(
                title: 'ULTRA',
                subTitle: 'ENTERPRISE USAGE',
                monthlyPrice: 500,
                yearlyPrice: 5500,
                advantagesListage: [
                  '<b><u><tC>1.000.000<tC><u><b> api calls',
                  '<b><u><tC>100<tC><u><b> concurrent requests',
                  '<b><u><tC>100<tC><u><b> active endpoints',
                  'Access a best AI model',
                  'Priority Support',
                  'Hide your endpoints from marketplace',
                  'Copy endpoints from marketplace',
                ],
                onTap: (bool isYearly) async {
                  await ref.globalLoadingSetter(() async {
                    await _handleSubscription(ref, context, 'ultra', isYearly);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubscription(
    WidgetRef ref,
    BuildContext context,
    String planTier,
    bool isYearly,
  ) async {
    try {
      // Check if user is logged in
      final isSignedIn = ref.read(sessionManagerProvider).isSignedIn;
      if (!isSignedIn) {
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

      // Launch Stripe checkout
      if (checkoutUrl.isNotEmpty) {
        final uri = Uri.parse(checkoutUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not open checkout page'),
              ),
            );
          }
        }
      }
    } catch (e) {
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
