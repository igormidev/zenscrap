import 'package:babel_text/babel_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/core/extensions/plan_tier_extension.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';

/// A tile that displays the subscription plan with a sync button
/// to refresh subscription status from Stripe.
class SubscriptionSyncTile extends ConsumerStatefulWidget {
  final AccountInfo accountInfo;
  final AnalyticsService analytics;

  const SubscriptionSyncTile({
    super.key,
    required this.accountInfo,
    required this.analytics,
  });

  @override
  ConsumerState<SubscriptionSyncTile> createState() =>
      _SubscriptionSyncTileState();
}

class _SubscriptionSyncTileState extends ConsumerState<SubscriptionSyncTile> {
  bool _isSyncing = false;

  Future<void> _syncSubscription() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    final language = ref.read(currentLanguageProvider);
    final result = await ref
        .read(clientProvider)
        .privateSubscription
        .syncSubscriptionFromStripe(language: language)
        .toResult;

    if (!mounted) return;

    await result.fold(
      (accountInfo) async {
        ref.read(accountProvider.notifier).setUser(accountInfo);

        // Track sync success
        await widget.analytics.trackSubscriptionSync(
          success: true,
          planTier: accountInfo.planTier.displayName,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.account_subscription_sync_success,
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: context.c.primary,
            ),
          );
        }
      },
      (error) async {
        // Track sync failure
        await widget.analytics.trackSubscriptionSync(
          success: false,
          planTier: widget.accountInfo.planTier.displayName,
        );

        if (mounted) {
          await handleBabelException(context, error);
        }
      },
    );

    if (mounted) {
      setState(() {
        _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final borderRadius = context.responsiveValue(
      compact: 6.0,
      medium: 7.0,
      expanded: 8.0,
    );

    final horizontalPadding = context.responsiveValue(
      compact: 12.0,
      medium: 14.0,
      expanded: 16.0,
    );

    final planName = widget.accountInfo.planTier.displayName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: BabelText(
                l10n.account_subscription_plan_label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            // Sync button
            _SyncButton(
              isSyncing: _isSyncing,
              onPressed: _syncSubscription,
            ),
          ],
        ),
        SizedBox(
          height: context.responsiveValue(
            compact: 6.0,
            medium: 7.0,
            expanded: 8.0,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: context.c.surfaceContainerLow,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.only(left: horizontalPadding, right: 8),
          child: Row(
            children: [
              // Plan tier icon
              _PlanTierBadge(planTier: widget.accountInfo.planTier),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  planName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: context.c.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: planName));
                  await widget.analytics.trackAccountInfoCopy(
                    fieldName: l10n.account_subscription_plan_label,
                    fieldValue: planName,
                  );
                },
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Animated sync button with loading state
class _SyncButton extends StatelessWidget {
  final bool isSyncing;
  final VoidCallback onPressed;

  const _SyncButton({
    required this.isSyncing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSyncing ? null : onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSyncing)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.c.primary,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.sync_rounded,
                    size: 18,
                    color: context.c.primary,
                  ),
                const SizedBox(width: 6),
                Text(
                  isSyncing
                      ? l10n.account_subscription_syncing
                      : l10n.account_subscription_sync,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: context.c.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Badge showing the plan tier with appropriate styling
class _PlanTierBadge extends StatelessWidget {
  final PlanTier planTier;

  const _PlanTierBadge({required this.planTier});

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (planTier) {
      PlanTier.none => (Icons.person_outline_rounded, context.c.outline),
      PlanTier.basic => (Icons.star_outline_rounded, Colors.blue),
      PlanTier.pro => (Icons.star_rounded, Colors.purple),
      PlanTier.ultra => (Icons.auto_awesome_rounded, Colors.amber),
    };

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 20,
        color: color,
      ),
    );
  }
}
