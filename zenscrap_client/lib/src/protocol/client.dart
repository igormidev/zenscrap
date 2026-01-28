/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:zenscrap_client/src/protocol/entities/auth/user_profile_response.dart'
    as _i5;
import 'package:zenscrap_client/src/protocol/entities/account/account.dart'
    as _i6;
import 'package:zenscrap_client/src/protocol/entities/supported_language.dart'
    as _i7;
import 'package:zenscrap_client/src/protocol/entities/account/ai_usage/ai_credit_history/paginated_ai_credit_history_response.dart'
    as _i8;
import 'package:zenscrap_client/src/protocol/entities/account/ai_usage/account_ai_usage.dart'
    as _i9;
import 'package:zenscrap_client/src/protocol/entities/scrappable/auto_fix/paginated_auto_fix_session_response.dart'
    as _i10;
import 'package:zenscrap_client/src/protocol/entities/account/api_usage/api_credit_history/paginated_api_credit_history_response.dart'
    as _i11;
import 'package:zenscrap_client/src/protocol/entities/account/account_api_key.dart'
    as _i12;
import 'package:zenscrap_client/src/protocol/entities/account/api_usage/account_api_usage.dart'
    as _i13;
import 'package:zenscrap_client/src/protocol/entities/api_key_response.dart'
    as _i14;
import 'package:zenscrap_client/src/protocol/entities/account/credit_purchase_option.dart'
    as _i15;
import 'package:zenscrap_client/src/protocol/entities/scrappable/scrappable.dart'
    as _i16;
import 'package:zenscrap_client/src/protocol/entities/analytics/paginated_scrappable_requests_analytics.dart'
    as _i17;
import 'package:zenscrap_client/src/protocol/entities/analytics/analytics_time_scope.dart'
    as _i18;
import 'package:zenscrap_client/src/protocol/entities/analytics/paginated_scrappable_analytics.dart'
    as _i19;
import 'package:zenscrap_client/src/protocol/entities/analytics/scrappable_usage_metrics.dart'
    as _i20;
import 'package:zenscrap_client/src/protocol/entities/user_scrappables/user_paginated_scrappable_response.dart'
    as _i21;
import 'package:zenscrap_client/src/protocol/entities/scrappable/scraper_category.dart'
    as _i22;
import 'package:zenscrap_client/src/protocol/entities/create_scrappable_stream/create_scrappable_stream_item.dart'
    as _i23;
import 'package:zenscrap_client/src/protocol/entities/scrappable/ai_model.dart'
    as _i24;
import 'package:zenscrap_client/src/protocol/entities/marketplace/paginated_scrappable_response.dart'
    as _i25;
import 'package:zenscrap_client/src/protocol/entities/scrappable/byte_test_data.dart'
    as _i26;
import 'package:zenscrap_client/src/protocol/entities/account/plan_tier.dart'
    as _i27;
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/create_session_response.dart'
    as _i28;
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/chat_response.dart'
    as _i29;
import 'protocol.dart' as _i30;

/// Email Identity Provider Endpoint
/// Exposes email/password authentication endpoints for the client
/// Handles registration, login, password reset, and email verification
/// Required by Serverpod 3.1 IDP authentication system
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );
}

/// Google Identity Provider Endpoint
/// Exposes Google OAuth authentication endpoints for the client
/// Required by Serverpod 3.1 IDP authentication system
/// {@category Endpoint}
class EndpointGoogleIdp extends _i1.EndpointGoogleIdpBase {
  EndpointGoogleIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'googleIdp';

  /// Validates a Google ID token and either logs in the associated user or
  /// creates a new user account if the Google account ID is not yet known.
  ///
  /// If a new user is created an associated [UserProfile] is also created.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'googleIdp',
    'login',
    {
      'idToken': idToken,
      'accessToken': accessToken,
    },
  );
}

