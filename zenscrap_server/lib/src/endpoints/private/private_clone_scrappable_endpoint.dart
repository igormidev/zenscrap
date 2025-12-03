import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateCloneScrappableEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Scrappable> cloneFromMarketplace(
    Session session, {
    required int scrappableId,
  }) async {
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) {
      throw defaultAuthenticationException;
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
      throw ZenScrapException(
        title: 'Account Not Found',
        description: 'Could not find your account information.',
      );
    }

    // Check if user has unlimited plan
    if (accountInfo.planTier != PlanTier.ultra) {
      throw ZenScrapException(
        title: 'Upgrade Required',
        description: 'Cloning marketplace scrappables requires an Ultra plan.',
      );
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
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description: 'The scrappable you are trying to clone does not exist.',
      );
    }

    // Verify it's a public scrappable
    if (sourceScrappable.willHideFromMarketplace) {
      throw ZenScrapException(
        title: 'Access Denied',
        description: 'This scrappable is private and cannot be cloned.',
      );
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
