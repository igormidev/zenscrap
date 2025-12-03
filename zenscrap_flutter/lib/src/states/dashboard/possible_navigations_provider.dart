import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/dashboard/onboarding_flow_provider.dart';
import 'package:zenscrap_flutter/src/states/dashboard/onboarding_flow_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

final possibleNavigationsProvider =
    Provider<List<DashboardNavigationType>>((ref) {
  final List<DashboardNavigationType> defaultOptions = [
    DashboardNavigationType.userEndpoints,
    DashboardNavigationType.marketPlace,
    DashboardNavigationType.usage,
    DashboardNavigationType.analytics,
    DashboardNavigationType.account,
    DashboardNavigationType.logOut,
  ];
  return ref.watch(onboardingFlowStateProvider).when(
        pendingPaymentFromUser: () => [
          DashboardNavigationType.pricingPage,
          ...defaultOptions,
        ],
        everythingOk: () => defaultOptions,
        none: () => defaultOptions,
      );
});
