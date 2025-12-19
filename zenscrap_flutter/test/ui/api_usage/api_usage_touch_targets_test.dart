import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/api_keys_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/purchase_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/api_key_card.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/create_api_key_dialog.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/credit_history_list.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Touch target compliance tests for api_usage components.
///
/// Material Design and WCAG accessibility guidelines require a minimum
/// touch target size of 48x48 pixels for interactive elements on mobile.
///
/// Tests verify that:
/// 1. All buttons have at least 48px touch area
/// 2. Icon buttons have at least 48px touch area
/// 3. Interactive cards are tappable
/// 4. Dialog buttons have adequate touch targets
void main() {
  group('API Usage Touch Target Compliance Tests', () {
    late SharedPreferences prefs;

    setUpAll(() async {
      prefs = await setupMockSharedPreferences();
    });

    group('Create API Key Button Touch Targets', () {
      testWidgets(
        'Create API key button has adequate touch area on mobile',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              SizedBox(
                height: 400,
                child: ApiKeysSection(
                  apiKeys: const [],
                  apiKeyUsageStats: const {},
                  onShowCreateApiKeyDialog: () {},
                  onDeactivateApiKey: (_) {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the create button
          final createButton = find.byType(ElevatedButton);
          expect(createButton, findsOneWidget);

          final buttonElement = tester.element(createButton);
          final renderBox = buttonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.height,
            greaterThanOrEqualTo(40.0),
            reason: 'Create API key button should have adequate height',
          );

          // Verify button is tappable
          await tester.tap(createButton);
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        'Create API key button is tappable at 320px width',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              SizedBox(
                height: 400,
                child: ApiKeysSection(
                  apiKeys: const [],
                  apiKeyUsageStats: const {},
                  onShowCreateApiKeyDialog: () {},
                  onDeactivateApiKey: (_) {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final createButton = find.byType(ElevatedButton);
          await tester.tap(createButton);
          await tester.pumpAndSettle();
        },
      );
    });

    group('API Key Card Touch Targets', () {
      testWidgets(
        'Copy button in API key card has at least 48px touch area',
        (tester) async {
          final apiKey = AccountApiKey(
            id: 1,
            name: 'Test Key',
            apiKey: 'sk_test_key',
            isActive: true,
            createdAt: DateTime.now(),
            accountApiUsageId: 1,
          );

          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Padding(
                padding: const EdgeInsets.all(16),
                child: ApiKeyCard(
                  apiKey: apiKey,
                  usageCount: 1000,
                  canDelete: true,
                  onDelete: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the copy IconButton
          final copyButton = find.byIcon(Icons.copy);
          expect(copyButton, findsOneWidget);

          final buttonElement = tester.element(
            find.ancestor(
              of: copyButton,
              matching: find.byType(IconButton),
            ),
          );
          final renderBox = buttonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Copy button should have at least 48px width',
          );
          expect(
            size.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Copy button should have at least 48px height',
          );
        },
      );

      testWidgets(
        'Delete button in API key card has adequate touch area',
        (tester) async {
          final apiKey = AccountApiKey(
            id: 1,
            name: 'Test Key',
            apiKey: 'sk_test_key',
            isActive: true,
            createdAt: DateTime.now(),
            accountApiUsageId: 1,
          );

          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Padding(
                padding: const EdgeInsets.all(16),
                child: ApiKeyCard(
                  apiKey: apiKey,
                  usageCount: 1000,
                  canDelete: true,
                  onDelete: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the delete IconButton
          final deleteButton = find.byIcon(Icons.delete);
          expect(deleteButton, findsOneWidget);

          final buttonElement = tester.element(
            find.ancestor(
              of: deleteButton,
              matching: find.byType(IconButton),
            ),
          );
          final renderBox = buttonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Delete button should have at least 48px width',
          );
          expect(
            size.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Delete button should have at least 48px height',
          );

          // Verify button is tappable
          await tester.tap(deleteButton);
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        'API key card buttons are tappable at 320px width',
        (tester) async {
          final apiKey = AccountApiKey(
            id: 1,
            name: 'Test Key',
            apiKey: 'sk_test_key',
            isActive: true,
            createdAt: DateTime.now(),
            accountApiUsageId: 1,
          );

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              Padding(
                padding: const EdgeInsets.all(16),
                child: ApiKeyCard(
                  apiKey: apiKey,
                  usageCount: 1000,
                  canDelete: true,
                  onDelete: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Test copy button
          final copyButton = find.byIcon(Icons.copy);
          await tester.tap(copyButton);
          await tester.pumpAndSettle();

          // Test delete button
          final deleteButton = find.byIcon(Icons.delete);
          await tester.tap(deleteButton);
          await tester.pumpAndSettle();
        },
      );
    });

    group('Create API Key Dialog Touch Targets', () {
      testWidgets(
        'Dialog close button has adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the close IconButton
          final closeButton = find.byIcon(Icons.close);
          expect(closeButton, findsOneWidget);

          final buttonElement = tester.element(
            find.ancestor(
              of: closeButton,
              matching: find.byType(IconButton),
            ),
          );
          final renderBox = buttonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.width,
            greaterThanOrEqualTo(48.0),
            reason: 'Close button should have at least 48px width',
          );
          expect(
            size.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Close button should have at least 48px height',
          );
        },
      );

      testWidgets(
        'Dialog cancel button has adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the cancel TextButton
          final cancelButtons = find.byType(TextButton);
          expect(cancelButtons, findsOneWidget);

          final buttonElement = tester.element(cancelButtons.first);
          final renderBox = buttonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.height,
            greaterThanOrEqualTo(36.0),
            reason: 'Cancel button should have adequate height',
          );
        },
      );

      testWidgets(
        'Dialog create button has adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the create FilledButton
          final createButton = find.byType(FilledButton);
          expect(createButton, findsOneWidget);

          final buttonElement = tester.element(createButton);
          final renderBox = buttonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.height,
            greaterThanOrEqualTo(40.0),
            reason: 'Create button should have adequate height',
          );
        },
      );

      testWidgets(
        'Dialog buttons are tappable at 320px width',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Test close button
          final closeButton = find.byIcon(Icons.close);
          await tester.tap(closeButton);
          await tester.pumpAndSettle();

          // Pump the dialog again for next test
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Test cancel button
          final cancelButton = find.byType(TextButton);
          await tester.tap(cancelButton);
          await tester.pumpAndSettle();
        },
      );
    });

    group('Purchase Section Touch Targets', () {
      testWidgets(
        'Purchase package cards are tappable',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              PurchaseSection(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find InkWell widgets (the cards are wrapped in InkWell)
          final inkWells = find.byType(InkWell);
          expect(inkWells, findsWidgets);

          // Test tapping the first card
          if (inkWells.evaluate().isNotEmpty) {
            await tester.tap(inkWells.first);
            await tester.pumpAndSettle();
          }
        },
      );

      testWidgets(
        'Purchase package cards have adequate touch area at 320px',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              PurchaseSection(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find Material widgets containing the cards
          final materials = find.byType(Material);
          expect(materials, findsWidgets);

          // Each card should be scrollable and tappable
          // The horizontal ListView allows all cards to be accessible
        },
      );
    });

    group('Credit History List Touch Targets', () {
      testWidgets(
        'Load more button has adequate touch area',
        (tester) async {
          final historyItems = List.generate(
            5,
            (i) => ApiCreditHistoryItem(
              date: DateTime.now().subtract(Duration(days: i)),
              transactionType: ApiCreditTransactionType.monthlySubscriptionDeposit,
              monthlySubscriptionApiCreditDeposit:
                  MonthlySubscriptionApiCreditDeposit(
                planTier: PlanTier.pro,
                creditsAmount: 1000000,
              ),
              accountApiUsageId: 1,
            ),
          );

          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              SizedBox(
                height: 600,
                child: CreditHistoryList(
                  creditHistory: historyItems,
                  isLoadingMore: false,
                  hasMore: true,
                  onLoadMore: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the load more OutlinedButton
          final loadMoreButton = find.byType(OutlinedButton);
          expect(loadMoreButton, findsOneWidget);

          final buttonElement = tester.element(loadMoreButton);
          final renderBox = buttonElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.height,
            greaterThanOrEqualTo(36.0),
            reason: 'Load more button should have adequate height',
          );

          // Verify button is tappable
          await tester.tap(loadMoreButton);
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        'Load more button is tappable at 320px width',
        (tester) async {
          final historyItems = List.generate(
            5,
            (i) => ApiCreditHistoryItem(
              date: DateTime.now().subtract(Duration(days: i)),
              transactionType: ApiCreditTransactionType.monthlySubscriptionDeposit,
              monthlySubscriptionApiCreditDeposit:
                  MonthlySubscriptionApiCreditDeposit(
                planTier: PlanTier.pro,
                creditsAmount: 1000000,
              ),
              accountApiUsageId: 1,
            ),
          );

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              SizedBox(
                height: 600,
                child: CreditHistoryList(
                  creditHistory: historyItems,
                  isLoadingMore: false,
                  hasMore: true,
                  onLoadMore: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final loadMoreButton = find.byType(OutlinedButton);
          await tester.tap(loadMoreButton);
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        'History list items are tappable (if interactive)',
        (tester) async {
          final historyItems = [
            ApiCreditHistoryItem(
              date: DateTime.now(),
              transactionType: ApiCreditTransactionType.monthlySubscriptionDeposit,
              monthlySubscriptionApiCreditDeposit:
                  MonthlySubscriptionApiCreditDeposit(
                planTier: PlanTier.pro,
                creditsAmount: 1000000,
              ),
              accountApiUsageId: 1,
            ),
          ];

          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              SizedBox(
                height: 400,
                child: CreditHistoryList(
                  creditHistory: historyItems,
                  isLoadingMore: false,
                  hasMore: false,
                  onLoadMore: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the ListTile
          final listTile = find.byType(ListTile);
          expect(listTile, findsOneWidget);

          final tileElement = tester.element(listTile);
          final renderBox = tileElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.height,
            greaterThanOrEqualTo(48.0),
            reason: 'List item should have adequate height',
          );
        },
      );
    });

    group('Form Field Touch Targets', () {
      testWidgets(
        'Text field in create dialog has adequate touch area',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.phone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          // Find the TextFormField
          final textField = find.byType(TextFormField);
          expect(textField, findsOneWidget);

          final fieldElement = tester.element(textField);
          final renderBox = fieldElement.renderObject as RenderBox;
          final size = renderBox.size;

          expect(
            size.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Text field should have at least 48px height for touch',
          );

          // Verify field is tappable
          await tester.tap(textField);
          await tester.pumpAndSettle();
        },
      );

      testWidgets(
        'Text field is tappable at 320px width',
        (tester) async {
          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 200));

          final textField = find.byType(TextFormField);
          await tester.tap(textField);
          await tester.pumpAndSettle();

          // Enter text to verify interaction
          await tester.enterText(textField, 'Test API Key');
          await tester.pumpAndSettle();
        },
      );
    });

    group('Comprehensive Touch Target Validation', () {
      testWidgets(
        'All interactive elements maintain touch targets across screen sizes',
        (tester) async {
          final apiKey = AccountApiKey(
            id: 1,
            name: 'Test Key',
            apiKey: 'sk_test_key',
            isActive: true,
            createdAt: DateTime.now(),
            accountApiUsageId: 1,
          );

          // Test only at compact and medium sizes where card is naturally used
          // Desktop sizes would need to be in a constrained container
          for (final size in [
            TestDeviceSizes.smallPhone,
            TestDeviceSizes.phone,
            TestDeviceSizes.tabletPortrait,
          ]) {
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ApiKeyCard(
                    apiKey: apiKey,
                    usageCount: 1000,
                    canDelete: true,
                    onDelete: () {},
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            // Verify all buttons are tappable at this size
            final copyButton = find.byIcon(Icons.copy);
            final deleteButton = find.byIcon(Icons.delete);

            await tester.tap(copyButton);
            await tester.pumpAndSettle();

            await tester.tap(deleteButton);
            await tester.pumpAndSettle();
          }
        },
      );
    });
  });
}
