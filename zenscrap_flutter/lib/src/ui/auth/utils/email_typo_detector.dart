import 'package:string_similarity/string_similarity.dart';

/// Utility class for detecting email provider typos and suggesting corrections.
///
/// Uses Dice's Coefficient algorithm (via string_similarity package) to compare
/// the user's email domain against a list of known email providers.
///
/// The algorithm works by:
/// 1. Extracting the domain from the email
/// 2. Checking if it's already a known valid domain (no typo)
/// 3. Comparing it against ALL known domains using string similarity
/// 4. If similarity is high (but not exact), suggesting a correction
class EmailTypoDetector {
  EmailTypoDetector._();

  /// Minimum similarity threshold to consider a typo (0.0 to 1.0).
  /// A value of 0.5 means domains must be at least 50% similar.
  /// Lower values catch more typos but may produce false positives.
  static const double _similarityThreshold = 0.5;

  /// Maximum similarity that still counts as a typo (below 1.0).
  /// If similarity is >= 0.99, it's considered an exact match (no typo).
  static const double _exactMatchThreshold = 0.99;

  /// Set of known valid email provider domains.
  /// These are the "correct" domains we compare against.
  static const Set<String> _knownDomains = {
    // Gmail - Google's email service
    'gmail.com',
    'googlemail.com',

    // Microsoft services
    'hotmail.com',
    'hotmail.co.uk',
    'hotmail.fr',
    'hotmail.de',
    'hotmail.es',
    'hotmail.it',
    'hotmail.com.br',
    'outlook.com',
    'outlook.co.uk',
    'outlook.fr',
    'outlook.de',
    'outlook.es',
    'outlook.it',
    'outlook.com.br',
    'live.com',
    'live.co.uk',
    'live.fr',
    'live.de',
    'msn.com',

    // Yahoo services
    'yahoo.com',
    'yahoo.co.uk',
    'yahoo.fr',
    'yahoo.de',
    'yahoo.es',
    'yahoo.it',
    'yahoo.com.br',
    'yahoo.ca',
    'yahoo.co.in',
    'ymail.com',
    'rocketmail.com',

    // Apple services
    'icloud.com',
    'me.com',
    'mac.com',

    // AOL
    'aol.com',
    'aol.co.uk',

    // Secure email providers
    'protonmail.com',
    'proton.me',
    'pm.me',
    'tutanota.com',
    'tutamail.com',
    'tuta.io',

    // Other popular providers
    'zoho.com',
    'zohomail.com',
    'gmx.com',
    'gmx.de',
    'gmx.net',
    'mail.com',
    'email.com',
    'fastmail.com',
    'fastmail.fm',
    'inbox.com',

    // Russian providers
    'yandex.com',
    'yandex.ru',
    'mail.ru',

    // Brazilian providers
    'uol.com.br',
    'bol.com.br',
    'terra.com.br',
    'terra.com',
    'globo.com',
    'globomail.com',
    'ig.com.br',

    // ISP/Telecom providers
    'cox.net',
    'comcast.net',
    'att.net',
    'sbcglobal.net',
    'verizon.net',

    // Indian providers
    'rediffmail.com',
    'rediff.com',
  };

  /// Common TLD (top-level domain) typos that the similarity algorithm
  /// might not catch well because they're very short strings.
  /// Maps incorrect TLD endings to correct ones.
  static const Map<String, String> _tldCorrections = {
    '.con': '.com',
    '.cmo': '.com',
    '.ocm': '.com',
    '.vom': '.com',
    '.xom': '.com',
    '.cim': '.com',
    '.com.': '.com',
    '.copm': '.com',
    '.comm': '.com',
    '.coom': '.com',
    '.co': '.com', // Catches gmail.co -> gmail.com
    '.cm': '.com',
    '.om': '.com',
    '.nt': '.net',
    '.ney': '.net',
    '.met': '.net',
  };

  /// Detects if an email has a typo in the domain and suggests a correction.
  ///
  /// Returns [EmailTypoResult] if a typo is detected, null otherwise.
  static EmailTypoResult? detectTypo(String email) {
    email = email.toLowerCase().trim();

    // Extract domain from email
    final atIndex = email.lastIndexOf('@');
    if (atIndex == -1 || atIndex == email.length - 1) {
      return null; // Invalid email format
    }

    final localPart = email.substring(0, atIndex);
    final domain = email.substring(atIndex + 1);

    // If domain is already a known provider, no typo
    if (_knownDomains.contains(domain)) {
      return null;
    }

    // Step 1: Try to fix TLD typos first (e.g., gmail.con -> gmail.com)
    final tldCorrectedDomain = _tryFixTld(domain);
    if (tldCorrectedDomain != null && _knownDomains.contains(tldCorrectedDomain)) {
      return EmailTypoResult(
        originalEmail: email,
        suggestedEmail: '$localPart@$tldCorrectedDomain',
        originalDomain: domain,
        suggestedDomain: tldCorrectedDomain,
        confidence: 0.95, // High confidence for TLD fixes
      );
    }

    // Step 2: Use string similarity to find the best matching known domain
    final result = _findBestMatch(domain);

    if (result != null) {
      return EmailTypoResult(
        originalEmail: email,
        suggestedEmail: '$localPart@${result.domain}',
        originalDomain: domain,
        suggestedDomain: result.domain,
        confidence: result.similarity,
      );
    }

    return null;
  }

  /// Tries to fix common TLD typos in the domain.
  /// Returns the corrected domain if a TLD fix was applied, null otherwise.
  static String? _tryFixTld(String domain) {
    for (final entry in _tldCorrections.entries) {
      if (domain.endsWith(entry.key)) {
        // Replace the incorrect TLD with the correct one
        final baseDomain = domain.substring(0, domain.length - entry.key.length);
        return '$baseDomain${entry.value}';
      }
    }
    return null;
  }

  /// Finds the best matching known domain using string similarity.
  /// Returns the match if similarity is above threshold, null otherwise.
  static _SimilarityMatch? _findBestMatch(String inputDomain) {
    String? bestMatch;
    double bestSimilarity = 0.0;

    for (final knownDomain in _knownDomains) {
      final similarity = StringSimilarity.compareTwoStrings(
        inputDomain,
        knownDomain,
      );

      if (similarity > bestSimilarity) {
        bestSimilarity = similarity;
        bestMatch = knownDomain;
      }
    }

    // Only return if we found a good match that's not exact
    if (bestMatch != null &&
        bestSimilarity >= _similarityThreshold &&
        bestSimilarity < _exactMatchThreshold) {
      return _SimilarityMatch(domain: bestMatch, similarity: bestSimilarity);
    }

    return null;
  }
}

/// Internal class to hold similarity match results.
class _SimilarityMatch {
  final String domain;
  final double similarity;

  const _SimilarityMatch({required this.domain, required this.similarity});
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
  /// Higher values indicate more confidence in the suggestion.
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
