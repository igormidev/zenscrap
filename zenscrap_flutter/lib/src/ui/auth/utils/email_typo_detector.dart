import 'package:string_similarity/string_similarity.dart';

/// Utility class for detecting email provider typos and suggesting corrections.
///
/// Uses a HYBRID approach:
/// 1. First checks a hardcoded table of known common typos (fast, deterministic)
/// 2. If not found, uses string similarity algorithm (Dice's Coefficient) to
///    find the closest known email provider domain
///
/// This ensures:
/// - Known typos like "hotmal.com" → "hotmail.com" are always caught
/// - Unknown typos are still detected via similarity algorithm
/// - Only shows suggestions above 60% similarity threshold
class EmailTypoDetector {
  EmailTypoDetector._();

  /// Minimum similarity threshold to consider a typo (0.0 to 1.0).
  /// 0.6 = 60% similarity required before suggesting a correction.
  /// This prevents false positives for unrelated domains.
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

    // Chinese providers
    'qq.com': 'qq.com',
    '163.com': '163.com',
    '126.com': '126.com',
    'sina.com': 'sina.com',
    'sina.cn': 'sina.cn',
    'sohu.com': 'sohu.com',
    'aliyun.com': 'aliyun.com',
    '139.com': '139.com',
    '189.cn': '189.cn',

    // Japanese providers
    'yahoo.co.jp': 'yahoo.co.jp',
    'docomo.ne.jp': 'docomo.ne.jp',
    'softbank.ne.jp': 'softbank.ne.jp',
    'au.com': 'au.com',
    'ezweb.ne.jp': 'ezweb.ne.jp',
    'i.softbank.jp': 'i.softbank.jp',
    'nifty.com': 'nifty.com',
    'biglobe.ne.jp': 'biglobe.ne.jp',

    // French providers
    'free.fr': 'free.fr',
    'orange.fr': 'orange.fr',
    'sfr.fr': 'sfr.fr',
    'wanadoo.fr': 'wanadoo.fr',
    'laposte.net': 'laposte.net',
    'neuf.fr': 'neuf.fr',
    'bbox.fr': 'bbox.fr',

    // German providers (beyond GMX)
    'web.de': 'web.de',
    't-online.de': 't-online.de',
    'freenet.de': 'freenet.de',
    'arcor.de': 'arcor.de',
    'vodafone.de': 'vodafone.de',
    '1und1.de': '1und1.de',

    // Spanish providers
    'telefonica.net': 'telefonica.net',
    'movistar.es': 'movistar.es',
    'ono.com': 'ono.com',

    // Italian providers
    'libero.it': 'libero.it',
    'virgilio.it': 'virgilio.it',
    'tim.it': 'tim.it',
    'tiscali.it': 'tiscali.it',
    'alice.it': 'alice.it',
    'tin.it': 'tin.it',

    // Polish providers
    'wp.pl': 'wp.pl',
    'o2.pl': 'o2.pl',
    'interia.pl': 'interia.pl',
    'onet.pl': 'onet.pl',
    'poczta.onet.pl': 'poczta.onet.pl',
    'gazeta.pl': 'gazeta.pl',

    // Dutch providers
    'ziggo.nl': 'ziggo.nl',
    'xs4all.nl': 'xs4all.nl',
    'kpnmail.nl': 'kpnmail.nl',
    'hetnet.nl': 'hetnet.nl',

    // Belgian providers
    'skynet.be': 'skynet.be',
    'telenet.be': 'telenet.be',
    'proximus.be': 'proximus.be',

    // Russian providers (beyond Yandex/Mail.ru)
    'list.ru': 'list.ru',
    'bk.ru': 'bk.ru',
    'inbox.ru': 'inbox.ru',
    'rambler.ru': 'rambler.ru',

    // South Korean providers
    'naver.com': 'naver.com',
    'daum.net': 'daum.net',
    'hanmail.net': 'hanmail.net',
    'kakao.com': 'kakao.com',

    // Latin American providers
    'fibertel.com.ar': 'fibertel.com.ar',
    'prodigy.net.mx': 'prodigy.net.mx',
    'telmex.com': 'telmex.com',
    'speedy.com.ar': 'speedy.com.ar',

    // Australian providers
    'optusnet.com.au': 'optusnet.com.au',
    'bigpond.com': 'bigpond.com',
    'bigpond.net.au': 'bigpond.net.au',
    'iinet.net.au': 'iinet.net.au',

    // Canadian providers
    'rogers.com': 'rogers.com',
    'shaw.ca': 'shaw.ca',
    'bell.net': 'bell.net',
    'sympatico.ca': 'sympatico.ca',

    // UK providers (beyond Hotmail/Yahoo variants)
    'btinternet.com': 'btinternet.com',
    'sky.com': 'sky.com',
    'virginmedia.com': 'virginmedia.com',
    'talktalk.net': 'talktalk.net',
    'ntlworld.com': 'ntlworld.com',
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

    // AOL typos
    'aol.co': 'aol.com',
    'aol.con': 'aol.com',
    'aol.cm': 'aol.com',
    'aol.om': 'aol.com',
    'alo.com': 'aol.com',
    'al.com': 'aol.com',

    // Yahoo regional typos
    'yahoo.co.u': 'yahoo.co.uk',
    'yahoo.cok.uk': 'yahoo.co.uk',
    'yaho.co.uk': 'yahoo.co.uk',

    // Hotmail regional typos
    'hotmail.co.u': 'hotmail.co.uk',
    'hotmail.cok.uk': 'hotmail.co.uk',
    'hotmal.co.uk': 'hotmail.co.uk',

    // GMX typos
    'gmx.co': 'gmx.com',
    'gmx.con': 'gmx.com',
    'gms.com': 'gmx.com',
    'gmx.cm': 'gmx.com',

    // Mail.com typos
    'mail.co': 'mail.com',
    'mail.con': 'mail.com',
    'mail.cm': 'mail.com',
    'mail.om': 'mail.com',
    'mai.com': 'mail.com',
    'maill.com': 'mail.com',
    'mal.com': 'mail.com',

    // Yandex typos
    'yandex.co': 'yandex.com',
    'yandex.con': 'yandex.com',
    'yandex.r': 'yandex.ru',
    'yandx.ru': 'yandex.ru',
    'yanex.ru': 'yandex.ru',

    // Zoho typos
    'zoho.co': 'zoho.com',
    'zoho.con': 'zoho.com',
    'zohomail.co': 'zohomail.com',
    'zohomail.con': 'zohomail.com',
    'zohomal.com': 'zohomail.com',

    // Web.de typos
    'web.d': 'web.de',
    'webd.de': 'web.de',
    'webe.de': 'web.de',

    // Libero.it typos
    'libero.i': 'libero.it',
    'libero.ti': 'libero.it',
    'liber.it': 'libero.it',
    'liberio.it': 'libero.it',

    // Free.fr typos
    'free.f': 'free.fr',
    'free.rf': 'free.fr',
    'fre.fr': 'free.fr',

    // Orange.fr typos
    'orange.f': 'orange.fr',
    'orange.rf': 'orange.fr',
    'ornage.fr': 'orange.fr',
    'orage.fr': 'orange.fr',

    // QQ.com typos
    'qq.co': 'qq.com',
    'qq.con': 'qq.com',
    'qq.cm': 'qq.com',

    // 163.com typos
    '163.co': '163.com',
    '163.con': '163.com',
    '163.cm': '163.com',

    // Naver.com typos
    'naver.co': 'naver.com',
    'naver.con': 'naver.com',
    'nave.com': 'naver.com',
    'naverr.com': 'naver.com',
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
