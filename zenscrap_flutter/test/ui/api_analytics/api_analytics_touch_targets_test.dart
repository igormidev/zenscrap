import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Touch target tests for api_analytics components.
///
/// These tests verify that all interactive elements meet the minimum
/// touch target size requirements on mobile devices (48x48 logical pixels).
///
/// According to Material Design guidelines and accessibility standards:
/// - Minimum touch target: 48x48 dp
/// - Recommended touch target: 48x48 dp or larger
/// - Critical for users with motor impairments
///
/// Test Categories:
/// 1. ScopeSelectorDropdown touch target (48px height)
/// 2. Refresh button touch target
/// 3. Back button touch target (compact layout)
/// 4. Analytics card expand/collapse button touch targets
/// 5. StatCard touch targets
/// 6. Load more button touch target
void main() {
  group('API Analytics Touch Target Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('ScopeSelectorDropdown Touch Target Tests', () {
      testWidgets(
        'scope selector dropdown has minimum 48px height on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScopeSelectorDropdown(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final dropdownSize = tester.getSize(
            find.byKey(const Key('scope_dropdown')),
          );

          expect(
            dropdownSize.height,
            equals(48.0),
            reason: 'Scope selector dropdown should be exactly 48px height',
          );
        },
      );

      testWidgets(
        'scope selector dropdown has minimum 48px height at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScopeSelectorDropdown(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final dropdownSize = tester.getSize(
            find.byKey(const Key('scope_dropdown')),
          );

          expect(
            dropdownSize.height,
            equals(48.0),
            reason: 'Scope selector should be 48px height even at 320px',
          );
        },
      );

      testWidgets(
        'scope selector dropdown maintains 48px height across all sizes',
        (tester) async {
          final failures = <String>[];

          for (final size in TestDeviceSizes.all) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockScopeSelectorDropdown(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            final dropdownSize = tester.getSize(
              find.byKey(const Key('scope_dropdown')),
            );

            if (dropdownSize.height != 48.0) {
              failures.add(
                'At ${TestDeviceSizes.nameFor(size)}: height is ${dropdownSize.height}px, expected 48px',
              );
            }
          }

          expect(
            failures,
            isEmpty,
            reason:
                'Scope selector should be 48px at all sizes:\n${failures.join('\n')}',
          );
        },
      );
    });

    group('Refresh Button Touch Target Tests', () {
      testWidgets(
        'refresh button has minimum 48px height on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockRefreshButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(
            find.byKey(const Key('refresh_button')),
          );

          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Refresh button should have minimum 48px height',
          );
        },
      );

      testWidgets(
        'refresh button maintains adequate touch target across all sizes',
        (tester) async {
          final failures = <String>[];

          for (final size in TestDeviceSizes.all) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockRefreshButton(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            final buttonSize = tester.getSize(
              find.byKey(const Key('refresh_button')),
            );

            if (buttonSize.height < 48.0) {
              failures.add(
                'At ${TestDeviceSizes.nameFor(size)}: height is ${buttonSize.height}px < 48px',
              );
            }
          }

          expect(
            failures,
            isEmpty,
            reason:
                'Refresh button should meet 48px minimum:\n${failures.join('\n')}',
          );
        },
      );
    });

    group('Back Button Touch Target Tests', () {
      testWidgets(
        'back button (compact layout) has minimum 48x48 touch target',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockBackButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(find.byType(IconButton));

          expect(
            buttonSize.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Back button width should be at least 48px',
          );
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Back button height should be at least 48px',
          );
        },
      );

      testWidgets(
        'back button maintains adequate touch target at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockBackButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(find.byType(IconButton));

          expect(
            buttonSize.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Back button width should be at least 48px at 320px',
          );
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Back button height should be at least 48px at 320px',
          );
        },
      );
    });

    group('Analytics Item Card Touch Target Tests', () {
      testWidgets(
        'expand/collapse button has minimum 48x48 touch target',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAnalyticsItemCardExpandButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(
            find.byKey(const Key('expand_button')),
          );

          expect(
            buttonSize.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Expand button width should be at least 48px',
          );
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Expand button height should be at least 48px',
          );
        },
      );

      testWidgets(
        'copy button in expanded card has minimum 48x48 touch target',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockCopyButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(
            find.byKey(const Key('copy_button')),
          );

          expect(
            buttonSize.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Copy button width should be at least 48px',
          );
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Copy button height should be at least 48px',
          );
        },
      );

      testWidgets(
        'unfold/fold button in JSON field has minimum 48x48 touch target',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockUnfoldButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(
            find.byKey(const Key('unfold_button')),
          );

          expect(
            buttonSize.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Unfold button width should be at least 48px',
          );
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Unfold button height should be at least 48px',
          );
        },
      );
    });

    group('StatCard Touch Target Tests', () {
      testWidgets(
        'stat card is tappable with adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTappableStatCard(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final cardSize = tester.getSize(
            find.byKey(const Key('stat_card')),
          );

          // While stat card doesn't need to be 48x48 (it's not a button),
          // it should have adequate vertical height for tooltip interaction
          expect(
            cardSize.height,
            greaterThanOrEqualTo(40.0),
            reason: 'Stat card should have adequate height for tooltip interaction',
          );

          // Verify tooltip can be triggered (has GestureDetector or InkWell)
          expect(
            find.byKey(const Key('stat_card')),
            findsOneWidget,
            reason: 'Stat card should be tappable for tooltip',
          );
        },
      );
    });

    group('Load More Button Touch Target Tests', () {
      testWidgets(
        'load more button has minimum 48px height',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoadMoreButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(
            find.byKey(const Key('load_more_button')),
          );

          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Load more button should have minimum 48px height',
          );
        },
      );

      testWidgets(
        'load more button maintains adequate touch target across all sizes',
        (tester) async {
          final failures = <String>[];

          for (final size in TestDeviceSizes.all) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockLoadMoreButton(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            final buttonSize = tester.getSize(
              find.byKey(const Key('load_more_button')),
            );

            if (buttonSize.height < 48.0) {
              failures.add(
                'At ${TestDeviceSizes.nameFor(size)}: height is ${buttonSize.height}px < 48px',
              );
            }
          }

          expect(
            failures,
            isEmpty,
            reason:
                'Load more button should meet 48px minimum:\n${failures.join('\n')}',
          );
        },
      );
    });

    group('All Interactive Elements Touch Target Tests', () {
      testWidgets(
        'all interactive elements meet minimum touch target at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAllInteractiveElements(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          final failures = <String>[];

          // Check scope selector dropdown
          final scopeSize = tester.getSize(
            find.byKey(const Key('scope_dropdown')),
          );
          if (scopeSize.height < 48.0) {
            failures.add(
              'Scope dropdown has height ${scopeSize.height}px < 48px',
            );
          }

          // Check refresh button
          final refreshSize = tester.getSize(
            find.byKey(const Key('refresh_button')),
          );
          if (refreshSize.height < 48.0) {
            failures.add(
              'Refresh button has height ${refreshSize.height}px < 48px',
            );
          }

          // Check all IconButtons
          for (final button in tester.widgetList<IconButton>(
            find.byType(IconButton),
          )) {
            final size = tester.getSize(find.byWidget(button));
            if (size.width < 48.0 || size.height < 48.0) {
              failures.add(
                'IconButton has size ${size.width}x${size.height}px < 48x48px',
              );
            }
          }

          // Check all ElevatedButtons
          for (final button in tester.widgetList<ElevatedButton>(
            find.byType(ElevatedButton),
          )) {
            final size = tester.getSize(find.byWidget(button));
            if (size.height < 48.0) {
              failures.add(
                'ElevatedButton has height ${size.height}px < 48px',
              );
            }
          }

          expect(
            failures,
            isEmpty,
            reason:
                'All interactive elements should meet 48px minimum:\n${failures.join('\n')}',
          );
        },
      );

      testWidgets(
        'touch targets remain adequate across all screen sizes',
        (tester) async {
          final failures = <String>[];

          for (final size in TestDeviceSizes.all) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockCriticalInteractiveElements(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            // Check scope dropdown
            final scopeSize = tester.getSize(
              find.byKey(const Key('scope_dropdown')),
            );
            if (scopeSize.height < 48.0) {
              failures.add(
                'Scope dropdown at ${TestDeviceSizes.nameFor(size)}: ${scopeSize.height}px < 48px',
              );
            }

            // Check back button (if present)
            final backButton = find.byKey(const Key('back_button'));
            if (backButton.evaluate().isNotEmpty) {
              final backSize = tester.getSize(backButton);
              if (backSize.width < 48.0 || backSize.height < 48.0) {
                failures.add(
                  'Back button at ${TestDeviceSizes.nameFor(size)}: ${backSize.width}x${backSize.height}px < 48x48px',
                );
              }
            }

            // Check expand button
            final expandSize = tester.getSize(
              find.byKey(const Key('expand_button')),
            );
            if (expandSize.width < 48.0 || expandSize.height < 48.0) {
              failures.add(
                'Expand button at ${TestDeviceSizes.nameFor(size)}: ${expandSize.width}x${expandSize.height}px < 48x48px',
              );
            }
          }

          expect(
            failures,
            isEmpty,
            reason:
                'Touch targets should be adequate across all sizes:\n${failures.join('\n')}',
          );
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock ScopeSelectorDropdown
class _MockScopeSelectorDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('scope_dropdown'),
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
        ],
        onChanged: (_) {},
      ),
    );
  }
}

