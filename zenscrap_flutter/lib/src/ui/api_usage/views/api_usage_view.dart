import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_usage_provider.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_usage_state.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_keys_provider.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_keys_state.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_credit_history_provider.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_credit_history_state.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/api_keys_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/history_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/overview_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/sections/purchase_section.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/create_api_key_dialog.dart';

class ApiUsageView extends ConsumerStatefulWidget {
  const ApiUsageView({super.key});

  @override
  ConsumerState<ApiUsageView> createState() => _ApiUsageViewState();
}

class _ApiUsageViewState extends ConsumerState<ApiUsageView> {
  final ValueNotifier<bool> _isRefreshVN = ValueNotifier<bool>(false);
  // For responsive design
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load data for all providers
    Future.microtask(() {
      ref.read(apiKeysProvider.notifier).loadApiKeys();
      ref.read(apiCreditHistoryProvider.notifier).loadCreditHistory();
    });
  }

  @override
  void dispose() {
    _isRefreshVN.dispose();
    super.dispose();
  }

  Future<void> _loadMoreHistory() async {
    await ref.read(apiCreditHistoryProvider.notifier).loadMoreHistory();
  }

  Future<void> _handleRefresh() async {
    // Track refresh click
    ref.read(analyticsServiceProvider).trackApiUsageRefreshClick();

    _isRefreshVN.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      await ref.globalLoadingSetter(() async {
        await ref.read(apiUsageProvider.notifier).loadApiUsage();
        await ref.read(apiKeysProvider.notifier).loadApiKeys();
        await ref.read(apiCreditHistoryProvider.notifier).loadCreditHistory();
      });
    } finally {
      _isRefreshVN.value = false;
    }
  }

  Future<AccountApiKey?> _createApiKey(String name) async {
    if (!mounted) return null;

    // Track create API key submit
    ref.read(analyticsServiceProvider).trackApiUsageCreateApiKeySubmit(
          keyName: name,
        );

    final newKey =
        await ref.read(apiKeysProvider.notifier).createApiKey(context, name);
    if (newKey != null && mounted) {
      // Track successful creation
      ref.read(analyticsServiceProvider).trackApiUsageCreateApiKeySuccess(
            keyId: newKey.id!,
            keyName: newKey.name,
          );
    }
    return newKey;
  }

  void _showApiKeyDialog(AccountApiKey apiKey) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.api_usage_new_api_key_created),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.api_usage_copy_api_key_warning,
              style: context.t.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.c.surfaceContainerHighest.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.c.outline),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      apiKey.apiKey,
                      style: context.t.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () {
                      // Track copy API key from dialog
                      ref
                          .read(analyticsServiceProvider)
                          .trackApiUsageCopyApiKeyDialog(
                            keyId: apiKey.id!,
                          );

                      Clipboard.setData(ClipboardData(text: apiKey.apiKey));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context)!.api_usage_api_key_copied)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.api_usage_done),
          ),
        ],
      ),
    );
  }

  Future<void> _deactivateApiKey(int keyId) async {
    // Find the key name for tracking
    final apiKeys = ref.read(apiKeysProvider).maybeWhen(
          loaded: (keys, _) => keys,
          orElse: () => <AccountApiKey>[],
        );
    final apiKey = apiKeys.firstWhere((key) => key.id == keyId);

    // Track deactivate click
    ref.read(analyticsServiceProvider).trackApiUsageDeactivateApiKeyClick(
          keyId: keyId,
          keyName: apiKey.name,
        );

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.api_usage_deactivate_api_key),
        content: Text(AppLocalizations.of(context)!.api_usage_deactivate_confirmation),
        actions: [
          TextButton(
            onPressed: () {
              // Track cancel
              ref
                  .read(analyticsServiceProvider)
                  .trackApiUsageDeactivateApiKeyCancel(
                    keyId: keyId,
                  );
              Navigator.of(context).pop(false);
            },
            child: Text(AppLocalizations.of(context)!.api_usage_cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: context.c.error,
            ),
            child: Text(AppLocalizations.of(context)!.api_usage_deactivate),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Track confirm
    ref.read(analyticsServiceProvider).trackApiUsageDeactivateApiKeyConfirm(
          keyId: keyId,
          keyName: apiKey.name,
        );

    if (!mounted) return;
    await ref.read(apiKeysProvider.notifier).deactivateApiKey(context, keyId);
  }

  Future<void> _showCreateApiKeyDialog() async {
    // Track create API key button click
    ref.read(analyticsServiceProvider).trackApiUsageCreateApiKeyClick();

    final newKey = await showDialog<AccountApiKey?>(
      context: context,
      builder: (context) => CreateApiKeyDialog(
        onCreateApiKey: _createApiKey,
      ),
    );

    // Show the API key dialog AFTER the create dialog is fully closed
    if (newKey != null && mounted) {
      _showApiKeyDialog(newKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final analytics = ref.read(analyticsServiceProvider);
    final planTier = ref.watch(accountProvider).maybeWhen(
          withData: (account) => account.planTier,
          orElse: () => PlanTier.none,
        );
    final apiUsageState = ref.watch(apiUsageProvider);
    final apiKeysState = ref.watch(apiKeysProvider);
    final creditHistoryState = ref.watch(apiCreditHistoryProvider);

    // Check if any provider is loading
    final isLoading = apiUsageState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        ) ||
        apiKeysState.maybeWhen(
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
    final apiUsageError = apiUsageState.maybeWhen(
      withError: (error) => error,
      orElse: () => null,
    );

    if (apiUsageError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.c.error),
            const SizedBox(height: 16),
            Text(
              apiUsageError.title,
              style: context.t.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              apiUsageError.description,
              style: context.t.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(apiUsageProvider.notifier).refresh();
                ref.read(apiKeysProvider.notifier).refresh();
                ref.read(apiCreditHistoryProvider.notifier).refresh();
              },
              child: Text(AppLocalizations.of(context)!.api_usage_retry),
            ),
          ],
        ),
      );
    }

    // Extract data from states
    final apiUsage = apiUsageState.maybeWhen(
      loaded: (apiUsage) => apiUsage,
      orElse: () => null,
    );

    final apiKeys = apiKeysState.maybeWhen(
      loaded: (apiKeys, usageStats) => apiKeys,
      orElse: () => <AccountApiKey>[],
    );

    final apiKeyUsageStats = apiKeysState.maybeWhen(
      loaded: (apiKeys, usageStats) => usageStats,
      orElse: () => <int, int>{},
    );

    final creditHistory = creditHistoryState.maybeWhen(
      loaded: (creditHistory, hasMore, isLoadingMore) => creditHistory,
      orElse: () => <ApiCreditHistoryItem>[],
    );

    final isLoadingMoreHistory = creditHistoryState.maybeWhen(
      loaded: (creditHistory, hasMore, isLoadingMore) => isLoadingMore,
      orElse: () => false,
    );

    final hasMoreHistory = creditHistoryState.maybeWhen(
      loaded: (creditHistory, hasMore, isLoadingMore) => hasMore,
      orElse: () => false,
    );

    if (apiUsage == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Track page view with credit and API key data
    final totalCredits = (apiUsage.creditUsage?.subscriptionCredits ?? 0) +
        (apiUsage.creditUsage?.purchasedCredits ?? 0);
    analytics.trackApiUsagePageView(
      subscriptionCredits: apiUsage.creditUsage?.subscriptionCredits ?? 0,
      purchasedCredits: apiUsage.creditUsage?.purchasedCredits ?? 0,
      totalCredits: totalCredits,
      apiKeyCount: apiKeys.length,
    );

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
      child: ResponsiveBuilder(
        compact: (context, constraints) => _CompactLayout(
          planTier: planTier,
          selectedTabIndex: _selectedTabIndex,
          onTabSelected: (index) =>
              setState(() => _selectedTabIndex = index),
          apiUsage: apiUsage,
          apiKeys: apiKeys,
          apiKeyUsageStats: apiKeyUsageStats,
          creditHistory: creditHistory,
          isLoadingMoreHistory: isLoadingMoreHistory,
          hasMoreHistory: hasMoreHistory,
          onLoadMoreHistory: _loadMoreHistory,
          onShowCreateApiKeyDialog: _showCreateApiKeyDialog,
          onDeactivateApiKey: _deactivateApiKey,
        ),
        expanded: (context, constraints) => _ExpandedLayout(
          isRefreshVN: _isRefreshVN,
          apiUsage: apiUsage,
          apiKeys: apiKeys,
          apiKeyUsageStats: apiKeyUsageStats,
          creditHistory: creditHistory,
          planTier: planTier,
          isLoadingMoreHistory: isLoadingMoreHistory,
          hasMoreHistory: hasMoreHistory,
          onLoadMoreHistory: _loadMoreHistory,
          onShowCreateApiKeyDialog: _showCreateApiKeyDialog,
          onDeactivateApiKey: _deactivateApiKey,
          onRefresh: _handleRefresh,
        ),
      ),
    );
  }
}

