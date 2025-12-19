import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive overflow detection tests for auth components.
///
/// Tests verify that auth-related widgets do not cause overflow errors
/// at various screen sizes, especially at the critical 320px width
/// and at breakpoint edges (599, 600, 839, 840).
///
/// Test Categories:
/// 1. Form field overflow tests
/// 2. Button overflow tests
/// 3. Legal links footer overflow tests
/// 4. Auth container layout overflow tests
void main() {
  group('Auth Components Overflow Detection Tests', () {
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

    group('Auth Form Field Overflow Tests', () {
      testWidgets(
        'Form fields do not overflow at 320px (smallest phone)',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              // Simulates auth form field layout with responsive padding
              _MockAuthFormField(
                horizontalPadding: 16.0, // compact padding
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Auth form field has overflow at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'Form fields with password toggle do not overflow at any screen size',
        (tester) async {
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockPasswordFieldWithToggle(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Password field with toggle overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
            );
          }

          overflowCapture.stop();
        },
      );

      testWidgets(
        'Form fields render correctly at breakpoint edges',
        (tester) async {
          overflowCapture.start();

          for (final size in TestDeviceSizes.breakpointEdges) {
            overflowCapture.clear();

            // Determine padding based on breakpoint
            final width = size.width;
            final horizontalPadding = width < 600
                ? 16.0
                : width < 840
                    ? 20.0
                    : 24.0;

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockAuthFormField(horizontalPadding: horizontalPadding),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Form field overflows at breakpoint edge ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
            );
          }

          overflowCapture.stop();
        },
      );
    });

    group('Auth Submit Button Overflow Tests', () {
      testWidgets(
        'Submit button with responsive height does not overflow at any size',
        (tester) async {
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockSubmitButton(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Submit button overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
            );
          }

          overflowCapture.stop();
        },
      );

      testWidgets(
        'Submit button with long text does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockSubmitButton(
                text: 'Create Account and Continue to Dashboard',
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Submit button with long text overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('Google Sign-In Button Overflow Tests', () {
      testWidgets(
        'Google sign-in button does not overflow at any screen size',
        (tester) async {
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockGoogleSignInButton(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Google sign-in button overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
            );
          }

          overflowCapture.stop();
        },
      );

      testWidgets(
        'Google sign-in with divider does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MockDividerWithText(text: 'or'),
                    const SizedBox(height: 16),
                    _MockGoogleSignInButton(),
                  ],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Google sign-in with divider overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('Legal Links Footer Overflow Tests', () {
      testWidgets(
        'Legal links footer does not overflow at any screen size',
        (tester) async {
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockLegalLinksFooter(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Legal links footer overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
            );
          }

          overflowCapture.stop();
        },
      );

      testWidgets(
        'Legal links with long labels do not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLegalLinksFooter(
                termsLabel: 'Terms of Service',
                privacyLabel: 'Privacy Policy',
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Legal links with long labels overflow at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('Auth Layout Container Overflow Tests', () {
      testWidgets(
        'Mobile auth layout does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockMobileAuthLayout(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Mobile auth layout overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'Mobile auth layout does not overflow at 375px (iPhone)',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockMobileAuthLayout(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Mobile auth layout overflows at 375px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'Desktop auth layout does not overflow at 840px (breakpoint)',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDesktopAuthLayout(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Desktop auth layout overflows at 840px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'Desktop auth layout does not overflow at 1200px (desktop)',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDesktopAuthLayout(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Desktop auth layout overflows at 1200px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('Complete Auth Form Overflow Tests', () {
      testWidgets(
        'Complete login form does not overflow at any compact size',
        (tester) async {
          overflowCapture.start();

          for (final size in TestDeviceSizes.compactSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockCompleteLoginForm(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 300));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Complete login form overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
            );
          }

          overflowCapture.stop();
        },
      );

      testWidgets(
        'Complete sign-up form does not overflow at any compact size',
        (tester) async {
          overflowCapture.start();

          for (final size in TestDeviceSizes.compactSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockCompleteSignUpForm(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 300));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Complete sign-up form overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
            );
          }

          overflowCapture.stop();
        },
      );
    });

    group('Splash View Overflow Tests', () {
      testWidgets(
        'Splash view loading indicator does not overflow at any size',
        (tester) async {
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockSplashView(screenWidth: size.width),
              ),
            );
            await tester.pump(const Duration(milliseconds: 100));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Splash view overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
            );
          }

          overflowCapture.stop();
        },
      );
    });

    group('TabBar Overflow Tests', () {
      testWidgets(
        'Auth TabBar does not overflow at any compact size',
        (tester) async {
          overflowCapture.start();

          for (final size in TestDeviceSizes.compactSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockAuthTabBar(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            expect(
              overflowCapture.hasOverflow,
              isFalse,
              reason:
                  'Auth TabBar overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
            );
          }

          overflowCapture.stop();
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock auth form field that simulates the real AuthFormField responsive behavior
class _MockAuthFormField extends StatelessWidget {
  final double horizontalPadding;

  const _MockAuthFormField({
    this.horizontalPadding = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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

/// Mock password field with visibility toggle
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
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 24.0,
        ),
      ),
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

/// Mock submit button that simulates the real _SubmitButton responsive behavior
class _MockSubmitButton extends StatelessWidget {
  final String text;

  const _MockSubmitButton({
    this.text = 'Log In',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 24.0,
        ),
      ),
      child: SizedBox(
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
          child: Text(
            text,
            style: context.responsiveValue(
              compact: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
              expanded: null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

/// Mock Google sign-in button
class _MockGoogleSignInButton extends StatelessWidget {
  const _MockGoogleSignInButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 24.0,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: context.responsiveValue(
          compact: 52.0,
          expanded: 48.0,
        ),
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.g_mobiledata, size: 20),
          label: Text(
            'Continue with Google',
            style: context.responsiveValue(
              compact: Theme.of(context).textTheme.titleSmall,
              expanded: null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          style: OutlinedButton.styleFrom(
            padding: context.responsiveValue(
              compact:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              expanded:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mock divider with text ("or")
class _MockDividerWithText extends StatelessWidget {
  final String text;

  const _MockDividerWithText({this.text = 'or'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

/// Mock legal links footer
/// Note: The real component uses Positioned inside a Stack.
/// For testing purposes, we test the Row content separately.
/// Uses Flexible widgets to prevent overflow with longer labels.
class _MockLegalLinksFooter extends StatelessWidget {
  final String termsLabel;
  final String privacyLabel;

  const _MockLegalLinksFooter({
    this.termsLabel = 'Terms',
    this.privacyLabel = 'Privacy',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        context.responsiveValue(compact: 8.0, expanded: 16.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: TextButton(
              onPressed: () {},
              child: Text(
                termsLabel,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
          ),
          SizedBox(
            width: context.responsiveValue(compact: 8.0, expanded: 16.0),
          ),
          Flexible(
            child: TextButton(
              onPressed: () {},
              child: Text(
                privacyLabel,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock mobile auth layout
class _MockMobileAuthLayout extends StatelessWidget {
  const _MockMobileAuthLayout();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Compact animation placeholder
          Container(
            width: double.maxFinite,
            height: 160,
            color: Colors.grey[200],
            child: const Center(child: Text('Animation')),
          ),
          // Form section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to ZenScrap',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  // Auth form container
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: _MockCompleteLoginForm(),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock desktop auth layout
class _MockDesktopAuthLayout extends StatelessWidget {
  const _MockDesktopAuthLayout();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1400),
      child: Row(
        children: [
          const SizedBox(width: 20),
          // Left side - Form section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Welcome to ZenScrap',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 20),
                  // Auth form
                  SizedBox(
                    height: 300,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: _MockCompleteLoginForm(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right side - Animation placeholder
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.grey[200],
                    child: const Center(child: Text('Animation')),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock complete login form
class _MockCompleteLoginForm extends StatelessWidget {
  const _MockCompleteLoginForm();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 24.0,
        ),
      ),
      children: [
        SizedBox(
          height: context.responsiveValue(compact: 12.0, expanded: 16.0),
        ),
        // Email field
        TextFormField(
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
        SizedBox(
          height: context.responsiveValue(compact: 12.0, expanded: 16.0),
        ),
        // Password field
        TextFormField(
          obscureText: true,
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
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: null,
                icon: Icon(Icons.visibility_off),
                iconSize: 24,
              ),
            ),
          ),
        ),
        SizedBox(
          height: context.responsiveValue(compact: 12.0, expanded: 16.0),
        ),
        // Submit button
        SizedBox(
          width: double.infinity,
          height: context.responsiveValue(
            compact: 52.0,
            expanded: 48.0,
          ),
          child: FilledButton(
            onPressed: () {},
            child: const Text('Log In'),
          ),
        ),
        const SizedBox(height: 8),
        // Google sign-in
        _MockDividerWithText(),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: context.responsiveValue(
            compact: 52.0,
            expanded: 48.0,
          ),
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.g_mobiledata, size: 20),
            label: Text(
              'Continue with Google',
              overflow: TextOverflow.ellipsis,
              style: context.responsiveValue(
                compact: Theme.of(context).textTheme.titleSmall,
                expanded: null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Mock complete sign-up form with 4 fields
class _MockCompleteSignUpForm extends StatelessWidget {
  const _MockCompleteSignUpForm();

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 24.0,
    );
    final itemSpacing = context.responsiveValue(compact: 12.0, expanded: 16.0);

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      children: [
        SizedBox(height: itemSpacing),
        // User name field
        TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            contentPadding: context.responsiveValue(
              compact: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              expanded: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            hintText: 'Enter your name',
            labelText: 'Name',
          ),
        ),
        SizedBox(height: itemSpacing),
        // Email field
        TextFormField(
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
        SizedBox(height: itemSpacing),
        // Password field
        TextFormField(
          obscureText: true,
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
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: null,
                icon: Icon(Icons.visibility_off),
                iconSize: 24,
              ),
            ),
          ),
        ),
        SizedBox(height: itemSpacing),
        // Confirm password field
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            contentPadding: context.responsiveValue(
              compact: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              expanded: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            hintText: 'Confirm your password',
            labelText: 'Confirm Password',
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: null,
                icon: Icon(Icons.visibility_off),
                iconSize: 24,
              ),
            ),
          ),
        ),
        SizedBox(height: itemSpacing),
        // Submit button
        SizedBox(
          width: double.infinity,
          height: context.responsiveValue(
            compact: 52.0,
            expanded: 48.0,
          ),
          child: FilledButton(
            onPressed: () {},
            child: const Text('Sign Up'),
          ),
        ),
      ],
    );
  }
}

/// Mock splash view with responsive loading indicator
class _MockSplashView extends StatelessWidget {
  final double screenWidth;

  const _MockSplashView({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    // Simulate responsive value based on screen width
    final indicatorSize = screenWidth < 600 ? 36.0 : 48.0;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: const CircularProgressIndicator(),
        ),
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
