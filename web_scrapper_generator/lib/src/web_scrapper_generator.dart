// ignore_for_file: constant_identifier_names
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'puppeteer_setup.dart';

class WebScrapperGeneratorController {
  static late final GeminiSDK _geminiSDK;

  static Future<void> init(String geminiApiKey) async {
    _geminiSDK = GeminiSDK(geminiApiKey);

    // Ensure Gemini CLI is installed
    final bool isInstalled = await _geminiSDK.isGeminiCLIInstalled();
    if (!isInstalled) {
      await _geminiSDK.installGeminiCLI(global: true);
    }

    // Setup Puppeteer and its MCP integration
    await PuppeteerSetup.instance.setupIfNeeded(_geminiSDK);
  }

  WebScrapperGeneratorController._();

  Future<void> sendMessage() async {
    // Todo: implement this
    _geminiSDK.createNewChat();
    throw UnimplementedError();
  }
}

enum ScrappableSource { gemini_2_5_flash, gemini_2_5_pro }