class _CompactLayout extends ConsumerWidget {
  final int selectedTabIndex;
  final PlanTier planTier;
  final Function(int) onTabSelected;
  final AccountApiUsage apiUsage;
  final List<AccountApiKey> apiKeys;
  final Map<int, int> apiKeyUsageStats;
  final List<ApiCreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final bool hasMoreHistory;
  final VoidCallback onLoadMoreHistory;
  final VoidCallback onShowCreateApiKeyDialog;
  final Function(int) onDeactivateApiKey;

  const _CompactLayout({
    required this.planTier,
    required this.selectedTabIndex,
    required this.onTabSelected,
    required this.apiUsage,
    required this.apiKeys,
    required this.apiKeyUsageStats,
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.hasMoreHistory,
    required this.onLoadMoreHistory,
    required this.onShowCreateApiKeyDialog,
    required this.onDeactivateApiKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabs = [
      _OverviewTab(
        apiUsage: apiUsage,
        planTier: planTier,
      ),
      _ApiKeysTab(
        apiKeys: apiKeys,
        apiKeyUsageStats: apiKeyUsageStats,
        onShowCreateApiKeyDialog: onShowCreateApiKeyDialog,
        onDeactivateApiKey: onDeactivateApiKey,
      ),
      _HistoryTab(
        creditHistory: creditHistory,
        isLoadingMoreHistory: isLoadingMoreHistory,
        hasMoreHistory: hasMoreHistory,
        onLoadMoreHistory: onLoadMoreHistory,
      ),
    ];

    final l10n = AppLocalizations.of(context)!;
    final tabNames = [l10n.api_usage_overview, l10n.api_usage_api_keys, l10n.api_usage_history];

    return Scaffold(
      body: IndexedStack(
        index: selectedTabIndex,
        children: tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTabIndex,
        onDestinationSelected: (index) {
          // Track tab selection
          ref.read(analyticsServiceProvider).trackApiUsageMobileTabSelect(
                tabName: tabNames[index],
                tabIndex: index,
              );
          onTabSelected(index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: l10n.api_usage_overview,
          ),
          NavigationDestination(
            icon: Icon(Icons.key_outlined),
            selectedIcon: Icon(Icons.key),
            label: l10n.api_usage_api_keys,
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: l10n.api_usage_history,
          ),
        ],
      ),
    );
  }
}

class _ExpandedLayout extends StatelessWidget {
  final PlanTier planTier;
  final AccountApiUsage apiUsage;
  final List<AccountApiKey> apiKeys;
  final Map<int, int> apiKeyUsageStats;
  final List<ApiCreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final bool hasMoreHistory;
  final VoidCallback onLoadMoreHistory;
  final VoidCallback onShowCreateApiKeyDialog;
  final Function(int) onDeactivateApiKey;
  final ValueNotifier<bool> isRefreshVN;
  final VoidCallback onRefresh;

