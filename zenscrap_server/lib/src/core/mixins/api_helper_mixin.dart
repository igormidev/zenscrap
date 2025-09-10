import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/extension/plan_tier_extension.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/endpoints/public/scrappable_chat_session.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef ApiKey = String;
typedef NanoId = String;
mixin ApiHelperMixin {
  static final Map<NanoId, int> _currentConcurrencyRequests = {};
  static final Map<NanoId, PlanTier> _currentAccountPlanTierCache = {};
  static final Map<NanoId, CreditUsage> _currentCreditUsage = {};
  static final Map<NanoId, int> _remainingSubscriptionCredits = {};
  static final Map<NanoId, int> _remainingPurchasedCredits = {};
  static final Map<NanoId, List<ApiKey>> _apiKeysAttachedToNanoId = {};

  static void resetNanoId(NanoId nanoId) {
    _currentConcurrencyRequests.remove(nanoId);
    _currentCreditUsage.remove(nanoId);
    _currentAccountPlanTierCache.remove(nanoId);
    _remainingSubscriptionCredits.remove(nanoId);
    _remainingPurchasedCredits.remove(nanoId);
    _apiKeysAttachedToNanoId.remove(nanoId);
  }

  Future<NanoId?> getNanoId(Session session, ApiKey? apikey) async {
    if (apikey == null) return null;
    final splitted = apikey.split('::');
    if (splitted.length != 2) throw _invalidApiKeyFormat;
    final nanoId = splitted[0];

    final PlanTier? cachePlanTier = _currentAccountPlanTierCache[nanoId];
    if (cachePlanTier != null) {
      if (cachePlanTier == PlanTier.none) throw _noActivePlan;
      return nanoId;
    }

    final PlanTier? planTier = (await AccountInfo.db.findFirstRow(
      session,
      where: (p0) =>
          p0.accountApiUsage.nanoId.equals(nanoId) &
          p0.accountApiUsage.apiKeys.any(
              (key) => key.apiKey.equals(apikey) & key.isActive.equals(true)),
    ))
        ?.planTier;

    if (planTier == null) throw _invalidApiKey;
    if (cachePlanTier == PlanTier.none) throw _noActivePlan;
    _currentAccountPlanTierCache[nanoId] = planTier;
    _apiKeysAttachedToNanoId[nanoId] ??= [apikey];

    return nanoId;
  }

  void increaseConcurrency(NanoId? nanoId) {
    if (nanoId == null) return;
    final maxConcurrentRequests = _currentAccountPlanTierCache[nanoId]
        ?.numberOfConcurrentRequestsAllowedByPlan;
    if (maxConcurrentRequests == null) throw _noActivePlan;

    final canIncrease =
        (_currentConcurrencyRequests[nanoId] ?? 0) + 1 <= maxConcurrentRequests;
    if (!canIncrease) throw _maxConcurrency;

    _currentConcurrencyRequests[nanoId] =
        (_currentConcurrencyRequests[nanoId] ?? 0) + 1;
  }

  void decreaseConcurrency(NanoId? nanoId) {
    if (nanoId == null) return;
    _currentConcurrencyRequests[nanoId] =
        (_currentConcurrencyRequests[nanoId] ?? 1) - 1;
    if (_currentConcurrencyRequests[nanoId] == 0) {
      _currentConcurrencyRequests.remove(nanoId);
    }
  }

  void throwErrorIfIsATestRequestAndTestTimeExpired(
      ApiKey? apiKey, Scrappable scrappable) {
    final isTest = apiKey == null;
    if (isTest) {
      final testExpiry = scrappable.testEndpointAvailableUntil;
      if (testExpiry == null || testExpiry.isBefore(DateTime.now())) {
        throw _testPeriodExpired;
      }
    }
  }

  String composeUrl(
    Map<String, dynamic> payload,
    ScrappableRequest targetRequest,
  ) {
    String targetUrl = targetRequest.url;

    // First, add the path parameters
    for (final String pathParam in targetRequest.pathParams) {
      final String? payloadParam = payload[pathParam];
      if (payloadParam == null) {
        throw ZenScrapException(
          title: 'Missing Path Parameter',
          description:
              'Required path parameter "$pathParam" was not provided in the payload.',
        );
      }
      targetUrl = targetUrl.replaceAll('{$pathParam}', payloadParam);
    }

    // Now, let's add query parameters
    final Map<String, String> queryParams = {};
    for (final MapEntry<String, String?> entry
        in targetRequest.queryParams.entries) {
      final String queryParamName = entry.key;
      final String? defaultQueryParam = entry.value;
      final String? payloadQueryParam = payload[queryParamName];
      final String? queryParam = payloadQueryParam ?? defaultQueryParam;
      if (queryParam != null) {
        queryParams[queryParamName] = queryParam;
      }
    }
    if (queryParams.isNotEmpty) {
      targetUrl += '?${Uri(queryParameters: queryParams).query}';
    }

    return targetUrl;
  }

  /// Priority is; first deduce on subscription, then on purchased credits
  Future<void> discountApiTokens(
    Session session, {
    required NanoId? nanoId,
  }) async {
    if (nanoId == null) return;
    final subscriptionCredits = _remainingSubscriptionCredits[nanoId];
    final purchasedCredits = _remainingPurchasedCredits[nanoId];

    if (subscriptionCredits == null || purchasedCredits == null) {
      // Let's get the most updated value from data base
      final accountApiUsage = await AccountApiUsage.db.findFirstRow(
        session,
        where: (p0) => p0.nanoId.equals(nanoId),
        include: AccountApiUsage.include(
          creditUsage: CreditUsage.include(),
        ),
      );
      if (accountApiUsage == null || accountApiUsage.creditUsage == null) {
        throw _noApiFound;
      }

      _currentCreditUsage[nanoId] = accountApiUsage.creditUsage!;
      _remainingPurchasedCredits[nanoId] =
          accountApiUsage.creditUsage!.purchasedCredits;
      _remainingSubscriptionCredits[nanoId] =
          accountApiUsage.creditUsage!.subscriptionCredits;
      return discountApiTokens(session, nanoId: nanoId);
    }

    // First, try to deduct from subscription credits
    if (subscriptionCredits > 0) {
      _remainingSubscriptionCredits[nanoId] =
          (_remainingSubscriptionCredits[nanoId] ?? subscriptionCredits) - 1;
      return;
    }

    if (purchasedCredits > 0) {
      _remainingPurchasedCredits[nanoId] =
          (_remainingPurchasedCredits[nanoId] ?? purchasedCredits) - 1;
      return;
    }

    throw _insufficientCredits;
  }

  Future<(Scrappable, ScrappableRequest)> getScrappableById(
      Session session, int scrappableId, NanoId? nanoId) async {
    final Scrappable? scrappable = await Scrappable.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(scrappableId) &
          ( // If not private, allow all
              t.willHideFromMarketplace.equals(false) |

                  // If private, allow only if the nanoId matches
                  (t.willHideFromMarketplace.equals(true) &
                      t.apiUsageOwnerNanoId.notEquals(null) &
                      t.apiUsageOwnerNanoId.equals(nanoId))),
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
      ),
    );

    final ScrappableRequest? targetRequest = scrappable?.targetRequest;

    if (scrappable == null || targetRequest == null) {
      throw _noScrappableFound(scrappableId.toString());
    }

    // Check if scrappable is deleted
    if (scrappable.isDeleted == true) {
      throw _noScrappableFound(scrappableId.toString());
    }

    return (scrappable, targetRequest);
  }

  Future<String> _getExtractRules(Session session, Scrappable scrappable,
      String? accountApiKeyString) async {
    final isTest = accountApiKeyString == null;
    if (isTest) {
      final testSessionExtractRule = getTestExtractRules(scrappable.id!);
      if (testSessionExtractRule == null) {
        throw _noActiveTestSessionFinded;
      }

      return testSessionExtractRule;
    }

    final String? extractRules = (await ScrappableTestResult.db.findFirstRow(
      session,
      where: (p0) => p0.scrappableId.equals(scrappable.id),
    ))
        ?.testExtractRule;

    if (extractRules == null || extractRules.isEmpty) {
      throw _missingExtractRules;
    }

    return extractRules;
  }

  bool checkIdApiKeyExists(NanoId? nanoId, ApiKey? apiKey) {
    return _apiKeysAttachedToNanoId[nanoId]?.contains(apiKey) ?? false;
  }

  Future<void> garanteeApiKeyExists(
      Session session, NanoId? nanoId, ApiKey? apiKey) async {
    final isTest = nanoId == null || apiKey == null;
    if (isTest) return;

    final accountApiUsage = await AccountApiUsage.db.findFirstRow(
      session,
      where: (p0) =>
          p0.nanoId.equals(nanoId) &
          p0.apiKeys.any(
              (key) => key.apiKey.equals(apiKey) & key.isActive.equals(true)),
    );

    if (accountApiUsage == null) {
      throw _apiKeyNotFound(apiKey);
    } else {
      _apiKeysAttachedToNanoId[nanoId] ??= [apiKey];
    }
  }

  Future<T> wrapAnalytics<T>(
    Session session,
    ApiKey? apiKey,
    Future<T> Function(void Function(Scrappable? scrappable) onSetScrapable,
            NanoId? nanoId)
        call,
  ) async {
    Scrappable? scrappable;
    final NanoId? nanoId = await getNanoId(session, apiKey);
    increaseConcurrency(nanoId);
    final doesApiKeyExists = checkIdApiKeyExists(nanoId, apiKey);
    // Will throw if not exists and cache result if exist so new calls to db are not needed each time
    if (!doesApiKeyExists) await garanteeApiKeyExists(session, nanoId, apiKey);

    try {
      return await call((s) {
        scrappable = s;
      }, nanoId);
    } on _ApiError catch (error, stackTrace) {
      await _setScrappableAnalytics(
          session, scrappable, error.status, apiKey, nanoId);
      session.log(
        '[${error.status.name.toUpperCase()}] ${_noApiFound.exception.title}',
        exception: error.exception,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      rethrow;
    } catch (error, stackTrace) {
      await _setScrappableAnalytics(
          session, scrappable, RequestStatus.serverError, apiKey, nanoId);
      session.log(
        'An unknown error occurred in api',
        exception: error,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      // Handle any other exceptions
      throw ZenScrapException(
        title: 'Unexpected Error',
        description: 'An unexpected error occurred: ${error.toString()}',
      );
    } finally {
      decreaseConcurrency(nanoId);
    }
  }

  Future<void> _setScrappableAnalytics(
    Session session,
    Scrappable? scrappable,
    RequestStatus status,
    ApiKey? apiKey,
    NanoId? nanoId,
  ) async {
    if (scrappable != null && apiKey != null && nanoId != null) {
      final CreditUsage? credit = _currentCreditUsage[nanoId];
      if (credit == null) {
        session.log(
          'Credit usage not found for nanoId $nanoId when trying to log scrappable analytics',
          level: LogLevel.error,
        );
        throw _noCreditUsageModelFound(apiKey);
      }

      await session.db.transaction((transaction) async {
        final newCredit = credit.copyWith(
          subscriptionCredits: _remainingSubscriptionCredits[nanoId],
          purchasedCredits: _remainingPurchasedCredits[nanoId],
        );
        await CreditUsage.db
            .updateRow(session, newCredit, transaction: transaction);
        final analytics = await ScrappableAnalytics.db.insertRow(
            session,
            ScrappableAnalytics(
              requestStatus: status,
              scrappableId: scrappable.id!,
              scrappable: scrappable,
              requestedAt: DateTime.now(),
              attachedApiKey: apiKey,
              attachedNanoId: nanoId,
            ),
            transaction: transaction);
        await Scrappable.db.attachRow.scrappableAnalytics(
          session,
          scrappable,
          analytics,
          transaction: transaction,
        );
      });
    }
  }

  Future<Map<String, dynamic>> callFunc(
    Session session, {
    required int scrappableId,
    String? apiKey,
    required Map<String, dynamic> payload,
  }) async {
    return wrapAnalytics(session, apiKey,
        (setScrappableCallback, nanoId) async {
      await discountApiTokens(session, nanoId: nanoId);

      final (Scrappable scrappable, ScrappableRequest targetRequest) =
          await getScrappableById(session, scrappableId, nanoId);
      setScrappableCallback(scrappable);
      throwErrorIfIsATestRequestAndTestTimeExpired(apiKey, scrappable);
      final String targetUrl = composeUrl(payload, targetRequest);
      final extractRules = await getExtractRules(session, scrappable, apiKey);

      final ExtractDataByRule result =
          await scrapingBeeDeprecated.extractByRules(
        targetUrl: targetUrl,
        extractRules: extractRules,
      );

      return result.when(withData: (r) => r, error: scrappingError);
    });
  }
}

_ApiError _noCreditUsageModelFound(ApiKey apiKey) => _ApiError(
      RequestStatus.clientError,
      ZenScrapException(
        title: 'No Credit Usage Model Found',
        description:
            'No credit usage model found for the provided API key: $apiKey.\n'
            'It could be that the account was deleted or has no plan assigned - check in your api key tab on ZenScrap site.',
      ),
    );
_ApiError _apiKeyNotFound(ApiKey apiKey) => _ApiError(
      RequestStatus.clientError,
      ZenScrapException(
        title: 'Valid API Key Not Found',
        description:
            'There is no active API key matching the provided value: $apiKey.\n'
            'It could be that the key was deleted or deactivated - check in your api key tab on ZenScrap site.',
      ),
    );
final _noActiveTestSessionFinded = _ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'No Active Test Session Found',
    description:
        'There is no active test session found for the provided scrappable.',
  ),
);
final _testPeriodExpired = _ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'Test Period Expired',
    description: '''The test period for this scrappable has expired.

You can:
- Start a new testing session, that will start a new test period
- Call the production endpoint with a valid API key if you have an account''',
  ),
);
final _noApiFound = _ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'API Key Not Found',
    description:
        'No account API key matched the provided value (key not found in database).',
  ),
);
final _insufficientCredits = _ApiError(
    RequestStatus.insufficientCredits,
    throw ZenScrapException(
      title: 'Insufficient Credits',
      description:
          'Your account has no remaining credits. Purchase or allocate more credits to continue making requests.',
    ));
