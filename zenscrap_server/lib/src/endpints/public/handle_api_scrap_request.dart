import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/entities/scrappable.dart';

class HandleApiScrapRequest extends Endpoint {
  Future<Map<String, dynamic>> call(
    Session session, {
    required int scrappableId,
    required Map<String, dynamic> payload,
  }) async {
    final Scrappable? scrappable =
        await Scrappable.db.findById(session, scrappableId);
    if (scrappable == null) {
      throw Exception('Scrappable not found');
    }
    if (scrappable.isActive == false) {
      throw Exception('This scrappable is no longer active');
    }

    final String? scrapingBeeApi = session.passwords['scrapingBeeApi'];

    return {};
  }
}
