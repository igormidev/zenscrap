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
        include: AccountInfo.include(
          userInfo: UserInfo.include(),
          accountApiKey: AccountApiKey.include(),
        ),
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
          final apiKey = await AccountApiKey.db.insertRow(
            session,
            AccountApiKey(
              apiKey: acountApiKey,
            ),
            transaction: transaction,
          );
          final accountInfo = AccountInfo(
            userInfoId: userId,
            accountApiKeyId: userId,
            accountApiKey: apiKey,
          );

          return await AccountInfo.db
              .insertRow(session, accountInfo, transaction: transaction);
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
}
/*
dart run bin/gobabel.dart --sync --api-key=01966b4d-f1da-728e-a27e-7a5daa594454 --path=go_babel_app/gobabel_flutter
dart pub global activate gobabel && gobabel --create  --attach-to-user-with-id=0196984f-a667-7151-98c4-74db023966d0

dart run bin/gobabel.dart --create --attach-to-user-with-id=0196984f-a667-7151-98c4-74db023966d0 --path=go_babel_app/gobabel_flutter
*/
