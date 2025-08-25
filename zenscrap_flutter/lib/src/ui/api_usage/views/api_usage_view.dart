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
        client.privateApiUsage.getCreditHistory(offset: 0, limit: _historyLimit),
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
        content: Text('Are you sure you want to deactivate this API key? This action cannot be undone.'),
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
          return _buildMobileLayout();
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    final tabs = [
      _buildOverviewTab(),
      _buildApiKeysTab(),
      _buildHistoryTab(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedTabIndex,
        children: tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTabIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedTabIndex = index);
        },
        destinations: [
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

  Widget _buildDesktopLayout() {
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
              
              // Overview section
              _buildOverviewSection(),
              
              const SizedBox(height: 32),
              
              // Two column layout for API Keys and History
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // API Keys section
                  Expanded(
                    flex: 5,
                    child: _buildApiKeysSection(),
                  ),
                  const SizedBox(width: 24),
                  // History section
                  Expanded(
                    flex: 4,
                    child: _buildHistorySection(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
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
          _buildOverviewSection(),
        ],
      ),
    );
  }

  Widget _buildApiKeysTab() {
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
          _buildApiKeysSection(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
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
          _buildHistorySection(),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreditsOverviewCard(
          subscriptionCredits: _apiUsage!.subscriptionCredits,
          purchasedCredits: _apiUsage!.purchasedCredits,
          accountId: _apiUsage!.nanoId,
        ),
      ],
    );
  }

  Widget _buildApiKeysSection() {
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
                onPressed: _showCreateApiKeyDialog,
                icon: Icon(Icons.add),
                label: Text('Create Key'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_apiKeys.isEmpty)
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
              physics: NeverScrollableScrollPhysics(),
              itemCount: _apiKeys.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final apiKey = _apiKeys[index];
                final usageCount = _apiKeyUsageStats[apiKey.id] ?? 0;
                
                return ApiKeyCard(
                  apiKey: apiKey,
                  usageCount: usageCount,
                  canDelete: _apiKeys.length > 1,
                  onDelete: () => _deactivateApiKey(apiKey.id!),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
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
            creditHistory: _creditHistory,
            isLoadingMore: _isLoadingMoreHistory,
            onLoadMore: _loadMoreHistory,
          ),
        ],
      ),
    );
  }
}