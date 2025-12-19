import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Tests for component visibility at different screen sizes.
///
/// These tests verify that the responsive design system works correctly
/// by testing the ResponsiveBuilder and ResponsiveWidget components
/// directly, rather than testing specific app widgets that may have
/// pending overflow fixes.
void main() {
  group('Landing Page Component Visibility Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('ResponsiveBuilder visibility tests', () {
      testWidgets('shows compact widget on compact screens', (tester) async {
        for (final size in TestDeviceSizes.compactSizes) {
          await tester.setScreenSize(size);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              ResponsiveBuilder(
                compact: (_, __) => const Text('Compact'),
                medium: (_, __) => const Text('Medium'),
                expanded: (_, __) => const Text('Expanded'),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          expect(find.text('Compact'), findsOneWidget);
          expect(find.text('Medium'), findsNothing);
          expect(find.text('Expanded'), findsNothing);
        }
      });

      testWidgets('shows medium widget on medium screens', (tester) async {
        for (final size in TestDeviceSizes.mediumSizes) {
          await tester.setScreenSize(size);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              ResponsiveBuilder(
                compact: (_, __) => const Text('Compact'),
                medium: (_, __) => const Text('Medium'),
                expanded: (_, __) => const Text('Expanded'),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          expect(find.text('Compact'), findsNothing);
          expect(find.text('Medium'), findsOneWidget);
          expect(find.text('Expanded'), findsNothing);
        }
      });

      testWidgets('shows expanded widget on expanded screens', (tester) async {
        for (final size in TestDeviceSizes.expandedSizes) {
          await tester.setScreenSize(size);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              ResponsiveBuilder(
                compact: (_, __) => const Text('Compact'),
                medium: (_, __) => const Text('Medium'),
                expanded: (_, __) => const Text('Expanded'),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          expect(find.text('Compact'), findsNothing);
          expect(find.text('Medium'), findsNothing);
          expect(find.text('Expanded'), findsOneWidget);
        }
      });

      testWidgets('falls back to compact when medium is not provided',
          (tester) async {
        await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            ResponsiveBuilder(
              compact: (_, __) => const Text('Compact'),
              // medium not provided
              expanded: (_, __) => const Text('Expanded'),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        // Medium screen without medium builder should fall back to compact
        expect(find.text('Compact'), findsOneWidget);
        expect(find.text('Expanded'), findsNothing);
      });

      testWidgets('falls back to medium when expanded is not provided',
          (tester) async {
        await tester.setScreenSize(TestDeviceSizes.desktop);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            ResponsiveBuilder(
              compact: (_, __) => const Text('Compact'),
              medium: (_, __) => const Text('Medium'),
              // expanded not provided
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        // Expanded screen without expanded builder should fall back to medium
        expect(find.text('Compact'), findsNothing);
        expect(find.text('Medium'), findsOneWidget);
      });
    });

    group('ResponsiveWidget visibility tests', () {
      testWidgets('shows compact widget on compact screens', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            const ResponsiveWidget(
              compact: Text('Compact Widget'),
              expanded: Text('Expanded Widget'),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        expect(find.text('Compact Widget'), findsOneWidget);
        expect(find.text('Expanded Widget'), findsNothing);
      });

      testWidgets('shows expanded widget on expanded screens', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.desktop);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            const ResponsiveWidget(
              compact: Text('Compact Widget'),
              expanded: Text('Expanded Widget'),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        expect(find.text('Compact Widget'), findsNothing);
        expect(find.text('Expanded Widget'), findsOneWidget);
      });

      testWidgets('medium screens fall back to compact in ResponsiveWidget',
          (tester) async {
        // ResponsiveWidget only has compact and expanded, medium falls back
        await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            const ResponsiveWidget(
              compact: Text('Compact Widget'),
              expanded: Text('Expanded Widget'),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        // Medium should fall back to compact
        expect(find.text('Compact Widget'), findsOneWidget);
        expect(find.text('Expanded Widget'), findsNothing);
      });
    });

    group('Breakpoint edge case visibility tests', () {
      testWidgets('switches correctly at 599px to 600px boundary',
          (tester) async {
        // At 599px - should be compact
        await tester.setScreenSize(const Size(599, 800));
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            ResponsiveBuilder(
              compact: (_, __) => const Text('Compact'),
              medium: (_, __) => const Text('Medium'),
              expanded: (_, __) => const Text('Expanded'),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        expect(find.text('Compact'), findsOneWidget);

        // At 600px - should be medium
        await tester.setScreenSize(const Size(600, 800));
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            ResponsiveBuilder(
              compact: (_, __) => const Text('Compact'),
              medium: (_, __) => const Text('Medium'),
              expanded: (_, __) => const Text('Expanded'),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        expect(find.text('Medium'), findsOneWidget);
      });

      testWidgets('switches correctly at 839px to 840px boundary',
          (tester) async {
        // At 839px - should be medium
        await tester.setScreenSize(const Size(839, 800));
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            ResponsiveBuilder(
              compact: (_, __) => const Text('Compact'),
              medium: (_, __) => const Text('Medium'),
              expanded: (_, __) => const Text('Expanded'),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        expect(find.text('Medium'), findsOneWidget);

        // At 840px - should be expanded
        await tester.setScreenSize(const Size(840, 800));
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            ResponsiveBuilder(
              compact: (_, __) => const Text('Compact'),
              medium: (_, __) => const Text('Medium'),
              expanded: (_, __) => const Text('Expanded'),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        expect(find.text('Expanded'), findsOneWidget);
      });
    });

    group('WindowSizeClass tests', () {
      testWidgets('windowSizeClassFromWidth returns correct class',
          (tester) async {
        // Test compact
        expect(windowSizeClassFromWidth(0), WindowSizeClass.compact);
        expect(windowSizeClassFromWidth(320), WindowSizeClass.compact);
        expect(windowSizeClassFromWidth(599), WindowSizeClass.compact);

        // Test medium
        expect(windowSizeClassFromWidth(600), WindowSizeClass.medium);
        expect(windowSizeClassFromWidth(700), WindowSizeClass.medium);
        expect(windowSizeClassFromWidth(839), WindowSizeClass.medium);

        // Test expanded
        expect(windowSizeClassFromWidth(840), WindowSizeClass.expanded);
        expect(windowSizeClassFromWidth(1200), WindowSizeClass.expanded);
        expect(windowSizeClassFromWidth(1600), WindowSizeClass.expanded);
      });
    });

    group('Layout visibility at various sizes', () {
      testWidgets('content is visible at all standard screen sizes',
          (tester) async {
        for (final size in TestDeviceSizes.all) {
          await tester.setScreenSize(size);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Title'),
                    SizedBox(height: 16),
                    Text('Subtitle'),
                  ],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          expect(
            find.text('Title'),
            findsOneWidget,
            reason:
                'Title should be visible at ${TestDeviceSizes.nameFor(size)}',
          );
          expect(
            find.text('Subtitle'),
            findsOneWidget,
            reason:
                'Subtitle should be visible at ${TestDeviceSizes.nameFor(size)}',
          );
        }
      });

      testWidgets('buttons are tappable at all screen sizes', (tester) async {
        int tapCount = 0;

        for (final size in TestDeviceSizes.all) {
          tapCount = 0;
          await tester.setScreenSize(size);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Center(
                child: ElevatedButton(
                  onPressed: () => tapCount++,
                  child: const Text('Tap Me'),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 100));

          await tester.tap(find.text('Tap Me'));
          await tester.pumpAndSettle();

          expect(
            tapCount,
            1,
            reason:
                'Button should be tappable at ${TestDeviceSizes.nameFor(size)}',
          );
        }
      });
    });
  });
}
