import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class PublicScrappableEndpoint extends Endpoint {
  /// Retrieves ByteTestData for a scrappable
  /// This is a public endpoint to allow viewing test data in the marketplace
  Future<ByteTestData?> getByteTestData(
    Session session,
    int scrappableId,
  ) async {
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
      throw ZenScrapException(
        title: 'Scrappable Not Found',
        description: 'The requested scrappable does not exist.',
      );
    }

    // Check if scrappable is deleted or hidden from marketplace
    if (scrappable.isDeleted == true ||
        scrappable.willHideFromMarketplace == true) {
      throw ZenScrapException(
        title: 'Scrappable Not Available',
        description: 'The requested scrappable is not available.',
      );
    }

    return scrappable.referenceTestData?.byteData;
  }
}
