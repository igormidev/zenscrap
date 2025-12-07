import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:result_dart/result_dart.dart';
import 'package:serverpod/serverpod.dart' hide Result;
import 'package:zenscrap_server/src/core/extension/plan_tier_extension.dart';
import 'package:zenscrap_server/src/core/extension/scrapping_bee_extract_logic_extension.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/endpoints/public/marketplace_endpoint.dart';
import 'package:zenscrap_server/src/endpoints/public/scrappable_chat_session.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

typedef ApiKey = String;
typedef NanoId = String;

/// Replaces placeholder patterns {paramName} in a string with actual values from the payload
String replacePlaceholders(String? input, Map<String, dynamic> payload) {
  if (input == null || input.isEmpty || payload.isEmpty) return input ?? '';

  String result = input;

  // Create a regex pattern that matches only the keys present in the payload
  // This is more efficient than matching all {.*} patterns
  final keys = payload.keys.where((k) => k.isNotEmpty).toList();
  if (keys.isEmpty) return result;

  // Build pattern like {(?:key1|key2|key3)}
  final pattern = '{(?:${keys.map(RegExp.escape).join('|')})}';
  final placeholderPattern = RegExp(pattern);

  // Replace all matches
  result = result.replaceAllMapped(placeholderPattern, (match) {
    final fullMatch = match.group(0)!; // e.g., "{searchQuery}"
    final paramName =
        fullMatch.substring(1, fullMatch.length - 1); // Remove { and }
    final value = payload[paramName];
    return value?.toString() ?? '';
  });

  return result;
}

/// Creates a copy of ScrappingBeeExtractLogic with all placeholders replaced
ScrappingBeeExtractLogic replaceExtractLogicPlaceholders(
  ScrappingBeeExtractLogic extractLogic,
  Map<String, dynamic> payload,
) {
  return extractLogic.copyWith(
    extractRules: replacePlaceholders(extractLogic.extractRules, payload),
    jsScenario: replacePlaceholders(extractLogic.jsScenario, payload),
  );
}

