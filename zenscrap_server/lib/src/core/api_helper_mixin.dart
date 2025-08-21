import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

mixin ApiHelperMixin {
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

  Future<void> discountApiTokens(
    Session session, {
    required String apiKey,
  }) async {
    final AccountApiKey? accountApiKey = await AccountApiKey.db.findFirstRow(
      session,
      where: (p0) => p0.apiKey.equals(apiKey),
      include: AccountApiKey.include(
        accountApiUsage: AccountApiUsage.include(
          apiKeys: AccountApiKey.includeList(),
        ),
      ),
    );
    final AccountApiUsage? accountApiUsage = accountApiKey?.accountApiUsage;
    if (accountApiKey == null || accountApiUsage == null) throw noApiFound;

    if (accountApiUsage.remainingCredits <= 0) throw insufficientCredits;
    await AccountApiUsage.db.updateRow(
      session,
      accountApiUsage.copyWith(
        remainingCredits: accountApiUsage.remainingCredits - 1,
      ),
    );
  }

  Future<(Scrappable, ScrappableRequest)> getScrappableById(
      Session session, String scrappableId) async {
    final Scrappable? scrappable =
        await Scrappable.db.findById(session, UuidValue.raw(scrappableId),
            include: Scrappable.include(
              targetRequest: ScrappableRequest.include(),
            ));

    final ScrappableRequest? targetRequest = scrappable?.targetRequest;

    if (scrappable == null || targetRequest == null) {
      throw noScrappableFound(scrappableId);
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

    if (extractRules == null || extractRules.isEmpty) throw missingExtractRules;

    return extractRules;
  }

  Future<T> wrapAnalytics<T>(Session session, Future<T> Function() call) async {
    try {
      return await call();
    } on ZenScrapException catch (error, stackTrace) {
      rethrow;
    } catch (error, stackTrace) {
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
    }
  }
}

final noApiFound = ZenScrapException(
  title: 'API Key Not Found',
  description:
      'No account API key matched the provided value (key not found in database).',
);
final insufficientCredits = throw ZenScrapException(
  title: 'Insufficient Credits',
  description:
      'Your account has no remaining credits. Purchase or allocate more credits to continue making requests.',
);
final missingExtractRules = ZenScrapException(
  title: 'Missing Extract Rules',
  description:
      'No extract rules are defined for this scrappable. Please define extraction rules before invoking this endpoint.',
);
T scrappingError<T>(String errorMessage) => throw ZenScrapException(
      title: 'Scraping Error',
      description: errorMessage,
    );

ZenScrapException noScrappableFound(String scrappableId) =>
    throw ZenScrapException(
      title: 'Scrappable Not Found',
      description:
          'The scrappable resource with id $scrappableId does not exist or has no target request configured.',
    );
