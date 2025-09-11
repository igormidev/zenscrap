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
import '../endpoints/private/private_clone_scrappable_endpoint.dart' as _i4;
import '../endpoints/private/private_scrappable_analytics_endpoint.dart' as _i5;
import '../endpoints/private/private_subscription_endpoint.dart' as _i6;
import '../endpoints/private/private_user_scrappables_endpoint.dart' as _i7;
import '../endpoints/public/create_scrappable.dart' as _i8;
import '../endpoints/public/delete_scrappable_endpoint.dart' as _i9;
import '../endpoints/public/deploy_endpoint.dart' as _i10;
import '../endpoints/public/edit_scrappable_endpoint.dart' as _i11;
import '../endpoints/public/marketplace_endpoint.dart' as _i12;
import '../endpoints/public/public_tier_endpoint.dart' as _i13;
import '../endpoints/public/scrappable_api.dart' as _i14;
import '../endpoints/public/scrappable_chat_session.dart' as _i15;
import 'package:zenscrap_server/src/generated/entities/scrappable/scrappable.dart'
    as _i16;
import 'package:zenscrap_server/src/generated/entities/account/credit_purchase_option.dart'
    as _i17;
import 'package:zenscrap_server/src/generated/entities/scrappable/reference_test_data.dart'
    as _i18;
import 'package:zenscrap_server/src/generated/entities/scrappable/scrapping_bee_extract_logic.dart'
    as _i19;
import 'package:zenscrap_server/src/generated/entities/scrappable/scrappable_request.dart'
    as _i20;
import 'package:zenscrap_server/src/generated/entities/scrappable/scraper_category.dart'
    as _i21;
import 'package:zenscrap_server/src/generated/entities/account/plan_tier.dart'
    as _i22;
