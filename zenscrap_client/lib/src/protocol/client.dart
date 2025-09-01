/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:zenscrap_client/src/protocol/entities/account/account.dart'
    as _i3;
import 'package:zenscrap_client/src/protocol/entities/scrappable/scrappable.dart'
    as _i4;
import 'package:zenscrap_client/src/protocol/entities/account/api_usage/api_creadit_history/api_creadit_history_item.dart'
    as _i5;
import 'package:zenscrap_client/src/protocol/entities/account/account_api_key.dart'
    as _i6;
import 'package:zenscrap_client/src/protocol/entities/account/api_usage/account_api_usage.dart'
    as _i7;
import 'package:uuid/uuid_value.dart' as _i8;
import 'package:zenscrap_client/src/protocol/entities/analytics/paginated_scrappable_requests_analytics.dart'
    as _i9;
import 'package:zenscrap_client/src/protocol/entities/analytics/paginated_scrappable_analytics.dart'
    as _i10;
import 'package:zenscrap_client/src/protocol/entities/scrappable/reference_test_data.dart'
    as _i11;
import 'package:zenscrap_client/src/protocol/entities/scrappable/scraper_category.dart'
    as _i12;
import 'package:zenscrap_client/src/protocol/entities/marketplace/paginated_scrappable_response.dart'
    as _i13;
import 'package:zenscrap_client/src/protocol/entities/account/plan_tier.dart'
    as _i14;
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/create_session_response.dart'
    as _i15;
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/chat_response.dart'
    as _i16;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i17;
import 'protocol.dart' as _i18;

/// {@category Endpoint}
class EndpointPrivateAccount extends _i1.EndpointRef {
  EndpointPrivateAccount(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateAccount';

  _i2.Future<_i3.AccountInfo> getAccountInfo(
          {required _i4.Scrappable? initialScrappableIfNewUser}) =>
      caller.callServerEndpoint<_i3.AccountInfo>(
        'privateAccount',
        'getAccountInfo',
        {'initialScrappableIfNewUser': initialScrappableIfNewUser},
      );
}

/// {@category Endpoint}
class EndpointPrivateApiUsage extends _i1.EndpointRef {
  EndpointPrivateApiUsage(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateApiUsage';

  _i2.Future<List<_i5.CreditHistoryItem>> getCreditHistory({
    required int offset,
    required int limit,
  }) =>
      caller.callServerEndpoint<List<_i5.CreditHistoryItem>>(
        'privateApiUsage',
        'getCreditHistory',
        {
          'offset': offset,
          'limit': limit,
        },
      );

  _i2.Future<_i6.AccountApiKey> createApiKey({required String name}) =>
      caller.callServerEndpoint<_i6.AccountApiKey>(
        'privateApiUsage',
        'createApiKey',
        {'name': name},
      );

  _i2.Future<bool> deactivateApiKey({required int apiKeyId}) =>
      caller.callServerEndpoint<bool>(
        'privateApiUsage',
        'deactivateApiKey',
        {'apiKeyId': apiKeyId},
      );

  _i2.Future<List<_i6.AccountApiKey>> getActiveApiKeys() =>
      caller.callServerEndpoint<List<_i6.AccountApiKey>>(
        'privateApiUsage',
        'getActiveApiKeys',
        {},
      );

  _i2.Future<Map<int, int>> getApiKeyUsageStats() =>
      caller.callServerEndpoint<Map<int, int>>(
        'privateApiUsage',
        'getApiKeyUsageStats',
        {},
      );

  _i2.Future<_i7.AccountApiUsage> getApiUsageInfo() =>
      caller.callServerEndpoint<_i7.AccountApiUsage>(
        'privateApiUsage',
        'getApiUsageInfo',
        {},
      );
}

/// {@category Endpoint}
class EndpointPrivateCloneScrappable extends _i1.EndpointRef {
  EndpointPrivateCloneScrappable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateCloneScrappable';

