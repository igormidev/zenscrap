// ignore_for_file: constant_identifier_names
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:web_scrapper_generator/src/prompts.dart';
import 'package:web_scrapper_generator/src/scraping_bee_mcp.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'puppeteer_setup.dart';

class WebScrapperGeneratorController {
  static late final GeminiSDK _geminiSDK;

  static Future<void> init(
    String geminiApiKey,
    String scrappingBeeApiKey,
    ScrappingBeeProxyConfig proxyConfig,
  ) async {
    _geminiSDK = GeminiSDK(geminiApiKey);

    // Ensure Gemini CLI is installed
    final bool isInstalled = await _geminiSDK.isGeminiCLIInstalled();
    if (!isInstalled) {
      await _geminiSDK.installGeminiCLI(global: true);
    }

    // Setup Puppeteer and its MCP integration
    await PuppeteerSetup.instance.setupIfNeeded(
      _geminiSDK,
      proxyConfig: proxyConfig,
    );

    // Initialize ScrapingBee MCP server
    await ScrapingBeeMcpServerSetup.instance.setupIfNeeded(_geminiSDK);
  }

  final GeminiChat _chat;
  final WebScrapperRequest _currentRequest;
  final ScrappingBeeFetchSettings _currentFetchSettings;

  WebScrapperGeneratorController._({
    required GeminiChat chat,
    required WebScrapperRequest currentRequest,
    required ScrappingBeeFetchSettings currentFetchSettings,
  }) : _chat = chat,
       _currentRequest = currentRequest,
       _currentFetchSettings = currentFetchSettings;

  static Future<WebScrapperGeneratorController> startChat({
    required WebScrapperRequest currentRequest,
    required ScrappingBeeFetchSettings currentFetchSettings,
  }) async {
    final chat = _geminiSDK.createNewChat(
      options: GeminiChatOptions(
        systemPrompt: systemPrompt,
        model: ScrappableSource.gemini_2_5_pro.apiName,
      ),
    );
    final instance = WebScrapperGeneratorController._(
      chat: chat,
      currentRequest: currentRequest,
      currentFetchSettings: currentFetchSettings,
    );
    return instance;
  }

  Future<WebScrapperChatAIResponse> sendMessage({
    required String userPrompt,
  }) async {
    List<GeminiSdkContent> prefixMessages = [];

    final isFirstMessage = _chat.isFirstMessage;
    if (isFirstMessage) {
      prefixMessages.addAll(
        getStartConversationContextContents(
          currentRequest: _currentRequest,
          currentFetchSettings: _currentFetchSettings,
        ),
      );
    }

    _chat.sendMessage([...prefixMessages, GeminiSdkContent.text(userPrompt)]);

    // Todo: implement this later...
    throw UnimplementedError();
  }
}

enum ScrappableSource {
  gemini_2_5_flash,
  gemini_2_5_pro;

  String get apiName {
    switch (this) {
      case gemini_2_5_flash:
        return 'gemini-2.5-flash';
      case gemini_2_5_pro:
        return 'gemini-2.5-pro';
    }
  }
}
