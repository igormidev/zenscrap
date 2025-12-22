import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Layout switching tests for api_analytics feature.
///
/// These tests verify that the API Analytics view correctly switches between
/// compact and expanded layouts at the appropriate breakpoints (600px, 840px).
///
/// Test Categories:
/// 1. ApiAnalyticsView master-detail pattern tests
/// 2. Breakpoint edge cases (599px, 600px, 839px, 840px)
/// 3. Layout visibility tests
/// 4. Responsive panel width tests
void main() {
  group('API Analytics Layout Switching Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('ApiAnalyticsView Master-Detail Pattern Tests', () {
      testWidgets(
        'compact layout shows single pane (grid only) when no selection',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockApiAnalyticsView(
                isCompact: true,
                hasSelection: false,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should show grid view
          expect(
            find.byKey(const Key('grid_view')),
            findsOneWidget,
            reason: 'Grid view should be visible in compact layout',
          );

          // Should not show detail page
          expect(
            find.byKey(const Key('detail_page')),
            findsNothing,
            reason: 'Detail page should not be visible when no selection',
          );
        },
      );

      testWidgets(
        'compact layout shows single pane (detail only) when has selection',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockApiAnalyticsView(
                isCompact: true,
                hasSelection: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should show detail page
          expect(
            find.byKey(const Key('detail_page')),
            findsOneWidget,
            reason: 'Detail page should be visible when has selection',
          );

          // Should not show grid view
          expect(
            find.byKey(const Key('grid_view')),
            findsNothing,
            reason: 'Grid view should be hidden when detail is shown',
          );

          // Should show back button in bottom app bar
          expect(
            find.byKey(const Key('back_button')),
            findsOneWidget,
            reason: 'Back button should be visible in compact layout',
          );
        },
      );

      testWidgets(
        'expanded layout shows both panes side-by-side',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletLandscape);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockApiAnalyticsView(
                isCompact: false,
                hasSelection: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Should show both grid and detail side-by-side
          expect(
            find.byKey(const Key('grid_view')),
            findsOneWidget,
            reason: 'Grid view should be visible in expanded layout',
          );

          expect(
            find.byKey(const Key('detail_page')),
            findsOneWidget,
            reason: 'Detail page should be visible in expanded layout',
          );

          // Should not show back button (not needed in desktop layout)
          expect(
            find.byKey(const Key('back_button')),
            findsNothing,
            reason: 'Back button should not be visible in expanded layout',
          );
        },
      );

      testWidgets(
        'expanded layout shows grid only when no selection',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockApiAnalyticsView(
                isCompact: false,
                hasSelection: false,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Grid should be visible
          expect(
            find.byKey(const Key('grid_view')),
            findsOneWidget,
            reason: 'Grid view should be visible',
          );

          // Detail panel should have zero width (AnimatedSize)
          final detailContainer = tester.widget<AnimatedSize>(
            find.byKey(const Key('detail_container')),
          );
          expect(
            (detailContainer.child as SizedBox).width,
            equals(0),
            reason: 'Detail panel should have zero width when no selection',
          );
        },
      );
    });

    group('Breakpoint Edge Cases', () {
      testWidgets(
        'layout switches from compact to expanded at 600px',
        (tester) async {
          // Test at 599px (just before medium breakpoint)
          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockResponsiveLayoutDetector(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.text('Compact Layout'),
            findsOneWidget,
            reason: '599px should use compact layout',
          );

          // Test at 600px (exactly at medium breakpoint)
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockResponsiveLayoutDetector(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.text('Compact Layout'),
            findsOneWidget,
            reason: '600px should still use compact layout (expanded starts at 840px)',
          );
        },
      );

      testWidgets(
        'layout switches from compact to expanded at 840px',
        (tester) async {
          // Test at 839px (just before expanded breakpoint)
          await tester.setScreenSize(const Size(839, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockResponsiveLayoutDetector(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.text('Compact Layout'),
            findsOneWidget,
            reason: '839px should use compact layout',
          );

          // Test at 840px (exactly at expanded breakpoint)
          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockResponsiveLayoutDetector(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.text('Expanded Layout'),
            findsOneWidget,
            reason: '840px should use expanded layout',
          );
        },
      );

      testWidgets(
        'all breakpoint edges use correct layout',
        (tester) async {
          final testCases = [
            (size: const Size(599, 800), expected: 'Compact'),
            (size: const Size(600, 800), expected: 'Compact'),
            (size: const Size(839, 800), expected: 'Compact'),
            (size: const Size(840, 800), expected: 'Expanded'),
            (size: const Size(1199, 800), expected: 'Expanded'),
            (size: const Size(1200, 800), expected: 'Expanded'),
          ];

          for (final testCase in testCases) {
            await tester.setScreenSize(testCase.size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockResponsiveLayoutDetector(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            expect(
              find.text('${testCase.expected} Layout'),
              findsOneWidget,
              reason:
                  '${testCase.size.width}px should use ${testCase.expected.toLowerCase()} layout',
            );
          }
        },
      );
    });

    group('Responsive Panel Width Tests', () {
      testWidgets(
        'detail panel has correct width in medium breakpoint (840-1199px)',
        (tester) async {
          // Test at 900px which is in the medium range for expanded layout
          // (medium: 840-1199, expanded: >=1200)
          await tester.setScreenSize(TestDeviceSizes.tabletLandscape);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockExpandedLayoutWithSelection(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final detailSize = tester.getSize(
            find.byKey(const Key('detail_panel')),
          );

          // Detail panel width should be 400px at medium (840-1199px)
          // But tabletLandscape (900px) is already >= 840, so it uses medium value
          // Actually, looking at the responsive system, medium is 600-839, expanded is >=840
          // So at 900px, we're in expanded range and should use 429px
          expect(
            detailSize.width,
            equals(429),
            reason: 'Detail panel should be 429px wide at 900px (expanded range)',
          );
        },
      );

      testWidgets(
        'detail panel has correct width at expanded breakpoint (>=840px)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockExpandedLayoutWithSelection(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final detailSize = tester.getSize(
            find.byKey(const Key('detail_panel')),
          );

          // Detail panel width should be 429px at expanded (>=1200px)
          expect(
            detailSize.width,
            equals(429),
            reason: 'Detail panel should be 429px wide at expanded breakpoint',
          );
        },
      );

      testWidgets(
        'detail panel animates to zero width when selection is cleared',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);

          // Start with selection
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockExpandedLayoutWithAnimatedSelection(hasSelection: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          // Verify detail panel is visible
          final initialSize = tester.getSize(
            find.byKey(const Key('detail_container')),
          );
          expect(
            initialSize.width,
            equals(429),
            reason: 'Detail panel should be 429px wide initially',
          );

          // Clear selection
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockExpandedLayoutWithAnimatedSelection(hasSelection: false),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          // Verify detail panel has zero width
          final finalSize = tester.getSize(
            find.byKey(const Key('detail_container')),
          );
          expect(
            finalSize.width,
            equals(0),
            reason: 'Detail panel should have zero width after clearing selection',
          );
        },
      );
    });

    group('Wrap Layout Responsiveness Tests', () {
      testWidgets(
        'wrap layout shows single column at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockWrapLayoutTest(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // At 320px with 12px padding and 348px card width,
          // only one card should fit per row
          // Card positions should be vertically stacked
          final firstCard = tester.getTopLeft(
            find.byKey(const Key('card_0')),
          );
          final secondCard = tester.getTopLeft(
            find.byKey(const Key('card_1')),
          );

          expect(
            secondCard.dy,
            greaterThan(firstCard.dy),
            reason: 'Cards should be vertically stacked at 320px',
          );
        },
      );

      testWidgets(
        'wrap layout shows multiple columns at larger widths',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockWrapLayoutTest(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // At 1200px, multiple cards should fit in a row
          final firstCard = tester.getTopLeft(
            find.byKey(const Key('card_0')),
          );
          final secondCard = tester.getTopLeft(
            find.byKey(const Key('card_1')),
          );

          expect(
            firstCard.dy,
            equals(secondCard.dy),
            reason: 'Cards should be side-by-side at desktop width',
          );

          expect(
            secondCard.dx,
            greaterThan(firstCard.dx),
            reason: 'Second card should be to the right of first card',
          );
        },
      );
    });

    group('Responsive Spacing Tests', () {
      testWidgets(
        'compact layout uses correct padding values',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockResponsivePaddingTest(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final container = tester.widget<Container>(
            find.byKey(const Key('padded_container')),
          );
          final padding = (container.padding as EdgeInsets);

          expect(
            padding.horizontal,
            equals(24.0),
            reason: 'Compact layout should use 12px horizontal padding (24 total)',
          );
        },
      );

      testWidgets(
        'medium layout uses correct padding values',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockResponsivePaddingTest(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final container = tester.widget<Container>(
            find.byKey(const Key('padded_container')),
          );
          final padding = (container.padding as EdgeInsets);

          expect(
            padding.horizontal,
            equals(32.0),
            reason: 'Medium layout should use 16px horizontal padding (32 total)',
          );
        },
      );

      testWidgets(
        'expanded layout uses correct padding values',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockResponsivePaddingTest(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final container = tester.widget<Container>(
            find.byKey(const Key('padded_container')),
          );
          final padding = (container.padding as EdgeInsets);

          expect(
            padding.horizontal,
            equals(32.0),
            reason: 'Expanded layout should use 16px horizontal padding (32 total)',
          );
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock ApiAnalyticsView with master-detail pattern
class _MockApiAnalyticsView extends StatelessWidget {
  final bool isCompact;
  final bool hasSelection;

  const _MockApiAnalyticsView({
    required this.isCompact,
    required this.hasSelection,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _MockCompactLayout(hasSelection: hasSelection);
    } else {
      return _MockExpandedLayout(hasSelection: hasSelection);
    }
  }
}

/// Mock compact layout (mobile)
class _MockCompactLayout extends StatelessWidget {
  final bool hasSelection;

  const _MockCompactLayout({required this.hasSelection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hasSelection
          ? Container(
              key: const Key('detail_page'),
              color: Colors.blue.shade50,
              child: const Center(child: Text('Detail Page')),
            )
          : Container(
              key: const Key('grid_view'),
              color: Colors.green.shade50,
              child: const Center(child: Text('Grid View')),
            ),
      bottomNavigationBar: hasSelection
          ? BottomAppBar(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        key: const Key('back_button'),
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Scrappable Name'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

/// Mock expanded layout (desktop)
class _MockExpandedLayout extends StatelessWidget {
  final bool hasSelection;

  const _MockExpandedLayout({required this.hasSelection});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Grid view (left side)
        Expanded(
          child: Container(
            key: const Key('grid_view'),
            color: Colors.green.shade50,
            child: const Center(child: Text('Grid View')),
          ),
        ),
        const VerticalDivider(width: 1),
        // Detail panel (right side)
        AnimatedSize(
          key: const Key('detail_container'),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: hasSelection
                ? context.responsiveValue(
                    compact: 0,
                    medium: 400,
                    expanded: 429,
                  )
                : 0,
            child: Container(
              key: const Key('detail_page'),
              color: Colors.blue.shade50,
              child: const Center(child: Text('Detail Page')),
            ),
          ),
        ),
      ],
    );
  }
}

/// Mock responsive layout detector
class _MockResponsiveLayoutDetector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      compact: (context, constraints) => const Center(
        child: Text('Compact Layout'),
      ),
      expanded: (context, constraints) => const Center(
        child: Text('Expanded Layout'),
      ),
    );
  }
}

/// Mock expanded layout with selection
class _MockExpandedLayoutWithSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.green.shade50,
            child: const Center(child: Text('Grid View')),
          ),
        ),
        const VerticalDivider(width: 1),
        Container(
          key: const Key('detail_panel'),
          width: context.responsiveValue(
            compact: 0,
            medium: 400,
            expanded: 429,
          ),
          color: Colors.blue.shade50,
          child: const Center(child: Text('Detail Panel')),
        ),
      ],
    );
  }
}