mixin ApiHelperMixin {
  static final Map<NanoId, int> _currentConcurrencyRequests = {};
  static final Map<NanoId, PlanTier> _currentAccountPlanTierCache = {};
  static final Map<NanoId, CreditUsage> _currentCreditUsage = {};
  static final Map<NanoId, int> _remainingSubscriptionCredits = {};
  static final Map<NanoId, int> _remainingPurchasedCredits = {};
  static final Map<NanoId, List<ApiKey>> _apiKeysAttachedToNanoId = {};
  static final Map<NanoId, List<ScrappableId>> _allowedScrappableIdsToUse = {};
  static final Map<ScrappableId, Scrappable> _scrappables = {};
  static final Map<ScrappableId,
      Map<NanoId, Map<ApiKey, List<AnalyticsPayload>>>> _pendingAnalytics = {};

  static void resetNanoId(NanoId nanoId) {
    _allowedScrappableIdsToUse.remove(nanoId);
    _currentConcurrencyRequests.remove(nanoId);
    _currentAccountPlanTierCache.remove(nanoId);
    _currentCreditUsage.remove(nanoId);
    _remainingSubscriptionCredits.remove(nanoId);
    _remainingPurchasedCredits.remove(nanoId);
    _apiKeysAttachedToNanoId.remove(nanoId);
  }

  Future<({NanoId? nanoId, Scrappable scrappable, PlanTier? planTier})>
      setAllDependencies(
    Session session,
    ScrappableId scrappableId,
    ApiKey? apiKey,
  ) async {
    final Scrappable? cacheScrappable = _scrappables[scrappableId];
    String? nanoId;
    if (apiKey != null) {
      final splitted = apiKey.split('::');
      if (splitted.length != 2) throw _invalidApiKeyFormat;
      nanoId = splitted[0];
    }

    PlanTier? cachePlanTier =
        nanoId == null ? null : _currentAccountPlanTierCache[nanoId];

    if (apiKey == null && cacheScrappable != null) {
      return (
        nanoId: null,
        scrappable: cacheScrappable,
        planTier: cachePlanTier,
      );
    }
    if (apiKey != null && nanoId != null) {
      if (cachePlanTier != null &&
          _currentCreditUsage.containsKey(nanoId) &&
          _apiKeysAttachedToNanoId[nanoId]?.contains(apiKey) == true &&
          _allowedScrappableIdsToUse[nanoId]?.contains(scrappableId) == true &&
          cacheScrappable != null &&
          _pendingAnalytics[scrappableId]?[nanoId]?[apiKey] != null) {
        final cachePlanTier = _currentAccountPlanTierCache[nanoId];
        if (cachePlanTier == null) throw _invalidApiKey;
        return (
          nanoId: nanoId,
          scrappable: cacheScrappable,
          planTier: cachePlanTier
        );
      }

      final accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (p0) =>
            p0.accountApiUsage.nanoId.equals(nanoId) &
            p0.accountApiUsage.apiKeys.any(
                (key) => key.apiKey.equals(apiKey) & key.isActive.equals(true)),
        include: AccountInfo.include(
          accountApiUsage: AccountApiUsage.include(
            creditUsage: CreditUsage.include(),
          ),
        ),
      );
      final PlanTier? newPlanTier = accountInfo?.planTier;
      final CreditUsage? creditUsage =
          accountInfo?.accountApiUsage?.creditUsage;
      if (newPlanTier == null) throw _invalidApiKey;
      if (creditUsage == null) throw _invalidApiKey;
      _currentAccountPlanTierCache[nanoId] = newPlanTier;
      _currentCreditUsage[nanoId] = creditUsage;
      cachePlanTier = newPlanTier;
    }

    final Scrappable? scrappable = await Scrappable.db.findFirstRow(
      session,
      where: (t) =>
          t.id.equals(scrappableId) &
          (t.apiUsageOwnerNanoId.equals(null) |

              // If not private, allow all
              t.willHideFromMarketplace.equals(false) |

              // If private, allow only if the nanoId matches
              (t.willHideFromMarketplace.equals(true) &
                  t.apiUsageOwnerNanoId.notEquals(null) &
                  t.apiUsageOwnerNanoId.equals(nanoId))),
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
      ),
    );
    final ScrappableRequest? targetRequest = scrappable?.targetRequest;
    final ScrappingBeeExtractLogic? extractRules =
        scrappable?.scrappingBeeExtractRules;
    if (scrappable == null || targetRequest == null || extractRules == null) {
      throw _noScrappableFound(scrappableId.toString());
    }

    // Check if scrappable is deleted
    if (scrappable.isDeleted == true) {
      throw _noScrappableFound(scrappableId.toString());
    }

    _scrappables[scrappableId] = scrappable;

    if (nanoId != null && apiKey != null) {
      _pendingAnalytics[scrappableId]?[nanoId]?[apiKey] ??= [];
      if (_allowedScrappableIdsToUse[nanoId] == null) {
        _allowedScrappableIdsToUse[nanoId] = [scrappableId];
      } else if (!_allowedScrappableIdsToUse[nanoId]!.contains(scrappableId)) {
        _allowedScrappableIdsToUse[nanoId]!.add(scrappableId);
      }
      if (!_pendingAnalytics.containsKey(scrappableId)) {
        _pendingAnalytics[scrappableId] = {};
      }
      if (!_pendingAnalytics[scrappableId]!.containsKey(nanoId)) {
        _pendingAnalytics[scrappableId]![nanoId] = {};
      }
      if (!_pendingAnalytics[scrappableId]![nanoId]!.containsKey(apiKey)) {
        _pendingAnalytics[scrappableId]![nanoId]![apiKey] = [];
      }
      if (_apiKeysAttachedToNanoId[nanoId] == null) {
        _apiKeysAttachedToNanoId[nanoId] = [apiKey];
      } else if (!_apiKeysAttachedToNanoId[nanoId]!.contains(apiKey)) {
        _apiKeysAttachedToNanoId[nanoId]!.add(apiKey);
      }
    }

    return (nanoId: nanoId, scrappable: scrappable, planTier: cachePlanTier);
  }

  void increaseConcurrency(NanoId? nanoId, PlanTier? planTier) {
    if (nanoId == null) return;
    final maxConcurrentRequests =
        planTier?.numberOfConcurrentRequestsAllowedByPlan;
    if (maxConcurrentRequests == null) throw _invalidApiKey;

    final canIncrease =
        (_currentConcurrencyRequests[nanoId] ?? 0) + 1 <= maxConcurrentRequests;
    if (!canIncrease) throw _maxConcurrencyReached(maxConcurrentRequests);

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
      Map<String, dynamic> payload, ScrappableRequest scrappableRequest) {
    String targetUrl = scrappableRequest.url;

    // First, add the path parameters
    for (final String pathParam in scrappableRequest.pathParams) {
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
        in scrappableRequest.queryParams.entries) {
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
    required int creditCost,
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
      return discountApiTokens(session, nanoId: nanoId, creditCost: creditCost);
    }

    // Check if we have enough credits in total
    final totalCredits = subscriptionCredits + purchasedCredits;
    if (totalCredits < creditCost) {
      throw _insufficientCredits;
    }

    // First, try to deduct from subscription credits
    if (subscriptionCredits >= creditCost) {
      _remainingSubscriptionCredits[nanoId] =
          (_remainingSubscriptionCredits[nanoId] ?? subscriptionCredits) -
              creditCost;
      return;
    }

    // If subscription credits are not enough, use them all and deduct the rest from purchased credits
    if (subscriptionCredits > 0) {
      final remainingCost = creditCost - subscriptionCredits;
      _remainingSubscriptionCredits[nanoId] = 0;
      _remainingPurchasedCredits[nanoId] =
          (_remainingPurchasedCredits[nanoId] ?? purchasedCredits) -
              remainingCost;
      return;
    }

    // No subscription credits, deduct all from purchased credits
    if (purchasedCredits >= creditCost) {
      _remainingPurchasedCredits[nanoId] =
          (_remainingPurchasedCredits[nanoId] ?? purchasedCredits) - creditCost;
      return;
    }

    throw _insufficientCredits;
  }

  Future<ScrappingBeeExtractLogic> _getExtractRules(Session session,
      Scrappable scrappable, String? accountApiKeyString) async {
    final isTest = accountApiKeyString == null;
    if (isTest) {
      final testSessionExtractRule = getTestExtractRules(scrappable.id!);
      if (testSessionExtractRule == null) {
        throw _noActiveTestSessionFinded;
      }

      return testSessionExtractRule;
    }

    final ScrappingBeeExtractLogic? extractRules =
        scrappable.scrappingBeeExtractRules;

    if (extractRules == null) throw _missingExtractRules;

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
    ScrappableId scrappableId,
    ApiKey? apiKey,
    Map<String, dynamic> payload,
    Future<T> Function(NanoId? nanoId, Scrappable scrappable) call,
  ) async {
    final now = DateTime.now();
    final String stringifiedPayload = jsonEncode(payload);
    Scrappable scrappable;
    NanoId? nanoId;
    try {
      final result = await setAllDependencies(session, scrappableId, apiKey);
      nanoId = result.nanoId;
      scrappable = result.scrappable;
      increaseConcurrency(
        nanoId,
        result.planTier,
      );
      final doesApiKeyExists = checkIdApiKeyExists(nanoId, apiKey);
      // Will throw if not exists and cache result if exist so new calls to db are not needed each time
      if (!doesApiKeyExists) {
        await garanteeApiKeyExists(session, nanoId, apiKey);
      }

      return await call(nanoId, scrappable);
    } on ApiError catch (error, stackTrace) {
      session.log(
        '[${error.status.name.toUpperCase()}] ${_noApiFound.exception.title}',
        exception: error.exception,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(apiKey) ==
          true) {
        _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
          AnalyticsPayload(
            time: now,
            status: error.status,
            stringifiedPayload: stringifiedPayload,
            title: error.exception.title,
            description: error.exception.description,
            errorObjectAsString: error.exception.toString(),
            errorStackTraceAsString: stackTrace.toString(),
          ),
        );
      }
      rethrow;
    } on ZenScrapException catch (error, stackTrace) {
      // Convert ZenScrapException to ApiError to preserve error details
      final apiError = ApiError(RequestStatus.clientError, error);
      session.log(
        '[${apiError.status.name.toUpperCase()}] ${error.title}',
        exception: error,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(apiKey) ==
          true) {
        _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
          AnalyticsPayload(
            time: now,
            status: apiError.status,
            stringifiedPayload: stringifiedPayload,
            title: error.title,
            description: error.description,
            errorObjectAsString: error.toString(),
            errorStackTraceAsString: stackTrace.toString(),
          ),
        );
      }
      throw apiError;
    } catch (error, stackTrace) {
      session.log(
        'An unknown error occurred in api',
        exception: error,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
      if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(apiKey) ==
          true) {
        _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
          AnalyticsPayload(
            time: now,
            status: RequestStatus.serverError,
            stringifiedPayload: stringifiedPayload,
            title: 'Unexpected Error',
            description: 'An unexpected error occurred',
            errorObjectAsString: error.toString(),
            errorStackTraceAsString: stackTrace.toString(),
          ),
        );
      }
      // Handle any other exceptions
      throw ZenScrapException(
        title: 'Unexpected Error',
        description: 'An unexpected error occurred: ${error.toString()}',
      );
    } finally {
      decreaseConcurrency(nanoId);
    }
  }

  /// Gets the current credit information for a nanoId
  /// Returns null if nanoId is null (test requests)
  Map<String, dynamic>? _getCreditInfo(NanoId? nanoId, int creditCost) {
    if (nanoId == null) return null;

    final subscriptionCredits = _remainingSubscriptionCredits[nanoId] ?? 0;
    final purchasedCredits = _remainingPurchasedCredits[nanoId] ?? 0;
    final totalCredits = subscriptionCredits + purchasedCredits;

    return {
      'spent': creditCost,
      'remaining': {
        'subscription': subscriptionCredits,
        'purchased': purchasedCredits,
        'total': totalCredits,
      },
    };
  }

  AsyncResultDart<Map<String, dynamic>, ApiError> callFunc(
    Session session, {
    required int scrappableId,
    required HttpRequest request,
    String? apiKey,
    required Map<String, dynamic> payload,
  }) async {
    final String stringifiedPayload = jsonEncode(payload);
    try {
      return await wrapAnalytics(session, scrappableId, apiKey, payload,
          (nanoId, scrappable) async {
        // final (Scrappable scrappable, ScrappableRequest targetRequest) =
        //     await getScrappableById(session, scrappableId, nanoId);
        // setScrappableCallback(scrappable);
        throwErrorIfIsATestRequestAndTestTimeExpired(apiKey, scrappable);

        final isTestRequest = apiKey == null;

        final ScrappingBeeExtractLogic extractRules =
            await _getExtractRules(session, scrappable, apiKey);

        // Calculate the actual credit cost for this extraction using the totalCreditCost getter
        final creditCost = extractRules.totalCreditCost;

        // Discount the actual cost from the account
        await discountApiTokens(session,
            nanoId: nanoId, creditCost: creditCost);

        // Get the scrappable request - use cached version for test requests
        final ScrappableRequest scrappableRequest = isTestRequest
            ? (getScrappableRequest(scrappable.id!) ??
                scrappable.targetRequest!)
            : scrappable.targetRequest!;

        final String targetUrl = composeUrl(payload, scrappableRequest);

        // For test requests, use fetchHtmlAndScreenshotWithLogic (heavier, includes screenshot)
        // For production requests, use extractByRulesWithLogic (lighter, no screenshot)
        if (isTestRequest) {
          // Get the current reference test data from cache
          final ReferenceTestData? currentTestData =
              getReferenceTestData(scrappable.id!);

          if (currentTestData == null) {
            return ApiError(
              RequestStatus.serverError,
              ZenScrapException(
                title: 'Test Data Not Found',
                description:
                    'No reference test data found for this scrappable session.',
              ),
            ).toFailure();
          }

          // Replace placeholders in extract logic before calling ScrapingBee
          final extractLogicWithReplacedPlaceholders =
              replaceExtractLogicPlaceholders(extractRules, payload);

          final ExtractFullDataByRule extractResponse =
              await scrappingBee.fetchHtmlAndScreenshotWithLogic(
            targetUrl: targetUrl,
            scrappingBeeExtractLogic: extractLogicWithReplacedPlaceholders,
          );

          return extractResponse.when(
              withData: (scrapedData, html, pageFullscreenScreenshot) async {
            final responseJson = jsonEncode(scrapedData);
            // Track success analytics
            if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(apiKey) ==
                true) {
              _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
                AnalyticsPayload(
                  time: DateTime.now(),
                  status: RequestStatus.success,
                  stringifiedPayload: stringifiedPayload,
                  stringifiedResponse: responseJson,
                ),
              );
            }

            // Create ByteTestData with the new HTML and screenshot
            final Uint8List htmlBytes = utf8.encode(html);
            final ByteData htmlByteData = ByteData.view(htmlBytes.buffer);
            final ByteData screenshotByteData =
                ByteData.view(pageFullscreenScreenshot.buffer);

            ByteTestData byteTestData = currentTestData.byteData?.copyWith(
                  referenceHtmlPage: htmlByteData,
                  referenceSiteScreenshot: screenshotByteData,
                ) ??
                ByteTestData(
                  referenceHtmlPage: htmlByteData,
                  referenceSiteScreenshot: screenshotByteData,
                );

            // Create new ReferenceTestData with updated data
            ReferenceTestData newReferenceTestData = currentTestData.copyWith(
              scrapResultJson: jsonEncode(scrapedData),
              byteData: byteTestData,
              referenceLinkUsed: targetUrl,
            );

            // Update the cache with new reference test data
            updateTestReferenceData(scrappable.id!, newReferenceTestData);

            // Send success notification to chat session with updated test data
            sendSystemMessageToScrappableSession(
              scrappableId: scrappable.id!,
              response: TestEndpointCalledSuccessResponse(
                role: PromptRole.system,
                expectsFollowUp: false, // Test result notification, no follow-up
                inputPayload: stringifiedPayload,
                responseData: jsonEncode(scrapedData),
                timestamp: DateTime.now(),
                referenceTestData: newReferenceTestData,
              ),
            );

            // Create response with scraped data and credit information
            final response = <String, dynamic>{
              'credits': _getCreditInfo(nanoId, creditCost),
              'data': scrapedData,
            };
            return response.toSuccess();
          }, error: (errorMessage) {
            // Track ScrapingBee errors separately
            if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(apiKey) ==
                true) {
              _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
                AnalyticsPayload(
                  time: DateTime.now(),
                  status: RequestStatus.failedAtScrappingBee,
                  stringifiedPayload: stringifiedPayload,
                  title: 'Scraping Error',
                  description: errorMessage,
                ),
              );
            }

            // Send error notification to chat session
            sendSystemMessageToScrappableSession(
              scrappableId: scrappable.id!,
              response: TestEndpointCalledErrorResponse(
                role: PromptRole.system,
                expectsFollowUp: false, // Test error notification, no follow-up
                errorTitle: 'Scraping Error',
                errorDescription: errorMessage,
                inputPayload: stringifiedPayload,
                timestamp: DateTime.now(),
              ),
            );

            return ApiError(
                RequestStatus.failedAtScrappingBee,
                ZenScrapException(
                  title: 'Scraping Error',
                  description: errorMessage,
                )).toFailure();
          });
        } else {
          // Production request - use lighter extraction without screenshot
          // Replace placeholders in extract logic before calling ScrapingBee
          final extractLogicWithReplacedPlaceholders =
              replaceExtractLogicPlaceholders(extractRules, payload);

          final ExtractDataByRule extractResponse =
              await scrappingBee.extractByRulesWithLogic(
            targetUrl: targetUrl,
            scrappingBeeExtractLogic: extractLogicWithReplacedPlaceholders,
          );

          return extractResponse.when(withData: (scrapedData) {
            final responseJson = jsonEncode(scrapedData);
            // Track success analytics
            if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(apiKey) ==
                true) {
              _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
                AnalyticsPayload(
                  time: DateTime.now(),
                  status: RequestStatus.success,
                  stringifiedPayload: stringifiedPayload,
                  stringifiedResponse: responseJson,
                ),
              );
            }

            // Create response with scraped data and credit information
            final response = <String, dynamic>{
              'credits': _getCreditInfo(nanoId, creditCost),
              'data': scrapedData,
            };
            return response.toSuccess();
          }, error: (errorMessage) {
            // Track ScrapingBee errors separately
            if (_pendingAnalytics[scrappableId]?[nanoId]?.containsKey(apiKey) ==
                true) {
              _pendingAnalytics[scrappableId]![nanoId]![apiKey]!.add(
                AnalyticsPayload(
                  time: DateTime.now(),
                  status: RequestStatus.failedAtScrappingBee,
                  stringifiedPayload: stringifiedPayload,
                  title: 'Scraping Error',
                  description: errorMessage,
                ),
              );
            }

            return ApiError(
                RequestStatus.failedAtScrappingBee,
                ZenScrapException(
                  title: 'Scraping Error',
                  description: errorMessage,
                )).toFailure();
          });
        }
      });
    } on ZenScrapException catch (error) {
      return ApiError(
        RequestStatus.serverError,
        error,
      ).toFailure();
    } on ApiError catch (error) {
      return error.toFailure();
    } catch (error, stackTrace) {
      session.log(
        'Unexpected error in ScrappableApiRoute',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
      return ApiError(
        RequestStatus.serverError,
        ZenScrapException(
          title: 'Unexpected Error',
          description: 'An unexpected error occurred: ${error.toString()}',
        ),
      ).toFailure();
    }
  }
}

