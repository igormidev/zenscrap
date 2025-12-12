import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateCloneScrappableEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Scrappable> cloneFromMarketplace(
    Session session, {
    required int scrappableId,
    SupportedLanguage language = SupportedLanguage.en,
  }) async {
    final authenticationInfo = session.authenticated;
    if (authenticationInfo == null) {
      throw _authenticationFailed(language);
    }

    final authenticatedUserId = authenticationInfo.userId;

    // Get account info with plan tier
    final accountInfo = await AccountInfo.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(authenticatedUserId),
      include: AccountInfo.include(
        accountApiUsage: AccountApiUsage.include(),
      ),
    );

    if (accountInfo == null) {
      throw _accountNotFound(language);
    }

    // Check if user has unlimited plan
    if (accountInfo.planTier != PlanTier.ultra) {
      throw _upgradeRequiredClone(language);
    }

    // Get the source scrappable to clone
    final sourceScrappable = await Scrappable.db.findById(
      session,
      scrappableId,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
        referenceTestData: ReferenceTestData.include(
          byteData: ByteTestData.include(),
        ),
      ),
    );

    if (sourceScrappable == null) {
      throw _scrappableNotFoundClone(language);
    }

    // Verify it's a public scrappable
    if (sourceScrappable.willHideFromMarketplace) {
      throw _scrappablePrivateCannotClone(language);
    }

    // Transaction: clone request, test data, reference data, and scrappable atomically
    Scrappable? clonedScrappable;
    await session.db.transaction<void>((transaction) async {
      // Clone the ScrappableRequest
      ScrappableRequest clonedRequest = ScrappableRequest(
        url: sourceScrappable.targetRequest!.url,
        queryParams: sourceScrappable.targetRequest!.queryParams,
        queryParamsNotRelatedToUrl: sourceScrappable.targetRequest!.queryParamsNotRelatedToUrl,
        pathParams: sourceScrappable.targetRequest!.pathParams,
      );
      clonedRequest = await ScrappableRequest.db.insertRow(
        session,
        clonedRequest,
        transaction: transaction,
      );

      // Clone ByteTestData
      final ByteTestData testData = await ByteTestData.db.insertRow(
        session,
        ByteTestData(
          referenceHtmlPage:
              sourceScrappable.referenceTestData!.byteData!.referenceHtmlPage,
          referenceSiteScreenshot: sourceScrappable
              .referenceTestData!.byteData!.referenceSiteScreenshot,
        ),
        transaction: transaction,
      );

      // Clone the ReferenceTestData
      final clonedTestData = ReferenceTestData(
        referenceLinkUsed:
            sourceScrappable.referenceTestData!.referenceLinkUsed,
        referenceQueryParametersJson:
            sourceScrappable.referenceTestData!.referenceQueryParametersJson,
        byteDataId: testData.id!,
        byteData: testData,
      );
      await ReferenceTestData.db.insertRow(
        session,
        clonedTestData,
        transaction: transaction,
      );

      await ReferenceTestData.db.attachRow.byteData(
        session,
        clonedTestData,
        testData,
        transaction: transaction,
      );

      final ScrappingBeeExtractLogic scrappingBeeExtractLogic =
          await ScrappingBeeExtractLogic.db.insertRow(
              session,
              ScrappingBeeExtractLogic(
                extractRules:
                    sourceScrappable.scrappingBeeExtractRules!.extractRules,
                jsScenario:
                    sourceScrappable.scrappingBeeExtractRules!.jsScenario,
                renderJs: sourceScrappable.scrappingBeeExtractRules!.renderJs,
                wait: sourceScrappable.scrappingBeeExtractRules!.wait,
                waitFor: sourceScrappable.scrappingBeeExtractRules!.waitFor,
                waitBrowser:
                    sourceScrappable.scrappingBeeExtractRules!.waitBrowser,
                premiumProxy:
                    sourceScrappable.scrappingBeeExtractRules!.premiumProxy,
                stealthProxy:
                    sourceScrappable.scrappingBeeExtractRules!.stealthProxy,
                countryCode:
                    sourceScrappable.scrappingBeeExtractRules!.countryCode,
                sessionId: sourceScrappable.scrappingBeeExtractRules!.sessionId,
                customGoogle:
                    sourceScrappable.scrappingBeeExtractRules!.customGoogle,
              ),
              transaction: transaction);

      final now = DateTime.now();

      // Create the cloned scrappable
      clonedScrappable = Scrappable(
        accountId: accountInfo.id,
        apiUsageOwnerNanoId: accountInfo.accountApiUsage?.nanoId,
        createdAt: now,
        generalInfosUpdatedAt: now,
        extractRulesUpdatedAt: now,
        name: '${sourceScrappable.name} (Copy)',
        description: sourceScrappable.description,
        testEndpointAvailableUntil: null,
        willHideFromMarketplace: false,
        isDeleted: false,
        targetRequestId: clonedRequest.id!,
        targetRequest: clonedRequest,
        referenceTestDataId: clonedTestData.id!,
        referenceTestData: clonedTestData,
        category: sourceScrappable.category,
        scrappingBeeExtractRules: scrappingBeeExtractLogic,
      );
      clonedScrappable = await Scrappable.db.insertRow(
        session,
        clonedScrappable!,
        transaction: transaction,
      );
      await Scrappable.db.attachRow.targetRequest(
          session, clonedScrappable!, clonedRequest,
          transaction: transaction);
      await Scrappable.db.attachRow.referenceTestData(
          session, clonedScrappable!, clonedTestData,
          transaction: transaction);
      await Scrappable.db.attachRow.scrappingBeeExtractRules(
          session, clonedScrappable!, scrappingBeeExtractLogic,
          transaction: transaction);

      // Create default AutoFixConfig for the cloned scrappable
      final autoFixConfig = await AutoFixConfig.db.insertRow(
        session,
        AutoFixConfig(
          scrappableId: clonedScrappable!.id!,
          enabled: true,
          consecutiveErrorThreshold: 100,
          currentConsecutiveErrors: 0,
          inProgress: false,
          attemptCount: 0,
          preferredAiModel: null, // Auto mode
        ),
        transaction: transaction,
      );
      await Scrappable.db.attachRow.autoFixConfig(
          session, clonedScrappable!, autoFixConfig,
          transaction: transaction);
    });

    // Return the cloned scrappable with all relations (after commit)
    final result = await Scrappable.db.findById(
      session,
      clonedScrappable!.id!,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        referenceTestData: ReferenceTestData.include(
          byteData: ByteTestData.include(),
        ),
      ),
    );

    return result!;
  }
}

// ============================================================================
// Error-returning functions
// ============================================================================

ZenScrapException _authenticationFailed(SupportedLanguage lang) =>
    createTranslatedException('authentication_failed', lang);

ZenScrapException _accountNotFound(SupportedLanguage lang) =>
    createTranslatedException('account_not_found', lang);

ZenScrapException _upgradeRequiredClone(SupportedLanguage lang) =>
    createTranslatedException('upgrade_required_clone', lang);

ZenScrapException _scrappableNotFoundClone(SupportedLanguage lang) =>
    createTranslatedException('scrappable_not_found_clone', lang);

ZenScrapException _scrappablePrivateCannotClone(SupportedLanguage lang) =>
    createTranslatedException('scrappable_private_cannot_clone', lang);
