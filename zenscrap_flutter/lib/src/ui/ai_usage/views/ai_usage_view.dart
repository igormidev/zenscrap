import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/consts.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_credit_history_provider.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_credit_history_state.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_usage_provider.dart';
import 'package:zenscrap_flutter/src/states/ai_usage/ai_usage_state.dart';

class AiUsageView extends ConsumerStatefulWidget {
  const AiUsageView({super.key});

  @override
  ConsumerState<AiUsageView> createState() => _AiUsageViewState();
}

class _AiUsageViewState extends ConsumerState<AiUsageView> {
  final ValueNotifier<bool> _isRefreshVN = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiUsageProvider.notifier).loadAiUsage();
      ref.read(aiCreditHistoryProvider.notifier).loadCreditHistory();
    });
  }

  @override
  void dispose() {
    _isRefreshVN.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _isRefreshVN.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      await ref.read(aiUsageProvider.notifier).loadAiUsage();
      await ref.read(aiCreditHistoryProvider.notifier).loadCreditHistory();
    } finally {
      _isRefreshVN.value = false;
    }
  }

  Future<void> _loadMoreHistory() async {
    await ref.read(aiCreditHistoryProvider.notifier).loadMoreHistory();
  }

  @override
  Widget build(BuildContext context) {
    final aiUsageState = ref.watch(aiUsageProvider);
    final creditHistoryState = ref.watch(aiCreditHistoryProvider);

    // Check if any provider is loading
    final isLoading = aiUsageState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        ) ||
        creditHistoryState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Check for errors
    final aiUsageError = aiUsageState.maybeWhen(
      withError: (error) => error,
      orElse: () => null,
    );

    if (aiUsageError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.c.error),
            const SizedBox(height: 16),
            Text(
              aiUsageError.title,
              style: context.t.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              aiUsageError.description,
              style: context.t.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(aiUsageProvider.notifier).refresh();
                ref.read(aiCreditHistoryProvider.notifier).refresh();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Extract data from states
    final aiUsage = aiUsageState.maybeWhen(
      loaded: (aiUsage) => aiUsage,
      orElse: () => null,
    );

    final creditHistory = creditHistoryState.maybeWhen(
      loaded: (creditHistory, hasMore, isLoadingMore) => creditHistory,
      orElse: () => <AICreditHistoryItem>[],
    );

    final isLoadingMoreHistory = creditHistoryState.maybeWhen(
      loaded: (creditHistory, hasMore, isLoadingMore) => isLoadingMore,
      orElse: () => false,
    );

    final hasMoreHistory = creditHistoryState.maybeWhen(
      loaded: (creditHistory, hasMore, isLoadingMore) => hasMore,
      orElse: () => false,
    );

    if (aiUsage == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ValueListenableBuilder(
      valueListenable: _isRefreshVN,
      builder: (context, isRefresh, child) {
        return Opacity(
          opacity: isRefresh ? 0.5 : 1.0,
          child: IgnorePointer(
            ignoring: isRefresh,
            child: child!,
          ),
        );
      },
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'AI Credits',
                      style: context.t.displaySmall,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isRefreshVN,
                    builder: (context, isRefresh, _) {
                      return FilledButton.tonalIcon(
                        onPressed: isRefresh ? null : _handleRefresh,
                        label: const Text('Refresh'),
                        icon: isRefresh
                            ? const CupertinoActivityIndicator()
                            : const Icon(Icons.refresh),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Overview section
              _AICreditsOverviewSection(aiUsage: aiUsage),
              const SizedBox(height: 20),
              // History section
              Expanded(
                child: _AICreditsHistorySection(
                  creditHistory: creditHistory,
                  isLoadingMoreHistory: isLoadingMoreHistory,
                  hasMoreHistory: hasMoreHistory,
                  onLoadMoreHistory: _loadMoreHistory,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _AICreditsOverviewSection extends StatelessWidget {
  final AccountAIUsage aiUsage;

  const _AICreditsOverviewSection({required this.aiUsage});

  @override
  Widget build(BuildContext context) {
    final remainingCredits = aiUsage.totalDollarsSpentFromTotalInUSD;
    final totalCredits = kDefaultMonthlyAICreditsInDollars;
    final usedCredits = totalCredits - remainingCredits;
    final usagePercentage = (usedCredits / totalCredits).clamp(0.0, 1.0);

    final hasOwnApiKey =
        aiUsage.userOpenAiApiKey != null && aiUsage.userOpenAiApiKey!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.outline.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: context.c.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'AI Credits Overview',
                style: context.t.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remaining Credits',
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.onSurface.withAlpha(150),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${remainingCredits.toStringAsFixed(2)}',
                      style: context.t.headlineMedium?.copyWith(
                        color: remainingCredits > 0
                            ? context.c.primary
                            : context.c.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly Limit',
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.onSurface.withAlpha(150),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${totalCredits.toStringAsFixed(2)}',
                      style: context.t.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usagePercentage,
              minHeight: 8,
              backgroundColor: context.c.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                usagePercentage > 0.9
                    ? context.c.error
                    : usagePercentage > 0.7
                        ? context.c.tertiary
                        : context.c.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(usagePercentage * 100).toStringAsFixed(1)}% used this month',
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
          if (hasOwnApiKey) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: context.c.primaryContainer.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.key,
                    size: 16,
                    color: context.c.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Using your own OpenAI API key',
                    style: context.t.bodySmall?.copyWith(
                      color: context.c.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AICreditsHistorySection extends StatelessWidget {
  final List<AICreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final bool hasMoreHistory;
  final VoidCallback onLoadMoreHistory;

  const _AICreditsHistorySection({
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.hasMoreHistory,
    required this.onLoadMoreHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.outline.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Credit History',
            style: context.t.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _AICreditHistoryList(
              creditHistory: creditHistory,
              isLoadingMore: isLoadingMoreHistory,
              hasMore: hasMoreHistory,
              onLoadMore: onLoadMoreHistory,
            ),
          ),
        ],
      ),
    );
  }
}

class _AICreditHistoryList extends StatelessWidget {
  final List<AICreditHistoryItem> creditHistory;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;

  const _AICreditHistoryList({
    required this.creditHistory,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (creditHistory.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: context.c.onSurface.withAlpha(100),
              ),
              const SizedBox(height: 16),
              Text(
                'No credit history yet',
                style: context.t.bodyLarge?.copyWith(
                  color: context.c.onSurface.withAlpha(150),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your AI credit transactions will appear here',
                style: context.t.bodySmall?.copyWith(
                  color: context.c.onSurface.withAlpha(100),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: creditHistory.length,
            separatorBuilder: (context, index) => Divider(
              color: context.c.outline.withAlpha(50),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final item = creditHistory[index];
              return _buildHistoryItem(context, item);
            },
          ),
        ),
        if (hasMore) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: isLoadingMore ? null : onLoadMore,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoadingMore
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.c.primary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.expand_more,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text('Load More'),
                      ],
                    ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, AICreditHistoryItem item) {
    final isSubscription = item.monthlySubscriptionAICreditDeposit != null;

    // Format date
    final dateFormatter = DateFormat('MMM d, y h:mm a');
    final dateStr = dateFormatter.format(item.date);

    IconData icon;
    String title;
    String subtitle;
    Color color;
    String? amount;

    if (isSubscription) {
      icon = Icons.calendar_month;
      final deposit = item.monthlySubscriptionAICreditDeposit!;
      final planName = deposit.planTier == PlanTier.none
          ? 'Free'
          : deposit.planTier.name.toUpperCase();
      title = 'Monthly AI Credits';
      subtitle = '$planName plan • $dateStr';
      color = context.c.primary;
      amount = '+\$${deposit.creditsAmountInDollars.toStringAsFixed(2)}';
    } else {
      icon = Icons.help_outline;
      title = 'Unknown Transaction';
      subtitle = dateStr;
      color = context.c.onSurface.withAlpha(150);
      amount = null;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: context.t.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.t.bodySmall?.copyWith(
          color: context.c.onSurface.withAlpha(150),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: amount != null
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: context.c.primaryContainer.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                amount,
                style: context.t.labelLarge?.copyWith(
                  color: context.c.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
