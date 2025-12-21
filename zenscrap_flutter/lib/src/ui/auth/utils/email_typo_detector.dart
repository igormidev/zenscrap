import 'package:string_similarity/string_similarity.dart';

/// Utility class for detecting email provider typos and suggesting corrections.
///
/// Uses Dice's Coefficient algorithm to compare the user's email domain
/// against a list of known email providers and their common typos.
class EmailTypoDetector {
  EmailTypoDetector._();

  /// Minimum similarity threshold to consider a typo (0.0 to 1.0).
  /// Higher values require more similarity to suggest a correction.
  static const double _similarityThreshold = 0.6;

  /// Maximum similarity that still counts as a typo (below 1.0).
  /// If similarity is 1.0, it's an exact match (no typo).
  static const double _exactMatchThreshold = 0.99;

  /// Map of common email providers to their correct domain.
  /// Includes the main domain and common variations/regional domains.
  static const Map<String, String> _providerDomains = {
    // Gmail - Google's email service
    'gmail.com': 'gmail.com',
    'googlemail.com': 'gmail.com',

    // Hotmail - Microsoft's legacy email
    'hotmail.com': 'hotmail.com',
    'hotmail.co.uk': 'hotmail.co.uk',
    'hotmail.fr': 'hotmail.fr',
    'hotmail.de': 'hotmail.de',
    'hotmail.es': 'hotmail.es',
    'hotmail.it': 'hotmail.it',
    'hotmail.com.br': 'hotmail.com.br',

    // Outlook - Microsoft's modern email
    'outlook.com': 'outlook.com',
    'outlook.co.uk': 'outlook.co.uk',
    'outlook.fr': 'outlook.fr',
    'outlook.de': 'outlook.de',
    'outlook.es': 'outlook.es',
    'outlook.it': 'outlook.it',
    'outlook.com.br': 'outlook.com.br',

    // Live - Microsoft's another service
    'live.com': 'live.com',
    'live.co.uk': 'live.co.uk',
    'live.fr': 'live.fr',
    'live.de': 'live.de',

    // MSN - Microsoft Network
    'msn.com': 'msn.com',

    // Yahoo - Yahoo Mail
    'yahoo.com': 'yahoo.com',
    'yahoo.co.uk': 'yahoo.co.uk',
    'yahoo.fr': 'yahoo.fr',
    'yahoo.de': 'yahoo.de',
    'yahoo.es': 'yahoo.es',
    'yahoo.it': 'yahoo.it',
    'yahoo.com.br': 'yahoo.com.br',
    'yahoo.ca': 'yahoo.ca',
    'yahoo.co.in': 'yahoo.co.in',
    'ymail.com': 'ymail.com',
    'rocketmail.com': 'rocketmail.com',

    // iCloud - Apple's email
    'icloud.com': 'icloud.com',
    'me.com': 'me.com',
    'mac.com': 'mac.com',

    // AOL - America Online
    'aol.com': 'aol.com',
    'aol.co.uk': 'aol.co.uk',

    // ProtonMail - Secure email
    'protonmail.com': 'protonmail.com',
    'proton.me': 'proton.me',
    'pm.me': 'pm.me',

    // Zoho Mail
    'zoho.com': 'zoho.com',
    'zohomail.com': 'zohomail.com',

    // GMX - German provider
    'gmx.com': 'gmx.com',
    'gmx.de': 'gmx.de',
    'gmx.net': 'gmx.net',

    // Mail.com - Free email
    'mail.com': 'mail.com',
    'email.com': 'email.com',

    // Yandex - Russian provider
    'yandex.com': 'yandex.com',
    'yandex.ru': 'yandex.ru',

    // Mail.ru - Russian provider
    'mail.ru': 'mail.ru',

    // UOL - Brazilian provider
    'uol.com.br': 'uol.com.br',
    'bol.com.br': 'bol.com.br',

    // Terra - Brazilian/Spanish provider
    'terra.com.br': 'terra.com.br',
    'terra.com': 'terra.com',

    // Globo - Brazilian provider
    'globo.com': 'globo.com',
    'globomail.com': 'globomail.com',

    // IG - Brazilian provider
    'ig.com.br': 'ig.com.br',

    // Fastmail
    'fastmail.com': 'fastmail.com',
    'fastmail.fm': 'fastmail.fm',

    // Tutanota - Secure email
    'tutanota.com': 'tutanota.com',
    'tutamail.com': 'tutamail.com',
    'tuta.io': 'tuta.io',

    // Inbox.com
    'inbox.com': 'inbox.com',

    // Cox
    'cox.net': 'cox.net',

    // Comcast
    'comcast.net': 'comcast.net',

    // AT&T
    'att.net': 'att.net',
    'sbcglobal.net': 'sbcglobal.net',

    // Verizon
    'verizon.net': 'verizon.net',

    // Rediffmail - Indian provider
    'rediffmail.com': 'rediffmail.com',
    'rediff.com': 'rediff.com',
  };

