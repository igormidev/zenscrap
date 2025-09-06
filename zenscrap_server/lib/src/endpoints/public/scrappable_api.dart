import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/mixins/api_helper_mixin.dart';

class ScrappableApiEndpoint extends Endpoint with ApiHelperMixin {
  Future<Map<String, dynamic>> prod(
    Session session, {
    required int scrappableId,
    required String apiKey,
    required Map<String, dynamic> payload,
  }) async =>
      callFunc(session,
          apiKey: apiKey, payload: payload, scrappableId: scrappableId);

  Future<Map<String, dynamic>> test(
    Session session, {
    required int scrappableId,
    required Map<String, dynamic> payload,
  }) async =>
      callFunc(session, payload: payload, scrappableId: scrappableId);
}
