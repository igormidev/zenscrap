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
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/category_badge.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/code_bloc.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/translatable_text.dart';
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

  const ScrappableInfoDialog({super.key, required this.scrappable});

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
    // Pass the raw client.host - the mixin handles localhost/production domain conversion
    final baseUrl = client.host;

    // Parse example payload if available
    Map<String, dynamic>? examplePayload;
    if (widget.scrappable.referenceTestData != null) {
      examplePayload = tryDecode(
        widget.scrappable.referenceTestData!.referenceQueryParametersJson,
      );
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

    final accountId = ref
        .watch(accountProvider)
        .mapOrNull(withData: (value) => value.accountInfo.id);
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
      insetPadding: EdgeInsets.symmetric(
        vertical: context.responsiveValue(
          compact: 16.0,
          medium: 20.0,
          expanded: 20.0,
        ),
        horizontal: context.responsiveValue(
          compact: 16.0,
          medium: 40.0,
          expanded: 40.0,
        ),
      ),
      titlePadding: EdgeInsets.only(
        left: context.responsiveValue(
          compact: 16.0,
          medium: 24.0,
          expanded: 24.0,
        ),
        right: context.responsiveValue(
          compact: 16.0,
          medium: 24.0,
          expanded: 24.0,
        ),
        top: context.responsiveValue(
          compact: 20.0,
          medium: 24.0,
          expanded: 24.0,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      title: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: context.responsiveValue(
            compact: double.infinity,
            medium: 500.0,
            expanded: 600.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TranslatableTitle(
                text: widget.scrappable.name,
                sourceLanguage: widget.scrappable.nameLanguage,
                style: context.t.titleLarge,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: context.pop,
              child: Icon(Icons.close, color: context.c.onSurfaceVariant),
            ),
          ],
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * context.responsiveValue(
            compact: 0.8,
            medium: 0.75,
            expanded: 0.7,
          ),
          maxWidth: context.responsiveValue(
            compact: double.infinity,
            medium: 500.0,
            expanded: 600.0,
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 20, top: 6),
            children: [
              Padding(
                padding: horizontalPadding,
                child: TranslatableDescription(
                  text: widget.scrappable.description,
                  sourceLanguage: widget.scrappable.descriptionLanguage,
                  style: context.t.bodyMedium,
                  maxLines: 10,
                ),
              ),
              const SizedBox(height: 8),
            Padding(
              padding: horizontalPadding,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CategoryBadge(scrappable: widget.scrappable),
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
                .replaceAllMapped(
                  RegExp(r'\{[^}]+\}'),
                  (match) => '<code>${match[0]}<code>',
                ),
                style: context.t.bodyMedium?.copyWith(),
                padding: horizontalPadding,
                styleMapping: {
                  '<code>': (_, style) => style.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                    backgroundColor: context.c.surfaceContainerHighest
                        .withAlpha(26),
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
                  border: Border.all(color: context.c.outline.withAlpha(51)),
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
                        label: Text(
                          AppLocalizations.of(context)!.marketplace_change,
                        ),
                      ),
                    ],
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
                              AppLocalizations.of(
                                context,
                              )!.marketplace_test_endpoint,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
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
                  copyTooltipMessage: AppLocalizations.of(
                    context,
                  )!.marketplace_copy_curl_command,
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
              // Auto-Fix Configuration Section
              if (widget.scrappable.autoFixConfig != null) ...[
                const SizedBox(height: 24),
                Padding(
                  padding: horizontalPadding,
                  child: _AutoFixInfoSection(
                    autoFixConfig: widget.scrappable.autoFixConfig!,
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
                  border: Border.all(color: context.c.primary.withAlpha(77)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: context.c.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.marketplace_login_required,
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
                  border: Border.all(color: context.c.error.withAlpha(51)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: context.c.error),
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
                AppLocalizations.of(context)!.marketplace_created_date(
                  _formatFullDate(widget.scrappable.createdAt),
                ),
                style: context.t.bodySmall?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: horizontalPadding,
              child: Text(
                AppLocalizations.of(
                  context,
                )!.marketplace_last_logic_modification(
                  widget.scrappable.extractRulesUpdatedAt.formatToDisplay,
                ),
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
                  label: Text(
                    AppLocalizations.of(
                      context,
                    )!.marketplace_clone_to_my_endpoints,
                  ),
                ),
              ),
              if (isMyScrappable != false) const SizedBox(height: 42),
            ],
          ),
        ),
      ),
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
      final language = ref.read(currentLanguageProvider);
      final clonedScrappable = await client.privateCloneScrappable
          .cloneFromMarketplace(
            scrappableId: widget.scrappable.id!,
            language: language,
          );

      if (context.mounted) {
        // Close loading dialog
        Navigator.of(context).pop();
        // Close details dialog
        Navigator.of(context).pop();

        // Show success dialog
        showDialog(
          context: context,
          builder: (context) =>
              CloneSuccessDialog(clonedScrappable: clonedScrappable),
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

/// Displays auto-fix configuration information for marketplace users.
/// Helps users understand how the scrappable handles errors and self-repairs.
class _AutoFixInfoSection extends StatelessWidget {
  final AutoFixConfig autoFixConfig;

  const _AutoFixInfoSection({required this.autoFixConfig});

  String _getAiModelLabel(AiModel? model) {
    if (model == null) return 'Auto';
    return switch (model) {
      AiModel.normal => 'Fast',
      AiModel.powerful => 'Powerful',
    };
  }

  String _getAiModelDescription(AiModel? model) {
    if (model == null) {
      return 'Automatically selects the best model based on context';
    }
    return switch (model) {
      AiModel.normal => 'Quick repairs with efficient processing',
      AiModel.powerful => 'Advanced AI for complex repair scenarios',
    };
  }

  IconData _getAiModelIcon(AiModel? model) {
    if (model == null) return Icons.auto_awesome;
    return switch (model) {
      AiModel.normal => Icons.speed,
      AiModel.powerful => Icons.rocket_launch,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = autoFixConfig.enabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Auto-Fix Configuration',
          style: context.t.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isEnabled
                ? context.c.surfaceContainerHighest.withAlpha(51)
                : context.c.errorContainer.withAlpha(40),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEnabled
                  ? context.c.outline.withAlpha(50)
                  : context.c.error.withAlpha(60),
            ),
          ),
          child: Column(
            children: [
              // Status row
              _InfoRow(
                icon: isEnabled
                    ? Icons.auto_fix_high_rounded
                    : Icons.auto_fix_off_rounded,
                iconColor: isEnabled ? context.c.primary : context.c.error,
                title: 'Auto-Fix',
                value: isEnabled ? 'Enabled' : 'Disabled',
                valueColor: isEnabled ? context.c.primary : context.c.error,
                subtitle: isEnabled
                    ? 'AI will automatically repair broken extraction rules'
                    : 'Manual intervention required when scrappable breaks',
              ),
              if (isEnabled) ...[
                Divider(height: 1, color: context.c.outline.withAlpha(30)),
                // Error threshold row
                _InfoRow(
                  icon: Icons.error_outline_rounded,
                  iconColor: context.c.onSurfaceVariant,
                  title: 'Error Threshold',
                  value: '${autoFixConfig.consecutiveErrorThreshold} errors',
                  subtitle:
                      'Auto-fix triggers after ${autoFixConfig.consecutiveErrorThreshold} consecutive failures',
                ),
                Divider(height: 1, color: context.c.outline.withAlpha(30)),
                // AI Model row
                _InfoRow(
                  icon: _getAiModelIcon(autoFixConfig.preferredAiModel),
                  iconColor: context.c.onSurfaceVariant,
                  title: 'AI Model',
                  value: _getAiModelLabel(autoFixConfig.preferredAiModel),
                  subtitle: _getAiModelDescription(
                    autoFixConfig.preferredAiModel,
                  ),
                ),
              ],
            ],
          ),
        ),
        // Info message about what auto-fix means for the user
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isEnabled
                ? context.c.primaryContainer.withAlpha(40)
                : context.c.errorContainer.withAlpha(50),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isEnabled ? Icons.info_outline : Icons.warning_amber_rounded,
                color: isEnabled
                    ? context.c.onPrimaryContainer
                    : context.c.error,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isEnabled
                      ? 'This scrappable will automatically attempt to repair itself when websites change their structure.'
                      : 'This scrappable requires manual intervention if websites change their structure.',
                  style: context.t.bodySmall?.copyWith(
                    color: isEnabled
                        ? context.c.onPrimaryContainer
                        : context.c.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final Color? valueColor;
  final String? subtitle;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.valueColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: context.t.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      value,
                      style: context.t.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: valueColor ?? context.c.onSurface,
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: context.t.bodySmall?.copyWith(
                      color: context.c.onSurfaceVariant.withAlpha(180),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
