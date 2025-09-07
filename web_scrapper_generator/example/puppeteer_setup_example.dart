import 'dart:io';
import 'package:web_scrapper_generator/src/puppeteer_setup.dart';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  print('🚀 Puppeteer Setup Example\n');
  print('=' * 50);
  
  // Get API key from environment or prompt user
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? '';
  
  if (apiKey.isEmpty) {
    print('⚠️  Please set your GEMINI_API_KEY environment variable');
    print('   You can get your API key from: https://makersuite.google.com/app/apikey');
    print('\nExample:');
    print('  export GEMINI_API_KEY="your-api-key-here"');
    exit(1);
  }

  // Initialize the SDK
  final geminiSDK = GeminiSDK(apiKey);
  
  try {
    // Get setup information before
    print('\n📊 Current Setup Information:');
    final setupInfo = await PuppeteerSetup.instance.getSetupInfo();
    setupInfo.forEach((key, value) {
      print('  $key: $value');
    });
    
    print('\n${'=' * 50}');
    print('Starting Puppeteer setup...\n');
    
    // Run the setup
    await PuppeteerSetup.instance.setupIfNeeded(geminiSDK);
    
    print('=' * 50);
    print('\n📊 Updated Setup Information:');
    final updatedInfo = await PuppeteerSetup.instance.getSetupInfo();
    updatedInfo.forEach((key, value) {
      print('  $key: $value');
    });
    
    // Now you can use Puppeteer through MCP with Gemini
    print('\n✅ You can now use Puppeteer for web scraping!');
    print('\nExample usage with Gemini:');
    print('''
    final chat = geminiSDK.createNewChat();
    final result = await chat.sendMessage([
      GeminiSdkContent.text(
        'Use Puppeteer to navigate to https://example.com and get the page title'
      ),
    ]);
    ''');
    
    // Optional: Test with a real chat session
    print('\n🧪 Testing Puppeteer with Gemini...\n');
    
    final chat = geminiSDK.createNewChat();
    try {
      final result = await chat.sendMessage([
        GeminiSdkContent.text(
          'Can you confirm if Puppeteer MCP server is available to you? Just say yes or no.'
        ),
      ]);
      
      print('Gemini response: $result');
      
      if (result.toLowerCase().contains('yes')) {
        print('\n🎉 Puppeteer is successfully integrated with Gemini!');
        
        // Try a simple web scraping task
        print('\n🌐 Attempting a simple web scraping task...\n');
        
        final scrapingResult = await chat.sendMessage([
          GeminiSdkContent.text(
            'Using Puppeteer, navigate to https://example.com and tell me the page title. Keep your response brief.'
          ),
        ]);
        
        print('Scraping result: $scrapingResult');
      }
    } finally {
      await chat.dispose();
    }
    
  } catch (e) {
    print('\n❌ Setup failed: $e');
    print('\nTroubleshooting tips:');
    print('1. Make sure Node.js and npm are installed');
    print('2. Check your internet connection');
    print('3. Ensure you have write permissions in the current directory');
    print('4. Try running with administrator/sudo privileges if needed');
    exit(1);
  } finally {
    // Cleanup
    await PuppeteerSetup.instance.cleanup();
    await geminiSDK.dispose();
  }
  
  print('\n✅ Example complete!');
}