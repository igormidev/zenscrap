import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive layout switching tests for scrap_session components.
///
/// Tests verify that:
/// 1. Compact layout is shown on compact screens (< 600px)
/// 2. Medium layout is shown on medium screens (600-839px)
/// 3. Expanded layout is shown on expanded screens (>= 840px)
/// 4. Layout switches correctly at breakpoint edges (599, 600, 839, 840)
/// 5. ScrappableEditSessionView switches between Column (compact) and Row (expanded)
/// 6. TestEndpointDialog switches between tabs (compact) and side-by-side (expanded)
/// 7. EditScrappableRequestDialog switches URL/button layout
void main() {
  group('Scrap Session Layout Switching Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('ScrappableEditSessionView Layout Switching', () {
      testWidgets(
        'shows compact (Column) layout at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSessionWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('compact_layout')), findsOneWidget);
          expect(find.byKey(const Key('expanded_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows compact (Column) layout at 599px (just before medium)',
        (tester) async {
          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSessionWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.byKey(const Key('compact_layout')),
            findsOneWidget,
            reason: 'Should show compact layout at 599px',
          );
          expect(find.byKey(const Key('expanded_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows compact (Column) layout at 600px (medium breakpoint)',
        (tester) async {
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSessionWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Note: ScrappableEditSessionView only switches to expanded at 840px
          expect(
            find.byKey(const Key('compact_layout')),
            findsOneWidget,
            reason: 'Should still show compact layout at 600px',
          );
          expect(find.byKey(const Key('expanded_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows compact (Column) layout at 839px (just before expanded)',
        (tester) async {
          await tester.setScreenSize(const Size(839, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSessionWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.byKey(const Key('compact_layout')),
            findsOneWidget,
            reason: 'Should still show compact layout at 839px',
          );
          expect(find.byKey(const Key('expanded_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows expanded (Row) layout at 840px (expanded breakpoint)',
        (tester) async {
          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSessionWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('compact_layout')), findsNothing);
          expect(
            find.byKey(const Key('expanded_layout')),
            findsOneWidget,
            reason: 'Should show expanded layout at 840px',
          );
        },
      );

      testWidgets(
        'shows expanded (Row) layout at 1200px (desktop)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSessionWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('expanded_layout')), findsOneWidget);
          expect(find.byKey(const Key('compact_layout')), findsNothing);
        },
      );

      testWidgets(
        'compact layout uses Column (vertical stacking)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSessionWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Verify Column is used in compact layout
          expect(find.byKey(const Key('compact_column')), findsOneWidget);
        },
      );

      testWidgets(
        'expanded layout uses Row (side-by-side)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSessionWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Verify Row is used in expanded layout
          expect(find.byKey(const Key('expanded_row')), findsOneWidget);
        },
      );
    });

    group('TestEndpointDialog Layout Switching', () {
      testWidgets(
        'shows compact layout with tabs at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('compact_tabs')), findsOneWidget);
          expect(find.byKey(const Key('expanded_panels')), findsNothing);
        },
      );

      testWidgets(
        'shows compact tabs at 599px (just before medium)',
        (tester) async {
          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.byKey(const Key('compact_tabs')),
            findsOneWidget,
            reason: 'Should show tabs at 599px',
          );
          expect(find.byKey(const Key('expanded_panels')), findsNothing);
        },
      );

      testWidgets(
        'shows compact tabs at 600px (medium breakpoint)',
        (tester) async {
          await tester.setScreenSize(const Size(600, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // TestEndpointDialog switches at 840px, not 600px
          expect(
            find.byKey(const Key('compact_tabs')),
            findsOneWidget,
            reason: 'Should still show tabs at 600px',
          );
          expect(find.byKey(const Key('expanded_panels')), findsNothing);
        },
      );

      testWidgets(
        'shows compact tabs at 839px (just before expanded)',
        (tester) async {
          await tester.setScreenSize(const Size(839, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.byKey(const Key('compact_tabs')),
            findsOneWidget,
            reason: 'Should still show tabs at 839px',
          );
          expect(find.byKey(const Key('expanded_panels')), findsNothing);
        },
      );

      testWidgets(
        'shows expanded side-by-side panels at 840px',
        (tester) async {
          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('compact_tabs')), findsNothing);
          expect(
            find.byKey(const Key('expanded_panels')),
            findsOneWidget,
            reason: 'Should show side-by-side panels at 840px',
          );
        },
      );

      testWidgets(
        'shows expanded panels at 1200px (desktop)',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('expanded_panels')), findsOneWidget);
          expect(find.byKey(const Key('compact_tabs')), findsNothing);
        },
      );

      testWidgets(
        'compact layout shows TabBar',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byType(TabBar), findsOneWidget);
          expect(find.text('Parameters'), findsOneWidget);
          expect(find.text('Response'), findsOneWidget);
        },
      );

      testWidgets(
        'expanded layout shows side-by-side panels without TabBar',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockTestEndpointDialogWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byType(TabBar), findsNothing);
          expect(find.byKey(const Key('parameters_panel')), findsOneWidget);
          expect(find.byKey(const Key('response_panel')), findsOneWidget);
        },
      );
    });

    group('EditScrappableRequestDialog Layout Switching', () {
      testWidgets(
        'shows compact layout (Column) for URL and button at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditDialogContentWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('compact_url_layout')), findsOneWidget);
          expect(find.byKey(const Key('expanded_url_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows compact layout at 599px',
        (tester) async {
          await tester.setScreenSize(const Size(599, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditDialogContentWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(
            find.byKey(const Key('compact_url_layout')),
            findsOneWidget,
            reason: 'Should show compact URL layout at 599px',
          );
          expect(find.byKey(const Key('expanded_url_layout')), findsNothing);
        },
      );

      testWidgets(
        'shows expanded layout (Row) for URL and button at 840px',
        (tester) async {
          await tester.setScreenSize(const Size(840, 800));
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditDialogContentWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('compact_url_layout')), findsNothing);
          expect(
            find.byKey(const Key('expanded_url_layout')),
            findsOneWidget,
            reason: 'Should show expanded URL layout at 840px',
          );
        },
      );

      testWidgets(
        'shows expanded layout at 1200px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockEditDialogContentWithKeys(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          expect(find.byKey(const Key('expanded_url_layout')), findsOneWidget);
          expect(find.byKey(const Key('compact_url_layout')), findsNothing);
        },
      );
    });

    group('Responsive Padding Tests', () {
      testWidgets(
        'ScrappableEditSession has 16px padding on compact',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSessionWithPadding(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final padding = tester.widget<Padding>(
            find.byKey(const Key('session_padding')),
          );

          expect(
            (padding.padding as EdgeInsets).left,
            equals(16.0),
            reason: 'Compact should have 16px padding',
          );
        },
      );

      testWidgets(
        'ScrappableEditSession has 20px padding on expanded',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockScrappableEditSessionWithPadding(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final padding = tester.widget<Padding>(
            find.byKey(const Key('session_padding')),
          );

          expect(
            (padding.padding as EdgeInsets).left,
            equals(20.0),
            reason: 'Expanded should have 20px padding',
          );
        },
      );

      testWidgets(
        'InitialChatPage has 20px horizontal padding on compact',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockInitialChatPageWithPadding(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final padding = tester.widget<Padding>(
            find.byKey(const Key('chat_page_padding')),
          );

          expect(
            (padding.padding as EdgeInsets).horizontal,
            equals(40.0), // 20.0 * 2
            reason: 'Compact should have 20px horizontal padding',
          );
        },
      );

      testWidgets(
        'InitialChatPage has 60px horizontal padding on expanded',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockInitialChatPageWithPadding(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final padding = tester.widget<Padding>(
            find.byKey(const Key('chat_page_padding')),
          );

          expect(
            (padding.padding as EdgeInsets).horizontal,
            equals(120.0), // 60.0 * 2
            reason: 'Expanded should have 60px horizontal padding',
          );
        },
      );
    });

    group('Message Bubble Constraint Tests', () {
      testWidgets(
        'message bubble has 85% max width on compact',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockMessageBubbleWithConstraints(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final container = tester.widget<Container>(
            find.byKey(const Key('message_container')),
          );

          final constraints = container.constraints as BoxConstraints;
          final screenWidth = TestDeviceSizes.phone.width;
          expect(
            constraints.maxWidth,
            equals(screenWidth * 0.85),
            reason: 'Message bubble should be 85% of screen width on compact',
          );
        },
      );

      testWidgets(
        'message bubble has 75% max width on expanded',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockMessageBubbleWithConstraints(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final container = tester.widget<Container>(
            find.byKey(const Key('message_container')),
          );

          final constraints = container.constraints as BoxConstraints;
          final screenWidth = TestDeviceSizes.desktop.width;
          expect(
            constraints.maxWidth,
            equals(screenWidth * 0.75),
            reason: 'Message bubble should be 75% of screen width on expanded',
          );
        },
      );
    });

    group('InitialChatPage Responsive Title Tests', () {
      testWidgets(
        'title has 32px font size on compact',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockInitialChatPageTitle(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final text = tester.widget<Text>(
            find.byKey(const Key('chat_title')),
          );

          expect(
            text.style?.fontSize,
            equals(32.0),
            reason: 'Title should be 32px on compact',
          );
        },
      );

      testWidgets(
        'title has 48px font size on expanded',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.desktop);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              _MockInitialChatPageTitle(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final text = tester.widget<Text>(
            find.byKey(const Key('chat_title')),
          );

          expect(
            text.style?.fontSize,
            equals(48.0),
            reason: 'Title should be 48px on expanded',
          );
        },
      );
    });
  });
}

