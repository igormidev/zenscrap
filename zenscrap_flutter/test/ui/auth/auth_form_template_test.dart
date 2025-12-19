import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Form template functionality tests for auth components.
///
/// Tests verify that:
/// 1. Form fields render correctly at all screen sizes
/// 2. Form validation works properly
/// 3. Submit button is disabled during loading
/// 4. Responsive padding and spacing are applied
void main() {
  group('Auth Form Template Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('Form Field Rendering', () {
      testWidgets(
        'form fields render correctly at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoginForm(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find form fields
          expect(find.byType(TextFormField), findsNWidgets(2));
          expect(find.text('Email'), findsOneWidget);
          expect(find.text('Password'), findsOneWidget);
          expect(find.byType(FilledButton), findsOneWidget);
        },
      );

      testWidgets(
        'form fields render correctly at 375px (iPhone)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoginForm(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byType(TextFormField), findsNWidgets(2));
          expect(find.byType(FilledButton), findsOneWidget);
        },
      );

      testWidgets(
        'form fields render correctly at desktop size',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoginForm(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byType(TextFormField), findsNWidgets(2));
          expect(find.byType(FilledButton), findsOneWidget);
        },
      );

      testWidgets(
        'sign-up form renders all 4 fields correctly',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockSignUpForm(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byType(TextFormField), findsNWidgets(4));
          expect(find.text('Name'), findsOneWidget);
          expect(find.text('Email'), findsOneWidget);
          expect(find.text('Password'), findsOneWidget);
          expect(find.text('Confirm Password'), findsOneWidget);
        },
      );
    });

    group('Form Validation', () {
      testWidgets(
        'shows validation error for empty email',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoginFormWithValidation(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Tap submit without entering data
          await tester.tap(find.byType(FilledButton));
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Should show validation error
          expect(find.text('Email is required'), findsOneWidget);
        },
      );

      testWidgets(
        'shows validation error for invalid email format',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoginFormWithValidation(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Enter invalid email
          await tester.enterText(
            find.byKey(const Key('email_field')),
            'invalid-email',
          );
          await tester.tap(find.byType(FilledButton));
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Should show validation error
          expect(find.text('Invalid email format'), findsOneWidget);
        },
      );

      testWidgets(
        'shows validation error for empty password',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoginFormWithValidation(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Enter valid email but no password
          await tester.enterText(
            find.byKey(const Key('email_field')),
            'test@example.com',
          );
          await tester.tap(find.byType(FilledButton));
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Should show password validation error
          expect(find.text('Password is required'), findsOneWidget);
        },
      );

      testWidgets(
        'shows validation error for password mismatch in sign-up',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockSignUpFormWithValidation(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Fill all fields with mismatched passwords
          await tester.enterText(
            find.byKey(const Key('name_field')),
            'Test User',
          );
          await tester.enterText(
            find.byKey(const Key('email_field')),
            'test@example.com',
          );
          await tester.enterText(
            find.byKey(const Key('password_field')),
            'Password123!',
          );
          await tester.enterText(
            find.byKey(const Key('confirm_password_field')),
            'DifferentPassword!',
          );
          await tester.tap(find.byType(FilledButton));
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Should show mismatch error
          expect(find.text('Passwords do not match'), findsOneWidget);
        },
      );

      testWidgets(
        'form validates successfully with valid data',
        (tester) async {
          bool formSubmitted = false;

          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoginFormWithValidation(
                onSubmit: () => formSubmitted = true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Enter valid data
          await tester.enterText(
            find.byKey(const Key('email_field')),
            'test@example.com',
          );
          await tester.enterText(
            find.byKey(const Key('password_field')),
            'Password123!',
          );
          await tester.tap(find.byType(FilledButton));
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Form should be submitted
          expect(formSubmitted, isTrue);
        },
      );
    });

    group('Submit Button States', () {
      testWidgets(
        'submit button is enabled by default',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoginForm(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final button = tester.widget<FilledButton>(
            find.byType(FilledButton),
          );
          expect(button.onPressed, isNotNull);
        },
      );

      testWidgets(
        'submit button shows loading indicator when loading',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoginFormWithLoading(isLoading: true),
            ),
          );
          // Use pump instead of pumpAndSettle because CircularProgressIndicator
          // is an infinite animation that would cause pumpAndSettle to timeout
          await tester.pump(const Duration(milliseconds: 200));

          // Should show loading indicator
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          expect(find.text('Log In'), findsNothing);
        },
      );

      testWidgets(
        'submit button is disabled when loading',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockLoginFormWithLoading(isLoading: true),
            ),
          );
          // Use pump instead of pumpAndSettle because CircularProgressIndicator
          // is an infinite animation that would cause pumpAndSettle to timeout
          await tester.pump(const Duration(milliseconds: 200));

          final button = tester.widget<FilledButton>(
            find.byType(FilledButton),
          );
          expect(button.onPressed, isNull);
        },
      );
    });

    group('Responsive Spacing', () {
      testWidgets(
        'form uses compact spacing on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockFormWithResponsiveSpacing(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the spacing SizedBox
          final spacingBoxes = tester.widgetList<SizedBox>(
            find.byKey(const Key('item_spacing')),
          );

          for (final box in spacingBoxes) {
            expect(
              box.height,
              equals(12.0),
              reason: 'Compact spacing should be 12px',
            );
          }
        },
      );

      testWidgets(
        'form uses expanded spacing on desktop',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockFormWithResponsiveSpacing(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the spacing SizedBox
          final spacingBoxes = tester.widgetList<SizedBox>(
            find.byKey(const Key('item_spacing')),
          );

          for (final box in spacingBoxes) {
            expect(
              box.height,
              equals(16.0),
              reason: 'Expanded spacing should be 16px',
            );
          }
        },
      );
    });

    group('Password Visibility Toggle', () {
      testWidgets(
        'password field starts with obscured icon',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockPasswordFieldWithVisibilityToggle(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Initially should show visibility_off icon (text is obscured)
          expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        },
      );

      testWidgets(
        'password visibility can be toggled',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockPasswordFieldWithVisibilityToggle(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Initially obscured
          expect(find.byIcon(Icons.visibility_off), findsOneWidget);

          // Tap to show password
          await tester.tap(find.byType(IconButton));
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Now visible
          expect(find.byIcon(Icons.visibility), findsOneWidget);

          // Tap to hide password again
          await tester.tap(find.byType(IconButton));
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Back to obscured
          expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        },
      );
    });

    group('Form Scrolling', () {
      testWidgets(
        'form is scrollable when content exceeds screen',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockSignUpForm(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find ListView
          expect(find.byType(ListView), findsOneWidget);

          // Should be able to scroll
          await tester.drag(find.byType(ListView), const Offset(0, -200));
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Submit button should still be findable after scroll
          expect(find.byType(FilledButton), findsOneWidget);
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Basic mock login form
class _MockLoginForm extends StatelessWidget {
  const _MockLoginForm();

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
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: context.responsiveValue(compact: 52.0, expanded: 48.0),
          child: FilledButton(
            onPressed: () {},
            child: const Text('Log In'),
          ),
        ),
      ],
    );
  }
}

