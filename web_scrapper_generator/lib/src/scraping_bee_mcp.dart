import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dart_mcp/server.dart';
import 'package:dart_mcp/stdio.dart';
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart' hide TextContent;
import 'package:path/path.dart' as path;
import 'scraping_bee_api_mixin.dart';

/// ScrapingBee MCP Server implementation
/// Provides MCP tools for testing web scraping extract rules
base class ScrapingBeeMcpServer extends MCPServer with ToolsSupport, ScrapingBeeApiMixin {
  ScrapingBeeMcpServer.fromStdio()
    : super.fromStreamChannel(
        stdioChannel(input: stdin, output: stdout),
        implementation: Implementation(
          name: 'scraping-bee-mcp',
          version: '1.0.0',
        ),
        instructions:
            'ScrapingBee MCP server for testing web scraping extract rules. '
            'Use the test_extract_rules tool to validate extraction rules against target URLs.',
      );

  @override
  FutureOr<InitializeResult> initialize(InitializeRequest request) async {
    // Set the API key for ScrapingBee
    ScrapingBeeApiMixin.setApiKey(
        '37N8150Q1JBVN85NS4RUOUIUYZ2AEUFX69QBM0X74VD13M9TLNRVOFWS7HZMKRG1X4SOH4BKJT5EUN6K');
    // Register the test_extract_rules tool
    registerTool(
      Tool(
        name: 'test_extract_rules',
        description:
            'Test web scraping extract rules using ScrapingBee API. '
            'Extracts structured data from web pages using CSS/XPath selectors.',
        inputSchema: ObjectSchema(
          properties: {
            'url': Schema.string(description: 'The target page URL to scrape'),
            'extract_rules': Schema.string(
              description:
                  'JSON-encoded string describing what to extract '
                  '(CSS/XPath selectors, lists, attributes, tables, etc.)',
            ),
            'js_scenario': Schema.string(
              description:
                  'Optional JSON-encoded string of scripted actions '
                  '(click/type/scroll/infinite-scroll/etc.) to run before extraction',
            ),
            'render_js': Schema.bool(
              description:
                  'Enable a headless browser to execute JavaScript before extraction',
            ),
            'wait': Schema.int(
              description:
                  'Fixed delay in milliseconds before returning the response (0-35000)',
              minimum: 0,
              maximum: 35000,
            ),
            'wait_for': Schema.string(
              description: 'CSS/XPath selector to wait for before returning',
            ),
            'wait_browser': Schema.string(
              description: 'Browser event to wait for (e.g., domcontentloaded)',
              enumValues: [
                'domcontentloaded',
                'load',
                'networkidle0',
                'networkidle2',
              ],
            ),
            'premium_proxy': Schema.bool(
              description: 'Use residential proxy for scraper-resistant sites',
            ),
            'stealth_proxy': Schema.bool(
              description: 'Use stealth proxy for the hardest-to-scrape sites (most expensive option)',
            ),
            'country_code': Schema.string(
              description: 'Proxy geolocation (e.g., us, de, br)',
              pattern: r'^[a-z]{2}$',
            ),
            'session_id': Schema.int(
              description:
                  'Keep the same IP across multiple requests (sticky sessions)',
            ),
            'custom_google': Schema.bool(
              description:
                  'Enable Google-specific handling (always true for Google domains)',
            ),
          },
          required: ['url', 'extract_rules'],
        ),
      ),
      (request) async => await _testExtractRules(request.arguments ?? {}),
    );

    return await super.initialize(request);
  }

  /// Handle the test_extract_rules tool call
  Future<CallToolResult> _testExtractRules(Map<String, Object?> args) async {
    try {
      // Extract required parameters
      final String url = args['url'] as String;
      final String extractRules = args['extract_rules'] as String;

      // Validate extract_rules is valid JSON
      try {
        jsonDecode(extractRules);
      } catch (e) {
        return CallToolResult(
          content: [
            TextContent(
              text: jsonEncode({
                'success': false,
                'error': 'Invalid extract_rules JSON: $e',
                'message':
                    'The extract_rules parameter must be a valid JSON string',
              }),
            ),
          ],
          isError: true,
        );
      }

      // Validate js_scenario if provided
      String? jsScenario;
      if (args.containsKey('js_scenario') && args['js_scenario'] != null) {
        jsScenario = args['js_scenario'] as String;
        try {
          jsonDecode(jsScenario);
        } catch (e) {
          return CallToolResult(
            content: [
              TextContent(
                text: jsonEncode({
                  'success': false,
                  'error': 'Invalid js_scenario JSON: $e',
                  'message':
                      'The js_scenario parameter must be a valid JSON string',
                }),
              ),
            ],
            isError: true,
          );
        }
      }

      // Extract optional parameters with validation
      final bool renderJs = args['render_js'] as bool? ?? true;

      int? wait;
      if (args.containsKey('wait') && args['wait'] != null) {
        wait = args['wait'] as int;
        if (wait < 0 || wait > 35000) {
          return CallToolResult(
            content: [
              TextContent(
                text: jsonEncode({
                  'success': false,
                  'error': 'Invalid wait value',
                  'message': 'Wait must be between 0 and 35000 milliseconds',
                }),
              ),
            ],
            isError: true,
          );
        }
      }

      final String? waitFor = args['wait_for'] as String?;
      final String? waitBrowser = args['wait_browser'] as String?;
      final bool premiumProxy = args['premium_proxy'] as bool? ?? false;
      final bool stealthProxy = args['stealth_proxy'] as bool? ?? false;

      String? countryCode;
      if (args.containsKey('country_code') && args['country_code'] != null) {
        countryCode = args['country_code'] as String;
        if (!RegExp(r'^[a-z]{2}$').hasMatch(countryCode)) {
          return CallToolResult(
            content: [
              TextContent(
                text: jsonEncode({
                  'success': false,
                  'error': 'Invalid country_code',
                  'message':
                      'Country code must be a 2-letter lowercase code (e.g., us, de, br)',
                }),
              ),
            ],
            isError: true,
          );
        }
      }

      final String? sessionId = args['session_id']?.toString();
      final bool? customGoogle = args['custom_google'] as bool?;

      // Use the mixin method to extract data
      final result = await extractByRules(
        targetUrl: url,
        extract_rules: extractRules,
        js_scenario: jsScenario,
        render_js: renderJs,
        wait: wait,
        wait_for: waitFor,
        wait_browser: waitBrowser,
        premium_proxy: premiumProxy,
        stealth_proxy: stealthProxy,
        country_code: countryCode,
        session_id: sessionId,
        custom_google: customGoogle,
      );

      // Handle the result using the when method
      return result.when(
        withData: (data) => CallToolResult(
          content: [
            TextContent(
              text: jsonEncode({
                'success': true,
                'data': data,
                'message': 'Data extracted successfully',
                'url': url,
                'rules_applied': jsonDecode(extractRules),
              }),
            ),
          ],
        ),
        error: (errorMessage) => CallToolResult(
          content: [
            TextContent(
              text: jsonEncode({
                'success': false,
                'error': errorMessage,
                'message': 'Failed to extract data from the target URL',
              }),
            ),
          ],
          isError: true,
        ),
      );
    } catch (e) {
      // Any other unexpected errors
      return CallToolResult(
        content: [
          TextContent(
            text: jsonEncode({
              'success': false,
              'error': e.toString(),
              'message':
                  'An unexpected error occurred while processing the request',
            }),
          ),
        ],
        isError: true,
      );
    }
  }
}

