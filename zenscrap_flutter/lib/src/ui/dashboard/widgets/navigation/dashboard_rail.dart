import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/states/dashboard/dashboard_index_provider.dart';
import 'package:zenscrap_flutter/src/states/dashboard/possible_navigations_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/dashboard_view.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/account_image.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/expand_button.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/widgets/version_indicator.dart';

class DashboardRail extends ConsumerWidget {
  const DashboardRail({
    super.key,
    required this.widget,
    required this.navigationType,
    required this.changeDrawerStyle,
    this.showExpandButton = true,
  });

  final DashboardView widget;
  final NavigationType navigationType;
  final void Function(NavigationType type) changeDrawerStyle;

  /// Whether to show the expand/collapse button.
  /// Set to false for medium screens where rail is the only option.
  final bool showExpandButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationOptions = ref.watch(possibleNavigationsProvider);
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
              final DashboardNavigationType tab = navigationOptions[index];
              changeTab(tab, context, ref);
            },
            destinations: [
              ...navigationOptions.map(
                (item) {
                  final isActive = true;
                  return NavigationRailDestination(
                    disabled: !isActive,
                    icon: Icon(item.inactiveIcon),
                    selectedIcon: Icon(item.activeIcon),
                    label: Text(item.getLocalizedLabel(context)),
                  );
                },
              ),
            ],
          ),
        ),
        // Only show expand button when enabled (expanded mode, not medium)
        if (showExpandButton)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ExpandButton(
              selectedNavigationType: navigationType,
              onNavigationTypeChange: changeDrawerStyle,
            ),
          ),
        if (showExpandButton) const SizedBox(height: 8),
        VersionIndicator(
          versionText: (version) => AppLocalizations.of(context)!.dashboard_version_short(version),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
