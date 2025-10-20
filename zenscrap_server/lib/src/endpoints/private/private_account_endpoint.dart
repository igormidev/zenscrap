import 'package:nanoid2/nanoid2.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:zenscrap_server/src/core/default_classes.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateAccountEndpoint extends Endpoint {
  final Uuid _uuid = Uuid();
  @override
  bool get requireLogin => true;

  Future<AccountInfo> getAccountInfo(
    Session session, {
    required int? initialScrappableId,
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

    final isNewAccount = accountInfo == null;

    if (!isNewAccount && initialScrappableId != null) {
      return await session.db.transaction((transaction) async {
        await _attachScrappable(
            session, transaction, accountInfo!, initialScrappableId);
        return accountInfo;
      });
    }

    if (!isNewAccount) {
      return accountInfo;
    }

    final String nanoId = nanoid(length: 8);
    final acountApiKey = '$nanoId::${_uuid.v7()}';
    try {
      return await session.db.transaction((transaction) async {
        // Create CreditUsage first with 100 initial credits for free tier
        final creditUsage = await CreditUsage.db.insertRow(
          session,
          CreditUsage(
            purchasedCredits: 0,
            subscriptionCredits: 100, // Free tier gets 100 credits initially
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

        if (initialScrappableId != null) {
          await _attachScrappable(
              session, transaction, accountInfo, initialScrappableId);
        }

        return accountAdded;
      }).then((accountInfo) async {
        // Schedule monthly credit addition for free tier users
        // This runs outside the transaction after account creation succeeds
        await session.serverpod.futureCallWithDelay(
          'monthly_subscription_credits',
          MonthlyCreditsData(
            accountInfoId: accountInfo.id!,
          ),
          const Duration(days: 30), // First monthly credit in 30 days
        );

        session.log(
            'Scheduled monthly credits for new free tier account ${accountInfo.id}');

        return accountInfo;
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
  }

  Future<void> _attachScrappable(
    Session session,
    Transaction transaction,
    AccountInfo accountInfo,
    int targetAttachScrappableId,
  ) async {
    Scrappable? existingScrappable = await Scrappable.db.findById(
      session,
      targetAttachScrappableId,
      transaction: transaction,
    );
    final existsScrappableWithTargetId = existingScrappable != null;
    final scrappableAccountId = existingScrappable?.accountId;
    final isAccountAlreadyAttachedToOtherUser =
        scrappableAccountId != null && scrappableAccountId != accountInfo.id;

    if (!existsScrappableWithTargetId) {
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description: 'The scrappable you are trying to attach does not exist.',
      );
    }

    if (isAccountAlreadyAttachedToOtherUser == true) {
      // Already attached to another account
      throw ZenScrapException(
        title: 'Scrappable Already Attached',
        description:
            'The scrappable you are trying to attach is already linked to another account.',
      );
    }

    existingScrappable = existingScrappable.copyWith(accountId: accountInfo.id);

    await Scrappable.db
        .updateRow(session, existingScrappable, transaction: transaction);
    await AccountInfo.db.attachRow.scrappables(
        session, accountInfo, existingScrappable,
        transaction: transaction);
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