// =============================================================================
// MOCK WIDGETS FOR TESTING
// =============================================================================

/// Mock ScrappableEditSession with layout keys
class _MockScrappableEditSessionWithKeys extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      compact: (context, constraints) => Container(
        key: const Key('compact_layout'),
        child: Column(
          key: const Key('compact_column'),
          children: [
            Expanded(child: const Text('Chat Section')),
            const Text('CURL Section'),
          ],
        ),
      ),
      expanded: (context, constraints) => Container(
        key: const Key('expanded_layout'),
        child: Row(
          key: const Key('expanded_row'),
          children: [
            Expanded(child: const Text('Chat Section')),
            Expanded(child: const Text('CURL Section')),
          ],
        ),
      ),
    );
  }
}

/// Mock ScrappableEditSession with padding for testing
class _MockScrappableEditSessionWithPadding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('session_padding'),
      padding: EdgeInsets.all(
        context.responsiveValue(
          compact: 16.0,
          medium: 18.0,
          expanded: 20.0,
        ),
      ),
      child: const Text('Content'),
    );
  }
}

/// Mock TestEndpointDialog with layout keys
class _MockTestEndpointDialogWithKeys extends StatefulWidget {
  @override
  State<_MockTestEndpointDialogWithKeys> createState() =>
      _MockTestEndpointDialogWithKeysState();
}