  /// Common typo patterns to known domains.
  /// These are typos that are so common we can directly map them.
  static const Map<String, String> _commonTypos = {
    // Gmail typos
    'gmal.com': 'gmail.com',
    'gmial.com': 'gmail.com',
    'gmali.com': 'gmail.com',
    'gamil.com': 'gmail.com',
    'gmaill.com': 'gmail.com',
    'gnail.com': 'gmail.com',
    'gmai.com': 'gmail.com',
    'gmail.co': 'gmail.com',
    'gmail.con': 'gmail.com',
    'gmail.om': 'gmail.com',
    'gmail.cm': 'gmail.com',
    'gmailcom': 'gmail.com',
    'g]mail.com': 'gmail.com',
    'gail.com': 'gmail.com',
    'gmail.cmo': 'gmail.com',
    'gmail.ocm': 'gmail.com',
    'gmail.copm': 'gmail.com',
    'gmeil.com': 'gmail.com',
    'gmsil.com': 'gmail.com',
    'gmaio.com': 'gmail.com',
    'gemail.com': 'gmail.com',
    'gmaiil.com': 'gmail.com',
    'ggmail.com': 'gmail.com',

    // Hotmail typos
    'hotmal.com': 'hotmail.com',
    'hotmai.com': 'hotmail.com',
    'hotmial.com': 'hotmail.com',
    'hotmaill.com': 'hotmail.com',
    'hotmil.com': 'hotmail.com',
    'hotamil.com': 'hotmail.com',
    'hotmail.co': 'hotmail.com',
    'hotmail.con': 'hotmail.com',
    'hotmail.om': 'hotmail.com',
    'hotmail.cm': 'hotmail.com',
    'hitmail.com': 'hotmail.com',
    'htmail.com': 'hotmail.com',
    'hotmmail.com': 'hotmail.com',
    'hotnail.com': 'hotmail.com',
    'hotmsil.com': 'hotmail.com',
    'hormail.com': 'hotmail.com',
    'homail.com': 'hotmail.com',
    'hotmeil.com': 'hotmail.com',
    'hotmaikl.com': 'hotmail.com',
    'hotmaol.com': 'hotmail.com',
    'hottmail.com': 'hotmail.com',

    // Outlook typos
    'outloo.com': 'outlook.com',
    'outlok.com': 'outlook.com',
    'outllook.com': 'outlook.com',
    'outloook.com': 'outlook.com',
    'outlook.co': 'outlook.com',
    'outlook.con': 'outlook.com',
    'otlook.com': 'outlook.com',
    'outlool.com': 'outlook.com',
    'outlouk.com': 'outlook.com',
    'outlokk.com': 'outlook.com',

    // Yahoo typos
    'yaho.com': 'yahoo.com',
    'yahooo.com': 'yahoo.com',
    'yhaoo.com': 'yahoo.com',
    'yhoo.com': 'yahoo.com',
    'yahoo.co': 'yahoo.com',
    'yahoo.con': 'yahoo.com',
    'yaoo.com': 'yahoo.com',
    'yshoo.com': 'yahoo.com',
    'yahhoo.com': 'yahoo.com',
    'yahho.com': 'yahoo.com',
    'yaaho.com': 'yahoo.com',

    // iCloud typos
    'iclod.com': 'icloud.com',
    'iclould.com': 'icloud.com',
    'icoud.com': 'icloud.com',
    'icloud.co': 'icloud.com',
    'icloud.con': 'icloud.com',
    'iclooud.com': 'icloud.com',
    'iclud.com': 'icloud.com',

    // Live typos
    'liv.com': 'live.com',
    'live.co': 'live.com',
    'live.con': 'live.com',
    'lve.com': 'live.com',
    'livee.com': 'live.com',

    // ProtonMail typos
    'protonmal.com': 'protonmail.com',
    'protonmial.com': 'protonmail.com',
    'protonmai.com': 'protonmail.com',
    'protonmail.co': 'protonmail.com',
    'protonmaill.com': 'protonmail.com',
    'protnmail.com': 'protonmail.com',

    // Common .com typos
    '.vom': '.com',
    '.xom': '.com',
    '.cim': '.com',
    '.comm': '.com',
    '.coom': '.com',
  };

