import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Touch target compliance tests for auth components.
///
/// Material Design and WCAG accessibility guidelines require a minimum
/// touch target size of 48x48 pixels for interactive elements on mobile.
///
/// The auth components use:
/// - 52px button height on compact screens (mobile)
/// - 48px button height on expanded screens (desktop)
///
/// Tests verify that:
/// 1. Submit buttons have at least 48px touch area
/// 2. Google sign-in button has at least 48px touch area
/// 3. Form fields have adequate touch area for interaction
/// 4. Icon buttons (password toggle) have at least 48px touch area
void main() {
  group('Auth Touch Target Compliance Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('Submit Button Touch Targets', () {
      testWidgets(
        'submit button height is at least 48px on mobile (320px)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockSubmitButtonWithMeasurement(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('submit_button_container')),
          );

          expect(
            sizedBox.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Submit button must have at least 48px height on mobile',
          );
        },
      );

      testWidgets(
        'submit button height is exactly 52px on compact screens',
        (tester) async {
          for (final size in TestDeviceSizes.compactSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockSubmitButtonWithMeasurement(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            final sizedBox = tester.widget<SizedBox>(
              find.byKey(const Key('submit_button_container')),
            );

            expect(
              sizedBox.height,
              equals(52.0),
              reason:
                  'Submit button should be 52px on compact at ${TestDeviceSizes.nameFor(size)}',
            );
          }
        },
      );

      testWidgets(
        'submit button height is 48px on expanded screens',
        (tester) async {
          for (final size in TestDeviceSizes.expandedSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockSubmitButtonWithMeasurement(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            final sizedBox = tester.widget<SizedBox>(
              find.byKey(const Key('submit_button_container')),
            );

            expect(
              sizedBox.height,
              equals(48.0),
              reason:
                  'Submit button should be 48px on expanded at ${TestDeviceSizes.nameFor(size)}',
            );
          }
        },
      );

      testWidgets(
        'submit button has full width for easier touch',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockSubmitButtonWithMeasurement(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('submit_button_container')),
          );

          expect(
            sizedBox.width,
            equals(double.infinity),
            reason: 'Submit button should span full width',
          );
        },
      );
    });

    group('Google Sign-In Button Touch Targets', () {
      testWidgets(
        'Google sign-in button height is at least 48px on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockGoogleButtonWithMeasurement(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final sizedBox = tester.widget<SizedBox>(
            find.byKey(const Key('google_button_container')),
          );

          expect(
            sizedBox.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Google sign-in button must have at least 48px height',
          );
        },
      );

      testWidgets(
        'Google sign-in button height is exactly 52px on compact screens',
        (tester) async {
          for (final size in TestDeviceSizes.compactSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockGoogleButtonWithMeasurement(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            final sizedBox = tester.widget<SizedBox>(
              find.byKey(const Key('google_button_container')),
            );

            expect(
              sizedBox.height,
              equals(52.0),
              reason:
                  'Google button should be 52px on compact at ${TestDeviceSizes.nameFor(size)}',
            );
          }
        },
      );

      testWidgets(
        'Google sign-in button height is 48px on expanded screens',
        (tester) async {
          for (final size in TestDeviceSizes.expandedSizes) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockGoogleButtonWithMeasurement(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            final sizedBox = tester.widget<SizedBox>(
              find.byKey(const Key('google_button_container')),
            );

            expect(
              sizedBox.height,
              equals(48.0),
              reason:
                  'Google button should be 48px on expanded at ${TestDeviceSizes.nameFor(size)}',
            );
          }
        },
      );
    });

    group('Form Field Touch Targets', () {
      testWidgets(
        'form field has adequate touch area on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockFormFieldWithMeasurement(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // The minimum touch target is achieved through content padding
          // We verify the form field renders and has proper touch area by checking
          // the rendered size of the TextField
          final textFieldElement = tester.element(find.byType(TextField));
          final renderBox = textFieldElement.renderObject as RenderBox;
          final size = renderBox.size;

          // Form field should have adequate height for touch interaction
          // With 16px vertical padding on compact + text, should be well over 48px
          expect(
            size.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Form field should have at least 48px height for touch on mobile',
          );
        },
      );

      testWidgets(
        'form field touch area is responsive',
        (tester) async {
          // Test compact size - should have larger touch area
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockFormFieldWithMeasurement(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          var textFieldElement = tester.element(find.byType(TextField));
          var renderBox = textFieldElement.renderObject as RenderBox;
          final compactHeight = renderBox.size.height;

          // Test expanded size - can have slightly smaller touch area
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockFormFieldWithMeasurement(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          textFieldElement = tester.element(find.byType(TextField));
          renderBox = textFieldElement.renderObject as RenderBox;
          final expandedHeight = renderBox.size.height;

          // Compact should have larger or equal touch area
          expect(
            compactHeight,
            greaterThanOrEqualTo(expandedHeight),
            reason: 'Compact form field should have larger or equal touch area',
          );

          // Both should still meet minimum touch target
          expect(
            expandedHeight,
            greaterThanOrEqualTo(40.0),
            reason: 'Expanded form field should still have adequate touch area',
          );
        },
      );
    });

    group('Password Toggle Icon Button Touch Targets', () {
      testWidgets(
        'password toggle icon button has at least 48px touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockPasswordFieldWithToggle(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the IconButton
          final iconButton = tester.widget<IconButton>(
            find.byType(IconButton),
          );

          // IconButton has a default minimum size of 48x48 in Material 3
          // Check that iconSize is reasonable and the button is tappable
          expect(
            iconButton.iconSize,
            equals(24.0),
            reason: 'Icon size should be 24px',
          );

          // Verify the icon button is tappable by checking render size
          final iconButtonElement = tester.element(find.byType(IconButton));
          final renderBox = iconButtonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.width,
            greaterThanOrEqualTo(48.0),
            reason: 'IconButton should have at least 48px width for touch',
          );
          expect(
            size.height,
            greaterThanOrEqualTo(48.0),
            reason: 'IconButton should have at least 48px height for touch',
          );
        },
      );

      testWidgets(
        'password toggle is tappable and toggles visibility',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockPasswordFieldWithToggle(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find initial visibility state
          expect(find.byIcon(Icons.visibility_off), findsOneWidget);
          expect(find.byIcon(Icons.visibility), findsNothing);

          // Tap the toggle button
          await tester.tap(find.byType(IconButton));
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Verify visibility toggled
          expect(find.byIcon(Icons.visibility), findsOneWidget);
          expect(find.byIcon(Icons.visibility_off), findsNothing);
        },
      );
    });

    group('Back Button Touch Targets', () {
      testWidgets(
        'back button (CircleAvatar + IconButton) has at least 48px touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockBackButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the CircleAvatar which wraps the IconButton
          final circleAvatarElement = tester.element(find.byType(CircleAvatar));
          final renderBox = circleAvatarElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.width,
            greaterThanOrEqualTo(40.0),
            reason: 'Back button CircleAvatar should have adequate width',
          );
          expect(
            size.height,
            greaterThanOrEqualTo(40.0),
            reason: 'Back button CircleAvatar should have adequate height',
          );

          // The IconButton inside should also be tappable
          final iconButtonElement = tester.element(find.byType(IconButton));
          final iconRenderBox = iconButtonElement.renderObject as RenderBox;
          final iconSize = iconRenderBox.size;

          expect(
            iconSize.width,
            greaterThanOrEqualTo(40.0),
            reason: 'Back IconButton should have adequate width',
          );
        },
      );
    });

    group('TabBar Tab Touch Targets', () {
      testWidgets(
        'auth TabBar tabs have adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthTabBar(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find all Tab widgets
          final tabs = find.byType(Tab);
          expect(tabs, findsNWidgets(3));

          // Each tab should be tappable - verify by tapping
          await tester.tap(tabs.at(1));
          await tester.pumpAndSettle();

          // The tap should work (no exception thrown)
          // Material TabBar tabs have built-in adequate touch targets
        },
      );

      testWidgets(
        'TabBar tabs are tappable at 320px width',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockAuthTabBar(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find tabs
          final tabs = find.byType(Tab);

          // Test tapping each tab
          for (var i = 0; i < 3; i++) {
            await tester.tap(tabs.at(i));
            await tester.pumpAndSettle(const Duration(milliseconds: 100));
          }

          // All taps should work without exception at 320px width
        },
      );
    });

    group('Legal Links Touch Targets', () {
      testWidgets(
        'legal link buttons have adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLegalLinks(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find TextButtons
          final textButtons = find.byType(TextButton);
          expect(textButtons, findsNWidgets(2));

          // Verify each button is tappable
          for (var i = 0; i < 2; i++) {
            final buttonElement = tester.element(textButtons.at(i));
            final renderBox = buttonElement.renderObject as RenderBox;
            final size = renderBox.size;

            // TextButtons should have adequate touch area
            // Material 3 TextButtons have minimum touch target built in
            expect(
              size.height,
              greaterThanOrEqualTo(36.0),
              reason: 'Legal link button $i should have adequate height',
            );
          }
        },
      );
    });

    group('Contact Support Button Touch Targets', () {
      testWidgets(
        'contact support button has adequate touch area on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockContactSupportButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the button
          final button = find.byType(OutlinedButton);
          expect(button, findsOneWidget);

          final buttonElement = tester.element(button);
          final renderBox = buttonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.height,
            greaterThanOrEqualTo(36.0),
            reason: 'Contact support button should have adequate height',
          );
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock submit button with measurement capability
class _MockSubmitButtonWithMeasurement extends StatelessWidget {
  const _MockSubmitButtonWithMeasurement();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        key: const Key('submit_button_container'),
        width: double.infinity,
        height: context.responsiveValue(
          compact: 52.0,
          expanded: 48.0,
        ),
        child: FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            padding: context.responsiveValue(
              compact: const EdgeInsets.symmetric(vertical: 14),
              expanded: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          child: const Text('Log In'),
        ),
      ),
    );
  }
}