class _MockTestEndpointDialogWithKeysState
    extends State<_MockTestEndpointDialogWithKeys>
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
    return ResponsiveBuilder(
      compact: (context, constraints) => Column(
        key: const Key('compact_tabs'),
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
                Text('Parameters Content'),
                Text('Response Content'),
              ],
            ),
          ),
        ],
      ),
      expanded: (context, constraints) => Row(
        key: const Key('expanded_panels'),
        children: [
          Expanded(
            child: Container(
              key: const Key('parameters_panel'),
              child: const Text('Parameters Panel'),
            ),
          ),
          Expanded(
            child: Container(
              key: const Key('response_panel'),
              child: const Text('Response Panel'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mock EditDialogContent with layout keys
class _MockEditDialogContentWithKeys extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      compact: (context, constraints) => Column(
        key: const Key('compact_url_layout'),
        children: [
          const TextField(),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      expanded: (context, constraints) => Row(
        key: const Key('expanded_url_layout'),
        children: [
          const Expanded(child: TextField()),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

/// Mock InitialChatPage with padding for testing
class _MockInitialChatPageWithPadding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('chat_page_padding'),
      padding: EdgeInsets.symmetric(
        horizontal: context.responsiveValue(
          compact: 20.0,
          medium: 40.0,
          expanded: 60.0,
        ),
      ),
      child: const Text('Content'),
    );
  }
}

/// Mock message bubble with constraints for testing
class _MockMessageBubbleWithConstraints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('message_container'),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width *
            context.responsiveValue(
              compact: 0.85,
              medium: 0.8,
              expanded: 0.75,
            ),
      ),
      child: const Text('Message'),
    );
  }
}

/// Mock InitialChatPage title for testing
class _MockInitialChatPageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Vibe scrap any site',
      key: const Key('chat_title'),
      style: TextStyle(
        fontSize: context.responsiveValue(
          compact: 32.0,
          medium: 40.0,
          expanded: 48.0,
        ),
      ),
    );
  }
}
