import 'dart:async';

import 'package:babel_text/babel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/core/extensions/string_extension.dart';
import 'package:zenscrap_flutter/src/core/mixins/curl_builder_mixin.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/category_badge.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/code_bloc.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/dialogs/clone_success_dialog.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/dialogs/upgrade_plan_dialog.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/api_key_selector_dialog.dart';

class ScrappableDetailsDialog extends ConsumerStatefulWidget {
  final Scrappable scrappable;
  final CurlBuilderMixin curlBuilderMixin;

  const ScrappableDetailsDialog({
    super.key,
    required this.scrappable,
    required this.curlBuilderMixin,
  });

  @override
  ConsumerState<ScrappableDetailsDialog> createState() =>
      _ScrappableDetailsDialogState();
}

class _ScrappableDetailsDialogState
    extends ConsumerState<ScrappableDetailsDialog> {
  AccountApiKey? selectedApiKey;
  String curlCommand = '';

  @override
  void initState() {
    super.initState();
    _initializeApiKey();
  }

  void _initializeApiKey() {
    final accountState = ref.read(accountProvider);
    accountState.whenOrNull(
      withData: (accountInfo) {
        final apiKeys = accountInfo.accountApiUsage?.apiKeys;
        if (apiKeys != null && apiKeys.isNotEmpty) {
          setState(() {
            selectedApiKey = apiKeys.first;
            _updateCurlCommand();
          });
        }
      },
    );
  }

  void _updateCurlCommand() {
    if (selectedApiKey == null) return;

    final client = ref.read(clientProvider);
    final baseUrl = client.host.replaceAll('localhost:8080', 'localhost:8082');

    // Parse example payload if available
    Map<String, dynamic>? examplePayload;
    if (widget.scrappable.referenceTestData != null) {
      examplePayload = tryDecode(
          widget.scrappable.referenceTestData!.referenceQueryParametersJson);
    }

    setState(() {
      curlCommand = widget.curlBuilderMixin.buildSimpleCurl(
        baseUrl: baseUrl,
        scrappableId: widget.scrappable.id,
        apiKey: selectedApiKey!.apiKey,
        examplePayload: examplePayload,
      );
    });
  }

  void _selectApiKey() async {
    final accountState = ref.read(accountProvider);
    accountState.whenOrNull(
      withData: (accountInfo) async {
        final apiKeys = accountInfo.accountApiUsage?.apiKeys;
        if (apiKeys == null || apiKeys.length <= 1) return;

        final selected = await showDialog<AccountApiKey>(
          context: context,
          builder: (context) => ApiKeySelectorDialog(
            apiKeys: apiKeys,
            selectedKey: selectedApiKey!,
          ),
        );

        if (selected != null) {
          setState(() {
            selectedApiKey = selected;
            _updateCurlCommand();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountProvider);
    final apiKeys = accountState.maybeWhen(
      withData: (accountInfo) => accountInfo.accountApiUsage?.apiKeys ?? [],
      orElse: () => <AccountApiKey>[],
    );

    return Row(
      children: [
        AlertDialog(
          title: Row(
            children: [
              Text(widget.scrappable.name),
              SizedBox(width: 16),
              CategoryBadge(
                scrappable: widget.scrappable,
              ),
              Spacer(),
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.close,
                  color: context.c.onSurfaceVariant,
                ),
              )
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.scrappable.description,
                    style: context.t.bodyMedium,
                  ),
                  if (widget.scrappable.targetRequest?.url != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Target URL:',
                      style: context.t.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    BabelText(
                      '<onTap><u><pC>${widget.scrappable.targetRequest!.url.shortUrl}<pC><u><onTap>',
                      style: context.t.bodyLarge?.copyWith(),
                      onTapMapping: {
                        '<onTap>': (context) {
                          launchUrlString(
                              widget.scrappable.targetRequest!.url.shortUrl);
                        }
                      },
                    ),
                  ],
                  if (selectedApiKey != null) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: context.c.surfaceContainerHighest.withAlpha(77),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: context.c.outline.withAlpha(51),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.vpn_key,
                            size: 16,
                            color: context.c.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            selectedApiKey!.name,
                            style: context.t.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${selectedApiKey!.apiKey.substring(0, 8)}...)',
                            style: context.t.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              color: context.c.onSurfaceVariant,
                            ),
                          ),
                          if (apiKeys.length > 1) ...[
                            Spacer(),
                            TextButton.icon(
                              onPressed: _selectApiKey,
                              icon: const Icon(Icons.swap_horiz, size: 18),
                              label: const Text('Change'),
                            ),
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Curl Command',
                      style: context.t.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: CodeBlock(
                        code: curlCommand,
                        fontSize: 12,
                      ),
                    ),
                  ] else if (apiKeys.isEmpty) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.c.errorContainer.withAlpha(26),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: context.c.error.withAlpha(51),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: context.c.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'No API keys found. Please create an API key first to use this scrappable.',
                              style: context.t.bodyMedium?.copyWith(
                                color: context.c.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            Text(
              'Created: ${_formatFullDate(widget.scrappable.createdAt)}',
              style: context.t.bodySmall?.copyWith(
                color: context.c.onSurfaceVariant,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // TextButton(
                //   onPressed: () => Navigator.of(context).pop(),
                //   child: const Text('Close'),
                // ),
                SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _handleClone(context),
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Clone to My Endpoints'),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _handleClone(BuildContext context) async {
    // Check if user has unlimited plan
    final accountState = ref.read(accountProvider);
    final hasUnlimitedPlan = accountState.maybeWhen(
      withData: (accountInfo) => accountInfo.planTier == PlanTier.ultra,
      orElse: () => false,
    );

    if (!hasUnlimitedPlan) {
      // Close current dialog and show upgrade dialog
      await showCloneUpgradeDialog(context);
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    try {
      final client = ref.read(clientProvider);
      final clonedScrappable =
          await client.privateCloneScrappable.cloneFromMarketplace(
        scrappableId: widget.scrappable.id,
      );

      if (context.mounted) {
        // Close loading dialog
        Navigator.of(context).pop();
        // Close details dialog
        Navigator.of(context).pop();

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => CloneSuccessDialog(
            clonedScrappable: clonedScrappable,
          ),
        );
      }
    } on ZenScrapException catch (e) {
      if (context.mounted) {
        // Close loading dialog
        Navigator.of(context).pop();

        if (e.title.contains('Upgrade Required')) {
          // Close details dialog and show upgrade dialog
          await showCloneUpgradeDialog(context);
        } else {
          showSnackbar(context, 'Failed to clone: ${e.description}');
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Close loading dialog
        Navigator.of(context).pop();
        showSnackbar(context, 'Failed to clone scrappable: $e');
      }
    }
  }
}
