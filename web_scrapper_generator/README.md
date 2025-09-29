# Web Scrapper Generator

Core AI-powered web scraping rules generation package. This package contains the brain of Zenscrap - all the AI prompts, MCP integrations, and logic for creating and testing ScrapingBee extraction rules.

## 📋 Overview

This package handles:
- AI prompt engineering for web scraping tasks
- Playwright MCP integration for browser automation
- ScrapingBee MCP for testing extraction rules
- Multi-SDK support (Gemini, Claude, Codex)
- Dynamic proxy configuration
- Cost optimization strategies

## 🏗️ Package Structure

```
web_scrapper_generator/
├── lib/
│   ├── src/
│   │   ├── implementations/      # SDK-specific implementations
│   │   │   ├── claude_implementation.dart
│   │   │   ├── codex_implementation.dart
│   │   │   └── gemini_implementation.dart
│   │   ├── prompts.dart         # Core AI prompts and system instructions
│   │   ├── playwright_setup.dart # Playwright MCP configuration
│   │   ├── scraping_bee_mcp.dart # ScrapingBee MCP server
│   │   ├── scraping_bee_api_mixin.dart # API interaction logic
│   │   ├── mcp_adapters.dart    # Unified MCP setup across SDKs
│   │   ├── web_scrapper_response.dart # Response models
│   │   └── web_scrapper_generator_interface.dart # Abstract interface
│   └── web_scrapper_generator.dart # Package exports
├── bin/
│   └── scraping_bee_mcp_server.dart # MCP server executable
└── pubspec.yaml
```

## 🚀 Installation

Add to your `pubspec.yaml`:
```yaml
dependencies:
  web_scrapper_generator:
    path: ./web_scrapper_generator
```

## 💡 Core Components

### 1. AI Prompts (`prompts.dart`)

The heart of the system - contains sophisticated prompts that guide the AI through:
- Page exploration and analysis
- Extraction rule creation
- JavaScript scenario generation
- Cost optimization
- Testing and validation

Key features:
- Dynamic country proxy selection based on target site
- Comprehensive testing workflow
- Credit cost optimization strategy
- Support for 195+ country proxies

### 2. MCP Integrations

#### Playwright MCP (`playwright_setup.dart`)
- Provides real browser automation
- Allows AI to interact with pages (click, type, scroll)
- Captures screenshots and rendered HTML
- Dynamic proxy configuration support

#### ScrapingBee MCP (`scraping_bee_mcp.dart`)
- Custom MCP server for testing extraction rules
- Validates rules against real ScrapingBee API
- Ensures rules work before returning to user
- Comprehensive error handling

### 3. SDK Implementations

Support for multiple AI providers through a unified interface:

#### Gemini Implementation
```dart
final generator = GeminiWebScrapperGenerator(
  geminiSDK: geminiSDK,
  scrapingBeeApiKey: 'your-api-key',
);
```

#### Claude Implementation
```dart
final generator = ClaudeWebScrapperGenerator(
  claudeSDK: claudeSDK,
  scrapingBeeApiKey: 'your-api-key',
);
```

#### Codex Implementation
```dart
final generator = CodexWebScrapperGenerator(
  codexSDK: codexSDK,
  scrapingBeeApiKey: 'your-api-key',
);
```

## 🎯 Usage Examples

### Basic Setup and Initialization

```dart
import 'package:web_scrapper_generator/web_scrapper_generator.dart';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  // Initialize SDK
  final geminiSDK = GeminiSDK();

  // Create generator instance
  final generator = GeminiWebScrapperGenerator(
    geminiSDK: geminiSDK,
    scrapingBeeApiKey: 'your-scrapingbee-api-key',
  );

  // Setup MCP tools if needed
  await generator.setupIfNeeded();

  // Now ready to generate scraping rules!
}
```

### Creating New Scraping Rules

```dart
// Define the target URL and request structure
final request = WebScrapperRequest(
  url: 'https://example.com/products/{category}',
  queryParam: {'sort': 'price', 'limit': '20'},
  pathParams: ['category'],
);

// Initialize chat with AI
await generator.initChat(
  InitialPayloadDataCreatingFromZero(
    targetExampleUrl: 'https://example.com/products/electronics',
    webScrapperRequest: request,
  ),
);

// Send user requirements
final response = await generator.sendMessage(
  'Extract product names, prices, and ratings from the product listing page'
);

// Handle response
switch (response) {
  case WebScrapperChatAIResponseWithDataResponse():
    print('Success! Generated settings:');
    print('URL: ${response.fetchSettings.url}');
    print('Rules: ${response.fetchSettings.extract_rules}');
    break;
  case WebScrapperChatAIResponseJustMessage():
    print('AI Message: ${response.message}');
    break;
  case WebScrapperChatAIResponseErrorMessage():
    print('Error: ${response.errorDescription}');
    break;
}
```

