import 'package:nanoid2/nanoid2.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/core/mixins/deploy_endpoint_mixin.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateAccountEndpoint extends Endpoint with DeployEndpointMixin {
  final Uuid _uuid = Uuid();
  @override
  bool get requireLogin => true;

  Future<AccountInfo> getAccountInfo(
    Session session, {
    required Scrappable? initialScrappableIfNewUser,
  }) async {
    final authenticationInfo = await session.authenticated;
    if (authenticationInfo == null) {
      throw defaultAuthenticationException;
    }

    final userId = authenticationInfo.userId;

    AccountInfo? accountInfo;
    try {
      accountInfo = await AccountInfo.db.findFirstRow(
        session,
        where: (p0) => p0.userInfoId.equals(userId),
        include: include,
      );
    } catch (e) {
      throw ZenScrapException(
        title: 'Database Error',
        description:
            'Failed to retrieve account information. Please try again later.',
      );
    }

    if (accountInfo == null) {
      final String nanoId = nanoid(length: 8);
      final acountApiKey = '$nanoId::${_uuid.v7()}';
      try {
        return await session.db.transaction((transaction) async {
          // Create CreditUsage first
          final creditUsage = await CreditUsage.db.insertRow(
            session,
            CreditUsage(
              purchasedCredits: 0,
              subscriptionCredits: 0,
            ),
            transaction: transaction,
          );

          // Create AccountApiUsage with creditUsageId
          final accountApiUsage = await AccountApiUsage.db.insertRow(
            session,
            AccountApiUsage(
              creditUsageId: creditUsage.id!,
              nanoId: nanoId,
            ),
            transaction: transaction,
          );
          final apiKey = await AccountApiKey.db.insertRow(
            session,
            AccountApiKey(
              name: 'Default API Key',
              apiKey: acountApiKey,
              accountApiUsageId: accountApiUsage.id!,
              accountApiUsage: accountApiUsage,
              createdAt: DateTime.now(),
            ),
            transaction: transaction,
          );

          await AccountApiKey.db.attachRow.accountApiUsage(
            session,
            apiKey,
            accountApiUsage,
            transaction: transaction,
          );
          AccountInfo accountInfo = AccountInfo(
            userInfoId: userId,
            accountApiUsageId: accountApiUsage.id!,
            accountApiUsage: accountApiUsage,
            planTier: PlanTier.none,
          );

          accountInfo = await AccountInfo.db
              .insertRow(session, accountInfo, transaction: transaction);

          await AccountInfo.db.attachRow.accountApiUsage(
              session, accountInfo, accountApiUsage,
              transaction: transaction);

          final accountAdded = await AccountInfo.db.findFirstRow(
            session,
            where: (p0) => p0.userInfoId.equals(userId),
            include: include,
            transaction: transaction,
          );
          if (accountAdded == null) {
            throw ZenScrapException(
              title: 'Account Creation Failed',
              description:
                  'Unable to create new account. Please try again later.',
            );
          }

          if (initialScrappableIfNewUser != null) {
            await _attachScrappable(
                session, transaction, accountInfo, initialScrappableIfNewUser);
          }

          return accountAdded;
        });
      } catch (error, stackTrace) {
        session.log(
          'Error creating new account for userId $userId',
          exception: error,
          level: LogLevel.error,
          stackTrace: stackTrace,
        );
        throw ZenScrapException(
          title: 'Account Creation Failed',
          description: 'This is a Internal error. Please try again later.',
        );
      }
    } else {
      if (initialScrappableIfNewUser != null) {
        await session.db.transaction((transaction) async {
          await _attachScrappable(
              session, transaction, accountInfo!, initialScrappableIfNewUser);
        });
      }
    }

    return accountInfo;
  }

  Future<void> _attachScrappable(
    Session session,
    Transaction transaction,
    AccountInfo accountInfo,
    Scrappable scrappable,
  ) async {
    final Scrappable? existingScrappable = await Scrappable.db.findById(
      session,
      scrappable.id!,
      include: Scrappable.include(
        scrappingBeeExtractRules: ScrappingBeeExtractLogic.include(),
        referenceTestData: ReferenceTestData.include(),
      ),
    );
    if (existingScrappable == null ||
        existingScrappable.accountId != null ||
        existingScrappable.isDeleted) {
      // Already have a account attached, just ignore...
      return;
    }
    await Scrappable.db.updateRow(
        session, scrappable.copyWith(accountId: accountInfo.id),
        transaction: transaction);
    await AccountInfo.db.attachRow.scrappables(session, accountInfo, scrappable,
        transaction: transaction);
    await deployReferenceTestData(
      session: session,
      transaction: transaction,
      testData: scrappable.referenceTestData!.copyWith(
        id: existingScrappable.referenceTestData!.id,
      ),
      scrappingBeeExtractLogic: scrappable.scrappingBeeExtractRules!.copyWith(
        id: existingScrappable.scrappingBeeExtractRules!.id,
      ),
      scrappableRequest: scrappable.targetRequest!,
    );
  }

  final include = AccountInfo.include(
    userInfo: UserInfo.include(),
    accountApiUsage: AccountApiUsage.include(
      apiKeys: AccountApiKey.includeList(
        limit: 10,
        orderBy: (p0) => p0.createdAt,
      ),
    ),
  );
}
