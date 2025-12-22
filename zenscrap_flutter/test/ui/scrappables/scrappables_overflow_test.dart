import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/pages/empty_scrappable_listage_indicator_page.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/widgets/user_scrappables_search_bar.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Tests for overflow detection in scrappables feature components.
///
/// These tests verify that all scrappables UI components properly adapt to
/// different screen sizes without causing overflow errors.
void main() {
  group('Scrappables Overflow Detection Tests', () {
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

    group('EmptyScrappableListageIndicatorPage overflow tests', () {
      testWidgets(
        'EmptyScrappableListageIndicatorPage does not overflow on all screen sizes',
        (tester) async {
          overflowCapture.start();

          try {
            for (final size in TestDeviceSizes.all) {
              overflowCapture.clear();

              await tester.setScreenSize(size);
              await tester.pumpWidget(
                fullPageTestWrapper(
                  sharedPreferences: prefs,
                  const EmptyScrappableListageIndicatorPage(),
                ),
              );
              await tester.pumpAndSettle(const Duration(seconds: 2));

              expect(
                overflowCapture.hasOverflow,
                isFalse,
                reason:
                    'EmptyScrappableListageIndicatorPage has overflow at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          } finally {
            overflowCapture.stop();
          }
        },
      );

      testWidgets(
        'EmptyScrappableListageIndicatorPage handles breakpoint edges correctly',
        (tester) async {
          overflowCapture.start();

          try {
            for (final size in TestDeviceSizes.breakpointEdges) {
              overflowCapture.clear();

              await tester.setScreenSize(size);
              await tester.pumpWidget(
                fullPageTestWrapper(
                  sharedPreferences: prefs,
                  const EmptyScrappableListageIndicatorPage(),
                ),
              );
              await tester.pumpAndSettle(const Duration(seconds: 2));

              expect(
                overflowCapture.hasOverflow,
                isFalse,
                reason:
                    'EmptyScrappableListageIndicatorPage has overflow at breakpoint edge ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          } finally {
            overflowCapture.stop();
          }
        },
      );
    });

    group('UserScrappablesSearchBar overflow tests', () {
      testWidgets(
        'UserScrappablesSearchBar does not overflow on all screen sizes',
        (tester) async {
          overflowCapture.start();

          try {
            for (final size in TestDeviceSizes.all) {
              overflowCapture.clear();

              await tester.setScreenSize(size);
              await tester.pumpWidget(
                responsiveTestWrapper(
                  sharedPreferences: prefs,
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: UserScrappablesSearchBar(),
                  ),
                ),
              );
              await tester.pumpAndSettle(const Duration(milliseconds: 300));

              expect(
                overflowCapture.hasOverflow,
                isFalse,
                reason:
                    'UserScrappablesSearchBar has overflow at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          } finally {
            overflowCapture.stop();
          }
        },
      );

      testWidgets(
        'UserScrappablesSearchBar adapts correctly at breakpoint edges',
        (tester) async {
          overflowCapture.start();

          try {
            for (final size in TestDeviceSizes.breakpointEdges) {
              overflowCapture.clear();

              await tester.setScreenSize(size);
              await tester.pumpWidget(
                responsiveTestWrapper(
                  sharedPreferences: prefs,
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: UserScrappablesSearchBar(),
                  ),
                ),
              );
              await tester.pumpAndSettle(const Duration(milliseconds: 300));

              expect(
                overflowCapture.hasOverflow,
                isFalse,
                reason:
                    'UserScrappablesSearchBar has overflow at breakpoint edge ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          } finally {
            overflowCapture.stop();
          }
        },
      );

      testWidgets(
        'UserScrappablesSearchBar handles very narrow screens',
        (tester) async {
          overflowCapture.start();

          try {
            final veryNarrowSize = const Size(280, 568); // Extra narrow
            overflowCapture.clear();

            await tester.setScreenSize(veryNarrowSize);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: UserScrappablesSearchBar(),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 300));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'UserScrappablesSearchBar has overflow on very narrow screen (280px): ${overflowCapture.summary}',
            );
          } finally {
            overflowCapture.stop();
          }
        },
      );
    });

    group('Compact screen size overflow tests', () {
      testWidgets(
        'All scrappables components handle compact sizes without overflow',
        (tester) async {
          overflowCapture.start();

          try {
            for (final size in TestDeviceSizes.compactSizes) {
              // Test EmptyScrappableListageIndicatorPage
              overflowCapture.clear();
              await tester.setScreenSize(size);
              await tester.pumpWidget(
                fullPageTestWrapper(
                  sharedPreferences: prefs,
                  const EmptyScrappableListageIndicatorPage(),
                ),
              );
              await tester.pumpAndSettle(const Duration(seconds: 2));

              expect(
                overflowCapture.hasOverflow,
                isFalse,
                reason:
                    'EmptyScrappableListageIndicatorPage overflows at ${TestDeviceSizes.nameFor(size)}',
              );

              // Test UserScrappablesSearchBar
              overflowCapture.clear();
              await tester.setScreenSize(size);
              await tester.pumpWidget(
                responsiveTestWrapper(
                  sharedPreferences: prefs,
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: UserScrappablesSearchBar(),
                  ),
                ),
              );
              await tester.pumpAndSettle(const Duration(milliseconds: 300));

              expect(
                overflowCapture.hasOverflow,
                isFalse,
                reason:
                    'UserScrappablesSearchBar overflows at ${TestDeviceSizes.nameFor(size)}',
              );
            }
          } finally {
            overflowCapture.stop();
          }
        },
      );
    });

    group('Responsive value scaling tests', () {
      testWidgets(
        'Components properly scale spacing and sizing across breakpoints',
        (tester) async {
          overflowCapture.start();

          try {
            final testSizes = [
              TestDeviceSizes.smallPhone, // Compact
              TestDeviceSizes.tabletPortrait, // Medium
              TestDeviceSizes.desktop, // Expanded
            ];

            for (final size in testSizes) {
              overflowCapture.clear();

              await tester.setScreenSize(size);
              await tester.pumpWidget(
                fullPageTestWrapper(
                  sharedPreferences: prefs,
                  const EmptyScrappableListageIndicatorPage(),
                ),
              );
              await tester.pumpAndSettle(const Duration(seconds: 2));

              expect(
                overflowCapture.hasOverflow,
                isFalse,
                reason:
                    'Component does not scale properly at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          } finally {
            overflowCapture.stop();
          }
        },
      );
    });

    group('Edge case overflow tests', () {
      testWidgets(
        'Components handle extreme aspect ratios without overflow',
        (tester) async {
          overflowCapture.start();

          try {
            // Test very wide but short screen
            final wideShort = const Size(1920, 400);
            overflowCapture.clear();
            await tester.setScreenSize(wideShort);
            await tester.pumpWidget(
              fullPageTestWrapper(
                sharedPreferences: prefs,
                const EmptyScrappableListageIndicatorPage(),
              ),
            );
            await tester.pumpAndSettle(const Duration(seconds: 2));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Components overflow on wide-short screen (1920x400): ${overflowCapture.summary}',
            );

            // Test very narrow but tall screen
            final narrowTall = const Size(300, 1200);
            overflowCapture.clear();
            await tester.setScreenSize(narrowTall);
            await tester.pumpWidget(
              fullPageTestWrapper(
                sharedPreferences: prefs,
                const EmptyScrappableListageIndicatorPage(),
              ),
            );
            await tester.pumpAndSettle(const Duration(seconds: 2));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Components overflow on narrow-tall screen (300x1200): ${overflowCapture.summary}',
            );
          } finally {
            overflowCapture.stop();
          }
        },
      );
    });
  });
}
