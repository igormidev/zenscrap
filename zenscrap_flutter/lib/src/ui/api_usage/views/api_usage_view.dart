import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/api_key_card.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/credit_history_list.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/credits_overview_card.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/create_api_key_dialog.dart';

class ApiUsageView extends ConsumerStatefulWidget {
  const ApiUsageView({super.key});

  @override
  ConsumerState<ApiUsageView> createState() => _ApiUsageViewState();
}

class _ApiUsageViewState extends ConsumerState<ApiUsageView> {
  AccountApiUsage? _apiUsage;
  List<AccountApiKey> _apiKeys = [];
  List<CreditHistoryItem> _creditHistory = [];
  Map<int, int> _apiKeyUsageStats = {};
  bool _isLoading = true;
  bool _isLoadingMoreHistory = false;
  int _historyOffset = 0;
  static const int _historyLimit = 20;

  // For responsive design
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final client = ref.read(clientProvider);

    try {
      // Load all data in parallel
      final results = await Future.wait<dynamic>([
        client.privateApiUsage.getApiUsageInfo(),
        client.privateApiUsage.getActiveApiKeys(),
        client.privateApiUsage
            .getCreditHistory(offset: 0, limit: _historyLimit),
        client.privateApiUsage.getApiKeyUsageStats(),
      ]);

      setState(() {
        _apiUsage = results[0] as AccountApiUsage;
        _apiKeys = results[1] as List<AccountApiKey>;
        _creditHistory = results[2] as List<CreditHistoryItem>;
        _apiKeyUsageStats = results[3] as Map<int, int>;
        _historyOffset = _historyLimit;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load API usage data: $e'),
            backgroundColor: context.c.error,
          ),
        );
      }
    }
  }

  Future<void> _loadMoreHistory() async {
    if (_isLoadingMoreHistory) return;

    setState(() => _isLoadingMoreHistory = true);

    final client = ref.read(clientProvider);

    try {
      final moreHistory = await client.privateApiUsage.getCreditHistory(
        offset: _historyOffset,
        limit: _historyLimit,
      );

      setState(() {
        _creditHistory.addAll(moreHistory);
        _historyOffset += _historyLimit;
        _isLoadingMoreHistory = false;
      });
    } catch (e) {
      setState(() => _isLoadingMoreHistory = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load more history: $e'),
            backgroundColor: context.c.error,
          ),
        );
      }
    }
  }

  Future<void> _createApiKey(String name) async {
    final client = ref.read(clientProvider);

    try {
      final newKey = await client.privateApiUsage.createApiKey(name: name);

      // Reload data to get updated stats
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('API key created successfully'),
            backgroundColor: context.c.primary,
          ),
        );
        if (mounted) {
          Navigator.of(context).pop();
        }
        // Show the API key in a dialog for copying
        _showApiKeyDialog(newKey);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create API key: $e'),
            backgroundColor: context.c.error,
          ),
        );
      }
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
        title: Text('Deactivate API Key'),
        content: Text(
            'Are you sure you want to deactivate this API key? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: context.c.error,
            ),
            child: Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final client = ref.read(clientProvider);

    try {
      await client.privateApiUsage.deactivateApiKey(apiKeyId: keyId);
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('API key deactivated successfully'),
            backgroundColor: context.c.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to deactivate API key: $e'),
            backgroundColor: context.c.error,
          ),
        );
      }
    }
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
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_apiUsage == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.c.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load API usage data',
              style: context.t.headlineSmall,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadData,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        if (isMobile) {
          return MobileLayout(
            selectedTabIndex: _selectedTabIndex,
            onTabSelected: (index) => setState(() => _selectedTabIndex = index),
            apiUsage: _apiUsage!,
            apiKeys: _apiKeys,
            apiKeyUsageStats: _apiKeyUsageStats,
            creditHistory: _creditHistory,
            isLoadingMoreHistory: _isLoadingMoreHistory,
            onLoadMoreHistory: _loadMoreHistory,
            onShowCreateApiKeyDialog: _showCreateApiKeyDialog,
            onDeactivateApiKey: _deactivateApiKey,
          );
        } else {
          return DesktopLayout(
            apiUsage: _apiUsage!,
            apiKeys: _apiKeys,
            apiKeyUsageStats: _apiKeyUsageStats,
            creditHistory: _creditHistory,
            isLoadingMoreHistory: _isLoadingMoreHistory,
            onLoadMoreHistory: _loadMoreHistory,
            onShowCreateApiKeyDialog: _showCreateApiKeyDialog,
            onDeactivateApiKey: _deactivateApiKey,
          );
        }
      },
    );
  }

}

class MobileLayout extends StatelessWidget {
  final int selectedTabIndex;
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
      OverviewTab(apiUsage: apiUsage),
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
  final AccountApiUsage apiUsage;
  final List<AccountApiKey> apiKeys;
  final Map<int, int> apiKeyUsageStats;
  final List<CreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final VoidCallback onLoadMoreHistory;
  final VoidCallback onShowCreateApiKeyDialog;
  final Function(int) onDeactivateApiKey;

  const DesktopLayout({
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'API Usage',
                style: context.t.displayMedium,
              ),
              const SizedBox(height: 24),
              OverviewSection(apiUsage: apiUsage),
              const SizedBox(height: 32),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  final AccountApiUsage apiUsage;

  const OverviewTab({required this.apiUsage});

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
          OverviewSection(apiUsage: apiUsage),
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

class OverviewSection extends StatelessWidget {
  final AccountApiUsage apiUsage;

  const OverviewSection({required this.apiUsage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreditsOverviewCard(
          subscriptionCredits: apiUsage.subscriptionCredits,
          purchasedCredits: apiUsage.purchasedCredits,
          accountId: apiUsage.nanoId,
        ),
      ],
    );
  }
}

class ApiKeysSection extends StatelessWidget {
  final List<AccountApiKey> apiKeys;
  final Map<int, int> apiKeyUsageStats;
  final VoidCallback onShowCreateApiKeyDialog;
  final Function(int) onDeactivateApiKey;

  const ApiKeysSection({
    required this.apiKeys,
    required this.apiKeyUsageStats,
    required this.onShowCreateApiKeyDialog,
    required this.onDeactivateApiKey,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'API Keys',
                style: context.t.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: onShowCreateApiKeyDialog,
                icon: const Icon(Icons.add),
                label: const Text('Create Key'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (apiKeys.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.key_off,
                      size: 48,
                      color: context.c.onSurface.withAlpha(100),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No API keys yet',
                      style: context.t.bodyLarge?.copyWith(
                        color: context.c.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: apiKeys.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final apiKey = apiKeys[index];
                final usageCount = apiKeyUsageStats[apiKey.id] ?? 0;

                return ApiKeyCard(
                  apiKey: apiKey,
                  usageCount: usageCount,
                  canDelete: apiKeys.length > 1,
                  onDelete: () => onDeactivateApiKey(apiKey.id!),
                );
              },
            ),
        ],
      ),
    );
  }
}

class HistorySection extends StatelessWidget {
  final List<CreditHistoryItem> creditHistory;
  final bool isLoadingMoreHistory;
  final VoidCallback onLoadMoreHistory;

  const HistorySection({
    required this.creditHistory,
    required this.isLoadingMoreHistory,
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
          CreditHistoryList(
            creditHistory: creditHistory,
            isLoadingMore: isLoadingMoreHistory,
            onLoadMore: onLoadMoreHistory,
          ),
        ],
      ),
    );
  }
}
