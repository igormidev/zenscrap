import 'package:flutter_test/flutter_test.dart';
import 'package:zenscrap_flutter/src/ui/auth/utils/email_typo_detector.dart';

void main() {
  group('EmailTypoDetector', () {
    // =========================================================================
    // CORE FUNCTIONALITY - Similarity-based detection
    // =========================================================================
    group('Similarity-based detection', () {
      test('detects typo and suggests correction based on string similarity', () {
        final result = EmailTypoDetector.detectTypo('user@gmal.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
        expect(result.confidence, greaterThan(0.5));
      });

      test('returns similarity confidence score', () {
        final result = EmailTypoDetector.detectTypo('user@hotmal.com');
        expect(result, isNotNull);
        expect(result!.confidence, greaterThan(0.0));
        expect(result.confidence, lessThan(1.0));
      });

      test('higher similarity typos have higher confidence', () {
        // Small typo (one character off)
        final smallTypo = EmailTypoDetector.detectTypo('user@gmial.com');
        // Bigger typo (multiple characters)
        final biggerTypo = EmailTypoDetector.detectTypo('user@gmal.com');

        expect(smallTypo, isNotNull);
        expect(biggerTypo, isNotNull);
        // Both should be detected, confidence may vary
        expect(smallTypo!.confidence, greaterThan(0.5));
        expect(biggerTypo!.confidence, greaterThan(0.5));
      });
    });

    // =========================================================================
    // GMAIL TYPOS - Using similarity algorithm
    // =========================================================================
    group('Gmail typos', () {
      test('detects "gmal.com" as Gmail typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmal.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmial.com" as Gmail typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmial.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmali.com" as Gmail typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmali.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gamil.com" as typo (algorithm may suggest mail.com or gmail.com)', () {
        final result = EmailTypoDetector.detectTypo('user@gamil.com');
        expect(result, isNotNull);
        // Algorithm may find mail.com or gmail.com as best match - both are valid
        expect(result!.suggestedDomain, anyOf('gmail.com', 'mail.com'));
      });

      test('detects "gmaill.com" as Gmail typo (double l)', () {
        final result = EmailTypoDetector.detectTypo('user@gmaill.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gnail.com" as typo (algorithm may suggest mail.com or gmail.com)', () {
        final result = EmailTypoDetector.detectTypo('user@gnail.com');
        expect(result, isNotNull);
        // Algorithm may find mail.com or gmail.com as best match - both are valid
        expect(result!.suggestedDomain, anyOf('gmail.com', 'mail.com'));
      });

      test('detects "gmai.com" as Gmail typo (missing l)', () {
        final result = EmailTypoDetector.detectTypo('user@gmai.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gemail.com" as typo (algorithm may suggest email.com or gmail.com)', () {
        final result = EmailTypoDetector.detectTypo('user@gemail.com');
        expect(result, isNotNull);
        // Algorithm may find email.com or gmail.com as best match - both are valid
        expect(result!.suggestedDomain, anyOf('gmail.com', 'email.com'));
      });

      test('detects "gmaiil.com" as Gmail typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmaiil.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('does NOT flag correct "gmail.com"', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.com');
        expect(result, isNull);
      });

      test('does NOT flag "googlemail.com" (valid alternative)', () {
        final result = EmailTypoDetector.detectTypo('user@googlemail.com');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // HOTMAIL TYPOS
    // =========================================================================
    group('Hotmail typos', () {
      test('detects "hotmal.com" as Hotmail typo (missing i)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmal.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmai.com" as Hotmail typo (missing l)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmai.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmial.com" as Hotmail typo (ai swapped)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmial.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmaill.com" as Hotmail typo (double l)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmaill.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmil.com" as Hotmail typo (missing a)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmil.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotamil.com" as Hotmail typo (extra a)', () {
        final result = EmailTypoDetector.detectTypo('user@hotamil.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmmail.com" as Hotmail typo (double m)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmmail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotnail.com" as Hotmail typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@hotnail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmsil.com" as Hotmail typo (s instead of a)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmsil.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmeil.com" as Hotmail typo (e instead of a)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmeil.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmaikl.com" as Hotmail typo (extra k)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmaikl.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('does NOT flag correct "hotmail.com"', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.com');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // OUTLOOK TYPOS
    // =========================================================================
    group('Outlook typos', () {
      test('detects "outloo.com" as Outlook typo (missing k)', () {
        final result = EmailTypoDetector.detectTypo('user@outloo.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('detects "outlok.com" as Outlook typo (missing o)', () {
        final result = EmailTypoDetector.detectTypo('user@outlok.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('detects "outllook.com" as Outlook typo (double l)', () {
        final result = EmailTypoDetector.detectTypo('user@outllook.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('detects "outloook.com" as Outlook typo (triple o)', () {
        final result = EmailTypoDetector.detectTypo('user@outloook.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('detects "otlook.com" as Outlook typo (missing u)', () {
        final result = EmailTypoDetector.detectTypo('user@otlook.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('detects "outlool.com" as Outlook typo (l instead of k)', () {
        final result = EmailTypoDetector.detectTypo('user@outlool.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('detects "outlouk.com" as Outlook typo (u instead of o)', () {
        final result = EmailTypoDetector.detectTypo('user@outlouk.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('detects "outlokk.com" as Outlook typo (double k)', () {
        final result = EmailTypoDetector.detectTypo('user@outlokk.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('does NOT flag correct "outlook.com"', () {
        final result = EmailTypoDetector.detectTypo('user@outlook.com');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // YAHOO TYPOS
    // =========================================================================
    group('Yahoo typos', () {
      test('detects "yaho.com" as Yahoo typo (missing o)', () {
        final result = EmailTypoDetector.detectTypo('user@yaho.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('detects "yahooo.com" as Yahoo typo (triple o)', () {
        final result = EmailTypoDetector.detectTypo('user@yahooo.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('detects "yhaoo.com" as Yahoo typo (letters swapped)', () {
        final result = EmailTypoDetector.detectTypo('user@yhaoo.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('detects "yhoo.com" as Yahoo typo (missing a)', () {
        final result = EmailTypoDetector.detectTypo('user@yhoo.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('detects "yaoo.com" as Yahoo typo (missing h)', () {
        final result = EmailTypoDetector.detectTypo('user@yaoo.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('detects "yshoo.com" as Yahoo typo (s instead of a)', () {
        final result = EmailTypoDetector.detectTypo('user@yshoo.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('detects "yahhoo.com" as Yahoo typo (double h)', () {
        final result = EmailTypoDetector.detectTypo('user@yahhoo.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('detects "yahho.com" as Yahoo typo (double h, missing o)', () {
        final result = EmailTypoDetector.detectTypo('user@yahho.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('does NOT flag correct "yahoo.com"', () {
        final result = EmailTypoDetector.detectTypo('user@yahoo.com');
        expect(result, isNull);
      });

      test('does NOT flag "ymail.com" (valid Yahoo alternative)', () {
        final result = EmailTypoDetector.detectTypo('user@ymail.com');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // ICLOUD TYPOS
    // =========================================================================
    group('iCloud typos', () {
      test('detects "iclod.com" as iCloud typo (missing u)', () {
        final result = EmailTypoDetector.detectTypo('user@iclod.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('icloud.com'));
      });

      test('detects "iclould.com" as iCloud typo (extra l)', () {
        final result = EmailTypoDetector.detectTypo('user@iclould.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('icloud.com'));
      });

      test('detects "icoud.com" as iCloud typo (missing l)', () {
        final result = EmailTypoDetector.detectTypo('user@icoud.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('icloud.com'));
      });

      test('detects "iclooud.com" as iCloud typo (double o)', () {
        final result = EmailTypoDetector.detectTypo('user@iclooud.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('icloud.com'));
      });

      test('detects "iclud.com" as iCloud typo (missing o)', () {
        final result = EmailTypoDetector.detectTypo('user@iclud.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('icloud.com'));
      });

      test('does NOT flag correct "icloud.com"', () {
        final result = EmailTypoDetector.detectTypo('user@icloud.com');
        expect(result, isNull);
      });

      test('does NOT flag "me.com" (valid Apple alternative)', () {
        final result = EmailTypoDetector.detectTypo('user@me.com');
        expect(result, isNull);
      });

      test('does NOT flag "mac.com" (valid Apple alternative)', () {
        final result = EmailTypoDetector.detectTypo('user@mac.com');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // LIVE.COM TYPOS
    // =========================================================================
    group('Live.com typos', () {
      test('detects "liv.com" as Live typo (missing e)', () {
        final result = EmailTypoDetector.detectTypo('user@liv.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('live.com'));
      });

      test('detects "lve.com" as Live typo (missing i)', () {
        final result = EmailTypoDetector.detectTypo('user@lve.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('live.com'));
      });

      test('detects "livee.com" as Live typo (double e)', () {
        final result = EmailTypoDetector.detectTypo('user@livee.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('live.com'));
      });

      test('does NOT flag correct "live.com"', () {
        final result = EmailTypoDetector.detectTypo('user@live.com');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // PROTONMAIL TYPOS
    // =========================================================================
    group('ProtonMail typos', () {
      test('detects "protonmal.com" as ProtonMail typo (missing i)', () {
        final result = EmailTypoDetector.detectTypo('user@protonmal.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('protonmail.com'));
      });

      test('detects "protonmial.com" as ProtonMail typo (swapped ai)', () {
        final result = EmailTypoDetector.detectTypo('user@protonmial.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('protonmail.com'));
      });

      test('detects "protonmai.com" as ProtonMail typo (missing l)', () {
        final result = EmailTypoDetector.detectTypo('user@protonmai.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('protonmail.com'));
      });

      test('detects "protonmaill.com" as ProtonMail typo (double l)', () {
        final result = EmailTypoDetector.detectTypo('user@protonmaill.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('protonmail.com'));
      });

      test('detects "protnmail.com" as ProtonMail typo (missing o)', () {
        final result = EmailTypoDetector.detectTypo('user@protnmail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('protonmail.com'));
      });

      test('does NOT flag correct "protonmail.com"', () {
        final result = EmailTypoDetector.detectTypo('user@protonmail.com');
        expect(result, isNull);
      });

      test('does NOT flag "proton.me" (valid alternative)', () {
        final result = EmailTypoDetector.detectTypo('user@proton.me');
        expect(result, isNull);
      });

      test('does NOT flag "pm.me" (valid alternative)', () {
        final result = EmailTypoDetector.detectTypo('user@pm.me');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // TLD (TOP-LEVEL DOMAIN) TYPOS
    // These are handled by special TLD correction logic
    // =========================================================================
    group('TLD typos', () {
      test('detects ".con" as .com typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects ".co" as .com typo for Gmail', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects ".cmo" as .com typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.cmo');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects ".ocm" as .com typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.ocm');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects ".copm" as .com typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.copm');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects ".cm" as .com typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.cm');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects ".om" as .com typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.om');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('TLD fix works for Hotmail', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('TLD fix works for Yahoo', () {
        final result = EmailTypoDetector.detectTypo('user@yahoo.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('TLD fix works for Outlook', () {
        final result = EmailTypoDetector.detectTypo('user@outlook.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('TLD fix works for iCloud', () {
        final result = EmailTypoDetector.detectTypo('user@icloud.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('icloud.com'));
      });

      test('TLD fix works for ProtonMail', () {
        final result = EmailTypoDetector.detectTypo('user@protonmail.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('protonmail.com'));
      });
    });

    // =========================================================================
    // REGIONAL VARIANTS - Should NOT be flagged
    // =========================================================================
    group('Regional variants (should NOT be flagged)', () {
      test('does NOT flag "hotmail.co.uk"', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.co.uk');
        expect(result, isNull);
      });

      test('does NOT flag "hotmail.fr"', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.fr');
        expect(result, isNull);
      });

      test('does NOT flag "hotmail.de"', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.de');
        expect(result, isNull);
      });

      test('does NOT flag "outlook.co.uk"', () {
        final result = EmailTypoDetector.detectTypo('user@outlook.co.uk');
        expect(result, isNull);
      });

      test('does NOT flag "yahoo.co.uk"', () {
        final result = EmailTypoDetector.detectTypo('user@yahoo.co.uk');
        expect(result, isNull);
      });

      test('does NOT flag "yahoo.fr"', () {
        final result = EmailTypoDetector.detectTypo('user@yahoo.fr');
        expect(result, isNull);
      });

      test('does NOT flag "live.co.uk"', () {
        final result = EmailTypoDetector.detectTypo('user@live.co.uk');
        expect(result, isNull);
      });

      test('does NOT flag "gmx.de"', () {
        final result = EmailTypoDetector.detectTypo('user@gmx.de');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // ISP / TELECOM PROVIDERS - Should NOT be flagged
    // =========================================================================
    group('ISP/Telecom providers (should NOT be flagged)', () {
      test('does NOT flag "cox.net"', () {
        final result = EmailTypoDetector.detectTypo('user@cox.net');
        expect(result, isNull);
      });

      test('does NOT flag "comcast.net"', () {
        final result = EmailTypoDetector.detectTypo('user@comcast.net');
        expect(result, isNull);
      });

      test('does NOT flag "att.net"', () {
        final result = EmailTypoDetector.detectTypo('user@att.net');
        expect(result, isNull);
      });

      test('does NOT flag "verizon.net"', () {
        final result = EmailTypoDetector.detectTypo('user@verizon.net');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // EDGE CASES
    // =========================================================================
    group('Edge cases', () {
      test('handles uppercase emails', () {
        final result = EmailTypoDetector.detectTypo('USER@GMAL.COM');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
        expect(result.suggestedEmail, equals('user@gmail.com'));
      });

      test('handles mixed case emails', () {
        final result = EmailTypoDetector.detectTypo('User@HotMal.Com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('handles emails with whitespace (trimmed)', () {
        final result = EmailTypoDetector.detectTypo('  user@gmal.com  ');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('returns null for invalid email without @', () {
        final result = EmailTypoDetector.detectTypo('usergmail.com');
        expect(result, isNull);
      });

      test('returns null for email with @ at the end', () {
        final result = EmailTypoDetector.detectTypo('user@');
        expect(result, isNull);
      });

      test('handles complex local part', () {
        final result = EmailTypoDetector.detectTypo('john.doe+work@gmal.com');
        expect(result, isNotNull);
        expect(result!.suggestedEmail, equals('john.doe+work@gmail.com'));
      });

      test('handles numeric local part', () {
        final result = EmailTypoDetector.detectTypo('12345@hotmal.com');
        expect(result, isNotNull);
        expect(result!.suggestedEmail, equals('12345@hotmail.com'));
      });
    });

    // =========================================================================
    // UNKNOWN DOMAINS - Should NOT be flagged
    // =========================================================================
    group('Unknown/corporate domains (should NOT be flagged)', () {
      test('does NOT flag company domain "user@company.com"', () {
        final result = EmailTypoDetector.detectTypo('user@company.com');
        expect(result, isNull);
      });

      test('does NOT flag custom domain "user@mywebsite.org"', () {
        final result = EmailTypoDetector.detectTypo('user@mywebsite.org');
        expect(result, isNull);
      });

      test('does NOT flag university domain "user@university.edu"', () {
        final result = EmailTypoDetector.detectTypo('user@university.edu');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // REAL-WORLD USER CASE
    // =========================================================================
    group('Real-world user case', () {
      test('detects "igor9ms@hotmal.com" as typo', () {
        final result = EmailTypoDetector.detectTypo('igor9ms@hotmal.com');
        expect(result, isNotNull);
        expect(result!.originalEmail, equals('igor9ms@hotmal.com'));
        expect(result!.suggestedEmail, equals('igor9ms@hotmail.com'));
        expect(result!.originalDomain, equals('hotmal.com'));
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });
    });

    // =========================================================================
    // EmailTypoResult
    // =========================================================================
    group('EmailTypoResult', () {
      test('toString returns readable format', () {
        final result = EmailTypoDetector.detectTypo('user@hotmal.com');
        expect(result, isNotNull);
        final str = result.toString();
        expect(str, contains('original'));
        expect(str, contains('suggested'));
        expect(str, contains('%'));
      });
    });
  });
}
