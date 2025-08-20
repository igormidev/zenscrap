import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PrivateApiUsageEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  Future<AccountApiUsage> getUsageInfo(Session session) async {
    final userId = (await session.authenticated)?.userId;
    final accountApiUsage = await AccountApiUsage.db.findFirstRow(
      session,
      where: (p0) => p0.accountInfo.userInfoId.equals(userId),
      include: AccountApiUsage.include(
        history: CreditHistoryItem.includeList(
          include: CreditHistoryItem.include(
            creaditPackagePurchase: CreditPackagePurchase.include(),
            monthlySubscriptionCreditDeposit:
                MonthlySubscriptionCreditDeposit.include(),
          ),
          limit: 30,
        ),
      ),
    );

    if (accountApiUsage == null) {
      throw ZenScrapException(
        title: 'Usage Information Not Found',
        description: 'No usage information found for the user.',
      );
    }

    return accountApiUsage;
  }
}
