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
import 'package:zenscrap_client/src/protocol/entities/account/plan_tier.dart'
    as _i5;
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/create_session_response.dart'
    as _i6;
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/chat_response.dart'
    as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
import 'protocol.dart' as _i9;

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
class EndpointHandleApiScrapRequest extends _i1.EndpointRef {
  EndpointHandleApiScrapRequest(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'handleApiScrapRequest';

  _i2.Future<Map<String, dynamic>> prod({
    required String scrappableId,
    required Map<String, dynamic> payload,
  }) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'handleApiScrapRequest',
        'prod',
        {
          'scrappableId': scrappableId,
          'payload': payload,
        },
      );

  _i2.Future<Map<String, dynamic>> test({
    required String scrappableId,
    required Map<String, dynamic> payload,
  }) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'handleApiScrapRequest',
        'test',
        {
          'scrappableId': scrappableId,
          'payload': payload,
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
    required _i5.PlanTier planTier,
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
class EndpointScrappableChatSession extends _i1.EndpointRef {
  EndpointScrappableChatSession(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scrappableChatSession';

  _i2.Future<_i6.CreateSessionResponse> createSession(
          {required _i4.Scrappable scrappable}) =>
      caller.callServerEndpoint<_i6.CreateSessionResponse>(
        'scrappableChatSession',
        'createSession',
        {'scrappable': scrappable},
      );

  _i2.Stream<_i7.ChatResponse> listenToScrappableRedraftSession(
          {required String sessionUuid}) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i7.ChatResponse>,
          _i7.ChatResponse>(
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
    auth = _i8.Caller(client);
  }

  late final _i8.Caller auth;
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
          _i9.Protocol(),
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
    privateUserScrappables = EndpointPrivateUserScrappables(this);
    createScrappable = EndpointCreateScrappable(this);
    handleApiScrapRequest = EndpointHandleApiScrapRequest(this);
    publicTier = EndpointPublicTier(this);
    scrappableChatSession = EndpointScrappableChatSession(this);
    modules = Modules(this);
  }

  late final EndpointPrivateAccount privateAccount;

  late final EndpointPrivateUserScrappables privateUserScrappables;

  late final EndpointCreateScrappable createScrappable;

  late final EndpointHandleApiScrapRequest handleApiScrapRequest;

  late final EndpointPublicTier publicTier;

  late final EndpointScrappableChatSession scrappableChatSession;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'privateAccount': privateAccount,
        'privateUserScrappables': privateUserScrappables,
        'createScrappable': createScrappable,
        'handleApiScrapRequest': handleApiScrapRequest,
        'publicTier': publicTier,
        'scrappableChatSession': scrappableChatSession,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
