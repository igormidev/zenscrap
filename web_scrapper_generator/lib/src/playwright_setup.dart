// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:path/path.dart' as path;

class PlaywrightSetup {
  static PlaywrightSetup? _instance;
  PlaywrightSetup._();
  static PlaywrightSetup get instance => _instance ??= PlaywrightSetup._();

  /// Ensures Playwright and its MCP integration are properly installed and configured
  ///
  /// Note: Proxy configuration is now handled dynamically by the AI through launchOptions
  /// when calling playwright tools, not during setup.
  Future<void> setupIfNeeded(
    GeminiSDK geminiSDK, {
    ScrappingBeeProxyConfig? proxyConfig,
  }) async {
    print('🚀 Setting up Playwright for web scraping...\n');

    try {
      // Step 1: Check if npm is installed
      print('📦 Checking npm installation...');
      final npmInstalled = await _isNpmInstalled();
      if (!npmInstalled) {
        throw Exception(
          'npm is not installed. Please install Node.js and npm first.\n'
          'Visit https://nodejs.org/ to download and install Node.js.',
        );
      }
      print('✅ npm is installed\n');

      // Step 2: Check and install playwright locally
      print('🌐 Checking Playwright installation...');
      final playwrightInstalled = await _isPlaywrightInstalled();

      if (!playwrightInstalled) {
        print('📥 Playwright not found. Installing locally...');
        await _installPlaywright();
        print('✅ Playwright installed successfully\n');
      } else {
        print('✅ Playwright is already installed\n');
      }

      // Step 3: Check MCP playwright server configuration
      print('🔌 Checking MCP Playwright server configuration...');
      final mcpConfigured = await _isMcpPlaywrightConfigured(geminiSDK);

      if (!mcpConfigured) {
        print('⚙️ Configuring MCP Playwright server...');
        await _configureMcpPlaywright(geminiSDK);
        print('✅ MCP Playwright server configured successfully\n');
      } else {
        print('✅ MCP Playwright server is already configured\n');
      }

      // Note: Proxy configuration is now handled dynamically by the AI
      // The proxyConfig parameter is kept for backward compatibility but not used
      if (proxyConfig != null) {
        print('ℹ️ Proxy configuration is now handled dynamically by the AI\n');
        print(
          '   The AI will pass proxy settings through launchOptions when needed.\n',
        );
      }

      // Step 4: Verify the setup
      await _verifySetup(geminiSDK);

      print('🎉 Playwright setup complete! Ready for web scraping.\n');
    } catch (e) {
      print('❌ Setup failed: $e');
      rethrow;
    }
  }

