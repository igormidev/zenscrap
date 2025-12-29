import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/dashboard/possible_navigations_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/dashboard_view.dart';

/// Notifier for managing the current tab index in the dashboard.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class CurrentTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int page) {
    state = page;
  }
}

final currentTabIndexProvider =
    NotifierProvider<CurrentTabIndexNotifier, int>(CurrentTabIndexNotifier.new);

final currentDashboardTabProvider = Provider<DashboardNavigationType>((ref) {
  final navigationOptions = ref.watch(possibleNavigationsProvider);
  final currentTabIndex = ref.watch(currentTabIndexProvider);

  return navigationOptions[currentTabIndex];
});

Future<void> changeTab(
  DashboardNavigationType tab,
  BuildContext context,
  WidgetRef ref,
) async {
  if (tab == DashboardNavigationType.logOut) {
    ref.read(currentTabIndexProvider.notifier).setPage(0);

    await logOut(context, ref);
    return;
  }

  ref
      .read(currentTabIndexProvider.notifier)
      .setPage(ref.read(possibleNavigationsProvider).indexOf(tab));

  final route = tab.routeOnClick;
  if (route != null) {
    context.go(route);
  }
}

Future<void> logOut(BuildContext context, WidgetRef ref) async {
  final result = await showOkCancelAlertDialog(
    context: context,
    title: 'Log out',
    message: 'Are you sure you want to log out?',
    okLabel: 'Log out',
    cancelLabel: 'Cancel',
  );
  if (result == OkCancelResult.ok) {
    ref.globalLoadingSetter(() async {
      await ref.read(sessionManagerProvider).signOutDevice();
      ref.read(sessionProvider.notifier).setState(SessionState.notSignedIn());
    });
  }
}

Future<void> rawLogOut(BuildContext context, Ref ref) async {
  final result = await showOkCancelAlertDialog(
    context: context,
    title: 'Log out',
    message: 'Are you sure you want to log out?',
    okLabel: 'Log out',
    cancelLabel: 'Cancel',
  );
  if (result == OkCancelResult.ok) {
    ref.globalLoadingSetter(() async {
      await ref.read(sessionManagerProvider).signOutDevice();
      ref.read(sessionProvider.notifier).setState(SessionState.notSignedIn());
    });
  }
}
