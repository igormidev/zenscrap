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
import '../endpoints/private/private_api_usage_endpoint.dart' as _i3;
import '../endpoints/private/private_user_scrappables_endpoint.dart' as _i4;
import '../endpoints/public/create_scrappable.dart' as _i5;
import '../endpoints/public/handle_api_scrap_request.dart' as _i6;
import '../endpoints/public/marketplace_endpoint.dart' as _i7;
import '../endpoints/public/public_tier_endpoint.dart' as _i8;
import '../endpoints/public/scrappable_chat_session.dart' as _i9;
import 'package:zenscrap_server/src/generated/entities/scrappable/scrappable.dart'
    as _i10;
import 'package:zenscrap_server/src/generated/entities/account/plan_tier.dart'
    as _i11;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i12;

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
      'privateApiUsage': _i3.PrivateApiUsageEndpoint()
        ..initialize(
          server,
          'privateApiUsage',
          null,
        ),
      'privateUserScrappables': _i4.PrivateUserScrappablesEndpoint()
        ..initialize(
          server,
          'privateUserScrappables',
          null,
        ),
      'createScrappable': _i5.CreateScrappableEndpoint()
        ..initialize(
          server,
          'createScrappable',
          null,
        ),
      'handleApiScrapRequest': _i6.HandleApiScrapRequestEndpoint()
        ..initialize(
          server,
          'handleApiScrapRequest',
          null,
        ),
      'marketplace': _i7.MarketplaceEndpoint()
        ..initialize(
          server,
          'marketplace',
          null,
        ),
      'publicTier': _i8.PublicTierEndpoint()
        ..initialize(
          server,
          'publicTier',
          null,
        ),
      'scrappableChatSession': _i9.ScrappableChatSession()
        ..initialize(
          server,
          'scrappableChatSession',
          null,
        ),
    };
    connectors['privateAccount'] = _i1.EndpointConnector(
      name: 'privateAccount',
      endpoint: endpoints['privateAccount']!,
      methodConnectors: {
        'getAccountInfo': _i1.MethodConnector(
          name: 'getAccountInfo',
          params: {
            'initialScrappableIfNewUser': _i1.ParameterDescription(
              name: 'initialScrappableIfNewUser',
              type: _i1.getType<_i10.Scrappable?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateAccount'] as _i2.PrivateAccountEndpoint)
                  .getAccountInfo(
            session,
            initialScrappableIfNewUser: params['initialScrappableIfNewUser'],
          ),
        )
      },
    );
    connectors['privateApiUsage'] = _i1.EndpointConnector(
      name: 'privateApiUsage',
      endpoint: endpoints['privateApiUsage']!,
      methodConnectors: {
        'getUsageInfo': _i1.MethodConnector(
          name: 'getUsageInfo',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i3.PrivateApiUsageEndpoint)
                  .getUsageInfo(session),
        )
      },
    );
    connectors['privateUserScrappables'] = _i1.EndpointConnector(
      name: 'privateUserScrappables',
      endpoint: endpoints['privateUserScrappables']!,
      methodConnectors: {
        'call': _i1.MethodConnector(
          name: 'call',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateUserScrappables']
                      as _i4.PrivateUserScrappablesEndpoint)
                  .call(session),
        )
      },
    );
    connectors['createScrappable'] = _i1.EndpointConnector(
      name: 'createScrappable',
      endpoint: endpoints['createScrappable']!,
      methodConnectors: {
        'call': _i1.MethodConnector(
          name: 'call',
          params: {
            'referenceLink': _i1.ParameterDescription(
              name: 'referenceLink',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['createScrappable'] as _i5.CreateScrappableEndpoint)
                  .call(
            session,
            referenceLink: params['referenceLink'],
          ),
        )
      },
    );
    connectors['handleApiScrapRequest'] = _i1.EndpointConnector(
      name: 'handleApiScrapRequest',
      endpoint: endpoints['handleApiScrapRequest']!,
      methodConnectors: {
        'prod': _i1.MethodConnector(
          name: 'prod',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<String>(),
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
                      as _i6.HandleApiScrapRequestEndpoint)
                  .prod(
            session,
            scrappableId: params['scrappableId'],
            payload: params['payload'],
          ),
        ),
        'test': _i1.MethodConnector(
          name: 'test',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<String>(),
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
                      as _i6.HandleApiScrapRequestEndpoint)
                  .test(
            session,
            scrappableId: params['scrappableId'],
            payload: params['payload'],
          ),
        ),
      },
    );
    connectors['marketplace'] = _i1.EndpointConnector(
      name: 'marketplace',
      endpoint: endpoints['marketplace']!,
      methodConnectors: {
        'getItems': _i1.MethodConnector(
          name: 'getItems',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['marketplace'] as _i7.MarketplaceEndpoint)
                  .getItems(session),
        )
      },
    );
    connectors['publicTier'] = _i1.EndpointConnector(
      name: 'publicTier',
      endpoint: endpoints['publicTier']!,
      methodConnectors: {
        'updatePlayerTier': _i1.MethodConnector(
          name: 'updatePlayerTier',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'tierManipulationKey': _i1.ParameterDescription(
              name: 'tierManipulationKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'planTier': _i1.ParameterDescription(
              name: 'planTier',
              type: _i1.getType<_i11.PlanTier>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['publicTier'] as _i8.PublicTierEndpoint)
                  .updatePlayerTier(
            session,
            email: params['email'],
            tierManipulationKey: params['tierManipulationKey'],
            planTier: params['planTier'],
          ),
        )
      },
    );
    connectors['scrappableChatSession'] = _i1.EndpointConnector(
      name: 'scrappableChatSession',
      endpoint: endpoints['scrappableChatSession']!,
      methodConnectors: {
        'createSession': _i1.MethodConnector(
          name: 'createSession',
          params: {
            'scrappable': _i1.ParameterDescription(
              name: 'scrappable',
              type: _i1.getType<_i10.Scrappable>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scrappableChatSession'] as _i9.ScrappableChatSession)
                  .createSession(
            session,
            scrappable: params['scrappable'],
          ),
        ),
        'sendPromptMessage': _i1.MethodConnector(
          name: 'sendPromptMessage',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
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
              (endpoints['scrappableChatSession'] as _i9.ScrappableChatSession)
                  .sendPromptMessage(
            session,
            sessionId: params['sessionId'],
            userPrompt: params['userPrompt'],
          ),
        ),
        'listenToScrappableRedraftSession': _i1.MethodStreamConnector(
          name: 'listenToScrappableRedraftSession',
          params: {
            'sessionUuid': _i1.ParameterDescription(
              name: 'sessionUuid',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['scrappableChatSession'] as _i9.ScrappableChatSession)
                  .listenToScrappableRedraftSession(
            session,
            sessionUuid: params['sessionUuid'],
          ),
        ),
      },
    );
    modules['serverpod_auth'] = _i12.Endpoints()..initializeEndpoints(server);
  }
}
