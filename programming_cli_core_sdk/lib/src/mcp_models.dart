// Common Model Context Protocol (MCP) models shared across CLI SDKs.

enum McpScope {
  project,
  user,
  system,
}

enum McpServerStatus {
  connected,
  disconnected,
  error,
  unknown,
}

class McpServer {
  final String name;
  final String command;
  final List<String> args;
  final Map<String, String>? env;
  final String type;
  final McpScope? scope;
  final McpServerStatus? status;
  final String? errorMessage;

  McpServer({
    required this.name,
    required this.command,
    required this.args,
    this.env,
    this.type = 'stdio',
    this.scope,
    this.status,
    this.errorMessage,
  });

  factory McpServer.fromJson(String name, Map<String, dynamic> json) {
    return McpServer(
      name: name,
      command: json['command'] as String,
      args: (json['args'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      env: (json['env'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value.toString())),
      type: json['type'] as String? ?? 'stdio',
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'command': command,
      'args': args,
      'type': type,
    };
    if (env != null && env!.isNotEmpty) {
      json['env'] = env;
    }
    return json;
  }

  McpServer copyWith({
    String? name,
    String? command,
    List<String>? args,
    Map<String, String>? env,
    String? type,
    McpScope? scope,
    McpServerStatus? status,
    String? errorMessage,
  }) {
    return McpServer(
      name: name ?? this.name,
      command: command ?? this.command,
      args: args ?? this.args,
      env: env ?? this.env,
      type: type ?? this.type,
      scope: scope ?? this.scope,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'McpServer(name: $name, command: $command, args: $args, '
        'status: $status, scope: $scope)';
  }
}

class McpConfig {
  final Map<String, McpServer> servers;

  McpConfig({Map<String, McpServer>? servers}) : servers = servers ?? {};

  factory McpConfig.fromJson(Map<String, dynamic> json) {
    final mcpServers = json['mcp_servers'] as Map<String, dynamic>?;
    if (mcpServers == null) {
      return McpConfig();
    }
    final servers = <String, McpServer>{};
    mcpServers.forEach((name, config) {
      if (config is Map<String, dynamic>) {
        servers[name] = McpServer.fromJson(name, config);
      }
    });
    return McpConfig(servers: servers);
  }

  Map<String, dynamic> toJson() {
    if (servers.isEmpty) {
      return {};
    }
    return {
      'mcp_servers': servers.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  McpConfig addServer(McpServer server) {
    final updated = Map<String, McpServer>.from(servers);
    updated[server.name] = server;
    return McpConfig(servers: updated);
  }

  McpConfig removeServer(String serverName) {
    final updated = Map<String, McpServer>.from(servers);
    updated.remove(serverName);
    return McpConfig(servers: updated);
  }

  McpServer? getServer(String name) => servers[name];

  List<McpServer> get serverList => servers.values.toList();

  @override
  String toString() => 'McpConfig(servers: ${servers.keys.join(', ')})';
}

class McpInstallationInfo {
  final bool hasMcpSupport;
  final List<McpServer> servers;
  final String? configPath;
  final String? mcpVersion;

  const McpInstallationInfo({
    required this.hasMcpSupport,
    required this.servers,
    this.configPath,
    this.mcpVersion,
  });

  factory McpInstallationInfo.notInstalled() {
    return const McpInstallationInfo(
      hasMcpSupport: false,
      servers: [],
    );
  }

  @override
  String toString() {
    return 'McpInstallationInfo(hasMcpSupport: $hasMcpSupport, '
        'servers: ${servers.length}, configPath: $configPath)';
  }
}

class McpAddOptions {
  final McpScope scope;
  final bool useNpx;
  final Map<String, String>? environment;
  final bool force;

  const McpAddOptions({
    this.scope = McpScope.user,
    this.useNpx = false,
    this.environment,
    this.force = false,
  });
}
