import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pricing_page/pricing_page.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';

class ZenScrapPricingPage extends ConsumerWidget {
  const ZenScrapPricingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 240, 255),
      body: PricingBackground(
        child: PricingPage(
          width: 832,
          childAspectRatio: 0.7,
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
                  await testSubscribePro(ref, context);
                  context.go('/endpoints');
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
                'Access to the best AI model (20 messages)',
              ],
              onTap: (bool isYearly) {},
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
                'Access to the best AI model (100 messages)',
                'Priority Support',
                'Hide endpoints from marketplace',
              ],
              onTap: (bool isYearly) {},
            ),
          ],
        ),
      ),
    );
  }

  Future<void> testSubscribePro(WidgetRef ref, BuildContext context) async {
    final userInfo = ref.read(sessionManagerProvider).signedInUser;
    final email = userInfo?.email;
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found'),
        ),
      );
      return;
    }
    await ref.read(clientProvider).publicTier.updatePlayerTier(
          email: email,
          tierManipulationKey: '0195744f-a23c-757e-9bf4-184f7ef3bb24',
          planTier: PlanTier.pro,
        );
  }
}
