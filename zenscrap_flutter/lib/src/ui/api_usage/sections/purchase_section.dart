import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/dialogs/upgrade_plan_dialog.dart';

class PurchaseSection extends ConsumerWidget {
  const PurchaseSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.outline.withAlpha(50)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20),
              Text(
                l10n.api_usage_purchase_credits,
                style: context.t.titleLarge,
              ),
              const Spacer(),
              Icon(
                Icons.add_card_rounded,
                color: context.c.primary,
                size: 28,
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 129,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                _CreditPackageCard(
                  package: CreditPurchaseOption.small,
                  credits: '100K',
                  price: '\$59',
                  unitPrice: '\$0.59/1K',
                  onTap: () =>
                      _handlePurchase(context, ref, CreditPurchaseOption.small),
                ),
                const SizedBox(width: 12),
                _CreditPackageCard(
                  package: CreditPurchaseOption.medium,
                  credits: '1M',
                  price: '\$199',
                  unitPrice: '\$0.20/1K',
                  badge: l10n.api_usage_best_value,
                  isHighlighted: true,
                  onTap: () => _handlePurchase(
                      context, ref, CreditPurchaseOption.medium),
                ),
                const SizedBox(width: 12),
                _CreditPackageCard(
                  package: CreditPurchaseOption.large,
                  credits: '2.5M',
                  price: '\$399',
                  unitPrice: '\$0.16/1K',
                  badge: l10n.api_usage_bulk_discount,
                  onTap: () =>
                      _handlePurchase(context, ref, CreditPurchaseOption.large),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: context.c.onSurfaceVariant.withAlpha(150),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.api_usage_credits_never_expire,
                    style: context.t.labelSmall?.copyWith(
                      color: context.c.onSurfaceVariant.withAlpha(150),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  static Future<void> _handlePurchase(
    BuildContext context,
    WidgetRef ref,
    CreditPurchaseOption package,
  ) async {
    // Show the initial dialog explaining the credit packages
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => _CreditPurchaseExplanationDialog(
        selectedPackage: package,
      ),
    );

    if (shouldProceed != true || !context.mounted) return;

    // Check if user has Ultra plan
    final accountState = ref.read(accountProvider);
    final accountInfo = accountState.mapOrNull(
      withData: (state) => state.accountInfo,
    );

    if (accountInfo == null) {
      showSnackbar(
          context, AppLocalizations.of(context)!.api_usage_unable_to_verify_account);
      return;
    }

    if (accountInfo.planTier != PlanTier.ultra) {
      // Show Ultra plan upgrade dialog
      await _showUltraRequiredDialog(context);
      return;
    }

    // User has Ultra plan, proceed with checkout
    if (context.mounted) {
      await _showCheckoutDialog(context, ref, package);
    }
  }

  static Future<void> _showUltraRequiredDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.workspace_premium_rounded,
          size: 48,
          color: context.c.primary,
        ),
        title: Text(l10n.api_usage_ultra_plan_required),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.api_usage_ultra_exclusive_benefit,
                style: context.t.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.c.primaryContainer.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.c.primary.withAlpha(77),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.all_inclusive_rounded,
                          color: context.c.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.api_usage_credits_never_expire_benefit,
                            style: context.t.bodySmall?.copyWith(
                              color: context.c.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.flash_on_rounded,
                          color: context.c.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.api_usage_perfect_for_traffic_spikes,
                            style: context.t.bodySmall?.copyWith(
                              color: context.c.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.api_usage_maybe_later),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              showUltraPlanUpgradeDialog(
                context,
                mainCTAText: l10n.api_usage_unlock_credits_message,
              );
            },
            child: Text(l10n.api_usage_upgrade_to_ultra),
          ),
        ],
      ),
    );
  }

  static Future<void> _showCheckoutDialog(
    BuildContext context,
    WidgetRef ref,
    CreditPurchaseOption package,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _CheckoutLoadingDialog(
        package: package,
        ref: ref,
      ),
    );
  }
}

