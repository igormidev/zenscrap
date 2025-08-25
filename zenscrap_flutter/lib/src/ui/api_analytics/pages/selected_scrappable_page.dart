import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_analytics_provider.dart';
import 'package:zenscrap_flutter/src/states/analytics/selected_scrappable_analytics_state.dart';
import 'package:zenscrap_flutter/src/ui/api_analytics/pages/no_selected_scrappable_indicator_page.dart';
import 'package:intl/intl.dart';

class SelectedScrappablePage extends ConsumerStatefulWidget {
  const SelectedScrappablePage({super.key});

  @override
  ConsumerState<SelectedScrappablePage> createState() =>
      _SelectedScrappablePageState();
}

class _SelectedScrappablePageState
    extends ConsumerState<SelectedScrappablePage> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      // User is near the bottom, we could trigger load more
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(selectedScrappableAnalyticsProvider);
    
    return state.when(
      none: () => const NoSelectedScrappableIndicatorPage(),
      loading: () => const Center(child: CircularProgressIndicator()),
      loadingMore: (currentData) => _buildAnalyticsList(context, currentData, isLoadingMore: true),
      withData: (data) => _buildAnalyticsList(context, data),
      withError: (error) => _buildErrorState(context, error),
    );
  }
  
  Widget _buildAnalyticsList(
    BuildContext context,
    PaginatedScrappableAnalytics data, {
    bool isLoadingMore = false,
  }) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm:ss');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, data.scrappable),
        _buildStatsSummary(context, data),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: data.items.length + 1,
            itemBuilder: (context, index) {
              if (index == data.items.length) {
                return _buildLoadMoreSection(context, data, isLoadingMore);
              }
              
              final analytics = data.items[index];
              return _buildAnalyticsCard(context, analytics, dateFormat);
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildHeader(BuildContext context, Scrappable scrappable) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface,
        border: Border(
          bottom: BorderSide(
            color: context.c.outline.withAlpha(50),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: context.c.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scrappable.name,
                      style: context.t.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (scrappable.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        scrappable.description,
                        style: context.t.bodySmall?.copyWith(
                          color: context.c.onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatsSummary(BuildContext context, PaginatedScrappableAnalytics data) {
    // Calculate totals from all loaded items
    int totalSuccess = 0;
    int totalClientError = 0;
    int totalServerError = 0;
    int totalInsufficientCredits = 0;
    int totalMaxConcurrency = 0;
    
    for (final item in data.items) {
      switch (item.requestStatus) {
        case RequestStatus.success:
          totalSuccess++;
          break;
        case RequestStatus.clientError:
          totalClientError++;
          break;
        case RequestStatus.serverError:
          totalServerError++;
          break;
        case RequestStatus.insufficientCredits:
          totalInsufficientCredits++;
          break;
        case RequestStatus.maxConcurrencyExceeded:
          totalMaxConcurrency++;
          break;
      }
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surfaceContainerHighest.withAlpha(50),
      ),
      child: Row(
        children: [
          _buildStatCard(context, 'Success', totalSuccess, Colors.green),
          const SizedBox(width: 16),
          _buildStatCard(context, '4xx', totalClientError, Colors.orange),
          const SizedBox(width: 16),
          _buildStatCard(context, '5xx', totalServerError, Colors.red),
          const SizedBox(width: 16),
          _buildStatCard(context, 'No Credits', totalInsufficientCredits, Colors.purple),
          const SizedBox(width: 16),
          _buildStatCard(context, 'Max Concurrency', totalMaxConcurrency, Colors.cyan),
          const Spacer(),
          Text(
            'Showing ${data.items.length} of ${data.totalCount}',
            style: context.t.bodySmall?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(BuildContext context, String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withAlpha(100),
        ),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: context.t.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: context.t.bodySmall?.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalyticsCard(
    BuildContext context,
    ScrappableAnalytics analytics,
    DateFormat dateFormat,
  ) {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (analytics.requestStatus) {
      case RequestStatus.success:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Success';
        break;
      case RequestStatus.clientError:
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        statusText = 'Client Error';
        break;
      case RequestStatus.serverError:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = 'Server Error';
        break;
      case RequestStatus.insufficientCredits:
        statusColor = Colors.purple;
        statusIcon = Icons.credit_card_off;
        statusText = 'Insufficient Credits';
        break;
      case RequestStatus.maxConcurrencyExceeded:
        statusColor = Colors.cyan;
        statusIcon = Icons.traffic;
        statusText = 'Max Concurrency';
        break;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          statusIcon,
          color: statusColor,
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                statusText,
                style: context.t.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              dateFormat.format(analytics.requestedAt),
              style: context.t.bodyMedium,
            ),
          ],
        ),
        subtitle: null,
        trailing: Text(
          analytics.attachedApiKey,
          style: context.t.bodySmall?.copyWith(
            color: context.c.onSurface.withAlpha(150),
          ),
        ),
      ),
    );
  }
  
  Widget _buildLoadMoreSection(
    BuildContext context,
    PaginatedScrappableAnalytics data,
    bool isLoadingMore,
  ) {
    if (!data.hasNextPage) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'No more analytics to load',
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
          ),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: isLoadingMore
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: () {
                  ref.read(selectedScrappableAnalyticsProvider.notifier)
                      .loadMoreAnalytics();
                },
                icon: const Icon(Icons.add),
                label: const Text('Load More'),
              ),
      ),
    );
  }
  
  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
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
            'Error Loading Analytics',
            style: context.t.headlineSmall?.copyWith(
              color: context.c.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurface.withAlpha(150),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(selectedScrappableAnalyticsProvider.notifier)
                  .resetState();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}