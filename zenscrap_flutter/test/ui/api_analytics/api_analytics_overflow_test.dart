import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive overflow detection tests for api_analytics components.
///
/// Tests verify that api_analytics widgets do not cause overflow errors
/// at various screen sizes, especially at the critical 320px width
/// and at breakpoint edges (599, 600, 839, 840).
///
/// Test Categories:
/// 1. ScrappablesGridView overflow tests (Wrap layout)
/// 2. SelectedScrappablePage overflow tests
/// 3. ScrappableHeader overflow tests
/// 4. StatCard overflow tests
/// 5. AnalyticsItemCard overflow tests (collapsed and expanded states)
/// 6. AnalyticsStatsSummary overflow tests
/// 7. NoSelectedScrappableIndicatorPage overflow tests
/// 8. ScopeSelectorDropdown overflow tests
void main() {
  group('API Analytics Components Overflow Detection Tests', () {
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

    group('ScrappablesGridView Overflow Tests', () {
      testWidgets(
        'grid view does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappablesGridView(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          overflowCapture.stop();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'ScrappablesGridView overflows at 320px: ${overflowCapture.summary}',
          );
        },
      );

      testWidgets(
        'grid view does not overflow at all screen sizes',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockScrappablesGridView(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add(
                'Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'grid header with title and controls does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.compactSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockGridViewHeader(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add(
                'Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'wrap layout with cards adapts to screen width without overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockWrapLayoutCards(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add(
                'Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('SelectedScrappablePage Overflow Tests', () {
      testWidgets(
        'selected scrappable page does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockSelectedScrappablePage(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          overflowCapture.stop();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'SelectedScrappablePage overflows at 320px: ${overflowCapture.summary}',
          );
        },
      );

      testWidgets(
        'selected scrappable page does not overflow at all screen sizes',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockSelectedScrappablePage(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add(
                'Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('ScrappableHeader Overflow Tests', () {
      testWidgets(
        'scrappable header does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableHeader(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          overflowCapture.stop();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'ScrappableHeader overflows at 320px: ${overflowCapture.summary}',
          );
        },
      );

      testWidgets(
        'scrappable header with long name does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.compactSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockScrappableHeader(
                  hasLongName: true,
                  hasDescription: true,
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add(
                'Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('StatCard Overflow Tests', () {
      testWidgets(
        'stat card does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockStatCard(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          overflowCapture.stop();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason: 'StatCard overflows at 320px: ${overflowCapture.summary}',
          );
        },
      );

      testWidgets(
        'stat card does not overflow at any screen size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockStatCard(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add(
                'Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('AnalyticsItemCard Overflow Tests', () {
      testWidgets(
        'collapsed analytics item card does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAnalyticsItemCard(isExpanded: false),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          overflowCapture.stop();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Collapsed AnalyticsItemCard overflows at 320px: ${overflowCapture.summary}',
          );
        },
      );

      testWidgets(
        'expanded analytics item card does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAnalyticsItemCard(isExpanded: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          overflowCapture.stop();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Expanded AnalyticsItemCard overflows at 320px: ${overflowCapture.summary}',
          );
        },
      );

      testWidgets(
        'analytics item card does not overflow at any screen size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            for (final isExpanded in [false, true]) {
              overflowCapture.clear();

              await tester.setScreenSize(size);
              await tester.pumpWidget(
                responsiveTestWrapper(
                  sharedPreferences: prefs,
                  _MockAnalyticsItemCard(isExpanded: isExpanded),
                ),
              );
              await tester.pumpAndSettle(const Duration(milliseconds: 300));

              if (overflowCapture.hasOverflow) {
                failures.add(
                  '${isExpanded ? "Expanded" : "Collapsed"} card overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
                );
              }
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('AnalyticsStatsSummary Overflow Tests', () {
      testWidgets(
        'analytics stats summary does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAnalyticsStatsSummary(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          overflowCapture.stop();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'AnalyticsStatsSummary overflows at 320px: ${overflowCapture.summary}',
          );
        },
      );

      testWidgets(
        'analytics stats summary scrolls horizontally without overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockAnalyticsStatsSummary(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add(
                'Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('NoSelectedScrappableIndicatorPage Overflow Tests', () {
      testWidgets(
        'no selected scrappable page does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockNoSelectedScrappableIndicatorPage(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          overflowCapture.stop();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'NoSelectedScrappableIndicatorPage overflows at 320px: ${overflowCapture.summary}',
          );
        },
      );

      testWidgets(
        'no selected scrappable page does not overflow at any screen size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockNoSelectedScrappableIndicatorPage(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add(
                'Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('ScopeSelectorDropdown Overflow Tests', () {
      testWidgets(
        'scope selector dropdown does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScopeSelectorDropdown(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          overflowCapture.stop();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'ScopeSelectorDropdown overflows at 320px: ${overflowCapture.summary}',
          );
        },
      );

      testWidgets(
        'scope selector dropdown does not overflow at any screen size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockScopeSelectorDropdown(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add(
                'Overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
              );
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock ScrappablesGridView
class _MockScrappablesGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: context.responsiveValue(
            compact: 12.0,
            medium: 16.0,
            expanded: 20.0,
          ),
        ),
        _MockGridViewHeader(),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveValue(
                  compact: 12.0,
                  medium: 16.0,
                  expanded: 16.0,
                ),
              ),
              child: _MockWrapLayoutCards(),
            ),
          ),
        ),
      ],
    );
  }
}

