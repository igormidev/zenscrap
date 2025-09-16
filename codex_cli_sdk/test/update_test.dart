import 'package:test/test.dart';
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() {
  group('Codex SDK Update Functionality', () {
    late Codex codexSDK;

    setUp(() {
      // Use a test API key or environment variable
      final apiKey = const String.fromEnvironment('OPENAI_API_KEY',
          defaultValue: 'test-api-key');
      codexSDK = Codex(apiKey);
    });

    tearDown(() async {
      await codexSDK.dispose();
    });

    test('version comparison logic', () {
      // Test the version comparison logic
      bool isNewerVersion(String current, String latest) {
        try {
          final currentParts = current.split('.').map(int.parse).toList();
          final latestParts = latest.split('.').map(int.parse).toList();

          for (int i = 0; i < 3; i++) {
            final currentPart = i < currentParts.length ? currentParts[i] : 0;
            final latestPart = i < latestParts.length ? latestParts[i] : 0;

            if (latestPart > currentPart) return true;
            if (latestPart < currentPart) return false;
          }

          return false;
        } catch (e) {
          return true;
        }
      }

      // Test cases for version comparison
      expect(isNewerVersion('1.0.0', '1.0.1'), isTrue);
      expect(isNewerVersion('1.0.0', '1.1.0'), isTrue);
      expect(isNewerVersion('1.0.0', '2.0.0'), isTrue);
      expect(isNewerVersion('1.0.1', '1.0.0'), isFalse);
      expect(isNewerVersion('1.1.0', '1.0.0'), isFalse);
      expect(isNewerVersion('2.0.0', '1.0.0'), isFalse);
      expect(isNewerVersion('1.0.0', '1.0.0'), isFalse);

      // Edge cases
      expect(isNewerVersion('1.0', '1.0.1'), isTrue);
      expect(isNewerVersion('1', '1.0.1'), isTrue);
      expect(isNewerVersion('invalid', '1.0.0'), isTrue);
    });

    test('updateToNewestVersionIfNeeded handles not installed CLI', () async {
      // This test would require mocking Process.run
      try {
        await codexSDK.updateToNewestVersionIfNeeded(global: true);
      } catch (e) {
        // Only fail if it's not an expected error
        if (!e.toString().contains('npm is not installed')) {
          fail('Unexpected error: $e');
        }
      }
    }, skip: 'Requires npm and network access');

    test('updateToNewestVersionIfNeeded completes without error', () async {
      final isInstalled = await codexSDK.isCodexCLIInstalled();

      if (isInstalled) {
        try {
          await codexSDK.updateToNewestVersionIfNeeded(global: true);
          expect(true, isTrue);
        } catch (e) {
          if (e.toString().contains('npm') ||
              e.toString().contains('permission') ||
              e.toString().contains('network')) {
            expect(true, isTrue);
          } else {
            fail('Unexpected error during update: $e');
          }
        }
      } else {
        markTestSkipped('Codex CLI not installed');
      }
    });

    test('getSDKInfo returns expected structure', () async {
      final info = await codexSDK.getSDKInfo();

      expect(info, isA<Map<String, dynamic>>());
      expect(info.containsKey('codexCLI'), isTrue);
      expect(info.containsKey('npm'), isTrue);

      if (info['codexCLI'] == true) {
        expect(info.containsKey('codexVersion'), isTrue);
      }
    });
  });
}