ApiError _noCreditUsageModelFound(ApiKey apiKey) => ApiError(
      RequestStatus.clientError,
      ZenScrapException(
        title: 'No Credit Usage Model Found',
        description:
            'No credit usage model found for the provided API key: $apiKey.\n'
            'It could be that the account was deleted or has no plan assigned - check in your api key tab on ZenScrap site.',
      ),
    );
ApiError _apiKeyNotFound(ApiKey apiKey) => ApiError(
      RequestStatus.clientError,
      ZenScrapException(
        title: 'Valid API Key Not Found',
        description:
            'There is no active API key matching the provided value: $apiKey.\n'
            'It could be that the key was deleted or deactivated - check in your api key tab on ZenScrap site.',
      ),
    );
final _noActiveTestSessionFinded = ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'No Active Test Session Found',
    description:
        'There is no active test session found for the provided scrappable.',
  ),
);
final _testPeriodExpired = ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'Test Period Expired',
    description:
        'The test period for this scrappable has expired.\nYou can:\n- Start a new testing session, that will start a new test period\n- Call the production endpoint with a valid API key if you have an account',
  ),
);
final _noApiFound = ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'API Key Not Found',
    description:
        'No account API key matched the provided value (key not found in database).',
  ),
);
// final _scrappableDataDissasociated = ApiError(
//   RequestStatus.serverError,
//   ZenScrapException(
//     title: 'Scrappable Data Dissasociated',
//     description:
//         'The scrappable data is dissasociated the current stack. This is a rare error that can happen after a server migration - your next scrapping request should work fine. If the error persists, contact support.',
//   ),
// );
final _insufficientCredits = ApiError(
    RequestStatus.insufficientCredits,
    ZenScrapException(
      title: 'Insufficient Credits',
      description:
          'Your account has no remaining credits. Purchase or allocate more credits to continue making requests.',
    ));