  _i2.Future<_i4.Scrappable> cloneFromMarketplace(
          {required _i8.UuidValue scrappableId}) =>
      caller.callServerEndpoint<_i4.Scrappable>(
        'privateCloneScrappable',
        'cloneFromMarketplace',
        {'scrappableId': scrappableId},
      );
}

/// {@category Endpoint}
class EndpointPrivateScrappableAnalytics extends _i1.EndpointRef {
  EndpointPrivateScrappableAnalytics(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateScrappableAnalytics';

  _i2.Future<_i9.PaginatedScrappableRequestsAnalytics>
      getScrappableAnalyticsOfTheLast12Hours({required int page}) =>
          caller.callServerEndpoint<_i9.PaginatedScrappableRequestsAnalytics>(
            'privateScrappableAnalytics',
            'getScrappableAnalyticsOfTheLast12Hours',
            {'page': page},
          );

  _i2.Future<_i10.PaginatedScrappableAnalytics> getScrappableAnalytics({
    required _i8.UuidValue scrappableId,
    required int page,
  }) =>
      caller.callServerEndpoint<_i10.PaginatedScrappableAnalytics>(
        'privateScrappableAnalytics',
        'getScrappableAnalytics',
        {
          'scrappableId': scrappableId,
          'page': page,
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
  }) =>
      caller.callServerEndpoint<String>(
        'privateSubscription',
        'createCheckoutSession',
        {
          'planTier': planTier,
          'isYearly': isYearly,
        },
      );

  _i2.Future<Map<String, dynamic>> getSubscriptionStatus() =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'privateSubscription',
        'getSubscriptionStatus',
        {},
      );

  _i2.Future<bool> cancelSubscription() => caller.callServerEndpoint<bool>(
        'privateSubscription',
        'cancelSubscription',
        {},
      );

  _i2.Future<String> createCustomerPortalSession() =>
      caller.callServerEndpoint<String>(
        'privateSubscription',
        'createCustomerPortalSession',
        {},
      );
}

/// {@category Endpoint}
class EndpointPrivateUserScrappables extends _i1.EndpointRef {
  EndpointPrivateUserScrappables(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateUserScrappables';

  _i2.Future<List<_i4.Scrappable>> call() =>
      caller.callServerEndpoint<List<_i4.Scrappable>>(
        'privateUserScrappables',
        'call',
        {},
      );

  _i2.Future<_i4.Scrappable> getScrappableById(String scrappableId) =>
      caller.callServerEndpoint<_i4.Scrappable>(
        'privateUserScrappables',
        'getScrappableById',
        {'scrappableId': scrappableId},
      );
}

/// {@category Endpoint}
class EndpointCreateScrappable extends _i1.EndpointRef {
  EndpointCreateScrappable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'createScrappable';

  _i2.Future<_i4.Scrappable> call({required String referenceLink}) =>
      caller.callServerEndpoint<_i4.Scrappable>(
        'createScrappable',
        'call',
        {'referenceLink': referenceLink},
      );
}

/// {@category Endpoint}
class EndpointDeleteScrappable extends _i1.EndpointRef {
  EndpointDeleteScrappable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'deleteScrappable';

  _i2.Future<bool> call({required String scrappableId}) =>
      caller.callServerEndpoint<bool>(
        'deleteScrappable',
        'call',
        {'scrappableId': scrappableId},
      );
}

/// {@category Endpoint}
class EndpointDeployScrappable extends _i1.EndpointRef {
  EndpointDeployScrappable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'deployScrappable';

