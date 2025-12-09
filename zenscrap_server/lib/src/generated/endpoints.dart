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
import '../endpoints/private/private_ai_usage_endpoint.dart' as _i3;
import '../endpoints/private/private_api_usage_endpoint.dart' as _i4;
import '../endpoints/private/private_clone_scrappable_endpoint.dart' as _i5;
import '../endpoints/private/private_scrappable_analytics_endpoint.dart' as _i6;
import '../endpoints/private/private_subscription_endpoint.dart' as _i7;
import '../endpoints/private/private_user_scrappables_endpoint.dart' as _i8;
import '../endpoints/public/create_scrappable.dart' as _i9;
import '../endpoints/public/delete_scrappable_endpoint.dart' as _i10;
import '../endpoints/public/edit_scrappable_endpoint.dart' as _i11;
import '../endpoints/public/marketplace_endpoint.dart' as _i12;
import '../endpoints/public/public_scrappable_endpoint.dart' as _i13;
import '../endpoints/public/public_tier_endpoint.dart' as _i14;
import '../endpoints/public/scrappable_chat_session.dart' as _i15;
import 'package:zenscrap_server/src/generated/entities/account/credit_purchase_option.dart'
    as _i16;
import 'package:zenscrap_server/src/generated/entities/analytics/analytics_time_scope.dart'
    as _i17;
import 'package:zenscrap_server/src/generated/entities/scrappable/scraper_category.dart'
    as _i18;
import 'package:zenscrap_server/src/generated/entities/account/plan_tier.dart'
    as _i19;
