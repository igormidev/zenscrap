import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
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
      ref.read(autoFixSessionsProvider.notifier).loadSessions();
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
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      await Future.wait([
        ref.read(aiUsageProvider.notifier).loadAiUsage(),
        ref.read(aiCreditHistoryProvider.notifier).loadCreditHistory(),
        ref.read(autoFixSessionsProvider.notifier).loadSessions(),
      ]);
    } finally {
      _isRefreshVN.value = false;
    }
  }

  Future<void> _loadMoreHistory() async {
    await ref.read(aiCreditHistoryProvider.notifier).loadMoreHistory();
  }

  Future<void> _loadMoreSessions() async {
    await ref.read(autoFixSessionsProvider.notifier).loadMoreSessions();
  }

  @override
  Widget build(BuildContext context) {
    final aiUsageState = ref.watch(aiUsageProvider);
    final creditHistoryState = ref.watch(aiCreditHistoryProvider);
    final autoFixSessionsState = ref.watch(autoFixSessionsProvider);

    // Check if any provider is loading
    final isLoading = aiUsageState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        ) ||
        creditHistoryState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        ) ||
        autoFixSessionsState.maybeWhen(
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
      return _ErrorState(
        error: aiUsageError,
        onRetry: () {
          ref.read(aiUsageProvider.notifier).refresh();
          ref.read(aiCreditHistoryProvider.notifier).refresh();
          ref.read(autoFixSessionsProvider.notifier).refresh();
        },
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

    final autoFixSessions = autoFixSessionsState.maybeWhen(
      loaded: (sessions, hasMore, isLoadingMore) => sessions,
      orElse: () => <AutoFixSession>[],
    );

    final isLoadingMoreSessions = autoFixSessionsState.maybeWhen(
      loaded: (sessions, hasMore, isLoadingMore) => isLoadingMore,
      orElse: () => false,
    );

    final hasMoreSessions = autoFixSessionsState.maybeWhen(
      loaded: (sessions, hasMore, isLoadingMore) => hasMore,
      orElse: () => false,
    );

    if (aiUsage == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ValueListenableBuilder(
        valueListenable: _isRefreshVN,
        builder: (context, isRefresh, child) {
          return AnimatedOpacity(
            opacity: isRefresh ? 0.6 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: isRefresh,
              child: child!,
            ),
          );
        },
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.responsiveValue(
                compact: double.infinity,
                medium: 900,
                expanded: 1200,
              ),
            ),
            child: Padding(
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
                  _Header(
                    isRefreshing: _isRefreshVN,
                    onRefresh: _handleRefresh,
                  ),
                  ResponsiveGap.vertical(
                    compactSize: 16,
                    mediumSize: 20,
                    expandedSize: 24,
                  ),
                  // Content
                  Expanded(
                    child: ResponsiveBuilder(
                      compact: (context, constraints) =>
                          _CompactLayout(
                            aiUsage: aiUsage,
                            creditHistory: creditHistory,
                            isLoadingMoreHistory: isLoadingMoreHistory,
                            hasMoreHistory: hasMoreHistory,
                            onLoadMoreHistory: _loadMoreHistory,
                            autoFixSessions: autoFixSessions,
                            isLoadingMoreSessions: isLoadingMoreSessions,
                            hasMoreSessions: hasMoreSessions,
                            onLoadMoreSessions: _loadMoreSessions,
                          ),
                      medium: (context, constraints) =>
                          _ExpandedLayout(
                            aiUsage: aiUsage,
                            creditHistory: creditHistory,
                            isLoadingMoreHistory: isLoadingMoreHistory,
                            hasMoreHistory: hasMoreHistory,
                            onLoadMoreHistory: _loadMoreHistory,
                            autoFixSessions: autoFixSessions,
                            isLoadingMoreSessions: isLoadingMoreSessions,
                            hasMoreSessions: hasMoreSessions,
                            onLoadMoreSessions: _loadMoreSessions,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final ValueNotifier<bool> isRefreshing;
  final VoidCallback onRefresh;

  const _Header({
    required this.isRefreshing,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.ai_usage_title,
            style: context.t.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isRefreshing,
          builder: (context, isRefresh, _) {
            return FilledButton.icon(
              onPressed: isRefresh ? null : onRefresh,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: Text(AppLocalizations.of(context)!.ai_usage_refresh),
              icon: isRefresh
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : const Icon(Icons.refresh, size: 20),
            );
          },
        ),
      ],
    );
  }
}

class _CompactLayout extends StatelessWidget {
  final AccountAIUsage aiUsage;
  final List<AICreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final bool hasMoreHistory;
  final VoidCallback onLoadMoreHistory;
  final List<AutoFixSession> autoFixSessions;
  final bool isLoadingMoreSessions;
  final bool hasMoreSessions;
  final VoidCallback onLoadMoreSessions;

  const _CompactLayout({
    required this.aiUsage,
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.hasMoreHistory,
    required this.onLoadMoreHistory,
    required this.autoFixSessions,
    required this.isLoadingMoreSessions,
    required this.hasMoreSessions,
    required this.onLoadMoreSessions,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AiCreditsOverviewSection(aiUsage: aiUsage),
          const SizedBox(height: 16),
          ApiKeySection(aiUsage: aiUsage),
          const SizedBox(height: 16),
          SizedBox(
            height: 400,
            child: AiCreditsHistorySection(
              creditHistory: creditHistory,
              isLoadingMoreHistory: isLoadingMoreHistory,
              hasMoreHistory: hasMoreHistory,
              onLoadMoreHistory: onLoadMoreHistory,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 500,
            child: AutoFixSessionsSection(
              sessions: autoFixSessions,
              isLoadingMore: isLoadingMoreSessions,
              hasMore: hasMoreSessions,
              onLoadMore: onLoadMoreSessions,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedLayout extends StatelessWidget {
  final AccountAIUsage aiUsage;
  final List<AICreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final bool hasMoreHistory;
  final VoidCallback onLoadMoreHistory;
  final List<AutoFixSession> autoFixSessions;
  final bool isLoadingMoreSessions;
  final bool hasMoreSessions;
  final VoidCallback onLoadMoreSessions;

  const _ExpandedLayout({
    required this.aiUsage,
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.hasMoreHistory,
    required this.onLoadMoreHistory,
    required this.autoFixSessions,
    required this.isLoadingMoreSessions,
    required this.hasMoreSessions,
    required this.onLoadMoreSessions,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 24.0,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column: Overview + API Key + History
        Expanded(
          child: Column(
            children: [
              AiCreditsOverviewSection(aiUsage: aiUsage),
              SizedBox(height: spacing),
              ApiKeySection(aiUsage: aiUsage),
              SizedBox(height: spacing),
              Expanded(
                child: AiCreditsHistorySection(
                  creditHistory: creditHistory,
                  isLoadingMoreHistory: isLoadingMoreHistory,
                  hasMoreHistory: hasMoreHistory,
                  onLoadMoreHistory: onLoadMoreHistory,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: spacing),
        // Right column: Auto-Fix Sessions
        Expanded(
          child: AutoFixSessionsSection(
            sessions: autoFixSessions,
            isLoadingMore: isLoadingMoreSessions,
            hasMore: hasMoreSessions,
            onLoadMore: onLoadMoreSessions,
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final ZenScrapException error;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.c.error,
            ),
            const SizedBox(height: 16),
            Text(
              error.title,
              style: context.t.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.description,
              style: context.t.bodyMedium?.copyWith(
                color: context.c.onSurface.withAlpha(150),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(AppLocalizations.of(context)!.ai_usage_retry),
            ),
          ],
        ),
      ),
    );
  }
}
