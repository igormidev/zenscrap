import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/extension/plan_tier_extension.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef ApiKey = String;
typedef NanoId = String;
mixin ApiHelperMixin {
  static final Map<NanoId, int> currentConcurrencyRequests = {};
  static final Map<NanoId, PlanTier> currentAccountPlanTierCache = {};
  static final Map<NanoId, int> remainingSubscriptionCredits = {};
  static final Map<NanoId, int> remainingPurchasedCredits = {};

  Future<NanoId?> getNanoId(Session session, ApiKey? apikey) async {
    if (apikey == null) return null;
    final splitted = apikey.split('::');
    if (splitted.length != 2) throw _invalidApiKeyFormat;
    final nanoId = splitted[0];

    final PlanTier? cachePlanTier = currentAccountPlanTierCache[nanoId];
    if (cachePlanTier != null) {
      if (cachePlanTier == PlanTier.none) throw _noActivePlan;
      return nanoId;
    }

    final PlanTier? planTier = (await AccountInfo.db.findFirstRow(
      session,
      where: (p0) =>
          p0.accountApiUsage.nanoId.equals(nanoId) &
          p0.accountApiUsage.apiKeys.any((key) => key.apiKey.equals(apikey)),
    ))
        ?.planTier;

    if (planTier == null) throw _invalidApiKey;
    if (cachePlanTier == PlanTier.none) throw _noActivePlan;
    currentAccountPlanTierCache[nanoId] = planTier;

    return nanoId;
  }

  void increaseConcurrency(NanoId? nanoId) {
    if (nanoId == null) return;
    final maxConcurrentRequests = currentAccountPlanTierCache[nanoId]
        ?.numberOfConcurrentRequestsAllowedByPlan;
    if (maxConcurrentRequests == null) throw _noActivePlan;

    final canIncrease =
        (currentConcurrencyRequests[nanoId] ?? 0) + 1 <= maxConcurrentRequests;
    if (!canIncrease) throw _maxConcurrency;

    currentConcurrencyRequests[nanoId] =
        (currentConcurrencyRequests[nanoId] ?? 0) + 1;
  }

  void decreaseConcurrency(NanoId? nanoId) {
    if (nanoId == null) return;
    currentConcurrencyRequests[nanoId] =
        (currentConcurrencyRequests[nanoId] ?? 1) - 1;
    if (currentConcurrencyRequests[nanoId] == 0) {
      currentConcurrencyRequests.remove(nanoId);
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
    final subscriptionCredits = remainingSubscriptionCredits[nanoId];
    final purchasedCredits = remainingPurchasedCredits[nanoId];

    if (subscriptionCredits == null || purchasedCredits == null) {
      // Let's get the most updated value from data base
      final accountApiUsage = await AccountApiUsage.db.findFirstRow(
        session,
        where: (p0) => p0.nanoId.equals(nanoId),
        include: AccountApiUsage.include(),
      );
      if (accountApiUsage == null) throw _noApiFound;

      remainingPurchasedCredits[nanoId] = accountApiUsage.purchasedCredits;
      remainingSubscriptionCredits[nanoId] =
          accountApiUsage.subscriptionCredits;
      return discountApiTokens(session, nanoId: nanoId);
    }

    // First, try to deduct from subscription credits
    if (subscriptionCredits > 0) {
      remainingSubscriptionCredits[nanoId] =
          (remainingSubscriptionCredits[nanoId] ?? subscriptionCredits) - 1;
      return;
    }

    if (purchasedCredits > 0) {
      remainingPurchasedCredits[nanoId] =
          (remainingPurchasedCredits[nanoId] ?? purchasedCredits) - 1;
      return;
    }

    throw _insufficientCredits;
  }

  Future<(Scrappable, ScrappableRequest)> getScrappableById(
      Session session, String scrappableId, NanoId? nanoId) async {
    final Scrappable? scrappable = await Scrappable.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(UuidValue.fromString(scrappableId)) &
          ( // If not private, allow all
              t.isPrivate.equals(false) |

                  // If private, allow only if the nanoId matches
                  (t.isPrivate.equals(true) &
                      t.apiUsageOwnerNanoId.notEquals(null) &
                      t.apiUsageOwnerNanoId.equals(nanoId))),
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
      ),
    );

    final ScrappableRequest? targetRequest = scrappable?.targetRequest;

    if (scrappable == null || targetRequest == null) {
      throw _noScrappableFound(scrappableId);
    }

    return (scrappable, targetRequest);
  }

  Future<String> getExtractRules(Session session, Scrappable scrappable,
      String? accountApiKeyString) async {
    final isTest = accountApiKeyString == null;
    final String? extractRules = isTest
        ? (await ScrappableTestResult.db.findFirstRow(
            session,
            where: (p0) => p0.scrappableId.equals(scrappable.id),
          ))
            ?.testExtractRule
        : scrappable.scrappingRules;

    if (extractRules == null || extractRules.isEmpty) {
      throw _missingExtractRules;
    }

    return extractRules;
  }

  Future<T> wrapAnalytics<T>(
    Session session,
    ApiKey? apiKey,
    Future<T> Function(void Function(Scrappable? scrappable) onSetScrapable,
            NanoId? nanoId)
        call,
  ) async {
    Scrappable? scrappable;
    final NanoId? concurrencyId = await getNanoId(session, apiKey);
    increaseConcurrency(apiKey);
    try {
      return await call((s) {
        scrappable = s;
      }, concurrencyId);
    } on _ApiError catch (error, stackTrace) {
      await _setScrappable(session, scrappable, error.status);
      session.log(
        '[${error.status.name.toUpperCase()}] ${_noApiFound.exception.title}',
        exception: error.exception,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      throw error.exception;
    } catch (error, stackTrace) {
      await _setScrappable(session, scrappable, RequestStatus.serverError);
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
      decreaseConcurrency(concurrencyId);
    }
  }

  Future<void> _setScrappable(
    Session session,
    Scrappable? scrappable,
    RequestStatus status,
  ) async {
    if (scrappable != null) {
      await session.db.transaction((transaction) async {
        final analytics = await ScrappableAnalytics.db.insertRow(
            session,
            ScrappableAnalytics(
              requestStatus: status,
              scrappableId: scrappable.id,
              scrappable: scrappable,
              requestedAt: DateTime.now(),
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
}

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
