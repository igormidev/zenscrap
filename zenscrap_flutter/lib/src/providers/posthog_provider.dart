import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:zenscrap_flutter/src/core/utils/device_utils.dart';
import 'package:zenscrap_flutter/src/core/utils/talker.dart';

/// Provider that initializes and provides access to PostHog analytics
final posthogProvider = Provider<Posthog>((ref) {
  return Posthog();
});

/// Analytics service provider that wraps PostHog with best practices
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final posthog = ref.watch(posthogProvider);
  return AnalyticsService(posthog);
});

/// Service class that encapsulates analytics tracking with PostHog best practices
///
/// Event naming convention: category:object_action
/// - category: context where event occurred (e.g., auth, dashboard)
/// - object: component/location (e.g., login_button, signup_form)
/// - action: verb describing what happened (e.g., click, submit, view)
///
/// Uses lowercase, snake_case, and present-tense verbs
///
/// All tracking methods are error-safe and will not throw exceptions to the app.
/// Errors are logged using Talker for debugging purposes.
class AnalyticsService {
  final Posthog _posthog;

  AnalyticsService(this._posthog);

  /// Whether analytics logging should be performed.
  ///
  /// Returns true only when running on web platform.
  /// This prevents development logs from Mac (the developer's machine) from
  /// mixing with real user analytics data, since the app is currently web-only.
  bool get _shouldLog => DeviceUtils.isWeb;

  /// Centralized, error-safe method to capture analytics events
  ///
  /// Wraps PostHog capture with try-catch to ensure analytics errors
  /// never disrupt app flow. Errors are logged via Talker.
  /// Only logs when running on web platform (see [_shouldLog]).
  Future<void> _safeCapture({
    required String eventName,
    required Map<String, Object> properties,
  }) async {
    if (!_shouldLog) return;
    try {
      await _posthog.capture(
        eventName: eventName,
        properties: properties,
      );
    } catch (e, stackTrace) {
      // Log analytics error but don't throw - analytics should never break the app
      logError(
        e,
        stackTrace,
        'Analytics tracking failed for event: $eventName',
      );
    }
  }

  /// Centralized, error-safe method to identify users
  ///
  /// Wraps PostHog identify with try-catch to ensure analytics errors
  /// never disrupt app flow. Errors are logged via Talker.
  /// Only logs when running on web platform (see [_shouldLog]).
  Future<void> _safeIdentify({
    required String userId,
    Map<String, Object>? userProperties,
  }) async {
    if (!_shouldLog) return;
    try {
      await _posthog.identify(
        userId: userId,
        userProperties: userProperties,
      );
    } catch (e, stackTrace) {
      // Log analytics error but don't throw - analytics should never break the app
      logError(
        e,
        stackTrace,
        'Analytics user identification failed for userId: $userId',
      );
    }
  }

  /// Centralized, error-safe method to reset user identification
  ///
  /// Wraps PostHog reset with try-catch to ensure analytics errors
  /// never disrupt app flow. Errors are logged via Talker.
  /// Only logs when running on web platform (see [_shouldLog]).
  Future<void> _safeReset() async {
    if (!_shouldLog) return;
    try {
      await _posthog.reset();
    } catch (e, stackTrace) {
      // Log analytics error but don't throw - analytics should never break the app
      logError(
        e,
        stackTrace,
        'Analytics reset failed',
      );
    }
  }

  /// Centralized, error-safe method to flush pending events
  ///
  /// Wraps PostHog flush with try-catch to ensure analytics errors
  /// never disrupt app flow. Errors are logged via Talker.
  /// Only logs when running on web platform (see [_shouldLog]).
  Future<void> _safeFlush() async {
    if (!_shouldLog) return;
    try {
      await _posthog.flush();
    } catch (e, stackTrace) {
      // Log analytics error but don't throw - analytics should never break the app
      logError(
        e,
        stackTrace,
        'Analytics flush failed',
      );
    }
  }

  // ========================================
  // Authentication Events
  // ========================================

