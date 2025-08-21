import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/server.dart';
import 'package:zenscrap_server/src/core/scraping_bee.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class HandleApiScrapRequestEndpoint extends Endpoint {
  Future<Map<String, dynamic>> prod(
    Session session, {
    required String scrappableId,
    required String accountApiKey,
    required Map<String, dynamic> payload,
  }) async {
    return _callFunc(
      session: session,
      accountApiKeyString: accountApiKey,
      payload: payload,
      scrappableId: scrappableId,
    );
  }

  Future<Map<String, dynamic>> test(
    Session session, {
    required String scrappableId,
    required Map<String, dynamic> payload,
  }) async {
    return _callFunc(
      session: session,
      accountApiKeyString: null,
      payload: payload,
      scrappableId: scrappableId,
    );
  }

  Future<Map<String, dynamic>> _callFunc({
    required Session session,
    required String scrappableId,
    required String? accountApiKeyString,
    required Map<String, dynamic> payload,
  }) async {
    final bool isTest = accountApiKeyString == null;
    final AccountApiKey? accountApiKey = isTest
        ? null
        : await AccountApiKey.db.findFirstRow(
            session,
            where: (p0) => p0.apiKey.equals(accountApiKeyString),
            include: AccountApiKey.include(
              accountApiUsage: AccountApiUsage.include(
                apiKeys: AccountApiKey.includeList(),
              ),
            ),
          );
    final AccountApiUsage? accountApiUsageData =
        isTest ? null : accountApiKey?.accountApiUsage;

    if (!isTest) {
      if (accountApiKey == null) {
        throw ZenScrapException(
          title: 'API Key Not Found',
          description:
              'No account API key matched the provided value (key not found in database).',
        );
      }
      if (accountApiUsageData == null) {
        throw ZenScrapException(
          title: 'Invalid API Key',
          description:
              'The provided API key is invalid or its usage record is missing. Please verify the key.',
        );
      }
    }

    final Scrappable? scrappable =
        await Scrappable.db.findById(session, UuidValue.raw(scrappableId),
            include: Scrappable.include(
              targetRequest: ScrappableRequest.include(),
            ));

    final ScrappableRequest? targetRequest = scrappable?.targetRequest;

    if (!isTest) {
      if (accountApiUsageData!.remainingCredits <= 0) {
        throw ZenScrapException(
          title: 'Insufficient Credits',
          description:
              'Your account has no remaining credits. Purchase or allocate more credits to continue making requests.',
        );
      }
    }

    if (scrappable == null || targetRequest == null) {
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description:
            'The scrappable resource with id $scrappableId does not exist or has no target request configured.',
      );
    }
    if (scrappable.isActive == false && isTest == false) {
      throw ZenScrapException(
        title: 'Scrappable Inactive',
        description:
            'The scrappable resource is inactive and cannot be used for production requests. Reactivate it before retrying.',
      );
    }
    final isTestExpirated = isTest &&
        scrappable.testEndpointAvailableUntil != null &&
        scrappable.testEndpointAvailableUntil!.isBefore(DateTime.now());

    if (isTestExpirated) {
      throw ZenScrapException(
        title: 'Test Endpoint Expired',
        description:
            'The test endpoint for this scrappable expired on ${scrappable.testEndpointAvailableUntil}.',
      );
    }

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

    final String? scrapExtractRules = isTest
        ? (await ScrappableTestResult.db.findFirstRow(
            session,
            where: (p0) => p0.scrappableId.equals(scrappable.id),
          ))
            ?.testExtractRule
        : scrappable.scrappingRules;
    if (scrapExtractRules == null || scrapExtractRules.isEmpty) {
      throw ZenScrapException(
        title: 'Missing Extract Rules',
        description:
            'No extract rules are defined for this scrappable. Please define extraction rules before invoking this endpoint.',
      );
    }

    final ExtractDataByRule result = await scrapingBee.extractByRules(
      targetUrl: targetUrl,
      extractRules: scrapExtractRules,
    );

    return result.when(
      withData: (result) => result,
      error: (errorMessage) => throw ZenScrapException(
        title: 'Scraping Error',
        description: errorMessage,
      ),
    );
  }

  Future<void> _logApiKeyUsage(
    Session session,
    Scrappable scrappable,
    RequestStatus requestStatus,
    AccountApiUsage? apiUsage,
    AccountApiKey? apiKey,
  ) async {
    await session.db.transaction((transaction) async {
      if (apiUsage != null) {
        await AccountApiUsage.db.updateRow(
          session,
          apiUsage.copyWith(
            remainingCredits: apiUsage.remainingCredits - 1,
          ),
          transaction: transaction,
        );
      }
      final analytics = await ScrappableAnalytics.db.insertRow(
          session,
          ScrappableAnalytics(
            requestStatus: requestStatus,
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