### Editing Existing Rules

```dart
// Edit existing scraping configuration
await generator.initChat(
  InitialPayloadDataEditingExistingWebScrapper(
    currentRequest: existingRequest,
    currentFetchSettings: existingSettings,
  ),
);

final response = await generator.sendMessage(
  'Add extraction for product images and availability status'
);
```

## 🔧 MCP Setup

### Automatic Setup

The package can automatically set up required MCP servers:

```dart
// This will:
// 1. Install Playwright if needed
// 2. Configure Playwright MCP
// 3. Compile and setup ScrapingBee MCP
await generator.setupIfNeeded();
```

### Manual Setup

If you prefer manual control:

```dart
// Setup Playwright
await PlaywrightSetup.instance.setupIfNeeded(geminiSDK);

// Setup ScrapingBee MCP
await ScrapingBeeMcpServerSetup.instance.setupIfNeeded(geminiSDK);
```

## 📊 Response Models

### WebScrapperRequest
Defines the URL pattern and parameters:
```dart
class WebScrapperRequest {
  final String url;                    // URL with {param} placeholders
  final Map<String, String?> queryParam; // Query parameters
  final List<String> pathParams;       // Path parameter names
}
```

### ScrappingBeeFetchSettings
Complete ScrapingBee configuration:
```dart
class ScrappingBeeFetchSettings {
  final String url;              // Target URL
  final String extract_rules;    // JSON extraction rules
  final String? js_scenario;     // JavaScript actions
  final bool render_js;          // Enable JS rendering
  final bool premium_proxy;      // Use premium proxy
  final bool stealth_proxy;      // Use stealth proxy
  final String? country_code;    // Proxy country
  // ... more settings
}
```

## 🌍 Proxy Configuration

The system intelligently selects proxy settings based on:
- Target domain (e.g., .de domains use German proxy)
- User requirements
- Site difficulty level

Cost optimization priority:
1. No proxy (1-5 credits)
2. Premium proxy (25 credits)
3. Stealth proxy (75 credits - only for LinkedIn, Meta, etc.)

## 🧪 Testing Workflow

The AI follows a strict testing protocol:
1. **Exploration**: Use Playwright to understand the page
2. **Rule Creation**: Design extraction rules
3. **Testing**: Validate with ScrapingBee MCP
4. **Optimization**: Find cheapest working configuration
5. **Validation**: Ensure data matches requirements

## 🔍 Debugging

### Enable Verbose Logging
```dart
// Set environment variable
export DEBUG_MCP=true
```

### Check MCP Status
```dart
final mcpInfo = await geminiSDK.isMcpInstalled();
print('MCP Support: ${mcpInfo.hasMcpSupport}');
print('Servers: ${mcpInfo.servers}');
```

### Test ScrapingBee Connection
```dart
final result = await generator.testScrapingBeeConnection();
print('ScrapingBee API Status: $result');
```

## ⚠️ Important Notes

1. **Always Test Rules**: The AI must test extraction rules before returning them
2. **Cost Awareness**: The system optimizes for lowest credit usage
3. **Dynamic Proxies**: Proxy country is selected based on target site
4. **MCP Required**: Both Playwright and ScrapingBee MCPs must be configured
5. **API Key Security**: Never expose ScrapingBee API keys to end users

## 🤝 Contributing

When contributing to this package:
1. Maintain the testing workflow in prompts
2. Ensure MCP compatibility across all SDKs
3. Add tests for new extraction scenarios
4. Document any new proxy requirements

## 📄 License

This package is part of the Zenscrap project. See main project license.

## 🐛 Troubleshooting

### "MCP not found" Error
```bash
# Compile the ScrapingBee MCP server
dart compile exe bin/scraping_bee_mcp_server.dart -o build/scraping_bee_mcp_server
```

### "Playwright not installed" Error
```bash
# Install Playwright
npm install playwright
npx playwright install
```

### "Invalid extraction rules" Error
- Ensure rules are valid JSON
- Test rules with ScrapingBee MCP before using
- Check CSS/XPath selector syntax

## 📚 Resources

- [ScrapingBee Documentation](https://www.scrapingbee.com/documentation/)
- [Playwright Documentation](https://playwright.dev/)
- [MCP Protocol Specification](https://github.com/modelcontextprotocol)