import 'package:dart_debouncer/dart_debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/elements/zen_tab.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/shared_preferences_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_usage_provider.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_error_provider.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_index_provider.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/dashboard/onboarding_flow_provider.dart';
import 'package:zenscrap_flutter/src/states/dashboard/onboarding_flow_state.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/fullscreen_loading_page.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/compact_dashboard_appbar.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/navigation/dashboard_drawer.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/navigation/dashboard_rail.dart';

class DashboardView extends ConsumerStatefulWidget {
  final Widget child;

  const DashboardView({super.key, required this.child});

  @override
  ConsumerState<DashboardView> createState() => DashboardTemplateState();
}

class DashboardTemplateState extends ConsumerState<DashboardView> {
  NavigationType navigationType = NavigationType.drawer;
  final Debouncer navToggleDebouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    _setInitialDrawerStyle();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(accountProvider.notifier).getAccountInfo();
      await ref.read(apiUsageProvider.notifier).loadApiUsage();
    });
  }

  void _setInitialDrawerStyle() {
    final drawerIndex =
        ref.read(sharedPreferencesProvider).getInt('drawerIndex');
    if (drawerIndex != null) {
      navigationType = NavigationType.values[drawerIndex];
    }
  }

  void changeDrawerStyle(NavigationType navigationType) {
    navToggleDebouncer.resetDebounce(() {
      ref
          .read(sharedPreferencesProvider)
          .setInt('drawerIndex', navigationType.index);
    });
    setState(() {
      this.navigationType = navigationType;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      accountProvider.select((value) => value.maybeWhen(
          orElse: () => null, withData: (accountInfo) => accountInfo.planTier)),
      (previous, next) {
        if (next != null) {
          if (next == PlanTier.none) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              changeTab(DashboardNavigationType.pricingPage, context, ref);
            });
          }
        }
      },
    );

    final onboardingFlowState = ref.watch(onboardingFlowStateProvider);
    final ZenScrapException? error = ref.watch(
      dashboardErrorProvider.select((value) => value),
    );
    final isLoading = ref.watch(
      dashboardLoadingProvider.select((value) => value),
    );

    // Main content stack with loading and error states
    final contentStack = _DashboardContentStack(
      error: error,
      isLoading: isLoading,
      onboardingFlowState: onboardingFlowState,
      child: widget.child,
    );

    return ResponsiveBuilder(
      // Compact (< 600dp): Drawer with hamburger menu
      compact: (context, constraints) => Scaffold(
        drawer: DashboardDrawer(
          widget: widget,
          navigationType: NavigationType.drawer,
          changeDrawerStyle: changeDrawerStyle,
          isCompactMode: true,
        ),
        appBar: const CompactDashboardAppBar(),
        body: contentStack,
      ),
      // Medium (600-839dp): Navigation Rail only
      medium: (context, constraints) => Scaffold(
        body: Row(
          children: [
            DashboardRail(
              widget: widget,
              navigationType: NavigationType.rail,
              changeDrawerStyle: changeDrawerStyle,
              showExpandButton: false,
            ),
            Expanded(child: contentStack),
          ],
        ),
      ),
      // Expanded (>= 840dp): Toggle between Rail and Drawer
      expanded: (context, constraints) => Scaffold(
        body: Row(
          children: [
            switch (navigationType) {
              NavigationType.rail => DashboardRail(
                  widget: widget,
                  navigationType: navigationType,
                  changeDrawerStyle: changeDrawerStyle,
                ),
              NavigationType.drawer => DashboardDrawer(
                  widget: widget,
                  navigationType: navigationType,
                  changeDrawerStyle: changeDrawerStyle,
                ),
            },
            Expanded(child: contentStack),
          ],
        ),
      ),
    );
  }
}

/// Private widget for the dashboard content stack with loading and error states.
/// Extracted to avoid code duplication across responsive layouts.
class _DashboardContentStack extends StatelessWidget {
  final ZenScrapException? error;
  final bool isLoading;
  final OnboardingFlowState onboardingFlowState;
  final Widget child;

  const _DashboardContentStack({
    required this.error,
    required this.isLoading,
    required this.onboardingFlowState,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (error == null)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isLoading ? 0 : 1,
            child: Center(
              child: onboardingFlowState.maybeWhen<Widget>(
                none: () => const SizedBox.shrink(),
                orElse: () => child,
              ),
            ),
          ),
        if (error == null)
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isLoading ? 1 : 0,
            child: isLoading
                ? const FullpageLoadingPage()
                : const SizedBox.shrink(),
          ),
        if (error != null) ZenErrorTab(error!),
      ],
    );
  }
}

enum DashboardNavigationType {
  userEndpoints(
    activeIcon: Icons.api,
    inactiveIcon: Icons.api_outlined,
    routeOnClick: '/endpoints',
  ),
  marketPlace(
    activeIcon: Icons.hub,
    inactiveIcon: Icons.hub_outlined,
    routeOnClick: '/marketplace',
  ),
  usage(
    activeIcon: Icons.key,
    inactiveIcon: Icons.key_outlined,
    routeOnClick: '/credits-keys',
  ),
  analytics(
    activeIcon: Icons.analytics,
    inactiveIcon: Icons.analytics_outlined,
    routeOnClick: '/api-analytics',
  ),
  aiUsage(
    activeIcon: Icons.smart_toy,
    inactiveIcon: Icons.smart_toy_outlined,
    routeOnClick: '/ai-usage',
  ),
  account(
    activeIcon: Icons.person,
    inactiveIcon: Icons.person_outline,
    routeOnClick: '/account',
  ),
  logOut(
    activeIcon: Icons.logout,
    inactiveIcon: Icons.logout,
    routeOnClick: null,
  ),
  pricingPage(
    activeIcon: Icons.workspace_premium,
    inactiveIcon: Icons.workspace_premium_outlined,
    routeOnClick: '/subscription',
  );

  final IconData activeIcon;
  final IconData inactiveIcon;
  final String? routeOnClick;

  const DashboardNavigationType({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.routeOnClick,
  });

  String getLocalizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      DashboardNavigationType.userEndpoints => l10n.dashboard_nav_your_endpoints,
      DashboardNavigationType.marketPlace => l10n.dashboard_nav_marketplace,
      DashboardNavigationType.usage => l10n.dashboard_nav_credits_keys,
      DashboardNavigationType.analytics => l10n.dashboard_nav_api_analytics,
      DashboardNavigationType.aiUsage => l10n.dashboard_nav_ai_usage,
      DashboardNavigationType.account => l10n.dashboard_nav_account,
      DashboardNavigationType.logOut => l10n.dashboard_nav_log_out,
      DashboardNavigationType.pricingPage => l10n.dashboard_nav_subscription,
    };
  }
}

enum NavigationType { rail, drawer }
