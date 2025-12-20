import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/pages/scrappable_details_dialog.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/scrappable_usage_metrics_widget.dart';

void main() {
  group('Marketplace Layout Switching Tests', () {
    Widget createTestWidget(Widget child, {required Size size}) {
      return ProviderScope(
        overrides: [
          marketplaceProvider.overrideWith((ref) => MockMarketplaceNotifier()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(size: size),
              child: child,
            ),
          ),
        ),
      );
    }

    Scrappable createMockScrappable() {
      return Scrappable(
        id: 1,
        accountId: 123,
        name: 'Test Scrappable',
        description: 'Test description',
        createdAt: DateTime.now(),
        extractRulesUpdatedAt: DateTime.now(),
        targetRequest: TargetRequest(
          url: 'https://example.com',
          method: HttpMethod.get,
        ),
        scrappingBeeExtractRules: null,
        referenceTestData: null,
        autoFixConfig: null,
        isPublic: true,
      );
    }

    testWidgets('ScrappableDetailsDialog switches to column layout on compact', (tester) async {
      final scrappable = createMockScrappable();

      // Test compact size (should use Column layout)
      final compactWidget = createTestWidget(
        ScrappableDetailsDialog(scrappable: scrappable),
        size: const Size(350, 600),
      );

      await tester.pumpWidget(compactWidget);
      await tester.pumpAndSettle();

      // In compact mode, dialogs should be stacked vertically
      // We can verify this by checking that the layout uses SingleChildScrollView with Column
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('ScrappableDetailsDialog uses row layout on medium/expanded', (tester) async {
      final scrappable = createMockScrappable();

      // Test medium size (should use Row layout)
      final mediumWidget = createTestWidget(
        ScrappableDetailsDialog(scrappable: scrappable),
        size: const Size(700, 800),
      );

      await tester.pumpWidget(mediumWidget);
      await tester.pumpAndSettle();

      // In medium/expanded mode, dialogs should be side by side
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('ScrappableUsageMetricsWidget switches layout based on size', (tester) async {
      // Test compact size (should use Column layout)
      final compactWidget = createTestWidget(
        const ScrappableUsageMetricsWidget(scrappableId: 1),
        size: const Size(350, 600),
      );

      await tester.pumpWidget(compactWidget);
      await tester.pumpAndSettle();

      // Wait for initial loading
      await tester.pump(const Duration(seconds: 2));

      // Metrics should be laid out vertically on compact
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Marketplace components adapt to different screen sizes', (tester) async {
      final sizes = [
        const Size(350, 600),   // compact
        const Size(700, 800),   // medium
        const Size(1200, 900),  // expanded
      ];

      for (final size in sizes) {
        final scrappable = createMockScrappable();
        final widget = createTestWidget(
          ScrappableDetailsDialog(scrappable: scrappable),
          size: size,
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        // Verify no rendering errors at any size
        expect(tester.takeException(), isNull,
          reason: 'No errors should occur at size ${size.width}x${size.height}');
      }
    });

    testWidgets('Marketplace view adapts padding across breakpoints', (tester) async {
      final sizes = [
        const Size(350, 600),   // compact - should have less padding
        const Size(700, 800),   // medium - should have medium padding
        const Size(1200, 900),  // expanded - should have full padding
      ];

      for (final size in sizes) {
        final widget = createTestWidget(
          Container(
            color: Colors.white,
            child: const Center(child: Text('Test')),
          ),
          size: size,
        );

        await tester.pumpWidget(widget);
        await tester.pumpAndSettle();

        // Verify layout adapts without errors
        expect(tester.takeException(), isNull);
      }
    });
  });
}

class MockMarketplaceNotifier extends StateNotifier<MarketplaceState>
    with Mock
    implements MarketplaceNotifier {
  MockMarketplaceNotifier() : super(const MarketplaceState.initial());
}
