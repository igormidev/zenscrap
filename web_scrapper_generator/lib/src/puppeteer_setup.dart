// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:path/path.dart' as path;

class PuppeteerSetup {
  static PuppeteerSetup? _instance;
  PuppeteerSetup._();
  static PuppeteerSetup get instance => _instance ??= PuppeteerSetup._();

  /// Ensures Puppeteer and its MCP integration are properly installed and configured
  ///
  /// Note: Proxy configuration is now handled dynamically by the AI through launchOptions
  /// when calling puppeteer_navigate, not during setup.
  Future<void> setupIfNeeded(
    GeminiSDK geminiSDK, {
    ScrappingBeeProxyConfig? proxyConfig,
  }) async {
    print('🚀 Setting up Puppeteer for web scraping...\n');

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

      // Step 2: Check and install puppeteer locally
      print('🌐 Checking Puppeteer installation...');
      final puppeteerInstalled = await _isPuppeteerInstalled();

      if (!puppeteerInstalled) {
        print('📥 Puppeteer not found. Installing locally...');
        await _installPuppeteer();
        print('✅ Puppeteer installed successfully\n');
      } else {
        print('✅ Puppeteer is already installed\n');
      }

      // Step 3: Check MCP puppeteer server configuration
      print('🔌 Checking MCP Puppeteer server configuration...');
      final mcpConfigured = await _isMcpPuppeteerConfigured(geminiSDK);

      if (!mcpConfigured) {
        print('⚙️ Configuring MCP Puppeteer server...');
        await _configureMcpPuppeteer(geminiSDK);
        print('✅ MCP Puppeteer server configured successfully\n');
      } else {
        print('✅ MCP Puppeteer server is already configured\n');
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

      print('🎉 Puppeteer setup complete! Ready for web scraping.\n');
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

  /// Checks if puppeteer is installed locally
  Future<bool> _isPuppeteerInstalled() async {
    try {
      // Check if node_modules/puppeteer exists
      final puppeteerPath = path.join(
        Directory.current.path,
        'node_modules',
        'puppeteer',
      );
      return Directory(puppeteerPath).existsSync();
    } catch (e) {
      return false;
    }
  }

  /// Installs puppeteer locally
  Future<void> _installPuppeteer() async {
    try {
      print('  Installing puppeteer...');
      final result = await Process.run(
        Platform.isWindows ? 'cmd.exe' : 'sh',
        Platform.isWindows
            ? ['/c', 'npm install puppeteer']
            : ['-c', 'npm install puppeteer'],
        workingDirectory: Directory.current.path,
      );

      if (result.exitCode != 0) {
        throw Exception('Failed to install puppeteer:\n${result.stderr}');
      }

      // Also install the MCP server-puppeteer globally if not already installed
      print('  Installing @modelcontextprotocol/server-puppeteer...');
      final mcpResult = await Process.run(
        Platform.isWindows ? 'cmd.exe' : 'sh',
        Platform.isWindows
            ? ['/c', 'npm install -g @modelcontextprotocol/server-puppeteer']
            : ['-c', 'npm install -g @modelcontextprotocol/server-puppeteer'],
      );

      if (mcpResult.exitCode != 0) {
        // Try local installation if global fails
        print('  Global installation failed, trying local installation...');
        await Process.run(
          Platform.isWindows ? 'cmd.exe' : 'sh',
          Platform.isWindows
              ? ['/c', 'npm install @modelcontextprotocol/server-puppeteer']
              : ['-c', 'npm install @modelcontextprotocol/server-puppeteer'],
          workingDirectory: Directory.current.path,
        );
      }
    } catch (e) {
      throw Exception('Failed to install puppeteer: $e');
    }
  }

  /// Checks if MCP puppeteer server is configured
  Future<bool> _isMcpPuppeteerConfigured(GeminiSDK geminiSDK) async {
    try {
      final mcpInfo = await geminiSDK.isMcpInstalled();
      if (!mcpInfo.hasMcpSupport) {
        return false;
      }

      // Check if puppeteer server is in the list
      return mcpInfo.servers.any(
        (server) =>
            server.name.toLowerCase().contains('puppeteer') ||
            server.name.contains('mcp-puppeteer'),
      );
    } catch (e) {
      return false;
    }
  }

  /// Configures the MCP puppeteer server
  Future<void> _configureMcpPuppeteer(GeminiSDK geminiSDK) async {
    try {
      await geminiSDK.installPopularMcpServer('puppeteer');
    } catch (e) {
      final puppeteerServer = McpServer(
        name: 'puppeteer',
        command: 'npx',
        args: ['-y', '@modelcontextprotocol/server-puppeteer'],
        env: {'NODE_PATH': path.join(Directory.current.path, 'node_modules')},
      );

      try {
        await geminiSDK.addMcpServer(
          'puppeteer',
          customServer: puppeteerServer,
        );
      } catch (_) {
        await geminiSDK.addMcpServer(
          'puppeteer',
          customServer: puppeteerServer,
          options: const McpAddOptions(scope: McpScope.project, useNpx: true),
        );
      }
    }
  }

  /// Verifies that the Puppeteer setup is working
  Future<void> _verifySetup(GeminiSDK geminiSDK) async {
    print('🔍 Verifying Puppeteer setup...');

    // Verify Puppeteer installation by creating a simple test script
    try {
      final testScript = '''
const puppeteer = require('puppeteer');
(async () => {
  try {
    const browser = await puppeteer.launch({ headless: 'new' });
    const page = await browser.newPage();
    await page.goto('https://example.com', { waitUntil: 'networkidle2' });
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
        path.join(Directory.current.path, '_puppeteer_test.js'),
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
          throw Exception('Puppeteer test failed: ${result.stderr}');
        }

        final output = result.stdout.toString();
        if (!output.contains('SUCCESS')) {
          throw Exception('Puppeteer test did not complete successfully');
        }

        print('✅ Puppeteer is working correctly');
      } finally {
        // Clean up test file
        if (await testFile.exists()) {
          await testFile.delete();
        }
      }
    } catch (e) {
      print('⚠️ Warning: Could not verify Puppeteer functionality: $e');
      print(
        '   The setup may still work, but manual verification is recommended.',
      );
    }

    // Verify MCP configuration
    final mcpInfo = await geminiSDK.isMcpInstalled();
    if (mcpInfo.hasMcpSupport) {
      final puppeteerServer = mcpInfo.servers
          .where((s) => s.name.contains('puppeteer'))
          .toList();

      if (puppeteerServer.isNotEmpty) {
        print(
          '✅ MCP Puppeteer server is registered: ${puppeteerServer.first.name}',
        );
      }
    }
  }

  /// Cleans up any temporary files or resources
  Future<void> cleanup() async {
    // Cleanup any temporary files if needed
    final filesToClean = ['_puppeteer_test.js'];

    for (final fileName in filesToClean) {
      final file = File(path.join(Directory.current.path, fileName));
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  /// Gets information about the current Puppeteer setup
  Future<Map<String, dynamic>> getSetupInfo() async {
    final info = <String, dynamic>{};

    info['npm_installed'] = await _isNpmInstalled();
    info['puppeteer_installed'] = await _isPuppeteerInstalled();

    // Check puppeteer version if installed
    if (info['puppeteer_installed']) {
      try {
        final packageJsonFile = File(
          path.join(Directory.current.path, 'package.json'),
        );
        if (await packageJsonFile.exists()) {
          final content = await packageJsonFile.readAsString();
          // Extract version from package.json
          final versionMatch = RegExp(
            r'"puppeteer":\s*"([^"]+)"',
          ).firstMatch(content);
          if (versionMatch != null) {
            info['puppeteer_version'] = versionMatch.group(1);
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
/// For Puppeteer, proxy settings are passed dynamically through launchOptions.
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
