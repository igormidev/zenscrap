import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive overflow detection tests for scrap_session components.
///
/// Tests verify that scrap_session widgets do not cause overflow errors
/// at various screen sizes, especially at the critical 320px width
/// and at breakpoint edges (599, 600, 839, 840).
///
/// Test Categories:
/// 1. ScrappableEditSessionView overflow tests (Column vs Row layouts)
/// 2. EditScrappableRequestDialog overflow tests
/// 3. TestEndpointDialog overflow tests (compact tabs vs expanded panels)
/// 4. InitialChatPage overflow tests
/// 5. ScrappableChatMessageStreamSection overflow tests (message bubbles)
void main() {
  group('Scrap Session Components Overflow Detection Tests', () {
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

    group('ScrappableEditSessionView Overflow Tests', () {
      testWidgets(
        'compact layout (Column) does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSession(isCompact: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'ScrappableEditSession compact layout overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'compact layout does not overflow at any compact size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.compactSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockScrappableEditSession(isCompact: true),
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
        'expanded layout (Row) does not overflow at any expanded size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.expandedSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockScrappableEditSession(isCompact: false),
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
        'chat section with message bubbles does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockChatMessageSection(),
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

    group('EditScrappableRequestDialog Overflow Tests', () {
      testWidgets(
        'dialog does not overflow at 320px (compact)',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditScrappableRequestDialog(isCompact: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'EditScrappableRequestDialog overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'dialog does not overflow at all screen sizes',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            final isCompact = size.width < 600;
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockEditScrappableRequestDialog(isCompact: isCompact),
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
        'dialog with URL input and save button (compact) does not overflow',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditDialogContent(isCompact: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Edit dialog content (compact) overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'dialog with URL input and save button (expanded) does not overflow',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditDialogContent(isCompact: false),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Edit dialog content (expanded) overflows: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('TestEndpointDialog Overflow Tests', () {
      testWidgets(
        'compact dialog with tabs does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(isCompact: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'TestEndpointDialog compact layout overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'compact dialog with tabs does not overflow at any compact size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.compactSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockTestEndpointDialog(isCompact: true),
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
        'expanded dialog with side-by-side panels does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.expandedSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockTestEndpointDialog(isCompact: false),
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
        'dialog with parameters panel does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockParametersPanel(),
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
        'dialog with response panel does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockResponsePanel(),
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

    group('InitialChatPage Overflow Tests', () {
      testWidgets(
        'initial chat page does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockInitialChatPage(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'InitialChatPage overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'initial chat page does not overflow at all screen sizes',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockInitialChatPage(),
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
        'chat input fields with responsive padding do not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.compactSizes) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockChatInputFields(),
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

    group('Message Bubble Overflow Tests', () {
      testWidgets(
        'user message bubble does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockMessageBubble(
                isUserMessage: true,
                hasLongText: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'User message bubble overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'AI message bubble does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockMessageBubble(
                isUserMessage: false,
                hasLongText: true,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'AI message bubble overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'message bubbles do not overflow at any screen size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            for (final isUser in [true, false]) {
              overflowCapture.clear();

              await tester.setScreenSize(size);
              await tester.pumpWidget(
                responsiveTestWrapper(
                  sharedPreferences: prefs,
                  _MockMessageBubble(
                    isUserMessage: isUser,
                    hasLongText: true,
                  ),
                ),
              );
              await tester.pumpAndSettle(const Duration(milliseconds: 200));

              if (overflowCapture.hasOverflow) {
                failures.add(
                  '${isUser ? "User" : "AI"} message overflows at ${TestDeviceSizes.nameFor(size)}: ${overflowCapture.summary}',
                );
              }
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

/// Mock ScrappableEditSession with compact (Column) and expanded (Row) layouts
class _MockScrappableEditSession extends StatelessWidget {
  final bool isCompact;

  const _MockScrappableEditSession({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      // Compact layout: Column with chat and CURL sections
      return Padding(
        padding: EdgeInsets.all(
          context.responsiveValue(
            compact: 16.0,
            medium: 18.0,
            expanded: 20.0,
          ),
        ),
        child: Column(
          children: [
            // Chat section (flex: 3)
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(child: _MockChatMessageSection()),
                  const SizedBox(height: 8),
                  const _MockChatTextField(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // CURL and test response section (flex: 2)
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _MockCurlSection(),
                  const SizedBox(height: 8),
                  Expanded(child: _MockTestResponse()),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Expanded layout: Row with side-by-side panels
      return Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: context.responsiveValue(
                  compact: 16.0,
                  medium: 18.0,
                  expanded: 20.0,
                ),
                left: context.responsiveValue(
                  compact: 16.0,
                  medium: 18.0,
                  expanded: 20.0,
                ),
              ),
              child: Column(
                children: [
                  Expanded(child: _MockChatMessageSection()),
                  const _MockChatTextField(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: context.responsiveValue(
                  compact: 16.0,
                  medium: 18.0,
                  expanded: 20.0,
                ),
                right: context.responsiveValue(
                  compact: 16.0,
                  medium: 18.0,
                  expanded: 20.0,
                ),
                top: context.responsiveValue(
                  compact: 16.0,
                  medium: 18.0,
                  expanded: 20.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _MockCurlSection(),
                  const SizedBox(height: 8),
                  Expanded(child: _MockTestResponse()),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }
}

/// Mock chat message section
class _MockChatMessageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView(
        padding: EdgeInsets.all(
          context.responsiveValue(
            compact: 12.0,
            medium: 16.0,
            expanded: 20.0,
          ),
        ),
        children: [
          _MockMessageBubble(isUserMessage: true, hasLongText: false),
          const SizedBox(height: 8),
          _MockMessageBubble(isUserMessage: false, hasLongText: false),
        ],
      ),
    );
  }
}

/// Mock chat text field
class _MockChatTextField extends StatelessWidget {
  const _MockChatTextField();

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

/// Mock CURL section
class _MockCurlSection extends StatelessWidget {
  const _MockCurlSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: const Text('CURL Section'),
    );
  }
}

/// Mock test response
class _MockTestResponse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(51),
        ),
      ),
      child: const Center(child: Text('Test Response')),
    );
  }
}

/// Mock EditScrappableRequestDialog
class _MockEditScrappableRequestDialog extends StatelessWidget {
  final bool isCompact;

  const _MockEditScrappableRequestDialog({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.responsiveValue(
            compact: double.infinity,
            medium: 700,
            expanded: 900,
          ),
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Container(
          padding: EdgeInsets.all(
            context.responsiveValue(
              compact: 16.0,
              medium: 20.0,
              expanded: 24.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.edit_document, size: 34),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Request',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Modify your endpoint configuration'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: _MockEditDialogContent(isCompact: isCompact),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mock edit dialog content with responsive layout
class _MockEditDialogContent extends StatelessWidget {
  final bool isCompact;

  const _MockEditDialogContent({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      compact: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'https://example.com/users/{userId}',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLines: 3,
            minLines: 1,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ),
        ],
      ),
      expanded: (context, constraints) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'https://example.com/users/{userId}',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock TestEndpointDialog
class _MockTestEndpointDialog extends StatelessWidget {
  final bool isCompact;

  const _MockTestEndpointDialog({required this.isCompact});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.responsiveValue(
            compact: double.infinity,
            medium: 700,
            expanded: 1000,
          ),
          maxHeight: MediaQuery.sizeOf(context).height *
              context.responsiveValue(
                compact: 0.9,
                medium: 0.85,
                expanded: 0.8,
              ),
        ),
        child: Container(
          padding: EdgeInsets.all(
            context.responsiveValue(
              compact: 16.0,
              medium: 20.0,
              expanded: 24.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Endpoint',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Fill in parameters and run a test request'),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: isCompact
                    ? _MockCompactDialogLayout()
                    : _MockExpandedDialogLayout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mock compact dialog layout with tabs
class _MockCompactDialogLayout extends StatefulWidget {
  @override
  State<_MockCompactDialogLayout> createState() =>
      _MockCompactDialogLayoutState();
}

class _MockCompactDialogLayoutState extends State<_MockCompactDialogLayout>
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
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _MockParametersPanel(),
              _MockResponsePanel(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mock expanded dialog layout with side-by-side panels
class _MockExpandedDialogLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 320,
          child: _MockParametersPanel(),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _MockResponsePanel(),
        ),
      ],
    );
  }
}

/// Mock parameters panel
class _MockParametersPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.tune_rounded, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Parameters',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: const Center(child: Text('Parameters Form')),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.play_arrow_rounded, size: 20),
          label: const Text('Run Test'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

/// Mock response panel
class _MockResponsePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.code_rounded, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Response',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: Text('Response Data')),
          ),
        ),
      ],
    );
  }
}

/// Mock InitialChatPage
class _MockInitialChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.responsiveValue(
            compact: double.infinity,
            medium: 600,
            expanded: 700,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsiveValue(
              compact: 20.0,
              medium: 40.0,
              expanded: 60.0,
            ),
          ),
          children: [
            SizedBox(
              height: context.responsiveValue(
                compact: 20.0,
                medium: 30.0,
                expanded: 40.0,
              ),
            ),
            Center(
              child: Text(
                'Vibe scrap any site',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: context.responsiveValue(
                    compact: 32.0,
                    medium: 40.0,
                    expanded: 48.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.responsiveValue(
                compact: 16.0,
                medium: 18.0,
                expanded: 20.0,
              ),
            ),
            _MockChatInputFields(),
            SizedBox(
              height: context.responsiveValue(
                compact: 24.0,
                medium: 28.0,
                expanded: 32.0,
              ),
            ),
            Center(
              child: FilledButton.tonalIcon(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: Size(
                    context.responsiveValue(
                      compact: double.infinity,
                      medium: 200.0,
                      expanded: 220.0,
                    ),
                    48,
                  ),
                ),
                icon: const Icon(Icons.send),
                label: const Text('Create scrappable'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mock chat input fields
class _MockChatInputFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Drop a target link',
            hintText: 'E.g https://example.com/product/12345',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            labelText: 'What do you want to extract?',
            hintText: 'E.g. Extract all product details...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}

/// Mock message bubble
class _MockMessageBubble extends StatelessWidget {
  final bool isUserMessage;
  final bool hasLongText;

  const _MockMessageBubble({
    required this.isUserMessage,
    required this.hasLongText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor =
        isUserMessage ? colorScheme.primary : colorScheme.surfaceContainerHigh;
    final textColor =
        isUserMessage ? colorScheme.onPrimary : colorScheme.onSurface;

    final text = hasLongText
        ? 'This is a very long message text that should wrap properly across multiple lines without causing overflow issues. It contains enough text to test the responsive constraints and padding at different screen sizes.'
        : 'Short message';

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: context.responsiveValue(
          compact: 8.0,
          medium: 12.0,
          expanded: 16.0,
        ),
      ),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width *
                    context.responsiveValue(
                      compact: 0.85,
                      medium: 0.8,
                      expanded: 0.75,
                    ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: context.responsiveValue(
                  compact: 12.0,
                  medium: 13.0,
                  expanded: 14.0,
                ),
                vertical: context.responsiveValue(
                  compact: 8.0,
                  medium: 9.0,
                  expanded: 10.0,
                ),
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                text,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