import 'package:zenscrap_server/src/generated/entities/scrappable/ai_model.dart'
    as _i20;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i21;

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
      'privateAiUsage': _i3.PrivateAiUsageEndpoint()
        ..initialize(
          server,
          'privateAiUsage',
          null,
        ),
      'privateApiUsage': _i4.PrivateApiUsageEndpoint()
        ..initialize(
          server,
          'privateApiUsage',
          null,
        ),
      'privateCloneScrappable': _i5.PrivateCloneScrappableEndpoint()
        ..initialize(
          server,
          'privateCloneScrappable',
          null,
        ),
      'privateScrappableAnalytics': _i6.PrivateScrappableAnalyticsEndpoint()
        ..initialize(
          server,
          'privateScrappableAnalytics',
          null,
        ),
      'privateSubscription': _i7.PrivateSubscriptionEndpoint()
        ..initialize(
          server,
          'privateSubscription',
          null,
        ),
      'privateUserScrappables': _i8.PrivateUserScrappablesEndpoint()
        ..initialize(
          server,
          'privateUserScrappables',
          null,
        ),
      'createScrappable': _i9.CreateScrappableEndpoint()
        ..initialize(
          server,
          'createScrappable',
          null,
        ),
      'deleteScrappable': _i10.DeleteScrappableEndpoint()
        ..initialize(
          server,
          'deleteScrappable',
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
      'publicScrappable': _i13.PublicScrappableEndpoint()
        ..initialize(
          server,
          'publicScrappable',
          null,
        ),
      'publicTier': _i14.PublicTierEndpoint()
        ..initialize(
          server,
          'publicTier',
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
            'initialScrappableId': _i1.ParameterDescription(
              name: 'initialScrappableId',
              type: _i1.getType<int?>(),
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
            initialScrappableId: params['initialScrappableId'],
          ),
        )
      },
    );
    connectors['privateAiUsage'] = _i1.EndpointConnector(
      name: 'privateAiUsage',
      endpoint: endpoints['privateAiUsage']!,
      methodConnectors: {
        'getAiCreditHistory': _i1.MethodConnector(
          name: 'getAiCreditHistory',
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
              (endpoints['privateAiUsage'] as _i3.PrivateAiUsageEndpoint)
                  .getAiCreditHistory(
            session,
            page: params['page'],
          ),
        ),
        'getAiUsageInfo': _i1.MethodConnector(
          name: 'getAiUsageInfo',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateAiUsage'] as _i3.PrivateAiUsageEndpoint)
                  .getAiUsageInfo(session),
        ),
        'getAutoFixSessions': _i1.MethodConnector(
          name: 'getAutoFixSessions',
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
              (endpoints['privateAiUsage'] as _i3.PrivateAiUsageEndpoint)
                  .getAutoFixSessions(
            session,
            page: params['page'],
          ),
        ),
      },
    );
    connectors['privateApiUsage'] = _i1.EndpointConnector(
      name: 'privateApiUsage',
      endpoint: endpoints['privateApiUsage']!,
      methodConnectors: {
        'getApiCreditHistory': _i1.MethodConnector(
          name: 'getApiCreditHistory',
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
              (endpoints['privateApiUsage'] as _i4.PrivateApiUsageEndpoint)
                  .getApiCreditHistory(
            session,
            page: params['page'],
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
              (endpoints['privateApiUsage'] as _i4.PrivateApiUsageEndpoint)
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
              (endpoints['privateApiUsage'] as _i4.PrivateApiUsageEndpoint)
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
              (endpoints['privateApiUsage'] as _i4.PrivateApiUsageEndpoint)
                  .getActiveApiKeys(session),
        ),
        'getApiKeyUsageStats': _i1.MethodConnector(
          name: 'getApiKeyUsageStats',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i4.PrivateApiUsageEndpoint)
                  .getApiKeyUsageStats(session),
        ),
        'getApiUsageInfo': _i1.MethodConnector(
          name: 'getApiUsageInfo',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i4.PrivateApiUsageEndpoint)
                  .getApiUsageInfo(session),
        ),
        'getApiKeysWithStats': _i1.MethodConnector(
          name: 'getApiKeysWithStats',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i4.PrivateApiUsageEndpoint)
                  .getApiKeysWithStats(session),
        ),
        'createCreditPurchaseCheckout': _i1.MethodConnector(
          name: 'createCreditPurchaseCheckout',
          params: {
            'creditPackage': _i1.ParameterDescription(
              name: 'creditPackage',
              type: _i1.getType<_i16.CreditPurchaseOption>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateApiUsage'] as _i4.PrivateApiUsageEndpoint)
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
                      as _i5.PrivateCloneScrappableEndpoint)
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
        'getScrappableAnalyticsWithScope': _i1.MethodConnector(
          name: 'getScrappableAnalyticsWithScope',
          params: {
            'page': _i1.ParameterDescription(
              name: 'page',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'scope': _i1.ParameterDescription(
              name: 'scope',
              type: _i1.getType<_i17.AnalyticsTimeScope>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateScrappableAnalytics']
                      as _i6.PrivateScrappableAnalyticsEndpoint)
                  .getScrappableAnalyticsWithScope(
            session,
            page: params['page'],
            scope: params['scope'],
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
                      as _i6.PrivateScrappableAnalyticsEndpoint)
                  .getScrappableAnalytics(
            session,
            scrappableId: params['scrappableId'],
            page: params['page'],
          ),
        ),
        'getScrappableUsageMetrics': _i1.MethodConnector(
          name: 'getScrappableUsageMetrics',
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
              (endpoints['privateScrappableAnalytics']
                      as _i6.PrivateScrappableAnalyticsEndpoint)
                  .getScrappableUsageMetrics(
            session,
            scrappableId: params['scrappableId'],
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
                      as _i7.PrivateSubscriptionEndpoint)
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
                      as _i7.PrivateSubscriptionEndpoint)
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
                      as _i7.PrivateSubscriptionEndpoint)
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
                      as _i7.PrivateSubscriptionEndpoint)
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
            'categories': _i1.ParameterDescription(
              name: 'categories',
              type: _i1.getType<List<_i18.ScraperCategory>?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['privateUserScrappables']
                      as _i8.PrivateUserScrappablesEndpoint)
                  .call(
            session,
            page: params['page'],
            searchQuery: params['searchQuery'],
            categories: params['categories'],
          ),
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
                      as _i8.PrivateUserScrappablesEndpoint)
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
              (endpoints['createScrappable'] as _i9.CreateScrappableEndpoint)
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
              (endpoints['deleteScrappable'] as _i10.DeleteScrappableEndpoint)
                  .call(
            session,
            scrappableId: params['scrappableId'],
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
              type: _i1.getType<_i18.ScraperCategory?>(),
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
            'categories': _i1.ParameterDescription(
              name: 'categories',
              type: _i1.getType<List<_i18.ScraperCategory>?>(),
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
            categories: params['categories'],
          ),
        )
      },
    );
    connectors['publicScrappable'] = _i1.EndpointConnector(
      name: 'publicScrappable',
      endpoint: endpoints['publicScrappable']!,
      methodConnectors: {
        'getByteTestData': _i1.MethodConnector(
          name: 'getByteTestData',
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
              (endpoints['publicScrappable'] as _i13.PublicScrappableEndpoint)
                  .getByteTestData(
            session,
            params['scrappableId'],
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
              type: _i1.getType<_i19.PlanTier>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['publicTier'] as _i14.PublicTierEndpoint)
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
        'commitCurrentEditState': _i1.MethodConnector(
          name: 'commitCurrentEditState',
          params: {
            'sessionUuid': _i1.ParameterDescription(
              name: 'sessionUuid',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scrappableChatSession'] as _i15.ScrappableChatSession)
                  .commitCurrentEditState(
            session,
            sessionUuid: params['sessionUuid'],
          ),
        ),
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
        'updateUserApiKey': _i1.MethodConnector(
          name: 'updateUserApiKey',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'openAiApiKey': _i1.ParameterDescription(
              name: 'openAiApiKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scrappableChatSession'] as _i15.ScrappableChatSession)
                  .updateUserApiKey(
            session,
            sessionId: params['sessionId'],
            openAiApiKey: params['openAiApiKey'],
          ),
        ),
        'updateScrappableRequest': _i1.MethodConnector(
          name: 'updateScrappableRequest',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'url': _i1.ParameterDescription(
              name: 'url',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'pathParams': _i1.ParameterDescription(
              name: 'pathParams',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
            'queryParams': _i1.ParameterDescription(
              name: 'queryParams',
              type: _i1.getType<Map<String, String?>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['scrappableChatSession'] as _i15.ScrappableChatSession)
                  .updateScrappableRequest(
            session,
            scrappableId: params['scrappableId'],
            url: params['url'],
            pathParams: params['pathParams'],
            queryParams: params['queryParams'],
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
              type: _i1.getType<_i20.AiModel>(),
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
        'sendPromptMessage': _i1.MethodStreamConnector(
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
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
            Map<String, Stream> streamParams,
          ) =>
              (endpoints['scrappableChatSession'] as _i15.ScrappableChatSession)
                  .sendPromptMessage(
            session,
            sessionId: params['sessionId'],
            userPrompt: params['userPrompt'],
          ),
        ),
      },
    );
    modules['serverpod_auth'] = _i21.Endpoints()..initializeEndpoints(server);
  }
}