  /// Checks if npm is installed
  Future<bool> _isNpmInstalled() async {
    try {
      final result = await Process.run(
        Platform.isWindows ? 'cmd.exe' : 'sh',
        Platform.isWindows ? ['/c', 'npm --version'] : ['-c', 'npm --version'],
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Checks if playwright is installed locally
  Future<bool> _isPlaywrightInstalled() async {
    try {
      // Check if node_modules/playwright exists
      final playwrightPath = path.join(
        Directory.current.path,
        'node_modules',
        'playwright',
      );
      return Directory(playwrightPath).existsSync();
    } catch (e) {
      return false;
    }
  }

  /// Installs playwright locally
  Future<void> _installPlaywright() async {
    try {
      print('  Installing playwright...');
      final result = await Process.run(
        Platform.isWindows ? 'cmd.exe' : 'sh',
        Platform.isWindows
            ? ['/c', 'npm install playwright']
            : ['-c', 'npm install playwright'],
        workingDirectory: Directory.current.path,
      );

      if (result.exitCode != 0) {
        throw Exception('Failed to install playwright:\n${result.stderr}');
      }

      // Install the browsers
      print('  Installing Playwright browsers...');
      final browsersResult = await Process.run(
        Platform.isWindows ? 'cmd.exe' : 'sh',
        Platform.isWindows
            ? ['/c', 'npx playwright install']
            : ['-c', 'npx playwright install'],
        workingDirectory: Directory.current.path,
      );

      if (browsersResult.exitCode != 0) {
        print('  Warning: Browser installation had issues: ${browsersResult.stderr}');
      }
    } catch (e) {
      throw Exception('Failed to install playwright: $e');
    }
  }

  /// Checks if MCP playwright server is configured
  Future<bool> _isMcpPlaywrightConfigured(GeminiSDK geminiSDK) async {
    try {
      final mcpInfo = await geminiSDK.isMcpInstalled();
      if (!mcpInfo.hasMcpSupport) {
        return false;
      }

      // Check if playwright server is in the list
      return mcpInfo.servers.any(
        (server) =>
            server.name.toLowerCase().contains('playwright') ||
            server.name.contains('mcp-playwright'),
      );
    } catch (e) {
      return false;
    }
  }

  /// Configures the MCP playwright server
  Future<void> _configureMcpPlaywright(GeminiSDK geminiSDK) async {
    try {
      // First try the official Microsoft Playwright MCP
      final playwrightServer = McpServer(
        name: 'playwright',
        command: 'npx',
        args: ['@playwright/mcp@latest', '--headless'],
        env: {'NODE_PATH': path.join(Directory.current.path, 'node_modules')},
      );

      try {
        await geminiSDK.addMcpServer(
          'playwright',
          customServer: playwrightServer,
        );
      } catch (_) {
        await geminiSDK.addMcpServer(
          'playwright',
          customServer: playwrightServer,
          options: const McpAddOptions(scope: McpScope.project, useNpx: true),
        );
      }
    } catch (e) {
      // If official fails, try alternative
      print('  Official Playwright MCP failed, trying alternative...');
      final altServer = McpServer(
        name: 'playwright',
        command: 'npx',
        args: ['@executeautomation/playwright-mcp-server'],
        env: {'NODE_PATH': path.join(Directory.current.path, 'node_modules')},
      );

      await geminiSDK.addMcpServer(
        'playwright',
        customServer: altServer,
        options: const McpAddOptions(scope: McpScope.project, useNpx: true),
      );
    }
  }

  /// Verifies that the Playwright setup is working
  Future<void> _verifySetup(GeminiSDK geminiSDK) async {
    print('🔍 Verifying Playwright setup...');

    // Verify Playwright installation by creating a simple test script
    try {
      final testScript = '''
const { chromium } = require('playwright');
(async () => {
  try {
    const browser = await chromium.launch({ headless: true });
    const page = await browser.newPage();
    await page.goto('https://example.com', { waitUntil: 'networkidle' });
    const title = await page.title();
    console.log('SUCCESS: Page title is: ' + title);
    await browser.close();
    process.exit(0);
  } catch (error) {
    console.error('ERROR: ' + error.message);
    process.exit(1);
  }
})();
''';

      // Create temporary test file
      final testFile = File(
        path.join(Directory.current.path, '_playwright_test.js'),
      );
      await testFile.writeAsString(testScript);

      try {
        final result = await Process.run(
          Platform.isWindows ? 'cmd.exe' : 'sh',
          Platform.isWindows
              ? ['/c', 'node ${testFile.path}']
              : ['-c', 'node ${testFile.path}'],
        );

        if (result.exitCode != 0) {
          throw Exception('Playwright test failed: ${result.stderr}');
        }

        final output = result.stdout.toString();
        if (!output.contains('SUCCESS')) {
          throw Exception('Playwright test did not complete successfully');
        }

        print('✅ Playwright is working correctly');
      } finally {
        // Clean up test file
        if (await testFile.exists()) {
          await testFile.delete();
        }
      }
    } catch (e) {
      print('⚠️ Warning: Could not verify Playwright functionality: $e');
      print(
        '   The setup may still work, but manual verification is recommended.',
      );
    }

    // Verify MCP configuration
    final mcpInfo = await geminiSDK.isMcpInstalled();
    if (mcpInfo.hasMcpSupport) {
      final playwrightServer = mcpInfo.servers
          .where((s) => s.name.contains('playwright'))
          .toList();

      if (playwrightServer.isNotEmpty) {
        print(
          '✅ MCP Playwright server is registered: ${playwrightServer.first.name}',
        );
      }
    }
  }

  /// Cleans up any temporary files or resources
  Future<void> cleanup() async {
    // Cleanup any temporary files if needed
    final filesToClean = ['_playwright_test.js'];

    for (final fileName in filesToClean) {
      final file = File(path.join(Directory.current.path, fileName));
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  /// Gets information about the current Playwright setup
  Future<Map<String, dynamic>> getSetupInfo() async {
    final info = <String, dynamic>{};

    info['npm_installed'] = await _isNpmInstalled();
    info['playwright_installed'] = await _isPlaywrightInstalled();

    // Check playwright version if installed
    if (info['playwright_installed']) {
      try {
        final packageJsonFile = File(
          path.join(Directory.current.path, 'package.json'),
        );
        if (await packageJsonFile.exists()) {
          final content = await packageJsonFile.readAsString();
          // Extract version from package.json
          final versionMatch = RegExp(
            r'"playwright":\s*"([^"]+)"',
          ).firstMatch(content);
          if (versionMatch != null) {
            info['playwright_version'] = versionMatch.group(1);
          }
        }
      } catch (e) {
        // Ignore errors in version checking
      }
    }

    return info;
  }
}

/// Configuration for ScrapingBee proxy service
/// Note: This is now primarily used for the ScrapingBee MCP server.
/// For Playwright, proxy settings are passed dynamically through launchOptions.
class ScrappingBeeProxyConfig {
  /// Your ScrapingBee API key
  final String apiKey;

  /// Proxy server host (default: proxy.scrapingbee.com)
  final String proxyHost;

  /// Proxy port (default: 8886 for HTTP, 8887 for HTTPS)
  final int proxyPort;

  /// Protocol to use (http, https, or socks5)
  final ProxyProtocol protocol;

  /// Custom parameters to pass to ScrapingBee
  final Map<String, String> parameters;

  /// Use stealth proxy for better success rates (rotating IPs)
  final bool stealthProxy;

  /// Enable JavaScript rendering
  final bool renderJs;

  /// Use premium residential proxies
  final bool premiumProxy;

  /// Country code for geo-targeting (e.g., 'us', 'de', 'br')
  final String? countryCode;

  const ScrappingBeeProxyConfig({
    required this.apiKey,
    this.proxyHost = 'proxy.scrapingbee.com',
    this.proxyPort = 8886,
    this.protocol = ProxyProtocol.http,
    this.parameters = const {},
    this.stealthProxy = true,
    this.renderJs = true,
    this.premiumProxy = true,
    this.countryCode,
  });

  /// Generates the proxy URL for browser configuration
  /// Format: http://apikey:params@proxy.scrapingbee.com:port
  String buildProxyUrl({String? dynamicCountryCode}) {
    final country = dynamicCountryCode ?? countryCode ?? 'us';
    final params = _buildParameters(countryCode: country);
    final auth = params.isEmpty ? apiKey : '$apiKey:$params';
    final scheme = protocol == ProxyProtocol.socks5 ? 'socks5' : protocol.name;
    return '$scheme://$auth@$proxyHost:$proxyPort';
  }

  /// Builds the parameter string for authentication
  String _buildParameters({String? countryCode}) {
    final params = <String, String>{};

    // Always set these for proxy mode
    params['render_js'] = renderJs ? 'True' : 'False';
    params['premium_proxy'] = premiumProxy ? 'True' : 'False';

    if (stealthProxy) {
      params['stealth_proxy'] = 'True';
    }

    // Use provided country code or fall back to configured one
    final country = countryCode ?? this.countryCode;
    if (country != null) {
      params['country_code'] = country;
    }

    // Add any custom parameters
    params.addAll(parameters);

    // Format as key1=value1&key2=value2
    return params.entries.map((e) => '${e.key}=${e.value}').join('&');
  }

  ScrappingBeeProxyConfig copyWith({
    String? apiKey,
    String? proxyHost,
    int? proxyPort,
    ProxyProtocol? protocol,
    Map<String, String>? parameters,
    bool? stealthProxy,
    bool? renderJs,
    bool? premiumProxy,
    String? countryCode,
  }) {
    return ScrappingBeeProxyConfig(
      apiKey: apiKey ?? this.apiKey,
      proxyHost: proxyHost ?? this.proxyHost,
      proxyPort: proxyPort ?? this.proxyPort,
      protocol: protocol ?? this.protocol,
      parameters: parameters ?? this.parameters,
      stealthProxy: stealthProxy ?? this.stealthProxy,
      renderJs: renderJs ?? this.renderJs,
      premiumProxy: premiumProxy ?? this.premiumProxy,
      countryCode: countryCode ?? this.countryCode,
    );
  }
}

/// Proxy protocol types supported by ScrapingBee
enum ProxyProtocol { http, https, socks5 }