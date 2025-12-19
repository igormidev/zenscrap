import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive layout switching tests for dashboard components.
///
/// Tests verify that:
/// 1. Compact layout is shown on compact screens (< 600px)
/// 2. Medium layout is shown on medium screens (600-839px)
/// 3. Expanded layout is shown on expanded screens (>= 840px)
/// 4. Layout switches correctly at breakpoint edges (599, 600, 839, 840)
/// 5. Responsive values return correct values at each breakpoint
/// 6. Drawer width is responsive (280px compact, 200px expanded)
/// 7. Account image size is responsive (32px appbar, 60px rail, 100-120px drawer)
/// 8. Pricing page width and aspect ratio are responsive
void main() {
  group('Dashboard Layout Switching Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('ResponsiveBuilder Layout Switching', () {
      testWidgets(
        'shows compact layout at 320px (smallest phone)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('compact_layout')), findsOneWidget);
          expect(find.byKey(const Key('medium_layout')), findsNothing);
          expect(find.byKey(const Key('expanded_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows compact layout at 375px (iPhone)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('compact_layout')), findsOneWidget);
          expect(find.byKey(const Key('medium_layout')), findsNothing);
          expect(find.byKey(const Key('expanded_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows compact layout at 599px (just before medium breakpoint)',
        (tester) async {
          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.byKey(const Key('compact_layout')),
            findsOneWidget,
            reason: '599px should still be compact',
          );
          expect(find.byKey(const Key('medium_layout')), findsNothing);
          expect(find.byKey(const Key('expanded_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows medium layout at 600px (medium breakpoint start)',
        (tester) async {
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('compact_layout')), findsNothing);
          expect(
            find.byKey(const Key('medium_layout')),
            findsOneWidget,
            reason: '600px should show medium layout',
          );
          expect(find.byKey(const Key('expanded_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows medium layout at 700px (mid-medium range)',
        (tester) async {
          await tester.setScreenSize(const Size(700, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('medium_layout')), findsOneWidget);
          expect(find.byKey(const Key('compact_layout')), findsNothing);
          expect(find.byKey(const Key('expanded_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows medium layout at 839px (just before expanded breakpoint)',
        (tester) async {
          await tester.setScreenSize(const Size(839, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.byKey(const Key('medium_layout')),
            findsOneWidget,
            reason: '839px should still be medium',
          );
          expect(find.byKey(const Key('expanded_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows expanded layout at 840px (expanded breakpoint start)',
        (tester) async {
          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('compact_layout')), findsNothing);
          expect(find.byKey(const Key('medium_layout')), findsNothing);
          expect(
            find.byKey(const Key('expanded_layout')),
            findsOneWidget,
            reason: '840px should show expanded layout',
          );
        },
      );

      testWidgets(
        'shows expanded layout at 1200px (desktop)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('expanded_layout')), findsOneWidget);
          expect(find.byKey(const Key('compact_layout')), findsNothing);
          expect(find.byKey(const Key('medium_layout')), findsNothing);
        },
      );
    });

    group('WindowSizeClass Detection', () {
      testWidgets(
        'isCompact returns true for widths < 600',
        (tester) async {
          for (final size in TestDeviceSizes.compactSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                Builder(
                  builder: (context) {
                    return Text(
                      'isCompact: ${context.isCompact}',
                      key: Key('result_${size.width}'),
                    );
                  },
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 100));

            expect(
              find.text('isCompact: true'),
              findsOneWidget,
              reason: 'isCompact should be true at ${size.width}px',
            );
          }
        },
      );

      testWidgets(
        'isMedium returns true for widths 600-839',
        (tester) async {
          final mediumSizes = [
            const Size(600, 800),
            const Size(700, 800),
            const Size(839, 800),
          ];

          for (final size in mediumSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                Builder(
                  builder: (context) {
                    return Text('isMedium: ${context.isMedium}');
                  },
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 100));

            expect(
              find.text('isMedium: true'),
              findsOneWidget,
              reason: 'isMedium should be true at ${size.width}px',
            );
          }
        },
      );

      testWidgets(
        'isExpanded returns true for widths >= 840',
        (tester) async {
          for (final size in TestDeviceSizes.expandedSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                Builder(
                  builder: (context) {
                    return Text('isExpanded: ${context.isExpanded}');
                  },
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 100));

            expect(
              find.text('isExpanded: true'),
              findsOneWidget,
              reason: 'isExpanded should be true at ${size.width}px',
            );
          }
        },
      );
    });

    group('Responsive Value Tests', () {
      testWidgets(
        'returns compact value at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Builder(
                builder: (context) {
                  final padding = context.responsiveValue(
                    compact: 16.0,
                    medium: 20.0,
                    expanded: 24.0,
                  );
                  return Text('padding: $padding');
                },
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          expect(find.text('padding: 16.0'), findsOneWidget);
        },
      );

      testWidgets(
        'returns medium value at 600px',
        (tester) async {
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Builder(
                builder: (context) {
                  final padding = context.responsiveValue(
                    compact: 16.0,
                    medium: 20.0,
                    expanded: 24.0,
                  );
                  return Text('padding: $padding');
                },
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          expect(find.text('padding: 20.0'), findsOneWidget);
        },
      );

      testWidgets(
        'returns expanded value at 1200px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Builder(
                builder: (context) {
                  final padding = context.responsiveValue(
                    compact: 16.0,
                    medium: 20.0,
                    expanded: 24.0,
                  );
                  return Text('padding: $padding');
                },
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          expect(find.text('padding: 24.0'), findsOneWidget);
        },
      );
    });

    group('Drawer Width Responsive Tests', () {
      testWidgets(
        'compact drawer width is 280px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardDrawer(isCompactMode: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('drawer_sized_box')),
          );

          expect(
            sizedBox.width,
            equals(280.0),
            reason: 'Compact drawer should be 280px wide',
          );
        },
      );

      testWidgets(
        'expanded drawer width is 200px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardDrawer(isCompactMode: false),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('drawer_sized_box')),
          );

          expect(
            sizedBox.width,
            equals(200.0),
            reason: 'Expanded drawer should be 200px wide',
          );
        },
      );
    });

    group('Account Image Size Responsive Tests', () {
      testWidgets(
        'account image size is 32px in appbar (compact)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAccountImage(size: 32),
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
        'account image size is 60px in rail (medium/expanded)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAccountImage(size: 60),
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

      testWidgets(
        'account image size is 100px in compact drawer',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAccountImage(size: 100),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('account_image_container')),
          );

          expect(sizedBox.width, equals(100.0));
          expect(sizedBox.height, equals(100.0));
        },
      );

      testWidgets(
        'account image size is 120px in expanded drawer',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAccountImage(size: 120),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('account_image_container')),
          );

          expect(sizedBox.width, equals(120.0));
          expect(sizedBox.height, equals(120.0));
        },
      );
    });

    group('Pricing Page Responsive Tests', () {
      testWidgets(
        'pricing page width is 320px on compact',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockPricingPage(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('pricing_container')),
          );

          expect(
            sizedBox.width,
            equals(320.0),
            reason: 'Pricing page should be 320px wide on compact',
          );
        },
      );

      testWidgets(
        'pricing page width is 600px on medium',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockPricingPage(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('pricing_container')),
          );

          expect(
            sizedBox.width,
            equals(600.0),
            reason: 'Pricing page should be 600px wide on medium',
          );
        },
      );

      testWidgets(
        'pricing page width is 865px on expanded',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockPricingPage(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('pricing_container')),
          );

          expect(
            sizedBox.width,
            equals(865.0),
            reason: 'Pricing page should be 865px wide on expanded',
          );
        },
      );

      testWidgets(
        'pricing page aspect ratio is responsive',
        (tester) async {
          // Test compact aspect ratio
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockPricingPage(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          var aspectRatio = tester.widget<AspectRatio>(
            find.byKey(const Key('pricing_aspect_ratio')),
          );
          expect(aspectRatio.aspectRatio, equals(0.38));

          // Test medium aspect ratio
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockPricingPage(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          aspectRatio = tester.widget<AspectRatio>(
            find.byKey(const Key('pricing_aspect_ratio')),
          );
          expect(aspectRatio.aspectRatio, equals(0.42));

          // Test expanded aspect ratio
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockPricingPage(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          aspectRatio = tester.widget<AspectRatio>(
            find.byKey(const Key('pricing_aspect_ratio')),
          );
          expect(aspectRatio.aspectRatio, equals(0.45));
        },
      );
    });

    group('Dashboard Layout Component Visibility', () {
      testWidgets(
        'compact layout shows appbar and drawer, no rail',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardComplete(layoutType: 'compact'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(find.byType(AppBar), findsOneWidget);
          expect(find.byIcon(Icons.menu), findsOneWidget);
          expect(find.byType(NavigationRail), findsNothing);
        },
      );

      testWidgets(
        'medium layout shows rail, no appbar with menu',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardComplete(layoutType: 'medium'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(find.byType(NavigationRail), findsOneWidget);
          expect(find.byIcon(Icons.menu), findsNothing);
        },
      );

      testWidgets(
        'expanded layout shows rail with expand button',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardComplete(layoutType: 'expanded'),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(find.byType(NavigationRail), findsOneWidget);
          expect(find.byIcon(Icons.menu), findsNothing);
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock dashboard with three layouts
class _MockDashboardWithLayouts extends StatelessWidget {
  const _MockDashboardWithLayouts();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      compact: (context, constraints) => Container(
        key: const Key('compact_layout'),
        child: const Text('Compact Layout'),
      ),
      medium: (context, constraints) => Container(
        key: const Key('medium_layout'),
        child: const Text('Medium Layout'),
      ),
      expanded: (context, constraints) => Container(
        key: const Key('expanded_layout'),
        child: const Text('Expanded Layout'),
      ),
    );
  }
}

/// Mock dashboard drawer with responsive width
class _MockDashboardDrawer extends StatelessWidget {
  final bool isCompactMode;

  const _MockDashboardDrawer({required this.isCompactMode});

  @override
  Widget build(BuildContext context) {
    final drawerWidth = isCompactMode ? 280.0 : 200.0;

    return SizedBox(
      key: const Key('drawer_sized_box'),
      width: drawerWidth,
      child: NavigationDrawer(
        selectedIndex: 0,
        children: [
          const SizedBox(height: 20),
          NavigationDrawerDestination(
            icon: const Icon(Icons.api_outlined),
            label: Text(isCompactMode ? 'Endpoints' : 'API'),
          ),
        ],
      ),
    );
  }
}

/// Mock account image with specific size
class _MockAccountImage extends StatelessWidget {
  final double size;

  const _MockAccountImage({required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
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
  }
}

/// Mock pricing page with responsive width and aspect ratio
class _MockPricingPage extends StatelessWidget {
  const _MockPricingPage();

  @override
  Widget build(BuildContext context) {
    final pricingWidth = context.responsiveValue<double>(
      compact: 320,
      medium: 600,
      expanded: 865,
    );

    final pricingAspectRatio = context.responsiveValue<double>(
      compact: 0.38,
      medium: 0.42,
      expanded: 0.45,
    );

    return Center(
      child: SizedBox(
        key: const Key('pricing_container'),
        width: pricingWidth,
        child: AspectRatio(
          key: const Key('pricing_aspect_ratio'),
          aspectRatio: pricingAspectRatio,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('Pricing Plans'),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mock complete dashboard layout
class _MockDashboardComplete extends StatelessWidget {
  final String layoutType;

  const _MockDashboardComplete({required this.layoutType});

  @override
  Widget build(BuildContext context) {
    return switch (layoutType) {
      'compact' => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
            title: const Text('Dashboard'),
          ),
          body: const Center(child: Text('Content')),
        ),
      'medium' => Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: 0,
                onDestinationSelected: (int index) {},
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.api_outlined),
                    label: Text('Endpoints'),
                  ),
                ],
              ),
              const Expanded(child: Center(child: Text('Content'))),
            ],
          ),
        ),
      'expanded' => Scaffold(
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: 0,
                onDestinationSelected: (int index) {},
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.api_outlined),
                    label: Text('Endpoints'),
                  ),
                ],
              ),
              const Expanded(child: Center(child: Text('Content'))),
            ],
          ),
        ),
      _ => const Scaffold(body: Center(child: Text('Unknown'))),
    };
  }
}