final _missingExtractRules = ApiError(
    RequestStatus.clientError,
    ZenScrapException(
      title: 'Missing Extract Rules',
      description:
          'No extract rules are defined for this scrappable. Please define extraction rules before invoking this endpoint.',
    ));
final _invalidApiKey = ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'Invalid API Key',
    description: 'The provided API key does not have a user account.',
  ),
);
ApiError _maxConcurrencyReached(int maxQuantityOfParallelRequests) => ApiError(
    RequestStatus.maxConcurrencyExceeded,
    ZenScrapException(
      title: 'Concurrency Limit Exceeded',
      description:
          '''You have reached the maximum number of concurrent requests allowed for your plan tier.'''
          ''' (Max allowed concurrent requests: $maxQuantityOfParallelRequests)''',
    ));
ApiError _noScrappableFound(String scrappableId) => ApiError(
    RequestStatus.clientError,
    ZenScrapException(
      title: 'Scrappable Not Found',
      description:
          'The scrappable resource with id $scrappableId does not exist or has no target request configured.',
    ));

final _invalidApiKeyFormat = ApiError(
  RequestStatus.clientError,
  ZenScrapException(
    title: 'Invalid API Key Format',
    description: 'API Key must be in the format "nanoId::apiKey".',
  ),
);

class ApiError {
  final RequestStatus status;
  final ZenScrapException exception;

