import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

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
class AnalyticsService {
  final Posthog _posthog;

  AnalyticsService(this._posthog);

  // ========================================
  // Authentication Events
  // ========================================

  /// Track when user views the login form
  Future<void> trackAuthLoginViewed() async {
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.identify(
      userId: email,
      userProperties: {
        'email': email,
        'user_name': userName,
        'last_login_date': DateTime.now().toIso8601String(),
      },
    );

    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
      eventName: 'auth:logout',
      properties: {
        'email': email,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    // Reset user identification
    await _posthog.reset();
  }

  // ========================================
  // Pricing Page Events
  // ========================================

  /// Track when user views the pricing page
  Future<void> trackPricingPageView() async {
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
      eventName: 'account:profile_image_change_click',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track successful profile image update
  Future<void> trackAccountProfileImageChangeSuccess() async {
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
      eventName: 'scrappable:creation_form_view',
      properties: {
        'is_authenticated': isAuthenticated,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user starts typing in URL field
  Future<void> trackScrappableUrlInputStart() async {
    await _posthog.capture(
      eventName: 'scrappable:url_input_start',
      properties: {
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track when user starts typing in prompt field
  Future<void> trackScrappablePromptInputStart() async {
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
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
    await _posthog.capture(
      eventName: 'scrappable:session_expired',
      properties: {
        'scrappable_id': scrappableId,
        'message_count': messageCount,
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
    await _posthog.capture(
      eventName: eventName,
      properties: eventProps,
    );
  }

  /// Identify a user in PostHog
  Future<void> identifyUser({
    required String userId,
    Map<String, Object>? userProperties,
  }) async {
    await _posthog.identify(
      userId: userId,
      userProperties: userProperties,
    );
  }

  /// Reset user identification (call on logout)
  Future<void> reset() async {
    await _posthog.reset();
  }

  /// Flush any pending events
  Future<void> flush() async {
    await _posthog.flush();
  }
}
