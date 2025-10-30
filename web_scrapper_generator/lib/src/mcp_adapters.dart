import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart' as gemini;
import 'package:claude_code_sdk/claude_code_sdk.dart' as claude;
import 'package:codex_cli_sdk/codex_cli_sdk.dart' as codex;
import 'playwright_setup.dart';

/// Abstract adapter for MCP setup across different SDKs
abstract class McpAdapter {
  Future<bool> isMcpInstalled();
  Future<bool> hasServer(String serverName);
  Future<void> addMcpServer(
    String name, {
    required String command,
    required List<String> args,
    Map<String, String>? env,
  });
}

/// Gemini SDK adapter for MCP
class GeminiMcpAdapter implements McpAdapter {
  final gemini.GeminiSDK sdk;

  GeminiMcpAdapter(this.sdk);

  @override
  Future<bool> isMcpInstalled() async {
    final info = await sdk.isMcpInstalled();
    return info.hasMcpSupport;
  }

  @override
  Future<bool> hasServer(String serverName) async {
    final servers = await sdk.listMcpServers();
    return servers.any((s) => s.name == serverName);
  }

  @override
  Future<void> addMcpServer(
    String name, {
    required String command,
    required List<String> args,
    Map<String, String>? env,
  }) async {
    final server = gemini.McpServer(
      name: name,
      command: command,
      args: args,
      env: env,
    );
    await sdk.addMcpServer(name, customServer: server);
  }
}

/// Claude SDK adapter for MCP
class ClaudeMcpAdapter implements McpAdapter {
  final claude.Claude sdk;

  ClaudeMcpAdapter(this.sdk);

  @override
  Future<bool> isMcpInstalled() async {
    final info = await sdk.isMcpInstalled();
    return info.hasMcpSupport;
  }

  @override
  Future<bool> hasServer(String serverName) async {
    final servers = await sdk.listMcpServers();
    return servers.any((s) => s.name == serverName);
  }

  @override
  Future<void> addMcpServer(
    String name, {
    required String command,
    required List<String> args,
    Map<String, String>? env,
  }) async {
    final server = claude.McpServer(
      name: name,
      command: command,
      args: args,
      env: env,
    );
    await sdk.addMcpServer(name, customServer: server);
  }
}

/// Codex SDK adapter for MCP
class CodexMcpAdapter implements McpAdapter {
  final codex.Codex sdk;

  CodexMcpAdapter(this.sdk);

  @override
  Future<bool> isMcpInstalled() async {
    final info = await sdk.isMcpInstalled();
    return info.hasMcpSupport;
  }

  @override
  Future<bool> hasServer(String serverName) async {
    final servers = await sdk.listMcpServers();
    return servers.any((s) => s.name == serverName);
  }

  @override
  Future<void> addMcpServer(
    String name, {
    required String command,
    required List<String> args,
    Map<String, String>? env,
  }) async {
    final server = codex.McpServer(
      name: name,
      command: command,
      args: args,
      env: env,
    );
    await sdk.addMcpServer(name, customServer: server);
  }
}

/// Unified Playwright setup that works with any SDK via adapter
class UnifiedPlaywrightSetup {
  static UnifiedPlaywrightSetup? _instance;
  UnifiedPlaywrightSetup._();
  static UnifiedPlaywrightSetup get instance =>
      _instance ??= UnifiedPlaywrightSetup._();

  /// Sets up Playwright MCP for any SDK using the adapter pattern
  Future<void> setupWithAdapter(
    McpAdapter adapter, {
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
      final hasServer = await adapter.hasServer('playwright');

      if (!hasServer) {
        print('⚙️ Configuring MCP Playwright server...');
        await _configureMcpPlaywright(adapter);
        print('✅ MCP Playwright server configured successfully\n');
      } else {
        print('✅ MCP Playwright server is already configured\n');
      }

      if (proxyConfig != null) {
        print('ℹ️ Proxy configuration is now handled dynamically by the AI\n');
        print(
          '   The AI will pass proxy settings through launchOptions when needed.\n',
        );
      }

      print('🎉 Playwright setup complete! Ready for web scraping.\n');
    } catch (e) {
      print('❌ Setup failed: $e');
      rethrow;
    }
  }

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

