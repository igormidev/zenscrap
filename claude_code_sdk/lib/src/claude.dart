import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'claude_chat.dart';
import 'exceptions/claude_exceptions.dart';
import 'models/chat_options.dart';
import 'models/mcp_models.dart';

/// Main Claude SDK class for interacting with Claude Code
class Claude {
  /// The API key for authenticating with Claude
  final String apiKey;

  /// List of active chat sessions for cleanup
  final List<ClaudeChat> _activeSessions = [];

  /// Creates a new Claude SDK instance
  Claude(this.apiKey) {
    if (apiKey.isEmpty) {
      throw ClaudeSDKException('API key cannot be empty');
    }
  }

  /// Creates a new chat session with Claude
  ClaudeChat createNewChat({ClaudeChatOptions? options}) {
    final chat = ClaudeChat(
      apiKey: apiKey,
      options: options,
    );
    _activeSessions.add(chat);
    return chat;
  }

  /// Checks if Claude Code SDK is installed
  Future<bool> isClaudeCodeSDKInstalled() async {
    try {
      // Try claude first (the actual command that works)
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('claude --version'),
      );
      
      if (result.exitCode == 0) {
        return true;
      }
      
      // Fallback to claude-code if claude doesn't work
      final result2 = await Process.run(
        _getShellCommand(),
        _getShellArgs('claude-code --version'),
      );
      
      return result2.exitCode == 0;
    } catch (e) {
      // If we can't run the command, assume it's not installed
      return false;
    }
  }

  /// Installs the Claude Code SDK using npm
  Future<void> installClaudeCodeSDK({bool global = true}) async {
    // Check if npm is installed first
    final npmInstalled = await _isNpmInstalled();
    if (!npmInstalled) {
      throw ClaudeSDKException(
        'npm is not installed. Please install Node.js and npm first.\n'
        'Visit https://nodejs.org/ to download and install Node.js.',
      );
    }

    print('Installing Claude Code SDK...');

    final command = global
        ? 'npm install -g @anthropic-ai/claude-code'
        : 'npm install @anthropic-ai/claude-code';

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
          'Failed to install Claude Code SDK',
          exitCode: exitCode,
        );
      }

      print('\nClaude Code SDK installed successfully!');

      // Also check if Python SDK needs to be installed
      await _checkAndInstallPythonSDK();
    } catch (e) {
      throw ProcessException(
        'Failed to install Claude Code SDK: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Checks and installs Python SDK if needed
  Future<void> _checkAndInstallPythonSDK() async {
    print('\nChecking Python SDK...');

    // Check if pip is available
    final pipInstalled = await _isPipInstalled();
    if (!pipInstalled) {
      print('pip is not installed. Python SDK installation skipped.');
      print(
          'To use all features, install Python and pip, then run: pip install claude-code-sdk');
      return;
    }

    // Check if claude-code-sdk is already installed
    final pythonSdkInstalled = await _isPythonSDKInstalled();
    if (pythonSdkInstalled) {
      print('Python SDK is already installed.');
      return;
    }

    print('Installing Python SDK...');

    try {
      final process = await Process.start(
        _getShellCommand(),
        _getShellArgs('pip install claude-code-sdk'),
      );

      process.stdout.listen((data) {
        stdout.write(String.fromCharCodes(data));
      });

      process.stderr.listen((data) {
        stderr.write(String.fromCharCodes(data));
      });

      final exitCode = await process.exitCode;

      if (exitCode != 0) {
        print('Warning: Failed to install Python SDK.');
        print(
            'You can manually install it later with: pip install claude-code-sdk');
      } else {
        print('Python SDK installed successfully!');
      }
    } catch (e) {
      print('Warning: Failed to install Python SDK: $e');
      print(
          'You can manually install it later with: pip install claude-code-sdk');
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

  /// Checks if pip is installed
  Future<bool> _isPipInstalled() async {
    try {
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('pip --version'),
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Checks if Python SDK is installed
  Future<bool> _isPythonSDKInstalled() async {
    try {
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('pip show claude-code-sdk'),
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Gets the appropriate shell command for the platform
  String _getShellCommand() {
    return Platform.isWindows ? 'cmd' : 'sh';
  }

  /// Gets the appropriate shell arguments for the platform
  List<String> _getShellArgs(String command) {
    if (Platform.isWindows) {
      return ['/c', command];
    } else {
      return ['-c', command];
    }
  }

  /// Disposes all active chat sessions
  Future<void> dispose() async {
    for (final session in _activeSessions) {
      if (!session.isDisposed) {
        await session.dispose();
      }
    }
    _activeSessions.clear();
  }

  /// Gets information about the Claude Code SDK installation
  Future<Map<String, dynamic>> getSDKInfo() async {
    final info = <String, dynamic>{};

    // Check Claude Code CLI
    info['claude_cli_installed'] = await isClaudeCodeSDKInstalled();

    if (info['claude_cli_installed'] == true) {
      try {
        final versionResult = await Process.run(
          _getShellCommand(),
          _getShellArgs('claude --version'),
        );
        if (versionResult.exitCode == 0) {
          info['claude_cli_version'] = versionResult.stdout.toString().trim();
        }
      } catch (_) {}
    }

    // Check npm
    info['npm_installed'] = await _isNpmInstalled();
    if (info['npm_installed'] == true) {
      try {
        final npmResult = await Process.run(
          _getShellCommand(),
          _getShellArgs('npm --version'),
        );
        if (npmResult.exitCode == 0) {
          info['npm_version'] = npmResult.stdout.toString().trim();
        }
      } catch (_) {}
    }

    // Check Python SDK
    info['python_sdk_installed'] = await _isPythonSDKInstalled();
    if (info['python_sdk_installed'] == true) {
      try {
        final pythonResult = await Process.run(
          _getShellCommand(),
          _getShellArgs('pip show claude-code-sdk'),
        );
        if (pythonResult.exitCode == 0) {
          final output = pythonResult.stdout.toString();
          final versionMatch = RegExp(r'Version: (.+)').firstMatch(output);
          if (versionMatch != null) {
            info['python_sdk_version'] = versionMatch.group(1)?.trim();
          }
        }
      } catch (_) {}
    }

    // Check pip
    info['pip_installed'] = await _isPipInstalled();

    // Check MCP installation
    try {
      final mcpInfo = await isMcpInstalled();
      info['mcp_enabled'] = mcpInfo.hasMcpSupport;
      info['mcp_servers'] = mcpInfo.servers.length;
      info['mcp_server_list'] = mcpInfo.servers.map((s) => s.name).toList();
    } catch (_) {
      info['mcp_enabled'] = false;
      info['mcp_servers'] = 0;
    }

    return info;
  }

  // ===== MCP (Model Context Protocol) Management Methods =====

  /// Checks if MCP is installed and returns information about configured servers
  Future<McpInstallationInfo> isMcpInstalled() async {
    // Check if Claude CLI is installed
    final isInstalled = await isClaudeCodeSDKInstalled();
    if (!isInstalled) {
      return McpInstallationInfo(
        isClaudeInstalled: false,
        servers: [],
        hasMcpSupport: false,
      );
    }

    // Get Claude version
    String? claudeVersion;
    try {
      final versionResult = await Process.run(
        _getShellCommand(),
        _getShellArgs('claude --version'),
      );
      if (versionResult.exitCode == 0) {
        claudeVersion = versionResult.stdout.toString().trim();
      }
    } catch (_) {}

    // Get list of MCP servers
    final servers = await listMcpServers();

    // Determine config path
    final configPath = _getConfigPath();

    return McpInstallationInfo(
      isClaudeInstalled: true,
      claudeVersion: claudeVersion,
      servers: servers,
      hasMcpSupport: true,
      configPath: configPath,
    );
  }

  /// Lists all configured MCP servers
  Future<List<McpServer>> listMcpServers() async {
    try {
      // Try using claude mcp list command
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('claude mcp list'),
      );

      if (result.exitCode == 0) {
        // Parse the output to extract server information
        final output = result.stdout.toString();
        return _parseMcpListOutput(output);
      }

      // Fallback: read from config file
      return await _readMcpServersFromConfig();
    } catch (e) {
      // If command fails, try reading config file directly
      try {
        return await _readMcpServersFromConfig();
      } catch (_) {
        return [];
      }
    }
  }

  /// Adds an MCP server to the configuration
  Future<void> addMcpServer(
    String name, {
    String? packageName,
    McpAddOptions? options,
    McpServer? customServer,
  }) async {
    if (!await isClaudeCodeSDKInstalled()) {
      throw ClaudeSDKException(
        'Claude Code CLI is not installed. Run installClaudeCodeSDK() first.',
      );
    }

    final opts = options ?? McpAddOptions();

    // If custom server is provided, use it directly
    if (customServer != null) {
      await _addMcpServerViaConfig(customServer);
      return;
    }

    // Check if it's a popular server
    final popularServer = PopularMcpServers.getServer(name);
    if (popularServer != null) {
      await _addMcpServerViaConfig(popularServer.copyWith(name: name));
      return;
    }

    // Otherwise, create a new server with the package name
    if (packageName == null) {
      throw ClaudeSDKException(
        'Package name is required for non-popular MCP servers',
      );
    }

    // Build the command and args
    String command;
    List<String> args;

    if (opts.useNpx) {
      if (Platform.isWindows && opts.windowsCmdWrapper) {
        command = 'cmd';
        args = ['/c', 'npx'];
        if (opts.npxAutoYes) args.add('-y');
        args.add(packageName);
      } else {
        command = 'npx';
        args = [];
        if (opts.npxAutoYes) args.add('-y');
        args.add(packageName);
      }
    } else {
      command = packageName;
      args = [];
    }

    if (opts.additionalArgs != null) {
      args.addAll(opts.additionalArgs!);
    }

    final server = McpServer(
      name: name,
      command: command,
      args: args,
      env: opts.environment,
    );

    await _addMcpServerViaConfig(server);
  }

  /// Removes an MCP server from the configuration
  Future<void> removeMcpServer(String name) async {
    if (!await isClaudeCodeSDKInstalled()) {
      throw ClaudeSDKException(
        'Claude Code CLI is not installed.',
      );
    }

    // Try using CLI command first
    try {
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('claude mcp remove $name'),
      );

      if (result.exitCode == 0) {
        print('MCP server "$name" removed successfully');
        return;
      }
    } catch (_) {}

    // Fallback: modify config file directly
    await _removeMcpServerViaConfig(name);
  }

  /// Gets details about a specific MCP server
  Future<McpServer?> getMcpServerDetails(String name) async {
    final servers = await listMcpServers();
    return servers.firstWhere(
      (s) => s.name == name,
      orElse: () => throw ClaudeSDKException('MCP server "$name" not found'),
    );
  }

  /// Gets a list of popular MCP servers that can be easily installed
  List<String> getPopularMcpServers() {
    return PopularMcpServers.availableServers;
  }

  /// Installs a popular MCP server by name
  Future<void> installPopularMcpServer(
    String serverName, {
    Map<String, String>? environment,
  }) async {
    final server = PopularMcpServers.getServer(serverName);
    if (server == null) {
      throw ClaudeSDKException(
        'Unknown popular server: $serverName. '
        'Available servers: ${PopularMcpServers.availableServers.join(", ")}',
      );
    }

    // Merge environment variables if provided
    final finalServer = environment != null
        ? server.copyWith(
            env: {...?server.env, ...environment},
          )
        : server;

    await addMcpServer(
      serverName,
      customServer: finalServer,
    );

    print('Installed popular MCP server: $serverName');
    if (server.env != null && server.env!.isNotEmpty) {
      final missingEnvVars = server.env!.entries
          .where((e) => environment?[e.key] == null || environment![e.key]!.isEmpty)
          .map((e) => e.key)
          .toList();

      if (missingEnvVars.isNotEmpty) {
        print('\nNote: The following environment variables need to be configured:');
        for (final envVar in missingEnvVars) {
          print('  - $envVar');
        }
        print('\nEdit the configuration file at ${_getConfigPath()} to add these values.');
      }
    }
  }

  // ===== Private MCP Helper Methods =====

  /// Gets the configuration file path
  String _getConfigPath() {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home == null) {
      throw ClaudeSDKException('Could not determine home directory');
    }
    return path.join(home, '.claude', '.claude.json');
  }

  /// Reads MCP servers from the configuration file
  Future<List<McpServer>> _readMcpServersFromConfig() async {
    final configPath = _getConfigPath();
    final configFile = File(configPath);

    if (!await configFile.exists()) {
      return [];
    }

    try {
      final content = await configFile.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final config = McpConfig.fromJson(json);
      return config.serverList;
    } catch (e) {
      print('Error reading MCP config: $e');
      return [];
    }
  }

  /// Adds an MCP server by modifying the config file
  Future<void> _addMcpServerViaConfig(McpServer server) async {
    final configPath = _getConfigPath();
    final configFile = File(configPath);

    // Ensure directory exists
    final configDir = File(configPath).parent;
    if (!await configDir.exists()) {
      await configDir.create(recursive: true);
    }

    // Read existing config or create new one
    Map<String, dynamic> configJson;
    if (await configFile.exists()) {
      final content = await configFile.readAsString();
      configJson = jsonDecode(content) as Map<String, dynamic>;
    } else {
      configJson = {};
    }

    // Add or update the MCP server
    configJson['mcpServers'] ??= <String, dynamic>{};
    final mcpServers = configJson['mcpServers'] as Map<String, dynamic>;
    mcpServers[server.name] = server.toJson();

    // Write back to file
    final encoder = JsonEncoder.withIndent('  ');
    await configFile.writeAsString(encoder.convert(configJson));

    print('MCP server "${server.name}" added successfully');
    print('Configuration saved to: $configPath');
  }

  /// Removes an MCP server by modifying the config file
  Future<void> _removeMcpServerViaConfig(String name) async {
    final configPath = _getConfigPath();
    final configFile = File(configPath);

    if (!await configFile.exists()) {
      throw ClaudeSDKException('Configuration file not found');
    }

    final content = await configFile.readAsString();
    final configJson = jsonDecode(content) as Map<String, dynamic>;

    final mcpServers = configJson['mcpServers'] as Map<String, dynamic>?;
    if (mcpServers == null || !mcpServers.containsKey(name)) {
      throw ClaudeSDKException('MCP server "$name" not found in configuration');
    }

    mcpServers.remove(name);

    // Write back to file
    final encoder = JsonEncoder.withIndent('  ');
    await configFile.writeAsString(encoder.convert(configJson));

    print('MCP server "$name" removed successfully');
  }

  /// Parses the output of 'claude mcp list' command
  List<McpServer> _parseMcpListOutput(String output) {
    final servers = <McpServer>[];
    final lines = output.split('\n');

    for (final line in lines) {
      // Look for patterns like "• server-name: connected" or "• server-name: disconnected"
      final match = RegExp(r'•\s+(\S+):\s+(\w+)').firstMatch(line);
      if (match != null) {
        final name = match.group(1)!;
        final statusStr = match.group(2)!.toLowerCase();

        McpServerStatus status;
        switch (statusStr) {
          case 'connected':
            status = McpServerStatus.connected;
            break;
          case 'disconnected':
            status = McpServerStatus.disconnected;
            break;
          case 'error':
            status = McpServerStatus.error;
            break;
          default:
            status = McpServerStatus.unknown;
        }

        servers.add(McpServer(
          name: name,
          command: '',  // Will be filled from config if needed
          args: [],
          status: status,
        ));
      }
    }

    // If we found servers from the list, try to get their full config
    if (servers.isNotEmpty) {
      _enrichServersWithConfig(servers);
    }

    return servers;
  }

  /// Enriches server list with configuration details
  Future<void> _enrichServersWithConfig(List<McpServer> servers) async {
    try {
      final configServers = await _readMcpServersFromConfig();
      for (var i = 0; i < servers.length; i++) {
        final server = servers[i];
        final configServer = configServers.firstWhere(
          (s) => s.name == server.name,
          orElse: () => server,
        );
        if (configServer != server) {
          servers[i] = configServer.copyWith(status: server.status);
        }
      }
    } catch (_) {
      // Ignore errors, we'll use the basic info we have
    }
  }
}