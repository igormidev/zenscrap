/// List of domains that are banned from scraping.
///
/// These domains are either too difficult to scrape reliably or have
/// strict anti-scraping measures that make the experience poor for users.
///
/// The check uses a regex with word boundaries to match:
/// - The exact domain (e.g., instagram.com)
/// - All subdomains (e.g., www.instagram.com, api.instagram.com)
/// - But NOT partial matches (e.g., "notinstagram.com" won't match)
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

/// Pre-compiled regex pattern for matching banned domains.
///
/// Uses word boundaries (`\b`) to ensure we match whole domain segments:
/// - "www.instagram.com" ✓ matches (word boundary before 'instagram')
/// - "instagram.com" ✓ matches
/// - "notinstagram.com" ✗ no match (no word boundary between 't' and 'i')
///
/// The capturing group extracts the matched domain for error messages.
/// Domains are sorted by length (longest first) to ensure more specific
/// domains like "google.com.br" match before "google.com".
final RegExp _bannedDomainRegex = RegExp(
  r'\b(' +
      ([...kBannedDomains]..sort((a, b) => b.length.compareTo(a.length)))
          .map((d) => RegExp.escape(d))
          .join('|') +
      r')\b',
  caseSensitive: false,
);

/// Returns the banned domain that matches the URL, or null if not banned.
///
/// Uses a single regex match - no URI parsing, no loops.
///
/// Example:
/// ```dart
/// getBannedDomainFromUrl('https://www.instagram.com/post/123'); // 'instagram.com'
/// getBannedDomainFromUrl('https://api.facebook.com/v1/data'); // 'facebook.com'
/// getBannedDomainFromUrl('https://example.com'); // null
/// getBannedDomainFromUrl('https://notinstagram.com'); // null (no false positives)
/// ```
String? getBannedDomainFromUrl(String url) {
  final match = _bannedDomainRegex.firstMatch(url);
  return match?.group(1)?.toLowerCase();
}

/// Checks if a URL belongs to a banned domain.
///
/// Returns `true` if the URL contains any domain from [kBannedDomains].
bool isUrlFromBannedDomain(String url) {
  return _bannedDomainRegex.hasMatch(url);
}
