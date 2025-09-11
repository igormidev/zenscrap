import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/endpoints/public/scrappable_chat_session.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

mixin DeployEndpointMixin {
  Future<void> deployReferenceTestData({
    required Session session,
    required Transaction transaction,
    required ReferenceTestData testData,
    required ScrappingBeeExtractLogic scrappingBeeExtractLogic,
    required ScrappableRequest scrappableRequest,
  }) async {
    if (testData.byteData == null) {
      throw ZenScrapException(
        title: 'No byte data to deploy',
        description:
            'You cannot deploy reference test data that does not have any byte data yet',
      );
    }

    final int? userId = (await session.authenticated)?.userId;
    final Scrappable? scrappable;
    if (userId == null) {
      // If not autenticated, should only be able to modify scrappables that are not attached to any account
      scrappable = await Scrappable.db.findFirstRow(session,
          where: (t) =>
              t.referenceTestDataId.equals(testData.id) &
              t.referenceTestData.byteData.id.equals(testData.byteData?.id) &
              t.scrappingBeeExtractRules.id
                  .equals(scrappingBeeExtractLogic.id) &
              t.targetRequest.id.equals(scrappableRequest.id) &
              t.accountId.equals(null),
          transaction: transaction);
    } else {
      final AccountInfo? accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (p0) => p0.userInfoId.equals(userId),
        transaction: transaction,
      );
      if (accountInfo == null) {
        throw defaultAuthenticationException;
      }
      scrappable = await Scrappable.db.findFirstRow(
        session,
        where: (t) =>
            t.referenceTestDataId.equals(testData.id) &
            t.referenceTestData.byteData.id.equals(testData.byteData?.id) &
            t.scrappingBeeExtractRules.id.equals(scrappingBeeExtractLogic.id) &
            t.targetRequest.id.equals(scrappableRequest.id) &
            t.accountId.equals(accountInfo.id),
        transaction: transaction,
      );
    }

    if (scrappable == null) {
      throw ZenScrapException(
        title: 'Authentication Required or Reference Data does not exist',
        description:
            'You probably must be authenticated to modify this reference test data - or you misstyped the id of it',
      );
    }

    await Scrappable.db.updateRow(
        session,
        scrappable.copyWith(
          extractRulesUpdatedAt: DateTime.now(),
        ),
        transaction: transaction);

    await ScrappingBeeExtractLogic.db
        .updateRow(session, scrappingBeeExtractLogic, transaction: transaction);
    await ScrappableRequest.db
        .updateRow(session, scrappableRequest, transaction: transaction);

    await ByteTestData.db
        .updateRow(session, testData.byteData!, transaction: transaction);

    await ReferenceTestData.db
        .updateRow(session, testData, transaction: transaction);

    await disposeFromScrappableId(scrappable.id!);
  }
}
