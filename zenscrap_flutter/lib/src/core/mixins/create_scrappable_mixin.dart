import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';

/// A mixin that provides scrappable creation functionality with analytics tracking.
///
/// Use this mixin on any [ConsumerState] to enable creating scrappables
/// with standardized analytics tracking for attempts, success, and failures.
///
/// Example:
/// ```dart
/// class _MyWidgetState extends ConsumerState<MyWidget>
///     with CreateScrappableMixin {
///   Future<void> _handleCreate() async {
///     await createScrappableWithTracking(
///       targetUrl: 'https://example.com',
///       userPrompt: 'Extract product data',
///       onSuccess: () => print('Created!'),
///     );
///   }
/// }
/// ```
mixin CreateScrappableMixin<T extends ConsumerStatefulWidget>
    on ConsumerState<T> {
  /// Creates a scrappable with full analytics tracking.
  ///
  /// This method handles the entire flow of creating a scrappable:
  /// 1. Executes optional [onBeforeCreate] callback (e.g., for page-specific analytics)
  /// 2. Tracks creation attempt analytics
  /// 3. Calls the scrappable creation API via [scrapChatProvider]
  /// 4. Tracks success/failure analytics
  /// 5. Calls [onSuccess] callback on successful creation
  ///
  /// Parameters:
  /// - [targetUrl]: The URL to create a scrapper for
  /// - [userPrompt]: The extraction instructions from the user
  /// - [onSuccess]: Optional callback invoked after successful creation
  /// - [onBeforeCreate]: Optional async callback before creation starts
  ///   (useful for additional analytics like landing page CTA tracking)
  ///
  /// Throws any exception that occurs during creation after tracking
  /// the failure analytics.
  Future<void> createScrappableWithTracking({
    required String targetUrl,
    required String userPrompt,
    VoidCallback? onSuccess,
    Future<void> Function()? onBeforeCreate,
  }) async {
    final analytics = ref.read(analyticsServiceProvider);

    // Call optional pre-creation callback (e.g., for landing page specific analytics)
    await onBeforeCreate?.call();

    await analytics.trackScrappableCreationAttempt(
      targetUrl: targetUrl,
      promptLength: userPrompt.length,
    );

    try {
      await ref
          .read(scrapChatProvider.notifier)
          .createScrappable(targetUrl: targetUrl, userPrompt: userPrompt);

      await analytics.trackScrappableCreationSuccess(
        targetUrl: targetUrl,
        scrappableId: 0, // Not available at this point, state transitions async
      );

      onSuccess?.call();
    } catch (e) {
      await analytics.trackScrappableCreationFailure(
        targetUrl: targetUrl,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }
}
