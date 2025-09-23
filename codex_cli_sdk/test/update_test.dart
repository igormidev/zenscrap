import 'package:codex_cli_sdk/codex_cli_sdk.dart';
import 'package:test/test.dart';

void main() {
  group('Codex SDK Update Functionality', () {
    late Codex codexSDK;

    setUp(() {
      final apiKey = const String.fromEnvironment('OPENAI_API_KEY',
          defaultValue: 'test-key');
      codexSDK = Codex(apiKey: apiKey);
    });

    tearDown(() async {
      await codexSDK.dispose();
    });

    test('version comparison logic behaves correctly', () {
      bool isNewerVersion(String current, String latest) {
        try {
          final currentParts = current.split('.').map(int.parse).toList();
          final latestParts = latest.split('.').map(int.parse).toList();
          for (var i = 0; i < 3; i++) {
            final currentPart = i < currentParts.length ? currentParts[i] : 0;
            final latestPart = i < latestParts.length ? latestParts[i] : 0;
            if (latestPart > currentPart) return true;
            if (latestPart < currentPart) return false;
          }
          return false;
        } catch (_) {
          return true;
        }
      }

      expect(isNewerVersion('1.0.0', '1.0.1'), isTrue);
      expect(isNewerVersion('1.0.0', '1.1.0'), isTrue);
      expect(isNewerVersion('1.0.0', '2.0.0'), isTrue);
      expect(isNewerVersion('1.0.1', '1.0.0'), isFalse);
      expect(isNewerVersion('1.1.0', '1.0.0'), isFalse);
      expect(isNewerVersion('2.0.0', '1.0.0'), isFalse);
      expect(isNewerVersion('1.0.0', '1.0.0'), isFalse);
      expect(isNewerVersion('1.0', '1.0.1'), isTrue);
      expect(isNewerVersion('1', '1.0.1'), isTrue);
      expect(isNewerVersion('invalid', '1.0.0'), isTrue);
    });

    test('updateToNewestVersionIfNeeded handles missing CLI', () async {
      try {
        await codexSDK.updateToNewestVersionIfNeeded(global: true);
      } catch (e) {
        if (!e.toString().contains('npm is not installed')) {
          fail('Unexpected error: $e');
        }
      }
    }, skip: 'Requires npm and network access.');

    test('getSDKInfo reports basic environment details', () async {
      final info = await codexSDK.getSDKInfo();

      expect(info, isA<Map<String, dynamic>>());
      expect(info.containsKey('codexCLIInstalled'), isTrue);
      expect(info.containsKey('npmInstalled'), isTrue);
      expect(info.containsKey('configPath'), isTrue);

      if (info['codexCLIInstalled'] == true) {
        expect(info.containsKey('codexVersion'), isTrue);
      }

      if (info['npmInstalled'] == true) {
        expect(info.containsKey('npmVersion'), isTrue);
      }
    });
  });
}