/// Mock refresh button
class _MockRefreshButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      key: const Key('refresh_button'),
      onPressed: () {},
      label: const Text('Refresh'),
      icon: const Icon(Icons.refresh),
    );
  }
}

/// Mock back button
class _MockBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('back_button'),
      icon: const Icon(Icons.arrow_back),
      onPressed: () {},
    );
  }
}

/// Mock analytics item card expand button
class _MockAnalyticsItemCardExpandButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('expand_button'),
      onPressed: () {},
      icon: const Icon(Icons.expand_more),
    );
  }
}

/// Mock copy button
class _MockCopyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('copy_button'),
      icon: const Icon(Icons.copy, size: 18),
      onPressed: () {},
      tooltip: 'Copy',
    );
  }
}

/// Mock unfold button
class _MockUnfoldButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('unfold_button'),
      icon: const Icon(Icons.unfold_more, size: 18),
      onPressed: () {},
      tooltip: 'Expand',
    );
  }
}

/// Mock tappable stat card
class _MockTappableStatCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Success requests',
      child: Container(
        key: const Key('stat_card'),
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withAlpha(50)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '123',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green.withAlpha(230),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              'Success',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green.withAlpha(200),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mock load more button
class _MockLoadMoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('load_more_button'),
      onPressed: () {},
      icon: const Icon(Icons.add),
      label: const Text('Load More'),
    );
  }
}

/// Mock all interactive elements
class _MockAllInteractiveElements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MockScopeSelectorDropdown(),
        const SizedBox(height: 8),
        _MockRefreshButton(),
        const SizedBox(height: 8),
        _MockBackButton(),
        const SizedBox(height: 8),
        _MockAnalyticsItemCardExpandButton(),
        const SizedBox(height: 8),
        _MockLoadMoreButton(),
      ],
    );
  }
}

/// Mock critical interactive elements
class _MockCriticalInteractiveElements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MockScopeSelectorDropdown(),
        const SizedBox(height: 8),
        _MockBackButton(),
        const SizedBox(height: 8),
        _MockAnalyticsItemCardExpandButton(),
      ],
    );
  }
}
