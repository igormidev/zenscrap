import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pricing_page/pricing_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';

class ZenScrapPricingPage extends ConsumerWidget {
  /// When true, clicking a plan will redirect to auth page instead of Stripe.
  /// Used when embedding the pricing page in the landing page.
  final bool isInsideLandingPage;

  const ZenScrapPricingPage({super.key, this.isInsideLandingPage = false});

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

class RawPricingPageComponent extends ConsumerWidget {
  final bool isInsideLandingPage;
  const RawPricingPageComponent({super.key, required this.isInsideLandingPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.read(analyticsServiceProvider);

    // Track page view when pricing page is displayed
    analytics.trackPricingPageView();
    final l10n = AppLocalizations.of(context)!;
    return PricingPage(
      width: 865,
      childAspectRatio: 0.45,
      perMonthText: l10n.pricing_per_month,
      perYearText: l10n.pricing_per_year,
      subtitle: l10n.pricing_subtitle,
      decorationMapper: (decoration) {
        return decoration.copyWith(
          color: Theme.of(context).colorScheme.onSecondary,
        );
      },
      pricesList: [
        PricesModel(
          title: l10n.pricing_plan_basic,
          subTitle: l10n.pricing_plan_basic_subtitle,
          monthlyPrice: 100,
          yearlyPrice: 1050,
          advantagesListage: [
            '<b><u><tC>250.000<tC><u><b> ${l10n.pricing_feature_api_credits('')}'.replaceFirst(' ', ''),
            '<b><u><tC>10<tC><u><b> ${l10n.pricing_feature_concurrent_requests('')}'.replaceFirst(' ', ''),
            '<b><u><tC>3<tC><u><b> ${l10n.pricing_feature_active_endpoints('')}'.replaceFirst(' ', ''),
          ],
          onTap: (bool isYearly) async {
            // Track plan click
            await analytics.trackPricingPlanClick(
              planTier: 'basic',
              isYearly: isYearly,
              price: isYearly ? 1050.0 : 100.0,
            );

            if (isInsideLandingPage) {
              context.push('/auth');
              return;
            }

            await ref.globalLoadingSetter(() async {
              await _handleSubscription(
                ref,
                context,
                l10n,
                'basic',
                isYearly,
                isYearly ? 1050.0 : 100.0,
              );
            });
          },
        ),
        PricesModel(
          title: l10n.pricing_plan_pro,
          subTitle: l10n.pricing_plan_pro_subtitle,
          emphasisText: l10n.pricing_plan_pro_emphasis,
          monthlyPrice: 199,
          yearlyPrice: 1999,
          advantagesListage: [
            '<b><u><tC>1.000.000<tC><u><b> ${l10n.pricing_feature_api_credits('')}'.replaceFirst(' ', ''),
            '<b><u><tC>30<tC><u><b> ${l10n.pricing_feature_concurrent_requests('')}'.replaceFirst(' ', ''),
            '<b><u><tC>10<tC><u><b> ${l10n.pricing_feature_active_endpoints('')}'.replaceFirst(' ', ''),
            l10n.pricing_feature_best_ai_model,
          ],
          onTap: (bool isYearly) async {
            // Track plan click
            await analytics.trackPricingPlanClick(
              planTier: 'pro',
              isYearly: isYearly,
              price: isYearly ? 1999.0 : 199.0,
            );

            if (isInsideLandingPage) {
              context.push('/auth');
              return;
            }

            await ref.globalLoadingSetter(() async {
              await _handleSubscription(
                ref,
                context,
                l10n,
                'pro',
                isYearly,
                isYearly ? 1999.0 : 199.0,
              );
            });
          },
        ),
        PricesModel(
          title: l10n.pricing_plan_ultra,
          subTitle: l10n.pricing_plan_ultra_subtitle,
          monthlyPrice: 500,
          yearlyPrice: 5500,
          advantagesListage: [
            '<b><u><tC>4.000.000<tC><u><b> ${l10n.pricing_feature_api_credits('')}'.replaceFirst(' ', ''),
            '<b><u><tC>100<tC><u><b> ${l10n.pricing_feature_concurrent_requests('')}'.replaceFirst(' ', ''),
            '<b><u><tC>100<tC><u><b> ${l10n.pricing_feature_active_endpoints('')}'.replaceFirst(' ', ''),
            l10n.pricing_feature_best_ai_model,
            l10n.pricing_feature_priority_support,
            l10n.pricing_feature_hide_endpoints,
            l10n.pricing_feature_copy_endpoints,
            l10n.pricing_feature_addon_credits,
          ],
          onTap: (bool isYearly) async {
            // Track plan click
            await analytics.trackPricingPlanClick(
              planTier: 'ultra',
              isYearly: isYearly,
              price: isYearly ? 5500.0 : 500.0,
            );

            if (isInsideLandingPage) {
              context.push('/auth');
              return;
            }

            await ref.globalLoadingSetter(() async {
              await _handleSubscription(
                ref,
                context,
                l10n,
                'ultra',
                isYearly,
                isYearly ? 5500.0 : 500.0,
              );
            });
          },
        ),
      ],
    );
  }

  Future<void> _handleSubscription(
    WidgetRef ref,
    BuildContext context,
    AppLocalizations l10n,
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
          SnackBar(content: Text(l10n.pricing_sign_in_required)),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        // ignore: use_build_context_synchronously
        context.go('/auth');
        return;
      }

      // Create checkout session
      final language = ref.read(currentLanguageProvider);
      final checkoutUrl = await ref
          .read(clientProvider)
          .privateSubscription
          .createCheckoutSession(planTier: planTier, isYearly: isYearly, language: language);

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

          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Track checkout failure - can't launch URL
          await analytics.trackPricingCheckoutFailure(
            planTier: planTier,
            isYearly: isYearly,
            errorMessage: 'Could not open checkout page',
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.pricing_checkout_error)),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pricing_error_message(e.toString()))));
      }
    }
  }
}
