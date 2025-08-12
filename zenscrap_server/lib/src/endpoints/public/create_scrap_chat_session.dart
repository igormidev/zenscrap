import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/mixin/create_scrappable_target_request_mixin.dart';

class CreateScrapChatSessionEndpoint extends Endpoint
    with CreateScrappableTargetRequestMixin {
  Future<void> call(
    Session session, {
    required String targetUrl,
  }) async {
    final request = await createMixinProvider(
      targetUrl: targetUrl,
    );
  }

  Future<void> createSession(
    Session session,
  ) async {}
}

void getSessionPrompt() {}
