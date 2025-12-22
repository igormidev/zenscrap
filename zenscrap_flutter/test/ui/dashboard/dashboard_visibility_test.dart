import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Component visibility tests for dashboard at different breakpoints.
///
/// Tests verify that:
/// 1. CompactDashboardAppbar: Only visible on compact (< 600px)
/// 2. NavigationRail: Visible on medium (600-839px) and expanded (>= 840px)
/// 3. NavigationDrawer: Visible on compact (slide-in) or expanded (when toggled)
/// 4. Expand button: Only visible on expanded (>= 840px)
/// 5. Account image: Appears in different locations based on breakpoint
/// 6. Version indicator: Appears in navigation areas
/// 7. Component visibility is consistent across breakpoint edges
void main() {
  group('Dashboard Component Visibility Tests', () {
    late SharedPreferences prefs;
    late VisibilityTestHelper helper;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    setUp(() {
      // Helper is initialized fresh for each test
    });

    group('CompactDashboardAppBar Visibility', () {
      testWidgets(
        'appbar visible at 320px (compact)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'compact'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(
            find.byType(AppBar),
            reason: 'AppBar should be visible in compact mode',
          );
          helper.expectVisible(
            find.byIcon(Icons.menu),
            reason: 'Hamburger menu should be visible in compact mode',
          );
        },
      );

      testWidgets(
        'appbar visible at 375px (compact)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'compact'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(find.byType(AppBar));
          helper.expectVisible(find.byIcon(Icons.menu));
        },
      );

      testWidgets(
        'appbar visible at 599px (just before medium)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'compact'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(
            find.byType(AppBar),
            reason: 'AppBar should still be visible at 599px',
          );
        },
      );

      testWidgets(
        'appbar NOT visible at 600px (medium)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'medium'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectNotVisible(
            find.byIcon(Icons.menu),
            reason: 'Hamburger menu should NOT be visible in medium mode',
          );
        },
      );

      testWidgets(
        'appbar NOT visible at 840px (expanded)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'expanded'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectNotVisible(
            find.byIcon(Icons.menu),
            reason: 'Hamburger menu should NOT be visible in expanded mode',
          );
        },
      );
    });

    group('NavigationRail Visibility', () {
      testWidgets(
        'rail NOT visible at 320px (compact)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'compact'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectNotVisible(
            find.byType(NavigationRail),
            reason: 'NavigationRail should NOT be visible in compact mode',
          );
        },
      );

      testWidgets(
        'rail NOT visible at 599px (just before medium)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'compact'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectNotVisible(
            find.byType(NavigationRail),
            reason: 'NavigationRail should NOT be visible at 599px',
          );
        },
      );

      testWidgets(
        'rail visible at 600px (medium)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'medium'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(
            find.byType(NavigationRail),
            reason: 'NavigationRail should be visible in medium mode',
          );
        },
      );

      testWidgets(
        'rail visible at 700px (medium)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(700, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'medium'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(find.byType(NavigationRail));
        },
      );

      testWidgets(
        'rail visible at 839px (just before expanded)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(839, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'medium'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(
            find.byType(NavigationRail),
            reason: 'NavigationRail should still be visible at 839px',
          );
        },
      );

      testWidgets(
        'rail visible at 840px (expanded)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'expanded',
                navigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(
            find.byType(NavigationRail),
            reason: 'NavigationRail should be visible in expanded mode (rail)',
          );
        },
      );

      testWidgets(
        'rail visible at 1200px (desktop)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'expanded',
                navigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(find.byType(NavigationRail));
        },
      );
    });

    group('NavigationDrawer Visibility', () {
      testWidgets(
        'drawer available (but closed) at 320px (compact)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'compact'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Drawer should be available but not visible initially
          final scaffolds = find.byType(Scaffold);
          expect(scaffolds, findsWidgets);

          // Find the inner scaffold with the drawer
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

          // Drawer not visible until opened
          helper.expectNotVisible(find.byType(NavigationDrawer));
        },
      );

      testWidgets(
        'drawer opens when hamburger menu tapped (compact)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'compact'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Initially, drawer not visible
          helper.expectNotVisible(find.byType(NavigationDrawer));

          // Tap hamburger menu
          await tester.tap(find.byIcon(Icons.menu));
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          // Now drawer should be visible
          helper.expectVisible(
            find.byType(NavigationDrawer),
            reason: 'Drawer should be visible after opening',
          );
        },
      );

      testWidgets(
        'drawer NOT available at 600px (medium - rail only)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'medium'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectNotVisible(find.byType(NavigationDrawer));
        },
      );

      testWidgets(
        'drawer visible at 840px when toggled (expanded)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'expanded',
                navigationType: NavigationType.drawer,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(
            find.byType(NavigationDrawer),
            reason: 'Drawer should be visible when toggled in expanded mode',
          );
        },
      );
    });

    group('Expand Button Visibility', () {
      testWidgets(
        'expand button NOT visible at 320px (compact)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'compact'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectNotVisible(
            find.byKey(const Key('expand_button')),
            reason: 'Expand button should NOT be visible in compact mode',
          );
        },
      );

      testWidgets(
        'expand button NOT visible at 600px (medium)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'medium'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectNotVisible(
            find.byKey(const Key('expand_button')),
            reason: 'Expand button should NOT be visible in medium mode',
          );
        },
      );

      testWidgets(
        'expand button NOT visible at 839px (just before expanded)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(839, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(layoutType: 'medium'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectNotVisible(
            find.byKey(const Key('expand_button')),
            reason: 'Expand button should NOT be visible at 839px',
          );
        },
      );

      testWidgets(
        'expand button visible at 840px (expanded)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'expanded',
                navigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(
            find.byKey(const Key('expand_button')),
            reason: 'Expand button should be visible in expanded mode',
          );
        },
      );

      testWidgets(
        'expand button visible at 1200px (desktop)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'expanded',
                navigationType: NavigationType.rail,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(find.byKey(const Key('expand_button')));
        },
      );

      testWidgets(
        'expand button visible in drawer mode (expanded)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'expanded',
                navigationType: NavigationType.drawer,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(
            find.byKey(const Key('expand_button')),
            reason: 'Expand button should be visible in drawer mode (expanded)',
          );
        },
      );
    });

    group('Account Image Position by Breakpoint', () {
      testWidgets(
        'account image in appbar at 320px (compact)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'compact',
                includeAccountImage: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Account image should be in appbar actions
          final appBar = find.byType(AppBar);
          expect(appBar, findsOneWidget);
          helper.expectVisible(find.byType(CircleAvatar));
        },
      );

      testWidgets(
        'account image in rail at 600px (medium)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'medium',
                includeAccountImage: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Account image should be above rail
          helper.expectVisible(find.byType(CircleAvatar));
          helper.expectVisible(find.byType(NavigationRail));
        },
      );

      testWidgets(
        'account image in rail at 840px (expanded, rail mode)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'expanded',
                navigationType: NavigationType.rail,
                includeAccountImage: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(find.byType(CircleAvatar));
          helper.expectVisible(find.byType(NavigationRail));
        },
      );
    });

    group('Version Indicator Visibility', () {
      testWidgets(
        'version indicator NOT in compact appbar',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'compact',
                includeVersionIndicator: false,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Version indicator should not be in compact appbar
          // It appears in the drawer when opened
          final versionText = find.textContaining('Version');
          helper.expectNotVisible(versionText);
        },
      );

      testWidgets(
        'version indicator in compact drawer when opened',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'compact',
                includeVersionIndicator: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Open drawer
          await tester.tap(find.byIcon(Icons.menu));
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          // Version indicator should be visible in drawer
          final versionText = find.textContaining('Version');
          helper.expectVisible(versionText);
        },
      );

      testWidgets(
        'version indicator in rail at 600px (medium)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'medium',
                includeVersionIndicator: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Version indicator should be visible in rail
          final versionText = find.textContaining('v');
          helper.expectVisible(versionText);
        },
      );

      testWidgets(
        'version indicator in rail at 840px (expanded)',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'expanded',
                navigationType: NavigationType.rail,
                includeVersionIndicator: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final versionText = find.textContaining('v');
          helper.expectVisible(versionText);
        },
      );
    });

    group('Combined Visibility at Breakpoint Edges', () {
      testWidgets(
        'at 599px: compact layout with appbar, no rail, no expand button',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'compact',
                includeAccountImage: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(find.byType(AppBar));
          helper.expectVisible(find.byIcon(Icons.menu));
          helper.expectNotVisible(find.byType(NavigationRail));
          helper.expectNotVisible(find.byKey(const Key('expand_button')));
        },
      );

      testWidgets(
        'at 600px: medium layout with rail, no appbar menu, no expand button',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'medium',
                includeAccountImage: true,
                includeVersionIndicator: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(find.byType(NavigationRail));
          helper.expectNotVisible(find.byIcon(Icons.menu));
          helper.expectNotVisible(find.byKey(const Key('expand_button')));
        },
      );

      testWidgets(
        'at 839px: medium layout with rail, no expand button',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(839, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'medium',
                includeAccountImage: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(find.byType(NavigationRail));
          helper.expectNotVisible(find.byKey(const Key('expand_button')));
        },
      );

      testWidgets(
        'at 840px: expanded layout with rail and expand button',
        (tester) async {
          helper = VisibilityTestHelper(tester);

          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithVisibility(
                layoutType: 'expanded',
                navigationType: NavigationType.rail,
                includeAccountImage: true,
                includeVersionIndicator: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          helper.expectVisible(find.byType(NavigationRail));
          helper.expectVisible(find.byKey(const Key('expand_button')));
          helper.expectNotVisible(find.byIcon(Icons.menu));
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock dashboard with complete visibility controls
class _MockDashboardWithVisibility extends StatelessWidget {
  final String layoutType;
  final NavigationType navigationType;
  final bool includeAccountImage;
  final bool includeVersionIndicator;

  const _MockDashboardWithVisibility({
    required this.layoutType,
    this.navigationType = NavigationType.rail,
    this.includeAccountImage = false,
    this.includeVersionIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return switch (layoutType) {
      'compact' => Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: const Text('Dashboard'),
            actions: [
              if (includeAccountImage)
                const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: CircleAvatar(radius: 16),
                ),
            ],
          ),
          drawer: SizedBox(
            width: 280,
            child: Stack(
              children: [
                NavigationDrawer(
                  selectedIndex: 0,
                  onDestinationSelected: (int index) {},
                  children: const [
                    SizedBox(height: 20),
                    NavigationDrawerDestination(
                      icon: Icon(Icons.api_outlined),
                      label: Text('Endpoints'),
                    ),
                  ],
                ),
                if (includeVersionIndicator)
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Center(child: Text('Version 1.0.0')),
                      SizedBox(height: 16),
                    ],
                  ),
              ],
            ),
          ),
          body: const Center(child: Text('Dashboard Content')),
        ),
      'medium' => Scaffold(
          body: Row(
            children: [
              Column(
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
                          label: Text('Endpoints'),
                        ),
                      ],
                    ),
                  ),
                  if (includeVersionIndicator) const Text('v1.0.0'),
                  if (includeVersionIndicator) const SizedBox(height: 16),
                ],
              ),
              const Expanded(child: Center(child: Text('Dashboard Content'))),
            ],
          ),
        ),
      'expanded' => Scaffold(
          body: Row(
            children: [
              switch (navigationType) {
                NavigationType.rail => Column(
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
                              label: Text('Endpoints'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _MockExpandButton(isExpanded: false),
                      ),
                      const SizedBox(height: 8),
                      if (includeVersionIndicator) const Text('v1.0.0'),
                      if (includeVersionIndicator) const SizedBox(height: 16),
                    ],
                  ),
                NavigationType.drawer => SizedBox(
                    width: 280,
                    child: Stack(
                      children: [
                        NavigationDrawer(
                          selectedIndex: 0,
                          onDestinationSelected: (int index) {},
                          children: const [
                            SizedBox(height: 20),
                            NavigationDrawerDestination(
                              icon: Icon(Icons.api_outlined),
                              label: Text('Endpoints'),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: _MockExpandButton(isExpanded: true),
                            ),
                            const SizedBox(height: 8),
                            if (includeVersionIndicator)
                              const Center(child: Text('Version 1.0.0')),
                            if (includeVersionIndicator) const SizedBox(height: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
              },
              const Expanded(child: Center(child: Text('Dashboard Content'))),
            ],
          ),
        ),
      _ => const Scaffold(body: Center(child: Text('Unknown'))),
    };
  }
}

/// Mock expand button
class _MockExpandButton extends StatelessWidget {
  final bool isExpanded;

  const _MockExpandButton({required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('expand_button'),
      onTap: () {},
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
              isExpanded
                  ? Icons.keyboard_double_arrow_left_rounded
                  : Icons.keyboard_double_arrow_right_rounded,
              size: 20,
            ),
            if (isExpanded) ...[
              const SizedBox(width: 4),
              const Flexible(
                child: Text(
                  'Close',
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
