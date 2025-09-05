import 'package:dart_debouncer/dart_debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/elements/zen_tab.dart';
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
    // [ --------- ERROR HANDLING --------- ]
    // [ --------- ERROR HANDLING --------- ]

    final onboardingFlowState = ref.watch(onboardingFlowStateProvider);
    final ZenScrapException? error = ref.watch(
      dashboardErrorProvider.select((value) => value),
    );
    final isLoading = ref.watch(
      dashboardLoadingProvider.select((value) => value),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompactSize = constraints.maxWidth < 1000;

        Widget content = Stack(
          children: [
            if (error == null)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isLoading ? 0 : 1,
                child: Center(
                  child: onboardingFlowState.maybeWhen<Widget>(
                    none: () => const SizedBox.shrink(),
                    orElse: () => widget.child,
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
            if (error != null) ZenErrorTab(error),
          ],
        );

        if (!isCompactSize) {
          content = Row(
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
              Expanded(child: content),
            ],
          );
        }

        return Scaffold(
          drawer: isCompactSize
              ? DashboardDrawer(
                  widget: widget,
                  navigationType: navigationType,
                  changeDrawerStyle: changeDrawerStyle,
                )
              : null,
          appBar: isCompactSize ? const CompactDashboardAppBar() : null,
          body: content,
          // bottomNavigationBar: isCompactSize
          //     ? BottomNavigationBar(
          //         onTap: changeTab,
          //         backgroundColor: const Color(0xffe0b9f6),
          //         currentIndex: currentIndex,
          //         items: widget.items.map((item) {
          //           return BottomNavigationBarItem(
          //             icon: Icon(item.inactiveIcon),
          //             activeIcon: Icon(item.activeIcon),
          //             label: item.label,
          //             tooltip: item.tooltip,
          //           );
          //         }).toList(),
          //       )
          //     : null,
        );
      },
    );
  }
}

enum DashboardNavigationType {
  userEndpoints(
    label: 'Your endpoints',
    activeIcon: Icons.api,
    inactiveIcon: Icons.api_outlined,
    routeOnClick: '/endpoints',
  ),
  marketPlace(
    label: 'Marketplace',
    activeIcon: Icons.hub,
    inactiveIcon: Icons.hub_outlined,
    routeOnClick: '/marketplace',
  ),
  usage(
    label: 'Api usage',
    activeIcon: Icons.language,
    inactiveIcon: Icons.language,
    routeOnClick: '/api-usage',
  ),
  analytics(
    label: 'Api analytics',
    activeIcon: Icons.analytics,
    inactiveIcon: Icons.analytics_outlined,
    routeOnClick: '/api-analytics',
  ),
  account(
    label: 'Account',
    activeIcon: Icons.person,
    inactiveIcon: Icons.person_outline,
    routeOnClick: '/account',
  ),
  logOut(
    label: 'Log out',
    activeIcon: Icons.logout,
    inactiveIcon: Icons.logout,
    routeOnClick: null,
  ),
  pricingPage(
    label: 'Subscription',
    activeIcon: Icons.workspace_premium,
    inactiveIcon: Icons.workspace_premium_outlined,
    routeOnClick: '/subscription',
  );

  final String label;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String? routeOnClick;

  const DashboardNavigationType({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.routeOnClick,
  });
}

enum NavigationType { rail, drawer }
