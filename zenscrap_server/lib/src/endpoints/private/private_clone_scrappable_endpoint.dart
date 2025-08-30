import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateCloneScrappableEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<Scrappable> cloneFromMarketplace(
    Session session, {
    required UuidValue scrappableId,
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
        referenceTestData: ReferenceTestData.include(),
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

    // Clone the ScrappableRequest
    final clonedRequest = ScrappableRequest(
      url: sourceScrappable.targetRequest!.url,
      queryParams: sourceScrappable.targetRequest!.queryParams,
      pathParams: sourceScrappable.targetRequest!.pathParams,
    );

    await ScrappableRequest.db.insertRow(session, clonedRequest);

    // Clone the ReferenceTestData
    final clonedTestData = ReferenceTestData(
      referenceLinkUsed: sourceScrappable.referenceTestData!.referenceLinkUsed,
      referenceQueryParametersJson:
          sourceScrappable.referenceTestData!.referenceQueryParametersJson,
      referenceHtmlPage: sourceScrappable.referenceTestData!.referenceHtmlPage,
      referenceSiteScreenshot:
          sourceScrappable.referenceTestData!.referenceSiteScreenshot,
    );

    await ReferenceTestData.db.insertRow(session, clonedTestData);

    // Create the cloned scrappable
    final clonedScrappable = Scrappable(
      id: UuidValue.fromString(Uuid().v4()),
      accountId: accountInfo.id,
      apiUsageOwnerNanoId: accountInfo.accountApiUsage?.nanoId,
      createdAt: DateTime.now(),
      name: '${sourceScrappable.name} (Copy)',
      description: sourceScrappable.description,
      testEndpointAvailableUntil: null,
      scrappingRules: sourceScrappable.scrappingRules,
      willHideFromMarketplace: false,
      targetRequestId: clonedRequest.id!,
      targetRequest: clonedRequest,
      referenceTestDataId: clonedTestData.id!,
      referenceTestData: clonedTestData,
      category: sourceScrappable.category,
    );

    await Scrappable.db.insertRow(session, clonedScrappable);

    // Return the cloned scrappable with all relations
    final result = await Scrappable.db.findById(
      session,
      clonedScrappable.id,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
        referenceTestData: ReferenceTestData.include(),
      ),
    );

    return result!;
  }
}
