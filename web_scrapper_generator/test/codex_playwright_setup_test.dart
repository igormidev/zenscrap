import 'package:test/test.dart';
import 'package:web_scrapper_generator/web_scrapper_generator.dart';

void main() {
  test(
    'Web scrapper generator test codex playwright setup',
    () async {
      // Get API key from environment or use a test key
      final codexApiKey =
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

      if (codexApiKey == 'YOUR_API_KEY') {
        print('Please set your OPENAI_API_KEY environment variable');
        print(
          'You can get your API key from: https://platform.openai.com/api-keys',
        );
        return;
      }

      // Initialize Codex implementation
      await WebScrapperCodexImpl.initCodex(
        codexApiKey: codexApiKey,
        scrappingBeeApiKey: scrapingBeeApiKey,
        proxyConfig: proxyConfig,
      );

      // Create a new chat session with Codex
      final codexChat = WebScrapperCodexImpl.startChat(
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
        model: CodexModel.gpt5,
      );

      print('Streaming message to Codex...\n');
      final result = await codexChat.sendMessage(
        userPrompt:
            'Quick question - before you write ANY CODE; answer me: do you have access to playwright in your environment? Are you able to use it? Please confirm that you can use playwright to interact with web pages.',
      );

      int messageCount = 0;

      print('\nTotal stream messages received: $messageCount');
      print('Waiting for final structured response...\n');

      print('Final structured response:');
      print(switch (result) {
        WebScrapperChatAIResponseJustMessage(:final String message) =>
          'JustMessage: $message',
        WebScrapperChatAIResponseErrorMessage(:final String errorDescription) =>
          'ErrorMessage: $errorDescription',
        WebScrapperChatAIResponseWithDataResponse(
          :final String resumeActionMessage,
          :final WebScrapperRequest? request,
          :final ScrappingBeeFetchSettings? fetchSettings,
        ) =>
          '''WithDataResponse: $resumeActionMessage

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
  'stealth_proxy': ${fetchSettings.stealth_proxy},
  'country_code': ${fetchSettings.country_code},
  'session_id': ${fetchSettings.session_id},
  'custom_google': ${fetchSettings.custom_google},
}''' : 'null (only request was modified)'}''',
      });

      print('\nFinal response type: ${result.runtimeType}');

      // Clean up
      await codexChat.dispose();
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}