class _CreditPackageCard extends StatelessWidget {
  final CreditPurchaseOption package;
  final String credits;
  final String price;
  final String unitPrice;
  final String? badge;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _CreditPackageCard({
    required this.package,
    required this.credits,
    required this.price,
    required this.unitPrice,
    this.badge,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 190,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isHighlighted
                ? context.c.primaryContainer.withAlpha(30)
                : context.c.surfaceContainerHighest.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHighlighted
                  ? context.c.primary.withAlpha(100)
                  : context.c.outline.withAlpha(30),
              width: isHighlighted ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    credits,
                    style: context.t.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isHighlighted
                          ? context.c.primary
                          : context.c.onSurface,
                    ),
                  ),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: context.c.tertiary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        badge!,
                        style: context.t.labelSmall?.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: context.c.onTertiary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: context.t.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.api_usage_unit_price(unitPrice),
                style: context.t.labelSmall?.copyWith(
                  color: context.c.onSurfaceVariant.withAlpha(150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreditPurchaseExplanationDialog extends StatelessWidget {
  final CreditPurchaseOption selectedPackage;

  const _CreditPurchaseExplanationDialog({
    required this.selectedPackage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.c.primaryContainer,
                    context.c.secondaryContainer.withAlpha(51),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.c.primary,
                      boxShadow: [
                        BoxShadow(
                          color: context.c.primary.withAlpha(102),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.generating_tokens_rounded,
                      size: 32,
                      color: context.c.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.api_usage_get_credits_title,
                    style: context.t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.c.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.api_usage_traffic_spikes_subtitle,
                    style: context.t.bodyMedium?.copyWith(
                      color: context.c.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Benefits
                  _BenefitItem(
                    icon: Icons.all_inclusive_rounded,
                    title: l10n.api_usage_credits_never_expire_title,
                    description: l10n.api_usage_credits_never_expire_description,
                  ),
                  const SizedBox(height: 12),
                  _BenefitItem(
                    icon: Icons.bolt_rounded,
                    title: l10n.api_usage_instant_activation_title,
                    description: l10n.api_usage_instant_activation_description,
                  ),
                  const SizedBox(height: 12),
                  _BenefitItem(
                    icon: Icons.trending_up_rounded,
                    title: l10n.api_usage_scale_without_limits_title,
                    description: l10n.api_usage_scale_without_limits_description,
                  ),
                  const SizedBox(height: 24),

                  // Package options
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.c.surfaceContainerHighest.withAlpha(51),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.c.outline.withAlpha(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          l10n.api_usage_choose_package,
                          style: context.t.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _PackageOption(
                          isSelected:
                              selectedPackage == CreditPurchaseOption.small,
                          credits: l10n.api_usage_100k_credits,
                          price: '\$59',
                          unitPrice: '\$0.59 per 1K',
                          description: l10n.api_usage_small_package_description,
                        ),
                        const SizedBox(height: 8),
                        _PackageOption(
                          isSelected:
                              selectedPackage == CreditPurchaseOption.medium,
                          credits: l10n.api_usage_1m_credits,
                          price: '\$199',
                          unitPrice: '\$0.20 per 1K',
                          description: l10n.api_usage_medium_package_description,
                          badge: l10n.api_usage_most_popular,
                        ),
                        const SizedBox(height: 8),
                        _PackageOption(
                          isSelected:
                              selectedPackage == CreditPurchaseOption.large,
                          credits: l10n.api_usage_2_5m_credits,
                          price: '\$399',
                          unitPrice: '\$0.16 per 1K',
                          description: l10n.api_usage_large_package_description,
                          badge: l10n.api_usage_best_deal,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Trust signals
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        size: 16,
                        color: context.c.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.api_usage_secure_payment_stripe,
                        style: context.t.labelMedium?.copyWith(
                          color: context.c.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.speed_rounded,
                        size: 16,
                        color: context.c.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.api_usage_instant_delivery,
                        style: context.t.labelMedium?.copyWith(
                          color: context.c.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: context.c.surfaceContainerHighest.withAlpha(26),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        l10n.api_usage_not_now,
                        style: context.t.bodyLarge?.copyWith(
                          color: context.c.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        backgroundColor: context.c.primary,
                      ),
                      icon: Icon(
                        Icons.shopping_cart_checkout_rounded,
                        color: context.c.onPrimary,
                      ),
                      label: Text(
                        _getButtonText(context, selectedPackage),
                        style: context.t.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.c.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText(BuildContext context, CreditPurchaseOption package) {
    final l10n = AppLocalizations.of(context)!;
    switch (package) {
      case CreditPurchaseOption.small:
        return l10n.api_usage_get_100k_credits;
      case CreditPurchaseOption.medium:
        return l10n.api_usage_get_1m_credits;
      case CreditPurchaseOption.large:
        return l10n.api_usage_get_2_5m_credits;
    }
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.c.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: context.c.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.t.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: context.t.bodySmall?.copyWith(
                  color: context.c.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PackageOption extends StatelessWidget {
  final bool isSelected;
  final String credits;
  final String price;
  final String unitPrice;
  final String description;
  final String? badge;

  const _PackageOption({
    required this.isSelected,
    required this.credits,
    required this.price,
    required this.unitPrice,
    required this.description,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? context.c.primaryContainer.withAlpha(51)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isSelected ? context.c.primary : context.c.outline.withAlpha(50),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: isSelected ? context.c.primary : context.c.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      credits,
                      style: context.t.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.c.tertiary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge!,
                          style: context.t.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: context.c.onTertiary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: context.t.bodySmall?.copyWith(
                    color: context.c.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: context.t.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? context.c.primary : context.c.onSurface,
                ),
              ),
              Text(
                unitPrice,
                style: context.t.labelSmall?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CheckoutLoadingDialog extends ConsumerStatefulWidget {
  final CreditPurchaseOption package;
  final WidgetRef ref;

  const _CheckoutLoadingDialog({
    required this.package,
    required this.ref,
  });

  @override
  ConsumerState<_CheckoutLoadingDialog> createState() =>
      _CheckoutLoadingDialogState();
}

class _CheckoutLoadingDialogState
    extends ConsumerState<_CheckoutLoadingDialog> {
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initiateCheckout();
  }

  Future<void> _initiateCheckout() async {
    try {
      final client = widget.ref.read(clientProvider);
      final language = widget.ref.read(currentLanguageProvider);
      final checkoutUrl = await client.privateApiUsage
          .createCreditPurchaseCheckout(creditPackage: widget.package, language: language);

      if (!mounted) return;

      // Open checkout URL in new tab
      final uri = Uri.parse(checkoutUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception('Could not open checkout page');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading) ...[
                const CupertinoActivityIndicator(radius: 20),
                const SizedBox(height: 24),
                Text(
                  l10n.api_usage_preparing_checkout,
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.api_usage_redirect_to_stripe,
                  style: context.t.bodyMedium?.copyWith(
                    color: context.c.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else if (_hasError) ...[
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: context.c.error,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.api_usage_checkout_failed,
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.c.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage ?? l10n.api_usage_unexpected_error,
                  style: context.t.bodyMedium?.copyWith(
                    color: context.c.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.api_usage_close),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.c.primaryContainer,
                  ),
                  child: Icon(
                    Icons.shopping_cart_checkout_rounded,
                    size: 48,
                    color: context.c.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.api_usage_complete_purchase,
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.c.primaryContainer.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.c.primary.withAlpha(77),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.open_in_new_rounded,
                        color: context.c.primary,
                        size: 32,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.api_usage_checkout_opened,
                        style: context.t.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.c.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.api_usage_complete_in_stripe,
                        style: context.t.bodySmall?.copyWith(
                          color: context.c.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 14,
                      color: context.c.onSurfaceVariant.withAlpha(150),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.api_usage_secure_payment_powered_by_stripe,
                      style: context.t.labelSmall?.copyWith(
                        color: context.c.onSurfaceVariant.withAlpha(150),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () async {
                    // Refresh account data
                    await widget.ref
                        .read(accountProvider.notifier)
                        .getAccountInfo(force: true);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      showSnackbar(context, l10n.api_usage_account_refreshed);
                    }
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.api_usage_refresh_and_close),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
