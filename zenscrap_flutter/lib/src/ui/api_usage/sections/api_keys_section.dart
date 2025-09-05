import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/api_usage/widgets/api_key_card.dart';

class ApiKeysSection extends StatelessWidget {
  final List<AccountApiKey> apiKeys;
  final Map<int, int> apiKeyUsageStats;
  final VoidCallback onShowCreateApiKeyDialog;
  final Function(int) onDeactivateApiKey;

  const ApiKeysSection({
    super.key,
    required this.apiKeys,
    required this.apiKeyUsageStats,
    required this.onShowCreateApiKeyDialog,
    required this.onDeactivateApiKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.outline.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: apiKeys.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
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
            ),
        ],
      ),
    );
  }
}