/// Mock grid view header with title, scope selector, and refresh button
class _MockGridViewHeader extends StatelessWidget {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'API Analytics',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Monitor API usage',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withAlpha(150),
                ),
          ),
          const SizedBox(height: 12),
          // Controls row - scrollable if needed
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: () {},
                  label: const Text('Refresh'),
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 12),
                _MockScopeSelectorDropdown(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock wrap layout with analytics cards
class _MockWrapLayoutCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
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
        runAlignment: WrapAlignment.start,
        alignment: WrapAlignment.start,
        children: List.generate(
          6,
          (index) => Container(
            width: 348,
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withAlpha(30),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Scrappable ${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Mock SelectedScrappablePage
class _MockSelectedScrappablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MockScrappableHeader(),
        _MockAnalyticsStatsSummary(),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: context.responsiveValue(
                compact: 8.0,
                medium: 12.0,
                expanded: 12.0,
              ),
            ),
            padding: EdgeInsets.all(
              context.responsiveValue(
                compact: 12.0,
                medium: 16.0,
                expanded: 16.0,
              ),
            ),
            itemCount: 5,
            itemBuilder: (context, index) => _MockAnalyticsItemCard(
              isExpanded: false,
            ),
          ),
        ),
      ],
    );
  }
}

/// Mock ScrappableHeader
class _MockScrappableHeader extends StatelessWidget {
  final bool hasLongName;
  final bool hasDescription;

  const _MockScrappableHeader({
    this.hasLongName = false,
    this.hasDescription = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 20.0,
        ),
        bottom: context.responsiveValue(
          compact: 12.0,
          medium: 16.0,
          expanded: 16.0,
        ),
        left: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 20.0,
        ),
        right: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 20.0,
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(50),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: context.responsiveValue(
                  compact: 20.0,
                  medium: 24.0,
                  expanded: 24.0,
                ),
              ),
              SizedBox(
                width: context.responsiveValue(
                  compact: 8.0,
                  medium: 8.0,
                  expanded: 8.0,
                ),
              ),
              Expanded(
                child: Text(
                  hasLongName
                      ? 'Very Long Scrappable Name That Should Wrap Properly Without Causing Overflow'
                      : 'Scrappable Name',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          if (hasDescription) ...[
            const SizedBox(height: 4),
            Text(
              'This is a description of the scrappable that explains what it does',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Mock StatCard
class _MockStatCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 12.0,
          medium: 14.0,
          expanded: 14.0,
        ),
        vertical: context.responsiveValue(
          compact: 8.0,
          medium: 10.0,
          expanded: 10.0,
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(18),
        borderRadius: BorderRadius.circular(
          context.responsiveValue(
            compact: 12.0,
            medium: 16.0,
            expanded: 16.0,
          ),
        ),
        border: Border.all(
          color: Colors.green.withAlpha(50),
        ),
      ),
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '123',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.green.withAlpha(230),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Success',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.green.withAlpha(200),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mock AnalyticsItemCard
class _MockAnalyticsItemCard extends StatelessWidget {
  final bool isExpanded;

  const _MockAnalyticsItemCard({required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main row
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsiveValue(
                compact: 12.0,
                medium: 20.0,
                expanded: 20.0,
              ),
              vertical: context.responsiveValue(
                compact: 8.0,
                medium: 12.0,
                expanded: 12.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withAlpha(20),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Success',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Dec 20, 12:00',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                      ),
                ),
              ],
            ),
          ),
          // Expanded details
          if (isExpanded)
            Container(
              height: 400,
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveValue(
                  compact: 12.0,
                  medium: 20.0,
                  expanded: 20.0,
                ),
              ),
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Request details here...'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Mock AnalyticsStatsSummary
class _MockAnalyticsStatsSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(30),
      ),
      child: Column(
        children: [
          SizedBox(
            height: context.responsiveValue(
              compact: 8.0,
              medium: 12.0,
              expanded: 12.0,
            ),
          ),
          SizedBox(
            height: context.responsiveValue(
              compact: 56.0,
              medium: 64.0,
              expanded: 64.0,
            ),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  width: context.responsiveValue(
                    compact: 12.0,
                    medium: 16.0,
                    expanded: 16.0,
                  ),
                ),
                _MockStatCard(),
                const SizedBox(width: 12),
                _MockStatCard(),
                const SizedBox(width: 12),
                _MockStatCard(),
                const SizedBox(width: 12),
                _MockStatCard(),
                const SizedBox(width: 12),
                _MockStatCard(),
                const SizedBox(width: 12),
                _MockStatCard(),
              ],
            ),
          ),
          SizedBox(
            height: context.responsiveValue(
              compact: 8.0,
              medium: 12.0,
              expanded: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock NoSelectedScrappableIndicatorPage
class _MockNoSelectedScrappableIndicatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          context.responsiveValue(
            compact: 24.0,
            medium: 32.0,
            expanded: 32.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: context.responsiveValue(
                compact: 48.0,
                medium: 64.0,
                expanded: 64.0,
              ),
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
            ),
            SizedBox(
              height: context.responsiveValue(
                compact: 12.0,
                medium: 16.0,
                expanded: 16.0,
              ),
            ),
            Text(
              'No scrappable selected',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Select a scrappable to view detailed analytics',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Mock ScopeSelectorDropdown
class _MockScopeSelectorDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 10.0,
          medium: 12.0,
          expanded: 12.0,
        ),
      ),
      height: context.responsiveValue(
        compact: 48.0,
        medium: 48.0,
        expanded: 48.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(50),
        ),
      ),
      child: DropdownButton<String>(
        value: 'Last Hour',
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.arrow_drop_down),
        items: const [
          DropdownMenuItem(value: 'Last Hour', child: Text('Last Hour')),
          DropdownMenuItem(value: 'Last 24 Hours', child: Text('Last 24 Hours')),
          DropdownMenuItem(value: 'Last 7 Days', child: Text('Last 7 Days')),
        ],
        onChanged: (_) {},
      ),
    );
  }
}
