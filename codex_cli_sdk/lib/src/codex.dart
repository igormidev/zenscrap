import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';

import 'codex_chat.dart';
import 'codex_chat_options.dart';

/// Main Codex SDK class for interacting with the OpenAI Codex CLI.
class Codex extends CodingCliInterface<CodexChat, CodexChatOptions> {
  Codex({this.apiKey});

  /// Optional default API key for authenticating with OpenAI Codex CLI.
  /// If not provided, assumes the CLI is already configured via login or environment.
  final String? apiKey;

  @override
  CodexChat createNewChat({CodexChatOptions? options, String? apiKey}) {
    // Use chat-specific apiKey if provided, otherwise use SDK's default
    final effectiveApiKey = apiKey ?? this.apiKey;
    final chat = CodexChat(apiKey: effectiveApiKey, options: options);
    activeSessions.add(chat);
    return chat;
  }

  @override
  Future<bool> isCodexCLIInstalled() async {
    try {
      final result = await Process.run(
        _shellCommand,
        _shellArgs('codex --version'),
      );
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> installCodexCLI({bool global = true}) async {
    if (!await _isNpmInstalled()) {
      throw CliException(
        'npm is not installed. Please install Node.js and npm first.\n'
        'Visit https://nodejs.org/ to download the installer.',
      );
    }

    print('Installing Codex CLI...');
    final command =
        global ? 'npm install -g @openai/codex' : 'npm install @openai/codex';

    final process = await Process.start(
      _shellCommand,
      _shellArgs(command),
      mode: ProcessStartMode.inheritStdio,
    );

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw CliException('Failed to install Codex CLI (exit code $exitCode).');
    }

    print('\nCodex CLI installed successfully!');
  }

  @override
  Future<void> updateToNewestVersionIfNeeded({bool global = true}) async {
    final isInstalled = await isCodexCLIInstalled();
    if (!isInstalled) {
      print('Codex CLI is not installed. Installing...');
      await installCodexCLI(global: global);
      return;
    }

    if (!await _isNpmInstalled()) {
      throw CliException(
        'npm is not installed. Please install Node.js and npm first.\n'
        'Visit https://nodejs.org/ to download the installer.',
      );
    }

    try {
      final currentVersionResult = await Process.run(
        _shellCommand,
        _shellArgs('codex --version'),
      );

      String currentVersion = '';
      if (currentVersionResult.exitCode == 0) {
        final output = currentVersionResult.stdout.toString().trim();
        final versionMatch = RegExp(r'(\d+\.\d+\.\d+)').firstMatch(output);
        if (versionMatch != null) {
          currentVersion = versionMatch.group(1) ?? '';
        }
      }

      final latestVersionResult = await Process.run(
        _shellCommand,
        _shellArgs('npm view @openai/codex version'),
      );

      if (latestVersionResult.exitCode != 0) {
        print('Failed to check for Codex updates.');
        return;
      }

      final latestVersion = latestVersionResult.stdout.toString().trim();
      if (currentVersion.isEmpty) {
        print('Could not determine current Codex version. Reinstalling...');
        await installCodexCLI(global: global);
        return;
      }

      if (_isNewerVersion(currentVersion, latestVersion)) {
        print('Updating Codex CLI from v$currentVersion to v$latestVersion...');
        final updateCommand =
            global ? 'npm update -g @openai/codex' : 'npm update @openai/codex';

        final process = await Process.start(
          _shellCommand,
          _shellArgs(updateCommand),
          mode: ProcessStartMode.inheritStdio,
        );

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
    } catch (error) {
      print('Error checking for Codex updates: $error');
      print('You can manually update with: npm update -g @openai/codex');
    }
  }

  @override
  Future<Map<String, dynamic>> getSDKInfo() async {
    final info = <String, dynamic>{};

    info['codexCLIInstalled'] = await isCodexCLIInstalled();
    if (info['codexCLIInstalled'] == true) {
      try {
        final result = await Process.run(
          _shellCommand,
          _shellArgs('codex --version'),
        );
        if (result.exitCode == 0) {
          info['codexVersion'] = result.stdout.toString().trim();
        }
      } catch (_) {}
    }

    info['npmInstalled'] = await _isNpmInstalled();
    if (info['npmInstalled'] == true) {
      try {
        final result = await Process.run(
          _shellCommand,
          _shellArgs('npm --version'),
        );
        if (result.exitCode == 0) {
          info['npmVersion'] = result.stdout.toString().trim();
        }
      } catch (_) {}
    }

    final configFile = _configFilePath;
    info['configPath'] = configFile.path;
    info['configExists'] = configFile.existsSync();

    return info;
  }

  @override
  Future<void> addApiKeyToEnvironment(String apiKey) async {
    // Since Codex >= 0.36.0, we use stdin login instead of env vars
    // This method now performs a login to make the API key available system-wide
    final loginProc = await Process.start(
      'codex',
      ['login', '--with-api-key'],
    );

    // Write API key to stdin
    loginProc.stdin
      ..write(apiKey)
      ..close();

    final exitCode = await loginProc.exitCode;
    if (exitCode != 0) {
      final stderr = await loginProc.stderr.transform(utf8.decoder).join();
      throw CliException(
        'Failed to login to Codex CLI. Exit code $exitCode. Error: $stderr',
      );
    }
  }

  /// Disposes all active chat sessions created by this SDK instance.
  Future<void> dispose() async {
    for (final session in activeSessions) {
      await session.dispose();
    }
    activeSessions.clear();
  }

  /// Checks if MCP support is configured and returns its details.
  Future<McpInstallationInfo> isMcpInstalled() async {
    try {
      final configFile = _configFilePath;
      if (!configFile.existsSync()) {
        return McpInstallationInfo.notInstalled();
      }

      final configContent = await configFile.readAsString();
      final servers = <McpServer>[];
      final mcpSection = _parseTomlMcpServers(configContent);
      mcpSection.forEach((name, config) {
        servers.add(McpServer.fromJson(name, config));
      });

      return McpInstallationInfo(
        hasMcpSupport: servers.isNotEmpty,
        servers: servers,
        configPath: configFile.path,
      );
    } catch (_) {
      return McpInstallationInfo.notInstalled();
    }
  }

  /// Returns all configured MCP servers.
  Future<List<McpServer>> listMcpServers() async {
    final info = await isMcpInstalled();
    return info.servers;
  }

  /// Installs a curated MCP server configuration.
  Future<void> installPopularMcpServer(
    String serverName, {
    Map<String, String>? environment,
  }) async {
    final popularServers = {
      'filesystem': {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-filesystem'],
      },
      'github': {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-github'],
        'env': {'GITHUB_TOKEN': environment?['GITHUB_TOKEN'] ?? ''},
      },
      'postgres': {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-postgres'],
        'env': {'DATABASE_URL': environment?['DATABASE_URL'] ?? ''},
      },
      'git': {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-git'],
      },
      'sequential-thinking': {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-sequential-thinking'],
      },
      'slack': {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-slack'],
        'env': {'SLACK_TOKEN': environment?['SLACK_TOKEN'] ?? ''},
      },
      'google-drive': {
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
      throw CliException(
        'Unknown popular server: $serverName. Available servers: ${popularServers.keys.join(', ')}',
      );
    }

    final server = McpServer(
      name: serverName,
      command: serverConfig['command'] as String,
      args: List<String>.from(serverConfig['args'] as List),
      env: (serverConfig['env'] as Map<String, String>?)?.map(
        (key, value) => MapEntry(key, value),
      ),
    );

    await addMcpServer(serverName, customServer: server);
  }

  /// Adds or updates an MCP server configuration.
  Future<void> addMcpServer(
    String name, {
    McpServer? customServer,
    McpAddOptions? options,
  }) async {
    final configFile = _configFilePath;
    final currentConfig = configFile.existsSync()
        ? McpConfig.fromJson(_parseTomlFile(configFile))
        : McpConfig();

    final server = customServer ??
        McpServer(
          name: name,
          command: 'npx',
          args: ['-y', name],
        );

    final env = options?.environment ?? {};
    final scope = options?.scope ?? McpScope.user;

    final updatedServer = server.copyWith(
      env: env.isEmpty ? server.env : env,
      scope: scope,
    );

    final updatedConfig = currentConfig.addServer(updatedServer);
    await _updateConfigFile((config) {
      config['mcp_servers'] = updatedConfig.toJson()['mcp_servers'];
    });

    print('Configured MCP server "$name" at scope ${scope.name}.');
  }

  /// Retrieves detailed information about a specific MCP server.
  Future<McpServer?> getMcpServerDetails(String name) async {
    final servers = await listMcpServers();
    try {
      return servers.firstWhere((server) => server.name == name);
    } catch (_) {
      return null;
    }
  }

  /// Removes an MCP server from the configuration.
  Future<void> removeMcpServer(String name) async {
    final configFile = _configFilePath;
    if (!configFile.existsSync()) {
      throw CliException('No Codex configuration file found to modify.');
    }

    await _updateConfigFile((config) {
      final servers = (config['mcp_servers'] as Map<String, dynamic>?);
      servers?.remove(name);
    });

    print('Removed MCP server: $name');
  }

  Map<String, dynamic> _parseTomlFile(File configFile) {
    final content = configFile.readAsStringSync();
    return {'mcp_servers': _parseTomlMcpServers(content)};
  }

  String get _shellCommand => Platform.isWindows ? 'cmd.exe' : '/bin/sh';

  List<String> _shellArgs(String command) =>
      Platform.isWindows ? ['/c', command] : ['-c', command];

  Future<bool> _isNpmInstalled() async {
    try {
      final result = await Process.run(
        _shellCommand,
        _shellArgs('npm --version'),
      );
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  File get _configFilePath {
    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';
    return File(path.join(home, '.codex', 'config.toml'));
  }

  bool _isNewerVersion(String current, String latest) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final latestParts = latest.split('.').map(int.parse).toList();

      for (var i = 0; i < 3; i++) {
        final currentPart = i < currentParts.length ? currentParts[i] : 0;
        final latestPart = i < latestParts.length ? latestParts[i] : 0;
        if (latestPart > currentPart) return true;
        if (latestPart < currentPart) return false;
      }
      return false;
    } catch (_) {
      return true;
    }
  }

  Map<String, dynamic> _parseTomlMcpServers(String tomlContent) {
    final servers = <String, dynamic>{};
    final lines = tomlContent.split('\n');
    String? currentServer;
    Map<String, dynamic>? currentConfig;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      final serverMatch =
          RegExp(r'^\[mcp_servers\.(.+)\]$').firstMatch(trimmed);
      if (serverMatch != null) {
        if (currentServer != null && currentConfig != null) {
          servers[currentServer] = currentConfig;
        }
        currentServer = serverMatch.group(1);
        currentConfig = {};
        continue;
      }

      if (currentConfig != null && trimmed.contains('=')) {
        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          var value = parts.sublist(1).join('=').trim();

          if (value.startsWith('"') && value.endsWith('"')) {
            value = value.substring(1, value.length - 1);
          }

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

    if (currentServer != null && currentConfig != null) {
      servers[currentServer] = currentConfig;
    }

    return servers;
  }

  Future<void> _updateConfigFile(
    void Function(Map<String, dynamic>) updater,
  ) async {
    final configFile = _configFilePath;
    if (!configFile.parent.existsSync()) {
      configFile.parent.createSync(recursive: true);
    }

    final config = <String, dynamic>{};
    if (configFile.existsSync()) {
      final content = await configFile.readAsString();
      if (content.contains('[mcp_servers')) {
        config['mcp_servers'] = _parseTomlMcpServers(content);
      }
    }

    updater(config);

    final buffer = StringBuffer();
    final mcpServers = config['mcp_servers'] as Map<String, dynamic>?;
    if (mcpServers != null) {
      mcpServers.forEach((name, serverConfig) {
        buffer.writeln('[mcp_servers.$name]');
        if (serverConfig is Map) {
          serverConfig.forEach((key, value) {
            if (value is List) {
              final items = value.map((v) => '"$v"').join(', ');
              buffer.writeln('$key = [$items]');
            } else if (value is Map) {
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
