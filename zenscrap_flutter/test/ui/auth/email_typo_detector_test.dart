import 'package:flutter_test/flutter_test.dart';
import 'package:zenscrap_flutter/src/ui/auth/utils/email_typo_detector.dart';

void main() {
  group('EmailTypoDetector', () {
    // =========================================================================
    // GMAIL TYPOS
    // =========================================================================
    group('Gmail typos', () {
      test('detects "gmal.com" as Gmail typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmal.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
        expect(result.suggestedEmail, equals('user@gmail.com'));
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

      test('detects "gamil.com" as Gmail typo', () {
        final result = EmailTypoDetector.detectTypo('user@gamil.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmaill.com" as Gmail typo (double l)', () {
        final result = EmailTypoDetector.detectTypo('user@gmaill.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gnail.com" as Gmail typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@gnail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmai.com" as Gmail typo (missing l)', () {
        final result = EmailTypoDetector.detectTypo('user@gmai.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmail.co" as Gmail typo (missing m in .com)', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmail.con" as Gmail typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmail.om" as Gmail typo (missing c)', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.om');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmail.cm" as Gmail typo (missing o)', () {
        final result = EmailTypoDetector.detectTypo('user@gmail.cm');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmailcom" as Gmail typo (missing dot)', () {
        final result = EmailTypoDetector.detectTypo('user@gmailcom');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gemail.com" as Gmail typo (e instead of nothing)', () {
        final result = EmailTypoDetector.detectTypo('user@gemail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmsil.com" as Gmail typo (s instead of a)', () {
        final result = EmailTypoDetector.detectTypo('user@gmsil.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmeil.com" as Gmail typo (e instead of a)', () {
        final result = EmailTypoDetector.detectTypo('user@gmeil.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "gmaio.com" as Gmail typo (o instead of l)', () {
        final result = EmailTypoDetector.detectTypo('user@gmaio.com');
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

      test('detects "hotmail.co" as Hotmail typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmail.con" as Hotmail typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmail.om" as Hotmail typo (missing c)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.om');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hotmail.cm" as Hotmail typo (missing o)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.cm');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "hitmail.com" as Hotmail typo (i instead of o)', () {
        final result = EmailTypoDetector.detectTypo('user@hitmail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "htmail.com" as Hotmail typo (missing o)', () {
        final result = EmailTypoDetector.detectTypo('user@htmail.com');
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

      test('detects "hormail.com" as Hotmail typo (r instead of t)', () {
        final result = EmailTypoDetector.detectTypo('user@hormail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "homail.com" as Hotmail typo (missing t)', () {
        final result = EmailTypoDetector.detectTypo('user@homail.com');
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

      test('detects "outlook.co" as Outlook typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@outlook.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('detects "outlook.con" as Outlook typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@outlook.con');
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

      test('detects "yahoo.co" as Yahoo typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@yahoo.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('detects "yahoo.con" as Yahoo typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@yahoo.con');
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

      test('detects "icloud.co" as iCloud typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@icloud.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('icloud.com'));
      });

      test('detects "icloud.con" as iCloud typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@icloud.con');
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

      test('detects "live.co" as Live typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@live.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('live.com'));
      });

      test('detects "live.con" as Live typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@live.con');
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

      test('detects "protonmail.co" as ProtonMail typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@protonmail.co');
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
    // AOL TYPOS
    // =========================================================================
    group('AOL typos', () {
      test('detects "aol.co" as AOL typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@aol.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('aol.com'));
      });

      test('detects "aol.con" as AOL typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@aol.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('aol.com'));
      });

      test('detects "aoll.com" as AOL typo (double l)', () {
        final result = EmailTypoDetector.detectTypo('user@aoll.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('aol.com'));
      });

      test('does NOT flag correct "aol.com"', () {
        final result = EmailTypoDetector.detectTypo('user@aol.com');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // MSN TYPOS
    // =========================================================================
    group('MSN typos', () {
      test('detects "msn.co" as MSN typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@msn.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('msn.com'));
      });

      test('detects "msn.con" as MSN typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@msn.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('msn.com'));
      });

      test('does NOT flag correct "msn.com"', () {
        final result = EmailTypoDetector.detectTypo('user@msn.com');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // GMX TYPOS
    // =========================================================================
    group('GMX typos', () {
      test('detects "gmx.co" as GMX typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@gmx.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmx.com'));
      });

      test('detects "gmx.con" as GMX typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@gmx.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmx.com'));
      });

      test('does NOT flag correct "gmx.com"', () {
        final result = EmailTypoDetector.detectTypo('user@gmx.com');
        expect(result, isNull);
      });

      test('does NOT flag "gmx.de" (valid regional)', () {
        final result = EmailTypoDetector.detectTypo('user@gmx.de');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // ZOHO TYPOS
    // =========================================================================
    group('Zoho typos', () {
      test('detects "zoho.co" as Zoho typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@zoho.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('zoho.com'));
      });

      test('detects "zoho.con" as Zoho typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@zoho.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('zoho.com'));
      });

      test('detects "zooho.com" as Zoho typo (double o)', () {
        final result = EmailTypoDetector.detectTypo('user@zooho.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('zoho.com'));
      });

      test('does NOT flag correct "zoho.com"', () {
        final result = EmailTypoDetector.detectTypo('user@zoho.com');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // BRAZILIAN PROVIDERS
    // =========================================================================
    group('Brazilian provider typos', () {
      test('detects "uol.com.b" as UOL typo (missing r)', () {
        final result = EmailTypoDetector.detectTypo('user@uol.com.b');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('uol.com.br'));
      });

      test('detects "uol.combr" as UOL typo (missing dot)', () {
        final result = EmailTypoDetector.detectTypo('user@uol.combr');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('uol.com.br'));
      });

      test('does NOT flag correct "uol.com.br"', () {
        final result = EmailTypoDetector.detectTypo('user@uol.com.br');
        expect(result, isNull);
      });

      test('does NOT flag "terra.com.br" (valid provider)', () {
        final result = EmailTypoDetector.detectTypo('user@terra.com.br');
        expect(result, isNull);
      });

      test('does NOT flag "globo.com" (valid provider)', () {
        final result = EmailTypoDetector.detectTypo('user@globo.com');
        expect(result, isNull);
      });

      test('does NOT flag "bol.com.br" (valid provider)', () {
        final result = EmailTypoDetector.detectTypo('user@bol.com.br');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // YANDEX/MAIL.RU TYPOS
    // =========================================================================
    group('Russian provider typos', () {
      test('detects "yandex.co" as Yandex typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@yandex.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yandex.com'));
      });

      test('detects "yandex.con" as Yandex typo (n instead of m)', () {
        final result = EmailTypoDetector.detectTypo('user@yandex.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yandex.com'));
      });

      test('does NOT flag correct "yandex.com"', () {
        final result = EmailTypoDetector.detectTypo('user@yandex.com');
        expect(result, isNull);
      });

      test('does NOT flag "yandex.ru" (valid regional)', () {
        final result = EmailTypoDetector.detectTypo('user@yandex.ru');
        expect(result, isNull);
      });

      test('does NOT flag "mail.ru" (valid provider)', () {
        final result = EmailTypoDetector.detectTypo('user@mail.ru');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // FASTMAIL / TUTANOTA TYPOS
    // =========================================================================
    group('Secure email provider typos', () {
      test('detects "fastmail.co" as Fastmail typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@fastmail.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('fastmail.com'));
      });

      test('does NOT flag correct "fastmail.com"', () {
        final result = EmailTypoDetector.detectTypo('user@fastmail.com');
        expect(result, isNull);
      });

      test('does NOT flag "fastmail.fm" (valid alternative)', () {
        final result = EmailTypoDetector.detectTypo('user@fastmail.fm');
        expect(result, isNull);
      });

      test('detects "tutanota.co" as Tutanota typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@tutanota.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('tutanota.com'));
      });

      test('does NOT flag correct "tutanota.com"', () {
        final result = EmailTypoDetector.detectTypo('user@tutanota.com');
        expect(result, isNull);
      });

      test('does NOT flag "tuta.io" (valid alternative)', () {
        final result = EmailTypoDetector.detectTypo('user@tuta.io');
        expect(result, isNull);
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

      test('does NOT flag "hotmail.es"', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.es');
        expect(result, isNull);
      });

      test('does NOT flag "hotmail.it"', () {
        final result = EmailTypoDetector.detectTypo('user@hotmail.it');
        expect(result, isNull);
      });

      test('does NOT flag "outlook.co.uk"', () {
        final result = EmailTypoDetector.detectTypo('user@outlook.co.uk');
        expect(result, isNull);
      });

      test('does NOT flag "outlook.fr"', () {
        final result = EmailTypoDetector.detectTypo('user@outlook.fr');
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

      test('does NOT flag "yahoo.de"', () {
        final result = EmailTypoDetector.detectTypo('user@yahoo.de');
        expect(result, isNull);
      });

      test('does NOT flag "yahoo.co.in"', () {
        final result = EmailTypoDetector.detectTypo('user@yahoo.co.in');
        expect(result, isNull);
      });

      test('does NOT flag "live.co.uk"', () {
        final result = EmailTypoDetector.detectTypo('user@live.co.uk');
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

      test('does NOT flag "sbcglobal.net"', () {
        final result = EmailTypoDetector.detectTypo('user@sbcglobal.net');
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

      test('preserves original local part exactly', () {
        final result = EmailTypoDetector.detectTypo('MyName@gmal.com');
        expect(result, isNotNull);
        // Should preserve "myname" as lowercase since we lowercase everything
        expect(result!.suggestedEmail, equals('myname@gmail.com'));
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

      test('does NOT flag government domain "user@agency.gov"', () {
        final result = EmailTypoDetector.detectTypo('user@agency.gov');
        expect(result, isNull);
      });

      test('does NOT flag random domain "user@randomdomain123.net"', () {
        final result = EmailTypoDetector.detectTypo('user@randomdomain123.net');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // CONFIDENCE SCORES
    // =========================================================================
    group('Confidence scores', () {
      test('exact typo mapping has high confidence (>0.9)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmal.com');
        expect(result, isNotNull);
        expect(result!.confidence, greaterThan(0.9));
      });

      test('fuzzy match has moderate confidence', () {
        final result = EmailTypoDetector.detectTypo('user@gmeil.com');
        expect(result, isNotNull);
        expect(result!.confidence, greaterThan(0.6));
      });
    });

    // =========================================================================
    // KEYBOARD PROXIMITY TYPOS (adjacent keys)
    // =========================================================================
    group('Keyboard proximity typos', () {
      test('detects "gmsil.com" as Gmail typo (s adjacent to a)', () {
        final result = EmailTypoDetector.detectTypo('user@gmsil.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "hotmaol.com" as Hotmail typo (o adjacent to i)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmaol.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "yshoo.com" as Yahoo typo (s adjacent to a)', () {
        final result = EmailTypoDetector.detectTypo('user@yshoo.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });
    });

    // =========================================================================
    // DOUBLE CHARACTER TYPOS
    // =========================================================================
    group('Double character typos', () {
      test('detects "gmaiil.com" as Gmail typo', () {
        final result = EmailTypoDetector.detectTypo('user@gmaiil.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "ggmail.com" as Gmail typo', () {
        final result = EmailTypoDetector.detectTypo('user@ggmail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "yahooo.com" as Yahoo typo', () {
        final result = EmailTypoDetector.detectTypo('user@yahooo.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });

      test('detects "hottmail.com" as Hotmail typo', () {
        final result = EmailTypoDetector.detectTypo('user@hottmail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });
    });

    // =========================================================================
    // MISSING CHARACTER TYPOS
    // =========================================================================
    group('Missing character typos', () {
      test('detects "gail.com" as Gmail typo (missing m)', () {
        final result = EmailTypoDetector.detectTypo('user@gail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "htmail.com" as Hotmail typo (missing o)', () {
        final result = EmailTypoDetector.detectTypo('user@htmail.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "otlook.com" as Outlook typo (missing u)', () {
        final result = EmailTypoDetector.detectTypo('user@otlook.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('outlook.com'));
      });

      test('detects "yaho.com" as Yahoo typo (missing o)', () {
        final result = EmailTypoDetector.detectTypo('user@yaho.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });
    });

    // =========================================================================
    // TRANSPOSITION TYPOS (swapped characters)
    // =========================================================================
    group('Transposition typos', () {
      test('detects "gmial.com" as Gmail typo (i and a swapped)', () {
        final result = EmailTypoDetector.detectTypo('user@gmial.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
      });

      test('detects "hotmial.com" as Hotmail typo (i and a swapped)', () {
        final result = EmailTypoDetector.detectTypo('user@hotmial.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('hotmail.com'));
      });

      test('detects "yaaho.com" as Yahoo typo (a and h swapped)', () {
        final result = EmailTypoDetector.detectTypo('user@yaaho.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yahoo.com'));
      });
    });

    // =========================================================================
    // SPECIAL REAL-WORLD CASE FROM USER
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
    // TLD TYPOS (.com variations)
    // =========================================================================
    group('TLD typos', () {
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
    });

    // =========================================================================
    // INTERNATIONAL PROVIDERS - Should NOT be flagged
    // =========================================================================
    group('International providers (should NOT be flagged)', () {
      // Chinese providers
      test('does NOT flag qq.com (Chinese)', () {
        final result = EmailTypoDetector.detectTypo('user@qq.com');
        expect(result, isNull);
      });

      test('does NOT flag 163.com (Chinese)', () {
        final result = EmailTypoDetector.detectTypo('user@163.com');
        expect(result, isNull);
      });

      test('does NOT flag 126.com (Chinese)', () {
        final result = EmailTypoDetector.detectTypo('user@126.com');
        expect(result, isNull);
      });

      // Japanese providers
      test('does NOT flag yahoo.co.jp (Japanese)', () {
        final result = EmailTypoDetector.detectTypo('user@yahoo.co.jp');
        expect(result, isNull);
      });

      test('does NOT flag docomo.ne.jp (Japanese)', () {
        final result = EmailTypoDetector.detectTypo('user@docomo.ne.jp');
        expect(result, isNull);
      });

      // French providers
      test('does NOT flag free.fr (French)', () {
        final result = EmailTypoDetector.detectTypo('user@free.fr');
        expect(result, isNull);
      });

      test('does NOT flag orange.fr (French)', () {
        final result = EmailTypoDetector.detectTypo('user@orange.fr');
        expect(result, isNull);
      });

      test('does NOT flag laposte.net (French)', () {
        final result = EmailTypoDetector.detectTypo('user@laposte.net');
        expect(result, isNull);
      });

      // German providers
      test('does NOT flag web.de (German)', () {
        final result = EmailTypoDetector.detectTypo('user@web.de');
        expect(result, isNull);
      });

      test('does NOT flag t-online.de (German)', () {
        final result = EmailTypoDetector.detectTypo('user@t-online.de');
        expect(result, isNull);
      });

      // Italian providers
      test('does NOT flag libero.it (Italian)', () {
        final result = EmailTypoDetector.detectTypo('user@libero.it');
        expect(result, isNull);
      });

      test('does NOT flag virgilio.it (Italian)', () {
        final result = EmailTypoDetector.detectTypo('user@virgilio.it');
        expect(result, isNull);
      });

      // Polish providers
      test('does NOT flag wp.pl (Polish)', () {
        final result = EmailTypoDetector.detectTypo('user@wp.pl');
        expect(result, isNull);
      });

      test('does NOT flag onet.pl (Polish)', () {
        final result = EmailTypoDetector.detectTypo('user@onet.pl');
        expect(result, isNull);
      });

      // Russian providers
      test('does NOT flag yandex.ru (Russian)', () {
        final result = EmailTypoDetector.detectTypo('user@yandex.ru');
        expect(result, isNull);
      });

      test('does NOT flag mail.ru (Russian)', () {
        final result = EmailTypoDetector.detectTypo('user@mail.ru');
        expect(result, isNull);
      });

      // South Korean providers
      test('does NOT flag naver.com (South Korean)', () {
        final result = EmailTypoDetector.detectTypo('user@naver.com');
        expect(result, isNull);
      });

      test('does NOT flag daum.net (South Korean)', () {
        final result = EmailTypoDetector.detectTypo('user@daum.net');
        expect(result, isNull);
      });

      // Australian providers
      test('does NOT flag bigpond.com (Australian)', () {
        final result = EmailTypoDetector.detectTypo('user@bigpond.com');
        expect(result, isNull);
      });

      // UK providers
      test('does NOT flag btinternet.com (UK)', () {
        final result = EmailTypoDetector.detectTypo('user@btinternet.com');
        expect(result, isNull);
      });

      test('does NOT flag sky.com (UK)', () {
        final result = EmailTypoDetector.detectTypo('user@sky.com');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // INTERNATIONAL TYPOS DETECTION
    // =========================================================================
    group('International typos detection', () {
      // French typos
      test('detects "fre.fr" as free.fr typo', () {
        final result = EmailTypoDetector.detectTypo('user@fre.fr');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('free.fr'));
      });

      test('detects "ornage.fr" as orange.fr typo', () {
        final result = EmailTypoDetector.detectTypo('user@ornage.fr');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('orange.fr'));
      });

      // German typos
      test('detects "web.d" as web.de typo', () {
        final result = EmailTypoDetector.detectTypo('user@web.d');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('web.de'));
      });

      // Italian typos
      test('detects "libero.i" as libero.it typo', () {
        final result = EmailTypoDetector.detectTypo('user@libero.i');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('libero.it'));
      });

      // Chinese typos
      test('detects "qq.co" as qq.com typo', () {
        final result = EmailTypoDetector.detectTypo('user@qq.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('qq.com'));
      });

      test('detects "163.con" as 163.com typo', () {
        final result = EmailTypoDetector.detectTypo('user@163.con');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('163.com'));
      });

      // Korean typos
      test('detects "naver.co" as naver.com typo', () {
        final result = EmailTypoDetector.detectTypo('user@naver.co');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('naver.com'));
      });

      // Russian typos
      test('detects "yandx.ru" as yandex.ru typo', () {
        final result = EmailTypoDetector.detectTypo('user@yandx.ru');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('yandex.ru'));
      });
    });

    // =========================================================================
    // SIMILARITY-BASED DETECTION (fallback algorithm)
    // =========================================================================
    group('Similarity-based detection', () {
      test('detects unknown typo via similarity algorithm', () {
        // A typo not in the hardcoded table but similar enough
        final result = EmailTypoDetector.detectTypo('user@gmaul.com');
        expect(result, isNotNull);
        expect(result!.suggestedDomain, equals('gmail.com'));
        expect(result.confidence, greaterThanOrEqualTo(0.6));
      });

      test('returns confidence score for similarity-based matches', () {
        final result = EmailTypoDetector.detectTypo('user@hotmaiil.com');
        expect(result, isNotNull);
        expect(result!.confidence, greaterThan(0.0));
        expect(result.confidence, lessThanOrEqualTo(1.0));
      });

      test('does NOT flag unknown domains below similarity threshold', () {
        // Completely unrelated domain
        final result = EmailTypoDetector.detectTypo('user@company.com');
        expect(result, isNull);
      });

      test('does NOT flag custom/corporate domains', () {
        final result = EmailTypoDetector.detectTypo('user@mycompany.org');
        expect(result, isNull);
      });
    });

    // =========================================================================
    // HYBRID APPROACH VERIFICATION
    // =========================================================================
    group('Hybrid approach verification', () {
      test('table lookup returns high confidence (0.95)', () {
        // Known typo from table
        final result = EmailTypoDetector.detectTypo('user@hotmal.com');
        expect(result, isNotNull);
        expect(result!.confidence, equals(0.95));
      });

      test('similarity match returns calculated confidence', () {
        // Unknown typo detected via similarity
        final result = EmailTypoDetector.detectTypo('user@hotmailo.com');
        expect(result, isNotNull);
        expect(result!.confidence, greaterThanOrEqualTo(0.6));
        expect(result.confidence, lessThan(0.95));
      });
    });

    // =========================================================================
    // EmailTypoResult toString
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