  const _ExpandedLayout({
    required this.apiUsage,
    required this.planTier,
    required this.apiKeys,
    required this.apiKeyUsageStats,
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.hasMoreHistory,
    required this.onLoadMoreHistory,
    required this.onShowCreateApiKeyDialog,
    required this.onDeactivateApiKey,
    required this.isRefreshVN,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = context.responsiveValue(
      compact: 16.0,
      medium: 24.0,
      expanded: 32.0,
    );
    final verticalSpacing = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 24.0,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1210),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: verticalSpacing),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.api_usage_page_title,
                      style: context.t.displaySmall,
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable: isRefreshVN,
                      builder: (context, isRefresh, _) {
                        return FilledButton.tonalIcon(
                          onPressed: isRefresh ? null : onRefresh,
                          label: Text(AppLocalizations.of(context)!.api_usage_refresh),
                          icon: isRefresh
                              ? CupertinoActivityIndicator()
                              : Icon(Icons.refresh),
                        );
                      }),
                ],
              ),
              SizedBox(height: verticalSpacing),
              Row(
                children: [
                  Expanded(
                    child: CreditsOverviewSection(
                      planTier: planTier,
                      subscriptionCredits:
                          apiUsage.creditUsage!.subscriptionCredits,
                      purchasedCredits: apiUsage.creditUsage!.purchasedCredits,
                    ),
                  ),
                  SizedBox(width: verticalSpacing),
                  Expanded(
                    child: PurchaseSection(),
                  ),
                ],
              ),
              SizedBox(height: verticalSpacing),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: ApiKeysSection(
                        apiKeys: apiKeys,
                        apiKeyUsageStats: apiKeyUsageStats,
                        onShowCreateApiKeyDialog: onShowCreateApiKeyDialog,
                        onDeactivateApiKey: onDeactivateApiKey,
                      ),
                    ),
                    SizedBox(width: verticalSpacing),
                    Expanded(
                      flex: 4,
                      child: HistorySection(
                        creditHistory: creditHistory,
                        isLoadingMoreHistory: isLoadingMoreHistory,
                        hasMoreHistory: hasMoreHistory,
                        onLoadMoreHistory: onLoadMoreHistory,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalSpacing),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final PlanTier planTier;
  final AccountApiUsage apiUsage;

  const _OverviewTab({
    required this.apiUsage,
    required this.planTier,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 24.0,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.api_usage_overview_title,
            style: context.t.headlineMedium,
          ),
          SizedBox(height: padding),
          CreditsOverviewSection(
            planTier: planTier,
            subscriptionCredits: apiUsage.creditUsage!.subscriptionCredits,
            purchasedCredits: apiUsage.creditUsage!.purchasedCredits,
          ),
        ],
      ),
    );
  }
}

