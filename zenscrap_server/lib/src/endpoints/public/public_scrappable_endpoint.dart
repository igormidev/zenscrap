import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/translations/error_translations.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PublicScrappableEndpoint extends Endpoint {
  /// Retrieves ByteTestData for a scrappable
  /// This is a public endpoint to allow viewing test data in the marketplace
  Future<ByteTestData?> getByteTestData(
    Session session,
    int scrappableId, {
    required SupportedLanguage language,
  }) async {
    // Find the scrappable
    final scrappable = await Scrappable.db.findById(
      session,
      scrappableId,
      include: Scrappable.include(
        referenceTestData: ReferenceTestData.include(
          byteData: ByteTestData.include(),
        ),
      ),
    );

    if (scrappable == null) {
      throw createTranslatedException('scrappable_not_found', language);
    }

    // Check if scrappable is deleted or hidden from marketplace
    if (scrappable.isDeleted == true ||
        scrappable.willHideFromMarketplace == true) {
      throw createTranslatedException('scrappable_not_available', language);
    }

    return scrappable.referenceTestData?.byteData;
  }
}
