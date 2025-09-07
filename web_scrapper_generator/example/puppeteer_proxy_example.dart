import 'dart:io';
import 'package:web_scrapper_generator/src/puppeteer_setup.dart';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  print('🚀 Puppeteer with ScrapingBee Proxy Example\n');
  print('=' * 50);
  
  // Get API keys from environment
  final geminiApiKey = Platform.environment['GEMINI_API_KEY'] ?? '';
  final scrapingBeeApiKey = Platform.environment['SCRAPINGBEE_API_KEY'] ?? '';
  
  if (geminiApiKey.isEmpty) {
    print('⚠️  Please set your GEMINI_API_KEY environment variable');
    print('   You can get your API key from: https://makersuite.google.com/app/apikey');
    exit(1);
  }
  
  if (scrapingBeeApiKey.isEmpty) {
    print('⚠️  Please set your SCRAPINGBEE_API_KEY environment variable');
    print('   You can get your API key from: https://www.scrapingbee.com/');
    print('\nExample:');
    print('  export GEMINI_API_KEY="your-gemini-key"');
    print('  export SCRAPINGBEE_API_KEY="your-scrapingbee-key"');
    exit(1);
  }

  // Initialize the SDK
  final geminiSDK = GeminiSDK(geminiApiKey);
  
  // Configure ScrapingBee proxy
  final proxyConfig = ScrappingBeeProxyConfig(
    apiKey: scrapingBeeApiKey,
    // Use default proxy host and port
    proxyHost: 'proxy.scrapingbee.com',
    proxyPort: 8886,
    protocol: ProxyProtocol.http,
    // Enable stealth proxy for rotating IPs
    stealthProxy: true,
    // Disable JS rendering for faster scraping (enable if needed)
    renderJs: false,
    // Use premium proxy for better performance (optional)
    premiumProxy: false,
    // Set country code if you need geo-targeted scraping
    countryCode: null, // e.g., 'us', 'gb', 'de'
    // Additional parameters
    parameters: {
      'block_ads': 'true',
      'block_resources': 'false',
    },
  );
  
  try {
    // Get setup information before
    print('\n📊 Current Setup Information:');
    final setupInfo = await PuppeteerSetup.instance.getSetupInfo();
    setupInfo.forEach((key, value) {
      print('  $key: $value');
    });
    
    print('\n${'=' * 50}');
    print('Starting Puppeteer setup with proxy...\n');
    
    // Run the setup with proxy configuration
    await PuppeteerSetup.instance.setupIfNeeded(
      geminiSDK,
      proxyConfig: proxyConfig,
    );
    
    print('=' * 50);
    print('\n📊 Updated Setup Information:');
    final updatedInfo = await PuppeteerSetup.instance.getSetupInfo();
    updatedInfo.forEach((key, value) {
      print('  $key: $value');
    });
    
    // Show proxy configuration details
    print('\n🔐 Proxy Configuration:');
    print('  Proxy URL: ${proxyConfig.proxyUrl}');
    print('  Protocol: ${proxyConfig.protocol.name}');
    print('  Host: ${proxyConfig.proxyHost}');
    print('  Port: ${proxyConfig.proxyPort}');
    print('  Stealth Proxy: ${proxyConfig.stealthProxy}');
    print('  Render JS: ${proxyConfig.renderJs}');
    print('  Premium Proxy: ${proxyConfig.premiumProxy}');
    if (proxyConfig.countryCode != null) {
      print('  Country Code: ${proxyConfig.countryCode}');
    }
    
    // Now you can use Puppeteer with ScrapingBee proxy through Gemini
    print('\n✅ Puppeteer with ScrapingBee proxy is ready!');
    print('\nExample usage with Gemini:');
    print('''
    final chat = geminiSDK.createNewChat();
    final result = await chat.sendMessage([
      GeminiSdkContent.text(\'\'\'
        Use Puppeteer with the configured proxy to:
        1. Navigate to https://httpbin.org/headers
        2. Extract the headers information
        3. Verify the proxy is working
      \'\'\'),
    ]);
    ''');
    
    // Test with a real chat session
    print('\n🧪 Testing Puppeteer with proxy through Gemini...\n');
    
    final chat = geminiSDK.createNewChat();
    try {
      // First, check if Puppeteer is available
      final checkResult = await chat.sendMessage([
        GeminiSdkContent.text(
          'Can you confirm if Puppeteer MCP server is available to you? Just say yes or no.'
        ),
      ]);
      
      print('Gemini response: $checkResult');
      
      if (checkResult.toLowerCase().contains('yes')) {
        print('\n🎉 Puppeteer is successfully integrated with Gemini!');
        
        // Try a web scraping task with proxy
        print('\n🌐 Testing proxy-based web scraping...\n');
        
        final scrapingResult = await chat.sendMessage([
          GeminiSdkContent.text('''
            Using the configured Puppeteer with proxy, navigate to https://httpbin.org/ip 
            and tell me what IP address is shown. This will verify the proxy is working.
            Keep your response brief.
          '''),
        ]);
        
        print('Proxy test result: $scrapingResult');
        
        // Advanced scraping example
        print('\n🔍 Attempting advanced scraping with proxy...\n');
        
        final advancedResult = await chat.sendMessage([
          GeminiSdkContent.text('''
            Using Puppeteer with the proxy, go to https://httpbin.org/headers 
            and extract the User-Agent header. Keep the response concise.
          '''),
        ]);
        
        print('Advanced scraping result: $advancedResult');
      }
    } finally {
      await chat.dispose();
    }
    
    // Show how to use the helper scripts directly
    print('\n💡 Direct Node.js Usage:');
    print('You can also use the generated helper scripts directly:');
    print('''
    
    // In Node.js:
    const { launchBrowserWithProxy } = require('./puppeteer-proxy-helper.js');
    
    async function scrapeWithProxy() {
      const { browser, page } = await launchBrowserWithProxy();
      
      // Your scraping logic here
      await page.goto('https://example.com');
      const title = await page.title();
      console.log('Page title:', title);
      
      await browser.close();
    }
    
    scrapeWithProxy();
    ''');
    
  } catch (e) {
    print('\n❌ Setup failed: $e');
    print('\nTroubleshooting tips:');
    print('1. Make sure Node.js and npm are installed');
    print('2. Check your ScrapingBee API key is valid');
    print('3. Ensure you have internet connectivity');
    print('4. Check ScrapingBee account has credits available');
    print('5. Verify proxy settings are correct');
    exit(1);
  } finally {
    // Cleanup
    await PuppeteerSetup.instance.cleanup();
    await geminiSDK.dispose();
  }
  
  print('\n✅ Example complete!');
  print('\nNote: The proxy configuration files have been created:');
  print('  - puppeteer-proxy-config.js (configuration)');
  print('  - puppeteer-proxy-helper.js (helper functions)');
  print('\nThese can be used directly in your Node.js scripts.');
}