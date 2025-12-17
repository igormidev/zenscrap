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
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/auth/email_idp_endpoint.dart' as _i2;
import '../endpoints/auth/google_idp_endpoint.dart' as _i3;
import '../endpoints/auth/refresh_jwt_tokens_endpoint.dart' as _i4;
import '../endpoints/private/private_account_endpoint.dart' as _i5;
import '../endpoints/private/private_ai_usage_endpoint.dart' as _i6;
import '../endpoints/private/private_api_usage_endpoint.dart' as _i7;
import '../endpoints/private/private_clone_scrappable_endpoint.dart' as _i8;
import '../endpoints/private/private_scrappable_analytics_endpoint.dart' as _i9;
import '../endpoints/private/private_subscription_endpoint.dart' as _i10;
import '../endpoints/private/private_user_scrappables_endpoint.dart' as _i11;
import '../endpoints/public/create_scrappable.dart' as _i12;
import '../endpoints/public/delete_scrappable_endpoint.dart' as _i13;
import '../endpoints/public/edit_scrappable_endpoint.dart' as _i14;
import '../endpoints/public/marketplace_endpoint.dart' as _i15;
import '../endpoints/public/public_scrappable_endpoint.dart' as _i16;
import '../endpoints/public/public_tier_endpoint.dart' as _i17;
import '../endpoints/public/scrappable_chat_session.dart' as _i18;
import 'package:zenscrap_server/src/generated/entities/supported_language.dart'
    as _i19;
import 'package:zenscrap_server/src/generated/protocol.dart' as _i20;
import 'package:zenscrap_server/src/generated/entities/account/credit_purchase_option.dart'
    as _i21;
import 'package:zenscrap_server/src/generated/entities/analytics/analytics_time_scope.dart'
    as _i22;
import 'package:zenscrap_server/src/generated/entities/scrappable/scraper_category.dart'
    as _i23;
import 'package:zenscrap_server/src/generated/entities/scrappable/ai_model.dart'
    as _i24;