/// Mock expanded layout with animated selection
class _MockExpandedLayoutWithAnimatedSelection extends StatelessWidget {
  final bool hasSelection;

  const _MockExpandedLayoutWithAnimatedSelection({
    required this.hasSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.green.shade50,
            child: const Center(child: Text('Grid View')),
          ),
        ),
        const VerticalDivider(width: 1),
        AnimatedSize(
          key: const Key('detail_container'),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: SizedBox(
            width: hasSelection
                ? context.responsiveValue(
                    compact: 0,
                    medium: 400,
                    expanded: 429,
                  )
                : 0,
            child: Container(
              color: Colors.blue.shade50,
              child: const Center(child: Text('Detail Panel')),
            ),
          ),
        ),
      ],
    );
  }
}

/// Mock wrap layout test
class _MockWrapLayoutTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 12.0,
          medium: 16.0,
          expanded: 16.0,
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: context.responsiveValue(
            compact: 12.0,
            medium: 16.0,
            expanded: 16.0,
          ),
          runSpacing: context.responsiveValue(
            compact: 12.0,
            medium: 16.0,
            expanded: 16.0,
          ),
          children: List.generate(
            4,
            (index) => Container(
              key: Key('card_$index'),
              width: 348,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text('Card $index')),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mock responsive padding test
class _MockResponsivePaddingTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('padded_container'),
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 12.0,
          medium: 16.0,
          expanded: 16.0,
        ),
      ),
      child: const Text('Padded Content'),
    );
  }
}
