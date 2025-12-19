import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/overview_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/api_keys_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/history_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/purchase_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/api_key_card.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/create_api_key_dialog.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/credit_history_list.dart';

import '../../helpers/responsive_test_helpers.dart';

/// Comprehensive overflow detection tests for api_usage components.
///
/// Tests verify that api_usage-related widgets do not cause overflow errors
/// at various screen sizes, especially at the critical 320px width
/// and at breakpoint edges (599, 600, 839, 840).
///
/// Test Categories:
/// 1. Overview section overflow tests (Column vs Row layout)
/// 2. API keys section overflow tests
/// 3. History section overflow tests
/// 4. Purchase section overflow tests (horizontal scroll)
/// 5. API key card overflow tests
/// 6. Create API key dialog overflow tests
/// 7. Credit history list overflow tests
void main() {
  group('API Usage Components Overflow Detection Tests', () {
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

    group('Overview Section Overflow Tests', () {
      testWidgets(
        'Overview section does not overflow at any screen size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                CreditsOverviewSection(
                  planTier: PlanTier.pro,
                  subscriptionCredits: 1000000,
                  purchasedCredits: 500000,
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'Overview section with zero credits does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                CreditsOverviewSection(
                  planTier: PlanTier.none,
                  subscriptionCredits: 0,
                  purchasedCredits: 0,
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'Overview section with large numbers does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreditsOverviewSection(
                planTier: PlanTier.ultra,
                subscriptionCredits: 99999999,
                purchasedCredits: 99999999,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Overview section with large numbers overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('API Keys Section Overflow Tests', () {
      testWidgets(
        'API keys section with no keys does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
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

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'API keys section with multiple keys does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          final apiKeys = List.generate(
            3,
            (i) => AccountApiKey(
              id: i,
              name: 'API Key ${i + 1}',
              apiKey: 'sk_test_${'a' * 32}_key_$i',
              isActive: true,
              createdAt: DateTime.now(),
              accountApiUsageId: 1,
            ),
          );
          final usageStats = {0: 1000, 1: 5000, 2: 250};

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                SizedBox(
                  height: 600,
                  child: ApiKeysSection(
                    apiKeys: apiKeys,
                    apiKeyUsageStats: usageStats,
                    onShowCreateApiKeyDialog: () {},
                    onDeactivateApiKey: (_) {},
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'API keys section with long key names does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          final apiKeys = [
            AccountApiKey(
              id: 1,
              name: 'This is a very long API key name for production environment',
              apiKey: 'sk_test_${'a' * 50}',
              isActive: true,
              createdAt: DateTime.now(),
              accountApiUsageId: 1,
            ),
          ];

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              SizedBox(
                height: 400,
                child: ApiKeysSection(
                  apiKeys: apiKeys,
                  apiKeyUsageStats: const {1: 12345},
                  onShowCreateApiKeyDialog: () {},
                  onDeactivateApiKey: (_) {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'API keys section with long names overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('History Section Overflow Tests', () {
      testWidgets(
        'History section with no items does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                SizedBox(
                  height: 400,
                  child: HistorySection(
                    creditHistory: const [],
                    isLoadingMoreHistory: false,
                    hasMoreHistory: false,
                    onLoadMoreHistory: () {},
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'History section with multiple items does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

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

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                SizedBox(
                  height: 600,
                  child: HistorySection(
                    creditHistory: historyItems,
                    isLoadingMoreHistory: false,
                    hasMoreHistory: true,
                    onLoadMoreHistory: () {},
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('Purchase Section Overflow Tests', () {
      testWidgets(
        'Purchase section does not overflow at any screen size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                PurchaseSection(),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'Purchase section horizontal scroll works at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              PurchaseSection(),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Purchase section overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('API Key Card Overflow Tests', () {
      testWidgets(
        'API key card does not overflow at any screen size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          final apiKey = AccountApiKey(
            id: 1,
            name: 'Production API Key',
            apiKey: 'sk_live_${'a' * 40}',
            isActive: true,
            createdAt: DateTime.now(),
            accountApiUsageId: 1,
          );

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ApiKeyCard(
                    apiKey: apiKey,
                    usageCount: 12345,
                    canDelete: true,
                    onDelete: () {},
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'API key card with long name does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          final apiKey = AccountApiKey(
            id: 1,
            name: 'Super Long API Key Name For Production Environment v2.0',
            apiKey: 'sk_live_${'a' * 50}',
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
                  usageCount: 999999,
                  canDelete: true,
                  onDelete: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'API key card with long name overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );

      testWidgets(
        'Inactive API key card does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          final apiKey = AccountApiKey(
            id: 1,
            name: 'Deactivated Key',
            apiKey: 'sk_test_deactivated',
            isActive: false,
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
                  usageCount: 0,
                  canDelete: false,
                  onDelete: () {},
                ),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Inactive API key card overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('Create API Key Dialog Overflow Tests', () {
      testWidgets(
        'Create API key dialog does not overflow at any screen size',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                CreateApiKeyDialog(
                  onCreateApiKey: (name) async => null,
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'Create API key dialog with long text input does not overflow at 320px',
        (tester) async {
          overflowCapture.start();

          await tester.setScreenSize(TestDeviceSizes.smallPhone);
          await tester.pumpWidget(
            responsiveTestWrapper(
              sharedPreferences: prefs,
              CreateApiKeyDialog(
                onCreateApiKey: (name) async => null,
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 300));

          // Type a long name
          await tester.enterText(
            find.byType(TextFormField),
            'This is a very long API key name that should not cause overflow',
          );
          await tester.pumpAndSettle();

          expect(
            overflowCapture.hasOverflow,
            isFalse,
            reason:
                'Create API key dialog with long text overflows at 320px: ${overflowCapture.summary}',
          );

          overflowCapture.stop();
        },
      );
    });

    group('Credit History List Overflow Tests', () {
      testWidgets(
        'Credit history list with empty state does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                SizedBox(
                  height: 400,
                  child: CreditHistoryList(
                    creditHistory: const [],
                    isLoadingMore: false,
                    hasMore: false,
                    onLoadMore: () {},
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'Credit history list with various transaction types does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          final historyItems = [
            ApiCreditHistoryItem(
              date: DateTime.now(),
              transactionType: ApiCreditTransactionType.initialAccountCredit,
              monthlySubscriptionApiCreditDeposit:
                  MonthlySubscriptionApiCreditDeposit(
                planTier: PlanTier.none,
                creditsAmount: 100000,
              ),
              accountApiUsageId: 1,
            ),
            ApiCreditHistoryItem(
              date: DateTime.now().subtract(const Duration(days: 1)),
              transactionType: ApiCreditTransactionType.monthlySubscriptionDeposit,
              monthlySubscriptionApiCreditDeposit:
                  MonthlySubscriptionApiCreditDeposit(
                planTier: PlanTier.pro,
                creditsAmount: 1000000,
              ),
              accountApiUsageId: 1,
            ),
            ApiCreditHistoryItem(
              date: DateTime.now().subtract(const Duration(days: 2)),
              transactionType: ApiCreditTransactionType.creditPackagePurchase,
              apiCreditPackagePurchase: ApiCreditPackagePurchase(
                value: 2500000.0,
              ),
              accountApiUsageId: 1,
            ),
          ];

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
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

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );

      testWidgets(
        'Credit history list with loading more state does not overflow',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          final historyItems = List.generate(
            10,
            (i) => ApiCreditHistoryItem(
              date: DateTime.now().subtract(Duration(days: i)),
              transactionType: ApiCreditTransactionType.monthlySubscriptionDeposit,
              monthlySubscriptionApiCreditDeposit:
                  MonthlySubscriptionApiCreditDeposit(
                planTier: PlanTier.ultra,
                creditsAmount: 2000000,
              ),
              accountApiUsageId: 1,
            ),
          );

          for (final size in TestDeviceSizes.all) {
            overflowCapture.clear();

            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                SizedBox(
                  height: 600,
                  child: CreditHistoryList(
                    creditHistory: historyItems,
                    isLoadingMore: true,
                    hasMore: true,
                    onLoadMore: () {},
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });

    group('Breakpoint Edge Cases', () {
      testWidgets(
        'All components render correctly at breakpoint edges',
        (tester) async {
          final failures = <String>[];
          overflowCapture.start();

          final apiKey = AccountApiKey(
            id: 1,
            name: 'Test Key',
            apiKey: 'sk_test_key',
            isActive: true,
            createdAt: DateTime.now(),
            accountApiUsageId: 1,
          );

          for (final size in TestDeviceSizes.breakpointEdges) {
            overflowCapture.clear();

            // Test overview section at breakpoint
            await tester.setScreenSize(size);
            await tester.pumpWidget(
              responsiveTestWrapper(
                sharedPreferences: prefs,
                CreditsOverviewSection(
                  planTier: PlanTier.pro,
                  subscriptionCredits: 1000000,
                  purchasedCredits: 500000,
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 200));

            if (overflowCapture.hasOverflow) {
              failures.add(
                'Overview section overflows at breakpoint ${TestDeviceSizes.nameFor(size)}',
              );
            }

            overflowCapture.clear();

            // Test API key card at breakpoint
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

            if (overflowCapture.hasOverflow) {
              failures.add(
                'API key card overflows at breakpoint ${TestDeviceSizes.nameFor(size)}',
              );
            }
          }

          overflowCapture.stop();
          expect(failures, isEmpty, reason: failures.join('\n'));
        },
      );
    });
  });
}