/// Refresh JWT Tokens Endpoint
/// Exposes JWT token refresh endpoint for the client
/// Required by Serverpod 3.1 IDP authentication system for token management
/// {@category Endpoint}
class EndpointRefreshJwtTokens extends _i4.EndpointRefreshJwtTokens {
  EndpointRefreshJwtTokens(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'refreshJwtTokens';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'refreshJwtTokens',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// Endpoint for retrieving authenticated user's profile information.
/// This endpoint requires the user to be logged in and returns their
/// profile details including email, name, and profile image URL.
/// {@category Endpoint}
class EndpointUserProfile extends _i2.EndpointRef {
  EndpointUserProfile(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userProfile';

  /// Returns the current authenticated user's profile information.
  ///
  /// This method retrieves the user profile from the authentication system
  /// after a successful login (e.g., Google OAuth, email/password).
  ///
  /// Returns a [UserProfileResponse] containing:
  /// - email: The user's email address
  /// - fullName: The user's full name (if available)
  /// - userName: The user's display name
  /// - imageUrl: URL to the user's profile image (if available)
  ///
  /// Throws a [ZenScrapException] if the user is not authenticated
  /// or if the profile cannot be retrieved.
  _i3.Future<_i5.UserProfileResponse> getCurrentUserProfile() =>
      caller.callServerEndpoint<_i5.UserProfileResponse>(
        'userProfile',
        'getCurrentUserProfile',
        {},
      );
}

/// {@category Endpoint}
class EndpointPrivateAccount extends _i2.EndpointRef {
  EndpointPrivateAccount(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateAccount';

  _i3.Future<_i6.AccountInfo> getAccountInfo({
    required int? initialScrappableId,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i6.AccountInfo>(
    'privateAccount',
    'getAccountInfo',
    {
      'initialScrappableId': initialScrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPrivateAiUsage extends _i2.EndpointRef {
  EndpointPrivateAiUsage(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateAiUsage';

  /// Returns paginated AI credit history for the authenticated user.
  _i3.Future<_i8.PaginatedAICreditHistoryResponse> getAiCreditHistory({
    required int page,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i8.PaginatedAICreditHistoryResponse>(
    'privateAiUsage',
    'getAiCreditHistory',
    {
      'page': page,
      'language': language,
    },
  );

  /// Returns the AI usage info for the authenticated user.
  _i3.Future<_i9.AccountAIUsage> getAiUsageInfo({
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i9.AccountAIUsage>(
    'privateAiUsage',
    'getAiUsageInfo',
    {'language': language},
  );

  /// Updates the user's OpenAI API key.
  /// Pass null or empty string to remove the API key.
  /// The key is validated against OpenAI's API before being saved.
  _i3.Future<_i9.AccountAIUsage> updateOpenAiApiKey({
    String? apiKey,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i9.AccountAIUsage>(
    'privateAiUsage',
    'updateOpenAiApiKey',
    {
      'apiKey': apiKey,
      'language': language,
    },
  );

  /// Returns paginated auto-fix sessions for scrappables owned by the authenticated user.
  ///
  /// This includes all auto-fix repair attempts across all of the user's scrappables,
  /// ordered by most recent first.
  _i3.Future<_i10.PaginatedAutoFixSessionResponse> getAutoFixSessions({
    required int page,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i10.PaginatedAutoFixSessionResponse>(
    'privateAiUsage',
    'getAutoFixSessions',
    {
      'page': page,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPrivateApiUsage extends _i2.EndpointRef {
  EndpointPrivateApiUsage(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateApiUsage';

  _i3.Future<_i11.PaginatedApiCreditHistoryResponse> getApiCreditHistory({
    required int page,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i11.PaginatedApiCreditHistoryResponse>(
    'privateApiUsage',
    'getApiCreditHistory',
    {
      'page': page,
      'language': language,
    },
  );

  _i3.Future<_i12.AccountApiKey> createApiKey({
    required String name,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i12.AccountApiKey>(
    'privateApiUsage',
    'createApiKey',
    {
      'name': name,
      'language': language,
    },
  );

  _i3.Future<bool> deactivateApiKey({
    required int apiKeyId,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<bool>(
    'privateApiUsage',
    'deactivateApiKey',
    {
      'apiKeyId': apiKeyId,
      'language': language,
    },
  );

  _i3.Future<List<_i12.AccountApiKey>> getActiveApiKeys({
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<List<_i12.AccountApiKey>>(
    'privateApiUsage',
    'getActiveApiKeys',
    {'language': language},
  );

  _i3.Future<Map<int, int>> getApiKeyUsageStats({
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<Map<int, int>>(
    'privateApiUsage',
    'getApiKeyUsageStats',
    {'language': language},
  );

  _i3.Future<_i13.AccountApiUsage> getApiUsageInfo({
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i13.AccountApiUsage>(
    'privateApiUsage',
    'getApiUsageInfo',
    {'language': language},
  );

  _i3.Future<_i14.ApiKeyResponse> getApiKeysWithStats({
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i14.ApiKeyResponse>(
    'privateApiUsage',
    'getApiKeysWithStats',
    {'language': language},
  );

  _i3.Future<String> createCreditPurchaseCheckout({
    required _i15.CreditPurchaseOption creditPackage,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<String>(
    'privateApiUsage',
    'createCreditPurchaseCheckout',
    {
      'creditPackage': creditPackage,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPrivateCloneScrappable extends _i2.EndpointRef {
  EndpointPrivateCloneScrappable(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateCloneScrappable';

  _i3.Future<_i16.Scrappable> cloneFromMarketplace({
    required int scrappableId,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i16.Scrappable>(
    'privateCloneScrappable',
    'cloneFromMarketplace',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPrivateScrappableAnalytics extends _i2.EndpointRef {
  EndpointPrivateScrappableAnalytics(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateScrappableAnalytics';

  _i3.Future<_i17.PaginatedScrappableRequestsAnalytics>
  getScrappableAnalyticsWithScope({
    required int page,
    required _i18.AnalyticsTimeScope scope,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i17.PaginatedScrappableRequestsAnalytics>(
    'privateScrappableAnalytics',
    'getScrappableAnalyticsWithScope',
    {
      'page': page,
      'scope': scope,
      'language': language,
    },
  );

  _i3.Future<_i19.PaginatedScrappableAnalytics> getScrappableAnalytics({
    required int scrappableId,
    required int page,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i19.PaginatedScrappableAnalytics>(
    'privateScrappableAnalytics',
    'getScrappableAnalytics',
    {
      'scrappableId': scrappableId,
      'page': page,
      'language': language,
    },
  );

  /// Get usage metrics for a scrappable in the last 30 days
  /// This includes ALL requests from ANY user who called this scrappable
  _i3.Future<_i20.ScrappableUsageMetrics> getScrappableUsageMetrics({
    required int scrappableId,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i20.ScrappableUsageMetrics>(
    'privateScrappableAnalytics',
    'getScrappableUsageMetrics',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPrivateSubscription extends _i2.EndpointRef {
  EndpointPrivateSubscription(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateSubscription';

  /// Syncs subscription status from Stripe using the user's email.
  /// This is useful when webhook delivery failed or user wants to manually refresh.
  _i3.Future<_i6.AccountInfo> syncSubscriptionFromStripe({
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i6.AccountInfo>(
    'privateSubscription',
    'syncSubscriptionFromStripe',
    {'language': language},
  );

  _i3.Future<String> createCheckoutSession({
    required String planTier,
    required bool isYearly,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<String>(
    'privateSubscription',
    'createCheckoutSession',
    {
      'planTier': planTier,
      'isYearly': isYearly,
      'language': language,
    },
  );

  _i3.Future<Map<String, dynamic>> getSubscriptionStatus({
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'privateSubscription',
    'getSubscriptionStatus',
    {'language': language},
  );

  _i3.Future<bool> cancelSubscription({
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<bool>(
    'privateSubscription',
    'cancelSubscription',
    {'language': language},
  );

  _i3.Future<String> createCustomerPortalSession({
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<String>(
    'privateSubscription',
    'createCustomerPortalSession',
    {'language': language},
  );
}

/// {@category Endpoint}
class EndpointPrivateUserScrappables extends _i2.EndpointRef {
  EndpointPrivateUserScrappables(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateUserScrappables';

  _i3.Future<_i21.UserPaginatedScrappableResponse> call({
    required int page,
    String? searchQuery,
    List<_i22.ScraperCategory>? categories,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i21.UserPaginatedScrappableResponse>(
    'privateUserScrappables',
    'call',
    {
      'page': page,
      'searchQuery': searchQuery,
      'categories': categories,
      'language': language,
    },
  );

  _i3.Future<_i16.Scrappable> getScrappableById(
    int scrappableId, {
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i16.Scrappable>(
    'privateUserScrappables',
    'getScrappableById',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointCreateScrappable extends _i2.EndpointRef {
  EndpointCreateScrappable(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'createScrappable';

  _i3.Stream<_i23.CreateScrappableStreamItem> call({
    required String referenceLink,
    required _i7.SupportedLanguage language,
  }) =>
      caller.callStreamingServerEndpoint<
        _i3.Stream<_i23.CreateScrappableStreamItem>,
        _i23.CreateScrappableStreamItem
      >(
        'createScrappable',
        'call',
        {
          'referenceLink': referenceLink,
          'language': language,
        },
        {},
      );
}

/// {@category Endpoint}
class EndpointDeleteScrappable extends _i2.EndpointRef {
  EndpointDeleteScrappable(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'deleteScrappable';

  _i3.Future<bool> call({
    required int scrappableId,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<bool>(
    'deleteScrappable',
    'call',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointEditScrappable extends _i2.EndpointRef {
  EndpointEditScrappable(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'editScrappable';

  _i3.Future<bool> call({
    required int scrappableId,
    required String name,
    required String description,
    required _i7.SupportedLanguage language,
    _i22.ScraperCategory? category,
    bool? willHideFromMarketplace,
    bool? autoFixEnabled,
    int? autoFixConsecutiveErrorThreshold,
    _i24.AiModel? autoFixPreferredAiModel,
    bool? autoFixUseAutoAiModel,
  }) => caller.callServerEndpoint<bool>(
    'editScrappable',
    'call',
    {
      'scrappableId': scrappableId,
      'name': name,
      'description': description,
      'language': language,
      'category': category,
      'willHideFromMarketplace': willHideFromMarketplace,
      'autoFixEnabled': autoFixEnabled,
      'autoFixConsecutiveErrorThreshold': autoFixConsecutiveErrorThreshold,
      'autoFixPreferredAiModel': autoFixPreferredAiModel,
      'autoFixUseAutoAiModel': autoFixUseAutoAiModel,
    },
  );
}

/// {@category Endpoint}
class EndpointMarketplace extends _i2.EndpointRef {
  EndpointMarketplace(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'marketplace';

  _i3.Future<_i25.PaginatedScrappableResponse> getItems({
    required int page,
    String? searchQuery,
    List<_i22.ScraperCategory>? categories,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i25.PaginatedScrappableResponse>(
    'marketplace',
    'getItems',
    {
      'page': page,
      'searchQuery': searchQuery,
      'categories': categories,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPublicScrappable extends _i2.EndpointRef {
  EndpointPublicScrappable(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'publicScrappable';

  /// Retrieves ByteTestData for a scrappable
  /// This is a public endpoint to allow viewing test data in the marketplace
  _i3.Future<_i26.ByteTestData?> getByteTestData(
    int scrappableId, {
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i26.ByteTestData?>(
    'publicScrappable',
    'getByteTestData',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPublicTier extends _i2.EndpointRef {
  EndpointPublicTier(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'publicTier';

  _i3.Future<void> updatePlayerTier({
    required String email,
    required String tierManipulationKey,
    required _i27.PlanTier planTier,
  }) => caller.callServerEndpoint<void>(
    'publicTier',
    'updatePlayerTier',
    {
      'email': email,
      'tierManipulationKey': tierManipulationKey,
      'planTier': planTier,
    },
  );
}

/// {@category Endpoint}
class EndpointScrappableChatSession extends _i2.EndpointRef {
  EndpointScrappableChatSession(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scrappableChatSession';

  _i3.Future<void> commitCurrentEditState({
    required String sessionUuid,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<void>(
    'scrappableChatSession',
    'commitCurrentEditState',
    {
      'sessionUuid': sessionUuid,
      'language': language,
    },
  );

  _i3.Future<void> disposeSession({required String sessionId}) =>
      caller.callServerEndpoint<void>(
        'scrappableChatSession',
        'disposeSession',
        {'sessionId': sessionId},
      );

  /// Updates the user's OpenAI API key for the current session.
  ///
  /// This endpoint is called when a user wants to add their own API key
  /// after receiving a [CreditLimitReachedResponse] (platform credits exhausted).
  ///
  /// The API key is:
  /// 1. Stored in the in-memory [_sessionAccountAIUsage] map
  /// 2. Persisted to the database when the session ends
  /// 3. Used for subsequent API calls in this session (no credits deducted)
  ///
  /// Returns success and sends an [ApiKeyUpdatedResponse] to the chat stream.
  _i3.Future<void> updateUserApiKey({
    required String sessionId,
    required String openAiApiKey,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<void>(
    'scrappableChatSession',
    'updateUserApiKey',
    {
      'sessionId': sessionId,
      'openAiApiKey': openAiApiKey,
      'language': language,
    },
  );

  _i3.Future<void> updateScrappableRequest({
    required int scrappableId,
    required String url,
    required List<String> pathParams,
    required Map<String, String?> queryParams,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<void>(
    'scrappableChatSession',
    'updateScrappableRequest',
    {
      'scrappableId': scrappableId,
      'url': url,
      'pathParams': pathParams,
      'queryParams': queryParams,
      'language': language,
    },
  );

  _i3.Future<_i28.CreateSessionResponse> createSession({
    required int scrappableId,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i28.CreateSessionResponse>(
    'scrappableChatSession',
    'createSession',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );

  _i3.Stream<_i29.ChatResponse> listenToScrappableRedraftSession({
    required String sessionUuid,
    required _i7.SupportedLanguage language,
  }) =>
      caller.callStreamingServerEndpoint<
        _i3.Stream<_i29.ChatResponse>,
        _i29.ChatResponse
      >(
        'scrappableChatSession',
        'listenToScrappableRedraftSession',
        {
          'sessionUuid': sessionUuid,
          'language': language,
        },
        {},
      );

  _i3.Future<void> changeChatModel({
    required String sessionUuid,
    required _i24.AiModel aiModel,
    required _i7.SupportedLanguage language,
  }) => caller.callServerEndpoint<void>(
    'scrappableChatSession',
    'changeChatModel',
    {
      'sessionUuid': sessionUuid,
      'aiModel': aiModel,
      'language': language,
    },
  );

  _i3.Stream<String> sendPromptMessage({
    required String sessionId,
    required String userPrompt,
    required _i7.SupportedLanguage language,
  }) => caller.callStreamingServerEndpoint<_i3.Stream<String>, String>(
    'scrappableChatSession',
    'sendPromptMessage',
    {
      'sessionId': sessionId,
      'userPrompt': userPrompt,
      'language': language,
    },
    {},
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i30.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    googleIdp = EndpointGoogleIdp(this);
    refreshJwtTokens = EndpointRefreshJwtTokens(this);
    userProfile = EndpointUserProfile(this);
    privateAccount = EndpointPrivateAccount(this);
    privateAiUsage = EndpointPrivateAiUsage(this);
    privateApiUsage = EndpointPrivateApiUsage(this);
    privateCloneScrappable = EndpointPrivateCloneScrappable(this);
    privateScrappableAnalytics = EndpointPrivateScrappableAnalytics(this);
    privateSubscription = EndpointPrivateSubscription(this);
    privateUserScrappables = EndpointPrivateUserScrappables(this);
    createScrappable = EndpointCreateScrappable(this);
    deleteScrappable = EndpointDeleteScrappable(this);
    editScrappable = EndpointEditScrappable(this);
    marketplace = EndpointMarketplace(this);
    publicScrappable = EndpointPublicScrappable(this);
    publicTier = EndpointPublicTier(this);
    scrappableChatSession = EndpointScrappableChatSession(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointGoogleIdp googleIdp;

  late final EndpointRefreshJwtTokens refreshJwtTokens;

  late final EndpointUserProfile userProfile;

  late final EndpointPrivateAccount privateAccount;

  late final EndpointPrivateAiUsage privateAiUsage;

  late final EndpointPrivateApiUsage privateApiUsage;

  late final EndpointPrivateCloneScrappable privateCloneScrappable;

  late final EndpointPrivateScrappableAnalytics privateScrappableAnalytics;

  late final EndpointPrivateSubscription privateSubscription;

  late final EndpointPrivateUserScrappables privateUserScrappables;

  late final EndpointCreateScrappable createScrappable;

  late final EndpointDeleteScrappable deleteScrappable;

  late final EndpointEditScrappable editScrappable;

  late final EndpointMarketplace marketplace;

  late final EndpointPublicScrappable publicScrappable;

  late final EndpointPublicTier publicTier;

  late final EndpointScrappableChatSession scrappableChatSession;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'googleIdp': googleIdp,
    'refreshJwtTokens': refreshJwtTokens,
    'userProfile': userProfile,
    'privateAccount': privateAccount,
    'privateAiUsage': privateAiUsage,
    'privateApiUsage': privateApiUsage,
    'privateCloneScrappable': privateCloneScrappable,
    'privateScrappableAnalytics': privateScrappableAnalytics,
    'privateSubscription': privateSubscription,
    'privateUserScrappables': privateUserScrappables,
    'createScrappable': createScrappable,
    'deleteScrappable': deleteScrappable,
    'editScrappable': editScrappable,
    'marketplace': marketplace,
    'publicScrappable': publicScrappable,
    'publicTier': publicTier,
    'scrappableChatSession': scrappableChatSession,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'auth_core': modules.auth_core,
  };
}