  _i2.Future<void> call({required _i11.ReferenceTestData testData}) =>
      caller.callServerEndpoint<void>(
        'deployScrappable',
        'call',
        {'testData': testData},
      );
}

/// {@category Endpoint}
class EndpointEditScrappable extends _i1.EndpointRef {
  EndpointEditScrappable(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'editScrappable';

  _i2.Future<bool> call({
    required String scrappableId,
    required String name,
    required String description,
    _i12.ScraperCategory? category,
    bool? willHideFromMarketplace,
  }) =>
      caller.callServerEndpoint<bool>(
        'editScrappable',
        'call',
        {
          'scrappableId': scrappableId,
          'name': name,
          'description': description,
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

  _i2.Future<_i13.PaginatedScrappableResponse> getItems({
    required int page,
    String? searchQuery,
  }) =>
      caller.callServerEndpoint<_i13.PaginatedScrappableResponse>(
        'marketplace',
        'getItems',
        {
          'page': page,
          'searchQuery': searchQuery,
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
    required _i14.PlanTier planTier,
  }) =>
      caller.callServerEndpoint<void>(
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
class EndpointScrappableApi extends _i1.EndpointRef {
  EndpointScrappableApi(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scrappableApi';

  _i2.Future<Map<String, dynamic>> prod({
    required String scrappableId,
    required String apiKey,
    required Map<String, dynamic> payload,
  }) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'scrappableApi',
        'prod',
        {
          'scrappableId': scrappableId,
          'apiKey': apiKey,
          'payload': payload,
        },
      );

  _i2.Future<Map<String, dynamic>> test({
    required String scrappableId,
    required Map<String, dynamic> payload,
  }) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'scrappableApi',
        'test',
        {
          'scrappableId': scrappableId,
          'payload': payload,
        },
      );
}

/// {@category Endpoint}
class EndpointScrappableChatSession extends _i1.EndpointRef {
  EndpointScrappableChatSession(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scrappableChatSession';

  _i2.Future<void> disposeSession({required String sessionId}) =>
      caller.callServerEndpoint<void>(
        'scrappableChatSession',
        'disposeSession',
        {'sessionId': sessionId},
      );

  _i2.Future<_i15.CreateSessionResponse> createSession(
          {required String scrappableId}) =>
      caller.callServerEndpoint<_i15.CreateSessionResponse>(
        'scrappableChatSession',
        'createSession',
        {'scrappableId': scrappableId},
      );

  _i2.Stream<_i16.ChatResponse> listenToScrappableRedraftSession(
          {required String sessionUuid}) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i16.ChatResponse>,
          _i16.ChatResponse>(
        'scrappableChatSession',
        'listenToScrappableRedraftSession',
        {'sessionUuid': sessionUuid},
        {},
      );

  _i2.Future<void> sendPromptMessage({
    required String sessionId,
    required String userPrompt,
  }) =>
      caller.callServerEndpoint<void>(
        'scrappableChatSession',
        'sendPromptMessage',
        {
          'sessionId': sessionId,
          'userPrompt': userPrompt,
        },
      );
}

class Modules {
  Modules(Client client) {
    auth = _i17.Caller(client);
  }

  late final _i17.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i18.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    privateAccount = EndpointPrivateAccount(this);
    privateApiUsage = EndpointPrivateApiUsage(this);
    privateCloneScrappable = EndpointPrivateCloneScrappable(this);
    privateScrappableAnalytics = EndpointPrivateScrappableAnalytics(this);
    privateSubscription = EndpointPrivateSubscription(this);
    privateUserScrappables = EndpointPrivateUserScrappables(this);
    createScrappable = EndpointCreateScrappable(this);
    deleteScrappable = EndpointDeleteScrappable(this);
    deployScrappable = EndpointDeployScrappable(this);
    editScrappable = EndpointEditScrappable(this);
    marketplace = EndpointMarketplace(this);
    publicTier = EndpointPublicTier(this);
    scrappableApi = EndpointScrappableApi(this);
    scrappableChatSession = EndpointScrappableChatSession(this);
    modules = Modules(this);
  }

  late final EndpointPrivateAccount privateAccount;

  late final EndpointPrivateApiUsage privateApiUsage;

  late final EndpointPrivateCloneScrappable privateCloneScrappable;

  late final EndpointPrivateScrappableAnalytics privateScrappableAnalytics;

  late final EndpointPrivateSubscription privateSubscription;

  late final EndpointPrivateUserScrappables privateUserScrappables;

  late final EndpointCreateScrappable createScrappable;

  late final EndpointDeleteScrappable deleteScrappable;

  late final EndpointDeployScrappable deployScrappable;

  late final EndpointEditScrappable editScrappable;

  late final EndpointMarketplace marketplace;

  late final EndpointPublicTier publicTier;

  late final EndpointScrappableApi scrappableApi;

  late final EndpointScrappableChatSession scrappableChatSession;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'privateAccount': privateAccount,
        'privateApiUsage': privateApiUsage,
        'privateCloneScrappable': privateCloneScrappable,
        'privateScrappableAnalytics': privateScrappableAnalytics,
        'privateSubscription': privateSubscription,
        'privateUserScrappables': privateUserScrappables,
        'createScrappable': createScrappable,
        'deleteScrappable': deleteScrappable,
        'deployScrappable': deployScrappable,
        'editScrappable': editScrappable,
        'marketplace': marketplace,
        'publicTier': publicTier,
        'scrappableApi': scrappableApi,
        'scrappableChatSession': scrappableChatSession,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
