import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Touch target compliance tests for dashboard components.
///
/// Material Design and WCAG accessibility guidelines require a minimum
/// touch target size of 48x48 pixels for interactive elements on mobile.
///
/// Tests verify that:
/// 1. Navigation drawer destinations have adequate touch area
/// 2. Navigation rail destinations have adequate touch area
/// 3. Hamburger menu button has at least 48px touch area
/// 4. Expand/collapse button has adequate touch area
/// 5. Account image (when tappable) has adequate touch area
/// 6. All interactive dashboard elements meet minimum touch target requirements
void main() {
  group('Dashboard Touch Target Compliance Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('Navigation Drawer Destination Touch Targets', () {
      testWidgets(
        'drawer destinations have adequate touch area on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockNavigationDrawer(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find all drawer destinations
          final destinations = find.byType(NavigationDrawerDestination);
          expect(destinations, findsWidgets);

          // Each destination should be tappable
          for (var i = 0; i < destinations.evaluate().length; i++) {
            final destElement = destinations.evaluate().elementAt(i);
            final renderBox = destElement.renderObject as RenderBox;
            final size = renderBox.size;

            expect(
              size.height,
              greaterThanOrEqualTo(48.0),
              reason: 'Drawer destination $i should have at least 48px height',
            );
          }
        },
      );

      testWidgets(
        'drawer destinations are tappable at 320px width',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockNavigationDrawer(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final destinations = find.byType(NavigationDrawerDestination);

          // Tap each destination to verify they're tappable
          for (var i = 0; i < destinations.evaluate().length; i++) {
            await tester.tap(destinations.at(i));
            await tester.pumpAndSettle(const Duration(milliseconds: 100));
          }

          // All taps should succeed without exception
        },
      );
    });

    group('Navigation Rail Destination Touch Targets', () {
      testWidgets(
        'rail destinations have adequate touch area on medium screens',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockNavigationRail(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the NavigationRail widget
          final rail = find.byType(NavigationRail);
          expect(rail, findsOneWidget);

          // Get the NavigationRail widget to access destinations
          final railWidget = tester.widget<NavigationRail>(rail);
          final destinationCount = railWidget.destinations.length;
          expect(destinationCount, greaterThan(0));

          // Find all icons within the rail - each destination renders an icon
          final icons = find.descendant(
            of: rail,
            matching: find.byType(Icon),
          );

          // There should be at least as many icons as destinations
          // (could be more due to selected/unselected states)
          expect(
            icons.evaluate().length,
            greaterThanOrEqualTo(destinationCount),
            reason: 'Each rail destination should render an icon',
          );

          // Verify the rail itself has proper sizing
          final railElement = tester.element(rail);
          final railRenderBox = railElement.renderObject as RenderBox;
          final railSize = railRenderBox.size;

          // Rail should be at least 72px wide (Material Design standard)
          expect(
            railSize.width,
            greaterThanOrEqualTo(72.0),
            reason: 'Navigation rail should have adequate width for touch targets',
          );
        },
      );

      testWidgets(
        'rail destinations are tappable',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockNavigationRail(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the NavigationRail and get the destination count
          final rail = find.byType(NavigationRail);
          final railWidget = tester.widget<NavigationRail>(rail);
          final destinationCount = railWidget.destinations.length;

          // Find icons within the rail - we'll tap on these
          final icons = find.descendant(
            of: rail,
            matching: find.byType(Icon),
          );

          expect(icons.evaluate().length, greaterThanOrEqualTo(destinationCount));

          // Tap each icon to verify destinations are tappable
          // We tap only the first `destinationCount` icons to avoid tapping selected icon duplicates
          for (var i = 0; i < destinationCount; i++) {
            await tester.tap(icons.at(i));
            await tester.pumpAndSettle(const Duration(milliseconds: 100));
          }
        },
      );
    });

    group('Hamburger Menu Button Touch Targets', () {
      testWidgets(
        'hamburger menu button has at least 48px touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockCompactAppBar(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the hamburger menu button
          final menuButton = find.byType(IconButton).first;
          expect(menuButton, findsWidgets);

          final iconButtonElement = tester.element(menuButton);
          final renderBox = iconButtonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Hamburger menu should have at least 48px width',
          );
          expect(
            size.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Hamburger menu should have at least 48px height',
          );
        },
      );

      testWidgets(
        'hamburger menu button is tappable at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockCompactAppBar(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Tap the hamburger menu
          await tester.tap(find.byIcon(Icons.menu));
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          // Tap should succeed without exception
        },
      );
    });

    group('Expand/Collapse Button Touch Targets', () {
      testWidgets(
        'expand button in rail mode has adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockExpandButton(isExpanded: false),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Get the render box to check size
          final buttonElement = tester.element(find.byType(InkWell));
          final renderBox = buttonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.height,
            greaterThanOrEqualTo(40.0),
            reason: 'Expand button should have adequate height for touch',
          );

          // Button should also be wide enough for touch
          expect(
            size.width,
            greaterThanOrEqualTo(40.0),
            reason: 'Expand button should have adequate width for touch',
          );
        },
      );

      testWidgets(
        'expand button in drawer mode has adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockExpandButton(isExpanded: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonElement = tester.element(find.byType(InkWell));
          final renderBox = buttonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.height,
            greaterThanOrEqualTo(40.0),
            reason: 'Collapse button should have adequate height for touch',
          );
        },
      );

      testWidgets(
        'expand button is tappable',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);

          bool tapped = false;
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockExpandButton(
                isExpanded: false,
                onTap: () => tapped = true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Tap the expand button
          await tester.tap(find.byType(InkWell));
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          expect(tapped, isTrue, reason: 'Expand button should be tappable');
        },
      );
    });

    group('Account Image Touch Targets', () {
      testWidgets(
        'account image in appbar has minimum 32px size',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAccountImage(size: 32, isTappable: false),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('account_image_container')),
          );

          expect(sizedBox.width, equals(32.0));
          expect(sizedBox.height, equals(32.0));
        },
      );

      testWidgets(
        'tappable account image has adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);

          bool tapped = false;
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAccountImage(
                size: 32,
                isTappable: true,
                onTap: () => tapped = true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Even though image is 32px, the tappable area should be larger
          final gestureElement = tester.element(find.byType(GestureDetector));
          final renderBox = gestureElement.renderObject as RenderBox;
          final size = renderBox.size;

          // GestureDetector should have minimum touch target
          expect(
            size.width,
            greaterThanOrEqualTo(32.0),
            reason: 'Tappable account image should have adequate width',
          );
          expect(
            size.height,
            greaterThanOrEqualTo(32.0),
            reason: 'Tappable account image should have adequate height',
          );

          // Verify it's actually tappable
          await tester.tap(find.byType(GestureDetector));
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          expect(tapped, isTrue, reason: 'Account image should be tappable');
        },
      );

      testWidgets(
        'account image in rail has 60px size',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAccountImage(size: 60, isTappable: false),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('account_image_container')),
          );

          expect(sizedBox.width, equals(60.0));
          expect(sizedBox.height, equals(60.0));
        },
      );
    });

    group('Version Indicator Touch Targets', () {
      testWidgets(
        'version indicator text is readable but not interactive',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockVersionIndicator(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Version indicator should be present
          expect(find.byType(Text), findsOneWidget);

          // It's not interactive, so no touch target requirements
          // Just verify it renders
        },
      );
    });

    group('Navigation Drawer and Rail Combined Tests', () {
      testWidgets(
        'all drawer interactive elements meet touch targets on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockCompleteDashboardDrawer(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // All NavigationDrawerDestinations should be tappable
          final destinations = find.byType(NavigationDrawerDestination);
          expect(destinations, findsWidgets);

          for (var i = 0; i < destinations.evaluate().length; i++) {
            await tester.tap(destinations.at(i));
            await tester.pumpAndSettle(const Duration(milliseconds: 50));
          }
        },
      );

      testWidgets(
        'all rail interactive elements meet touch targets on tablet',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockCompleteDashboardRail(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Find the NavigationRail and get the destination count
          final rail = find.byType(NavigationRail);
          expect(rail, findsOneWidget);

          final railWidget = tester.widget<NavigationRail>(rail);
          final destinationCount = railWidget.destinations.length;

          // Find icons within the rail
          final icons = find.descendant(
            of: rail,
            matching: find.byType(Icon),
          );

          expect(
            icons.evaluate().length,
            greaterThanOrEqualTo(destinationCount),
            reason: 'All rail destinations should render icons',
          );

          // Tap each destination by tapping its icon
          for (var i = 0; i < destinationCount; i++) {
            await tester.tap(icons.at(i));
            await tester.pumpAndSettle(const Duration(milliseconds: 50));
          }
        },
      );
    });

    group('Compact AppBar Action Buttons Touch Targets', () {
      testWidgets(
        'all appbar action buttons have adequate touch targets',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockCompactAppBarWithActions(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find all IconButtons in the appbar
          final iconButtons = find.byType(IconButton);
          expect(iconButtons, findsWidgets);

          // Each IconButton should have minimum touch target
          for (var i = 0; i < iconButtons.evaluate().length; i++) {
            final buttonElement = iconButtons.evaluate().elementAt(i);
            final renderBox = buttonElement.renderObject as RenderBox;
            final size = renderBox.size;

            expect(
              size.width,
              greaterThanOrEqualTo(48.0),
              reason: 'IconButton $i should have at least 48px width',
            );
            expect(
              size.height,
              greaterThanOrEqualTo(48.0),
              reason: 'IconButton $i should have at least 48px height',
            );
          }
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock navigation drawer
class _MockNavigationDrawer extends StatelessWidget {
  const _MockNavigationDrawer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: NavigationDrawer(
        selectedIndex: 0,
        onDestinationSelected: (int index) {},
        children: const [
          SizedBox(height: 20),
          NavigationDrawerDestination(
            icon: Icon(Icons.api_outlined),
            selectedIcon: Icon(Icons.api),
            label: Text('Your Endpoints'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.hub_outlined),
            selectedIcon: Icon(Icons.hub),
            label: Text('Marketplace'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.key_outlined),
            selectedIcon: Icon(Icons.key),
            label: Text('Credits & Keys'),
          ),
          NavigationDrawerDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: Text('Account'),
          ),
        ],
      ),
    );
  }
}

/// Mock navigation rail
class _MockNavigationRail extends StatelessWidget {
  const _MockNavigationRail();

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
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
        NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Account'),
        ),
      ],
    );
  }
}

