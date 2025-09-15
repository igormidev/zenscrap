import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart' as gemini;
import 'package:claude_code_sdk/claude_code_sdk.dart' as claude;
import 'package:codex_cli_sdk/codex_cli_sdk.dart' as codex;
import 'puppeteer_setup.dart';

/// Abstract adapter for MCP setup across different SDKs
abstract class McpAdapter {
  Future<bool> isMcpInstalled();
  Future<bool> hasServer(String serverName);
  Future<void> addMcpServer(String name, {
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
  Future<void> addMcpServer(String name, {
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
  Future<void> addMcpServer(String name, {
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
  Future<void> addMcpServer(String name, {
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

/// Unified Puppeteer setup that works with any SDK via adapter
class UnifiedPuppeteerSetup {
  static UnifiedPuppeteerSetup? _instance;
  UnifiedPuppeteerSetup._();
  static UnifiedPuppeteerSetup get instance => _instance ??= UnifiedPuppeteerSetup._();

  /// Sets up Puppeteer MCP for any SDK using the adapter pattern
  Future<void> setupWithAdapter(
    McpAdapter adapter, {
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
      final hasServer = await adapter.hasServer('puppeteer');

      if (!hasServer) {
        print('⚙️ Configuring MCP Puppeteer server...');
        await _configureMcpPuppeteer(adapter);
        print('✅ MCP Puppeteer server configured successfully\n');
      } else {
        print('✅ MCP Puppeteer server is already configured\n');
      }

      if (proxyConfig != null) {
        print('ℹ️ Proxy configuration is now handled dynamically by the AI\n');
        print('   The AI will pass proxy settings through launchOptions when needed.\n');
      }

      print('🎉 Puppeteer setup complete! Ready for web scraping.\n');
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

  Future<bool> _isPuppeteerInstalled() async {
    try {
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

  Future<void> _configureMcpPuppeteer(McpAdapter adapter) async {
    // Check if we have global installation
    final globalCheck = await Process.run(
      Platform.isWindows ? 'cmd.exe' : 'sh',
      Platform.isWindows
          ? ['/c', 'where @modelcontextprotocol/server-puppeteer']
          : ['-c', 'which @modelcontextprotocol/server-puppeteer'],
    );

    String command;
    List<String> args;

    if (globalCheck.exitCode == 0) {
      // Use global installation
      command = 'npx';
      args = ['-y', '@modelcontextprotocol/server-puppeteer'];
    } else {
      // Use local installation
      command = 'node';
      args = [
        path.join(
          Directory.current.path,
          'node_modules',
          '@modelcontextprotocol',
          'server-puppeteer',
          'dist',
          'index.js',
        ),
      ];
    }

    await adapter.addMcpServer(
      'puppeteer',
      command: command,
      args: args,
    );
  }
}

/// Unified ScrapingBee MCP setup that works with any SDK via adapter
class UnifiedScrapingBeeSetup {
  static UnifiedScrapingBeeSetup? _instance;
  UnifiedScrapingBeeSetup._();
  static UnifiedScrapingBeeSetup get instance => _instance ??= UnifiedScrapingBeeSetup._();

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
    final projectRoot = Directory.current.path;
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

    // Compile the Dart script to an executable
    final result = await Process.run(
      'dart',
      [
        'compile',
        'exe',
        path.join(
          projectRoot,
          'web_scrapper_generator',
          'lib',
          'src',
          'scraping_bee_mcp.dart',
        ),
        '-o',
        serverExePath,
      ],
      workingDirectory: projectRoot,
    );

    if (result.exitCode != 0) {
      throw Exception(
        'Failed to compile ScrapingBee MCP server:\n${result.stderr}',
      );
    }

    print('  ✅ ScrapingBee MCP server compiled successfully');
  }

  Future<void> _configureMcpScrapingBee(McpAdapter adapter) async {
    final serverExePath = path.join(
      Directory.current.path,
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