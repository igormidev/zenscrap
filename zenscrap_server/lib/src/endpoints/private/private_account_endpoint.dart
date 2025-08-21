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
      final acountApiKey = _uuid.v7();
      try {
        return await session.db.transaction((transaction) async {
          final accountApiUsage = await AccountApiUsage.db.insertRow(
            session,
            AccountApiUsage(remainingCredits: 0),
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
          if (initialScrappableIfNewUser != null) {
            await Scrappable.db.updateRow(
                session,
                initialScrappableIfNewUser.copyWith(
                  accountId: accountInfo.id,
                ),
                transaction: transaction);
            await AccountInfo.db.attachRow.scrappables(
                session, accountInfo, initialScrappableIfNewUser,
                transaction: transaction);
          }

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

          return accountAdded;
        });
      } catch (e) {
        throw ZenScrapException(
          title: 'Account Creation Failed',
          description: 'Unable to create new account. Please try again later.',
        );
      }
    }

    accountInfo.userInfoId;
    return accountInfo;
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