/// Standalone executable entry point for the MCP server
Future<void> main() async {
  try {
    // Create and start the server
    // The server will automatically handle initialization and tool registration
    ScrapingBeeMcpServer.fromStdio();

    // Keep the server running indefinitely
    await Completer<void>().future;
  } catch (e) {
    stderr.writeln('Error running ScrapingBee MCP server: $e');
    exit(1);
  }
}

/// Setup class for ScrapingBee MCP Server integration with Gemini CLI
class ScrapingBeeMcpServerSetup {
  static ScrapingBeeMcpServerSetup? _instance;
  ScrapingBeeMcpServerSetup._();
  static ScrapingBeeMcpServerSetup get instance =>
      _instance ??= ScrapingBeeMcpServerSetup._();

  /// Ensures ScrapingBee MCP server is properly installed and configured
  Future<void> setupIfNeeded(GeminiSDK geminiSDK) async {
    print('🐝 Setting up ScrapingBee MCP server...\n');

    try {
      // Step 1: Check if MCP server is already configured
      print('🔌 Checking ScrapingBee MCP server configuration...');
      final mcpConfigured = await _isMcpScrapingBeeConfigured(geminiSDK);

      if (!mcpConfigured) {
        print('⚙️ Configuring ScrapingBee MCP server...');

        // Step 2: Compile the server executable if needed
        await _compileServerIfNeeded();

        // Step 3: Configure the MCP server
        await _configureMcpScrapingBee(geminiSDK);

        print('✅ ScrapingBee MCP server configured successfully\n');
      } else {
        print('✅ ScrapingBee MCP server is already configured\n');
      }

      // Step 4: Verify the setup
      await _verifySetup(geminiSDK);

      print('🎉 ScrapingBee MCP setup complete! Ready for web scraping.\n');
    } catch (e) {
      print('❌ Setup failed: $e');
      rethrow;
    }
  }

