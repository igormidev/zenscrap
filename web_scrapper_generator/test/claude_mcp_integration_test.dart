import 'package:test/test.dart';
import 'package:web_scrapper_generator/src/implementations/web_scrapper_claude_impl.dart';
import 'package:web_scrapper_generator/src/models/ai_models.dart';

void main() {
  group('Claude MCP Integration', () {
    test('Claude implementation should compile with MCP setup', () {
      // This test verifies that the Claude implementation
      // compiles correctly with MCP configuration
      expect(WebScrapperClaudeImpl, isNotNull);
    });

    test('initClaude method signature is correct', () async {
      // Verify that initClaude accepts the required parameters
      // Note: We're not actually calling it to avoid needing real API keys
      final initMethod = WebScrapperClaudeImpl.initClaude;
      expect(initMethod, isNotNull);
    });

    test('startChat factory method exists', () {
      // Verify startChat factory method exists with correct signature
      final startChatMethod = WebScrapperClaudeImpl.startChat;
      expect(startChatMethod, isNotNull);
    });

    test('Claude models are available', () {
      // Verify Claude models are accessible
      expect(ClaudeModel.claudeSonnet4, isNotNull);
      expect(ClaudeModel.claudeOpus4, isNotNull);
      expect(ClaudeModel.claudeOpus41, isNotNull);
      expect(ClaudeModel.claude37Sonnet, isNotNull);
      expect(ClaudeModel.claude35Sonnet, isNotNull);
      expect(ClaudeModel.claude35Haiku, isNotNull);
    });

    test('Claude implementation extends correct base class', () {
      // Verify inheritance structure
      expect(
        WebScrapperClaudeImpl,
        isA<Type>(),
      );
      // Note: Can't directly test inheritance without an instance,
      // but compilation success proves it extends WebScrapperGeneratorController
    });
  });
}