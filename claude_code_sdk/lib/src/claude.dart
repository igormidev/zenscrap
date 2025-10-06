import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';

import 'claude_chat.dart';
import 'claude_chat_options.dart';

class Claude extends CodingCliInterface<ClaudeChat, ClaudeChatOptions> {
  Claude({super.apiKey});

  @override
  ClaudeChat createNewChat({ClaudeChatOptions? options}) {
    final chat = ClaudeChat(apiKey: apiKey, options: options);
    activeSessions.add(chat);
    return chat;
  }

  @override
  Future<bool> isCodexCLIInstalled() async => isClaudeCLIInstalled();

  Future<bool> isClaudeCLIInstalled() async {
    final commands = ['claude --version', 'claude-code --version'];
    for (final command in commands) {
      try {
        final result = await Process.run(
          _shellCommand,
          _shellArgs(command),
        );
        if (result.exitCode == 0) {
          return true;
        }
      } catch (_) {
        continue;
      }
    }
    return false;
  }

  @override
  Future<void> installCodexCLI({bool global = true}) async =>
      installClaudeCLI(global: global);

  Future<void> installClaudeCLI({bool global = true}) async {
    if (!await _isNpmInstalled()) {
      throw CliException(
        'npm is not installed. Install Node.js (https://nodejs.org/) to continue.',
      );
    }

    final installCommand = global
        ? 'npm install -g @anthropic-ai/claude-code'
        : 'npm install @anthropic-ai/claude-code';

    final process = await Process.start(
      _shellCommand,
      _shellArgs(installCommand),
      mode: ProcessStartMode.inheritStdio,
    );

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw CliException(
          'Failed to install Claude Code CLI (exit code $exitCode).');
    }
  }

  @override
  Future<void> updateToNewestVersionIfNeeded({bool global = true}) async {
    if (!await isClaudeCLIInstalled()) {
      await installClaudeCLI(global: global);
      return;
    }

    if (!await _isNpmInstalled()) {
      throw CliException(
        'npm is not installed. Install Node.js (https://nodejs.org/) to continue.',
      );
    }

    try {
      final current = await _resolveInstalledVersion();
      final latest = await _resolveLatestVersion();

      if (current == null ||
          latest == null ||
          _isNewerVersion(current, latest)) {
        final command = global
            ? 'npm update -g @anthropic-ai/claude-code'
            : 'npm update @anthropic-ai/claude-code';

        final process = await Process.start(
          _shellCommand,
          _shellArgs(command),
          mode: ProcessStartMode.inheritStdio,
        );

        final exitCode = await process.exitCode;
        if (exitCode != 0) {
          await installClaudeCLI(global: global);
        }
      }
    } catch (_) {
      // If anything fails, fall back to reinstall.
      await installClaudeCLI(global: global);
    }
  }

  @override
  Future<Map<String, dynamic>> getSDKInfo() async {
    final info = <String, dynamic>{};

    info['claudeCLIInstalled'] = await isClaudeCLIInstalled();
    if (info['claudeCLIInstalled'] == true) {
      info['claudeVersion'] = await _resolveInstalledVersion();
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

    final mcpInfo = await isMcpInstalled();
    info['mcpEnabled'] = mcpInfo.hasMcpSupport;
    info['mcpServerCount'] = mcpInfo.servers.length;

    return info;
  }

  Future<McpInstallationInfo> isMcpInstalled() async {
    final installed = await isClaudeCLIInstalled();
    final servers = await listMcpServers();
    final version = await _resolveInstalledVersion();

    return McpInstallationInfo(
      hasMcpSupport: installed,
      servers: servers,
      configPath: _configFilePath.path,
      mcpVersion: version,
    );
  }

  Future<List<McpServer>> listMcpServers() async {
    final file = _configFilePath;
    if (!await file.exists()) {
      return [];
    }

    try {
      final content = await file.readAsString();
      final json = _normalizeMcpConfig(jsonDecode(content));
      final config = McpConfig.fromJson(json);
      return config.serverList;
    } catch (_) {
      return [];
    }
  }

  Future<void> addMcpServer(
    String name, {
    McpServer? customServer,
    McpAddOptions? options,
  }) async {
    var server = customServer ??
        _popularServerTemplate(name)?.copyWith(name: name) ??
        McpServer(
          name: name,
          command: options?.useNpx == false ? name : 'npx',
          args: options?.useNpx == false ? [] : ['-y', name],
        );

    if (options?.environment != null) {
      final mergedEnv = Map<String, String>.from(server.env ?? {});
      mergedEnv.addAll(options!.environment!);
      server = server.copyWith(env: mergedEnv);
    }

    final file = _configFilePath;
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    Map<String, dynamic> configJson = {};
    if (await file.exists()) {
      try {
        final content = await file.readAsString();
        configJson = jsonDecode(content) as Map<String, dynamic>;
      } catch (_) {
        configJson = {};
      }
    }

    final normalized = _normalizeMcpConfig(configJson);
    final servers = (normalized['mcp_servers'] as Map<String, dynamic>? ?? {})
      ..[server.name] = server.toJson();
    normalized['mcp_servers'] = servers;

    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(normalized));
  }

  Future<void> removeMcpServer(String name) async {
    final file = _configFilePath;
    if (!await file.exists()) {
      throw CliException('Configuration file not found at ${file.path}');
    }

    final content = await file.readAsString();
    final configJson = _normalizeMcpConfig(jsonDecode(content));
    final servers = configJson['mcp_servers'] as Map<String, dynamic>?;

    if (servers == null || !servers.containsKey(name)) {
      throw CliException('MCP server "$name" not found in configuration.');
    }

    servers.remove(name);
    final encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(configJson));
  }

  Future<void> exportApiKeyToEnvironment() async {
    if (apiKey == null || apiKey!.isEmpty) {
      throw CliException(
        'Cannot export API key: No API key provided. Use logged-in credentials instead.',
      );
    }

    final command = Platform.isWindows
        ? 'setx ANTHROPIC_API_KEY "$apiKey"'
        : 'export ANTHROPIC_API_KEY="$apiKey"';

    final result = await Process.run(
      _shellCommand,
      _shellArgs(command),
    );

    if (result.exitCode != 0) {
      final errorOutput = (result.stderr as String?)?.trim().isNotEmpty == true
          ? result.stderr.toString().trim()
          : result.stdout.toString().trim();
      throw CliException(
        'Failed to export ANTHROPIC_API_KEY. Exit code ${result.exitCode}.${errorOutput.isEmpty ? '' : ' Error: $errorOutput'}',
      );
    }
  }

  Future<void> dispose() async {
    for (final session in activeSessions) {
      await session.dispose();
    }
    activeSessions.clear();
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
    return File(path.join(home, '.claude', '.claude.json'));
  }

  Future<String?> _resolveInstalledVersion() async {
    final commands = ['claude --version', 'claude-code --version'];
    for (final cmd in commands) {
      try {
        final result = await Process.run(
          _shellCommand,
          _shellArgs(cmd),
        );
        if (result.exitCode == 0) {
          final match =
              RegExp(r'(\d+\.\d+\.\d+)').firstMatch(result.stdout.toString());
          if (match != null) {
            return match.group(1);
          }
        }
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  Future<String?> _resolveLatestVersion() async {
    try {
      final result = await Process.run(
        _shellCommand,
        _shellArgs('npm view @anthropic-ai/claude-code version'),
      );
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
    } catch (_) {}
    return null;
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

  Map<String, dynamic> _normalizeMcpConfig(Map<String, dynamic> json) {
    if (json.containsKey('mcpServers') && !json.containsKey('mcp_servers')) {
      json = Map<String, dynamic>.from(json);
      json['mcp_servers'] = json['mcpServers'];
      json.remove('mcpServers');
    }
    return json;
  }

  McpServer? _popularServerTemplate(String name) {
    switch (name) {
      case 'filesystem':
        return McpServer(
          name: 'filesystem',
          command: 'npx',
          args: [
            '-y',
            '@modelcontextprotocol/server-filesystem',
            '~/Documents',
            '~/Desktop'
          ],
        );
      case 'github':
        return McpServer(
          name: 'github',
          command: 'npx',
          args: ['-y', '@modelcontextprotocol/server-github'],
          env: {'GITHUB_TOKEN': ''},
        );
      case 'postgres':
        return McpServer(
          name: 'postgres',
          command: 'npx',
          args: ['-y', '@modelcontextprotocol/server-postgres'],
          env: {'DATABASE_URL': ''},
        );
      case 'git':
        return McpServer(
          name: 'git',
          command: 'npx',
          args: ['-y', '@modelcontextprotocol/server-git'],
        );
      case 'sequential-thinking':
        return McpServer(
          name: 'sequential-thinking',
          command: 'npx',
          args: ['-y', '@modelcontextprotocol/server-sequential-thinking'],
        );
      case 'slack':
        return McpServer(
          name: 'slack',
          command: 'npx',
          args: ['-y', '@modelcontextprotocol/server-slack'],
          env: {'SLACK_TOKEN': ''},
        );
      case 'google-drive':
        return McpServer(
          name: 'google-drive',
          command: 'npx',
          args: ['-y', '@modelcontextprotocol/server-google-drive'],
          env: {
            'GOOGLE_CLIENT_ID': '',
            'GOOGLE_CLIENT_SECRET': '',
          },
        );
    }
    return null;
  }
}