  /// Checks if ScrapingBee MCP server is configured
  static Future<bool> _isMcpScrapingBeeConfigured(GeminiSDK geminiSDK) async {
    try {
      final servers = await geminiSDK.listMcpServers();
      return servers.any(
        (server) =>
            server.name == 'scraping-bee-mcp' ||
            server.command.contains('scraping_bee_mcp_server') ||
            (server.args.isNotEmpty &&
                server.args.any((arg) => arg.contains('scraping_bee_mcp'))),
      );
    } catch (e) {
      return false;
    }
  }

  /// Resolves the package root directory for web_scrapper_generator
  static Future<String> _resolvePackageRoot() async {
    // Try to resolve the package URI to find the actual package location
    final packageUri = Uri.parse(
      'package:web_scrapper_generator/web_scrapper_generator.dart',
    );
    final resolvedUri = await Isolate.resolvePackageUri(packageUri);

    if (resolvedUri != null) {
      // Get the directory path from the resolved URI
      // The URI points to lib/web_scrapper_generator.dart, so we need to go up to the package root
      final libPath = resolvedUri.toFilePath();
      final packageRoot = path.dirname(
        path.dirname(libPath),
      ); // Go up from lib/file.dart to package root
      return packageRoot;
    }

    // Fallback to current directory if resolution fails
    return Directory.current.path;
  }

  /// Compiles the MCP server executable if needed
  static Future<void> _compileServerIfNeeded() async {
    final packagePath = await _resolvePackageRoot();
    final serverScriptPath = path.join(
      packagePath,
      'bin',
      'scraping_bee_mcp_server.dart',
    );
    final compiledPath = path.join(
      packagePath,
      'bin',
      Platform.isWindows
          ? 'scraping_bee_mcp_server.exe'
          : 'scraping_bee_mcp_server',
    );

    final compiledFile = File(compiledPath);
    final serverScript = File(serverScriptPath);

    // Check if we need to compile
    bool needsCompilation = false;

    if (!await compiledFile.exists()) {
      needsCompilation = true;
    } else if (await serverScript.exists()) {
      // Check if source is newer than compiled
      final scriptModified = await serverScript.lastModified();
      final compiledModified = await compiledFile.lastModified();
      if (scriptModified.isAfter(compiledModified)) {
        needsCompilation = true;
      }
    }

    if (needsCompilation) {
      print('📦 Compiling ScrapingBee MCP server executable...');

      final result = await Process.run('dart', [
        'compile',
        'exe',
        serverScriptPath,
        '-o',
        compiledPath,
      ]);

      if (result.exitCode != 0) {
        throw Exception(
          'Failed to compile ScrapingBee MCP server: ${result.stderr}',
        );
      }

      print('✅ ScrapingBee MCP server compiled successfully');
    }
  }

