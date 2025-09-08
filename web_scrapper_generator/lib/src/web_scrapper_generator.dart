// ignore_for_file: constant_identifier_names
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
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
    await ScrapingBeeMcp.initialize(
      geminiSDK: _geminiSDK,
      apiKey: scrappingBeeApiKey,
    );
  }

  final GeminiChat _chat;

  WebScrapperGeneratorController._({required GeminiChat chat}) : _chat = chat;

  static Future<WebScrapperGeneratorController> startChat() async {
    final chat = _geminiSDK.createNewChat();
    final instance = WebScrapperGeneratorController._(chat: chat);
    return instance;
  }

  Future<WebScrapperChatAIResponse> sendMessage({
    required String userPrompt,
  }) async {
    // Todo: implement this later...
    throw UnimplementedError();
  }
}

enum ScrappableSource { gemini_2_5_flash, gemini_2_5_pro }
