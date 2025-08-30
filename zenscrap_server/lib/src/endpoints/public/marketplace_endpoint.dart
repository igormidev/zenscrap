import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class MarketplaceEndpoint extends Endpoint {
  Future<PaginatedScrappableResponse> getItems(
    Session session, {
    int page = 1,
    int pageSize = 20,
    String? searchQuery,
  }) async {
    // Ensure page is at least 1
    page = page < 1 ? 1 : page;
    
    // Build where clause  
    // Add search filter if query is provided
    // Also filter out deleted scrappables
    final whereClause = searchQuery != null && searchQuery.isNotEmpty 
        ? (ScrappableTable t) => t.isPrivate.equals(false) & 
            t.isDeleted.equals(false) &
            (t.name.ilike('%$searchQuery%') | t.description.ilike('%$searchQuery%'))
        : (ScrappableTable t) => t.isPrivate.equals(false) & t.isDeleted.equals(false);
    
    // Get total count for pagination
    final totalCount = await Scrappable.db.count(
      session,
      where: whereClause,
    );
    
    // Calculate pagination metadata
    final totalPages = (totalCount / pageSize).ceil();
    final hasNextPage = page < totalPages;
    final hasPreviousPage = page > 1;
    
    // Calculate offset
    final offset = (page - 1) * pageSize;
    
    // Fetch paginated data
    final scrappables = await Scrappable.db.find(
      session,
      where: whereClause,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: pageSize,
      offset: offset,
      include: Scrappable.include(
        targetRequest: ScrappableRequest.include(),
      ),
    );
    
    return PaginatedScrappableResponse(
      data: scrappables,
      pagination: PaginationMetadata(
        currentPage: page,
        pageSize: pageSize,
        totalCount: totalCount,
        totalPages: totalPages,
        hasNextPage: hasNextPage,
        hasPreviousPage: hasPreviousPage,
      ),
    );
  }
}
