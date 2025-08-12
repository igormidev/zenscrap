import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/mixin/create_scrappable_mixin.dart';
import 'package:zenscrap_server/src/core/mixin/create_scrappable_target_request_mixin.dart';
import 'package:zenscrap_server/src/generated/entities/scrappable.dart';

class CreateScrapChatSessionEndpoint extends Endpoint
    with CreateScrappableTargetRequestMixin, CreateScrappableMixin {
  Future<Scrappable> call(
    Session session, {
    required String targetUrl,
    required String userPrompt,
  }) async {
    final request = await createMixinProvider(
      targetUrl: targetUrl,
    );

    return await createScrappable(
      session: session,
      requestStrcture: request,
      referenceUrl: targetUrl,
      userPrompt: userPrompt,
    );
  }

  Future<void> createSession(
    Session session,
  ) async {}
}

void getSessionPrompt() {}
