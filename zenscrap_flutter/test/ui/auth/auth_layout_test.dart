import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive layout switching tests for auth components.
///
/// Tests verify that:
/// 1. Mobile layout is shown on compact screens (< 600px)
/// 2. Desktop layout is shown on expanded screens (>= 840px)
/// 3. Layout switches correctly at breakpoint edges (599, 600, 839, 840)
/// 4. Medium breakpoint (600-839) uses appropriate layout
void main() {
  group('Auth Layout Switching Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('ResponsiveBuilder Layout Switching', () {
      testWidgets(
        'shows compact layout at 599px (just before medium breakpoint)',
        (tester) async {
          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthViewWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('mobile_layout')), findsOneWidget);
          expect(find.byKey(const Key('desktop_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows medium layout at 600px (medium breakpoint start)',
        (tester) async {
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthViewWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // At medium, we expect medium or mobile layout (medium falls back to compact)
          expect(
            find.byKey(const Key('medium_layout')),
            findsOneWidget,
            reason: 'Should show medium layout at 600px',
          );
          expect(find.byKey(const Key('desktop_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows medium layout at 839px (just before expanded breakpoint)',
        (tester) async {
          await tester.setScreenSize(const Size(839, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthViewWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('medium_layout')), findsOneWidget);
          expect(find.byKey(const Key('desktop_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows desktop layout at 840px (expanded breakpoint start)',
        (tester) async {
          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthViewWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('mobile_layout')), findsNothing);
          expect(find.byKey(const Key('medium_layout')), findsNothing);
          expect(find.byKey(const Key('desktop_layout')), findsOneWidget);
        },
      );

      testWidgets(
        'shows desktop layout at 1200px (desktop size)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthViewWithLayouts(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('desktop_layout')), findsOneWidget);
          expect(find.byKey(const Key('mobile_layout')), findsNothing);
        },
      );
    });

    group('Compact/Expanded Two-Layout Pattern', () {
      testWidgets(
        'shows mobile layout at all compact sizes',
        (tester) async {
          for (final size in TestDeviceSizes.compactSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockTwoLayoutAuthView(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            expect(
              find.byKey(const Key('mobile_auth_layout')),
              findsOneWidget,
              reason: 'Should show mobile layout at ${TestDeviceSizes.nameFor(size)}',
            );
            expect(find.byKey(const Key('desktop_auth_layout')), findsNothing);
          }
        },
      );

      testWidgets(
        'shows desktop layout at all expanded sizes',
        (tester) async {
          for (final size in TestDeviceSizes.expandedSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockTwoLayoutAuthView(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            expect(
              find.byKey(const Key('desktop_auth_layout')),
              findsOneWidget,
              reason: 'Should show desktop layout at ${TestDeviceSizes.nameFor(size)}',
            );
            expect(find.byKey(const Key('mobile_auth_layout')), findsNothing);
          }
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
          await tester.setScreenSize(const Size(700, 800));
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

          expect(find.text('isMedium: true'), findsOneWidget);
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
        'returns medium value at 700px',
        (tester) async {
          await tester.setScreenSize(const Size(700, 800));
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

      testWidgets(
        'falls back to compact when medium is not provided',
        (tester) async {
          await tester.setScreenSize(const Size(700, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Builder(
                builder: (context) {
                  final padding = context.responsiveValue(
                    compact: 16.0,
                    expanded: 24.0,
                  );
                  return Text('padding: $padding');
                },
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          // Should fall back to compact value when medium not provided
          expect(find.text('padding: 16.0'), findsOneWidget);
        },
      );
    });

    group('Auth Form Layout Switching', () {
      testWidgets(
        'form uses responsive padding at different sizes',
        (tester) async {
          // Test at compact size
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthFormWithResponsivePadding(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the Padding widget
          final compactPadding = tester.widget<Padding>(
            find.byKey(const Key('form_padding')),
          );
          expect(
            (compactPadding.padding as EdgeInsets).horizontal,
            equals(32.0), // 16.0 * 2
            reason: 'Compact padding should be 16px horizontal',
          );

          // Test at expanded size
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthFormWithResponsivePadding(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final expandedPadding = tester.widget<Padding>(
            find.byKey(const Key('form_padding')),
          );
          expect(
            (expandedPadding.padding as EdgeInsets).horizontal,
            equals(48.0), // 24.0 * 2
            reason: 'Expanded padding should be 24px horizontal',
          );
        },
      );

      testWidgets(
        'form button height is responsive',
        (tester) async {
          // Test at compact size
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthButtonWithResponsiveHeight(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final compactButton = tester.widget<SizedBox>(
            find.byKey(const Key('button_container')),
          );
          expect(
            compactButton.height,
            equals(52.0),
            reason: 'Compact button height should be 52px',
          );

          // Test at expanded size
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthButtonWithResponsiveHeight(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final expandedButton = tester.widget<SizedBox>(
            find.byKey(const Key('button_container')),
          );
          expect(
            expandedButton.height,
            equals(48.0),
            reason: 'Expanded button height should be 48px',
          );
        },
      );
    });

    group('Splash View Layout', () {
      testWidgets(
        'splash indicator size is responsive',
        (tester) async {
          // Test at compact size
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockSplashViewWithResponsiveIndicator(),
            ),
          );
          await tester.pump(const Duration(milliseconds: 100));

          final compactIndicator = tester.widget<SizedBox>(
            find.byKey(const Key('indicator_container')),
          );
          expect(
            compactIndicator.width,
            equals(36.0),
            reason: 'Compact indicator should be 36px',
          );

          // Test at expanded size
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockSplashViewWithResponsiveIndicator(),
            ),
          );
          await tester.pump(const Duration(milliseconds: 100));

          final expandedIndicator = tester.widget<SizedBox>(
            find.byKey(const Key('indicator_container')),
          );
          expect(
            expandedIndicator.width,
            equals(48.0),
            reason: 'Expanded indicator should be 48px',
          );
        },
      );
    });

    group('Legal Links Layout', () {
      testWidgets(
        'legal links positioning is responsive',
        (tester) async {
          // Test at compact size
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Stack(
                children: [
                  const SizedBox.expand(),
                  _MockLegalLinksWithResponsivePosition(),
                ],
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final compactPositioned = tester.widget<Positioned>(
            find.byKey(const Key('legal_links_positioned')),
          );
          expect(
            compactPositioned.bottom,
            equals(8.0),
            reason: 'Compact bottom position should be 8px',
          );
          expect(
            compactPositioned.right,
            equals(8.0),
            reason: 'Compact right position should be 8px',
          );

          // Test at expanded size
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Stack(
                children: [
                  const SizedBox.expand(),
                  _MockLegalLinksWithResponsivePosition(),
                ],
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final expandedPositioned = tester.widget<Positioned>(
            find.byKey(const Key('legal_links_positioned')),
          );
          expect(
            expandedPositioned.bottom,
            equals(16.0),
            reason: 'Expanded bottom position should be 16px',
          );
          expect(
            expandedPositioned.right,
            equals(16.0),
            reason: 'Expanded right position should be 16px',
          );
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock auth view with three layouts (compact, medium, expanded)
class _MockAuthViewWithLayouts extends StatelessWidget {
  const _MockAuthViewWithLayouts();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      compact: (context, constraints) => Container(
        key: const Key('mobile_layout'),
        child: const Text('Mobile Layout'),
      ),
      medium: (context, constraints) => Container(
        key: const Key('medium_layout'),
        child: const Text('Medium Layout'),
      ),
      expanded: (context, constraints) => Container(
        key: const Key('desktop_layout'),
        child: const Text('Desktop Layout'),
      ),
    );
  }
}

/// Mock auth view with two layouts (mobile/desktop) like the real auth_view.dart
class _MockTwoLayoutAuthView extends StatelessWidget {
  const _MockTwoLayoutAuthView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ResponsiveBuilder(
        compact: (context, constraints) => Container(
          key: const Key('mobile_auth_layout'),
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: 160,
                color: Colors.grey[200],
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Mobile Auth Form'),
                ),
              ),
            ],
          ),
        ),
        expanded: (context, constraints) => Container(
          key: const Key('desktop_auth_layout'),
          constraints: const BoxConstraints(maxWidth: 1400),
          child: Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Desktop Auth Form'),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: const Center(child: Text('Animation')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mock auth form with responsive padding
class _MockAuthFormWithResponsivePadding extends StatelessWidget {
  const _MockAuthFormWithResponsivePadding();

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('form_padding'),
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 24.0,
        ),
      ),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock auth button with responsive height
class _MockAuthButtonWithResponsiveHeight extends StatelessWidget {
  const _MockAuthButtonWithResponsiveHeight();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        key: const Key('button_container'),
        width: double.infinity,
        height: context.responsiveValue(
          compact: 52.0,
          expanded: 48.0,
        ),
        child: FilledButton(
          onPressed: () {},
          child: const Text('Submit'),
        ),
      ),
    );
  }
}

/// Mock splash view with responsive indicator size
class _MockSplashViewWithResponsiveIndicator extends StatelessWidget {
  const _MockSplashViewWithResponsiveIndicator();

  @override
  Widget build(BuildContext context) {
    final indicatorSize = context.responsiveValue(
      compact: 36.0,
      expanded: 48.0,
    );

    return Scaffold(
      body: Center(
        child: SizedBox(
          key: const Key('indicator_container'),
          width: indicatorSize,
          height: indicatorSize,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}

/// Mock legal links with responsive positioning
class _MockLegalLinksWithResponsivePosition extends StatelessWidget {
  const _MockLegalLinksWithResponsivePosition();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      key: const Key('legal_links_positioned'),
      bottom: context.responsiveValue(compact: 8.0, expanded: 16.0),
      right: context.responsiveValue(compact: 8.0, expanded: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text('Terms'),
          ),
          SizedBox(
            width: context.responsiveValue(compact: 12.0, expanded: 16.0),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Privacy'),
          ),
        ],
      ),
    );
  }
}