  /// Configures the ScrapingBee MCP server in Gemini CLI
  static Future<void> _configureMcpScrapingBee(GeminiSDK geminiSDK) async {
    try {
      final packagePath = await _resolvePackageRoot();
      final executablePath = path.join(
        packagePath,
        'bin',
        Platform.isWindows
            ? 'scraping_bee_mcp_server.exe'
            : 'scraping_bee_mcp_server',
      );

      final executableFile = File(executablePath);

      if (await executableFile.exists()) {
        // Use compiled executable
        final server = McpServer(
          name: 'scraping-bee-mcp',
          command: executablePath,
          args: [],
          env: {},
        );

        await geminiSDK.addMcpServer('scraping-bee-mcp', customServer: server);
      } else {
        // Fallback to dart run
        final serverScriptPath = path.join(
          packagePath,
          'bin',
          'scraping_bee_mcp_server.dart',
        );

        final server = McpServer(
          name: 'scraping-bee-mcp',
          command: 'dart',
          args: ['run', serverScriptPath],
          env: {},
        );

        await geminiSDK.addMcpServer('scraping-bee-mcp', customServer: server);
      }
    } catch (e) {
      // If adding to user config fails, try project scope
      try {
        final packagePath = await _resolvePackageRoot();
        final serverScriptPath = path.join(
          packagePath,
          'bin',
          'scraping_bee_mcp_server.dart',
        );

        await geminiSDK.addMcpServer(
          'scraping-bee-mcp',
          customServer: McpServer(
            name: 'scraping-bee-mcp',
            command: 'dart',
            args: ['run', serverScriptPath],
            env: {},
          ),
          options: McpAddOptions(scope: McpScope.project),
        );
      } catch (e2) {
        throw Exception('Failed to configure ScrapingBee MCP server: $e2');
      }
    }
  }

  /// Verifies that the setup is complete and working
  static Future<void> _verifySetup(GeminiSDK geminiSDK) async {
    print('🔍 Verifying ScrapingBee MCP setup...');

    // Verify MCP configuration
    final mcpInfo = await geminiSDK.isMcpInstalled();
    if (mcpInfo.hasMcpSupport) {
      final scrapingBeeServer = mcpInfo.servers
          .where((s) => s.name.contains('scraping-bee-mcp'))
          .toList();

      if (scrapingBeeServer.isNotEmpty) {
        print(
          '✅ ScrapingBee MCP server is registered: ${scrapingBeeServer.first.name}',
        );
      } else {
        print(
          '⚠️ Warning: ScrapingBee MCP server not found in registered servers',
        );
      }
    } else {
      print('⚠️ Warning: MCP support not detected in Gemini SDK');
    }
  }

  /// Gets information about the current ScrapingBee MCP setup
  static Future<Map<String, dynamic>> getSetupInfo(GeminiSDK geminiSDK) async {
    final info = <String, dynamic>{};

    info['mcp_configured'] = await _isMcpScrapingBeeConfigured(geminiSDK);

    final packagePath = await _resolvePackageRoot();
    final executablePath = path.join(
      packagePath,
      'bin',
      Platform.isWindows
          ? 'scraping_bee_mcp_server.exe'
          : 'scraping_bee_mcp_server',
    );

    info['executable_exists'] = await File(executablePath).exists();
    info['executable_path'] = executablePath;

    final serverScriptPath = path.join(
      packagePath,
      'bin',
      'scraping_bee_mcp_server.dart',
    );
    info['script_exists'] = await File(serverScriptPath).exists();
    info['script_path'] = serverScriptPath;

    info['project_path'] = packagePath;

    return info;
  }

  /// Removes the ScrapingBee MCP server from Gemini CLI configuration
  static Future<void> cleanup(GeminiSDK geminiSDK) async {
    try {
      final servers = await geminiSDK.listMcpServers();
      final hasServer = servers.any((s) => s.name == 'scraping-bee-mcp');

      if (hasServer) {
        // Note: GeminiSDK would need a removeMcpServer method
        // This is a placeholder for when that functionality is available
        print(
          '⚠️ Manual removal required: Remove "scraping-bee-mcp" from MCP configuration',
        );
      } else {
        print('ScrapingBee MCP server not found in configuration');
      }
    } catch (e) {
      print('Could not check ScrapingBee MCP server: $e');
    }
  }
}
