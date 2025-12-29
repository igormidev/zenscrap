import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_index_provider.dart';
import 'package:zenscrap_flutter/src/states/dashboard/possible_navigations_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/dashboard_view.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/account_image.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/expand_button.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/version_indicator.dart';

class DashboardDrawer extends ConsumerWidget {
  const DashboardDrawer({
    super.key,
    required this.widget,
    required this.navigationType,
    required this.changeDrawerStyle,
    this.isCompactMode = false,
  });

  final DashboardView widget;
  final NavigationType navigationType;
  final void Function(NavigationType type) changeDrawerStyle;

  /// When true, the drawer is shown in compact/mobile mode where it slides in.
  /// In this mode, the expand button is hidden since there's no rail alternative.
  final bool isCompactMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationOptions = ref.watch(possibleNavigationsProvider);
    final currentTabIndex = ref.watch(currentTabIndexProvider);
    final accountImageUrl = ref
        .watch(sessionProvider)
        .mapOrNull(logged: (value) => value.user.imageUrl);

    // Responsive sizing
    final drawerWidth = isCompactMode ? 280.0 : 200.0;
    final accountImageSize = isCompactMode ? 100.0 : 120.0;

    return SizedBox(
      width: drawerWidth,
      child: Stack(
        children: [
          NavigationDrawer(
            backgroundColor: context.c.surface,
            selectedIndex: currentTabIndex,
            onDestinationSelected: (int index) async {
              final DashboardNavigationType tab = navigationOptions[index];

              await changeTab(tab, context, ref);
              if (context.mounted) {
                // Only close drawer if in compact mode (slide-in drawer)
                if (isCompactMode) {
                  Scaffold.of(context).closeDrawer();
                }
              }
            },
            children: [
              const SizedBox(height: 20),
              AccountImage(image: accountImageUrl, size: accountImageSize),
              const SizedBox(height: 20),
              const Divider(height: 16),
              ...navigationOptions.map((item) {
                final isActive = true;
                return NavigationDrawerDestination(
                  enabled: isActive,
                  icon: Icon(item.inactiveIcon),
                  selectedIcon: Icon(item.activeIcon),
                  label: Text(item.getLocalizedLabel(context)),
                );
              }),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Only show expand button in expanded mode (not in compact/mobile)
              if (!isCompactMode)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ExpandButton(
                    selectedNavigationType: navigationType,
                    onNavigationTypeChange: changeDrawerStyle,
                  ),
                ),
              if (!isCompactMode) const SizedBox(height: 8),
              const VersionIndicator(),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
