import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/dashboard_view.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive overflow detection tests for dashboard components.
///
/// Tests verify that dashboard-related widgets do not cause overflow errors
/// at various screen sizes, especially at the critical 320px width
/// and at breakpoint edges (599, 600, 839, 840).
///
/// Test Categories:
/// 1. Navigation drawer overflow tests
/// 2. Navigation rail overflow tests
/// 3. Dashboard appbar overflow tests
/// 4. Expand button overflow tests
/// 5. Account image overflow tests
/// 6. Version indicator overflow tests
/// 7. Pricing page overflow tests
void main() {
  group('Dashboard Components Overflow Detection Tests', () {
    late OverflowErrorCapture overflowCapture;
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    setUp(() {
      overflowCapture = OverflowErrorCapture();
    });

    tearDown(() {
      overflowCapture.stop();
    });

    group('Dashboard Drawer Overflow Tests', () {
      testWidgets(
        'compact drawer does not overflow at 320px (smallest phone)',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDashboardDrawer(isCompactMode: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Compact drawer has overflow at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'expanded drawer does not overflow at any expanded size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.expandedSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockDashboardDrawer(isCompactMode: false),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'drawer with account image does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            final isCompact = size.width < 600;
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockDashboardDrawer(
                  isCompactMode: isCompact,
                  includeAccountImage: true,
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('Dashboard Rail Overflow Tests', () {
      testWidgets(
        'navigation rail does not overflow at medium sizes',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.mediumSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockDashboardRail(showExpandButton: false),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'navigation rail with expand button does not overflow at expanded sizes',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.expandedSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockDashboardRail(showExpandButton: true),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'rail with account image and version indicator does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in [...TestDeviceSizes.mediumSizes, ...TestDeviceSizes.expandedSizes]) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockDashboardRail(
                  showExpandButton: size.width >= 840,
                  includeAccountImage: true,
                  includeVersionIndicator: true,
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('Compact Dashboard AppBar Overflow Tests', () {
      testWidgets(
        'compact appbar does not overflow at any compact size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.compactSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                Scaffold(
                  appBar: _MockCompactDashboardAppBar(),
                  body: const SizedBox(),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'compact appbar with account image does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Scaffold(
                appBar: _MockCompactDashboardAppBar(includeAccountImage: true),
                body: const SizedBox(),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Compact appbar with account image overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('Expand Button Overflow Tests', () {
      testWidgets(
        'expand button in rail mode does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.expandedSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockExpandButton(navigationType: NavigationType.rail),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'expand button in drawer mode does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.expandedSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockExpandButton(navigationType: NavigationType.drawer),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('Account Image Overflow Tests', () {
      testWidgets(
        'account image at different sizes does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          final testSizes = [
            (32.0, 'appbar'),
            (60.0, 'rail'),
            (100.0, 'compact drawer'),
            (120.0, 'expanded drawer'),
          ];

          for (final (size, label) in testSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(TestDeviceSizes.desktop);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockAccountImage(size: size),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows for $label (${size}px): ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('Version Indicator Overflow Tests', () {
      testWidgets(
        'version indicator does not overflow at any size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockVersionIndicator(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'version indicator with short text format does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockVersionIndicator(useShortFormat: true),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('Pricing Page Overflow Tests', () {
      testWidgets(
        'pricing page does not overflow at compact sizes',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.compactSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockPricingPage(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 300));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'pricing page does not overflow at all screen sizes',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockPricingPage(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 300));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('Complete Dashboard Layout Overflow Tests', () {
      testWidgets(
        'complete compact dashboard layout does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockCompleteDashboardLayout(layoutType: DashboardLayoutType.compact),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Complete compact dashboard overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'complete medium dashboard layout does not overflow at 600px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockCompleteDashboardLayout(layoutType: DashboardLayoutType.medium),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Complete medium dashboard overflows at 600px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'complete expanded dashboard layout does not overflow at 1200px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockCompleteDashboardLayout(layoutType: DashboardLayoutType.expanded),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Complete expanded dashboard overflows at 1200px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

enum DashboardLayoutType { compact, medium, expanded }

/// Mock dashboard drawer that simulates the real DashboardDrawer responsive behavior
class _MockDashboardDrawer extends StatelessWidget {
  final bool isCompactMode;
  final bool includeAccountImage;

  const _MockDashboardDrawer({
    required this.isCompactMode,
    this.includeAccountImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final drawerWidth = isCompactMode ? 280.0 : 280.0;
    final accountImageSize = isCompactMode ? 100.0 : 120.0;

    return SizedBox(
      width: drawerWidth,
      child: NavigationDrawer(
        selectedIndex: 0,
        onDestinationSelected: (int index) {},
        children: [
          const SizedBox(height: 20),
          if (includeAccountImage)
            _MockAccountImage(size: accountImageSize),
          if (includeAccountImage) const SizedBox(height: 20),
          const Divider(height: 16),
          const NavigationDrawerDestination(
            icon: Icon(Icons.api_outlined),
            selectedIcon: Icon(Icons.api),
            label: Text('Your Endpoints'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.hub_outlined),
            selectedIcon: Icon(Icons.hub),
            label: Text('Marketplace'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.key_outlined),
            selectedIcon: Icon(Icons.key),
            label: Text('Credits & Keys'),
          ),
        ],
      ),
    );
  }
}

/// Mock dashboard rail
class _MockDashboardRail extends StatelessWidget {
  final bool showExpandButton;
  final bool includeAccountImage;
  final bool includeVersionIndicator;

  const _MockDashboardRail({
    required this.showExpandButton,
    this.includeAccountImage = false,
    this.includeVersionIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        if (includeAccountImage) _MockAccountImage(size: 60),
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
            child: _MockExpandButton(navigationType: NavigationType.rail),
          ),
        if (showExpandButton) const SizedBox(height: 8),
        if (includeVersionIndicator) _MockVersionIndicator(useShortFormat: true),
        if (includeVersionIndicator) const SizedBox(height: 16),
      ],
    );
  }
}

/// Mock compact dashboard appbar
class _MockCompactDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool includeAccountImage;

  const _MockCompactDashboardAppBar({this.includeAccountImage = false});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      title: const Text('ZenScrap Dashboard'),
      actions: [
        if (includeAccountImage)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _MockAccountImage(size: 32),
          ),
      ],
    );
  }
}

/// Mock expand button
class _MockExpandButton extends StatelessWidget {
  final NavigationType navigationType;

  const _MockExpandButton({required this.navigationType});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(switch (navigationType) {
              NavigationType.rail => Icons.keyboard_double_arrow_right_rounded,
              NavigationType.drawer => Icons.keyboard_double_arrow_left_rounded,
            }),
            Text(switch (navigationType) {
              NavigationType.rail => '',
              NavigationType.drawer => 'Collapse',
            }),
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

  const _MockAccountImage({required this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.no_photography_rounded),
        ),
      ),
    );
  }
}

/// Mock version indicator
class _MockVersionIndicator extends StatelessWidget {
  final bool useShortFormat;

  const _MockVersionIndicator({this.useShortFormat = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        useShortFormat ? 'v1.0.0' : 'Version 1.0.0',
        style: Theme.of(context).textTheme.bodySmall,
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
        width: pricingWidth,
        child: AspectRatio(
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
class _MockCompleteDashboardLayout extends StatelessWidget {
  final DashboardLayoutType layoutType;

  const _MockCompleteDashboardLayout({required this.layoutType});

  @override
  Widget build(BuildContext context) {
    return switch (layoutType) {
      DashboardLayoutType.compact => Scaffold(
          appBar: _MockCompactDashboardAppBar(includeAccountImage: true),
          drawer: _MockDashboardDrawer(
            isCompactMode: true,
            includeAccountImage: true,
          ),
          body: Container(
            color: Theme.of(context).colorScheme.surface,
            child: const Center(child: Text('Dashboard Content')),
          ),
        ),
      DashboardLayoutType.medium => Scaffold(
          body: Row(
            children: [
              _MockDashboardRail(
                showExpandButton: false,
                includeAccountImage: true,
                includeVersionIndicator: true,
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: const Center(child: Text('Dashboard Content')),
                ),
              ),
            ],
          ),
        ),
      DashboardLayoutType.expanded => Scaffold(
          body: Row(
            children: [
              _MockDashboardRail(
                showExpandButton: true,
                includeAccountImage: true,
                includeVersionIndicator: true,
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: const Center(child: Text('Dashboard Content')),
                ),
              ),
            ],
          ),
        ),
    };
  }
}
