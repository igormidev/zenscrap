# Puppeteer Setup for Web Scrapper Generator

This package provides automatic setup and configuration of Puppeteer with MCP (Model Context Protocol) integration for web scraping using Gemini AI.

## Features

- 🚀 **Automatic Installation**: Checks and installs all required dependencies
- 🔌 **MCP Integration**: Configures Puppeteer as an MCP server for Gemini
- 🧪 **Self-Verification**: Tests the setup to ensure everything works
- 🎯 **Zero Configuration**: Works out of the box with minimal setup
- 📦 **Local Installation**: Installs packages locally in your project

## How It Works

The `PuppeteerSetup` class handles the entire setup process:

1. **NPM Check**: Verifies Node.js and npm are installed
2. **Puppeteer Installation**: Installs Puppeteer and MCP server locally
3. **Chromium Download**: Ensures Chromium browser is downloaded
4. **MCP Configuration**: Registers Puppeteer as an MCP server with Gemini
5. **Verification**: Tests the setup to confirm everything works

## Usage

### Basic Setup

```dart
import 'package:web_scrapper_generator/src/puppeteer_setup.dart';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  // Initialize Gemini SDK
  final geminiSDK = GeminiSDK('YOUR_API_KEY');
  
  // Run the setup
  await PuppeteerSetup.instance.setupIfNeeded(geminiSDK);
  
  // Now you can use Puppeteer through Gemini!
}
```

### Using with WebScrapperGeneratorController

The controller automatically handles the setup:

```dart
import 'package:web_scrapper_generator/src/web_scrapper_generator.dart';

void main() async {
  // Initialize the controller (handles Puppeteer setup internally)
  await WebScrapperGeneratorController.init('YOUR_GEMINI_API_KEY');
  
  // Ready to use for web scraping!
}
```

### Web Scraping with Gemini

Once setup is complete, you can use Puppeteer through Gemini:

```dart
final chat = geminiSDK.createNewChat();

// Ask Gemini to scrape a website
final result = await chat.sendMessage([
  GeminiSdkContent.text('''
    Using Puppeteer, navigate to https://example.com and:
    1. Get the page title
    2. Extract all h1 headings
    3. Take a screenshot
  '''),
]);

print(result);
```

## What Gets Installed

### Local NPM Packages
- `puppeteer` - Headless Chrome automation
- `@modelcontextprotocol/server-puppeteer` - MCP server for Puppeteer

### File Structure
```
your_project/
├── package.json              # NPM configuration
├── node_modules/            # NPM packages
│   ├── puppeteer/
│   └── @modelcontextprotocol/
└── .gemini/                 # MCP configuration (if project scope)
    └── settings.json
```

## API Reference

### PuppeteerSetup

#### setupIfNeeded(GeminiSDK geminiSDK)
Main setup method that ensures Puppeteer is installed and configured.

```dart
await PuppeteerSetup.instance.setupIfNeeded(geminiSDK);
```

#### getSetupInfo()
Returns information about the current setup status.

```dart
final info = await PuppeteerSetup.instance.getSetupInfo();
// Returns:
// {
//   'npm_installed': true,
//   'puppeteer_installed': true,
//   'puppeteer_version': '^22.0.0',
//   'node_modules_path': '/path/to/node_modules',
//   'project_path': '/path/to/project'
// }
```

#### cleanup()
Cleans up temporary files created during setup.

```dart
await PuppeteerSetup.instance.cleanup();
```

## Prerequisites

