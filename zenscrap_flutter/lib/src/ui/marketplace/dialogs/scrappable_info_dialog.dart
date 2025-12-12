import 'dart:async';

import 'package:babel_text/babel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/convert_extensions.dart';
import 'package:zenscrap_flutter/src/core/extensions/date_time_extension.dart';
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
import 'package:zenscrap_flutter/src/ui/marketplace/widgets/scrappable_usage_metrics_widget.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/scrapping_bee_cost_table.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/dialogs/test_endpoint_dialog.dart';

class ScrappableInfoDialog extends ConsumerStatefulWidget {
  final Scrappable scrappable;

  const ScrappableInfoDialog({
    super.key,
    required this.scrappable,
  });

  @override
  ConsumerState<ScrappableInfoDialog> createState() =>
      _ScrappableInfoDialogState();
}

class _ScrappableInfoDialogState extends ConsumerState<ScrappableInfoDialog>
    with CurlBuilderMixin {
  AccountApiKey? selectedApiKey;
  String displayCurlCommand = '';
  String copiableCurlCommand = '';

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
    final baseUrl =
        client.host.replaceAll('localhost:8080/', 'localhost:8082/');

    // Parse example payload if available
    Map<String, dynamic>? examplePayload;
    if (widget.scrappable.referenceTestData != null) {
      examplePayload = tryDecode(
          widget.scrappable.referenceTestData!.referenceQueryParametersJson);
    }

    setState(() {
      displayCurlCommand = buildSimpleCurl(
        isDisplayCurl: true,
        baseUrl: baseUrl,
        scrappableId: widget.scrappable.id!,
        isProd: true, // Marketplace always uses prod endpoint
        apiKey: selectedApiKey!.apiKey,
        examplePayload: examplePayload,
      );
      copiableCurlCommand = buildSimpleCurl(
        isDisplayCurl: false,
        baseUrl: baseUrl,
        scrappableId: widget.scrappable.id!,
        isProd: true, // Marketplace always uses prod endpoint
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

    final accountId = ref.watch(accountProvider).mapOrNull(
          withData: (value) => value.accountInfo.id,
        );
    final isMyScrappable = accountId == widget.scrappable.accountId;
    final apiKeys = accountState.maybeWhen(
      withData: (accountInfo) => accountInfo.accountApiUsage?.apiKeys ?? [],
      orElse: () => <AccountApiKey>[],
    );

    // Check if user is logged in
    final isLoggedIn = accountState.maybeWhen(
      withData: (_) => true,
      orElse: () => false,
    );
    final isNewScrappable = widget.scrappable.accountId == null;
    final horizontalPadding = const EdgeInsets.only(left: 24, right: 24);

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 20),
      titlePadding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      // contentPadding: const EdgeInsets.only(left: 24, right: 24),
      contentPadding: EdgeInsets.zero,
      title: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.3,
        child: Row(
          children: [
            Expanded(child: BabelSelectableText(widget.scrappable.name)),
            const SizedBox(width: 8),
            InkWell(
              onTap: context.pop,
              child: Icon(
                Icons.close,
                color: context.c.onSurfaceVariant,
              ),
            )
          ],
        ),
      ),
      content: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        width: MediaQuery.sizeOf(context).width * 0.3,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20, top: 6),
          children: [
            Padding(
              padding: horizontalPadding,
              child: BabelSelectableText(
                widget.scrappable.description,
                style: context.t.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: horizontalPadding,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CategoryBadge(
                  scrappable: widget.scrappable,
                ),
              ),
            ),
            if (widget.scrappable.targetRequest?.url != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: horizontalPadding,
                child: Text(
                  AppLocalizations.of(context)!.marketplace_target_url,
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BabelSelectableText(
                '<pC>${widget.scrappable.targetRequest!.url.shortUrl}<pC>'
                    // There are a lot of {var}
                    .replaceAllMapped(RegExp(r'\{[^}]+\}'),
                        (match) => '<code>${match[0]}<code>'),
                style: context.t.bodyMedium?.copyWith(),
                padding: horizontalPadding,
                styleMapping: {
                  '<code>': (_, style) => style.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                        backgroundColor:
                            context.c.surfaceContainerHighest.withAlpha(26),
                      ),
                },
              ),
            ],
            if (selectedApiKey != null) ...[
              const SizedBox(height: 8),
              Container(
                margin: horizontalPadding,
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
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _selectApiKey,
                        icon: const Icon(Icons.swap_horiz, size: 18),
                        label: Text(AppLocalizations.of(context)!.marketplace_change),
                      ),
                    ]
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: horizontalPadding,
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.marketplace_curl_command,
                      style: context.t.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    if (widget.scrappable.targetRequest != null)
                      SizedBox(
                        height: 28,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            iconAlignment: IconAlignment.end,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                          ),
                          onPressed: () => _openTestDialog(context),
                          icon: const Icon(Icons.science, size: 15),
                          label: Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              AppLocalizations.of(context)!.marketplace_test_endpoint,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: horizontalPadding,
                child: CodeBlock(
                  copyTooltipMessage: AppLocalizations.of(context)!.marketplace_copy_curl_command,
                  code: displayCurlCommand,
                  copyCode: copiableCurlCommand,
                  fontSize: 12,
                ),
              ),
              if (widget.scrappable.scrappingBeeExtractRules != null) ...[
                const SizedBox(height: 24),
                Padding(
                  padding: horizontalPadding,
                  child: Text(
                    AppLocalizations.of(context)!.marketplace_api_configuration,
                    style: context.t.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: horizontalPadding,
                  child: ScrappingBeeCostTable(
                    extractLogic: widget.scrappable.scrappingBeeExtractRules!,
                  ),
                ),
              ],
              if (isNewScrappable == false) ...[
                const SizedBox(height: 24),
                Padding(
                  padding: horizontalPadding,
                  child: ScrappableUsageMetricsWidget(
                    scrappableId: widget.scrappable.id!,
                  ),
                ),
              ],
            ] else if (!isLoggedIn) ...[
              const SizedBox(height: 24),
              Container(
                margin: horizontalPadding,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.c.primaryContainer.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.c.primary.withAlpha(77),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: context.c.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.marketplace_login_required,
                        style: context.t.bodyMedium?.copyWith(
                          color: context.c.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (apiKeys.isEmpty) ...[
              const SizedBox(height: 24),
              Container(
                margin: horizontalPadding,
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
                        AppLocalizations.of(context)!.marketplace_no_api_keys,
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
            Padding(
              padding: horizontalPadding,
              child: Text(
                AppLocalizations.of(context)!.marketplace_created_date(_formatFullDate(widget.scrappable.createdAt)),
                style: context.t.bodySmall?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: horizontalPadding,
              child: Text(
                AppLocalizations.of(context)!.marketplace_last_logic_modification(widget.scrappable.extractRulesUpdatedAt.formatToDisplay),
                style: context.t.bodySmall?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isMyScrappable == false)
              Padding(
                padding: horizontalPadding,
                child: FilledButton.icon(
                  onPressed: () => _handleClone(context),
                  icon: const Icon(Icons.copy_rounded),
                  label: Text(AppLocalizations.of(context)!.marketplace_clone_to_my_endpoints),
                ),
              ),
            if (isMyScrappable != false) const SizedBox(height: 42)
          ],
        ),
      ),
      // actions: [
      // ],
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _openTestDialog(BuildContext context) {
    if (selectedApiKey == null || widget.scrappable.targetRequest == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => TestEndpointDialog(
        scrappableId: widget.scrappable.id!,
        scrappableRequest: widget.scrappable.targetRequest!,
        testData: widget.scrappable.referenceTestData,
        isTestMode: false,
        apiKey: selectedApiKey!.apiKey,
      ),
    );
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
        scrappableId: widget.scrappable.id!,
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
