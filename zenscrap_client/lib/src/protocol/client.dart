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
import 'package:zenscrap_client/src/protocol/entities/redraft_scrappable_session/zen_scrap_redraft_state.dart'
    as _i5;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i6;
import 'protocol.dart' as _i7;

/// {@category Endpoint}
class EndpointPrivateAccount extends _i1.EndpointRef {
  EndpointPrivateAccount(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'privateAccount';

  _i2.Future<_i3.AccountInfo> getAccountInfo() =>
      caller.callServerEndpoint<_i3.AccountInfo>(
        'privateAccount',
        'getAccountInfo',
        {},
      );
}

/// {@category Endpoint}
class EndpointCreateScrapChatSession extends _i1.EndpointRef {
  EndpointCreateScrapChatSession(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'createScrapChatSession';

  _i2.Future<_i4.Scrappable> call({
    required String targetUrl,
    required String userPrompt,
  }) =>
      caller.callServerEndpoint<_i4.Scrappable>(
        'createScrapChatSession',
        'call',
        {
          'targetUrl': targetUrl,
          'userPrompt': userPrompt,
        },
      );

  _i2.Future<void> createSession() => caller.callServerEndpoint<void>(
        'createScrapChatSession',
        'createSession',
        {},
      );
}

/// {@category Endpoint}
class EndpointHandleApiScrapRequest extends _i1.EndpointRef {
  EndpointHandleApiScrapRequest(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'handleApiScrapRequest';

  _i2.Future<Map<String, dynamic>> call({
    required int scrappableId,
    required Map<String, dynamic> payload,
  }) =>
      caller.callServerEndpoint<Map<String, dynamic>>(
        'handleApiScrapRequest',
        'call',
        {
          'scrappableId': scrappableId,
          'payload': payload,
        },
      );
}

/// {@category Endpoint}
class EndpointScrappableSession extends _i1.EndpointRef {
  EndpointScrappableSession(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'scrappableSession';

  _i2.Stream<_i5.ZenScrapRedraftState> listenToScrappableRedraftSession(
          {required String sessionUuid}) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i5.ZenScrapRedraftState>,
          _i5.ZenScrapRedraftState>(
        'scrappableSession',
        'listenToScrappableRedraftSession',
        {'sessionUuid': sessionUuid},
        {},
      );

  _i2.Future<void> sendRedraftPrompt({
    required String sessionUuid,
    required String prompt,
  }) =>
      caller.callServerEndpoint<void>(
        'scrappableSession',
        'sendRedraftPrompt',
        {
          'sessionUuid': sessionUuid,
          'prompt': prompt,
        },
      );

  _i2.Future<void> createPrompt({required _i4.Scrappable scrappable}) =>
      caller.callServerEndpoint<void>(
        'scrappableSession',
        'createPrompt',
        {'scrappable': scrappable},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i6.Caller(client);
  }

  late final _i6.Caller auth;
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
          _i7.Protocol(),
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
    createScrapChatSession = EndpointCreateScrapChatSession(this);
    handleApiScrapRequest = EndpointHandleApiScrapRequest(this);
    scrappableSession = EndpointScrappableSession(this);
    modules = Modules(this);
  }

  late final EndpointPrivateAccount privateAccount;

  late final EndpointCreateScrapChatSession createScrapChatSession;

  late final EndpointHandleApiScrapRequest handleApiScrapRequest;

  late final EndpointScrappableSession scrappableSession;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'privateAccount': privateAccount,
        'createScrapChatSession': createScrapChatSession,
        'handleApiScrapRequest': handleApiScrapRequest,
        'scrappableSession': scrappableSession,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
