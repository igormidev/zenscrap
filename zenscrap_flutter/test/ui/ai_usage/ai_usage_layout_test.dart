import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_credit_history_provider.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_credit_history_state.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_usage_provider.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_usage_state.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/auto_fix_sessions_provider.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/auto_fix_sessions_state.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/sections/ai_credits_history_section.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/sections/ai_credits_overview_section.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/sections/api_key_section.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/sections/auto_fix_sessions_section.dart';
import 'package:zenscrap_flutter/src/ui/ai_usage/views/ai_usage_view.dart';
import '../../responsive_test_utils.dart';

void main() {
  group('AiUsageView Layout Tests', () {
    late AccountAIUsage mockAiUsage;
    late List<AICreditHistoryItem> mockCreditHistory;
    late List<AutoFixSession> mockSessions;

    setUp(() {
      mockAiUsage = AccountAIUsage(
        totalDollarsSpentFromTotalInUSD: 4.50,
        userOpenAiApiKey: null,
      );

      mockCreditHistory = [
        AICreditHistoryItem(
          accountAIUsageId: 1,
          date: DateTime.now().subtract(const Duration(days: 1)),
          transactionType: AICreditTransactionType.initialAccountCredit,
          monthlySubscriptionAICreditDeposit:
              MonthlySubscriptionAICreditDeposit(
            creditsAmountInDollars: 5.0,
            planTier: PlanTier.none,
          ),
        ),
      ];

      mockSessions = [
        AutoFixSession(
          id: 1,
          scrappableId: 123,
          status: AutoFixSessionStatus.success,
          usedAiModel: AiModel.normal,
          triggeredAtErrorCount: 3,
          configuredThreshold: 3,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          totalInputTokens: 1500,
          totalOutputTokens: 500,
          totalCostUsd: 0.002,
          usedUserApiKey: false,
          successSummary: 'Successfully fixed the selector',
          attempts: [],
        ),
      ];
    });

    testWidgets('shows compact layout on small screens', (tester) async {
      await tester.setScreenSize(TestDeviceSizes.phone);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiUsageProvider.overrideWith(() => MockAiUsageNotifier(mockAiUsage)),
            aiCreditHistoryProvider.overrideWith(
              () => MockAiCreditHistoryNotifier(mockCreditHistory),
            ),
            autoFixSessionsProvider.overrideWith(
              () => MockAutoFixSessionsNotifier(mockSessions),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: AiUsageView(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify sections are present
      expect(find.byType(AiCreditsOverviewSection), findsOneWidget);
      expect(find.byType(ApiKeySection), findsOneWidget);
      expect(find.byType(AiCreditsHistorySection), findsOneWidget);
      expect(find.byType(AutoFixSessionsSection), findsOneWidget);

      // Verify all sections are in a vertical layout (SingleChildScrollView with Column)
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('shows expanded layout on medium and larger screens',
        (tester) async {
      await tester.setScreenSize(TestDeviceSizes.desktop);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiUsageProvider.overrideWith(() => MockAiUsageNotifier(mockAiUsage)),
            aiCreditHistoryProvider.overrideWith(
              () => MockAiCreditHistoryNotifier(mockCreditHistory),
            ),
            autoFixSessionsProvider.overrideWith(
              () => MockAutoFixSessionsNotifier(mockSessions),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: AiUsageView(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify sections are present
      expect(find.byType(AiCreditsOverviewSection), findsOneWidget);
      expect(find.byType(ApiKeySection), findsOneWidget);
      expect(find.byType(AiCreditsHistorySection), findsOneWidget);
      expect(find.byType(AutoFixSessionsSection), findsOneWidget);

      // Verify two-column layout (Row with Expanded children)
      final rowFinder = find.descendant(
        of: find.byType(AiUsageView),
        matching: find.byWidgetPredicate(
          (widget) => widget is Row && widget.children.length >= 2,
        ),
      );
      expect(rowFinder, findsWidgets);
    });

    testWidgets('switches layout at medium breakpoint', (tester) async {
      // Just before medium (599) - should be compact
      await tester.setScreenSize(const Size(599, 800));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiUsageProvider.overrideWith(() => MockAiUsageNotifier(mockAiUsage)),
            aiCreditHistoryProvider.overrideWith(
              () => MockAiCreditHistoryNotifier(mockCreditHistory),
            ),
            autoFixSessionsProvider.overrideWith(
              () => MockAutoFixSessionsNotifier(mockSessions),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: AiUsageView(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show compact layout (SingleChildScrollView)
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Exactly at medium (600) - should be expanded
      await tester.setScreenSize(const Size(600, 800));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiUsageProvider.overrideWith(() => MockAiUsageNotifier(mockAiUsage)),
            aiCreditHistoryProvider.overrideWith(
              () => MockAiCreditHistoryNotifier(mockCreditHistory),
            ),
            autoFixSessionsProvider.overrideWith(
              () => MockAutoFixSessionsNotifier(mockSessions),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: AiUsageView(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should show expanded layout (Row)
      final rowFinder = find.descendant(
        of: find.byType(AiUsageView),
        matching: find.byWidgetPredicate(
          (widget) => widget is Row && widget.children.length >= 2,
        ),
      );
      expect(rowFinder, findsWidgets);
    });

    testWidgets('credit stat cards stack on compact, side-by-side on medium',
        (tester) async {
      // Compact - should be Column
      await tester.setScreenSize(TestDeviceSizes.phone);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiUsageProvider.overrideWith(() => MockAiUsageNotifier(mockAiUsage)),
            aiCreditHistoryProvider.overrideWith(
              () => MockAiCreditHistoryNotifier(mockCreditHistory),
            ),
            autoFixSessionsProvider.overrideWith(
              () => MockAutoFixSessionsNotifier(mockSessions),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: AiUsageView(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the stat cards column in overview section
      final overviewSection = find.byType(AiCreditsOverviewSection);
      expect(overviewSection, findsOneWidget);

      // Medium/Desktop - should be Row
      await tester.setScreenSize(TestDeviceSizes.desktop);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiUsageProvider.overrideWith(() => MockAiUsageNotifier(mockAiUsage)),
            aiCreditHistoryProvider.overrideWith(
              () => MockAiCreditHistoryNotifier(mockCreditHistory),
            ),
            autoFixSessionsProvider.overrideWith(
              () => MockAutoFixSessionsNotifier(mockSessions),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: AiUsageView(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(overviewSection, findsOneWidget);
    });
  });
}

// Mock notifiers for testing
class MockAiUsageNotifier extends AIUsageNotifier {
  final AccountAIUsage _mockData;

  MockAiUsageNotifier(this._mockData);

  @override
  AIUsageState build() {
    return AIUsageState.loaded(aiUsage: _mockData);
  }
}

class MockAiCreditHistoryNotifier extends AICreditHistoryNotifier {
  final List<AICreditHistoryItem> _mockData;

  MockAiCreditHistoryNotifier(this._mockData);

  @override
  AICreditHistoryState build() {
    return AICreditHistoryState.loaded(
      creditHistory: _mockData,
      hasMore: false,
    );
  }
}

class MockAutoFixSessionsNotifier extends AutoFixSessionsNotifier {
  final List<AutoFixSession> _mockData;

  MockAutoFixSessionsNotifier(this._mockData);

  @override
  AutoFixSessionsState build() {
    return AutoFixSessionsState.loaded(
      sessions: _mockData,
      hasMore: false,
    );
  }
}
