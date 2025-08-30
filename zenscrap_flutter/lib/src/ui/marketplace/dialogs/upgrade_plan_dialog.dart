import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';

class _UpgradePlanDialog extends ConsumerStatefulWidget {
  final String mainCTAText;
  const _UpgradePlanDialog({
    required this.mainCTAText,
  });

  @override
  ConsumerState<_UpgradePlanDialog> createState() => _UpgradePlanDialogState();
}

class _UpgradePlanDialogState extends ConsumerState<_UpgradePlanDialog> {
  bool _isLoadingPortal = false;

  Future<void> _openCustomerPortal() async {
    setState(() {
      _isLoadingPortal = true;
    });

    try {
      final client = ref.read(clientProvider);
      final portalUrl =
          await client.privateSubscription.createCustomerPortalSession();

      if (await canLaunchUrl(Uri.parse(portalUrl))) {
        await launchUrl(Uri.parse(portalUrl));

        if (mounted) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => _RefreshAfterUpgradeDialog(),
          );
        }
      } else {
        throw Exception('Could not launch customer portal');
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(context, 'Failed to open customer portal: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingPortal = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with premium icon
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: context.c.primary.withAlpha(26),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
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
                      Icons.workspace_premium_rounded,
                      size: 48,
                      color: context.c.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '🚀 Unlock Ultra Features',
                    style: context.t.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.c.primary,
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
                  Text(
                    'Clone & Customize Marketplace Scrappables',
                    style: context.t.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.mainCTAText,
                    style: context.t.bodyMedium?.copyWith(
                      color: context.c.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Benefits list
                  _BenefitItem(
                    icon: Icons.copy_all_rounded,
                    title: 'One-Click Clone',
                    description:
                        'Instantly copy any marketplace scrappable to your collection',
                  ),
                  const SizedBox(height: 12),
                  _BenefitItem(
                    icon: Icons.edit_note_rounded,
                    title: 'Full Customization',
                    description:
                        'Modify extraction rules, URLs, and parameters to your needs',
                  ),
                  const SizedBox(height: 12),
                  _BenefitItem(
                    icon: Icons.rocket_launch_rounded,
                    title: 'Save Development Time',
                    description:
                        'Build on existing scrappables instead of starting from scratch',
                  ),
                  const SizedBox(height: 12),
                  _BenefitItem(
                    icon: Icons.all_inclusive_rounded,
                    title: 'Plus Everything in Ultra',
                    description:
                        '1M API calls, 100 concurrent requests, priority support & more',
                  ),

                  const SizedBox(height: 32),

                  // Pricing highlight
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: context.c.tertiaryContainer.withAlpha(51),
                      border: Border.all(
                        color: context.c.tertiary.withAlpha(77),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: context.c.tertiary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Starting at just \$500/month',
                          style: context.t.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.c.tertiary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: context.c.error,
                          ),
                          child: Text(
                            'Save \$500/year',
                            style: context.t.labelSmall?.copyWith(
                              color: context.c.onError,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                color: context.c.surfaceContainerHighest.withAlpha(51),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Maybe Later',
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
                      onPressed: _isLoadingPortal ? null : _openCustomerPortal,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        backgroundColor: context.c.primary,
                        foregroundColor: context.c.onPrimary,
                        iconAlignment: IconAlignment.start,
                      ),
                      icon: _isLoadingPortal
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.c.onPrimary,
                              ),
                            )
                          : const Icon(
                              Icons.upgrade_outlined,
                              size: 28,
                            ),
                      label: Text(
                        _isLoadingPortal
                            ? 'Opening Portal...'
                            : 'Upgrade to Ultra',
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RefreshAfterUpgradeDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Row(
          children: [
            Icon(
              Icons.autorenew_rounded,
              color: context.c.primary,
            ),
            const SizedBox(width: 12),
            const Text('Updating Your Plan'),
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your subscription is being updated in the Stripe customer portal.',
            style: context.t.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Once you\'ve completed the upgrade, click refresh to activate your new features.',
            style: context.t.bodyMedium?.copyWith(
              color: context.c.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton.icon(
          onPressed: () async {
            // Refresh account info
            await ref.read(accountProvider.notifier).getAccountInfo();
            if (context.mounted) {
              Navigator.of(context).pop();
              showSnackbar(context, 'Account refreshed successfully');
            }
          },
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Refresh Account'),
        ),
      ],
    );
  }
}

// Public wrapper functions for showing upgrade dialogs with explanations

/// Shows upgrade dialog for cloning marketplace scrappables
Future<void> showCloneUpgradeDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      icon: Icon(
        Icons.copy_all_rounded,
        size: 48,
        color: context.c.primary,
      ),
      title: const Text('Clone Marketplace Scrappables'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This feature allows you to instantly copy any marketplace scrappable to your collection and customize it to your needs.',
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
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: context.c.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Requires Ultra Plan (\$500/month)',
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Ok'),
        ),
      ],
    ),
  );

  if (result == true && context.mounted) {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _UpgradePlanDialog(
        mainCTAText:
            'Get instant access to clone and customize any marketplace scrappable. Build on proven solutions instead of starting from scratch.',
      ),
    );
  }
}

/// Shows upgrade dialog for hiding scrappables from marketplace
Future<void> showHideFromMarketplaceUpgradeDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      icon: Icon(
        Icons.visibility_off_rounded,
        size: 48,
        color: context.c.primary,
      ),
      title: const Text('Hide from Marketplace'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Control the visibility of your scrappables in the marketplace. Keep your proprietary solutions private while still accessible via API.',
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
              child: Row(
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: context.c.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ultra Plan Exclusive Feature',
                      style: context.t.bodySmall?.copyWith(
                        color: context.c.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Ok'),
        ),
      ],
    ),
  );

  if (result == true && context.mounted) {
    await showDialog(
      context: context,
      builder: (context) => const _UpgradePlanDialog(
        mainCTAText:
            'Unlock the ability to hide your scrappables from the marketplace while keeping them fully accessible through your API.',
      ),
    );
  }
}
