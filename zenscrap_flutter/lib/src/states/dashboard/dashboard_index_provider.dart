import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

final currentTabIndexProvider =
    StateNotifierProvider<CurrentTabIndexStateNotifier, int>((ref) {
  return CurrentTabIndexStateNotifier(ref);
});

final currentDashboardTabProvider = Provider<DashboardNavigationType>((ref) {
  final currentTabIndex = ref.watch(currentTabIndexProvider);

  return DashboardNavigationType.values[currentTabIndex];
});

class CurrentTabIndexStateNotifier extends StateNotifier<int> {
  CurrentTabIndexStateNotifier(this.ref) : super(0);
  final Ref ref;

  void setPage(int page) {
    state = page;
  }
}

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

  ref.read(currentTabIndexProvider.notifier).setPage(tab.index);

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
    });
  }
}
