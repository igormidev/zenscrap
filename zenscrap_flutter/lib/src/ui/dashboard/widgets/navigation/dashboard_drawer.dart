import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_index_provider.dart';
import 'package:zenscrap_flutter/src/states/dashboard/possible_navigations_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/account_image.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/version_indicator.dart';

class DashboardDrawer extends ConsumerWidget {
  const DashboardDrawer({
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
    final navigationOptions = ref.watch(possibleNavigationsProvider);
    final currentTabIndex = ref.watch(currentTabIndexProvider);
    final accountImageUrl = ref
        .watch(sessionProvider)
        .mapOrNull(logged: (value) => value.user.imageUrl);

    return SizedBox(
      width: 200.0,
      child: Stack(
        children: [
          NavigationDrawer(
            backgroundColor: context.c.surface,
            selectedIndex: currentTabIndex,
            onDestinationSelected: (int index) async {
              final DashboardNavigationType tab = navigationOptions[index];

              await changeTab(tab, context, ref);
              if (context.mounted) Scaffold.of(context).closeDrawer();
            },
            children: [
              const SizedBox(height: 20),
              AccountImage(image: accountImageUrl, size: 120),
              const SizedBox(height: 20),
              const Divider(height: 16),
              ...navigationOptions.map((item) {
                final isActive = true;
                return NavigationDrawerDestination(
                  enabled: isActive,
                  icon: Icon(item.inactiveIcon),
                  selectedIcon: Icon(item.activeIcon),
                  label: Text(item.label),
                );
              }),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ExpandButton(
                  selectedNavigationType: navigationType,
                  onNavigationTypeChange: changeDrawerStyle,
                ),
              ),
              const SizedBox(height: 8),
              const VersionIndicator(),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
