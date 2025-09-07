import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'gemini_chat.dart';
import 'exceptions/gemini_exceptions.dart';
import 'models/chat_options.dart';
import 'models/mcp_models.dart';

/// Main Gemini SDK class for interacting with Gemini CLI
class GeminiSDK {
  /// The API key for authenticating with Gemini
  final String apiKey;

  /// List of active chat sessions for cleanup
  final List<GeminiChat> _activeSessions = [];

  /// Creates a new Gemini SDK instance
  GeminiSDK(this.apiKey) {
    if (apiKey.isEmpty) {
      throw GeminiSDKException('API key cannot be empty');
    }
  }

  /// Creates a new chat session with Gemini
  GeminiChat createNewChat({GeminiChatOptions? options}) {
    final chat = GeminiChat(
      apiKey: apiKey,
      options: options,
    );
    _activeSessions.add(chat);
    return chat;
  }

  /// Checks if Gemini CLI is installed
  Future<bool> isGeminiCLIInstalled() async {
    try {
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('gemini --version'),
      );
      
      return result.exitCode == 0;
    } catch (e) {
      // If we can't run the command, assume it's not installed
      return false;
    }
  }

  /// Checks if Gemini SDK (CLI) is installed
  /// This is an alias for isGeminiCLIInstalled() for consistency
  Future<bool> isGeminiSDKInstalled() async {
    return isGeminiCLIInstalled();
  }

  /// Installs the Gemini SDK (CLI) using npm
  /// This is an alias for installGeminiCLI() for consistency
  Future<void> installGeminiSDK({bool global = true}) async {
    return installGeminiCLI(global: global);
  }

  /// Installs the Gemini CLI using npm
  Future<void> installGeminiCLI({bool global = true}) async {
    // Check if npm is installed first
    final npmInstalled = await _isNpmInstalled();
    if (!npmInstalled) {
      throw GeminiSDKException(
        'npm is not installed. Please install Node.js and npm first.\n'
        'Visit https://nodejs.org/ to download and install Node.js.',
      );
    }

    print('Installing Gemini CLI...');

    final command = global
        ? 'npm install -g @google/gemini-cli'
        : 'npm install @google/gemini-cli';

    try {
      final process = await Process.start(
        _getShellCommand(),
        _getShellArgs(command),
      );

      // Stream output to console
      process.stdout.listen((data) {
        stdout.write(String.fromCharCodes(data));
      });

      process.stderr.listen((data) {
        stderr.write(String.fromCharCodes(data));
      });

      final exitCode = await process.exitCode;

      if (exitCode != 0) {
        throw ProcessException(
          'Failed to install Gemini CLI',
          exitCode: exitCode,
        );
      }

      print('\nGemini CLI installed successfully!');
    } catch (e) {
      throw ProcessException(
        'Failed to install Gemini CLI: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Gets information about installed Gemini CLI
  Future<Map<String, dynamic>> getSDKInfo() async {
    final info = <String, dynamic>{};

    // Check if Gemini CLI is installed
    info['geminiCLI'] = await isGeminiCLIInstalled();

    if (info['geminiCLI']) {
      try {
        // Get version
        final versionResult = await Process.run(
          _getShellCommand(),
          _getShellArgs('gemini --version'),
        );
        
        if (versionResult.exitCode == 0) {
          info['version'] = versionResult.stdout.toString().trim();
        }
      } catch (e) {
        info['version'] = 'unknown';
      }
    }

    // Check MCP status
    final mcpInfo = await isMcpInstalled();
    info['mcp'] = {
      'enabled': mcpInfo.hasMcpSupport,
      'servers': mcpInfo.servers.length,
      'configPath': mcpInfo.configPath,
    };

    return info;
  }

  /// Checks if MCP is installed and configured
  Future<McpInstallationInfo> isMcpInstalled() async {
    try {
      final homeDir = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
      if (homeDir == null) {
        return const McpInstallationInfo(
          hasMcpSupport: false,
          servers: [],
        );
      }

      final configPath = path.join(homeDir, '.gemini', 'settings.json');
      final configFile = File(configPath);

      if (!await configFile.exists()) {
        return McpInstallationInfo(
          hasMcpSupport: false,
          servers: [],
          configPath: configPath,
        );
      }

      final configContent = await configFile.readAsString();
      final config = jsonDecode(configContent) as Map<String, dynamic>;

      final servers = <McpServerStatus>[];
      
      if (config['mcpServers'] != null) {
        final mcpServers = config['mcpServers'] as Map<String, dynamic>;
        for (final entry in mcpServers.entries) {
          servers.add(McpServerStatus(
            name: entry.key,
            status: 'configured',
          ));
        }
      }

      return McpInstallationInfo(
        hasMcpSupport: servers.isNotEmpty,
        servers: servers,
        configPath: configPath,
      );
    } catch (e) {
      return const McpInstallationInfo(
        hasMcpSupport: false,
        servers: [],
      );
    }
  }

  /// Installs a popular MCP server
  Future<void> installPopularMcpServer(String serverName, {
    Map<String, String>? environment,
  }) async {
    final serverConfig = PopularMcpServers.getServer(serverName);
    if (serverConfig == null) {
      throw GeminiSDKException(
        'Unknown popular server: $serverName\n'
        'Available servers: ${PopularMcpServers.list().join(', ')}',
      );
    }

    // Check required environment variables
    if (serverConfig['requiredEnv'] != null) {
      final requiredEnv = serverConfig['requiredEnv'] as List<dynamic>;
      final missingEnv = <String>[];
      
      for (final envVar in requiredEnv) {
        if (environment?[envVar] == null && Platform.environment[envVar] == null) {
          missingEnv.add(envVar as String);
        }
      }
      
      if (missingEnv.isNotEmpty) {
        throw GeminiSDKException(
          'Missing required environment variables for $serverName: ${missingEnv.join(', ')}\n'
          'Please provide them in the environment parameter.',
        );
      }
    }

    // Create MCP server configuration
    final server = McpServer(
      name: serverName,
      command: serverConfig['command'] as String,
      args: List<String>.from(serverConfig['args'] as List),
      env: environment,
    );

    await addMcpServer(serverName, customServer: server);
    
    print('Successfully installed $serverName MCP server');
  }

  /// Adds an MCP server to the configuration
  Future<void> addMcpServer(String name, {
    String? packageName,
    McpServer? customServer,
    McpAddOptions? options,
  }) async {
    if (packageName == null && customServer == null) {
      throw GeminiSDKException(
        'Either packageName or customServer must be provided',
      );
    }

    final opts = options ?? const McpAddOptions();
    
    // Determine config path based on scope
    final homeDir = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (homeDir == null) {
      throw GeminiSDKException('Could not determine home directory');
    }

    final configPath = opts.scope == McpScope.user
        ? path.join(homeDir, '.gemini', 'settings.json')
        : path.join(Directory.current.path, '.gemini', 'settings.json');

    // Create directory if it doesn't exist
    final configDir = Directory(path.dirname(configPath));
    if (!await configDir.exists()) {
      await configDir.create(recursive: true);
    }

    // Load existing config or create new one
    Map<String, dynamic> config = {};
    final configFile = File(configPath);
    
    if (await configFile.exists()) {
      final content = await configFile.readAsString();
      config = jsonDecode(content) as Map<String, dynamic>;
    }

    // Ensure mcpServers exists
    config['mcpServers'] ??= <String, dynamic>{};
    final mcpServers = config['mcpServers'] as Map<String, dynamic>;

    // Add the server
    if (customServer != null) {
      mcpServers[name] = customServer.toJson();
    } else if (packageName != null) {
      // Create server from npm package
      final server = McpServer(
        name: name,
        command: opts.useNpx ? 'npx' : 'node',
        args: opts.useNpx ? ['-y', packageName] : [packageName],
        env: opts.environment,
      );
      mcpServers[name] = server.toJson();
    }

    // Save the updated config
    await configFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(config),
    );

    print('Added MCP server "$name" to ${opts.scope.name} configuration');
  }

  /// Lists all configured MCP servers
  Future<List<McpServer>> listMcpServers() async {
    final mcpInfo = await isMcpInstalled();
    
    if (!mcpInfo.hasMcpSupport || mcpInfo.configPath == null) {
      return [];
    }

    try {
      final configFile = File(mcpInfo.configPath!);
      final configContent = await configFile.readAsString();
      final config = jsonDecode(configContent) as Map<String, dynamic>;

      if (config['mcpServers'] == null) {
        return [];
      }

      final mcpServers = config['mcpServers'] as Map<String, dynamic>;
      final servers = <McpServer>[];

      for (final entry in mcpServers.entries) {
        servers.add(McpServer.fromJson({
          'name': entry.key,
          ...entry.value as Map<String, dynamic>,
        }));
      }

      return servers;
    } catch (e) {
      throw GeminiSDKException('Failed to list MCP servers: $e');
    }
  }

  /// Gets details about a specific MCP server
  Future<McpServer?> getMcpServerDetails(String name) async {
    final servers = await listMcpServers();
    
    try {
      return servers.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Removes an MCP server from the configuration
  Future<void> removeMcpServer(String name) async {
    final homeDir = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (homeDir == null) {
      throw GeminiSDKException('Could not determine home directory');
    }

    // Try both user and project scope
    final userConfigPath = path.join(homeDir, '.gemini', 'settings.json');
    final projectConfigPath = path.join(Directory.current.path, '.gemini', 'settings.json');

    bool removed = false;

    for (final configPath in [userConfigPath, projectConfigPath]) {
      final configFile = File(configPath);
      
      if (await configFile.exists()) {
        final content = await configFile.readAsString();
        final config = jsonDecode(content) as Map<String, dynamic>;

        if (config['mcpServers'] != null) {
          final mcpServers = config['mcpServers'] as Map<String, dynamic>;
          
          if (mcpServers.containsKey(name)) {
            mcpServers.remove(name);
            
            await configFile.writeAsString(
              const JsonEncoder.withIndent('  ').convert(config),
            );
            
            removed = true;
            print('Removed MCP server "$name" from configuration');
          }
        }
      }
    }

    if (!removed) {
      throw GeminiSDKException('MCP server "$name" not found in configuration');
    }
  }

  /// Checks if npm is installed
  Future<bool> _isNpmInstalled() async {
    try {
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('npm --version'),
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Gets the appropriate shell command for the platform
  String _getShellCommand() {
    if (Platform.isWindows) {
      return 'cmd.exe';
    }
    return 'sh';
  }

  /// Gets the appropriate shell arguments for the platform
  List<String> _getShellArgs(String command) {
    if (Platform.isWindows) {
      return ['/c', command];
    }
    return ['-c', command];
  }

  /// Disposes all active chat sessions
  Future<void> dispose() async {
    for (final session in _activeSessions) {
      await session.dispose();
    }
    _activeSessions.clear();
  }
}