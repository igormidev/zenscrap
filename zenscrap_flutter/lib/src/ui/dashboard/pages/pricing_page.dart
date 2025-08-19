import 'package:flutter/material.dart';
import 'package:pricing_page/pricing_page.dart';

class ZenScrapPricingPage extends StatelessWidget {
  const ZenScrapPricingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              title: 'BASE',
              subTitle: 'SIDE-PROJECTS',
              monthlyPrice: 80,
              yearlyPrice: 850,
              advantagesListage: [
                '<b><u><tC>2<tC><u><b> projects',
                '<b><u><tC>4<tC><u><b> languages',
                '<b><u><tC>1<tC><u><b> account',
              ],
              onTap: (bool isYearly) {},
            ),
            PricesModel(
              title: 'PRO',
              subTitle: 'FOR STARTUP',
              emphasisText: 'MOST POPULAR',
              monthlyPrice: 99,
              yearlyPrice: 999,
              advantagesListage: [
                '<b><u><tC>10<tC><u><b> projects',
                '<b><u><tC>10<tC><u><b> languages',
                '<b><u><tC>5<tC><u><b> accounts',
              ],
              onTap: (bool isYearly) {},
            ),
            PricesModel(
              title: 'UNLIMITED',
              subTitle: 'ENTERPRISE',
              monthlyPrice: 250,
              yearlyPrice: 2500,
              advantagesListage: [
                '<b><u><tC>Unlimited<tC><u><b> projects',
                '<b><u><tC>Unlimited<tC><u><b> languages',
                '<b><u><tC>Unlimited<tC><u><b> accounts',
              ],
              onTap: (bool isYearly) {},
            ),
          ],
        ),
      ),
    );
  }
}
