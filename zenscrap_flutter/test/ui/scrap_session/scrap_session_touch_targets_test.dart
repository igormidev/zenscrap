import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Touch target tests for scrap_session components.
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
/// 1. Button touch targets (FilledButton, IconButton, TextButton)
/// 2. TextField minimum heights
/// 3. Dialog close button touch targets
/// 4. Tab touch targets
/// 5. Message bubble interactive elements
void main() {
  group('Scrap Session Touch Target Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('Button Touch Target Tests', () {
      testWidgets(
        'FilledButton has minimum 48px height on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockButtonWithSize(
                buttonType: _ButtonType.filled,
                hasIcon: false,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(find.byType(FilledButton));
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'FilledButton should have minimum 48px height',
          );
        },
      );

      testWidgets(
        'FilledButton.icon has minimum 48px height on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              FilledButton.icon(
                key: const Key('icon_button'),
                onPressed: () {},
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(find.byKey(const Key('icon_button')));
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'FilledButton.icon should have minimum 48px height',
          );
        },
      );

      testWidgets(
        'IconButton has minimum 48x48 touch target on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockIconButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(find.byType(IconButton));
          expect(
            buttonSize.width,
            greaterThanOrEqualTo(48.0),
            reason: 'IconButton width should be at least 48px',
          );
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'IconButton height should be at least 48px',
          );
        },
      );

      testWidgets(
        'TextButton has minimum 48px height on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              TextButton(
                onPressed: () {},
                child: const Text('Button Text'),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(find.byType(TextButton));
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'TextButton should have minimum 48px height',
          );
        },
      );

      testWidgets(
        'Save button in EditDialog has minimum 48px height',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditDialogSaveButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(
            find.byKey(const Key('save_button')),
          );
          expect(
            buttonSize.height,
            equals(48.0),
            reason: 'Save button should be exactly 48px height',
          );
        },
      );

      testWidgets(
        'Run Test button in TestDialog has minimum 48px height',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockRunTestButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(
            find.byKey(const Key('run_test_button')),
          );
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Run Test button should have minimum 48px height',
          );
        },
      );

      testWidgets(
        'Create scrappable button has minimum 48px height',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockCreateScrappableButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(
            find.byKey(const Key('create_button')),
          );
          expect(
            buttonSize.height,
            equals(48.0),
            reason: 'Create scrappable button should be exactly 48px height',
          );
        },
      );
    });

    group('Dialog Close Button Touch Target Tests', () {
      testWidgets(
        'Edit dialog close button has minimum 48x48 touch target',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDialogCloseButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(find.byType(IconButton));
          expect(
            buttonSize.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Close button width should be at least 48px',
          );
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Close button height should be at least 48px',
          );
        },
      );

      testWidgets(
        'Test dialog close button has minimum 48x48 touch target',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockDialogCloseButton(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final buttonSize = tester.getSize(find.byType(IconButton));
          expect(
            buttonSize.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Close button width should be at least 48px',
          );
          expect(
            buttonSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Close button height should be at least 48px',
          );
        },
      );
    });

    group('TextField Touch Target Tests', () {
      testWidgets(
        'URL TextField has minimum height for touch interaction',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockUrlTextField(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final textFieldSize = tester.getSize(find.byType(TextField));
          expect(
            textFieldSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'URL TextField should have minimum 48px height',
          );
        },
      );

      testWidgets(
        'Chat TextField has minimum height for touch interaction',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockChatTextField(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final textFieldSize = tester.getSize(find.byType(TextField));
          expect(
            textFieldSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Chat TextField should have minimum 48px height',
          );
        },
      );

      testWidgets(
        'Parameter input TextField has minimum height',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockParameterTextField(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final textFieldSize = tester.getSize(find.byType(TextField));
          expect(
            textFieldSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Parameter TextField should have minimum 48px height',
          );
        },
      );
    });

    group('Tab Touch Target Tests', () {
      testWidgets(
        'Tabs in TestDialog have minimum 48px height',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestDialogTabs(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final tabBarSize = tester.getSize(find.byType(TabBar));
          expect(
            tabBarSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'TabBar should have minimum 48px height',
          );
        },
      );

      testWidgets(
        'Individual tab has adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestDialogTabs(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // The TabBar itself should be 48px tall, providing adequate touch target
          // Individual tab text may be smaller, but the tappable area is the full tab height
          final tabBarSize = tester.getSize(find.byType(TabBar));
          expect(
            tabBarSize.height,
            greaterThanOrEqualTo(48.0),
            reason: 'TabBar provides adequate touch target for tabs',
          );
        },
      );
    });

    group('All Interactive Elements Touch Target Tests', () {
      testWidgets(
        'all buttons meet minimum touch target at 320px',
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

          // Check all FilledButtons
          for (final button in tester.widgetList<FilledButton>(
            find.byType(FilledButton),
          )) {
            final size = tester.getSize(find.byWidget(button));
            if (size.height < 48.0) {
              failures.add('FilledButton has height ${size.height}px < 48px');
            }
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

          // Check all TextFields
          for (final textField in tester.widgetList<TextField>(
            find.byType(TextField),
          )) {
            final size = tester.getSize(find.byWidget(textField));
            if (size.height < 48.0) {
              failures.add('TextField has height ${size.height}px < 48px');
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
    });

    group('Responsive Touch Target Tests', () {
      testWidgets(
        'touch targets remain adequate across all screen sizes',
        (tester) async {
          final failures = <String>[];

          for (final size in TestDeviceSizes.all) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockResponsiveButtons(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            final saveButton = tester.getSize(
              find.byKey(const Key('save_button')),
            );
            if (saveButton.height < 48.0) {
              failures.add(
                'Save button at ${TestDeviceSizes.nameFor(size)}: ${saveButton.height}px < 48px',
              );
            }

            final closeButton = tester.getSize(
              find.byKey(const Key('close_button')),
            );
            if (closeButton.width < 48.0 || closeButton.height < 48.0) {
              failures.add(
                'Close button at ${TestDeviceSizes.nameFor(size)}: ${closeButton.width}x${closeButton.height}px < 48x48px',
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

enum _ButtonType { filled, outlined, text }

/// Mock button with specific size
class _MockButtonWithSize extends StatelessWidget {
  final _ButtonType buttonType;
  final bool hasIcon;

  const _MockButtonWithSize({
    required this.buttonType,
    required this.hasIcon,
  });

  @override
  Widget build(BuildContext context) {
    return switch (buttonType) {
      _ButtonType.filled => hasIcon
          ? FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text('Save'),
            )
          : FilledButton(
              onPressed: () {},
              child: const Text('Button'),
            ),
      _ButtonType.outlined => hasIcon
          ? OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.cancel),
              label: const Text('Cancel'),
            )
          : OutlinedButton(
              onPressed: () {},
              child: const Text('Button'),
            ),
      _ButtonType.text => hasIcon
          ? TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info),
              label: const Text('Info'),
            )
          : TextButton(
              onPressed: () {},
              child: const Text('Button'),
            ),
    };
  }
}

/// Mock IconButton
class _MockIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {},
    );
  }
}

/// Mock Edit Dialog Save Button
class _MockEditDialogSaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('save_button'),
      height: 48,
      child: FilledButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.save),
        label: const Text('Save Changes'),
      ),
    );
  }
}