final _missingExtractRules = _ApiError(
    RequestStatus.clientError,
    ZenScrapException(
      title: 'Missing Extract Rules',
      description:
          'No extract rules are defined for this scrappable. Please define extraction rules before invoking this endpoint.',
    ));
final _invalidApiKey = _ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'Invalid API Key',
    description: 'The provided API key does not have a user account.',
  ),
);
final _noActivePlan = _ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'No Active Plan',
    description:
        'Your account does not have an active plan. Subscribe to a plan to access the API.',
  ),
);
final _maxConcurrency = _ApiError(
    RequestStatus.maxConcurrencyExceeded,
    ZenScrapException(
      title: 'Concurrency Limit Exceeded',
      description:
          'You have reached the maximum number of concurrent requests allowed for your plan tier.',
    ));

T scrappingError<T>(String errorMessage) => throw _ApiError(
    RequestStatus.serverError,
    ZenScrapException(
      title: 'Scraping Error',
      description: errorMessage,
    ));

_ApiError _noScrappableFound(String scrappableId) => _ApiError(
    RequestStatus.clientError,
    throw ZenScrapException(
      title: 'Scrappable Not Found',
      description:
          'The scrappable resource with id $scrappableId does not exist or has no target request configured.',
    ));

final _invalidApiKeyFormat = _ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'Invalid API Key Format',
    description: 'API Key must be in the format "nanoId::apiKey".',
  ),
);

class _ApiError {
  final RequestStatus status;
  final ZenScrapException exception;

  _ApiError(this.status, this.exception);
}