import 'package:zenscrap_server/src/generated/entities/account/plan_tier.dart'
    as _i25;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i26;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i27;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'googleIdp': _i3.GoogleIdpEndpoint()
        ..initialize(
          server,
          'googleIdp',
          null,
        ),
      'refreshJwtTokens': _i4.RefreshJwtTokensEndpoint()
        ..initialize(
          server,
          'refreshJwtTokens',
          null,
        ),
      'privateAccount': _i5.PrivateAccountEndpoint()
        ..initialize(
          server,
          'privateAccount',
          null,
        ),
      'privateAiUsage': _i6.PrivateAiUsageEndpoint()
        ..initialize(
          server,
          'privateAiUsage',
          null,
        ),
      'privateApiUsage': _i7.PrivateApiUsageEndpoint()
        ..initialize(
          server,
          'privateApiUsage',
          null,
        ),
      'privateCloneScrappable': _i8.PrivateCloneScrappableEndpoint()
        ..initialize(
          server,
          'privateCloneScrappable',
          null,
        ),
      'privateScrappableAnalytics': _i9.PrivateScrappableAnalyticsEndpoint()
        ..initialize(
          server,
          'privateScrappableAnalytics',
          null,
        ),
      'privateSubscription': _i10.PrivateSubscriptionEndpoint()
        ..initialize(
          server,
          'privateSubscription',
          null,
        ),
      'privateUserScrappables': _i11.PrivateUserScrappablesEndpoint()
        ..initialize(
          server,
          'privateUserScrappables',
          null,
        ),
      'createScrappable': _i12.CreateScrappableEndpoint()
        ..initialize(
          server,
          'createScrappable',
          null,
        ),
      'deleteScrappable': _i13.DeleteScrappableEndpoint()
        ..initialize(
          server,
          'deleteScrappable',
          null,
        ),
      'editScrappable': _i14.EditScrappableEndpoint()
        ..initialize(
          server,
          'editScrappable',
          null,
        ),
      'marketplace': _i15.MarketplaceEndpoint()
        ..initialize(
          server,
          'marketplace',
          null,
        ),
      'publicScrappable': _i16.PublicScrappableEndpoint()
        ..initialize(
          server,
          'publicScrappable',
          null,
        ),
      'publicTier': _i17.PublicTierEndpoint()
        ..initialize(
          server,
          'publicTier',
          null,
        ),
      'scrappableChatSession': _i18.ScrappableChatSession()
        ..initialize(
          server,
          'scrappableChatSession',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['googleIdp'] = _i1.EndpointConnector(
      name: 'googleIdp',
      endpoint: endpoints['googleIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'accessToken': _i1.ParameterDescription(
              name: 'accessToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['googleIdp'] as _i3.GoogleIdpEndpoint).login(
                    session,
                    idToken: params['idToken'],
                    accessToken: params['accessToken'],
                  ),
        ),
      },
    );
    connectors['refreshJwtTokens'] = _i1.EndpointConnector(
      name: 'refreshJwtTokens',
      endpoint: endpoints['refreshJwtTokens']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['refreshJwtTokens']
                          as _i4.RefreshJwtTokensEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
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
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateAccount'] as _i5.PrivateAccountEndpoint)
                      .getAccountInfo(
                        session,
                        initialScrappableId: params['initialScrappableId'],
                        language: params['language'],
                      ),
        ),
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
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateAiUsage'] as _i6.PrivateAiUsageEndpoint)
                      .getAiCreditHistory(
                        session,
                        page: params['page'],
                        language: params['language'],
                      ),
        ),
        'getAiUsageInfo': _i1.MethodConnector(
          name: 'getAiUsageInfo',
          params: {
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateAiUsage'] as _i6.PrivateAiUsageEndpoint)
                      .getAiUsageInfo(
                        session,
                        language: params['language'],
                      ),
        ),
        'updateOpenAiApiKey': _i1.MethodConnector(
          name: 'updateOpenAiApiKey',
          params: {
            'apiKey': _i1.ParameterDescription(
              name: 'apiKey',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateAiUsage'] as _i6.PrivateAiUsageEndpoint)
                      .updateOpenAiApiKey(
                        session,
                        apiKey: params['apiKey'],
                        language: params['language'],
                      ),
        ),
        'getAutoFixSessions': _i1.MethodConnector(
          name: 'getAutoFixSessions',
          params: {
            'page': _i1.ParameterDescription(
              name: 'page',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateAiUsage'] as _i6.PrivateAiUsageEndpoint)
                      .getAutoFixSessions(
                        session,
                        page: params['page'],
                        language: params['language'],
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
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateApiUsage'] as _i7.PrivateApiUsageEndpoint)
                      .getApiCreditHistory(
                        session,
                        page: params['page'],
                        language: params['language'],
                      ),
        ),
        'createApiKey': _i1.MethodConnector(
          name: 'createApiKey',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateApiUsage'] as _i7.PrivateApiUsageEndpoint)
                      .createApiKey(
                        session,
                        name: params['name'],
                        language: params['language'],
                      ),
        ),
        'deactivateApiKey': _i1.MethodConnector(
          name: 'deactivateApiKey',
          params: {
            'apiKeyId': _i1.ParameterDescription(
              name: 'apiKeyId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateApiUsage'] as _i7.PrivateApiUsageEndpoint)
                      .deactivateApiKey(
                        session,
                        apiKeyId: params['apiKeyId'],
                        language: params['language'],
                      ),
        ),
        'getActiveApiKeys': _i1.MethodConnector(
          name: 'getActiveApiKeys',
          params: {
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateApiUsage'] as _i7.PrivateApiUsageEndpoint)
                      .getActiveApiKeys(
                        session,
                        language: params['language'],
                      ),
        ),
        'getApiKeyUsageStats': _i1.MethodConnector(
          name: 'getApiKeyUsageStats',
          params: {
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateApiUsage'] as _i7.PrivateApiUsageEndpoint)
                      .getApiKeyUsageStats(
                        session,
                        language: params['language'],
                      )
                      .then((container) => _i20.mapContainerToJson(container)),
        ),
        'getApiUsageInfo': _i1.MethodConnector(
          name: 'getApiUsageInfo',
          params: {
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateApiUsage'] as _i7.PrivateApiUsageEndpoint)
                      .getApiUsageInfo(
                        session,
                        language: params['language'],
                      ),
        ),
        'getApiKeysWithStats': _i1.MethodConnector(
          name: 'getApiKeysWithStats',
          params: {
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateApiUsage'] as _i7.PrivateApiUsageEndpoint)
                      .getApiKeysWithStats(
                        session,
                        language: params['language'],
                      ),
        ),
        'createCreditPurchaseCheckout': _i1.MethodConnector(
          name: 'createCreditPurchaseCheckout',
          params: {
            'creditPackage': _i1.ParameterDescription(
              name: 'creditPackage',
              type: _i1.getType<_i21.CreditPurchaseOption>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateApiUsage'] as _i7.PrivateApiUsageEndpoint)
                      .createCreditPurchaseCheckout(
                        session,
                        creditPackage: params['creditPackage'],
                        language: params['language'],
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
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateCloneScrappable']
                          as _i8.PrivateCloneScrappableEndpoint)
                      .cloneFromMarketplace(
                        session,
                        scrappableId: params['scrappableId'],
                        language: params['language'],
                      ),
        ),
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
              type: _i1.getType<_i22.AnalyticsTimeScope>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateScrappableAnalytics']
                          as _i9.PrivateScrappableAnalyticsEndpoint)
                      .getScrappableAnalyticsWithScope(
                        session,
                        page: params['page'],
                        scope: params['scope'],
                        language: params['language'],
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
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateScrappableAnalytics']
                          as _i9.PrivateScrappableAnalyticsEndpoint)
                      .getScrappableAnalytics(
                        session,
                        scrappableId: params['scrappableId'],
                        page: params['page'],
                        language: params['language'],
                      ),
        ),
        'getScrappableUsageMetrics': _i1.MethodConnector(
          name: 'getScrappableUsageMetrics',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateScrappableAnalytics']
                          as _i9.PrivateScrappableAnalyticsEndpoint)
                      .getScrappableUsageMetrics(
                        session,
                        scrappableId: params['scrappableId'],
                        language: params['language'],
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
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateSubscription']
                          as _i10.PrivateSubscriptionEndpoint)
                      .createCheckoutSession(
                        session,
                        planTier: params['planTier'],
                        isYearly: params['isYearly'],
                        language: params['language'],
                      ),
        ),
        'getSubscriptionStatus': _i1.MethodConnector(
          name: 'getSubscriptionStatus',
          params: {
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateSubscription']
                          as _i10.PrivateSubscriptionEndpoint)
                      .getSubscriptionStatus(
                        session,
                        language: params['language'],
                      ),
        ),
        'cancelSubscription': _i1.MethodConnector(
          name: 'cancelSubscription',
          params: {
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateSubscription']
                          as _i10.PrivateSubscriptionEndpoint)
                      .cancelSubscription(
                        session,
                        language: params['language'],
                      ),
        ),
        'createCustomerPortalSession': _i1.MethodConnector(
          name: 'createCustomerPortalSession',
          params: {
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateSubscription']
                          as _i10.PrivateSubscriptionEndpoint)
                      .createCustomerPortalSession(
                        session,
                        language: params['language'],
                      ),
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
              type: _i1.getType<List<_i23.ScraperCategory>?>(),
              nullable: true,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateUserScrappables']
                          as _i11.PrivateUserScrappablesEndpoint)
                      .call(
                        session,
                        page: params['page'],
                        searchQuery: params['searchQuery'],
                        categories: params['categories'],
                        language: params['language'],
                      ),
        ),
        'getScrappableById': _i1.MethodConnector(
          name: 'getScrappableById',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['privateUserScrappables']
                          as _i11.PrivateUserScrappablesEndpoint)
                      .getScrappableById(
                        session,
                        params['scrappableId'],
                        language: params['language'],
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
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['createScrappable']
                          as _i12.CreateScrappableEndpoint)
                      .call(
                        session,
                        referenceLink: params['referenceLink'],
                        language: params['language'],
                      ),
        ),
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
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['deleteScrappable']
                          as _i13.DeleteScrappableEndpoint)
                      .call(
                        session,
                        scrappableId: params['scrappableId'],
                        language: params['language'],
                      ),
        ),
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
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i23.ScraperCategory?>(),
              nullable: true,
            ),
            'willHideFromMarketplace': _i1.ParameterDescription(
              name: 'willHideFromMarketplace',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'autoFixEnabled': _i1.ParameterDescription(
              name: 'autoFixEnabled',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'autoFixConsecutiveErrorThreshold': _i1.ParameterDescription(
              name: 'autoFixConsecutiveErrorThreshold',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'autoFixPreferredAiModel': _i1.ParameterDescription(
              name: 'autoFixPreferredAiModel',
              type: _i1.getType<_i24.AiModel?>(),
              nullable: true,
            ),
            'autoFixUseAutoAiModel': _i1.ParameterDescription(
              name: 'autoFixUseAutoAiModel',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['editScrappable'] as _i14.EditScrappableEndpoint)
                      .call(
                        session,
                        scrappableId: params['scrappableId'],
                        name: params['name'],
                        description: params['description'],
                        language: params['language'],
                        category: params['category'],
                        willHideFromMarketplace:
                            params['willHideFromMarketplace'],
                        autoFixEnabled: params['autoFixEnabled'],
                        autoFixConsecutiveErrorThreshold:
                            params['autoFixConsecutiveErrorThreshold'],
                        autoFixPreferredAiModel:
                            params['autoFixPreferredAiModel'],
                        autoFixUseAutoAiModel: params['autoFixUseAutoAiModel'],
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
              type: _i1.getType<List<_i23.ScraperCategory>?>(),
              nullable: true,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['marketplace'] as _i15.MarketplaceEndpoint)
                  .getItems(
                    session,
                    page: params['page'],
                    searchQuery: params['searchQuery'],
                    categories: params['categories'],
                    language: params['language'],
                  ),
        ),
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
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['publicScrappable']
                          as _i16.PublicScrappableEndpoint)
                      .getByteTestData(
                        session,
                        params['scrappableId'],
                        language: params['language'],
                      ),
        ),
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
              type: _i1.getType<_i25.PlanTier>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['publicTier'] as _i17.PublicTierEndpoint)
                  .updatePlayerTier(
                    session,
                    email: params['email'],
                    tierManipulationKey: params['tierManipulationKey'],
                    planTier: params['planTier'],
                  ),
        ),
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
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['scrappableChatSession']
                          as _i18.ScrappableChatSession)
                      .commitCurrentEditState(
                        session,
                        sessionUuid: params['sessionUuid'],
                        language: params['language'],
                      ),
        ),
        'disposeSession': _i1.MethodConnector(
          name: 'disposeSession',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['scrappableChatSession']
                          as _i18.ScrappableChatSession)
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
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['scrappableChatSession']
                          as _i18.ScrappableChatSession)
                      .updateUserApiKey(
                        session,
                        sessionId: params['sessionId'],
                        openAiApiKey: params['openAiApiKey'],
                        language: params['language'],
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
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['scrappableChatSession']
                          as _i18.ScrappableChatSession)
                      .updateScrappableRequest(
                        session,
                        scrappableId: params['scrappableId'],
                        url: params['url'],
                        pathParams: params['pathParams'],
                        queryParams: params['queryParams'],
                        language: params['language'],
                      ),
        ),
        'createSession': _i1.MethodConnector(
          name: 'createSession',
          params: {
            'scrappableId': _i1.ParameterDescription(
              name: 'scrappableId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['scrappableChatSession']
                          as _i18.ScrappableChatSession)
                      .createSession(
                        session,
                        scrappableId: params['scrappableId'],
                        language: params['language'],
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
              type: _i1.getType<_i24.AiModel>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['scrappableChatSession']
                          as _i18.ScrappableChatSession)
                      .changeChatModel(
                        session,
                        sessionUuid: params['sessionUuid'],
                        aiModel: params['aiModel'],
                        language: params['language'],
                      ),
        ),
        'listenToScrappableRedraftSession': _i1.MethodStreamConnector(
          name: 'listenToScrappableRedraftSession',
          params: {
            'sessionUuid': _i1.ParameterDescription(
              name: 'sessionUuid',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['scrappableChatSession']
                          as _i18.ScrappableChatSession)
                      .listenToScrappableRedraftSession(
                        session,
                        sessionUuid: params['sessionUuid'],
                        language: params['language'],
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
            'language': _i1.ParameterDescription(
              name: 'language',
              type: _i1.getType<_i19.SupportedLanguage>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) =>
                  (endpoints['scrappableChatSession']
                          as _i18.ScrappableChatSession)
                      .sendPromptMessage(
                        session,
                        sessionId: params['sessionId'],
                        userPrompt: params['userPrompt'],
                        language: params['language'],
                      ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i26.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i27.Endpoints()
      ..initializeEndpoints(server);
  }
}
