import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_index_provider.dart';
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
    DashboardNavigationType.endpoints => [],
    DashboardNavigationType.marketPlace => [],
    DashboardNavigationType.languages => [],
    DashboardNavigationType.account => [],
    DashboardNavigationType.logOut => [],
  };

  return pageDependenciesErrors.firstWhereOrNull((element) => element != null);
});
