import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:zenscrap_server/src/core/api_helper/api_helper_mixin.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PublicTierEndpoint extends Endpoint {
  Future<void> updatePlayerTier(
    Session session, {
    required String email,
    required String tierManipulationKey,
    required PlanTier planTier,
  }) async {
    if (tierManipulationKey != _privateTierManipulationKey) {
      throw ZenScrapException(
        title: 'Invalid key',
        description: 'The key you provided is invalid. Please contact support',
      );
    }
    final user = await UserInfo.db
        .findFirstRow(session, where: (p0) => p0.email.ilike(email));
    if (user == null) {
      throw ZenScrapException(
        title: 'User not found',
        description: 'User with email $email not found',
      );
    }
    final account = await AccountInfo.db
        .findFirstRow(session, where: (p0) => p0.userInfoId.equals(user.id));
    if (account == null) {
      throw ZenScrapException(
        title: 'Account not found',
        description: 'Account with email $email not found',
      );
    }

    if (account.planTier == planTier) {
      return;
    }

    await AccountInfo.db.updateRow(
      session,
      account.copyWith(
        planTier: planTier,
      ),
    );

    // Get API usage to reset cache when plan tier changes
    final apiUsage = await AccountApiUsage.db.findById(
      session,
      account.accountApiUsageId,
    );
    if (apiUsage != null) {
      ApiHelperMixin.resetNanoId(apiUsage.nanoId);
    }
  }
}

const String _privateTierManipulationKey =
    '0195744f-a23c-757e-9bf4-184f7ef3bb24';
