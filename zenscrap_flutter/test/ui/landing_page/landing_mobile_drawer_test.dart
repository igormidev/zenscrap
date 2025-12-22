import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/widgets/landing_appbar.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/widgets/landing_mobile_drawer.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Tests for the LandingMobileDrawer navigation component.
///
/// These tests verify that the mobile drawer:
/// - Contains all required navigation items
/// - Handles user interactions correctly
/// - Displays proper UI elements
void main() {
  group('LandingMobileDrawer Navigation Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    Widget buildDrawerTestWidget({
      LandingSection activeSection = LandingSection.createScrappable,
      void Function(LandingSection)? onSectionTap,
      VoidCallback? onSignInTap,
    }) {
      return responsiveTestWrapper(
        sharedPreferences: prefs,
        Builder(
          builder: (context) => Scaffold(
            endDrawer: LandingMobileDrawer(
              activeSection: activeSection,
              onSectionTap: onSectionTap ?? (_) {},
              onSignInTap: onSignInTap ?? () {},
            ),
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                child: const Text('Open Drawer'),
              ),
            ),
          ),
        ),
      );
    }

    group('Drawer structure tests', () {
      testWidgets('contains all navigation items', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(buildDrawerTestWidget());
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Verify all navigation sections are present
        final drawerContext =
            tester.element(find.byType(LandingMobileDrawer));
        for (final section in LandingSection.values) {
          final label = section.getLabel(drawerContext);
          expect(
            find.text(label),
            findsOneWidget,
            reason: 'Should find navigation item for ${section.name}',
          );
        }
      });

      testWidgets('contains logo in header', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(buildDrawerTestWidget());
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Logo icon should be present
        expect(
          find.byIcon(Icons.auto_awesome_rounded),
          findsOneWidget,
          reason: 'Should find logo icon in drawer header',
        );
      });

      testWidgets('contains sign in button', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.largePhone);
        await tester.pumpWidget(buildDrawerTestWidget());
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Scroll to ensure sign in button is visible
        final listView = find.byType(ListView);
        if (listView.evaluate().isNotEmpty) {
          await tester.drag(listView, const Offset(0, -100));
          await tester.pumpAndSettle();
        }

        // Should find login icon (inside FilledButton)
        expect(
          find.byIcon(Icons.login_rounded),
          findsOneWidget,
          reason: 'Should find login icon',
        );
      });

      testWidgets('contains language selector', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(buildDrawerTestWidget());
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Should find language icon
        expect(
          find.byIcon(Icons.language_rounded),
          findsOneWidget,
          reason: 'Should find language icon',
        );
      });
    });

    group('Navigation item icons tests', () {
      testWidgets('each section has appropriate icon', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(buildDrawerTestWidget());
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Check for each section's icon
        expect(
          find.byIcon(Icons.add_circle_outline_rounded),
          findsOneWidget,
          reason: 'Should find createScrappable icon',
        );
        expect(
          find.byIcon(Icons.help_outline_rounded),
          findsOneWidget,
          reason: 'Should find howItWorks icon',
        );
        expect(
          find.byIcon(Icons.auto_fix_high_rounded),
          findsOneWidget,
          reason: 'Should find autoFix icon',
        );
        expect(
          find.byIcon(Icons.star_outline_rounded),
          findsOneWidget,
          reason: 'Should find features icon',
        );
        expect(
          find.byIcon(Icons.store_outlined),
          findsOneWidget,
          reason: 'Should find marketplace icon',
        );
        expect(
          find.byIcon(Icons.payments_outlined),
          findsOneWidget,
          reason: 'Should find pricing icon',
        );
      });
    });

    group('Active section highlighting tests', () {
      testWidgets('highlights active section correctly', (tester) async {
        for (final activeSection in LandingSection.values) {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            buildDrawerTestWidget(activeSection: activeSection),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Open the drawer
          await tester.tap(find.text('Open Drawer'));
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Find all ListTiles
          final listTiles =
              tester.widgetList<ListTile>(find.byType(ListTile));

          // Verify one is selected
          final selectedTiles = listTiles.where(
            (tile) => tile.selected == true,
          );
          expect(
            selectedTiles.length,
            1,
            reason:
                'Should have exactly one selected ListTile for ${activeSection.name}',
          );

          // Close drawer by tapping outside
          await tester.tapAt(const Offset(10, 10));
          await tester.pumpAndSettle(const Duration(milliseconds: 300));
        }
      });
    });

    group('Navigation callback tests', () {
      testWidgets('calls onSectionTap when navigation item is tapped',
          (tester) async {
        LandingSection? tappedSection;

        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(
          buildDrawerTestWidget(
            onSectionTap: (section) {
              tappedSection = section;
            },
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Tap on "How It Works" section
        final context = tester.element(find.byType(LandingMobileDrawer));
        final howItWorksLabel = LandingSection.howItWorks.getLabel(context);
        await tester.tap(find.text(howItWorksLabel));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        expect(tappedSection, LandingSection.howItWorks);
      });

      testWidgets('closes drawer after navigation item tap', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(buildDrawerTestWidget());
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Verify drawer is open
        expect(find.byType(Drawer), findsOneWidget);

        // Tap on a navigation item
        final context = tester.element(find.byType(LandingMobileDrawer));
        final featuresLabel = LandingSection.features.getLabel(context);
        await tester.tap(find.text(featuresLabel));
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Drawer should be closed (not visible)
        expect(
          find.byType(LandingMobileDrawer).evaluate().isEmpty,
          isTrue,
          reason: 'Drawer should close after navigation tap',
        );
      });

      testWidgets('calls onSignInTap when sign in button is tapped',
          (tester) async {
        bool signInTapped = false;

        await tester.setScreenSize(TestDeviceSizes.largePhone);
        await tester.pumpWidget(
          buildDrawerTestWidget(
            onSignInTap: () {
              signInTapped = true;
            },
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        // Scroll to ensure sign in button is visible
        final listView = find.byType(ListView);
        if (listView.evaluate().isNotEmpty) {
          await tester.drag(listView, const Offset(0, -100));
          await tester.pumpAndSettle();
        }

        // Tap sign in button by finding its icon
        await tester.tap(find.byIcon(Icons.login_rounded));
        await tester.pump();

        // Clear the GoRouter exception that occurs after onSignInTap is called
        // The callback is invoked before context.push('/auth') which throws
        final exception = tester.takeException();
        expect(exception, isNotNull); // GoRouter error expected

        expect(signInTapped, isTrue);
      });
    });

    group('Drawer rendering on different compact sizes', () {
      testWidgets('renders correctly on small phone (320px)', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.smallPhone);
        await tester.pumpWidget(buildDrawerTestWidget());
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Drawer should render
        expect(find.byType(Drawer), findsOneWidget);
        expect(find.byType(LandingMobileDrawer), findsOneWidget);
      });

      testWidgets('renders correctly on large phone (428px)', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.largePhone);
        await tester.pumpWidget(
          buildDrawerTestWidget(activeSection: LandingSection.marketplace),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Drawer should render
        expect(find.byType(Drawer), findsOneWidget);
        expect(find.byType(LandingMobileDrawer), findsOneWidget);

        // All sections should be visible
        final drawerContext =
            tester.element(find.byType(LandingMobileDrawer));
        for (final section in LandingSection.values) {
          final label = section.getLabel(drawerContext);
          expect(find.text(label), findsOneWidget);
        }
      });
    });

    group('Drawer ListView scrolling', () {
      testWidgets('navigation items are in a scrollable ListView',
          (tester) async {
        await tester.setScreenSize(TestDeviceSizes.smallPhone);
        await tester.pumpWidget(buildDrawerTestWidget());
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Should have ListView for navigation items
        expect(find.byType(ListView), findsOneWidget);
      });
    });

    group('SafeArea usage', () {
      testWidgets('drawer content is wrapped in SafeArea', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(buildDrawerTestWidget());
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Open the drawer
        await tester.tap(find.text('Open Drawer'));
        await tester.pumpAndSettle(const Duration(milliseconds: 300));

        // Should have SafeArea (may be multiple due to nested widgets)
        expect(find.byType(SafeArea), findsWidgets);
      });
    });
  });
}