  ApiError(this.status, this.exception);
}

class AnalyticsPayload {
  final RequestStatus status;
  final DateTime time;
  final String? title;
  final String? description;
  final String? errorObjectAsString;
  final String? errorStackTraceAsString;
  final String stringifiedPayload;

  /// The JSON-encoded response data (only present on successful requests)
  final String? stringifiedResponse;

  const AnalyticsPayload({
    required this.time,
    required this.status,
    required this.stringifiedPayload,
    this.title,
    this.description,
    this.errorObjectAsString,
    this.errorStackTraceAsString,
    this.stringifiedResponse,
  });
}

class PeriodicSetRequestsAnalytics extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? _) async {
    Map<ScrappableId, Map<NanoId, Map<ApiKey, List<AnalyticsPayload>>>>
        pendingAnalytics = {...ApiHelperMixin._pendingAnalytics};
    ApiHelperMixin._pendingAnalytics.clear();

    for (final entry in pendingAnalytics.entries) {
      final scrappableId = entry.key;
      final scrappable = ApiHelperMixin._scrappables[scrappableId];
      for (final requestEntry in entry.value.entries) {
        final nanoId = requestEntry.key;
        final apiKeys = requestEntry.value;
        for (final apiKeyEntry in apiKeys.entries) {
          final apiKey = apiKeyEntry.key;
          final analyticsPayload = apiKeyEntry.value;

          await _setScrappableAnalytics(
            session,
            scrappable: scrappable,
            apiKey: apiKey,
            nanoId: nanoId,
            items: analyticsPayload,
          );
        }
      }
    }

