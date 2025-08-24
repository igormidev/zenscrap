import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_index_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

// If null, means no error
final dashboardErrorProvider = Provider<ZenScrapException?>((ref) {
  final selectedPage = ref.watch(currentDashboardTabProvider);
  final accountError = ref.watch(
    accountProvider.select(
      (state) => state.whenOrNull(withError: (value) => value),
    ),
  );
  if (accountError != null) {
    return accountError;
  }

  final List<ZenScrapException?> pageDependenciesErrors =
      switch (selectedPage) {
    DashboardNavigationType.userEndpoints => [
        ref.watch(userScrappables
            .select((value) => value.whenOrNull(withError: (error) => error))),
      ],
    DashboardNavigationType.marketPlace => [
        ref.watch(marketplaceProvider
            .select((value) => value.whenOrNull(withError: (error) => error))),
      ],
    DashboardNavigationType.usage => [],
    DashboardNavigationType.account => [],
    DashboardNavigationType.logOut => [],
    DashboardNavigationType.pricingPage => [],
  };

  return pageDependenciesErrors.firstWhereOrNull((element) => element != null);
});
