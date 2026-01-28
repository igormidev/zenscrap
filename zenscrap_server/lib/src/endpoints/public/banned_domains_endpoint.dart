import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/core/banned_domains.dart';

/// Endpoint that exposes the list of banned domains to clients.
///
/// This allows the client to validate URLs before attempting to create
/// a scrappable, providing immediate feedback to users.
class BannedDomainsEndpoint extends Endpoint {
  /// Returns the list of banned domains.
  ///
  /// These domains cannot be used for creating scrappables due to
  /// technical limitations or anti-scraping measures.
  Future<List<String>> getBannedDomains(Session session) async {
    return kBannedDomains;
  }

  /// Checks if a URL is from a banned domain.
  ///
  /// Returns the banned domain if found, or null if the URL is allowed.
  Future<String?> checkUrl(Session session, String url) async {
    return getBannedDomainFromUrl(url);
  }
}