    // Schedule the next execution
    await session.serverpod.futureCallWithDelay(
      'periodicSetRequestsAnalytics',
      null,
      Duration(minutes: 5), // Adjust interval as needed
      identifier: 'periodicSetRequestsAnalytics',
    );
  }
}

class PeriodicCleanupOldAnalyticsDetails extends FutureCall {
  @override
  Future<void> invoke(Session session, SerializableModel? _) async {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      // Delete all AnalyticsRequestDetails older than 7 days
      final deletedCount = await AnalyticsRequestDetails.db.deleteWhere(
        session,
        where: (t) => t.timeStamp < sevenDaysAgo,
      );

      session.log(
        'Cleaned up $deletedCount old analytics details (older than 7 days)',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      session.log(
        'Error during periodic cleanup of analytics details',
        exception: e,
        stackTrace: stackTrace,
        level: LogLevel.error,
      );
    }

    // Schedule the next execution in 1 hour
    await session.serverpod.futureCallWithDelay(
      'periodicCleanupOldAnalyticsDetails',
      null,
      const Duration(hours: 1),
      identifier: 'periodicCleanupOldAnalyticsDetails',
    );
  }
}

Future<void> _setScrappableAnalytics(
  Session session, {
  Scrappable? scrappable,
  ApiKey? apiKey,
  NanoId? nanoId,
  required List<AnalyticsPayload> items,
}) async {
  if (scrappable != null && apiKey != null && nanoId != null) {
    final CreditUsage? credit = ApiHelperMixin._currentCreditUsage[nanoId];
    if (credit == null) {
      session.log(
        'Credit usage not found for nanoId $nanoId when trying to log scrappable analytics',
        level: LogLevel.error,
      );
      throw _noCreditUsageModelFound(apiKey);
    }

    await session.db.transaction((transaction) async {
      final newCredit = credit.copyWith(
        subscriptionCredits:
            ApiHelperMixin._remainingSubscriptionCredits[nanoId],
        purchasedCredits: ApiHelperMixin._remainingPurchasedCredits[nanoId],
      );
      await CreditUsage.db
          .updateRow(session, newCredit, transaction: transaction);

      // First, create all AnalyticsRequestDetails
      final detailsList = await AnalyticsRequestDetails.db.insert(
        session,
        items.map((e) {
          return AnalyticsRequestDetails(
            timeStamp: e.time,
            title: e.title,
            description: e.description,
            errorObjectAsString: e.errorObjectAsString,
            errorStackTraceAsString: e.errorStackTraceAsString,
            stringifiedPayload: e.stringifiedPayload,
            stringifiedResponse: e.stringifiedResponse,
          );
        }).toList(),
        transaction: transaction,
      );

      // Then create ScrappableAnalytics with detailsId set
      final analytics = await ScrappableAnalytics.db.insert(
          session,
          List.generate(items.length, (i) {
            return ScrappableAnalytics(
              requestStatus: items[i].status,
              scrappableId: scrappable.id!,
              scrappable: scrappable,
              requestedAt: items[i].time,
              attachedApiKey: apiKey,
              attachedNanoId: nanoId,
              detailsId: detailsList[i].id,
            );
          }),
          transaction: transaction);

      await Scrappable.db.attach.scrappableAnalytics(
        session,
        scrappable,
        analytics,
        transaction: transaction,
      );
    });
  }
}