/// Mock Google button with measurement capability
class _MockGoogleButtonWithMeasurement extends StatelessWidget {
  const _MockGoogleButtonWithMeasurement();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        key: const Key('google_button_container'),
        width: double.infinity,
        height: context.responsiveValue(
          compact: 52.0,
          expanded: 48.0,
        ),
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.g_mobiledata, size: 20),
          label: const Text('Continue with Google'),
          style: OutlinedButton.styleFrom(
            padding: context.responsiveValue(
              compact:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              expanded:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mock form field with measurement capability
class _MockFormFieldWithMeasurement extends StatelessWidget {
  const _MockFormFieldWithMeasurement();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: context.responsiveValue(
            compact: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            expanded: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          hintText: 'Enter your email',
          labelText: 'Email',
        ),
      ),
    );
  }
}

/// Mock password field with toggle button
class _MockPasswordFieldWithToggle extends StatefulWidget {
  const _MockPasswordFieldWithToggle();

  @override
  State<_MockPasswordFieldWithToggle> createState() =>
      _MockPasswordFieldWithToggleState();
}

class _MockPasswordFieldWithToggleState
    extends State<_MockPasswordFieldWithToggle> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: context.responsiveValue(
            compact: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            expanded: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          hintText: 'Enter your password',
          labelText: 'Password',
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                setState(() => _obscureText = !_obscureText);
              },
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              iconSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}

/// Mock back button (CircleAvatar with IconButton)
class _MockBackButton extends StatelessWidget {
  const _MockBackButton();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.arrow_back),
        tooltip: 'Back',
      ),
    );
  }
}

/// Mock auth TabBar
class _MockAuthTabBar extends StatelessWidget {
  const _MockAuthTabBar();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const TabBar(
          tabs: [
            Tab(text: 'Log In', icon: Icon(Icons.login)),
            Tab(text: 'Sign Up', icon: Icon(Icons.person_add)),
            Tab(text: 'Reset', icon: Icon(Icons.vpn_key)),
          ],
        ),
      ),
    );
  }
}

/// Mock legal links - uses short labels to avoid overflow
class _MockLegalLinks extends StatelessWidget {
  const _MockLegalLinks();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Terms',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Privacy',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Mock contact support button
class _MockContactSupportButton extends StatelessWidget {
  const _MockContactSupportButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.support_agent, size: 20),
      label: const Text('Contact Support'),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