  /// Track when user views the login form
  Future<void> trackAuthLoginViewed() async {
    await _safeCapture(
      eventName: 'auth:login_form_view',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user attempts to log in
  Future<void> trackAuthLoginAttempt({
    required String email,
  }) async {
    await _safeCapture(
      eventName: 'auth:login_form_submit',
      properties: {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track successful login
  Future<void> trackAuthLoginSuccess({
    required String email,
    required String userName,
  }) async {
    // Identify user in PostHog
    await _safeIdentify(
      userId: email,
      userProperties: {
        'email': email,
        'user_name': userName,
        'last_login_date': DateTime.now().toIso8601String(),
      },
    );

    await _safeCapture(
      eventName: 'auth:login_success',
      properties: {
        'email': email,
        'user_name': userName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track login failure
  Future<void> trackAuthLoginFailure({
    required String email,
    String? errorMessage,
  }) async {
    await _safeCapture(
      eventName: 'auth:login_failure',
      properties: {
        'email': email,
        if (errorMessage != null) 'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user views the sign up form
  Future<void> trackAuthSignUpViewed() async {
    await _safeCapture(
      eventName: 'auth:signup_form_view',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user attempts to sign up
  Future<void> trackAuthSignUpAttempt({
    required String email,
    required String userName,
  }) async {
    await _safeCapture(
      eventName: 'auth:signup_form_submit',
      properties: {
        'email': email,
        'user_name': userName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track successful sign up (account creation request sent)
  Future<void> trackAuthSignUpSuccess({
    required String email,
    required String userName,
  }) async {
    await _safeCapture(
      eventName: 'auth:signup_success',
      properties: {
        'email': email,
        'user_name': userName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track sign up failure
  Future<void> trackAuthSignUpFailure({
    required String email,
    String? errorMessage,
  }) async {
    await _safeCapture(
      eventName: 'auth:signup_failure',
      properties: {
        'email': email,
        if (errorMessage != null) 'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user views the password reset form
  Future<void> trackAuthPasswordResetViewed() async {
    await _safeCapture(
      eventName: 'auth:password_reset_form_view',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user initiates password reset
  Future<void> trackAuthPasswordResetInitiate({
    required String email,
  }) async {
    await _safeCapture(
      eventName: 'auth:password_reset_initiate',
      properties: {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track successful password reset code sent
  Future<void> trackAuthPasswordResetCodeSent({
    required String email,
  }) async {
    await _safeCapture(
      eventName: 'auth:password_reset_code_sent',
      properties: {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track password reset failure
  Future<void> trackAuthPasswordResetFailure({
    required String email,
    String? errorMessage,
  }) async {
    await _safeCapture(
      eventName: 'auth:password_reset_failure',
      properties: {
        'email': email,
        if (errorMessage != null) 'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user views the password reset validation page
  Future<void> trackAuthPasswordResetValidationViewed({
    required String email,
  }) async {
    await _safeCapture(
      eventName: 'auth:password_reset_validation_view',
      properties: {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track successful password reset completion
  Future<void> trackAuthPasswordResetComplete({
    required String email,
  }) async {
    await _safeCapture(
      eventName: 'auth:password_reset_complete',
      properties: {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track email confirmation view
  Future<void> trackAuthEmailConfirmationViewed({
    required String email,
  }) async {
    await _safeCapture(
      eventName: 'auth:email_confirmation_view',
      properties: {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track successful email confirmation
  Future<void> trackAuthEmailConfirmationSuccess({
    required String email,
  }) async {
    await _safeCapture(
      eventName: 'auth:email_confirmation_success',
      properties: {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user logs out
  Future<void> trackAuthLogout({
    required String email,
  }) async {
    await _safeCapture(
      eventName: 'auth:logout',
      properties: {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    // Reset user identification
    await _safeReset();
  }

  // ========================================
  // Pricing Page Events
  // ========================================

  /// Track when user views the pricing page
  Future<void> trackPricingPageView() async {
    await _safeCapture(
      eventName: 'pricing:page_view',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks on a subscription plan
  Future<void> trackPricingPlanClick({
    required String planTier,
    required bool isYearly,
    required double price,
  }) async {
    await _safeCapture(
      eventName: 'pricing:plan_button_click',
      properties: {
        'plan_tier': planTier,
        'billing_period': isYearly ? 'yearly' : 'monthly',
        'price': price,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when unauthenticated user tries to subscribe
  Future<void> trackPricingUnauthenticatedAttempt({
    required String planTier,
    required bool isYearly,
  }) async {
    await _safeCapture(
      eventName: 'pricing:unauthenticated_attempt',
      properties: {
        'plan_tier': planTier,
        'billing_period': isYearly ? 'yearly' : 'monthly',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when checkout session is successfully created
  Future<void> trackPricingCheckoutSessionCreated({
    required String planTier,
    required bool isYearly,
    required double price,
  }) async {
    await _safeCapture(
      eventName: 'pricing:checkout_session_created',
      properties: {
        'plan_tier': planTier,
        'billing_period': isYearly ? 'yearly' : 'monthly',
        'price': price,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when Stripe checkout page is opened
  Future<void> trackPricingCheckoutOpened({
    required String planTier,
    required bool isYearly,
  }) async {
    await _safeCapture(
      eventName: 'pricing:checkout_opened',
      properties: {
        'plan_tier': planTier,
        'billing_period': isYearly ? 'yearly' : 'monthly',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track checkout failure
  Future<void> trackPricingCheckoutFailure({
    required String planTier,
    required bool isYearly,
    String? errorMessage,
  }) async {
    await _safeCapture(
      eventName: 'pricing:checkout_failure',
      properties: {
        'plan_tier': planTier,
        'billing_period': isYearly ? 'yearly' : 'monthly',
        if (errorMessage != null) 'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // Account Page Events
  // ========================================

  /// Track when user views the account page
  Future<void> trackAccountPageView({
    required String userName,
    required String email,
    required String planTier,
  }) async {
    await _safeCapture(
      eventName: 'account:page_view',
      properties: {
        'user_name': userName,
        'email': email,
        'plan_tier': planTier,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks to change profile image
  Future<void> trackAccountProfileImageChangeClick() async {
    await _safeCapture(
      eventName: 'account:profile_image_change_click',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track successful profile image update
  Future<void> trackAccountProfileImageChangeSuccess() async {
    await _safeCapture(
      eventName: 'account:profile_image_change_success',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track profile image update failure
  Future<void> trackAccountProfileImageChangeFailure({
    String? errorMessage,
  }) async {
    await _safeCapture(
      eventName: 'account:profile_image_change_failure',
      properties: {
        if (errorMessage != null) 'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user copies information from account page
  Future<void> trackAccountInfoCopy({
    required String fieldName,
    required String fieldValue,
  }) async {
    await _safeCapture(
      eventName: 'account:info_copy',
      properties: {
        'field_name': fieldName,
        'field_value': fieldValue,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks contact support
  Future<void> trackAccountContactSupportClick() async {
    await _safeCapture(
      eventName: 'account:contact_support_click',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // Scrappable Creation Flow Events (InitialChatPage)
  // ========================================

  /// Track when user views the scrappable creation form
  Future<void> trackScrappableCreationFormView({
    bool isAuthenticated = false,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:creation_form_view',
      properties: {
        'is_authenticated': isAuthenticated,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user starts typing in URL field
  Future<void> trackScrappableUrlInputStart() async {
    await _safeCapture(
      eventName: 'scrappable:url_input_start',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user starts typing in prompt field
  Future<void> trackScrappablePromptInputStart() async {
    await _safeCapture(
      eventName: 'scrappable:prompt_input_start',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track scrappable creation attempt
  Future<void> trackScrappableCreationAttempt({
    required String targetUrl,
    required int promptLength,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:creation_attempt',
      properties: {
        'target_url': targetUrl,
        'prompt_length': promptLength,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track successful scrappable creation
  Future<void> trackScrappableCreationSuccess({
    required String targetUrl,
    required int scrappableId,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:creation_success',
      properties: {
        'target_url': targetUrl,
        'scrappable_id': scrappableId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track scrappable creation failure
  Future<void> trackScrappableCreationFailure({
    required String targetUrl,
    String? errorMessage,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:creation_failure',
      properties: {
        'target_url': targetUrl,
        if (errorMessage != null) 'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track login button click from creation page
  Future<void> trackScrappableCreationLoginClick() async {
    await _safeCapture(
      eventName: 'scrappable:creation_login_click',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // Scrappable Edit Session Events
  // ========================================

  /// Track when user views edit session (with existing scrappable)
  Future<void> trackScrappableEditSessionView({
    required int scrappableId,
    required String targetUrl,
    bool isAuthenticated = false,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:edit_session_view',
      properties: {
        'scrappable_id': scrappableId,
        'target_url': targetUrl,
        'is_authenticated': isAuthenticated,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user sends a message in chat
  Future<void> trackScrappableChatMessageSend({
    required int scrappableId,
    required int messageLength,
    required int messageCount,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:chat_message_send',
      properties: {
        'scrappable_id': scrappableId,
        'message_length': messageLength,
        'message_count': messageCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when AI responds to user message
  Future<void> trackScrappableChatMessageReceive({
    required int scrappableId,
    required int messageCount,
    required Duration responseTime,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:chat_message_receive',
      properties: {
        'scrappable_id': scrappableId,
        'message_count': messageCount,
        'response_time_ms': responseTime.inMilliseconds,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user changes AI model
  Future<void> trackScrappableAiModelChange({
    required int scrappableId,
    required String fromModel,
    required String toModel,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:ai_model_change',
      properties: {
        'scrappable_id': scrappableId,
        'from_model': fromModel,
        'to_model': toModel,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user copies CURL command
  Future<void> trackScrappableCurlCopy({
    required int scrappableId,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:curl_copy',
      properties: {
        'scrappable_id': scrappableId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user switches tabs in test response
  Future<void> trackScrappableTestTabSwitch({
    required int scrappableId,
    required String tabName,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:test_tab_switch',
      properties: {
        'scrappable_id': scrappableId,
        'tab_name': tabName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track deploy button click
  Future<void> trackScrappableDeployAttempt({
    required int scrappableId,
    required int messageCount,
    bool isAuthenticated = false,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:deploy_attempt',
      properties: {
        'scrappable_id': scrappableId,
        'message_count': messageCount,
        'is_authenticated': isAuthenticated,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track successful deployment
  Future<void> trackScrappableDeploySuccess({
    required int scrappableId,
    required int messageCount,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:deploy_success',
      properties: {
        'scrappable_id': scrappableId,
        'message_count': messageCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track deployment failure
  Future<void> trackScrappableDeployFailure({
    required int scrappableId,
    String? errorMessage,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:deploy_failure',
      properties: {
        'scrappable_id': scrappableId,
        if (errorMessage != null) 'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when unauthenticated user tries to deploy
  Future<void> trackScrappableDeployUnauthenticatedAttempt({
    required int scrappableId,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:deploy_unauthenticated_attempt',
      properties: {
        'scrappable_id': scrappableId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user discards changes
  Future<void> trackScrappableDiscardChanges({
    required int scrappableId,
    required int messageCount,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:discard_changes',
      properties: {
        'scrappable_id': scrappableId,
        'message_count': messageCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user navigates back
  Future<void> trackScrappableGoBack({
    required int scrappableId,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:go_back',
      properties: {
        'scrappable_id': scrappableId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when test session expires
  Future<void> trackScrappableSessionExpired({
    required int scrappableId,
    required int messageCount,
  }) async {
    await _safeCapture(
      eventName: 'scrappable:session_expired',
      properties: {
        'scrappable_id': scrappableId,
        'message_count': messageCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // User Scrappables Page Events
  // ========================================

  /// Track when user views their scrappables page
  Future<void> trackUserScrappablesPageView({
    required int scrappableCount,
    bool hasSearchQuery = false,
  }) async {
    await _safeCapture(
      eventName: 'user_scrappables:page_view',
      properties: {
        'scrappable_count': scrappableCount,
        'has_search_query': hasSearchQuery,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks create new endpoint button
  Future<void> trackUserScrappablesCreateNewClick() async {
    await _safeCapture(
      eventName: 'user_scrappables:create_new_click',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user submits the create scrappable dialog
  Future<void> trackUserScrappablesCreateNewDialogSubmit({
    required String targetUrl,
    required int promptLength,
  }) async {
    await _safeCapture(
      eventName: 'user_scrappables:create_dialog_submit',
      properties: {
        'target_url': targetUrl,
        'prompt_length': promptLength,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user starts searching their scrappables
  Future<void> trackUserScrappablesSearchStart({
    required String searchQuery,
    required int queryLength,
  }) async {
    await _safeCapture(
      eventName: 'user_scrappables:search_start',
      properties: {
        'search_query': searchQuery,
        'query_length': queryLength,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clears their search
  Future<void> trackUserScrappablesSearchClear() async {
    await _safeCapture(
      eventName: 'user_scrappables:search_clear',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks load more button
  Future<void> trackUserScrappablesLoadMoreClick({
    required int currentPage,
    required int totalPages,
  }) async {
    await _safeCapture(
      eventName: 'user_scrappables:load_more_click',
      properties: {
        'current_page': currentPage,
        'total_pages': totalPages,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks on a scrappable card
  Future<void> trackUserScrappablesCardClick({
    required int scrappableId,
    required String scrappableName,
  }) async {
    await _safeCapture(
      eventName: 'user_scrappables:card_click',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks edit button on scrappable card
  Future<void> trackUserScrappablesEditClick({
    required int scrappableId,
    required String scrappableName,
  }) async {
    await _safeCapture(
      eventName: 'user_scrappables:edit_click',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // Marketplace Page Events
  // ========================================

  /// Track when user views marketplace page
  Future<void> trackMarketplacePageView({
    required int scrappableCount,
    required int currentPage,
    bool hasSearchQuery = false,
  }) async {
    await _safeCapture(
      eventName: 'marketplace:page_view',
      properties: {
        'scrappable_count': scrappableCount,
        'current_page': currentPage,
        'has_search_query': hasSearchQuery,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks refresh button
  Future<void> trackMarketplaceRefreshClick() async {
    await _safeCapture(
      eventName: 'marketplace:refresh_click',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user starts searching marketplace
  Future<void> trackMarketplaceSearchStart({
    required String searchQuery,
    required int queryLength,
  }) async {
    await _safeCapture(
      eventName: 'marketplace:search_start',
      properties: {
        'search_query': searchQuery,
        'query_length': queryLength,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clears marketplace search
  Future<void> trackMarketplaceSearchClear() async {
    await _safeCapture(
      eventName: 'marketplace:search_clear',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks previous page button
  Future<void> trackMarketplacePaginationPrevious({
    required int fromPage,
    required int toPage,
  }) async {
    await _safeCapture(
      eventName: 'marketplace:pagination_previous',
      properties: {
        'from_page': fromPage,
        'to_page': toPage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks next page button
  Future<void> trackMarketplacePaginationNext({
    required int fromPage,
    required int toPage,
  }) async {
    await _safeCapture(
      eventName: 'marketplace:pagination_next',
      properties: {
        'from_page': fromPage,
        'to_page': toPage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks specific page number
  Future<void> trackMarketplacePaginationPage({
    required int fromPage,
    required int toPage,
  }) async {
    await _safeCapture(
      eventName: 'marketplace:pagination_page',
      properties: {
        'from_page': fromPage,
        'to_page': toPage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks on a marketplace scrappable card
  Future<void> trackMarketplaceCardClick({
    required int scrappableId,
    required String scrappableName,
    int? usageCount,
  }) async {
    await _safeCapture(
      eventName: 'marketplace:card_click',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        if (usageCount != null) 'usage_count': usageCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // API Usage Page Events
  // ========================================

  /// Track when user views the API usage page
  Future<void> trackApiUsagePageView({
    required int subscriptionCredits,
    required int purchasedCredits,
    required int totalCredits,
    required int apiKeyCount,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:page_view',
      properties: {
        'subscription_credits': subscriptionCredits,
        'purchased_credits': purchasedCredits,
        'total_credits': totalCredits,
        'api_key_count': apiKeyCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks refresh button
  Future<void> trackApiUsageRefreshClick() async {
    await _safeCapture(
      eventName: 'api_usage:refresh_click',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user selects a tab on mobile
  Future<void> trackApiUsageMobileTabSelect({
    required String tabName,
    required int tabIndex,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:mobile_tab_select',
      properties: {
        'tab_name': tabName,
        'tab_index': tabIndex,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks create API key button
  Future<void> trackApiUsageCreateApiKeyClick() async {
    await _safeCapture(
      eventName: 'api_usage:create_api_key_click',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user submits create API key form
  Future<void> trackApiUsageCreateApiKeySubmit({
    required String keyName,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:create_api_key_submit',
      properties: {
        'key_name': keyName,
        'name_length': keyName.length,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when API key is successfully created
  Future<void> trackApiUsageCreateApiKeySuccess({
    required int keyId,
    required String keyName,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:create_api_key_success',
      properties: {
        'key_id': keyId,
        'key_name': keyName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user copies API key from success dialog
  Future<void> trackApiUsageCopyApiKeyDialog({
    required int keyId,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:copy_api_key_dialog',
      properties: {
        'key_id': keyId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user copies API key from card
  Future<void> trackApiUsageCopyApiKeyCard({
    required int keyId,
    required String keyName,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:copy_api_key_card',
      properties: {
        'key_id': keyId,
        'key_name': keyName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks deactivate on API key
  Future<void> trackApiUsageDeactivateApiKeyClick({
    required int keyId,
    required String keyName,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:deactivate_api_key_click',
      properties: {
        'key_id': keyId,
        'key_name': keyName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user confirms API key deactivation
  Future<void> trackApiUsageDeactivateApiKeyConfirm({
    required int keyId,
    required String keyName,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:deactivate_api_key_confirm',
      properties: {
        'key_id': keyId,
        'key_name': keyName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user cancels API key deactivation
  Future<void> trackApiUsageDeactivateApiKeyCancel({
    required int keyId,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:deactivate_api_key_cancel',
      properties: {
        'key_id': keyId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks load more in credit history
  Future<void> trackApiUsageLoadMoreHistoryClick({
    required int currentCount,
    required bool hasMore,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:load_more_history_click',
      properties: {
        'current_count': currentCount,
        'has_more': hasMore,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user copies account ID
  Future<void> trackApiUsageCopyAccountId({
    required String accountId,
  }) async {
    await _safeCapture(
      eventName: 'api_usage:copy_account_id',
      properties: {
        'account_id': accountId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // API Analytics Page Events
  // ========================================

  /// Track when user views the API analytics page
  Future<void> trackApiAnalyticsPageView({
    required int scrappableCount,
    required String timeScope,
  }) async {
    await _safeCapture(
      eventName: 'api_analytics:page_view',
      properties: {
        'scrappable_count': scrappableCount,
        'time_scope': timeScope,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks refresh button
  Future<void> trackApiAnalyticsRefreshClick({
    required String timeScope,
  }) async {
    await _safeCapture(
      eventName: 'api_analytics:refresh_click',
      properties: {
        'time_scope': timeScope,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user changes time scope
  Future<void> trackApiAnalyticsTimeScopeChange({
    required String fromScope,
    required String toScope,
  }) async {
    await _safeCapture(
      eventName: 'api_analytics:time_scope_change',
      properties: {
        'from_scope': fromScope,
        'to_scope': toScope,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks on a scrappable analytics card
  Future<void> trackApiAnalyticsScrappableCardClick({
    required int scrappableId,
    required String scrappableName,
    required bool isSelecting,
  }) async {
    await _safeCapture(
      eventName: 'api_analytics:scrappable_card_click',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        'is_selecting': isSelecting,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when load more cards is triggered by scrolling
  Future<void> trackApiAnalyticsLoadMoreCardsTrigger({
    required int currentCount,
    required int totalCount,
  }) async {
    await _safeCapture(
      eventName: 'api_analytics:load_more_cards_trigger',
      properties: {
        'current_count': currentCount,
        'total_count': totalCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when selected scrappable details view opens
  Future<void> trackApiAnalyticsSelectedScrappableView({
    required int scrappableId,
    required String scrappableName,
  }) async {
    await _safeCapture(
      eventName: 'api_analytics:selected_scrappable_view',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks load more in details panel
  Future<void> trackApiAnalyticsLoadMoreDetailsClick({
    required int scrappableId,
    required int currentCount,
  }) async {
    await _safeCapture(
      eventName: 'api_analytics:load_more_details_click',
      properties: {
        'scrappable_id': scrappableId,
        'current_count': currentCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks back button on mobile
  Future<void> trackApiAnalyticsMobileBackClick({
    required int scrappableId,
  }) async {
    await _safeCapture(
      eventName: 'api_analytics:mobile_back_click',
      properties: {
        'scrappable_id': scrappableId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks retry after error
  Future<void> trackApiAnalyticsErrorRetryClick({
    required String errorType,
  }) async {
    await _safeCapture(
      eventName: 'api_analytics:error_retry_click',
      properties: {
        'error_type': errorType,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // Edit Scrappable Dialog Events
  // ========================================

  /// Track when edit scrappable dialog is opened
  Future<void> trackEditScrappableDialogView({
    required int scrappableId,
    required String scrappableName,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:dialog_view',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user closes the edit dialog
  Future<void> trackEditScrappableDialogClose({
    required int scrappableId,
    required bool hadUnsavedChanges,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:dialog_close',
      properties: {
        'scrappable_id': scrappableId,
        'had_unsaved_changes': hadUnsavedChanges,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user changes the scrappable name
  Future<void> trackEditScrappableNameChange({
    required int scrappableId,
    required int nameLength,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:name_change',
      properties: {
        'scrappable_id': scrappableId,
        'name_length': nameLength,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user changes the scrappable description
  Future<void> trackEditScrappableDescriptionChange({
    required int scrappableId,
    required int descriptionLength,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:description_change',
      properties: {
        'scrappable_id': scrappableId,
        'description_length': descriptionLength,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user opens category selection dialog
  Future<void> trackEditScrappableCategoryDialogOpen({
    required int scrappableId,
    required String currentCategory,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:category_dialog_open',
      properties: {
        'scrappable_id': scrappableId,
        'current_category': currentCategory,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user selects a new category
  Future<void> trackEditScrappableCategoryChange({
    required int scrappableId,
    required String fromCategory,
    required String toCategory,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:category_change',
      properties: {
        'scrappable_id': scrappableId,
        'from_category': fromCategory,
        'to_category': toCategory,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks save button
  Future<void> trackEditScrappableSaveClick({
    required int scrappableId,
    required bool hasNameChange,
    required bool hasDescriptionChange,
    required bool hasCategoryChange,
    required bool hasMarketplaceVisibilityChange,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:save_click',
      properties: {
        'scrappable_id': scrappableId,
        'has_name_change': hasNameChange,
        'has_description_change': hasDescriptionChange,
        'has_category_change': hasCategoryChange,
        'has_marketplace_visibility_change': hasMarketplaceVisibilityChange,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when save operation succeeds
  Future<void> trackEditScrappableSaveSuccess({
    required int scrappableId,
    required String scrappableName,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:save_success',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when save operation fails
  Future<void> trackEditScrappableSaveFailure({
    required int scrappableId,
    String? errorMessage,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:save_failure',
      properties: {
        'scrappable_id': scrappableId,
        if (errorMessage != null) 'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks delete button
  Future<void> trackEditScrappableDeleteClick({
    required int scrappableId,
    required String scrappableName,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:delete_click',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user cancels deletion
  Future<void> trackEditScrappableDeleteCancel({
    required int scrappableId,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:delete_cancel',
      properties: {
        'scrappable_id': scrappableId,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user confirms deletion
  Future<void> trackEditScrappableDeleteConfirm({
    required int scrappableId,
    required String scrappableName,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:delete_confirm',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when deletion succeeds
  Future<void> trackEditScrappableDeleteSuccess({
    required int scrappableId,
    required String scrappableName,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:delete_success',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when deletion fails
  Future<void> trackEditScrappableDeleteFailure({
    required int scrappableId,
    String? errorMessage,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:delete_failure',
      properties: {
        'scrappable_id': scrappableId,
        if (errorMessage != null) 'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks "Edit scrapper extract logic" button
  Future<void> trackEditScrappableEditExtractLogicClick({
    required int scrappableId,
    required String scrappableName,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:edit_extract_logic_click',
      properties: {
        'scrappable_id': scrappableId,
        'scrappable_name': scrappableName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user toggles hide from marketplace
  Future<void> trackEditScrappableMarketplaceToggle({
    required int scrappableId,
    required bool newValue,
    required bool hadPermission,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:marketplace_toggle',
      properties: {
        'scrappable_id': scrappableId,
        'new_value': newValue,
        'had_permission': hadPermission,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when upgrade dialog is shown for marketplace hiding
  Future<void> trackEditScrappableUpgradeDialogShown({
    required int scrappableId,
  }) async {
    await _safeCapture(
      eventName: 'edit_scrappable:upgrade_dialog_shown',
      properties: {
        'scrappable_id': scrappableId,
        'feature': 'hide_from_marketplace',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // Credit Limit Events
  // ========================================

  /// Track when user sees the IP limit reached message
  Future<void> trackChatIpLimitReachedView({
    required double totalSpentUsd,
    required double spendingLimitUsd,
    required int timeUntilResetSeconds,
  }) async {
    await _safeCapture(
      eventName: 'chat:ip_limit_reached_view',
      properties: {
        'total_spent_usd': totalSpentUsd,
        'spending_limit_usd': spendingLimitUsd,
        'time_until_reset_seconds': timeUntilResetSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks "Create Account" button from IP limit message
  Future<void> trackChatIpLimitCreateAccountClick({
    required double totalSpentUsd,
    required double spendingLimitUsd,
    required int timeUntilResetSeconds,
  }) async {
    await _safeCapture(
      eventName: 'chat:ip_limit_create_account_click',
      properties: {
        'total_spent_usd': totalSpentUsd,
        'spending_limit_usd': spendingLimitUsd,
        'time_until_reset_seconds': timeUntilResetSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user sees the IP limit error on create scrappable page
  Future<void> trackCreateScrappableIpLimitView({
    required String errorTitle,
    required String errorDescription,
  }) async {
    await _safeCapture(
      eventName: 'create_scrappable:ip_limit_view',
      properties: {
        'error_title': errorTitle,
        'error_description': errorDescription,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks "Create Account" from IP limit error on create scrappable page
  Future<void> trackCreateScrappableIpLimitCreateAccountClick({
    required String errorTitle,
  }) async {
    await _safeCapture(
      eventName: 'create_scrappable:ip_limit_create_account_click',
      properties: {
        'error_title': errorTitle,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks "Try Again" from IP limit error on create scrappable page
  Future<void> trackCreateScrappableIpLimitTryAgainClick() async {
    await _safeCapture(
      eventName: 'create_scrappable:ip_limit_try_again_click',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

// ========================================
  // Suspicious IP Block Events
  // ========================================

  /// Track when user sees the suspicious IP block error view
  Future<void> trackSuspiciousIpBlockView({
    required String errorTitle,
    required String errorDescription,
  }) async {
    await _safeCapture(
      eventName: 'suspicious_ip:block_view',
      properties: {
        'error_title': errorTitle,
        'error_description': errorDescription,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks "Create Account" from suspicious IP block view
  Future<void> trackSuspiciousIpCreateAccountClick({
    required String errorTitle,
  }) async {
    await _safeCapture(
      eventName: 'suspicious_ip:create_account_click',
      properties: {
        'error_title': errorTitle,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks "Try Again" from suspicious IP block view
  Future<void> trackSuspiciousIpTryAgainClick() async {
    await _safeCapture(
      eventName: 'suspicious_ip:try_again_click',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user sees suspicious IP message in chat stream
  Future<void> trackChatSuspiciousIpMessageView({
    required String blockReason,
    required bool isVpn,
    required bool isProxy,
    required bool isTor,
    required bool isDatacenter,
    required bool isAbuser,
    String? countryCode,
  }) async {
    await _safeCapture(
      eventName: 'chat:suspicious_ip_message_view',
      properties: {
        'block_reason': blockReason,
        'is_vpn': isVpn,
        'is_proxy': isProxy,
        'is_tor': isTor,
        'is_datacenter': isDatacenter,
        'is_abuser': isAbuser,
        if (countryCode != null) 'country_code': countryCode,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks "Create Account" from suspicious IP chat message
  Future<void> trackChatSuspiciousIpCreateAccountClick({
    required String blockReason,
  }) async {
    await _safeCapture(
      eventName: 'chat:suspicious_ip_create_account_click',
      properties: {
        'block_reason': blockReason,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when a new (anonymous/not logged in) user encounters an error on their
  /// first interaction with the platform.
  ///
  /// This is a critical event for understanding user drop-off at the very first
  /// step of the user journey. New users who hit errors on their first attempt
  /// are at high risk of abandoning the platform.
  ///
  /// This event is ONLY tracked for:
  /// - Users who are NOT logged in (anonymous/new visitors)
  /// - When an error occurs during their first scrappable creation attempt
  ///
  /// Fields:
  /// - targetUrl: The URL the user was trying to scrape
  /// - promptLength: Length of the user's extraction prompt
  /// - errorMessage: The error message received
  Future<void> trackNewUserFirstInteractionError({
    required String targetUrl,
    required int promptLength,
    required String errorMessage,
  }) async {
    await _safeCapture(
      eventName: 'new_user:first_interaction_error',
      properties: {
        'target_url': targetUrl,
        'prompt_length': promptLength,
        'error_message': errorMessage,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user sees the session credit limit reached message
  Future<void> trackChatSessionLimitReachedView({
    required double creditsSpent,
    required double creditsLimit,
    required bool canUseOwnApiKey,
  }) async {
    await _safeCapture(
      eventName: 'chat:session_limit_reached_view',
      properties: {
        'credits_spent': creditsSpent,
        'credits_limit': creditsLimit,
        'can_use_own_api_key': canUseOwnApiKey,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks "Add Your OpenAI API Key" button from credit limit message
  Future<void> trackChatSessionLimitAddApiKeyClick({
    required double creditsSpent,
    required double creditsLimit,
  }) async {
    await _safeCapture(
      eventName: 'chat:session_limit_add_api_key_click',
      properties: {
        'credits_spent': creditsSpent,
        'credits_limit': creditsLimit,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // Chat Response Error Events
  // ========================================

  /// Track when any error response is received in chat.
  ///
  /// This tracks all types of errors that can occur during the chat session:
  /// - ErrorTextResponse: General AI error message
  /// - TestEndpointCalledErrorResponse: Error when testing the endpoint
  /// - CreditLimitReachedResponse: Session credit limit reached
  /// - IpLimitReachedResponse: IP rate limit for anonymous users
  /// - UserApiKeyQuotaExceededResponse: User's OpenAI API key quota exceeded
  Future<void> trackChatResponseError({
    required int scrappableId,
    required String errorType,
    required int messageCount,
    required bool isFirstResponse,
    String? errorMessage,
    String? errorTitle,
    String? errorDescription,
  }) async {
    await _safeCapture(
      eventName: 'chat:response_error',
      properties: {
        'scrappable_id': scrappableId,
        'error_type': errorType,
        'message_count': messageCount,
        'is_first_response': isFirstResponse,
        if (errorMessage != null) 'error_message': errorMessage,
        if (errorTitle != null) 'error_title': errorTitle,
        if (errorDescription != null) 'error_description': errorDescription,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when the first extract rule is successfully generated.
  ///
  /// This is a critical event - it means the AI successfully analyzed the page
  /// and generated working extract rules for the first time.
  Future<void> trackChatFirstExtractRuleSuccess({
    required int scrappableId,
    required int messageCount,
  }) async {
    await _safeCapture(
      eventName: 'chat:first_extract_rule_success',
      properties: {
        'scrappable_id': scrappableId,
        'message_count': messageCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when an error occurs before ANY extract rule is generated.
  ///
  /// This is a CRITICAL event for understanding user drop-off. If a user
  /// encounters an error before receiving their first working extract rule,
  /// they are at very high risk of abandoning the platform.
  ///
  /// This is different from `trackChatResponseError` because it specifically
  /// tracks errors that occur BEFORE the user has ever seen a successful result.
  Future<void> trackChatFirstExtractRuleError({
    required int scrappableId,
    required String errorType,
    required int messageCount,
    String? errorMessage,
    String? errorTitle,
    String? errorDescription,
  }) async {
    await _safeCapture(
      eventName: 'chat:first_extract_rule_error',
      properties: {
        'scrappable_id': scrappableId,
        'error_type': errorType,
        'message_count': messageCount,
        if (errorMessage != null) 'error_message': errorMessage,
        if (errorTitle != null) 'error_title': errorTitle,
        if (errorDescription != null) 'error_description': errorDescription,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track any chat response received (for overall metrics).
  ///
  /// Response types tracked:
  /// - message_text: Regular text message from AI
  /// - new_extract_rule: Extract rules generated successfully
  /// - test_endpoint_success: Endpoint test successful
  /// - test_endpoint_error: Endpoint test failed
  /// - updated_request: Request configuration updated
  /// - candidate_extract_logic: Extract logic candidate update
  /// - api_key_updated: API key was updated
  /// - error_text: General error message
  /// - credit_limit_reached: Session credit limit
  /// - ip_limit_reached: IP rate limit
  /// - user_api_key_quota_exceeded: User API key quota exceeded
  Future<void> trackChatResponseReceived({
    required int scrappableId,
    required String responseType,
    required int messageCount,
    required bool hasReceivedExtractRule,
  }) async {
    await _safeCapture(
      eventName: 'chat:response_received',
      properties: {
        'scrappable_id': scrappableId,
        'response_type': responseType,
        'message_count': messageCount,
        'has_received_extract_rule': hasReceivedExtractRule,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // Landing Page Events
  // ========================================

  /// Track when landing page is viewed
  Future<void> trackLandingPageView() async {
    await _safeCapture(
      eventName: 'landing:page_view',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track scroll depth milestones (25%, 50%, 75%, 100%)
  ///
  /// Based on research:
  /// - 50%+ scroll depth is above average engagement
  /// - Users who scroll past 70% convert at 5.8x higher rate
  Future<void> trackLandingScrollDepth({
    required int depthPercentage,
    required double scrollPosition,
    required double maxScrollExtent,
  }) async {
    await _safeCapture(
      eventName: 'landing:scroll_depth',
      properties: {
        'depth_percentage': depthPercentage,
        'scroll_position': scrollPosition,
        'max_scroll_extent': maxScrollExtent,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when a landing page section becomes visible in viewport
  ///
  /// This helps understand which content users actually see and engage with.
  /// Sections: hero, problem, howItWorks, autoFix, features, marketplace, pricing, finalCta
  Future<void> trackLandingSectionView({
    required String sectionName,
    required int sectionIndex,
    required double scrollPosition,
  }) async {
    await _safeCapture(
      eventName: 'landing:section_view',
      properties: {
        'section_name': sectionName,
        'section_index': sectionIndex,
        'scroll_position': scrollPosition,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks a navigation item in the landing appbar
  ///
  /// This shows which sections users are most interested in navigating to directly.
  Future<void> trackLandingNavClick({
    required String sectionName,
    required String currentSection,
    required double scrollPosition,
  }) async {
    await _safeCapture(
      eventName: 'landing:nav_item_click',
      properties: {
        'clicked_section': sectionName,
        'from_section': currentSection,
        'scroll_position': scrollPosition,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks the "Learn more" scroll indicator
  Future<void> trackLandingLearnMoreClick({
    required double scrollPosition,
  }) async {
    await _safeCapture(
      eventName: 'landing:learn_more_click',
      properties: {
        'scroll_position': scrollPosition,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks the "Sign In" button in landing appbar
  Future<void> trackLandingSignInClick({
    required String currentSection,
    required double scrollPosition,
  }) async {
    await _safeCapture(
      eventName: 'landing:sign_in_click',
      properties: {
        'from_section': currentSection,
        'scroll_position': scrollPosition,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track CTA button clicks on landing page
  ///
  /// Tracks all call-to-action buttons: "Create Your First Scraper", "Browse Marketplace", etc.
  Future<void> trackLandingCtaClick({
    required String buttonLabel,
    required String sectionName,
    required double scrollPosition,
  }) async {
    await _safeCapture(
      eventName: 'landing:cta_button_click',
      properties: {
        'button_label': buttonLabel,
        'section_name': sectionName,
        'scroll_position': scrollPosition,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user clicks "Create Your First Scraper" from Final CTA section
  /// (separate from hero section which is tracked by trackScrappableCreationAttempt)
  Future<void> trackLandingFinalCtaClick({
    required String buttonType,
    required double scrollPosition,
  }) async {
    await _safeCapture(
      eventName: 'landing:final_cta_click',
      properties: {
        'button_type': buttonType,
        'scroll_position': scrollPosition,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track engagement time on landing page when user leaves
  Future<void> trackLandingEngagement({
    required int engagementTimeSeconds,
    required int maxScrollDepthPercentage,
    required List<String> sectionsViewed,
    required int navClicksCount,
    required int ctaClicksCount,
  }) async {
    await _safeCapture(
      eventName: 'landing:engagement_summary',
      properties: {
        'engagement_time_seconds': engagementTimeSeconds,
        'max_scroll_depth_percentage': maxScrollDepthPercentage,
        'sections_viewed': sectionsViewed.join(','),
        'sections_viewed_count': sectionsViewed.length,
        'nav_clicks_count': navClicksCount,
        'cta_clicks_count': ctaClicksCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  // ========================================
  // General Utility Methods
  // ========================================

  /// Track any custom event with properties
  Future<void> trackEvent({
    required String eventName,
    Map<String, Object>? properties,
  }) async {
    final Map<String, Object> eventProps = {
      if (properties != null) ...properties,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _safeCapture(
      eventName: eventName,
      properties: eventProps,
    );
  }

  /// Identify a user in PostHog
  Future<void> identifyUser({
    required String userId,
    Map<String, Object>? userProperties,
  }) async {
    await _safeIdentify(
      userId: userId,
      userProperties: userProperties,
    );
  }

  /// Reset user identification (call on logout)
  Future<void> reset() async {
    await _safeReset();
  }

  /// Flush any pending events
  Future<void> flush() async {
    await _safeFlush();
  }
}
