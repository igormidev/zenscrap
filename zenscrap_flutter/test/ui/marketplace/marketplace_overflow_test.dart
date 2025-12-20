import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/overflow_error_capture.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_provider.dart';
import 'package:zenscrap_flutter/src/states/marketplace/marketplace_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/views/marketplace_view.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_header.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/marketplace_pagination_controls.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/pages/empty_marketplace_page.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/dialogs/upgrade_plan_dialog.dart';

void main() {
  group('Marketplace Overflow Detection Tests', () {
    late OverrideErrorCapture errorCapture;

    setUp(() {
      errorCapture = OverrideErrorCapture();
    });

    Widget createTestWidget(Widget child, {Size? size}) {
      return ProviderScope(
        overrides: [
          marketplaceProvider.overrideWith((ref) => MockMarketplaceNotifier()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(size: size ?? const Size(400, 800)),
              child: child,
            ),
          ),
        ),
      );
    }

    testWidgets('MarketplaceView detects overflow at compact size', (tester) async {
      final widget = createTestWidget(
        const MarketplaceView(),
        size: const Size(350, 600),
      );

      await errorCapture.pumpWithCapture(tester, widget);
      errorCapture.expectNoOverflow();
    });

    testWidgets('MarketplaceHeader detects overflow at compact size', (tester) async {
      final widget = createTestWidget(
        const MarketplaceHeader(),
        size: const Size(350, 600),
      );

      await errorCapture.pumpWithCapture(tester, widget);
      errorCapture.expectNoOverflow();
    });

    testWidgets('EmptyMarketplacePage detects overflow at compact size', (tester) async {
      final widget = createTestWidget(
        const EmptyMarketplacePage(
          isSearchResult: false,
          searchQuery: '',
        ),
        size: const Size(350, 600),
      );

      await errorCapture.pumpWithCapture(tester, widget);
      errorCapture.expectNoOverflow();
    });

    testWidgets('MarketplaceView no overflow at medium size', (tester) async {
      final widget = createTestWidget(
        const MarketplaceView(),
        size: const Size(700, 800),
      );

      await errorCapture.pumpWithCapture(tester, widget);
      errorCapture.expectNoOverflow();
    });

    testWidgets('MarketplaceView no overflow at expanded size', (tester) async {
      final widget = createTestWidget(
        const MarketplaceView(),
        size: const Size(1200, 900),
      );

      await errorCapture.pumpWithCapture(tester, widget);
      errorCapture.expectNoOverflow();
    });

    testWidgets('EmptyMarketplacePage no overflow at all sizes', (tester) async {
      final sizes = [
        const Size(350, 600),  // compact
        const Size(700, 800),  // medium
        const Size(1200, 900), // expanded
      ];

      for (final size in sizes) {
        final widget = createTestWidget(
          const EmptyMarketplacePage(
            isSearchResult: true,
            searchQuery: 'test search query',
          ),
          size: size,
        );

        await errorCapture.pumpWithCapture(tester, widget);
        errorCapture.expectNoOverflow();
      }
    });
  });
}

class MockMarketplaceNotifier extends StateNotifier<MarketplaceState>
    with Mock
    implements MarketplaceNotifier {
  MockMarketplaceNotifier() : super(const MarketplaceState.initial());
}
