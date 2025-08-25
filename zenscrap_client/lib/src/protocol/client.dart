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
import 'package:zenscrap_client/src/protocol/entities/marketplace/paginated_scrappable_response.dart'
    as _i9;
import 'package:zenscrap_client/src/protocol/entities/account/plan_tier.dart'
    as _i10;
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/create_session_response.dart'
    as _i11;
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/chat_response.dart'
    as _i12;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i13;
import 'protocol.dart' as _i14;

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
class EndpointMarketplace extends _i1.EndpointRef {
  EndpointMarketplace(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'marketplace';

  _i2.Future<_i9.PaginatedScrappableResponse> getItems({
    required int page,
    required int pageSize,
    String? searchQuery,
  }) =>
      caller.callServerEndpoint<_i9.PaginatedScrappableResponse>(
        'marketplace',
        'getItems',
        {
          'page': page,
          'pageSize': pageSize,
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
    required _i10.PlanTier planTier,
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

  _i2.Future<_i11.CreateSessionResponse> createSession(
          {required _i4.Scrappable scrappable}) =>
      caller.callServerEndpoint<_i11.CreateSessionResponse>(
        'scrappableChatSession',
        'createSession',
        {'scrappable': scrappable},
      );

  _i2.Stream<_i12.ChatResponse> listenToScrappableRedraftSession(
          {required String sessionUuid}) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i12.ChatResponse>,
          _i12.ChatResponse>(
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
    auth = _i13.Caller(client);
  }

  late final _i13.Caller auth;
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
          _i14.Protocol(),
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
    privateSubscription = EndpointPrivateSubscription(this);
    privateUserScrappables = EndpointPrivateUserScrappables(this);
    createScrappable = EndpointCreateScrappable(this);
    marketplace = EndpointMarketplace(this);
    publicTier = EndpointPublicTier(this);
    scrappableApi = EndpointScrappableApi(this);
    scrappableChatSession = EndpointScrappableChatSession(this);
    modules = Modules(this);
  }

  late final EndpointPrivateAccount privateAccount;

  late final EndpointPrivateApiUsage privateApiUsage;

  late final EndpointPrivateCloneScrappable privateCloneScrappable;

  late final EndpointPrivateSubscription privateSubscription;

  late final EndpointPrivateUserScrappables privateUserScrappables;

  late final EndpointCreateScrappable createScrappable;

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
        'privateSubscription': privateSubscription,
        'privateUserScrappables': privateUserScrappables,
        'createScrappable': createScrappable,
        'marketplace': marketplace,
        'publicTier': publicTier,
        'scrappableApi': scrappableApi,
        'scrappableChatSession': scrappableChatSession,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