import 'package:zenscrap_server/src/generated/entities/scrappable/ai_model.dart'
    as _i23;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i24;

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
      'privateCloneScrappable': _i4.PrivateCloneScrappableEndpoint()
        ..initialize(
          server,
          'privateCloneScrappable',
          null,
        ),
      'privateScrappableAnalytics': _i5.PrivateScrappableAnalyticsEndpoint()
        ..initialize(
          server,
          'privateScrappableAnalytics',
          null,
        ),
      'privateSubscription': _i6.PrivateSubscriptionEndpoint()
        ..initialize(
          server,
          'privateSubscription',
          null,
        ),
      'privateUserScrappables': _i7.PrivateUserScrappablesEndpoint()
        ..initialize(
          server,
          'privateUserScrappables',
          null,
        ),
      'createScrappable': _i8.CreateScrappableEndpoint()
        ..initialize(
          server,
          'createScrappable',
          null,
        ),
      'deleteScrappable': _i9.DeleteScrappableEndpoint()
        ..initialize(
          server,
          'deleteScrappable',
          null,
        ),
      'deployScrappable': _i10.DeployScrappable()
        ..initialize(
          server,
          'deployScrappable',
          null,
        ),
      'editScrappable': _i11.EditScrappableEndpoint()
        ..initialize(
          server,
          'editScrappable',
          null,
        ),
      'marketplace': _i12.MarketplaceEndpoint()
        ..initialize(
          server,
          'marketplace',
          null,
        ),
      'publicTier': _i13.PublicTierEndpoint()
        ..initialize(
          server,
          'publicTier',
          null,
        ),
      'scrappableApi': _i14.ScrappableApiEndpoint()
        ..initialize(
          server,
          'scrappableApi',
          null,
        ),
      'scrappableChatSession': _i15.ScrappableChatSession()
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
              type: _i1.getType<_i16.Scrappable?>(),
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
        'getCreditHistory': _i1.MethodConnector(
          name: 'getCreditHistory',
          params: {
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i3.PrivateApiUsageEndpoint)
                  .getCreditHistory(
            session,
            offset: params['offset'],
            limit: params['limit'],
          ),
        ),
        'createApiKey': _i1.MethodConnector(
          name: 'createApiKey',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i3.PrivateApiUsageEndpoint)
                  .createApiKey(
            session,
            name: params['name'],
          ),
        ),
        'deactivateApiKey': _i1.MethodConnector(
          name: 'deactivateApiKey',
          params: {
            'apiKeyId': _i1.ParameterDescription(
              name: 'apiKeyId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i3.PrivateApiUsageEndpoint)
                  .deactivateApiKey(
            session,
            apiKeyId: params['apiKeyId'],
          ),
        ),
        'getActiveApiKeys': _i1.MethodConnector(
          name: 'getActiveApiKeys',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i3.PrivateApiUsageEndpoint)
                  .getActiveApiKeys(session),
        ),
        'getApiKeyUsageStats': _i1.MethodConnector(
          name: 'getApiKeyUsageStats',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i3.PrivateApiUsageEndpoint)
                  .getApiKeyUsageStats(session),
        ),
        'getApiUsageInfo': _i1.MethodConnector(
          name: 'getApiUsageInfo',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i3.PrivateApiUsageEndpoint)
                  .getApiUsageInfo(session),
        ),
        'getApiKeysWithStats': _i1.MethodConnector(
          name: 'getApiKeysWithStats',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i3.PrivateApiUsageEndpoint)
                  .getApiKeysWithStats(session),
        ),
        'createCreditPurchaseCheckout': _i1.MethodConnector(
          name: 'createCreditPurchaseCheckout',
          params: {
            'creditPackage': _i1.ParameterDescription(
              name: 'creditPackage',
              type: _i1.getType<_i17.CreditPurchaseOption>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i3.PrivateApiUsageEndpoint)
                  .createCreditPurchaseCheckout(
            session,
            creditPackage: params['creditPackage'],
          ),
        ),
      },
    );
    connectors['privateCloneScrappable'] = _i1.EndpointConnector(
      name: 'privateCloneScrappable',
      endpoint: endpoints['privateCloneScrappable']!,
      methodConnectors: {
        'cloneFromMarketplace': _i1.MethodConnector(
          name: 'cloneFromMarketplace',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateCloneScrappable']
                      as _i4.PrivateCloneScrappableEndpoint)
                  .cloneFromMarketplace(
            session,
            scrappableId: params['scrappableId'],
          ),
        )
      },
    );
    connectors['privateScrappableAnalytics'] = _i1.EndpointConnector(
      name: 'privateScrappableAnalytics',
      endpoint: endpoints['privateScrappableAnalytics']!,
      methodConnectors: {
        'getScrappableAnalyticsOfTheLast12Hours': _i1.MethodConnector(
          name: 'getScrappableAnalyticsOfTheLast12Hours',
          params: {
            'page': _i1.ParameterDescription(
              name: 'page',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateScrappableAnalytics']
                      as _i5.PrivateScrappableAnalyticsEndpoint)
                  .getScrappableAnalyticsOfTheLast12Hours(
            session,
            page: params['page'],
          ),
        ),
        'getScrappableAnalytics': _i1.MethodConnector(
          name: 'getScrappableAnalytics',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'page': _i1.ParameterDescription(
              name: 'page',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateScrappableAnalytics']
                      as _i5.PrivateScrappableAnalyticsEndpoint)
                  .getScrappableAnalytics(
            session,
            scrappableId: params['scrappableId'],
            page: params['page'],
          ),
        ),
      },
    );
    connectors['privateSubscription'] = _i1.EndpointConnector(
      name: 'privateSubscription',
      endpoint: endpoints['privateSubscription']!,
      methodConnectors: {
        'createCheckoutSession': _i1.MethodConnector(
          name: 'createCheckoutSession',
          params: {
            'planTier': _i1.ParameterDescription(
              name: 'planTier',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isYearly': _i1.ParameterDescription(
              name: 'isYearly',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateSubscription']
                      as _i6.PrivateSubscriptionEndpoint)
                  .createCheckoutSession(
            session,
            planTier: params['planTier'],
            isYearly: params['isYearly'],
          ),
        ),
        'getSubscriptionStatus': _i1.MethodConnector(
          name: 'getSubscriptionStatus',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateSubscription']
                      as _i6.PrivateSubscriptionEndpoint)
                  .getSubscriptionStatus(session),
        ),
        'cancelSubscription': _i1.MethodConnector(
          name: 'cancelSubscription',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateSubscription']
                      as _i6.PrivateSubscriptionEndpoint)
                  .cancelSubscription(session),
        ),
        'createCustomerPortalSession': _i1.MethodConnector(
          name: 'createCustomerPortalSession',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateSubscription']
                      as _i6.PrivateSubscriptionEndpoint)
                  .createCustomerPortalSession(session),
        ),
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
                      as _i7.PrivateUserScrappablesEndpoint)
                  .call(session),
        ),
        'getScrappableById': _i1.MethodConnector(
          name: 'getScrappableById',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateUserScrappables']
                      as _i7.PrivateUserScrappablesEndpoint)
                  .getScrappableById(
            session,
            params['scrappableId'],
          ),
        ),
      },
    );
    connectors['createScrappable'] = _i1.EndpointConnector(
      name: 'createScrappable',
      endpoint: endpoints['createScrappable']!,
      methodConnectors: {
        'call': _i1.MethodStreamConnector(
          name: 'call',
          params: {
            'referenceLink': _i1.ParameterDescription(
              name: 'referenceLink',
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
              (endpoints['createScrappable'] as _i8.CreateScrappableEndpoint)
                  .call(
            session,
            referenceLink: params['referenceLink'],
          ),
        )
      },
    );
    connectors['deleteScrappable'] = _i1.EndpointConnector(
      name: 'deleteScrappable',
      endpoint: endpoints['deleteScrappable']!,
      methodConnectors: {
        'call': _i1.MethodConnector(
          name: 'call',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['deleteScrappable'] as _i9.DeleteScrappableEndpoint)
                  .call(
            session,
            scrappableId: params['scrappableId'],
          ),
        )
      },
    );
    connectors['deployScrappable'] = _i1.EndpointConnector(
      name: 'deployScrappable',
      endpoint: endpoints['deployScrappable']!,
      methodConnectors: {
        'call': _i1.MethodConnector(
          name: 'call',
          params: {
            'testData': _i1.ParameterDescription(
              name: 'testData',
              type: _i1.getType<_i18.ReferenceTestData>(),
              nullable: false,
            ),
            'scrappingBeeExtractLogic': _i1.ParameterDescription(
              name: 'scrappingBeeExtractLogic',
              type: _i1.getType<_i19.ScrappingBeeExtractLogic>(),
              nullable: false,
            ),
            'scrappableRequest': _i1.ParameterDescription(
              name: 'scrappableRequest',
              type: _i1.getType<_i20.ScrappableRequest>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['deployScrappable'] as _i10.DeployScrappable).call(
            session,
            testData: params['testData'],
            scrappingBeeExtractLogic: params['scrappingBeeExtractLogic'],
            scrappableRequest: params['scrappableRequest'],
          ),
        )
      },
    );
    connectors['editScrappable'] = _i1.EndpointConnector(
      name: 'editScrappable',
      endpoint: endpoints['editScrappable']!,
      methodConnectors: {
        'call': _i1.MethodConnector(
          name: 'call',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i21.ScraperCategory?>(),
              nullable: true,
            ),
            'willHideFromMarketplace': _i1.ParameterDescription(
              name: 'willHideFromMarketplace',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['editScrappable'] as _i11.EditScrappableEndpoint).call(
            session,
            scrappableId: params['scrappableId'],
            name: params['name'],
            description: params['description'],
            category: params['category'],
            willHideFromMarketplace: params['willHideFromMarketplace'],
          ),
        )
      },
    );
    connectors['marketplace'] = _i1.EndpointConnector(
      name: 'marketplace',
      endpoint: endpoints['marketplace']!,
      methodConnectors: {
        'getItems': _i1.MethodConnector(
          name: 'getItems',
          params: {
            'page': _i1.ParameterDescription(
              name: 'page',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'searchQuery': _i1.ParameterDescription(
              name: 'searchQuery',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['marketplace'] as _i12.MarketplaceEndpoint).getItems(
            session,
            page: params['page'],
            searchQuery: params['searchQuery'],
          ),
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
              type: _i1.getType<_i22.PlanTier>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['publicTier'] as _i13.PublicTierEndpoint)
                  .updatePlayerTier(
            session,
            email: params['email'],
            tierManipulationKey: params['tierManipulationKey'],
            planTier: params['planTier'],
          ),
        )
      },
    );
    connectors['scrappableApi'] = _i1.EndpointConnector(
      name: 'scrappableApi',
      endpoint: endpoints['scrappableApi']!,
      methodConnectors: {
        'prod': _i1.MethodConnector(
          name: 'prod',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'apiKey': _i1.ParameterDescription(
              name: 'apiKey',
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
              (endpoints['scrappableApi'] as _i14.ScrappableApiEndpoint).prod(
            session,
            scrappableId: params['scrappableId'],
            apiKey: params['apiKey'],
            payload: params['payload'],
          ),
        ),
        'test': _i1.MethodConnector(
          name: 'test',
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
              (endpoints['scrappableApi'] as _i14.ScrappableApiEndpoint).test(
            session,
            scrappableId: params['scrappableId'],
            payload: params['payload'],
          ),
        ),
      },
    );
    connectors['scrappableChatSession'] = _i1.EndpointConnector(
      name: 'scrappableChatSession',
      endpoint: endpoints['scrappableChatSession']!,
      methodConnectors: {
        'disposeSession': _i1.MethodConnector(
          name: 'disposeSession',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scrappableChatSession'] as _i15.ScrappableChatSession)
                  .disposeSession(
            session,
            sessionId: params['sessionId'],
          ),
        ),
        'createSession': _i1.MethodConnector(
          name: 'createSession',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scrappableChatSession'] as _i15.ScrappableChatSession)
                  .createSession(
            session,
            scrappableId: params['scrappableId'],
          ),
        ),
        'changeChatModel': _i1.MethodConnector(
          name: 'changeChatModel',
          params: {
            'sessionUuid': _i1.ParameterDescription(
              name: 'sessionUuid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'aiModel': _i1.ParameterDescription(
              name: 'aiModel',
              type: _i1.getType<_i23.AiModel>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scrappableChatSession'] as _i15.ScrappableChatSession)
                  .changeChatModel(
            session,
            sessionUuid: params['sessionUuid'],
            aiModel: params['aiModel'],
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
              (endpoints['scrappableChatSession'] as _i15.ScrappableChatSession)
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
              (endpoints['scrappableChatSession'] as _i15.ScrappableChatSession)
                  .listenToScrappableRedraftSession(
            session,
            sessionUuid: params['sessionUuid'],
          ),
        ),
      },
    );
    modules['serverpod_auth'] = _i24.Endpoints()..initializeEndpoints(server);
  }
}
