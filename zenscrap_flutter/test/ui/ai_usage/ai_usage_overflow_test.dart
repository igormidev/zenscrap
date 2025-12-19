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
import 'package:zenscrap_flutter/src/ui/ai_usage/views/ai_usage_view.dart';
import '../../responsive_test_utils.dart';

void main() {
  group('AiUsageView Overflow Tests', () {
    late AccountAIUsage mockAiUsage;
    late List<AICreditHistoryItem> mockCreditHistory;
    late List<AutoFixSession> mockSessions;

    setUp(() {
      // Create mock data
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

    testWidgets('renders without overflow on all screen sizes',
        (tester) async {
      final overflowCapture = OverflowErrorCapture();
      final failures = <String>[];

      overflowCapture.start();

      for (final size in TestDeviceSizes.all) {
        overflowCapture.clear();

        await tester.setScreenSize(size);
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

        if (overflowCapture.hasOverflow) {
          failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
        }
      }

      overflowCapture.stop();

      expect(
        failures,
        isEmpty,
        reason: failures.isEmpty
            ? 'No overflows detected'
            : 'Overflow errors detected:\n${failures.join('\n')}',
      );
    });

    testWidgets('handles breakpoint edges without overflow', (tester) async {
      final overflowCapture = OverflowErrorCapture();
      final failures = <String>[];

      overflowCapture.start();

      for (final size in TestDeviceSizes.breakpointEdges) {
        overflowCapture.clear();

        await tester.setScreenSize(size);
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

        if (overflowCapture.hasOverflow) {
          failures.add('Overflows at ${TestDeviceSizes.nameFor(size)}');
        }
      }

      overflowCapture.stop();

      expect(
        failures,
        isEmpty,
        reason: failures.isEmpty
            ? 'No overflows at breakpoint edges'
            : 'Overflow errors at breakpoint edges:\n${failures.join('\n')}',
      );
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