/// Mock sign-up form with 4 fields
class _MockSignUpForm extends StatelessWidget {
  const _MockSignUpForm();

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
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: context.responsiveValue(compact: 52.0, expanded: 48.0),
          child: FilledButton(
            onPressed: () {},
            child: const Text('Sign Up'),
          ),
        ),
      ],
    );
  }
}

/// Mock login form with validation
class _MockLoginFormWithValidation extends StatefulWidget {
  final VoidCallback? onSubmit;

  const _MockLoginFormWithValidation({this.onSubmit});

  @override
  State<_MockLoginFormWithValidation> createState() =>
      _MockLoginFormWithValidationState();
}

class _MockLoginFormWithValidationState
    extends State<_MockLoginFormWithValidation> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            key: const Key('email_field'),
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Invalid email format';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('password_field'),
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSubmit?.call();
                }
              },
              child: const Text('Log In'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock sign-up form with validation
class _MockSignUpFormWithValidation extends StatefulWidget {
  const _MockSignUpFormWithValidation();

  @override
  State<_MockSignUpFormWithValidation> createState() =>
      _MockSignUpFormWithValidationState();
}

class _MockSignUpFormWithValidationState
    extends State<_MockSignUpFormWithValidation> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            key: const Key('name_field'),
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('email_field'),
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('password_field'),
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: const Key('confirm_password_field'),
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () {
                _formKey.currentState!.validate();
              },
              child: const Text('Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock login form with loading state
class _MockLoginFormWithLoading extends StatelessWidget {
  final bool isLoading;

  const _MockLoginFormWithLoading({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: isLoading ? null : () {},
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Log In'),
          ),
        ),
      ],
    );
  }
}

/// Mock form with responsive spacing
class _MockFormWithResponsiveSpacing extends StatelessWidget {
  const _MockFormWithResponsiveSpacing();

  @override
  Widget build(BuildContext context) {
    final itemSpacing = context.responsiveValue(
      compact: 12.0,
      expanded: 16.0,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(key: const Key('item_spacing'), height: itemSpacing),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(key: const Key('item_spacing'), height: itemSpacing),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(key: const Key('item_spacing'), height: itemSpacing),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: () {},
            child: const Text('Log In'),
          ),
        ),
      ],
    );
  }
}

/// Mock password field with visibility toggle
class _MockPasswordFieldWithVisibilityToggle extends StatefulWidget {
  const _MockPasswordFieldWithVisibilityToggle();

  @override
  State<_MockPasswordFieldWithVisibilityToggle> createState() =>
      _MockPasswordFieldWithVisibilityToggleState();
}

class _MockPasswordFieldWithVisibilityToggleState
    extends State<_MockPasswordFieldWithVisibilityToggle> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: 'Password',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() => _obscureText = !_obscureText);
            },
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
            ),
          ),
        ),
      ),
    );
  }
}