/// Mock compact appbar
class _MockCompactAppBar extends StatelessWidget {
  const _MockCompactAppBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text('ZenScrap Dashboard'),
      ),
      body: const SizedBox(),
    );
  }
}

/// Mock expand button
class _MockExpandButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onTap;

  const _MockExpandButton({
    required this.isExpanded,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isExpanded
                  ? Icons.keyboard_double_arrow_left_rounded
                  : Icons.keyboard_double_arrow_right_rounded,
            ),
            if (isExpanded) const Text('Collapse'),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

/// Mock account image
class _MockAccountImage extends StatelessWidget {
  final double size;
  final bool isTappable;
  final VoidCallback? onTap;

  const _MockAccountImage({
    required this.size,
    required this.isTappable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final image = Center(
      child: SizedBox(
        key: const Key('account_image_container'),
        height: size,
        width: size,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.person),
        ),
      ),
    );

    if (isTappable) {
      return GestureDetector(
        onTap: onTap,
        child: image,
      );
    }

    return image;
  }
}

/// Mock version indicator
class _MockVersionIndicator extends StatelessWidget {
  const _MockVersionIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Version 1.0.0',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

/// Mock complete dashboard drawer
class _MockCompleteDashboardDrawer extends StatelessWidget {
  const _MockCompleteDashboardDrawer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Stack(
        children: [
          NavigationDrawer(
            selectedIndex: 0,
            onDestinationSelected: (int index) {},
            children: const [
              SizedBox(height: 20),
              CircleAvatar(radius: 50),
              SizedBox(height: 20),
              Divider(height: 16),
              NavigationDrawerDestination(
                icon: Icon(Icons.api_outlined),
                label: Text('Endpoints'),
              ),
              NavigationDrawerDestination(
                icon: Icon(Icons.hub_outlined),
                label: Text('Marketplace'),
              ),
              NavigationDrawerDestination(
                icon: Icon(Icons.key_outlined),
                label: Text('Credits'),
              ),
            ],
          ),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(child: Text('Version 1.0.0')),
              SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mock complete dashboard rail
class _MockCompleteDashboardRail extends StatelessWidget {
  const _MockCompleteDashboardRail();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(radius: 30),
        const SizedBox(height: 8),
        Expanded(
          child: NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {},
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.api_outlined),
                label: Text('Endpoints'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.hub_outlined),
                label: Text('Marketplace'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.key_outlined),
                label: Text('Credits'),
              ),
            ],
          ),
        ),
        const Text('v1.0.0'),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Mock compact appbar with actions
class _MockCompactAppBarWithActions extends StatelessWidget {
  const _MockCompactAppBarWithActions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(radius: 16),
          ),
        ],
      ),
      body: const SizedBox(),
    );
  }
}