class _ApiKeysTab extends StatelessWidget {
  final List<AccountApiKey> apiKeys;
  final Map<int, int> apiKeyUsageStats;
  final VoidCallback onShowCreateApiKeyDialog;
  final Function(int) onDeactivateApiKey;

  const _ApiKeysTab({
    required this.apiKeys,
    required this.apiKeyUsageStats,
    required this.onShowCreateApiKeyDialog,
    required this.onDeactivateApiKey,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 24.0,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.api_usage_api_keys,
            style: context.t.headlineMedium,
          ),
          SizedBox(height: padding),
          ApiKeysSection(
            apiKeys: apiKeys,
            apiKeyUsageStats: apiKeyUsageStats,
            onShowCreateApiKeyDialog: onShowCreateApiKeyDialog,
            onDeactivateApiKey: onDeactivateApiKey,
          ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final List<ApiCreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final bool hasMoreHistory;
  final VoidCallback onLoadMoreHistory;

  const _HistoryTab({
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.hasMoreHistory,
    required this.onLoadMoreHistory,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 24.0,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.api_usage_credit_history,
            style: context.t.headlineMedium,
          ),
          SizedBox(height: padding),
          HistorySection(
            creditHistory: creditHistory,
            isLoadingMoreHistory: isLoadingMoreHistory,
            hasMoreHistory: hasMoreHistory,
            onLoadMoreHistory: onLoadMoreHistory,
          ),
        ],
      ),
    );
  }
}
