import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:programming_cli_core_sdk/programming_cli_core_sdk.dart';

import 'gemini_chat.dart';
import 'gemini_chat_options.dart';

class Gemini extends CodingCliInterface<GeminiChat, GeminiChatOptions> {
  Gemini({required this.apiKey});

  /// The API key for authenticating with Gemini CLI
  final String apiKey;

  @override
  GeminiChat createNewChat({GeminiChatOptions? options}) {
    final chat = GeminiChat(apiKey: apiKey, options: options);
    activeSessions.add(chat);
    return chat;
  }

  @override
  Future<bool> isCodexCLIInstalled() async => isGeminiCLIInstalled();

  Future<bool> isGeminiCLIInstalled() async {
    try {
      final result = await Process.run(
        _shellCommand,
        _shellArgs('gemini --version'),
      );
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> installCodexCLI({bool global = true}) async =>
      installGeminiCLI(global: global);

  Future<void> installGeminiCLI({bool global = true}) async {
    if (!await _isNpmInstalled()) {
      throw CliException(
        'npm is not installed. Please install Node.js (https://nodejs.org/) first.',
      );
    }

    final command = global
        ? 'npm install -g @google/gemini-cli'
        : 'npm install @google/gemini-cli';

    final process = await Process.start(
      _shellCommand,
      _shellArgs(command),
      mode: ProcessStartMode.inheritStdio,
    );

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw CliException('Failed to install Gemini CLI (exit code $exitCode).');
    }
  }

  @override
  Future<void> updateToNewestVersionIfNeeded({bool global = true}) async {
    if (!await isGeminiCLIInstalled()) {
      await installGeminiCLI(global: global);
      return;
    }

    if (!await _isNpmInstalled()) {
      throw CliException(
        'npm is not installed. Please install Node.js (https://nodejs.org/) first.',
      );
    }

    try {
      final currentVersionResult = await Process.run(
        _shellCommand,
        _shellArgs('gemini --version'),
      );

      String currentVersion = '';
      if (currentVersionResult.exitCode == 0) {
        final versionMatch = RegExp(r'(\d+\.\d+\.\d+)')
            .firstMatch(currentVersionResult.stdout.toString());
        if (versionMatch != null) {
          currentVersion = versionMatch.group(1) ?? '';
        }
      }

      final latestVersionResult = await Process.run(
        _shellCommand,
        _shellArgs('npm view @google/gemini-cli version'),
      );

      if (latestVersionResult.exitCode != 0) {
        return;
      }

      final latestVersion = latestVersionResult.stdout.toString().trim();
      if (currentVersion.isEmpty) {
        await installGeminiCLI(global: global);
        return;
      }

      if (_isNewerVersion(currentVersion, latestVersion)) {
        final command = global
            ? 'npm update -g @google/gemini-cli'
            : 'npm update @google/gemini-cli';

        final process = await Process.start(
          _shellCommand,
          _shellArgs(command),
          mode: ProcessStartMode.inheritStdio,
        );

        final exitCode = await process.exitCode;
        if (exitCode != 0) {
          await installGeminiCLI(global: global);
        }
      }
    } catch (_) {
      await installGeminiCLI(global: global);
    }
  }

  @override
  Future<Map<String, dynamic>> getSDKInfo() async {
    final info = <String, dynamic>{};

    info['geminiCLIInstalled'] = await isGeminiCLIInstalled();
    if (info['geminiCLIInstalled'] == true) {
      try {
        final result = await Process.run(
          _shellCommand,
          _shellArgs('gemini --version'),
        );
        if (result.exitCode == 0) {
          info['geminiVersion'] = result.stdout.toString().trim();
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

    final userConfig = _configFile(scope: McpScope.user);
    info['configPath'] = userConfig.path;
    info['configExists'] = userConfig.existsSync();

    final mcpInfo = await isMcpInstalled();
    info['mcpEnabled'] = mcpInfo.hasMcpSupport;
    info['mcpServers'] = mcpInfo.servers.length;

    return info;
  }

  @override
  Future<void> addApiKeyToEnvironment(String apiKey) async {
    final command = Platform.isWindows
        ? 'setx GEMINI_API_KEY "$apiKey"'
        : 'export GEMINI_API_KEY="$apiKey"';

    final result = await Process.run(
      _shellCommand,
      _shellArgs(command),
    );

    if (result.exitCode != 0) {
      final errorOutput = (result.stderr as String?)?.trim().isNotEmpty == true
          ? result.stderr.toString().trim()
          : result.stdout.toString().trim();
      throw CliException(
        'Failed to export GEMINI_API_KEY. Exit code ${result.exitCode}.${errorOutput.isEmpty ? '' : ' Error: $errorOutput'}',
      );
    }
  }

  Future<void> dispose() async {
    for (final session in activeSessions) {
      await session.dispose();
    }
    activeSessions.clear();
  }

  Future<McpInstallationInfo> isMcpInstalled() async {
    final file = _configFile(scope: McpScope.user);
    if (!await file.exists()) {
      return McpInstallationInfo.notInstalled();
    }

    try {
      final json = await _readConfigJson(file);
      final normalized = _normalizeConfig(json);
      final config = McpConfig.fromJson(normalized);
      return McpInstallationInfo(
        hasMcpSupport: config.servers.isNotEmpty,
        servers: config.serverList,
        configPath: file.path,
      );
    } catch (_) {
      return McpInstallationInfo.notInstalled();
    }
  }

  Future<List<McpServer>> listMcpServers(
      {McpScope scope = McpScope.user}) async {
    final file = _configFile(scope: scope);
    if (!await file.exists()) {
      return [];
    }

    try {
      final json = await _readConfigJson(file);
      final normalized = _normalizeConfig(json);
      final config = McpConfig.fromJson(normalized);
      return config.serverList;
    } catch (_) {
      return [];
    }
  }

  Future<void> installPopularMcpServer(
    String serverName, {
    Map<String, String>? environment,
    McpScope scope = McpScope.user,
  }) async {
    final template = _popularServers[serverName];
    if (template == null) {
      throw CliException(
        'Unknown popular server: $serverName. Available servers: ${_popularServers.keys.join(', ')}',
      );
    }

    final env = <String, String>{};
    env.addAll(template.env ?? {});
    if (environment != null) {
      env.addAll(environment);
    }

    final server = McpServer(
      name: serverName,
      command: template.command,
      args: template.args,
      env: env.isEmpty ? null : env,
    );

    await addMcpServer(
      serverName,
      customServer: server,
      options: McpAddOptions(scope: scope),
    );
  }

  Future<void> addMcpServer(
    String name, {
    McpServer? customServer,
    McpAddOptions? options,
  }) async {
    final opts = options ?? const McpAddOptions();
    final scope = opts.scope;
    if (scope == McpScope.system) {
      throw CliException(
          'Gemini CLI does not support system scope configurations.');
    }

    final file = _configFile(scope: scope);
    final originalJson = await _readConfigJson(file);
    final normalized = _normalizeConfig(originalJson);
    var config = McpConfig.fromJson(normalized);

    var server = customServer ?? _createDefaultServer(name, opts.useNpx);
    if (opts.environment != null && opts.environment!.isNotEmpty) {
      final mergedEnv = Map<String, String>.from(server.env ?? {});
      mergedEnv.addAll(opts.environment!);
      server = server.copyWith(env: mergedEnv);
    }

    config = config.addServer(server.copyWith(scope: scope));

    final updatedJson = _denormalizeConfig(config, originalJson);
    await _writeConfigJson(file, updatedJson);
  }

  Future<McpServer?> getMcpServerDetails(String name) async {
    final servers = await listMcpServers();
    try {
      return servers.firstWhere((server) => server.name == name);
    } catch (_) {
      return null;
    }
  }

  Future<void> removeMcpServer(String name,
      {bool removeFromProject = true}) async {
    final scopes = <McpScope>[McpScope.user];
    if (removeFromProject) {
      scopes.add(McpScope.project);
    }

    var removed = false;
    for (final scope in scopes) {
      final file = _configFile(scope: scope);
      if (!await file.exists()) {
        continue;
      }

      final originalJson = await _readConfigJson(file);
      final normalized = _normalizeConfig(originalJson);
      final config = McpConfig.fromJson(normalized);
      if (config.getServer(name) == null) {
        continue;
      }

      final updatedConfig = config.removeServer(name);
      final updatedJson = _denormalizeConfig(updatedConfig, originalJson);
      await _writeConfigJson(file, updatedJson);
      removed = true;
    }

    if (!removed) {
      throw CliException('MCP server "$name" not found in configuration.');
    }
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

  File _configFile({required McpScope scope}) {
    final fileName = path.join('.gemini', 'settings.json');
    switch (scope) {
      case McpScope.user:
        final home = _resolveHomeDirectory();
        return File(path.join(home, fileName));
      case McpScope.project:
        return File(path.join(Directory.current.path, fileName));
      case McpScope.system:
        throw CliException('System scope is not supported for Gemini CLI.');
    }
  }

  String _resolveHomeDirectory() {
    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        Platform.environment['HOMEPATH'];
    if (home == null || home.isEmpty) {
      throw CliException(
          'Could not determine home directory for MCP configuration.');
    }
    return home;
  }

  Future<Map<String, dynamic>> _readConfigJson(File file) async {
    if (!await file.exists()) {
      return {};
    }

    try {
      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        return {};
      }
      final decoded = jsonDecode(content);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeConfigJson(File file, Map<String, dynamic> json) async {
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString('${encoder.convert(json)}\n');
  }

  Map<String, dynamic> _normalizeConfig(Map<String, dynamic> json) {
    if (json.containsKey('mcp_servers')) {
      return json;
    }
    if (json.containsKey('mcpServers')) {
      final value = json['mcpServers'];
      if (value is Map<String, dynamic>) {
        return {
          ...json,
          'mcp_servers': value,
        };
      }
    }
    return json;
  }

  Map<String, dynamic> _denormalizeConfig(
    McpConfig config,
    Map<String, dynamic> original,
  ) {
    final updated = Map<String, dynamic>.from(original)
      ..remove('mcpServers')
      ..remove('mcp_servers');

    final servers = config.toJson()['mcp_servers'] as Map<String, dynamic>?;
    if (servers != null && servers.isNotEmpty) {
      updated['mcpServers'] = servers;
    }

    return updated;
  }

  McpServer _createDefaultServer(String name, bool useNpx) {
    return McpServer(
      name: name,
      command: useNpx ? 'npx' : name,
      args: useNpx ? ['-y', name] : [],
    );
  }

  static const Map<String, _PopularServer> _popularServers = {
    'filesystem': _PopularServer(
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-filesystem'],
    ),
    'github': _PopularServer(
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-github'],
      env: {'GITHUB_TOKEN': ''},
    ),
    'postgres': _PopularServer(
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-postgres'],
      env: {'DATABASE_URL': ''},
    ),
    'git': _PopularServer(
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-git'],
    ),
    'sequential-thinking': _PopularServer(
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-sequential-thinking'],
    ),
    'slack': _PopularServer(
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-slack'],
      env: {'SLACK_TOKEN': ''},
    ),
    'google-drive': _PopularServer(
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-google-drive'],
      env: {
        'GOOGLE_CLIENT_ID': '',
        'GOOGLE_CLIENT_SECRET': '',
      },
    ),
  };
}

class _PopularServer {
  const _PopularServer({
    required this.command,
    required this.args,
    this.env,
  });

  final String command;
  final List<String> args;
  final Map<String, String>? env;
}

typedef GeminiSDK = Gemini;
