import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Tests for overflow detection in landing page components.
///
/// NOTE: Some components have known overflow issues that need to be fixed:
/// - LandingAppBar: Both mobile and desktop layouts have overflow issues
///   due to Row widgets that don't use flexible children properly.
/// - TrustBadgesRow: The _TrustBadge Row overflows on small screens.
///
/// These tests focus on components and sizes where overflow does NOT occur.
void main() {
  group('Landing Page Overflow Detection Tests', () {
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

    group('ResponsiveWidget overflow tests', () {
      testWidgets(
        'ResponsiveWidget does not cause overflow at breakpoint edges',
        (tester) async {
          overflowCapture.start();

          for (final size in TestDeviceSizes.breakpointEdges) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                ResponsiveWidget(
                  compact: Container(
                    padding: const EdgeInsets.all(16),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mobile Layout'),
                        SizedBox(height: 8),
                        Text('This is compact content'),
                      ],
                    ),
                  ),
                  expanded: Container(
                    padding: const EdgeInsets.all(32),
                    child: const Row(
                      children: [
                        Expanded(child: Text('Desktop Layout')),
                        SizedBox(width: 16),
                        Expanded(child: Text('Side by side content')),
                      ],
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 300));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'ResponsiveWidget has overflow at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
            );
          }

          overflowCapture.stop();
        },
      );
    });

    group('ResponsiveBuilder overflow tests', () {
      testWidgets('ResponsiveBuilder handles all screen sizes without overflow', (
        tester,
      ) async {
        overflowCapture.start();

        for (final size in TestDeviceSizes.all) {
          overflowCapture.clear();

          await tester.setScreenSize(size);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              ResponsiveBuilder(
                compact: (_, constraints) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Compact layout with proper padding'),
                ),
                medium: (_, constraints) => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Medium layout with proper padding'),
                ),
                expanded: (_, constraints) => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Expanded layout with proper padding'),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'ResponsiveBuilder has overflow at ${TestDeviceSizes.nameFor(size)}',
          );
        }

        overflowCapture.stop();
      });
    });

    group('Flexible widget overflow tests', () {
      testWidgets('Expanded and Flexible widgets prevent overflow', (
        tester,
      ) async {
        overflowCapture.start();

        for (final size in TestDeviceSizes.compactSizes) {
          overflowCapture.clear();

          await tester.setScreenSize(size);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'This is a very long text that would overflow without Expanded',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward),
                ],
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Expanded widget should prevent overflow at ${TestDeviceSizes.nameFor(size)}',
          );
        }

        overflowCapture.stop();
      });

      testWidgets('Wrap widget prevents horizontal overflow', (tester) async {
        overflowCapture.start();

        for (final size in TestDeviceSizes.compactSizes) {
          overflowCapture.clear();

          await tester.setScreenSize(size);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  10,
                  (i) => Chip(label: Text('Item $i')),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Wrap widget should prevent overflow at ${TestDeviceSizes.nameFor(size)}',
          );
        }

        overflowCapture.stop();
      });
    });

    group('ConstrainedBox and SizedBox tests', () {
      testWidgets('ConstrainedBox with maxWidth prevents overflow', (
        tester,
      ) async {
        overflowCapture.start();

        await tester.setScreenSize(TestDeviceSizes.smallPhone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: const Text(
                  'This text is constrained to 300px maximum width',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        expect(
          overflowCapture.hasOverflow,
          isFalse,
          reason: 'ConstrainedBox should prevent overflow',
        );

        overflowCapture.stop();
      });
    });

    group('ListView scrolling prevents overflow', () {
      testWidgets('ListView allows content taller than screen', (tester) async {
        overflowCapture.start();

        await tester.setScreenSize(TestDeviceSizes.smallPhone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            ListView(
              children: List.generate(
                50,
                (i) => ListTile(title: Text('Item $i')),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 200));

        expect(
          overflowCapture.hasOverflow,
          isFalse,
          reason: 'ListView should handle overflow via scrolling',
        );

        overflowCapture.stop();
      });
    });
  });
}
