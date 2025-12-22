import 'package:flutter/material.dart';
import '../responsive/responsive.dart';

/// A navigation destination for the adaptive scaffold
class AdaptiveDestination {
  /// Icon when the destination is not selected
  final IconData icon;

  /// Icon when the destination is selected
  final IconData? selectedIcon;

  /// Text label for the destination
  final String label;

  /// Optional tooltip (defaults to label)
  final String? tooltip;

  /// Optional badge count
  final int? badgeCount;

  const AdaptiveDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.tooltip,
    this.badgeCount,
  });
}

/// An adaptive scaffold that switches navigation based on screen size:
/// - Compact: Bottom navigation bar
/// - Medium: Navigation rail
/// - Expanded: Navigation drawer (collapsible)
///
/// Example:
/// ```dart
/// AdaptiveScaffold(
///   selectedIndex: _currentIndex,
///   onDestinationSelected: (index) => setState(() => _currentIndex = index),
///   destinations: [
///     AdaptiveDestination(icon: Icons.home, label: 'Home'),
///     AdaptiveDestination(icon: Icons.settings, label: 'Settings'),
///   ],
///   body: _pages[_currentIndex],
/// )
/// ```
class AdaptiveScaffold extends StatelessWidget {
  /// The currently selected destination index
  final int selectedIndex;

  /// Callback when a destination is selected
  final ValueChanged<int> onDestinationSelected;

  /// The navigation destinations
  final List<AdaptiveDestination> destinations;

  /// The main body content
  final Widget body;

  /// Optional app bar (for compact mode)
  final PreferredSizeWidget? appBar;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Location of the FAB
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Whether the drawer should be extended (expanded mode only)
  final bool extendedDrawer;

  /// Optional leading widget for the navigation rail/drawer
  final Widget? navigationLeading;

  /// Optional trailing widget for the navigation rail/drawer
  final Widget? navigationTrailing;

  /// Optional callback for drawer toggle (expanded mode)
  final VoidCallback? onDrawerToggle;

  /// Custom background color for navigation
  final Color? navigationBackgroundColor;

  const AdaptiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendedDrawer = true,
    this.navigationLeading,
    this.navigationTrailing,
    this.onDrawerToggle,
    this.navigationBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      compact: (context, constraints) => _CompactLayout(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
        body: body,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        navigationBackgroundColor: navigationBackgroundColor,
      ),
      medium: (context, constraints) => _MediumLayout(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
        body: body,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        navigationLeading: navigationLeading,
        navigationTrailing: navigationTrailing,
        navigationBackgroundColor: navigationBackgroundColor,
      ),
      expanded: (context, constraints) => _ExpandedLayout(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
        body: body,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        navigationLeading: navigationLeading,
        navigationTrailing: navigationTrailing,
        navigationBackgroundColor: navigationBackgroundColor,
      ),
    );
  }
}

/// Compact layout: Bottom navigation bar
class _CompactLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveDestination> destinations;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? navigationBackgroundColor;

  const _CompactLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.navigationBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        backgroundColor: navigationBackgroundColor,
        destinations: destinations.map((dest) {
          return NavigationDestination(
            icon: _BadgeIcon(icon: dest.icon, badgeCount: dest.badgeCount),
            selectedIcon: _BadgeIcon(
              icon: dest.selectedIcon ?? dest.icon,
              badgeCount: dest.badgeCount,
            ),
            label: dest.label,
            tooltip: dest.tooltip ?? dest.label,
          );
        }).toList(),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// Medium layout: Navigation rail
class _MediumLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveDestination> destinations;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? navigationLeading;
  final Widget? navigationTrailing;
  final Color? navigationBackgroundColor;

  const _MediumLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.navigationLeading,
    this.navigationTrailing,
    this.navigationBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: navigationBackgroundColor,
            labelType: NavigationRailLabelType.all,
            leading: navigationLeading,
            trailing: navigationTrailing != null
                ? Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: navigationTrailing,
                      ),
                    ),
                  )
                : null,
            destinations: destinations.map((dest) {
              return NavigationRailDestination(
                icon: _BadgeIcon(icon: dest.icon, badgeCount: dest.badgeCount),
                selectedIcon: _BadgeIcon(
                  icon: dest.selectedIcon ?? dest.icon,
                  badgeCount: dest.badgeCount,
                ),
                label: Text(dest.label),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// Expanded layout: Navigation drawer
class _ExpandedLayout extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<AdaptiveDestination> destinations;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? navigationLeading;
  final Widget? navigationTrailing;
  final Color? navigationBackgroundColor;

  const _ExpandedLayout({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.navigationLeading,
    this.navigationTrailing,
    this.navigationBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationDrawer(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            backgroundColor: navigationBackgroundColor,
            children: [
              if (navigationLeading != null) ...[
                navigationLeading!,
                const Divider(indent: 16, endIndent: 16),
              ],
              ...destinations.map((dest) {
                return NavigationDrawerDestination(
                  icon: _BadgeIcon(icon: dest.icon, badgeCount: dest.badgeCount),
                  selectedIcon: _BadgeIcon(
                    icon: dest.selectedIcon ?? dest.icon,
                    badgeCount: dest.badgeCount,
                  ),
                  label: Text(dest.label),
                );
              }),
              if (navigationTrailing != null) ...[
                const Spacer(),
                const Divider(indent: 16, endIndent: 16),
                navigationTrailing!,
                const SizedBox(height: 16),
              ],
            ],
          ),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}

/// Icon with optional badge count
class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int? badgeCount;

  const _BadgeIcon({
    required this.icon,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon);

    if (badgeCount == null || badgeCount! <= 0) {
      return iconWidget;
    }

    return Badge.count(
      count: badgeCount!,
      child: iconWidget,
    );
  }
}