### Required Software
1. **Node.js and npm** - [Download](https://nodejs.org/)
2. **Gemini API Key** - [Get yours](https://makersuite.google.com/app/apikey)

### System Requirements
- macOS, Linux, or Windows
- Internet connection for package downloads
- Write permissions in project directory

## Error Handling

The setup handles various error scenarios:

```dart
try {
  await PuppeteerSetup.instance.setupIfNeeded(geminiSDK);
} catch (e) {
  if (e.toString().contains('npm is not installed')) {
    // Node.js/npm not installed
  } else if (e.toString().contains('Failed to install puppeteer')) {
    // Installation failed (network issues, permissions, etc.)
  } else if (e.toString().contains('Failed to configure MCP')) {
    // MCP configuration failed
  }
}
```

## Troubleshooting

### NPM Not Found
```bash
# Install Node.js from https://nodejs.org/
# Or use a package manager:
brew install node        # macOS
apt-get install nodejs   # Ubuntu/Debian
choco install nodejs     # Windows
```

### Permission Errors
```bash
# On Unix systems, you might need sudo for global installs
sudo npm install -g @google/gemini-cli
```

### Puppeteer Can't Download Chromium
```bash
# Manually trigger Chromium download
npx puppeteer browsers install chrome
```

### MCP Server Not Showing Up
1. Check `~/.gemini/settings.json` for user config
2. Check `.gemini/settings.json` in project for project config
3. Verify with: `await geminiSDK.listMcpServers()`

## How MCP Works

MCP (Model Context Protocol) allows Gemini to interact with external tools:

1. **Server Registration**: Puppeteer is registered as an MCP server
2. **Tool Discovery**: Gemini discovers available Puppeteer functions
3. **Execution**: When you ask Gemini to scrape, it uses the MCP server
4. **Results**: Puppeteer executes commands and returns results to Gemini

## Example: Complete Web Scraping Flow

```dart
import 'dart:io';
import 'package:web_scrapper_generator/src/puppeteer_setup.dart';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

void main() async {
  // Setup
  final geminiSDK = GeminiSDK(Platform.environment['GEMINI_API_KEY']!);
  await PuppeteerSetup.instance.setupIfNeeded(geminiSDK);
  
  // Create chat session
  final chat = geminiSDK.createNewChat();
  
  try {
    // Complex scraping task
    final result = await chat.sendMessage([
      GeminiSdkContent.text('''
        Using Puppeteer, go to https://news.ycombinator.com and:
        1. Extract the top 5 story titles
        2. Get their vote counts
        3. Return as JSON
      '''),
    ]);
    
    print('Scraped data: $result');
    
    // Parse and use the data
    // ... your logic here
    
  } finally {
    await chat.dispose();
    await geminiSDK.dispose();
  }
}
```

## Security Considerations

- API keys are never stored in code
- Puppeteer runs in sandboxed Chromium
- MCP servers run with limited permissions
- All installations are local to your project

## ScrapingBee Proxy Support

The PuppeteerSetup now includes built-in support for ScrapingBee's proxy service, enabling:
- 🔄 Rotating IP addresses
- 🌍 Geo-targeted scraping
- 🛡️ Stealth mode for anti-detection
- ⚡ Premium proxy options
- 🚫 Resource blocking for faster scraping

### Proxy Configuration

```dart
import 'package:web_scrapper_generator/src/puppeteer_setup.dart';

// Configure ScrapingBee proxy
final proxyConfig = ScrappingBeeProxyConfig(
  apiKey: 'YOUR_SCRAPINGBEE_API_KEY',
  proxyHost: 'proxy.scrapingbee.com', // default
  proxyPort: 8886,                     // 8886 for HTTP, 8887 for HTTPS, 8888 for Socks5
  protocol: ProxyProtocol.http,        // http, https, or socks5
  stealthProxy: true,                  // Enable rotating IPs
  renderJs: false,                     // JS rendering (false recommended for proxy mode)
  premiumProxy: false,                 // Use premium proxies
  countryCode: 'us',                   // Optional: geo-targeting
  parameters: {
    'block_ads': 'true',
    'wait': '2000',
  },
);

// Setup with proxy
await PuppeteerSetup.instance.setupIfNeeded(
  geminiSDK,
  proxyConfig: proxyConfig,
);
```

### ProxyProtocol Options

```dart
enum ProxyProtocol {
  http,   // Port 8886
  https,  // Port 8887
  socks5, // Port 8888
}
```

### ScrappingBeeProxyConfig Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `apiKey` | String | required | Your ScrapingBee API key |
| `proxyHost` | String | `proxy.scrapingbee.com` | Proxy server host |
| `proxyPort` | int | `8886` | Proxy server port |
| `protocol` | ProxyProtocol | `http` | Connection protocol |
| `stealthProxy` | bool | `true` | Enable IP rotation |
| `renderJs` | bool | `false` | JavaScript rendering |
| `premiumProxy` | bool | `false` | Use premium proxies |
| `countryCode` | String? | `null` | Country for geo-targeting |
| `parameters` | Map<String,String> | `{}` | Additional ScrapingBee parameters |

### Using Proxy with Gemini

Once configured, Gemini can use Puppeteer with the proxy:

```dart
final chat = geminiSDK.createNewChat();

final result = await chat.sendMessage([
  GeminiSdkContent.text('''
    Using Puppeteer with proxy, scrape https://example.com and:
    1. Extract the main content
    2. Get all links
    3. Check response headers
  '''),
]);
```

### Generated Proxy Files

The setup creates two helper files:

1. **puppeteer-proxy-config.js** - Configuration file with proxy settings
2. **puppeteer-proxy-helper.js** - Helper functions for proxy usage

### Direct Node.js Usage

You can use the generated files directly in Node.js:

```javascript
const { launchBrowserWithProxy } = require('./puppeteer-proxy-helper.js');

async function scrapeWithProxy() {
  const { browser, page } = await launchBrowserWithProxy();
  
  await page.goto('https://example.com');
  const title = await page.title();
  console.log('Title:', title);
  
  await browser.close();
}

scrapeWithProxy();
```

### Proxy Authentication

ScrapingBee uses a special authentication format:
- **Username**: Your API key
- **Password**: Parameters (e.g., `render_js=false&premium_proxy=true`)

The SDK handles this automatically based on your configuration.

### API Credit Usage

**Important**: When using proxy mode with Puppeteer:
- Each request counts as an API call
- Google searches cost 20 credits
- Disable JS rendering when not needed (`renderJs: false`)
- Block unnecessary resources to save credits

### Supported ScrapingBee Parameters

Common parameters you can add to the `parameters` map:

| Parameter | Description |
|-----------|-------------|
| `block_ads` | Block advertisements |
| `block_resources` | Block CSS, images, fonts |
| `wait` | Wait time in milliseconds |
| `wait_for` | CSS selector to wait for |
| `premium_proxy` | Use premium proxy pool |
| `stealth_proxy` | Use stealth proxy (rotating IPs) |
| `session_id` | Maintain session across requests |
| `forward_headers` | Forward custom headers |

### Error Handling with Proxy

```dart
try {
  await PuppeteerSetup.instance.setupIfNeeded(
    geminiSDK,
    proxyConfig: proxyConfig,
  );
} catch (e) {
  if (e.toString().contains('Failed to setup proxy')) {
    // Proxy configuration error
    print('Check your ScrapingBee API key and settings');
  }
}
```

### Testing Proxy Connection

The setup automatically tests the proxy by:
1. Launching Puppeteer with proxy settings
2. Navigating to `https://httpbin.org/ip`
3. Verifying the response shows a different IP

### Cleanup

Proxy configuration files are automatically cleaned up:

```dart
await PuppeteerSetup.instance.cleanup();
// Removes: puppeteer-proxy-config.js, puppeteer-proxy-helper.js
```

## Performance Tips

1. **Reuse Sessions**: Don't create new Puppeteer instances for each scrape
2. **Headless Mode**: Use headless mode for better performance
3. **Caching**: Cache scraped data when appropriate
4. **Parallel Scraping**: Use multiple pages for concurrent scraping

## Contributing

Feel free to submit issues and enhancement requests!

## License

This package follows the same license as the parent project.