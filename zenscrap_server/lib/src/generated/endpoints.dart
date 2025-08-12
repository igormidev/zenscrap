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
import '../endpoints/public/create_scrap_chat_session.dart' as _i2;
import '../endpoints/public/handle_api_scrap_request.dart' as _i3;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'createScrapChatSession': _i2.CreateScrapChatSessionEndpoint()
        ..initialize(
          server,
          'createScrapChatSession',
          null,
        ),
      'handleApiScrapRequest': _i3.HandleApiScrapRequestEndpoint()
        ..initialize(
          server,
          'handleApiScrapRequest',
          null,
        ),
    };
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
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['createScrapChatSession']
                      as _i2.CreateScrapChatSessionEndpoint)
                  .call(
            session,
            targetUrl: params['targetUrl'],
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
                      as _i2.CreateScrapChatSessionEndpoint)
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
                      as _i3.HandleApiScrapRequestEndpoint)
                  .call(
            session,
            scrappableId: params['scrappableId'],
            payload: params['payload'],
          ),
        )
      },
    );
  }
}
