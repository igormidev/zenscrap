import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_index_provider.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables.dart';
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
    DashboardNavigationType.userEndpoints => [
        ref.watch(userScrappables.select((value) =>
            value.maybeMap(loading: (loading) => true, orElse: () => false))),
      ],
    DashboardNavigationType.marketPlace => [],
    DashboardNavigationType.usage => [],
    DashboardNavigationType.account => [],
    DashboardNavigationType.logOut => [],
  };

  return pageDependenciesLoading.any((element) => element);
});
