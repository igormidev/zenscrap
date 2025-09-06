import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
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
                'Purchase API Credits',
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
                  badge: 'BEST VALUE',
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
                  badge: 'BULK DISCOUNT',
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
                    'Credits never expire • Instant activation',
                    // 'Ultra plan exclusive • Credits never expire • Instant activation',
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
          context, 'Unable to verify account status. Please try again.');
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
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.workspace_premium_rounded,
          size: 48,
          color: context.c.primary,
        ),
        title: const Text('Ultra Plan Required'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Credit packages are an exclusive benefit for Ultra plan subscribers.',
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
                            'Credits that never expire',
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
                            'Perfect for traffic spikes',
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
            child: const Text('Maybe Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              showUltraPlanUpgradeDialog(
                context,
                mainCTAText:
                    'Unlock the ability to purchase additional credits that never expire. Perfect for handling traffic spikes and seasonal demands.',
              );
            },
            child: const Text('Upgrade to Ultra'),
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
                'Unit price: $unitPrice',
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
                    'Get Credits That Never Expire',
                    style: context.t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.c.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Perfect for traffic spikes & long-term planning',
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
                    title: 'Credits Never Expire',
                    description:
                        'Unlike subscription credits that reset monthly, purchased credits stay in your account forever while your Ultra plan is active.',
                  ),
                  const SizedBox(height: 12),
                  _BenefitItem(
                    icon: Icons.bolt_rounded,
                    title: 'Instant Activation',
                    description:
                        'Credits are added to your account immediately after payment - no waiting, no delays.',
                  ),
                  const SizedBox(height: 12),
                  _BenefitItem(
                    icon: Icons.trending_up_rounded,
                    title: 'Scale Without Limits',
                    description:
                        'Handle traffic spikes, seasonal demands, or special projects without upgrading your monthly plan.',
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
                          'Choose Your Package',
                          style: context.t.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _PackageOption(
                          isSelected:
                              selectedPackage == CreditPurchaseOption.small,
                          credits: '100,000 credits',
                          price: '\$59',
                          unitPrice: '\$0.59 per 1K',
                          description: 'Great for testing and small projects',
                        ),
                        const SizedBox(height: 8),
                        _PackageOption(
                          isSelected:
                              selectedPackage == CreditPurchaseOption.medium,
                          credits: '1,000,000 credits',
                          price: '\$199',
                          unitPrice: '\$0.20 per 1K',
                          description: 'Best value for growing applications',
                          badge: 'MOST POPULAR',
                        ),
                        const SizedBox(height: 8),
                        _PackageOption(
                          isSelected:
                              selectedPackage == CreditPurchaseOption.large,
                          credits: '2,500,000 credits',
                          price: '\$399',
                          unitPrice: '\$0.16 per 1K',
                          description: 'Maximum savings for enterprise needs',
                          badge: 'BEST DEAL',
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
                        'Secure payment via Stripe',
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
                        'Instant delivery',
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
                        'Not Now',
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
                        _getButtonText(selectedPackage),
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

  String _getButtonText(CreditPurchaseOption package) {
    switch (package) {
      case CreditPurchaseOption.small:
        return 'Get 100K Credits';
      case CreditPurchaseOption.medium:
        return 'Get 1M Credits';
      case CreditPurchaseOption.large:
        return 'Get 2.5M Credits';
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
      final checkoutUrl = await client.privateApiUsage
          .createCreditPurchaseCheckout(creditPackage: widget.package);

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
                  'Preparing checkout...',
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'ll be redirected to Stripe in a moment',
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
                  'Checkout Failed',
                  style: context.t.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.c.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage ?? 'An unexpected error occurred',
                  style: context.t.bodyMedium?.copyWith(
                    color: context.c.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
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
                  'Complete Your Purchase',
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
                        'Checkout opened in a new tab',
                        style: context.t.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.c.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Complete your purchase in the Stripe checkout page, then refresh this page to see your new credits.',
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
                      'Secure payment powered by Stripe',
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
                      showSnackbar(context, 'Account refreshed');
                    }
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Refresh & Close'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
