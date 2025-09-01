import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/mixins/deploy_endpoint_mixin.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class DeployScrappable extends Endpoint with DeployEndpointMixin {
  Future<void> call(
    Session session, {
    required ReferenceTestData testData,
  }) async {
    return session.db.transaction((transaction) {
      return deployReferenceTestData(
        session: session,
        transaction: transaction,
        testData: testData,
      );
    });
  }
}
