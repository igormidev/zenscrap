import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/core/extensions/string_extension.dart';
import 'package:zenscrap_flutter/src/core/mixins/curl_builder_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';

class MarketplaceScrappableCard extends ConsumerWidget with CurlBuilderMixin {
  final Scrappable scrappable;
  final int usedCount;
  final VoidCallback? onTap;

  const MarketplaceScrappableCard({
    super.key,
    required this.scrappable,
    required this.usedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUrl = scrappable.targetRequest?.url != null;
    final url = scrappable.targetRequest?.url ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
            .copyWith(bottom: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.c.outline.withAlpha(51),
            width: 1,
          ),
          color: context.c.surfaceContainerLowest.withAlpha(100),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scrappable.name,
                  style: context.t.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.c.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  scrappable.description,
                  style: context.t.bodyMedium?.copyWith(
                    color: context.c.onSurfaceVariant,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (hasUrl) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: context.c.surfaceContainerHighest.withAlpha(128),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.c.outline.withAlpha(51),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.link_rounded,
                      size: 16,
                      color: context.c.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        url.shortUrl,
                        style: context.t.bodySmall?.copyWith(
                          color: context.c.primary,
                          fontFamily: 'monospace',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                InkWell(
                  onTap: () => _copyCurl(context, ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: context.c.primaryContainer.withAlpha(156),
                      // color: context.c.tertiary.withAlpha(26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.copy,
                          size: 12,
                          color: context.c.tertiary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Copy curl request',
                          style: context.t.labelSmall?.copyWith(
                            color: context.c.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (scrappable.scrappingRules != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.c.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 12,
                          color: context.c.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'AI Powered',
                          style: context.t.labelSmall?.copyWith(
                            color: context.c.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  'Created ${_formatDate(scrappable.createdAt)}',
                  style: context.t.labelMedium?.copyWith(
                    color: context.c.onSurfaceVariant.withAlpha(179),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyCurl(BuildContext context, WidgetRef ref) async {
    // Get the first API key from the account state
    final accountState = ref.read(accountProvider);

    accountState.whenOrNull(
      withData: (accountInfo) async {
        final apiKeys = accountInfo.accountApiUsage?.apiKeys;

        if (apiKeys == null || apiKeys.isEmpty) {
          showSnackbar(context, 'No API keys found. Please create one first.');
          return;
        }

        // Use the first API key
        final firstApiKey = apiKeys.first;
        final client = ref.read(clientProvider);
        final baseUrl =
            client.host.replaceAll('localhost:8080', 'localhost:8082');

        // Parse example payload if available
        Map<String, dynamic>? examplePayload;
        if (scrappable.referenceTestData != null) {
          examplePayload = tryDecode(
              scrappable.referenceTestData!.referenceQueryParametersJson);
        }

        final curlCommand = buildSimpleCurl(
          baseUrl: baseUrl,
          scrappableId: scrappable.id,
          apiKey: firstApiKey.apiKey,
          examplePayload: examplePayload,
        );

        await Clipboard.setData(ClipboardData(text: curlCommand));

        if (context.mounted) {
          showSnackbar(context, 'Curl command copied to clipboard');
        }
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }
}
