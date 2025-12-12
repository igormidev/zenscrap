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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:zenscrap_client/src/protocol/entities/account/account.dart'
    as _i3;
import 'package:zenscrap_client/src/protocol/entities/supported_language.dart'
    as _i4;
import 'package:zenscrap_client/src/protocol/entities/account/ai_usage/ai_credit_history/paginated_ai_credit_history_response.dart'
    as _i5;
import 'package:zenscrap_client/src/protocol/entities/account/ai_usage/account_ai_usage.dart'
    as _i6;
import 'package:zenscrap_client/src/protocol/entities/scrappable/auto_fix/paginated_auto_fix_session_response.dart'
    as _i7;
import 'package:zenscrap_client/src/protocol/entities/account/api_usage/api_credit_history/paginated_api_credit_history_response.dart'
    as _i8;
import 'package:zenscrap_client/src/protocol/entities/account/account_api_key.dart'
    as _i9;
import 'package:zenscrap_client/src/protocol/entities/account/api_usage/account_api_usage.dart'
    as _i10;
import 'package:zenscrap_client/src/protocol/entities/api_key_response.dart'
    as _i11;
import 'package:zenscrap_client/src/protocol/entities/account/credit_purchase_option.dart'
    as _i12;
import 'package:zenscrap_client/src/protocol/entities/scrappable/scrappable.dart'
    as _i13;
import 'package:zenscrap_client/src/protocol/entities/analytics/paginated_scrappable_requests_analytics.dart'
    as _i14;
import 'package:zenscrap_client/src/protocol/entities/analytics/analytics_time_scope.dart'
    as _i15;
import 'package:zenscrap_client/src/protocol/entities/analytics/paginated_scrappable_analytics.dart'
    as _i16;
import 'package:zenscrap_client/src/protocol/entities/analytics/scrappable_usage_metrics.dart'
    as _i17;
import 'package:zenscrap_client/src/protocol/entities/user_scrappables/user_paginated_scrappable_response.dart'
    as _i18;
import 'package:zenscrap_client/src/protocol/entities/scrappable/scraper_category.dart'
    as _i19;
import 'package:zenscrap_client/src/protocol/entities/create_scrappable_stream/create_scrappable_stream_item.dart'
    as _i20;
import 'package:zenscrap_client/src/protocol/entities/marketplace/paginated_scrappable_response.dart'
    as _i21;
import 'package:zenscrap_client/src/protocol/entities/scrappable/byte_test_data.dart'
    as _i22;
import 'package:zenscrap_client/src/protocol/entities/account/plan_tier.dart'
    as _i23;
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/create_session_response.dart'
    as _i24;
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/chat_response.dart'
    as _i25;
import 'package:zenscrap_client/src/protocol/entities/scrappable/ai_model.dart'
    as _i26;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i27;
import 'protocol.dart' as _i28;

