import 'dart:io';
import 'package:path/path.dart' as path;

import 'codex_chat.dart';
import 'exceptions/codex_exceptions.dart';
import 'models/chat_options.dart';
import 'models/mcp_models.dart';

/// Main Codex SDK class for interacting with OpenAI Codex CLI
class Codex {
  /// The API key for authenticating with OpenAI
  final String apiKey;

  /// List of active chat sessions for cleanup
  final List<CodexChat> _activeSessions = [];

  /// Creates a new Codex SDK instance
  Codex(this.apiKey) {
    if (apiKey.isEmpty) {
      throw CodexSDKException('API key cannot be empty');
    }
  }

  /// Creates a new chat session with Codex
  CodexChat createNewChat({CodexChatOptions? options}) {
    final chat = CodexChat(
      apiKey: apiKey,
      options: options,
    );
    _activeSessions.add(chat);
    return chat;
  }

  /// Checks if Codex CLI is installed
  Future<bool> isCodexCLIInstalled() async {
    try {
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('codex --version'),
      );

      return result.exitCode == 0;
    } catch (e) {
      // If we can't run the command, assume it's not installed
      return false;
    }
  }

  /// Installs the Codex CLI using npm
  Future<void> installCodexCLI({bool global = true}) async {
    // Check if npm is installed first
    final npmInstalled = await _isNpmInstalled();
    if (!npmInstalled) {
      throw CodexSDKException(
        'npm is not installed. Please install Node.js and npm first.\n'
        'Visit https://nodejs.org/ to download and install Node.js.',
      );
    }

    print('Installing Codex CLI...');

    final command = global
        ? 'npm install -g @openai/codex'
        : 'npm install @openai/codex';

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
          'Failed to install Codex CLI',
          exitCode: exitCode,
        );
      }

      print('\nCodex CLI installed successfully!');
    } catch (e) {
      if (e is ProcessException) rethrow;
      throw ProcessException(
        'Failed to install Codex CLI',
        originalError: e,
      );
    }
  }

  /// Updates the Codex CLI to the newest version if needed
  Future<void> updateToNewestVersionIfNeeded({bool global = true}) async {
    // First check if CLI is installed
    final isInstalled = await isCodexCLIInstalled();
    if (!isInstalled) {
      print('Codex CLI is not installed. Installing...');
      await installCodexCLI(global: global);
      return;
    }

    // Check if npm is installed
    final npmInstalled = await _isNpmInstalled();
    if (!npmInstalled) {
      throw CodexSDKException(
        'npm is not installed. Please install Node.js and npm first.\n'
        'Visit https://nodejs.org/ to download and install Node.js.',
      );
    }

    try {
      // Get current installed version
      final currentVersionResult = await Process.run(
        _getShellCommand(),
        _getShellArgs('codex --version'),
      );

      String currentVersion = '';
      if (currentVersionResult.exitCode == 0) {
        // Extract version number from output (e.g., "1.2.3" from "codex 1.2.3")
        final output = currentVersionResult.stdout.toString().trim();
        final versionMatch = RegExp(r'(\d+\.\d+\.\d+)').firstMatch(output);
        if (versionMatch != null) {
          currentVersion = versionMatch.group(1) ?? '';
        }
      }

      // Get latest available version from npm
      final latestVersionResult = await Process.run(
        _getShellCommand(),
        _getShellArgs('npm view @openai/codex version'),
      );

      if (latestVersionResult.exitCode != 0) {
        print('Failed to check for updates.');
        return;
      }

      final latestVersion = latestVersionResult.stdout.toString().trim();

      if (currentVersion.isEmpty) {
        print('Could not determine current version. Reinstalling...');
        await installCodexCLI(global: global);
        return;
      }

      // Compare versions
      if (_isNewerVersion(currentVersion, latestVersion)) {
        print('Updating Codex CLI from v$currentVersion to v$latestVersion...');

        final updateCommand = global
            ? 'npm update -g @openai/codex'
            : 'npm update @openai/codex';

        final process = await Process.start(
          _getShellCommand(),
          _getShellArgs(updateCommand),
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
          print('Update failed. Attempting reinstall...');
          await installCodexCLI(global: global);
        } else {
          print('\nCodex CLI updated successfully to v$latestVersion!');
        }
      } else {
        print('Codex CLI is up to date (v$currentVersion).');
      }
    } catch (e) {
      print('Error checking for updates: $e');
      print('You can manually update with: npm update -g @openai/codex');
    }
  }

  /// Helper method to compare version strings
  bool _isNewerVersion(String current, String latest) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final latestParts = latest.split('.').map(int.parse).toList();

      for (int i = 0; i < 3; i++) {
        final currentPart = i < currentParts.length ? currentParts[i] : 0;
        final latestPart = i < latestParts.length ? latestParts[i] : 0;

        if (latestPart > currentPart) return true;
        if (latestPart < currentPart) return false;
      }

      return false;
    } catch (e) {
      // If version parsing fails, assume update is needed
      return true;
    }
  }

  /// Gets information about the installed SDK
  Future<Map<String, dynamic>> getSDKInfo() async {
    final info = <String, dynamic>{};

    // Check Codex CLI
    info['codexCLI'] = await isCodexCLIInstalled();
    if (info['codexCLI']) {
      try {
        final result = await Process.run(
          _getShellCommand(),
          _getShellArgs('codex --version'),
        );
        if (result.exitCode == 0) {
          info['codexVersion'] = result.stdout.toString().trim();
        }
      } catch (_) {}
    }

    // Check npm
    info['npm'] = await _isNpmInstalled();
    if (info['npm']) {
      try {
        final result = await Process.run(
          _getShellCommand(),
          _getShellArgs('npm --version'),
        );
        if (result.exitCode == 0) {
          info['npmVersion'] = result.stdout.toString().trim();
        }
      } catch (_) {}
    }

    // Check config file
    final configFile = _getConfigFilePath();
    info['configPath'] = configFile.path;
    info['configExists'] = configFile.existsSync();

    return info;
  }

  /// Checks if MCP is installed and configured
  Future<McpInstallationInfo> isMcpInstalled() async {
    try {
      final configFile = _getConfigFilePath();
      if (!configFile.existsSync()) {
        return McpInstallationInfo.notInstalled();
      }

      final configContent = await configFile.readAsString();
      final servers = <McpServer>[];

      // Parse TOML file to extract MCP servers
      // This is a simplified parser - might need a proper TOML library
      final mcpSection = _parseTomlMcpServers(configContent);
      mcpSection.forEach((name, config) {
        servers.add(McpServer.fromJson(name, config));
      });

      return McpInstallationInfo(
        hasMcpSupport: servers.isNotEmpty,
        servers: servers,
        configPath: configFile.path,
      );
    } catch (e) {
      return McpInstallationInfo.notInstalled();
    }
  }

  /// Lists all configured MCP servers
  Future<List<McpServer>> listMcpServers() async {
    final info = await isMcpInstalled();
    return info.servers;
  }

  /// Installs a popular MCP server
  Future<void> installPopularMcpServer(String serverName,
      {Map<String, String>? environment}) async {
    final popularServers = {
      'filesystem': {
        'package': '@modelcontextprotocol/server-filesystem',
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-filesystem'],
      },
      'github': {
        'package': '@modelcontextprotocol/server-github',
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-github'],
        'env': {'GITHUB_TOKEN': environment?['GITHUB_TOKEN'] ?? ''},
      },
      'postgres': {
        'package': '@modelcontextprotocol/server-postgres',
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-postgres'],
        'env': {'DATABASE_URL': environment?['DATABASE_URL'] ?? ''},
      },
      'git': {
        'package': '@modelcontextprotocol/server-git',
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-git'],
      },
      'puppeteer': {
        'package': '@modelcontextprotocol/server-puppeteer',
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-puppeteer'],
      },
      'sequential-thinking': {
        'package': '@modelcontextprotocol/server-sequential-thinking',
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-sequential-thinking'],
      },
      'slack': {
        'package': '@modelcontextprotocol/server-slack',
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-slack'],
        'env': {'SLACK_TOKEN': environment?['SLACK_TOKEN'] ?? ''},
      },
      'google-drive': {
        'package': '@modelcontextprotocol/server-google-drive',
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-google-drive'],
        'env': {
          'GOOGLE_CLIENT_ID': environment?['GOOGLE_CLIENT_ID'] ?? '',
          'GOOGLE_CLIENT_SECRET': environment?['GOOGLE_CLIENT_SECRET'] ?? '',
        },
      },
    };

    final serverConfig = popularServers[serverName];
    if (serverConfig == null) {
      throw CodexSDKException(
        'Unknown popular server: $serverName. Available servers: ${popularServers.keys.join(', ')}',
      );
    }

    // Create MCP server configuration
    final server = McpServer(
      name: serverName,
      command: serverConfig['command'] as String,
      args: serverConfig['args'] as List<String>,
      env: serverConfig['env'] as Map<String, String>?,
    );

    await addMcpServer(serverName, customServer: server);
  }

  /// Adds an MCP server to the configuration
  Future<void> addMcpServer(
    String name, {
    String? packageName,
    McpServer? customServer,
    McpAddOptions? options,
  }) async {
    if (packageName == null && customServer == null) {
      throw CodexSDKException(
        'Either packageName or customServer must be provided',
      );
    }

    final McpServer server;
    if (customServer != null) {
      server = customServer;
    } else {
      // Create server from package name
      final useNpx = options?.useNpx ?? true;
      server = McpServer(
        name: name,
        command: useNpx ? 'npx' : 'node',
        args: useNpx ? ['-y', packageName!] : [packageName!],
        env: options?.environment,
      );
    }

    // Update config file
    await _updateConfigFile((config) {
      config['mcp_servers'] ??= {};
      config['mcp_servers'][name] = server.toJson();
    });

    print('Added MCP server: $name');
  }

  /// Gets details about a specific MCP server
  Future<McpServer?> getMcpServerDetails(String name) async {
    final servers = await listMcpServers();
    try {
      return servers.firstWhere((s) => s.name == name);
    } catch (_) {
      return null;
    }
  }

  /// Removes an MCP server from the configuration
  Future<void> removeMcpServer(String name) async {
    await _updateConfigFile((config) {
      config['mcp_servers']?.remove(name);
    });

    print('Removed MCP server: $name');
  }

  /// Disposes all active chat sessions
  Future<void> dispose() async {
    for (final session in _activeSessions) {
      await session.dispose();
    }
    _activeSessions.clear();
  }

  // Private helper methods

  String _getShellCommand() {
    if (Platform.isWindows) {
      return 'cmd.exe';
    }
    return '/bin/sh';
  }

  List<String> _getShellArgs(String command) {
    if (Platform.isWindows) {
      return ['/c', command];
    }
    return ['-c', command];
  }

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

  File _getConfigFilePath() {
    final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '';
    return File(path.join(home, '.codex', 'config.toml'));
  }

  Map<String, dynamic> _parseTomlMcpServers(String tomlContent) {
    final servers = <String, dynamic>{};
    final lines = tomlContent.split('\n');
    String? currentServer;
    Map<String, dynamic>? currentConfig;

    for (final line in lines) {
      final trimmed = line.trim();

      // Skip comments and empty lines
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      // Check for [mcp_servers.name] section
      final serverMatch = RegExp(r'^\[mcp_servers\.(.+)\]$').firstMatch(trimmed);
      if (serverMatch != null) {
        // Save previous server if exists
        if (currentServer != null && currentConfig != null) {
          servers[currentServer] = currentConfig;
        }

        currentServer = serverMatch.group(1);
        currentConfig = {};
        continue;
      }

      // Parse key-value pairs
      if (currentConfig != null && trimmed.contains('=')) {
        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          var value = parts.sublist(1).join('=').trim();

          // Remove quotes if present
          if (value.startsWith('"') && value.endsWith('"')) {
            value = value.substring(1, value.length - 1);
          }

          // Parse arrays
          if (value.startsWith('[') && value.endsWith(']')) {
            value = value.substring(1, value.length - 1);
            final items = value.split(',').map((s) {
              var item = s.trim();
              if (item.startsWith('"') && item.endsWith('"')) {
                item = item.substring(1, item.length - 1);
              }
              return item;
            }).toList();
            currentConfig[key] = items;
          } else {
            currentConfig[key] = value;
          }
        }
      }
    }

    // Save last server
    if (currentServer != null && currentConfig != null) {
      servers[currentServer] = currentConfig;
    }

    return servers;
  }

  Future<void> _updateConfigFile(void Function(Map<String, dynamic>) updater) async {
    final configFile = _getConfigFilePath();

    // Create directory if it doesn't exist
    if (!configFile.parent.existsSync()) {
      configFile.parent.createSync(recursive: true);
    }

    Map<String, dynamic> config = {};

    // Read existing config if it exists
    if (configFile.existsSync()) {
      final content = await configFile.readAsString();
      // Parse existing TOML - simplified approach
      // In production, use a proper TOML library
      if (content.contains('[mcp_servers')) {
        config['mcp_servers'] = _parseTomlMcpServers(content);
      }
    }

    // Update the config
    updater(config);

    // Write back as TOML
    final buffer = StringBuffer();

    // Write MCP servers section
    if (config['mcp_servers'] != null) {
      final mcpServers = config['mcp_servers'] as Map;
      mcpServers.forEach((name, serverConfig) {
        buffer.writeln('[mcp_servers.$name]');
        if (serverConfig is Map) {
          serverConfig.forEach((key, value) {
            if (value is List) {
              final items = value.map((v) => '"$v"').join(', ');
              buffer.writeln('$key = [$items]');
            } else if (value is Map) {
              // Handle environment variables
              buffer.writeln('$key = {');
              value.forEach((envKey, envValue) {
                buffer.writeln('  $envKey = "$envValue"');
              });
              buffer.writeln('}');
            } else {
              buffer.writeln('$key = "$value"');
            }
          });
        }
        buffer.writeln();
      });
    }

    await configFile.writeAsString(buffer.toString());
  }
}