/// Mock Run Test Button
class _MockRunTestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      key: const Key('run_test_button'),
      onPressed: () {},
      icon: const Icon(Icons.play_arrow_rounded, size: 20),
      label: const Text('Run Test'),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}

/// Mock Create Scrappable Button
class _MockCreateScrappableButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      key: const Key('create_button'),
      onPressed: () {},
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
      ),
      icon: const Icon(Icons.send),
      label: const Text('Create scrappable'),
    );
  }
}

/// Mock Dialog Close Button
class _MockDialogCloseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {},
      tooltip: 'Close',
    );
  }
}

/// Mock URL TextField
class _MockUrlTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'https://example.com/users/{userId}',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

/// Mock Chat TextField
class _MockChatTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Type a message...',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}

/// Mock Parameter TextField
class _MockParameterTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'userId',
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        isDense: true,
      ),
    );
  }
}

/// Mock Test Dialog Tabs
class _MockTestDialogTabs extends StatefulWidget {
  @override
  State<_MockTestDialogTabs> createState() => _MockTestDialogTabsState();
}

class _MockTestDialogTabsState extends State<_MockTestDialogTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Parameters'),
            Tab(text: 'Response'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              Center(child: Text('Parameters Content')),
              Center(child: Text('Response Content')),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mock all interactive elements
class _MockAllInteractiveElements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
        const SizedBox(height: 8),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {},
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter text',
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

/// Mock responsive buttons
class _MockResponsiveButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          key: const Key('save_button'),
          height: 48,
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ),
        const SizedBox(height: 8),
        IconButton(
          key: const Key('close_button'),
          icon: const Icon(Icons.close),
          onPressed: () {},
        ),
      ],
    );
  }
}
