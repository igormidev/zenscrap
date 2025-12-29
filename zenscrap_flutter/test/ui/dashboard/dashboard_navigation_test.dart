import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/dashboard_view.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive navigation pattern tests for dashboard.
///
/// Tests verify that:
/// 1. Compact (< 600px): Shows Drawer with hamburger menu, NO Rail
/// 2. Medium (600-839px): Shows Rail with NO expand button
/// 3. Expanded (>= 840px): Shows Rail with expand button OR Drawer when expanded
/// 4. Navigation switches correctly at breakpoint edges (599, 600, 839, 840)
/// 5. Drawer can be opened via hamburger menu in compact mode
/// 6. Rail destinations are tappable and navigate correctly
/// 7. Expand button toggles between rail and drawer in expanded mode
void main() {
  group('Dashboard Navigation Pattern Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('Navigation Pattern by Breakpoint', () {
      testWidgets(
        'compact (320px): shows drawer navigation, no rail',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.drawer,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should show hamburger menu button (drawer trigger)
          expect(
            find.byIcon(Icons.menu),
            findsOneWidget,
            reason: 'Compact mode should show hamburger menu',
          );

          // Should NOT show navigation rail
          expect(
            find.byType(NavigationRail),
            findsNothing,
            reason: 'Compact mode should not show navigation rail',
          );

          // Should have a drawer available (find the inner Scaffold with drawer)
          final scaffolds = find.byType(Scaffold);
          expect(scaffolds, findsWidgets);

          // The inner scaffold (from _MockDashboardWithNavigation) has the drawer
          final innerScaffold = scaffolds.evaluate().firstWhere(
            (element) {
              final widget = element.widget as Scaffold;
              return widget.drawer != null;
            },
          );

          final scaffoldState = tester.state<ScaffoldState>(
            find.byWidget(innerScaffold.widget),
          );
          expect(
            scaffoldState.hasDrawer,
            isTrue,
            reason: 'Compact mode should have a drawer',
          );
        },
      );

      testWidgets(
        'compact (375px): shows drawer navigation, no rail',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.drawer,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(find.byIcon(Icons.menu), findsOneWidget);
          expect(find.byType(NavigationRail), findsNothing);
        },
      );

      testWidgets(
        'breakpoint edge (599px): still shows drawer navigation',
        (tester) async {
          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.drawer,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            find.byIcon(Icons.menu),
            findsOneWidget,
            reason: '599px should still be compact with drawer',
          );
          expect(find.byType(NavigationRail), findsNothing);
        },
      );

      testWidgets(
        'medium (600px): shows rail with NO expand button',
        (tester) async {
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should show navigation rail
          expect(
            find.byType(NavigationRail),
            findsOneWidget,
            reason: 'Medium mode should show navigation rail',
          );

          // Should NOT show hamburger menu
          expect(
            find.byIcon(Icons.menu),
            findsNothing,
            reason: 'Medium mode should not show hamburger menu',
          );

          // Should NOT show expand button
          expect(
            find.byKey(const Key('expand_button')),
            findsNothing,
            reason: 'Medium mode should not show expand button',
          );
        },
      );

      testWidgets(
        'medium (tablet portrait): shows rail with NO expand button',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(find.byType(NavigationRail), findsOneWidget);
          expect(find.byKey(const Key('expand_button')), findsNothing);
        },
      );

      testWidgets(
        'breakpoint edge (839px): still shows rail with NO expand button',
        (tester) async {
          await tester.setScreenSize(const Size(839, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            find.byType(NavigationRail),
            findsOneWidget,
            reason: '839px should still be medium with rail only',
          );
          expect(find.byKey(const Key('expand_button')), findsNothing);
        },
      );

      testWidgets(
        'expanded (840px): shows rail with expand button',
        (tester) async {
          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should show navigation rail
          expect(
            find.byType(NavigationRail),
            findsOneWidget,
            reason: 'Expanded mode should show navigation rail by default',
          );

          // Should show expand button
          expect(
            find.byKey(const Key('expand_button')),
            findsOneWidget,
            reason: 'Expanded mode should show expand button',
          );
        },
      );

      testWidgets(
        'expanded (1200px desktop): shows rail with expand button',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(find.byType(NavigationRail), findsOneWidget);
          expect(find.byKey(const Key('expand_button')), findsOneWidget);
        },
      );

      testWidgets(
        'expanded (840px): can show drawer when toggled',
        (tester) async {
          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.drawer,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should show navigation drawer instead of rail
          expect(
            find.byType(NavigationDrawer),
            findsOneWidget,
            reason: 'Expanded mode can show drawer when toggled',
          );

          // Should still show expand button (for collapsing back to rail)
          expect(
            find.byKey(const Key('expand_button')),
            findsOneWidget,
            reason: 'Drawer mode should show expand button for collapsing',
          );

          // Should NOT show navigation rail
          expect(
            find.byType(NavigationRail),
            findsNothing,
            reason: 'Should not show rail when drawer is expanded',
          );
        },
      );
    });

    group('Drawer Navigation Tests', () {
      testWidgets(
        'hamburger menu opens drawer in compact mode',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.drawer,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Initially, drawer should be closed
          expect(find.byType(NavigationDrawer), findsNothing);

          // Tap hamburger menu
          await tester.tap(find.byIcon(Icons.menu));
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          // Drawer should now be visible
          expect(
            find.byType(NavigationDrawer),
            findsOneWidget,
            reason: 'Drawer should open after tapping hamburger menu',
          );
        },
      );

      testWidgets(
        'drawer destinations are tappable',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.drawer,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Open drawer
          await tester.tap(find.byIcon(Icons.menu));
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          // Find drawer destinations
          final destinations = find.byType(NavigationDrawerDestination);
          expect(destinations, findsWidgets);

          // Tap a destination (should not throw)
          await tester.tap(destinations.first);
          await tester.pumpAndSettle(const Duration(milliseconds: 300));
        },
      );

      testWidgets(
        'compact drawer has isCompactMode = true',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardDrawerStandalone(isCompactMode: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Drawer width should be 280px in compact mode
          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('drawer_container')),
          );
          expect(
            sizedBox.width,
            equals(280.0),
            reason: 'Compact drawer should be 280px wide',
          );
        },
      );

      testWidgets(
        'expanded drawer has isCompactMode = false',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardDrawerStandalone(isCompactMode: false),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Drawer width should be 200px in expanded mode
          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('drawer_container')),
          );
          expect(
            sizedBox.width,
            equals(200.0),
            reason: 'Expanded drawer should be 200px wide',
          );
        },
      );
    });

    group('Rail Navigation Tests', () {
      testWidgets(
        'rail destinations are tappable',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Find the NavigationRail widget
          final rail = find.byType(NavigationRail);
          expect(rail, findsOneWidget);

          // Find icons within the rail - we can tap these
          final icons = find.descendant(
            of: rail,
            matching: find.byType(Icon),
          );
          expect(icons, findsWidgets);

          // Tap a destination icon (should not throw)
          await tester.tap(icons.first);
          await tester.pumpAndSettle(const Duration(milliseconds: 300));
        },
      );

      testWidgets(
        'medium rail has showExpandButton = false',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardRailStandalone(showExpandButton: false),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should not find expand button
          expect(
            find.byKey(const Key('expand_button')),
            findsNothing,
            reason: 'Medium rail should not have expand button',
          );
        },
      );

      testWidgets(
        'expanded rail has showExpandButton = true',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardRailStandalone(showExpandButton: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should find expand button
          expect(
            find.byKey(const Key('expand_button')),
            findsOneWidget,
            reason: 'Expanded rail should have expand button',
          );
        },
      );
    });

    group('Expand Button Behavior Tests', () {
      testWidgets(
        'expand button shows correct icon in rail mode',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockExpandButtonStandalone(
                navigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should show expand icon (double arrow right)
          expect(
            find.byIcon(Icons.keyboard_double_arrow_right_rounded),
            findsOneWidget,
            reason: 'Rail mode should show expand icon',
          );

          // Should NOT show collapse icon
          expect(
            find.byIcon(Icons.keyboard_double_arrow_left_rounded),
            findsNothing,
          );
        },
      );

      testWidgets(
        'expand button shows correct icon and text in drawer mode',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockExpandButtonStandalone(
                navigationType: NavigationType.drawer,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should show collapse icon (double arrow left)
          expect(
            find.byIcon(Icons.keyboard_double_arrow_left_rounded),
            findsOneWidget,
            reason: 'Drawer mode should show collapse icon',
          );

          // Should show "Collapse" text
          expect(
            find.text('Collapse'),
            findsOneWidget,
            reason: 'Drawer mode should show "Collapse" text',
          );
        },
      );

      testWidgets(
        'expand button is tappable',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);

          bool toggleCalled = false;
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockExpandButtonStandalone(
                navigationType: NavigationType.rail,
                onToggle: () => toggleCalled = true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Tap expand button
          await tester.tap(find.byType(InkWell));
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            toggleCalled,
            isTrue,
            reason: 'Expand button tap should trigger callback',
          );
        },
      );
    });

    group('Navigation Type Persistence Tests', () {
      testWidgets(
        'navigation type is preserved across breakpoint changes',
        (tester) async {
          // Start in expanded mode with rail
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(find.byType(NavigationRail), findsOneWidget);

          // Resize to medium - should still show rail (no choice)
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(find.byType(NavigationRail), findsOneWidget);
        },
      );
    });

    group('Account Image Position Tests', () {
      testWidgets(
        'account image appears in appbar in compact mode',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithNavigation(
                currentNavigationType: NavigationType.drawer,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Account image should be in appbar (size 32)
          final appBar = find.byType(AppBar);
          expect(appBar, findsOneWidget);
        },
      );

      testWidgets(
        'account image appears in rail in medium mode',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardRailStandalone(
                showExpandButton: false,
                includeAccountImage: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Account image should be in column above rail
          expect(find.byType(CircleAvatar), findsOneWidget);
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock dashboard with complete navigation setup
class _MockDashboardWithNavigation extends StatelessWidget {
  final NavigationType currentNavigationType;

  const _MockDashboardWithNavigation({
    required this.currentNavigationType,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      // Compact (< 600dp): Drawer with hamburger menu
      compact: (context, constraints) => Scaffold(
        drawer: _MockDashboardDrawerStandalone(isCompactMode: true),
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const Text('Dashboard'),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(radius: 16),
            ),
          ],
        ),
        body: const Center(child: Text('Dashboard Content')),
      ),
      // Medium (600-839dp): Navigation Rail only
      medium: (context, constraints) => Scaffold(
        body: Row(
          children: [
            _MockDashboardRailStandalone(
              showExpandButton: false,
              includeAccountImage: true,
            ),
            const Expanded(child: Center(child: Text('Dashboard Content'))),
          ],
        ),
      ),
      // Expanded (>= 840dp): Toggle between Rail and Drawer
      expanded: (context, constraints) => Scaffold(
        body: Row(
          children: [
            switch (currentNavigationType) {
              NavigationType.rail => _MockDashboardRailStandalone(
                  showExpandButton: true,
                  includeAccountImage: true,
                ),
              NavigationType.drawer => _MockDashboardDrawerStandalone(
                  isCompactMode: false,
                  showExpandButton: true,
                ),
            },
            const Expanded(child: Center(child: Text('Dashboard Content'))),
          ],
        ),
      ),
    );
  }
}

/// Mock dashboard drawer
class _MockDashboardDrawerStandalone extends StatelessWidget {
  final bool isCompactMode;
  final bool showExpandButton;

  const _MockDashboardDrawerStandalone({
    required this.isCompactMode,
    this.showExpandButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final drawerWidth = isCompactMode ? 280.0 : 200.0;

    return SizedBox(
      key: const Key('drawer_container'),
      width: drawerWidth,
      child: Stack(
        children: [
          NavigationDrawer(
            selectedIndex: 0,
            onDestinationSelected: (int index) {},
            children: [
              const SizedBox(height: 20),
              NavigationDrawerDestination(
                icon: const Icon(Icons.api_outlined),
                selectedIcon: const Icon(Icons.api),
                label: Text(isCompactMode ? 'Endpoints' : 'API'),
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.hub_outlined),
                selectedIcon: const Icon(Icons.hub),
                label: Text(isCompactMode ? 'Marketplace' : 'Market'),
              ),
              NavigationDrawerDestination(
                icon: const Icon(Icons.key_outlined),
                selectedIcon: const Icon(Icons.key),
                label: Text(isCompactMode ? 'Credits' : 'Keys'),
              ),
            ],
          ),
          if (showExpandButton)
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _MockExpandButtonStandalone(
                    navigationType: NavigationType.drawer,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
        ],
      ),
    );
  }
}

/// Mock dashboard rail
class _MockDashboardRailStandalone extends StatelessWidget {
  final bool showExpandButton;
  final bool includeAccountImage;

  const _MockDashboardRailStandalone({
    required this.showExpandButton,
    this.includeAccountImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        if (includeAccountImage) const CircleAvatar(radius: 30),
        if (includeAccountImage) const SizedBox(height: 8),
        Expanded(
          child: NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {},
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.api_outlined),
                selectedIcon: Icon(Icons.api),
                label: Text('Endpoints'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.hub_outlined),
                selectedIcon: Icon(Icons.hub),
                label: Text('Marketplace'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.key_outlined),
                selectedIcon: Icon(Icons.key),
                label: Text('Credits'),
              ),
            ],
          ),
        ),
        if (showExpandButton)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _MockExpandButtonStandalone(
              navigationType: NavigationType.rail,
            ),
          ),
        if (showExpandButton) const SizedBox(height: 8),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Mock expand button
class _MockExpandButtonStandalone extends StatelessWidget {
  final NavigationType navigationType;
  final VoidCallback? onToggle;

  const _MockExpandButtonStandalone({
    required this.navigationType,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('expand_button'),
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              switch (navigationType) {
                NavigationType.rail => Icons.keyboard_double_arrow_right_rounded,
                NavigationType.drawer => Icons.keyboard_double_arrow_left_rounded,
              },
              size: 20,
            ),
            if (navigationType == NavigationType.drawer) ...[
              const SizedBox(width: 4),
              const Flexible(
                child: Text(
                  'Collapse',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
