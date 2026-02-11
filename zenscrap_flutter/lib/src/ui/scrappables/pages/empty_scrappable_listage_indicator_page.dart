import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_flutter/src/core/extensions/plan_tier_extension.dart';
import 'package:zenscrap_flutter/src/core/mixins/create_new_scrappable_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';

class EmptyScrappableListageIndicatorPage extends ConsumerStatefulWidget {
  const EmptyScrappableListageIndicatorPage({super.key});

  @override
  ConsumerState<EmptyScrappableListageIndicatorPage> createState() =>
      _EmptyScrappableListageIndicatorPageState();
}

class _EmptyScrappableListageIndicatorPageState
    extends ConsumerState<EmptyScrappableListageIndicatorPage>
    with CreateNewScrappableMixin {
  @override
  Widget build(BuildContext context) {
    // Get account info for plan tier
    final accountState = ref.watch(accountProvider);
    final planTier =
        accountState.mapOrNull(withData: (data) => data.accountInfo.planTier) ??
        PlanTier.none;

    // Get total user scrappables count from state
    final scrappablesState = ref.watch(userScrappablesProvider);
    final totalUserScrappables =
        scrappablesState.mapOrNull(
          withData: (data) => data.response.pagination.totalUserScrappables,
          loading: (data) => data.response?.pagination.totalUserScrappables,
          withError: (data) => data.response?.pagination.totalUserScrappables,
        ) ??
        0;

    final maxAllowed = planTier.maxScrappables;
    final isAtLimit = totalUserScrappables >= maxAllowed;

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
            onPressed: () => onTapCreateNewScrappable(
              context,
              isAtLimit: isAtLimit,
              totalUserScrappables: totalUserScrappables,
              maxAllowed: maxAllowed,
              planTier: planTier,
            ),
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.scrappables_create_first),
          ),
          SizedBox(height: buttonSpacing),
        ],
      ),
    );
  }
}