  Future<bool> _isPlaywrightInstalled() async {
    try {
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

  Future<void> _configureMcpPlaywright(McpAdapter adapter) async {
    // Use the official Microsoft Playwright MCP
    // Include NODE_PATH so it can find locally installed playwright
    await adapter.addMcpServer(
      'playwright',
      command: 'npx',
      args: ['@playwright/mcp@latest', '--headless'],
      env: {'NODE_PATH': path.join(Directory.current.path, 'node_modules')},
    );
  }
}

/// Unified ScrapingBee MCP setup that works with any SDK via adapter
class UnifiedScrapingBeeSetup {
  static UnifiedScrapingBeeSetup? _instance;
  UnifiedScrapingBeeSetup._();
  static UnifiedScrapingBeeSetup get instance =>
      _instance ??= UnifiedScrapingBeeSetup._();

  /// Sets up ScrapingBee MCP for any SDK using the adapter pattern
  Future<void> setupWithAdapter(McpAdapter adapter) async {
    print('🐝 Setting up ScrapingBee MCP server...\n');

    try {
      // Step 1: Check if MCP server is already configured
      print('🔌 Checking ScrapingBee MCP server configuration...');
      final hasServer = await adapter.hasServer('scraping-bee-mcp');

      if (!hasServer) {
        print('⚙️ Configuring ScrapingBee MCP server...');

        // Step 2: Compile the server executable if needed
        await _compileServerIfNeeded();

        // Step 3: Configure the MCP server
        await _configureMcpScrapingBee(adapter);
        print('✅ ScrapingBee MCP server configured successfully\n');
      } else {
        print('✅ ScrapingBee MCP server is already configured\n');
      }

      print('🎉 ScrapingBee MCP setup complete!\n');
    } catch (e) {
      print('❌ ScrapingBee MCP setup failed: $e');
      rethrow;
    }
  }

  Future<void> _compileServerIfNeeded() async {
    // Find the web_scrapper_generator package root
    final webScrapperGenPath = _findWebScrapperGeneratorPath();

    // Place the executable in the project root's build directory
    final projectRoot = _findProjectRoot();
    final serverExePath = path.join(
      projectRoot,
      'build',
      'scraping_bee_mcp_server',
    );

    // Check if executable already exists
    if (File(serverExePath).existsSync()) {
      print('  ScrapingBee MCP server executable already exists');
      return;
    }

    print('  Compiling ScrapingBee MCP server...');

    // Create build directory if it doesn't exist
    final buildDir = Directory(path.join(projectRoot, 'build'));
    if (!buildDir.existsSync()) {
      buildDir.createSync(recursive: true);
    }

    // Compile the Dart script to an executable using the bin entry point
    final serverSourcePath = path.join(
      webScrapperGenPath,
      'bin',
      'scraping_bee_mcp_server.dart',
    );

    final result = await Process.run('dart', [
      'compile',
      'exe',
      serverSourcePath,
      '-o',
      serverExePath,
    ], workingDirectory: webScrapperGenPath);

    if (result.exitCode != 0) {
      throw Exception(
        'Failed to compile ScrapingBee MCP server:\n${result.stderr}',
      );
    }

    print('  ✅ ScrapingBee MCP server compiled successfully');
  }

  /// Find the web_scrapper_generator package root directory
  String _findWebScrapperGeneratorPath() {
    // Start from current directory and search upwards for the monorepo root
    var current = Directory.current;

    // First, find the project root (where zenscrap lives)
    while (current.path != current.parent.path) {
      final webScrapperGenDir = Directory(
        path.join(current.path, 'web_scrapper_generator'),
      );
      if (webScrapperGenDir.existsSync()) {
        final pubspecFile = File(
          path.join(webScrapperGenDir.path, 'pubspec.yaml'),
        );
        if (pubspecFile.existsSync()) {
          return webScrapperGenDir.path;
        }
      }
      current = current.parent;
    }

    throw Exception(
      'Could not find web_scrapper_generator package. '
      'Make sure you are running from within the zenscrap project.',
    );
  }

  /// Find the project root directory (where build/ should be placed)
  String _findProjectRoot() {
    var current = Directory.current;

    while (current.path != current.parent.path) {
      // Check if this directory contains web_scrapper_generator
      final webScrapperGenDir = Directory(
        path.join(current.path, 'web_scrapper_generator'),
      );
      if (webScrapperGenDir.existsSync()) {
        return current.path;
      }
      current = current.parent;
    }

    // Fallback to current directory
    return Directory.current.path;
  }

  Future<void> _configureMcpScrapingBee(McpAdapter adapter) async {
    final projectRoot = _findProjectRoot();
    final serverExePath = path.join(
      projectRoot,
      'build',
      'scraping_bee_mcp_server',
    );

    await adapter.addMcpServer(
      'scraping-bee-mcp',
      command: serverExePath,
      args: [],
    );
  }
}
