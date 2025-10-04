import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/analytics_state.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_index_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

typedef HaveAnyActiveLoading = bool;

final dashboardLoadingProvider = Provider<HaveAnyActiveLoading>((ref) {
  final selectedPage = ref.watch(currentDashboardTabProvider);
  final isAccountInfoLoading = ref.watch(accountProvider).maybeMap(
        initial: (value) => true,
        loading: (value) => true,
        orElse: () => false,
      );
  if (isAccountInfoLoading) {
    return true;
  }

  final List<bool> pageDependenciesLoading = switch (selectedPage) {
    DashboardNavigationType.analytics => [
        ref.watch(analyticsProvider.select((value) =>
            value.maybeMap(loading: (loading) => true, orElse: () => false))),
      ],
    DashboardNavigationType.userEndpoints => [
        ref.watch(userScrappables.select((value) =>
            value.maybeMap(loading: (loading) => true, orElse: () => false))),
      ],
    DashboardNavigationType.marketPlace => [
        ref.watch(marketplaceProvider.select((value) =>
            value.maybeMap(loading: (loading) => true, orElse: () => false))),
      ],
    DashboardNavigationType.usage => [],
    DashboardNavigationType.account => [],
    DashboardNavigationType.logOut => [],
    DashboardNavigationType.pricingPage => [],
  };

  return pageDependenciesLoading.any((element) => element);
});
