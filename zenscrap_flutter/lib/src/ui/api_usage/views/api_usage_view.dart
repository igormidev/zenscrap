import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_usage_provider.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_usage_state.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_keys_provider.dart';
import 'package:zenscrap_flutter/src/states/api_usage/api_keys_state.dart';
import 'package:zenscrap_flutter/src/states/api_usage/credit_history_provider.dart';
import 'package:zenscrap_flutter/src/states/api_usage/credit_history_state.dart';
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
      ref.read(creditHistoryProvider.notifier).loadCreditHistory();
    });
  }

  @override
  void dispose() {
    _isRefreshVN.dispose();
    super.dispose();
  }

  Future<void> _loadMoreHistory() async {
    await ref.read(creditHistoryProvider.notifier).loadMoreHistory();
  }

  Future<void> _createApiKey(String name) async {
    if (!mounted) return;
    final newKey =
        await ref.read(apiKeysProvider.notifier).createApiKey(context, name);
    if (newKey != null && mounted) {
      Navigator.of(context).pop();
      // Show the API key in a dialog for copying
      _showApiKeyDialog(newKey);
    }
  }

  void _showApiKeyDialog(AccountApiKey apiKey) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('New API Key Created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please copy and save this API key. You won\'t be able to see it again!',
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
                      Clipboard.setData(ClipboardData(text: apiKey.apiKey));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('API key copied to clipboard')),
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
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _deactivateApiKey(int keyId) async {
    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate API Key'),
        content: const Text(
            'Are you sure you want to deactivate this API key? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: context.c.error,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (!mounted) return;
    await ref.read(apiKeysProvider.notifier).deactivateApiKey(context, keyId);
  }

  void _showCreateApiKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateApiKeyDialog(
        onCreateApiKey: _createApiKey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planTier = ref.watch(accountProvider).maybeWhen(
          withData: (account) => account.planTier,
          orElse: () => PlanTier.none,
        );
    final apiUsageState = ref.watch(apiUsageProvider);
    final apiKeysState = ref.watch(apiKeysProvider);
    final creditHistoryState = ref.watch(creditHistoryProvider);

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
                ref.read(creditHistoryProvider.notifier).refresh();
              },
              child: const Text('Retry'),
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
      orElse: () => <CreditHistoryItem>[],
    );

    final isLoadingMoreHistory = creditHistoryState.maybeWhen(
      loaded: (creditHistory, hasMore, isLoadingMore) => isLoadingMore,
      orElse: () => false,
    );

    if (apiUsage == null) {
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;

          if (isMobile) {
            return MobileLayout(
              planTier: planTier,
              selectedTabIndex: _selectedTabIndex,
              onTabSelected: (index) =>
                  setState(() => _selectedTabIndex = index),
              apiUsage: apiUsage,
              apiKeys: apiKeys,
              apiKeyUsageStats: apiKeyUsageStats,
              creditHistory: creditHistory,
              isLoadingMoreHistory: isLoadingMoreHistory,
              onLoadMoreHistory: _loadMoreHistory,
              onShowCreateApiKeyDialog: _showCreateApiKeyDialog,
              onDeactivateApiKey: _deactivateApiKey,
            );
          } else {
            return DesktopLayout(
              isRefreshVN: _isRefreshVN,
              apiUsage: apiUsage,
              apiKeys: apiKeys,
              apiKeyUsageStats: apiKeyUsageStats,
              creditHistory: creditHistory,
              planTier: planTier,
              isLoadingMoreHistory: isLoadingMoreHistory,
              onLoadMoreHistory: _loadMoreHistory,
              onShowCreateApiKeyDialog: _showCreateApiKeyDialog,
              onDeactivateApiKey: _deactivateApiKey,
            );
          }
        },
      ),
    );
  }
}

class MobileLayout extends StatelessWidget {
  final int selectedTabIndex;
  final PlanTier planTier;
  final Function(int) onTabSelected;
  final AccountApiUsage apiUsage;
  final List<AccountApiKey> apiKeys;
  final Map<int, int> apiKeyUsageStats;
  final List<CreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final VoidCallback onLoadMoreHistory;
  final VoidCallback onShowCreateApiKeyDialog;
  final Function(int) onDeactivateApiKey;

