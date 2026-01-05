import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
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
    final horizontalPadding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 20.0,
    );
    final verticalSpacing = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );
    final borderRadius = context.responsiveValue(
      compact: 12.0,
      medium: 16.0,
      expanded: 16.0,
    );
    final emptyStatePadding = context.responsiveValue(
      compact: 24.0,
      medium: 32.0,
      expanded: 32.0,
    );

    final headerRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            AppLocalizations.of(context)!.api_usage_api_keys,
            style: context.t.titleLarge,
          ),
        ),
        SizedBox(width: 8),
        // Use icon-only button on compact screens to prevent overflow
        context.windowSizeClass == WindowSizeClass.compact
            ? IconButton.filled(
                onPressed: onShowCreateApiKeyDialog,
                icon: const Icon(Icons.add),
                tooltip: AppLocalizations.of(context)!.api_usage_create_key,
              )
            : ElevatedButton.icon(
                onPressed: onShowCreateApiKeyDialog,
                icon: const Icon(Icons.add),
                label: Text(AppLocalizations.of(context)!.api_usage_create_key),
              ),
      ],
    );

    final emptyState = Center(
      child: Padding(
        padding: EdgeInsets.all(emptyStatePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.key_off,
              size: 48,
              color: context.c.onSurface.withAlpha(100),
            ),
            SizedBox(height: verticalSpacing),
            Text(
              AppLocalizations.of(context)!.api_usage_no_api_keys,
              style: context.t.bodyLarge?.copyWith(
                color: context.c.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: context.c.outline.withAlpha(50)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isUnbounded = constraints.maxHeight == double.infinity;

          if (apiKeys.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: isUnbounded ? MainAxisSize.min : MainAxisSize.max,
              children: [
                SizedBox(height: verticalSpacing),
                headerRow,
                SizedBox(height: verticalSpacing),
                emptyState,
              ],
            );
          }

          final listView = ListView.separated(
            shrinkWrap: isUnbounded,
            physics: isUnbounded ? const NeverScrollableScrollPhysics() : null,
            padding: EdgeInsets.only(bottom: verticalSpacing),
            itemCount: apiKeys.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: verticalSpacing),
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
          );

          if (isUnbounded) {
            // In scrollable context (tablet mode) - shrink-wrap
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: verticalSpacing),
                headerRow,
                SizedBox(height: verticalSpacing),
                listView,
              ],
            );
          } else {
            // In bounded context (desktop mode) - expand to fill
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: verticalSpacing),
                headerRow,
                SizedBox(height: verticalSpacing),
                Expanded(child: listView),
              ],
            );
          }
        },
      ),
    );
  }
}
