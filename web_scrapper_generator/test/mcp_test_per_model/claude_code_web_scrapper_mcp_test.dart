import 'package:test/test.dart';
import 'package:web_scrapper_generator/web_scrapper_generator.dart';

void main() {
  test(
    'Web scrapper Claude implementation MCP TEST',
    () async {
      // Get API key from environment or use a test key
      final claudeCodeSdkApiKey =
          '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';
      final scrapingBeeApiKey =
          '37N8150Q1JBVN85NS4RUOUIUYZ2AEUFX69QBM0X74VD13M9TLNRVOFWS7HZMKRG1X4SOH4BKJT5EUN6K';

      // Initialize WebScrapperGeneratorController with proper proxy configuration
      final proxyConfig = ScrappingBeeProxyConfig(
        apiKey: scrapingBeeApiKey,
        stealthProxy: true,
        renderJs: true,
        premiumProxy: true,
        countryCode: 'us',
      );

      if (claudeCodeSdkApiKey == 'YOUR_API_KEY') {
        print('Please set your CLAUDE_API_KEY environment variable');
        print(
          'You can get your API key from: https://makersuite.google.com/app/apikey',
        );
        return;
      }

      // Initialize Claude implementation
      await WebScrapperClaudeImpl.initClaude(
        claudeApiKey: claudeCodeSdkApiKey,
        scrappingBeeApiKey: scrapingBeeApiKey,
        proxyConfig: proxyConfig,
      );

      // Create a new chat session with Claude
      final claudeChat = WebScrapperClaudeImpl.startChat(
        initialPayload: InitialPayloadDataCreatingFromZero(
          targetExampleUrl:
              'https://www.transfermarkt.com/neymar/profil/spieler/68290',
          webScrapperRequest: WebScrapperRequest(
            url:
                'https://www.transfermarkt.com.br/{trainerSlug}/profil/trainer/{trainerId}',
            queryParam: {},
            pathParams: ['trainerSlug', 'trainerId'],
          ),
        ),
        model: ClaudeModel.claudeSonnet4,
      );

      print('Sending message to Claude Code...\n');
      final WebScrapperChatAIResponse result = await claudeChat.sendMessage(
        userPrompt:
            'DO NOT DO ANYTHING YET. Before starting, confirm me that you have access to MCP servers.\n'
            'If you have access to scrapping bee mcp server write "CONFIRMED ACCESS TO SCRAPPING BEE MCP".\n'
            'If you have access to playwright server write "CONFIRMED ACCESS TO PLAYWRIGHT MCP".\n'
            'BE CAREFUL: If you do not have access to MCP servers, just write "NO MCP ACCESS". And if you have make sure to return 100% accurate confirmation message.\n',
      );
      print('Response:\n');
      print(switch (result) {
        WebScrapperChatAIResponseJustMessage(:final String message) => message,
        WebScrapperChatAIResponseErrorMessage(:final String errorDescription) =>
          errorDescription,
        WebScrapperChatAIResponseWithDataResponse(
          :final String resumeActionMessage,
          :final ScrappingBeeFetchSettings fetchSettings,
        ) =>
          '''$resumeActionMessage

Fetch settings used:
{
  'url': ${fetchSettings.url},
  'extract_rules': ${fetchSettings.extract_rules},
  'js_scenario': ${fetchSettings.js_scenario},
  'render_js': ${fetchSettings.render_js},
  'wait': ${fetchSettings.wait},
  'wait_for': ${fetchSettings.wait_for},
  'wait_browser': ${fetchSettings.wait_browser},
  'premium_proxy': ${fetchSettings.premium_proxy},
  'country_code': ${fetchSettings.country_code},
  'session_id': ${fetchSettings.session_id},
  'custom_google': ${fetchSettings.custom_google},
}''',
      });

      print('\nVerifying MCP access in response...\n');
      expect(
          result.toString(), contains('CONFIRMED ACCESS TO SCRAPPING BEE MCP'),
          reason: 'Claude should confirm access to Scrapping Bee MCP server.');
      print('\n✅ MCP Access test completed successfully.\n');
      expect(
        result.toString(),
        contains('CONFIRMED ACCESS TO PLAYWRIGHT MCP'),
        reason: 'Claude should confirm access to Playwright MCP server.',
      );
      print('\n✅ Playwright MCP Access test completed successfully.\n');
      expect(result.toString().contains('NO MCP ACCESS'), isFalse,
          reason: 'Claude should not say it has no MCP access.');
      // Clean up
      await claudeChat.dispose();
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