  /// Result of email typo detection.
  static EmailTypoResult? detectTypo(String email) {
    email = email.toLowerCase().trim();

    // Extract domain from email
    final atIndex = email.lastIndexOf('@');
    if (atIndex == -1 || atIndex == email.length - 1) {
      return null; // Invalid email format
    }

    final localPart = email.substring(0, atIndex);
    final domain = email.substring(atIndex + 1);

    // First, check for exact known typos
    if (_commonTypos.containsKey(domain)) {
      final correctedDomain = _commonTypos[domain]!;
      return EmailTypoResult(
        originalEmail: email,
        suggestedEmail: '$localPart@$correctedDomain',
        originalDomain: domain,
        suggestedDomain: correctedDomain,
        confidence: 0.95,
      );
    }

    // If domain is already a known provider, no typo
    if (_providerDomains.containsKey(domain)) {
      return null;
    }

    // Find the most similar known domain
    String? bestMatch;
    double bestSimilarity = 0.0;

    for (final knownDomain in _providerDomains.keys) {
      final similarity = StringSimilarity.compareTwoStrings(
        domain,
        knownDomain,
      );

      if (similarity > bestSimilarity) {
        bestSimilarity = similarity;
        bestMatch = knownDomain;
      }
    }

    // Also check common typos similarity (in case we have partial matches)
    for (final typo in _commonTypos.keys) {
      final correctedDomain = _commonTypos[typo]!;
      final similarity = StringSimilarity.compareTwoStrings(domain, typo);

      // If very similar to a known typo, suggest the correction
      if (similarity > 0.8 && similarity > bestSimilarity) {
        bestSimilarity = similarity;
        bestMatch = correctedDomain;
      }
    }

    // If we found a good match that's not exact
    if (bestMatch != null &&
        bestSimilarity >= _similarityThreshold &&
        bestSimilarity < _exactMatchThreshold) {
      return EmailTypoResult(
        originalEmail: email,
        suggestedEmail: '$localPart@$bestMatch',
        originalDomain: domain,
        suggestedDomain: bestMatch,
        confidence: bestSimilarity,
      );
    }

    return null;
  }
}

/// Result of email typo detection containing original and suggested values.
class EmailTypoResult {
  /// The original email entered by the user.
  final String originalEmail;

  /// The suggested corrected email.
  final String suggestedEmail;

  /// The original domain part that was mistyped.
  final String originalDomain;

  /// The suggested correct domain.
  final String suggestedDomain;

  /// Confidence score of the correction (0.0 to 1.0).
  final double confidence;

  const EmailTypoResult({
    required this.originalEmail,
    required this.suggestedEmail,
    required this.originalDomain,
    required this.suggestedDomain,
    required this.confidence,
  });

  @override
  String toString() {
    return 'EmailTypoResult(original: $originalEmail, suggested: $suggestedEmail, confidence: ${(confidence * 100).toStringAsFixed(1)}%)';
  }
}