/// {@category Endpoint}
class EndpointPrivateAccount extends _i1.EndpointRef {
  EndpointPrivateAccount(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateAccount';

  _i2.Future<_i3.AccountInfo> getAccountInfo({
    required int? initialScrappableId,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i3.AccountInfo>(
    'privateAccount',
    'getAccountInfo',
    {
      'initialScrappableId': initialScrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPrivateAiUsage extends _i1.EndpointRef {
  EndpointPrivateAiUsage(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateAiUsage';

  /// Returns paginated AI credit history for the authenticated user.
  _i2.Future<_i5.PaginatedAICreditHistoryResponse> getAiCreditHistory({
    required int page,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i5.PaginatedAICreditHistoryResponse>(
    'privateAiUsage',
    'getAiCreditHistory',
    {
      'page': page,
      'language': language,
    },
  );

  /// Returns the AI usage info for the authenticated user.
  _i2.Future<_i6.AccountAIUsage> getAiUsageInfo({
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i6.AccountAIUsage>(
    'privateAiUsage',
    'getAiUsageInfo',
    {'language': language},
  );

  /// Returns paginated auto-fix sessions for scrappables owned by the authenticated user.
  ///
  /// This includes all auto-fix repair attempts across all of the user's scrappables,
  /// ordered by most recent first.
  _i2.Future<_i7.PaginatedAutoFixSessionResponse> getAutoFixSessions({
    required int page,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i7.PaginatedAutoFixSessionResponse>(
    'privateAiUsage',
    'getAutoFixSessions',
    {
      'page': page,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPrivateApiUsage extends _i1.EndpointRef {
  EndpointPrivateApiUsage(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateApiUsage';

  _i2.Future<_i8.PaginatedApiCreditHistoryResponse> getApiCreditHistory({
    required int page,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i8.PaginatedApiCreditHistoryResponse>(
    'privateApiUsage',
    'getApiCreditHistory',
    {
      'page': page,
      'language': language,
    },
  );

  _i2.Future<_i9.AccountApiKey> createApiKey({
    required String name,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i9.AccountApiKey>(
    'privateApiUsage',
    'createApiKey',
    {
      'name': name,
      'language': language,
    },
  );

  _i2.Future<bool> deactivateApiKey({
    required int apiKeyId,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<bool>(
    'privateApiUsage',
    'deactivateApiKey',
    {
      'apiKeyId': apiKeyId,
      'language': language,
    },
  );

  _i2.Future<List<_i9.AccountApiKey>> getActiveApiKeys({
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<List<_i9.AccountApiKey>>(
    'privateApiUsage',
    'getActiveApiKeys',
    {'language': language},
  );

  _i2.Future<Map<int, int>> getApiKeyUsageStats({
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<Map<int, int>>(
    'privateApiUsage',
    'getApiKeyUsageStats',
    {'language': language},
  );

  _i2.Future<_i10.AccountApiUsage> getApiUsageInfo({
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i10.AccountApiUsage>(
    'privateApiUsage',
    'getApiUsageInfo',
    {'language': language},
  );

  _i2.Future<_i11.ApiKeyResponse> getApiKeysWithStats({
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i11.ApiKeyResponse>(
    'privateApiUsage',
    'getApiKeysWithStats',
    {'language': language},
  );

  _i2.Future<String> createCreditPurchaseCheckout({
    required _i12.CreditPurchaseOption creditPackage,
    required _i4.SupportedLanguage language,
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
class EndpointPrivateCloneScrappable extends _i1.EndpointRef {
  EndpointPrivateCloneScrappable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateCloneScrappable';

  _i2.Future<_i13.Scrappable> cloneFromMarketplace({
    required int scrappableId,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i13.Scrappable>(
    'privateCloneScrappable',
    'cloneFromMarketplace',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPrivateScrappableAnalytics extends _i1.EndpointRef {
  EndpointPrivateScrappableAnalytics(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateScrappableAnalytics';

  _i2.Future<_i14.PaginatedScrappableRequestsAnalytics>
  getScrappableAnalyticsWithScope({
    required int page,
    required _i15.AnalyticsTimeScope scope,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i14.PaginatedScrappableRequestsAnalytics>(
    'privateScrappableAnalytics',
    'getScrappableAnalyticsWithScope',
    {
      'page': page,
      'scope': scope,
      'language': language,
    },
  );

  _i2.Future<_i16.PaginatedScrappableAnalytics> getScrappableAnalytics({
    required int scrappableId,
    required int page,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i16.PaginatedScrappableAnalytics>(
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
  _i2.Future<_i17.ScrappableUsageMetrics> getScrappableUsageMetrics({
    required int scrappableId,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i17.ScrappableUsageMetrics>(
    'privateScrappableAnalytics',
    'getScrappableUsageMetrics',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPrivateSubscription extends _i1.EndpointRef {
  EndpointPrivateSubscription(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateSubscription';

  _i2.Future<String> createCheckoutSession({
    required String planTier,
    required bool isYearly,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<String>(
    'privateSubscription',
    'createCheckoutSession',
    {
      'planTier': planTier,
      'isYearly': isYearly,
      'language': language,
    },
  );

  _i2.Future<Map<String, dynamic>> getSubscriptionStatus({
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<Map<String, dynamic>>(
    'privateSubscription',
    'getSubscriptionStatus',
    {'language': language},
  );

  _i2.Future<bool> cancelSubscription({
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<bool>(
    'privateSubscription',
    'cancelSubscription',
    {'language': language},
  );

  _i2.Future<String> createCustomerPortalSession({
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<String>(
    'privateSubscription',
    'createCustomerPortalSession',
    {'language': language},
  );
}

/// {@category Endpoint}
class EndpointPrivateUserScrappables extends _i1.EndpointRef {
  EndpointPrivateUserScrappables(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateUserScrappables';

  _i2.Future<_i18.UserPaginatedScrappableResponse> call({
    required int page,
    String? searchQuery,
    List<_i19.ScraperCategory>? categories,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i18.UserPaginatedScrappableResponse>(
    'privateUserScrappables',
    'call',
    {
      'page': page,
      'searchQuery': searchQuery,
      'categories': categories,
      'language': language,
    },
  );

  _i2.Future<_i13.Scrappable> getScrappableById(
    int scrappableId, {
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i13.Scrappable>(
    'privateUserScrappables',
    'getScrappableById',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointCreateScrappable extends _i1.EndpointRef {
  EndpointCreateScrappable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'createScrappable';

  _i2.Stream<_i20.CreateScrappableStreamItem> call({
    required String referenceLink,
    required _i4.SupportedLanguage language,
  }) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i20.CreateScrappableStreamItem>,
        _i20.CreateScrappableStreamItem
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
class EndpointDeleteScrappable extends _i1.EndpointRef {
  EndpointDeleteScrappable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'deleteScrappable';

  _i2.Future<bool> call({
    required int scrappableId,
    required _i4.SupportedLanguage language,
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
class EndpointEditScrappable extends _i1.EndpointRef {
  EndpointEditScrappable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'editScrappable';

  _i2.Future<bool> call({
    required int scrappableId,
    required String name,
    required String description,
    required _i4.SupportedLanguage language,
    _i19.ScraperCategory? category,
    bool? willHideFromMarketplace,
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
    },
  );
}

/// {@category Endpoint}
class EndpointMarketplace extends _i1.EndpointRef {
  EndpointMarketplace(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'marketplace';

  _i2.Future<_i21.PaginatedScrappableResponse> getItems({
    required int page,
    String? searchQuery,
    List<_i19.ScraperCategory>? categories,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i21.PaginatedScrappableResponse>(
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
class EndpointPublicScrappable extends _i1.EndpointRef {
  EndpointPublicScrappable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'publicScrappable';

  /// Retrieves ByteTestData for a scrappable
  /// This is a public endpoint to allow viewing test data in the marketplace
  _i2.Future<_i22.ByteTestData?> getByteTestData(
    int scrappableId, {
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i22.ByteTestData?>(
    'publicScrappable',
    'getByteTestData',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );
}

/// {@category Endpoint}
class EndpointPublicTier extends _i1.EndpointRef {
  EndpointPublicTier(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'publicTier';

  _i2.Future<void> updatePlayerTier({
    required String email,
    required String tierManipulationKey,
    required _i23.PlanTier planTier,
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
class EndpointScrappableChatSession extends _i1.EndpointRef {
  EndpointScrappableChatSession(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scrappableChatSession';

  _i2.Future<void> commitCurrentEditState({
    required String sessionUuid,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<void>(
    'scrappableChatSession',
    'commitCurrentEditState',
    {
      'sessionUuid': sessionUuid,
      'language': language,
    },
  );

  _i2.Future<void> disposeSession({required String sessionId}) =>
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
  _i2.Future<void> updateUserApiKey({
    required String sessionId,
    required String openAiApiKey,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<void>(
    'scrappableChatSession',
    'updateUserApiKey',
    {
      'sessionId': sessionId,
      'openAiApiKey': openAiApiKey,
      'language': language,
    },
  );

  _i2.Future<void> updateScrappableRequest({
    required int scrappableId,
    required String url,
    required List<String> pathParams,
    required Map<String, String?> queryParams,
    required _i4.SupportedLanguage language,
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

  _i2.Future<_i24.CreateSessionResponse> createSession({
    required int scrappableId,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<_i24.CreateSessionResponse>(
    'scrappableChatSession',
    'createSession',
    {
      'scrappableId': scrappableId,
      'language': language,
    },
  );

  _i2.Stream<_i25.ChatResponse> listenToScrappableRedraftSession({
    required String sessionUuid,
    required _i4.SupportedLanguage language,
  }) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i25.ChatResponse>,
        _i25.ChatResponse
      >(
        'scrappableChatSession',
        'listenToScrappableRedraftSession',
        {
          'sessionUuid': sessionUuid,
          'language': language,
        },
        {},
      );

  _i2.Future<void> changeChatModel({
    required String sessionUuid,
    required _i26.AiModel aiModel,
    required _i4.SupportedLanguage language,
  }) => caller.callServerEndpoint<void>(
    'scrappableChatSession',
    'changeChatModel',
    {
      'sessionUuid': sessionUuid,
      'aiModel': aiModel,
      'language': language,
    },
  );

  _i2.Stream<String> sendPromptMessage({
    required String sessionId,
    required String userPrompt,
    required _i4.SupportedLanguage language,
  }) => caller.callStreamingServerEndpoint<_i2.Stream<String>, String>(
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
    auth = _i27.Caller(client);
  }

  late final _i27.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
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
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i28.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
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
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
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
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
  };
}
