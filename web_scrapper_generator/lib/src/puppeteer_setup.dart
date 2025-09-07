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
  /// [proxyConfig] Optional ScrapingBee proxy configuration for web scraping
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

      // Step 4: Setup proxy configuration if provided
      if (proxyConfig != null) {
        print('🔐 Configuring ScrapingBee proxy...');
        await _setupProxyConfiguration(proxyConfig);
        print('✅ Proxy configuration complete\n');
      }

      // Step 5: Verify the setup
      await _verifySetup(geminiSDK, proxyConfig: proxyConfig);

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

  /// Checks if puppeteer is installed locally in the project
  Future<bool> _isPuppeteerInstalled() async {
    try {
      // Check in local node_modules
      final nodeModulesPath = path.join(
        Directory.current.path,
        'node_modules',
        'puppeteer',
      );
      final puppeteerDir = Directory(nodeModulesPath);

      if (await puppeteerDir.exists()) {
        return true;
      }

      // Also check if package.json exists and contains puppeteer
      final packageJsonFile = File(
        path.join(Directory.current.path, 'package.json'),
      );
      if (await packageJsonFile.exists()) {
        final content = await packageJsonFile.readAsString();
        return content.contains('"puppeteer"');
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Installs puppeteer and MCP SDK locally
  Future<void> _installPuppeteer() async {
    // First, ensure package.json exists
    final packageJsonFile = File(
      path.join(Directory.current.path, 'package.json'),
    );
    if (!await packageJsonFile.exists()) {
      print('📝 Initializing npm project...');

      // Create a basic package.json
      await packageJsonFile.writeAsString('''{
  "name": "web-scrapper-generator",
  "version": "1.0.0",
  "description": "Web scrapper generator with Puppeteer support",
  "private": true,
  "dependencies": {}
}''');
    }

    // Install puppeteer and the MCP puppeteer server
    print('📦 Installing puppeteer and dependencies...');

    final process = await Process.start(
      Platform.isWindows ? 'cmd.exe' : 'sh',
      Platform.isWindows
          ? [
              '/c',
              'npm install puppeteer @modelcontextprotocol/server-puppeteer --save',
            ]
          : [
              '-c',
              'npm install puppeteer @modelcontextprotocol/server-puppeteer --save',
            ],
    );

    // Stream output
    process.stdout.listen((data) {
      stdout.write(String.fromCharCodes(data));
    });

    process.stderr.listen((data) {
      stderr.write(String.fromCharCodes(data));
    });

    final exitCode = await process.exitCode;

    if (exitCode != 0) {
      throw Exception('Failed to install puppeteer. Exit code: $exitCode');
    }

    // Also ensure Chrome/Chromium is downloaded
    print('🌐 Ensuring Chromium is downloaded...');
    final downloadProcess = await Process.start(
      Platform.isWindows ? 'cmd.exe' : 'sh',
      Platform.isWindows
          ? ['/c', 'npx puppeteer browsers install chrome']
          : ['-c', 'npx puppeteer browsers install chrome'],
    );

    await downloadProcess.exitCode;
  }

  /// Checks if MCP puppeteer server is configured
  Future<bool> _isMcpPuppeteerConfigured(GeminiSDK geminiSDK) async {
    try {
      final servers = await geminiSDK.listMcpServers();
      return servers.any(
        (server) =>
            server.name == 'puppeteer' ||
            server.command.contains('puppeteer') ||
            (server.args.isNotEmpty &&
                server.args.any((arg) => arg.contains('puppeteer'))),
      );
    } catch (e) {
      return false;
    }
  }

  /// Sets up proxy configuration for Puppeteer
  Future<void> _setupProxyConfiguration(ScrappingBeeProxyConfig config) async {
    try {
      // Create a configuration file for the proxy
      final proxyConfigFile = File(
        path.join(Directory.current.path, 'puppeteer-proxy-config.js'),
      );
      
      // Generate the Puppeteer configuration with proxy settings
      final configContent = '''
// Puppeteer configuration with ScrapingBee proxy
module.exports = {
  proxyUrl: '${config.proxyUrl}',
  launchOptions: {
    headless: 'new',
    args: [
      '--proxy-server=${config.proxyHost}:${config.proxyPort}',
      '--ignore-certificate-errors',
      '--ignore-certificate-errors-spki-list',
      '--disable-web-security',
      '--disable-features=IsolateOrigins',
      '--disable-site-isolation-trials',
      '--no-sandbox',
      '--disable-setuid-sandbox',
    ],
    ignoreHTTPSErrors: true,
  },
  // Authentication for ScrapingBee proxy
  authenticate: async (page) => {
    await page.authenticate({
      username: '${config.apiKey}',
      password: '${config._buildParameters()}',
    });
  },
  // Block unnecessary resources to save API credits
  blockResources: ${!config.renderJs},
  blockedResourceTypes: [
    'image',
    'media',
    'font',
    'texttrack',
    'object',
    'beacon',
    'csp_report',
    'imageset',
  ],
  // ScrapingBee specific settings
  scrapingBeeConfig: {
    apiKey: '${config.apiKey}',
    stealthProxy: ${config.stealthProxy},
    renderJs: ${config.renderJs},
    premiumProxy: ${config.premiumProxy},
    ${config.countryCode != null ? "countryCode: '${config.countryCode}'," : ''}
  },
};
''';
      
      await proxyConfigFile.writeAsString(configContent);
      print('  \u2713 Created proxy configuration file');
      
      // Also create a helper script for using the proxy
      final helperScriptFile = File(
        path.join(Directory.current.path, 'puppeteer-proxy-helper.js'),
      );
      
      final helperScript = '''
// Helper functions for ScrapingBee proxy with Puppeteer
const config = require('./puppeteer-proxy-config.js');

async function launchBrowserWithProxy() {
  const puppeteer = require('puppeteer');
  const browser = await puppeteer.launch(config.launchOptions);
  const page = await browser.newPage();
  
  // Authenticate with proxy
  await config.authenticate(page);
  
  // Block resources if configured
  if (config.blockResources) {
    await page.setRequestInterception(true);
    page.on('request', (request) => {
      if (config.blockedResourceTypes.includes(request.resourceType())) {
        request.abort();
      } else {
        request.continue();
      }
    });
  }
  
  return { browser, page };
}

module.exports = { launchBrowserWithProxy, config };
''';
      
      await helperScriptFile.writeAsString(helperScript);
      print('  \u2713 Created proxy helper script');
      
    } catch (e) {
      throw Exception('Failed to setup proxy configuration: $e');
    }
  }

  /// Generates a test script for proxy configuration
  String _generateProxyTestScript(ScrappingBeeProxyConfig config) {
    return '''
const puppeteer = require('puppeteer');
(async () => {
  try {
    // Launch browser with proxy configuration
    const browser = await puppeteer.launch({
      headless: 'new',
      args: [
        '--proxy-server=${config.proxyHost}:${config.proxyPort}',
        '--ignore-certificate-errors',
        '--ignore-certificate-errors-spki-list',
        '--no-sandbox',
        '--disable-setuid-sandbox',
      ],
      ignoreHTTPSErrors: true,
    });
    
    const page = await browser.newPage();
    
    // Authenticate with ScrapingBee proxy
    await page.authenticate({
      username: '${config.apiKey}',
      password: '${config._buildParameters()}',
    });
    
    // Test by navigating to a simple page
    await page.goto('https://httpbin.org/ip', { waitUntil: 'networkidle2' });
    const content = await page.content();
    
    // Check if we got a response (proxy is working)
    if (content.includes('origin')) {
      console.log('SUCCESS: Proxy connection established');
      const ipData = await page.evaluate(() => {
        const pre = document.querySelector('pre');
        return pre ? pre.textContent : null;
      });
      if (ipData) {
        console.log('Proxy IP info:', ipData);
      }
    } else {
      console.log('ERROR: Could not verify proxy connection');
    }
    
    await browser.close();
    process.exit(0);
  } catch (error) {
    console.error('ERROR: ' + error.message);
    process.exit(1);
  }
})();
''';
  }

  /// Configures the MCP puppeteer server
  Future<void> _configureMcpPuppeteer(GeminiSDK geminiSDK) async {
    try {
      // Check if the popular server is available
      if (PopularMcpServers.isPopular('puppeteer')) {
        // Use the popular server configuration
        await geminiSDK.installPopularMcpServer('puppeteer');
      } else {
        // Configure custom MCP server for puppeteer
        final puppeteerServer = McpServer(
          name: 'puppeteer',
          command: 'npx',
          args: ['-y', '@modelcontextprotocol/server-puppeteer'],
          env: {'NODE_PATH': path.join(Directory.current.path, 'node_modules')},
        );

        await geminiSDK.addMcpServer(
          'puppeteer',
          customServer: puppeteerServer,
        );
      }
    } catch (e) {
      // If adding to user config fails, try project scope
      try {
        await geminiSDK.addMcpServer(
          'puppeteer',
          packageName: '@modelcontextprotocol/server-puppeteer',
          options: McpAddOptions(
            scope: McpScope.project,
            useNpx: true,
            environment: {
              'NODE_PATH': path.join(Directory.current.path, 'node_modules'),
            },
          ),
        );
      } catch (e2) {
        throw Exception('Failed to configure MCP Puppeteer server: $e2');
      }
    }
  }

  /// Verifies that the setup is complete and working
  Future<void> _verifySetup(
    GeminiSDK geminiSDK, {
    ScrappingBeeProxyConfig? proxyConfig,
  }) async {
    print('🔍 Verifying Puppeteer setup...');

    // Test if puppeteer can be run
    try {
      final testScript = proxyConfig != null
          ? _generateProxyTestScript(proxyConfig)
          : '''
const puppeteer = require('puppeteer');
(async () => {
  try {
    const browser = await puppeteer.launch({ headless: 'new' });
    const page = await browser.newPage();
    await page.goto('https://example.com');
    const title = await page.title();
    console.log('SUCCESS: ' + title);
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
    final filesToClean = [
      '_puppeteer_test.js',
      'puppeteer-proxy-config.js',
      'puppeteer-proxy-helper.js',
    ];
    
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
        info['puppeteer_version'] = 'unknown';
      }
    }
    
    // Check proxy configuration
    final proxyConfigFile = File(
      path.join(Directory.current.path, 'puppeteer-proxy-config.js'),
    );
    info['proxy_configured'] = await proxyConfigFile.exists();
    
    // Check for ScrapingBee server-puppeteer
    if (info['puppeteer_installed']) {
      final scrapingBeeServerPath = path.join(
        Directory.current.path,
        'node_modules',
        '@modelcontextprotocol',
        'server-puppeteer',
      );
      info['scrapingbee_mcp_installed'] = await Directory(scrapingBeeServerPath).exists();
    }

    info['node_modules_path'] = path.join(
      Directory.current.path,
      'node_modules',
    );
    info['project_path'] = Directory.current.path;

    return info;
  }
}

/// Configuration for ScrapingBee proxy service
class ScrappingBeeProxyConfig {
  /// Your ScrapingBee API key
  final String apiKey;
  
  /// Proxy server host (default: proxy.scrapingbee.com)
  final String proxyHost;
  
  /// Proxy port (default: 8886 for HTTP, 8887 for HTTPS)
  final int proxyPort;
  
  /// Protocol to use (http, https, or socks5)
  final ProxyProtocol protocol;
  
  /// Parameters to pass to ScrapingBee (e.g., render_js, premium_proxy)
  final Map<String, String> parameters;
  
  /// Whether to use stealth proxy (rotating IPs)
  final bool stealthProxy;
  
  /// Whether to render JavaScript (default: false for proxy mode)
  final bool renderJs;
  
  /// Whether to use premium proxy
  final bool premiumProxy;
  
  /// Country code for geo-targeted requests
  final String? countryCode;
  
  const ScrappingBeeProxyConfig({
    required this.apiKey,
    this.proxyHost = 'proxy.scrapingbee.com',
    this.proxyPort = 8886,
    this.protocol = ProxyProtocol.http,
    this.parameters = const {},
    this.stealthProxy = true,
    this.renderJs = false,
    this.premiumProxy = false,
    this.countryCode,
  });

  /// Generates the proxy URL for Puppeteer
  String get proxyUrl {
    final params = _buildParameters();
    final auth = params.isEmpty ? apiKey : '$apiKey:$params';
    final scheme = protocol == ProxyProtocol.socks5 ? 'socks5' : protocol.name;
    return '$scheme://$auth@$proxyHost:$proxyPort';
  }
  
  /// Builds the parameter string for authentication
  String _buildParameters() {
    final allParams = Map<String, String>.from(parameters);
    
    // Add default parameters based on configuration
    allParams['render_js'] = renderJs.toString();
    
    if (stealthProxy) {
      allParams['stealth_proxy'] = 'true';
    }
    
    if (premiumProxy) {
      allParams['premium_proxy'] = 'true';
    }
    
    if (countryCode != null) {
      allParams['country_code'] = countryCode!;
    }
    
    // Join parameters with & delimiter
    return allParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
  }
  
  /// Gets the appropriate port based on protocol
  int get defaultPort {
    switch (protocol) {
      case ProxyProtocol.http:
        return 8886;
      case ProxyProtocol.https:
        return 8887;
      case ProxyProtocol.socks5:
        return 8888;
    }
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
enum ProxyProtocol {
  http,
  https,
  socks5,
}
