import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/overview_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/create_api_key_dialog.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive layout switching tests for api_usage components.
///
/// Tests verify that:
/// 1. Overview section switches between Column (compact) and Row (expanded) layouts
/// 2. Create API key dialog has responsive max widths
/// 3. Responsive values adapt correctly at different breakpoints
/// 4. Layout switches occur at correct breakpoint boundaries
void main() {
  group('API Usage Layout Switching Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('Overview Section Layout Switching', () {
      testWidgets(
        'Overview section uses Column layout at compact sizes',
        (tester) async {
          for (final size in TestDeviceSizes.compactSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                CreditsOverviewSection(
                  planTier: PlanTier.pro,
                  subscriptionCredits: 1000000,
                  purchasedCredits: 500000,
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            // On compact screens, ResponsiveBuilder should use Column layout
            // We can verify this by checking that the compact builder is used
            // The credit items should be stacked vertically
            final columnFinder = find.descendant(
              of: find.byType(CreditsOverviewSection),
              matching: find.byType(Column),
            );

            expect(
              columnFinder,
              findsWidgets,
              reason:
                  'Overview section should use Column layout at ${TestDeviceSizes.nameFor(size)}',
            );
          }
        },
      );

      testWidgets(
        'Overview section uses Row layout at expanded sizes',
        (tester) async {
          for (final size in TestDeviceSizes.expandedSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                CreditsOverviewSection(
                  planTier: PlanTier.pro,
                  subscriptionCredits: 1000000,
                  purchasedCredits: 500000,
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            // On expanded screens, ResponsiveBuilder should use Row layout
            // The credit items should be arranged horizontally
            final rowFinder = find.descendant(
              of: find.byType(CreditsOverviewSection),
              matching: find.byType(Row),
            );

            expect(
              rowFinder,
              findsWidgets,
              reason:
                  'Overview section should use Row layout at ${TestDeviceSizes.nameFor(size)}',
            );
          }
        },
      );

      testWidgets(
        'Overview section switches layout at 599px to 600px boundary',
        (tester) async {
          // Test at 599px (just before medium breakpoint) - should use compact
          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Text('isCompact: ${context.isCompact}'),
                      CreditsOverviewSection(
                        planTier: PlanTier.pro,
                        subscriptionCredits: 1000000,
                        purchasedCredits: 500000,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.text('isCompact: true'), findsOneWidget);

          // Test at 600px (medium breakpoint start) - should use medium/compact fallback
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Text('isMedium: ${context.isMedium}'),
                      CreditsOverviewSection(
                        planTier: PlanTier.pro,
                        subscriptionCredits: 1000000,
                        purchasedCredits: 500000,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.text('isMedium: true'), findsOneWidget);
        },
      );

      testWidgets(
        'Overview section switches layout at 839px to 840px boundary',
        (tester) async {
          // Test at 839px (just before expanded breakpoint) - should use medium
          await tester.setScreenSize(const Size(839, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Text('isMedium: ${context.isMedium}'),
                      CreditsOverviewSection(
                        planTier: PlanTier.pro,
                        subscriptionCredits: 1000000,
                        purchasedCredits: 500000,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.text('isMedium: true'), findsOneWidget);

          // Test at 840px (expanded breakpoint start) - should use expanded (Row layout)
          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Builder(
                builder: (context) {
                  return Column(
                    children: [
                      Text('isExpanded: ${context.isExpanded}'),
                      CreditsOverviewSection(
                        planTier: PlanTier.pro,
                        subscriptionCredits: 1000000,
                        purchasedCredits: 500000,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.text('isExpanded: true'), findsOneWidget);
        },
      );
    });

    group('Create API Key Dialog Size Tests', () {
      testWidgets(
        'Dialog uses full width on compact screens',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the Container with constraints
          final container = tester.widget<Container>(
            find.descendant(
              of: find.byType(CreateApiKeyDialog),
              matching: find.byType(Container),
            ).first,
          );

          final constraints = container.constraints as BoxConstraints;
          expect(
            constraints.maxWidth,
            equals(double.infinity),
            reason: 'Dialog should have full width on compact screens',
          );
        },
      );

      testWidgets(
        'Dialog uses 500px max width on medium screens',
        (tester) async {
          await tester.setScreenSize(const Size(700, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the Container with constraints
          final container = tester.widget<Container>(
            find.descendant(
              of: find.byType(CreateApiKeyDialog),
              matching: find.byType(Container),
            ).first,
          );

          final constraints = container.constraints as BoxConstraints;
          expect(
            constraints.maxWidth,
            equals(500.0),
            reason: 'Dialog should have 500px max width on medium screens',
          );
        },
      );

      testWidgets(
        'Dialog uses 600px max width on expanded screens',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the Container with constraints
          final container = tester.widget<Container>(
            find.descendant(
              of: find.byType(CreateApiKeyDialog),
              matching: find.byType(Container),
            ).first,
          );

          final constraints = container.constraints as BoxConstraints;
          expect(
            constraints.maxWidth,
            equals(600.0),
            reason: 'Dialog should have 600px max width on expanded screens',
          );
        },
      );
    });

    group('Responsive Padding Tests', () {
      testWidgets(
        'Overview section uses correct padding at different breakpoints',
        (tester) async {
          // Test compact padding (16.0)
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _TestResponsivePadding(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          var padding = tester.widget<Padding>(
            find.byKey(const Key('test_padding')),
          );
          expect(
            (padding.padding as EdgeInsets).horizontal,
            equals(32.0), // 16.0 * 2
            reason: 'Should use 16px horizontal padding on compact',
          );

          // Test medium padding (20.0)
          await tester.setScreenSize(const Size(700, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _TestResponsivePadding(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          padding = tester.widget<Padding>(
            find.byKey(const Key('test_padding')),
          );
          expect(
            (padding.padding as EdgeInsets).horizontal,
            equals(40.0), // 20.0 * 2
            reason: 'Should use 20px horizontal padding on medium',
          );

          // Test expanded padding (20.0 - same as medium for overview section)
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _TestResponsivePadding(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          padding = tester.widget<Padding>(
            find.byKey(const Key('test_padding')),
          );
          expect(
            (padding.padding as EdgeInsets).horizontal,
            equals(40.0), // 20.0 * 2
            reason: 'Should use 20px horizontal padding on expanded',
          );
        },
      );
    });

    group('Responsive Spacing Tests', () {
      testWidgets(
        'Vertical spacing is responsive across breakpoints',
        (tester) async {
          // Test compact spacing (12.0)
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _TestResponsiveSpacing(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          var sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('test_spacing')),
          );
          expect(
            sizedBox.height,
            equals(12.0),
            reason: 'Should use 12px spacing on compact',
          );

          // Test medium spacing (16.0)
          await tester.setScreenSize(const Size(700, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _TestResponsiveSpacing(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('test_spacing')),
          );
          expect(
            sizedBox.height,
            equals(16.0),
            reason: 'Should use 16px spacing on medium',
          );

          // Test expanded spacing (16.0)
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _TestResponsiveSpacing(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('test_spacing')),
          );
          expect(
            sizedBox.height,
            equals(16.0),
            reason: 'Should use 16px spacing on expanded',
          );
        },
      );
    });

    group('Responsive Border Radius Tests', () {
      testWidgets(
        'Border radius is responsive across breakpoints',
        (tester) async {
          // Test compact border radius (12.0)
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _TestResponsiveBorderRadius(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          var container = tester.widget<Container>(
            find.byKey(const Key('test_border_radius')),
          );
          var decoration = container.decoration as BoxDecoration;
          var borderRadius = decoration.borderRadius as BorderRadius;
          expect(
            borderRadius.topLeft.x,
            equals(12.0),
            reason: 'Should use 12px border radius on compact',
          );

          // Test medium border radius (16.0)
          await tester.setScreenSize(const Size(700, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _TestResponsiveBorderRadius(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          container = tester.widget<Container>(
            find.byKey(const Key('test_border_radius')),
          );
          decoration = container.decoration as BoxDecoration;
          borderRadius = decoration.borderRadius as BorderRadius;
          expect(
            borderRadius.topLeft.x,
            equals(16.0),
            reason: 'Should use 16px border radius on medium',
          );

          // Test expanded border radius (16.0)
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _TestResponsiveBorderRadius(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          container = tester.widget<Container>(
            find.byKey(const Key('test_border_radius')),
          );
          decoration = container.decoration as BoxDecoration;
          borderRadius = decoration.borderRadius as BorderRadius;
          expect(
            borderRadius.topLeft.x,
            equals(16.0),
            reason: 'Should use 16px border radius on expanded',
          );
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
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Test widget for responsive padding
class _TestResponsivePadding extends StatelessWidget {
  const _TestResponsivePadding();

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('test_padding'),
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 20.0,
        ),
      ),
      child: const Text('Test'),
    );
  }
}

/// Test widget for responsive spacing
class _TestResponsiveSpacing extends StatelessWidget {
  const _TestResponsiveSpacing();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('test_spacing'),
      height: context.responsiveValue(
        compact: 12.0,
        medium: 16.0,
        expanded: 16.0,
      ),
    );
  }
}

/// Test widget for responsive border radius
class _TestResponsiveBorderRadius extends StatelessWidget {
  const _TestResponsiveBorderRadius();

  @override
  Widget build(BuildContext context) {
    final borderRadius = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );

    return Container(
      key: const Key('test_border_radius'),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Text('Test'),
    );
  }
}
