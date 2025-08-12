/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/private/private_account_endpoint.dart' as _i2;
import '../endpoints/public/create_scrap_chat_session.dart' as _i3;
import '../endpoints/public/handle_api_scrap_request.dart' as _i4;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i5;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'privateAccount': _i2.PrivateAccountEndpoint()
        ..initialize(
          server,
          'privateAccount',
          null,
        ),
      'createScrapChatSession': _i3.CreateScrapChatSessionEndpoint()
        ..initialize(
          server,
          'createScrapChatSession',
          null,
        ),
      'handleApiScrapRequest': _i4.HandleApiScrapRequestEndpoint()
        ..initialize(
          server,
          'handleApiScrapRequest',
          null,
        ),
    };
    connectors['privateAccount'] = _i1.EndpointConnector(
      name: 'privateAccount',
      endpoint: endpoints['privateAccount']!,
      methodConnectors: {
        'getAccountInfo': _i1.MethodConnector(
          name: 'getAccountInfo',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateAccount'] as _i2.PrivateAccountEndpoint)
                  .getAccountInfo(session),
        )
      },
    );
    connectors['createScrapChatSession'] = _i1.EndpointConnector(
      name: 'createScrapChatSession',
      endpoint: endpoints['createScrapChatSession']!,
      methodConnectors: {
        'call': _i1.MethodConnector(
          name: 'call',
          params: {
            'targetUrl': _i1.ParameterDescription(
              name: 'targetUrl',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'userPrompt': _i1.ParameterDescription(
              name: 'userPrompt',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['createScrapChatSession']
                      as _i3.CreateScrapChatSessionEndpoint)
                  .call(
            session,
            targetUrl: params['targetUrl'],
            userPrompt: params['userPrompt'],
          ),
        ),
        'createSession': _i1.MethodConnector(
          name: 'createSession',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['createScrapChatSession']
                      as _i3.CreateScrapChatSessionEndpoint)
                  .createSession(session),
        ),
      },
    );
    connectors['handleApiScrapRequest'] = _i1.EndpointConnector(
      name: 'handleApiScrapRequest',
      endpoint: endpoints['handleApiScrapRequest']!,
      methodConnectors: {
        'call': _i1.MethodConnector(
          name: 'call',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'payload': _i1.ParameterDescription(
              name: 'payload',
              type: _i1.getType<Map<String, dynamic>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['handleApiScrapRequest']
                      as _i4.HandleApiScrapRequestEndpoint)
                  .call(
            session,
            scrappableId: params['scrappableId'],
            payload: params['payload'],
          ),
        )
      },
    );
    modules['serverpod_auth'] = _i5.Endpoints()..initializeEndpoints(server);
  }
}
