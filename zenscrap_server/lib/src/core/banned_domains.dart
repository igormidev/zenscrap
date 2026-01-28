/// List of domains that are banned from scraping.
///
/// These domains are either too difficult to scrape reliably or have
/// strict anti-scraping measures that make the experience poor for users.
///
/// The check matches:
/// - The exact domain (e.g., instagram.com)
/// - All subdomains (e.g., www.instagram.com, api.instagram.com)
///
/// This list is exposed via the [BannedDomainsEndpoint] so the client
/// can validate URLs before attempting to create a scrappable.
const List<String> kBannedDomains = [
  // Instagram
  'instagram.com',
  'instagr.am',

  // TikTok
  'tiktok.com',
  'tiktokv.com',
  'musical.ly',

  // Facebook & Meta
  'facebook.com',
  'fb.com',
  'fb.me',
  'fbcdn.net',
  'messenger.com',

  // Google & Alphabet
  'google.com',
  'google.co.uk',
  'google.co.jp',
  'google.de',
  'google.fr',
  'google.es',
  'google.it',
  'google.com.br',
  'google.ca',
  'google.com.au',
  'google.co.in',
  'google.ru',
  'google.pl',
  'google.nl',
  'google.com.mx',
  'google.co.kr',
  'google.com.ar',
  'google.com.tw',
  'google.co.id',
  'google.com.tr',
  'google.ch',
  'google.at',
  'google.be',
  'google.se',
  'google.pt',
  'google.com.sg',
  'google.com.hk',
  'google.co.th',
  'google.com.ph',
  'google.com.my',
  'google.com.vn',
  'google.co.za',
  'google.com.eg',
  'google.com.pk',
  'google.co.nz',
  'google.ie',
  'google.dk',
  'google.fi',
  'google.no',
  'google.cz',
  'google.hu',
  'google.gr',
  'google.ro',
  'google.co.il',
  'google.ae',
  'google.com.sa',
  'google.cl',
  'google.com.co',
  'google.com.pe',
  'googleapis.com',
  'googleusercontent.com',
  'googlevideo.com',
  'goo.gl',
  'g.co',
  'youtube.com',
  'youtu.be',
  'ytimg.com',
  'yt.be',
  'gmail.com',

  // Bing
  'bing.com',

  // Tumblr
  'tumblr.com',

  // Amazon
  'amazon.com',
  'amazon.co.uk',
  'amazon.de',
  'amazon.fr',
  'amazon.es',
  'amazon.it',
  'amazon.co.jp',
  'amazon.ca',
  'amazon.com.au',
  'amazon.com.br',
  'amazon.com.mx',
  'amazon.in',
  'amazon.nl',
  'amazon.sg',
  'amazon.ae',
  'amazon.sa',
  'amazon.se',
  'amazon.pl',
  'amazon.com.tr',
  'amazon.cn',
  'amzn.com',
  'amzn.to',
  'a.co',
  'z.cn',
];

/// Checks if a URL belongs to a banned domain.
///
/// Returns `true` if the URL's host matches or is a subdomain of any
/// domain in [kBannedDomains].
///
/// Example:
/// ```dart
/// isUrlFromBannedDomain('https://www.instagram.com/post/123'); // true
/// isUrlFromBannedDomain('https://api.facebook.com/v1/data'); // true
/// isUrlFromBannedDomain('https://example.com'); // false
/// ```
bool isUrlFromBannedDomain(String url) {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null || uri.host.isEmpty) {
    // If we can't parse the URL, try adding a scheme
    final uriWithScheme = Uri.tryParse('https://$url');
    if (uriWithScheme == null || uriWithScheme.host.isEmpty) {
      return false;
    }
    return _isHostBanned(uriWithScheme.host);
  }
  return _isHostBanned(uri.host);
}

/// Checks if a host is banned.
///
/// Matches both exact domain and subdomains.
/// For example, if 'instagram.com' is banned:
/// - 'instagram.com' matches
/// - 'www.instagram.com' matches
/// - 'api.instagram.com' matches
/// - 'notinstagram.com' does NOT match
bool _isHostBanned(String host) {
  final lowerHost = host.toLowerCase();

  for (final bannedDomain in kBannedDomains) {
    // Check for exact match
    if (lowerHost == bannedDomain) {
      return true;
    }

    // Check for subdomain match (host ends with .bannedDomain)
    if (lowerHost.endsWith('.$bannedDomain')) {
      return true;
    }
  }

  return false;
}

/// Returns the banned domain that matches the URL, or null if not banned.
///
/// This is useful for error messages to tell the user which domain
/// was detected as banned.
String? getBannedDomainFromUrl(String url) {
  final Uri? uri = Uri.tryParse(url);
  final String host;

  if (uri == null || uri.host.isEmpty) {
    final uriWithScheme = Uri.tryParse('https://$url');
    if (uriWithScheme == null || uriWithScheme.host.isEmpty) {
      return null;
    }
    host = uriWithScheme.host.toLowerCase();
  } else {
    host = uri.host.toLowerCase();
  }

  for (final bannedDomain in kBannedDomains) {
    if (host == bannedDomain || host.endsWith('.$bannedDomain')) {
      return bannedDomain;
    }
  }

  return null;
}
