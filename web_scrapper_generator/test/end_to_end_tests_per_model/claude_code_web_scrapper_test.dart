import 'package:test/test.dart';
import 'package:web_scrapper_generator/web_scrapper_generator.dart';

void main() {
  test(
    'Web scrapper generator with Claude implementation',
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
            'This is a player page. Extract the player name, his current club name and also the current club image url',
      );
      print('Response:\n');
      print(switch (result) {
        WebScrapperChatAIResponseJustMessage(:final String message) => message,
        WebScrapperChatAIResponseErrorMessage(:final String errorDescription) =>
          errorDescription,
        WebScrapperChatAIResponseWithDataResponse(
          :final String resumeActionMessage,
          :final WebScrapperRequest? request,
          :final ScrappingBeeFetchSettings? fetchSettings,
        ) =>
          '''$resumeActionMessage

Request used:
$request

Fetch settings used:
${fetchSettings != null ? '''{
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
}''' : 'null (only request was modified)'}''',
      });

      // Clean up
      await claudeChat.dispose();
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
