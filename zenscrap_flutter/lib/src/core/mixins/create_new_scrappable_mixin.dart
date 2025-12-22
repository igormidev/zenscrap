// ignore_for_file: use_build_context_synchronously

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/plan_tier_extension.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/dialogs/upgrade_plan_dialog.dart';
import 'package:zenscrap_flutter/src/ui/scrappables/dialogs/create_scrappable_dialog.dart';

/// A mixin that provides the "Create New Scrappable" button functionality.
///
/// This handles:
/// - Analytics tracking for the create new click
/// - Plan limit checking and upgrade dialog
/// - Resetting the chat session
/// - Showing the create scrappable dialog
/// - Navigating to the scrappable form on success
///
/// Example:
/// ```dart
/// class _MyWidgetState extends ConsumerState<MyWidget>
///     with CreateNewScrappableMixin {
///   Future<void> _handleCreateNew() async {
///     await onTapCreateNewScrappable(
///       context,
///       isAtLimit: false,
///       totalUserScrappables: 5,
///       maxAllowed: 10,
///       planTier: PlanTier.starter,
///     );
///   }
/// }
/// ```
mixin CreateNewScrappableMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  /// Handles the "Create New Scrappable" button tap.
  ///
  /// Parameters:
  /// - [context]: The build context for dialogs and navigation
  /// - [isAtLimit]: Whether the user has reached their scrappable limit
  /// - [totalUserScrappables]: Current count of user's scrappables
  /// - [maxAllowed]: Maximum allowed scrappables for the user's plan
  /// - [planTier]: The user's current plan tier
  Future<void> onTapCreateNewScrappable(
    BuildContext context, {
    required bool isAtLimit,
    required int totalUserScrappables,
    required int maxAllowed,
    required PlanTier planTier,
  }) async {
    final analytics = ref.read(analyticsServiceProvider);

    // Track create new click
    await analytics.trackUserScrappablesCreateNewClick();

    // Check if user is at their endpoint limit
    if (isAtLimit) {
      if (!context.mounted) return;
      await showEndpointLimitUpgradeDialog(
        context,
        currentCount: totalUserScrappables,
        maxAllowed: maxAllowed,
        currentPlan: planTier,
        nextPlan: planTier.nextTier,
      );
    }

    ref.read(scrapChatProvider.notifier).reset();
    if (!context.mounted) return;

    // Show the create scrappable dialog
    final result = await CreateScrappableDialog.show(context);
    if (result == true && context.mounted) {
      // Navigate to /scrappable-form which shows LandingPage
      // LandingPage handles the creatingScrappable state (shows AI thinking dialog)
      // and switches to ScrappableEditSessionView when state becomes standard
      context.go('/scrappable-form');
    }
  }
}
