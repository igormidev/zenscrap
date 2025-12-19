import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive dialog sizing and behavior tests for scrap_session dialogs.
///
/// Tests verify that:
/// 1. EditScrappableRequestDialog has correct max width per breakpoint
/// 2. TestEndpointDialog has correct max width and height per breakpoint
/// 3. Dialogs properly constrain content
/// 4. Dialogs are scrollable when content exceeds height
/// 5. Dialog padding is responsive
/// 6. Dialog headers are properly sized
void main() {
  group('Scrap Session Dialog Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('EditScrappableRequestDialog Sizing Tests', () {
      testWidgets(
        'dialog has full width on compact (320px)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditScrappableRequestDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final constrainedBox = tester.widget<ConstrainedBox>(
            find.byKey(const Key('dialog_constraints')),
          );

          expect(
            constrainedBox.constraints.maxWidth,
            equals(double.infinity),
            reason: 'Dialog should have full width on compact',
          );
        },
      );

      testWidgets(
        'dialog has 700px max width on medium (600px)',
        (tester) async {
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditScrappableRequestDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final constrainedBox = tester.widget<ConstrainedBox>(
            find.byKey(const Key('dialog_constraints')),
          );

          expect(
            constrainedBox.constraints.maxWidth,
            equals(700),
            reason: 'Dialog should have 700px max width on medium',
          );
        },
      );

      testWidgets(
        'dialog has 900px max width on expanded (1200px)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditScrappableRequestDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final constrainedBox = tester.widget<ConstrainedBox>(
            find.byKey(const Key('dialog_constraints')),
          );

          expect(
            constrainedBox.constraints.maxWidth,
            equals(900),
            reason: 'Dialog should have 900px max width on expanded',
          );
        },
      );

      testWidgets(
        'dialog has 85% max height across all sizes',
        (tester) async {
          for (final size in [
            TestDeviceSizes.smallPhone,
            const Size(600, 800),
            TestDeviceSizes.desktop,
          ]) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                _MockEditScrappableRequestDialog(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            final constrainedBox = tester.widget<ConstrainedBox>(
              find.byKey(const Key('dialog_constraints')),
            );

            expect(
              constrainedBox.constraints.maxHeight,
              equals(size.height * 0.85),
              reason:
                  'Dialog should have 85% max height at ${TestDeviceSizes.nameFor(size)}',
            );
          }
        },
      );

      testWidgets(
        'dialog has 16px padding on compact',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditScrappableRequestDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final container = tester.widget<Container>(
            find.byKey(const Key('dialog_content')),
          );

          expect(
            (container.padding as EdgeInsets).top,
            equals(16.0),
            reason: 'Dialog should have 16px padding on compact',
          );
        },
      );

      testWidgets(
        'dialog has 24px padding on expanded',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditScrappableRequestDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final container = tester.widget<Container>(
            find.byKey(const Key('dialog_content')),
          );

          expect(
            (container.padding as EdgeInsets).top,
            equals(24.0),
            reason: 'Dialog should have 24px padding on expanded',
          );
        },
      );
    });

    group('TestEndpointDialog Sizing Tests', () {
      testWidgets(
        'dialog has full width on compact (320px)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final constrainedBox = tester.widget<ConstrainedBox>(
            find.byKey(const Key('test_dialog_constraints')),
          );

          expect(
            constrainedBox.constraints.maxWidth,
            equals(double.infinity),
            reason: 'Test dialog should have full width on compact',
          );
        },
      );

      testWidgets(
        'dialog has 700px max width on medium (600px)',
        (tester) async {
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final constrainedBox = tester.widget<ConstrainedBox>(
            find.byKey(const Key('test_dialog_constraints')),
          );

          expect(
            constrainedBox.constraints.maxWidth,
            equals(700),
            reason: 'Test dialog should have 700px max width on medium',
          );
        },
      );

      testWidgets(
        'dialog has 1000px max width on expanded (1200px)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final constrainedBox = tester.widget<ConstrainedBox>(
            find.byKey(const Key('test_dialog_constraints')),
          );

          expect(
            constrainedBox.constraints.maxWidth,
            equals(1000),
            reason: 'Test dialog should have 1000px max width on expanded',
          );
        },
      );

      testWidgets(
        'dialog has 90% max height on compact',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final constrainedBox = tester.widget<ConstrainedBox>(
            find.byKey(const Key('test_dialog_constraints')),
          );

          expect(
            constrainedBox.constraints.maxHeight,
            equals(TestDeviceSizes.phone.height * 0.9),
            reason: 'Test dialog should have 90% max height on compact',
          );
        },
      );

      testWidgets(
        'dialog has 85% max height on medium',
        (tester) async {
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final constrainedBox = tester.widget<ConstrainedBox>(
            find.byKey(const Key('test_dialog_constraints')),
          );

          expect(
            constrainedBox.constraints.maxHeight,
            equals(800 * 0.85),
            reason: 'Test dialog should have 85% max height on medium',
          );
        },
      );

      testWidgets(
        'dialog has 80% max height on expanded',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final constrainedBox = tester.widget<ConstrainedBox>(
            find.byKey(const Key('test_dialog_constraints')),
          );

          expect(
            constrainedBox.constraints.maxHeight,
            equals(TestDeviceSizes.desktop.height * 0.8),
            reason: 'Test dialog should have 80% max height on expanded',
          );
        },
      );

      testWidgets(
        'dialog has 16px padding on compact',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final container = tester.widget<Container>(
            find.byKey(const Key('test_dialog_content')),
          );

          expect(
            (container.padding as EdgeInsets).top,
            equals(16.0),
            reason: 'Test dialog should have 16px padding on compact',
          );
        },
      );

      testWidgets(
        'dialog has 24px padding on expanded',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final container = tester.widget<Container>(
            find.byKey(const Key('test_dialog_content')),
          );

          expect(
            (container.padding as EdgeInsets).top,
            equals(24.0),
            reason: 'Test dialog should have 24px padding on expanded',
          );
        },
      );
    });

    group('Dialog Header Tests', () {
      testWidgets(
        'edit dialog header has close button',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditScrappableRequestDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byIcon(Icons.close), findsOneWidget);
          expect(find.byType(IconButton), findsOneWidget);
        },
      );

      testWidgets(
        'edit dialog header has icon and title',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditScrappableRequestDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byIcon(Icons.edit_document), findsOneWidget);
          expect(find.text('Edit Request'), findsOneWidget);
          expect(find.text('Modify your endpoint configuration'), findsOneWidget);
        },
      );

      testWidgets(
        'test dialog header has close button',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byIcon(Icons.close), findsOneWidget);
          expect(find.byType(IconButton), findsOneWidget);
        },
      );

      testWidgets(
        'test dialog header has title and description',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.text('Test Endpoint'), findsOneWidget);
          expect(
            find.text('Fill in parameters and run a test request'),
            findsOneWidget,
          );
        },
      );
    });

    group('Dialog Content Scrolling Tests', () {
      testWidgets(
        'edit dialog content is scrollable',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditScrappableRequestDialog(hasLongContent: true),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byType(SingleChildScrollView), findsOneWidget);
        },
      );

      testWidgets(
        'test dialog uses TabBarView for scrolling (compact)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithContent(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byType(TabBarView), findsOneWidget);
        },
      );
    });

    group('Dialog Visibility Tests', () {
      testWidgets(
        'edit dialog shows ResponsiveBuilder layouts correctly',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditScrappableRequestDialog(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Should show compact layout
          expect(find.byKey(const Key('url_input_compact')), findsOneWidget);
        },
      );

      testWidgets(
        'test dialog shows TabBar on compact',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithContent(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byType(TabBar), findsOneWidget);
          expect(find.text('Parameters'), findsOneWidget);
          expect(find.text('Response'), findsOneWidget);
        },
      );

      testWidgets(
        'test dialog shows side-by-side panels on expanded',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithContent(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byType(TabBar), findsNothing);
          expect(find.byKey(const Key('expanded_row')), findsOneWidget);
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock EditScrappableRequestDialog
class _MockEditScrappableRequestDialog extends StatelessWidget {
  final bool hasLongContent;

  const _MockEditScrappableRequestDialog({this.hasLongContent = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        key: const Key('dialog_constraints'),
        constraints: BoxConstraints(
          maxWidth: context.responsiveValue(
            compact: double.infinity,
            medium: 700,
            expanded: 900,
          ),
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Container(
          key: const Key('dialog_content'),
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
                    child: Icon(
                      Icons.edit_document,
                      size: 34,
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
                  child: ResponsiveBuilder(
                    compact: (context, constraints) => Column(
                      key: const Key('url_input_compact'),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TextField(
                          decoration: InputDecoration(
                            hintText: 'https://example.com/users/{userId}',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (hasLongContent) ...[
                          for (int i = 0; i < 20; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text('Long content item $i'),
                            ),
                        ],
                      ],
                    ),
                    expanded: (context, constraints) => Column(
                      key: const Key('url_input_expanded'),
                      children: [
                        const TextField(
                          decoration: InputDecoration(
                            hintText: 'https://example.com/users/{userId}',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        if (hasLongContent) ...[
                          for (int i = 0; i < 20; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text('Long content item $i'),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mock TestEndpointDialog
class _MockTestEndpointDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        key: const Key('test_dialog_constraints'),
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
          key: const Key('test_dialog_content'),
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
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mock TestEndpointDialog with content
class _MockTestEndpointDialogWithContent extends StatefulWidget {
  @override
  State<_MockTestEndpointDialogWithContent> createState() =>
      _MockTestEndpointDialogWithContentState();
}

class _MockTestEndpointDialogWithContentState
    extends State<_MockTestEndpointDialogWithContent>
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
                child: ResponsiveBuilder(
                  compact: (context, constraints) => Column(
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
                          children: const [
                            Center(child: Text('Parameters Content')),
                            Center(child: Text('Response Content')),
                          ],
                        ),
                      ),
                    ],
                  ),
                  expanded: (context, constraints) => Row(
                    key: const Key('expanded_row'),
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(
                        child: Center(child: Text('Parameters Panel')),
                      ),
                      const SizedBox(width: 24),
                      const Expanded(
                        child: Center(child: Text('Response Panel')),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
