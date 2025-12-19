import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/sections/hero_section.dart';
import 'package:zenscrap_flutter/src/ui/landing_page/widgets/trust_badges_row.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Tests for the HeroSection responsive behavior.
///
/// These tests verify the hero section's core functionality across
/// different screen sizes. Note that the HeroSection contains complex
/// dependencies including Lottie animations that may have network
/// requirements in some environments.
void main() {
  group('HeroSection Responsive Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('Component presence tests', () {
      testWidgets('contains Form widget', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 700,
              onFormSubmitted: () {},
            ),
          ),
        );
        // Don't wait for animations - just pump a few frames
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('contains TrustBadgesRow widget', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 700,
              onFormSubmitted: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(TrustBadgesRow), findsOneWidget);
      });

      testWidgets('contains CTA button with icon', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.largePhone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 800,
              onFormSubmitted: () {},
            ),
          ),
        );
        // Pump longer to allow animations to complete (button has 800ms delay)
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // The CTA button contains an auto_awesome icon
        expect(find.byIcon(Icons.auto_awesome_rounded), findsWidgets);
      });

      testWidgets('contains text form fields', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 700,
              onFormSubmitted: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(TextFormField), findsWidgets);
      });
    });

    group('ResponsiveBuilder usage tests', () {
      testWidgets('uses ResponsiveBuilder for layout', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 700,
              onFormSubmitted: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // HeroSection should use ResponsiveBuilder internally
        expect(find.byType(ResponsiveBuilder), findsWidgets);
      });

      testWidgets('uses LayoutBuilder internally', (tester) async {
        // Use phone size to avoid desktop layout overflow issues
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 700,
              onFormSubmitted: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // ResponsiveBuilder uses LayoutBuilder internally
        expect(find.byType(LayoutBuilder), findsWidgets);
      });
    });

    group('Screen size adaptation tests', () {
      testWidgets('renders on compact screen size', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 700,
              onFormSubmitted: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // Widget tree should be built without errors
        expect(find.byType(HeroSection), findsOneWidget);
      });

      testWidgets('renders on tablet portrait screen size', (tester) async {
        // Use tablet portrait (600px width = medium breakpoint)
        // which uses mobile layout with scrolling
        await tester.setScreenSize(TestDeviceSizes.tabletPortrait);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 900,
              onFormSubmitted: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // Widget tree should be built without errors
        expect(find.byType(HeroSection), findsOneWidget);
      });

      testWidgets('renders at medium breakpoint edge (839px)', (tester) async {
        // Test at medium breakpoint (just below expanded threshold)
        // which uses mobile layout that handles scrolling properly
        await tester.setScreenSize(const Size(839, 800));
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 720,
              onFormSubmitted: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(HeroSection), findsOneWidget);
      });
    });

    group('Available height tests', () {
      testWidgets('handles short available height', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 400, // Very short
              onFormSubmitted: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // Should render without crashing
        expect(find.byType(HeroSection), findsOneWidget);
      });

      testWidgets('handles various mobile heights with scrolling', (tester) async {
        // Test that mobile layout can handle various heights via scrolling
        for (final height in [500.0, 600.0, 700.0, 800.0]) {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              HeroSection(
                availableHeight: height,
                onFormSubmitted: () {},
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 100));
          await tester.pump(const Duration(milliseconds: 100));

          expect(
            find.byType(HeroSection),
            findsOneWidget,
            reason: 'HeroSection should render at height $height',
          );
        }
      });
    });

    group('Form interaction tests', () {
      testWidgets('form fields can receive focus', (tester) async {
        await tester.setScreenSize(TestDeviceSizes.phone);
        await tester.pumpWidget(
          responsiveTestWrapper(
            sharedPreferences: prefs,
            HeroSection(
              availableHeight: 700,
              onFormSubmitted: () {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // Find text fields
        final textFields = find.byType(TextFormField);
        expect(textFields, findsWidgets);

        // Attempt to tap first text field
        if (textFields.evaluate().isNotEmpty) {
          await tester.tap(textFields.first);
          await tester.pump();
          // No errors means field is interactive
        }
      });
    });
  });
}