  const MobileLayout({
    super.key,
    required this.planTier,
    required this.selectedTabIndex,
    required this.onTabSelected,
    required this.apiUsage,
    required this.apiKeys,
    required this.apiKeyUsageStats,
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.onLoadMoreHistory,
    required this.onShowCreateApiKeyDialog,
    required this.onDeactivateApiKey,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      OverviewTab(
        apiUsage: apiUsage,
        planTier: planTier,
      ),
      ApiKeysTab(
        apiKeys: apiKeys,
        apiKeyUsageStats: apiKeyUsageStats,
        onShowCreateApiKeyDialog: onShowCreateApiKeyDialog,
        onDeactivateApiKey: onDeactivateApiKey,
      ),
      HistoryTab(
        creditHistory: creditHistory,
        isLoadingMoreHistory: isLoadingMoreHistory,
        onLoadMoreHistory: onLoadMoreHistory,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedTabIndex,
        children: tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTabIndex,
        onDestinationSelected: onTabSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.key_outlined),
            selectedIcon: Icon(Icons.key),
            label: 'API Keys',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}

class DesktopLayout extends StatelessWidget {
  final PlanTier planTier;
  final AccountApiUsage apiUsage;
  final List<AccountApiKey> apiKeys;
  final Map<int, int> apiKeyUsageStats;
  final List<CreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final VoidCallback onLoadMoreHistory;
  final VoidCallback onShowCreateApiKeyDialog;
  final Function(int) onDeactivateApiKey;
  final ValueNotifier<bool> isRefreshVN;

  const DesktopLayout({
    super.key,
    required this.apiUsage,
    required this.planTier,
    required this.apiKeys,
    required this.apiKeyUsageStats,
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.onLoadMoreHistory,
    required this.onShowCreateApiKeyDialog,
    required this.onDeactivateApiKey,
    required this.isRefreshVN,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'API Usage',
                    style: context.t.displayMedium,
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: isRefreshVN,
                    builder: (context, isRefresh, _) {
                      return Consumer(builder: (context, ref, child) {
                        return FilledButton.tonalIcon(
                          onPressed: isRefresh
                              ? null
                              : () async {
                                  isRefreshVN.value = true;
                                  try {
                                    await Future.delayed(
                                        const Duration(milliseconds: 800));
                                    await ref.globalLoadingSetter(() async {
                                      await ref
                                          .read(apiUsageProvider.notifier)
                                          .loadApiUsage();
                                      await ref
                                          .read(apiKeysProvider.notifier)
                                          .loadApiKeys();
                                      await ref
                                          .read(creditHistoryProvider.notifier)
                                          .loadCreditHistory();
                                    });
                                  } finally {
                                    isRefreshVN.value = false;
                                  }
                                },
                          label: Text('Refresh'),
                          icon: isRefresh
                              ? CupertinoActivityIndicator()
                              : Icon(Icons.refresh),
                        );
                      });
                    }),
              ],
            ),
            const SizedBox(height: 16),
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
                SizedBox(width: 24),
                Expanded(
                  child: PurchaseSection(),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 4,
                    child: HistorySection(
                      creditHistory: creditHistory,
                      isLoadingMoreHistory: isLoadingMoreHistory,
                      onLoadMoreHistory: onLoadMoreHistory,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  final PlanTier planTier;
  final AccountApiUsage apiUsage;

  const OverviewTab(
      {super.key, required this.apiUsage, required this.planTier});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'API Usage Overview',
            style: context.t.headlineMedium,
          ),
          const SizedBox(height: 16),
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

class ApiKeysTab extends StatelessWidget {
  final List<AccountApiKey> apiKeys;
  final Map<int, int> apiKeyUsageStats;
  final VoidCallback onShowCreateApiKeyDialog;
  final Function(int) onDeactivateApiKey;

  const ApiKeysTab({
    super.key,
    required this.apiKeys,
    required this.apiKeyUsageStats,
    required this.onShowCreateApiKeyDialog,
    required this.onDeactivateApiKey,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'API Keys',
            style: context.t.headlineMedium,
          ),
          const SizedBox(height: 16),
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

class HistoryTab extends StatelessWidget {
  final List<CreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final VoidCallback onLoadMoreHistory;

  const HistoryTab({
    super.key,
    required this.creditHistory,
    required this.isLoadingMoreHistory,
    required this.onLoadMoreHistory,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Credit History',
            style: context.t.headlineMedium,
          ),
          const SizedBox(height: 16),
          HistorySection(
            creditHistory: creditHistory,
            isLoadingMoreHistory: isLoadingMoreHistory,
            onLoadMoreHistory: onLoadMoreHistory,
          ),
        ],
      ),
    );
  }
}
