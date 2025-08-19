import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_index_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/account_image.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/version_indicator.dart';

class DashboardRail extends ConsumerWidget {
  const DashboardRail({
    super.key,
    required this.widget,
    required this.navigationType,
    required this.changeDrawerStyle,
  });

  final DashboardView widget;
  final NavigationType navigationType;
  final void Function(NavigationType type) changeDrawerStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTabIndex = ref.watch(currentTabIndexProvider);
    final accountImageUrl = ref.watch(sessionProvider).mapOrNull(
          logged: (value) => value.user.imageUrl,
        );

    return Column(
      children: [
        const SizedBox(height: 20),
        AccountImage(
          image: accountImageUrl,
          size: 60,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: NavigationRail(
            selectedIndex: currentTabIndex,
            onDestinationSelected: (int index) async {
              final DashboardNavigationType tab =
                  DashboardNavigationType.values[index];
              changeTab(tab, context, ref);
            },
            destinations: [
              ...DashboardNavigationType.values.map(
                (item) {
                  final isActive = true;
                  return NavigationRailDestination(
                    disabled: !isActive,
                    icon: Icon(item.inactiveIcon),
                    selectedIcon: Icon(item.activeIcon),
                    label: Text(item.label),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: ExpandButton(
            selectedNavigationType: navigationType,
            onNavigationTypeChange: changeDrawerStyle,
          ),
        ),
        const SizedBox(height: 8),
        VersionIndicator(
          versionText: (version) => 'v$version',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
