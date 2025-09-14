/// Represents the scope where an MCP server is configured
enum McpScope {
  /// Project-specific configuration
  project,
  /// User-specific configuration
  user,
  /// System-wide configuration
  system,
}

/// Represents the current status of an MCP server
enum McpServerStatus {
  /// Server is connected and running
  connected,
  /// Server is configured but not connected
  disconnected,
  /// Server configuration has errors
  error,
  /// Server status is unknown
  unknown,
}

/// Represents an MCP server configuration
class McpServer {
  /// The unique name/identifier of the MCP server
  final String name;

  /// The command to execute (e.g., 'npx', 'node', 'python')
  final String command;

  /// Arguments to pass to the command
  final List<String> args;

  /// Environment variables for the server
  final Map<String, String>? env;

  /// The type of server (usually 'stdio')
  final String type;

  /// The scope where this server is configured
  final McpScope? scope;

  /// Current status of the server
  final McpServerStatus? status;

  /// Error message if status is error
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

  /// Creates an McpServer from JSON configuration
  factory McpServer.fromJson(String name, Map<String, dynamic> json) {
    return McpServer(
      name: name,
      command: json['command'] as String,
      args: (json['args'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      env: (json['env'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value.toString())),
      type: json['type'] as String? ?? 'stdio',
    );
  }

  /// Converts the McpServer to JSON for configuration
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

  /// Creates a copy with updated values
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

/// Configuration for the entire MCP setup
class McpConfig {
  /// Map of server name to server configuration
  final Map<String, McpServer> servers;

  McpConfig({
    Map<String, McpServer>? servers,
  }) : servers = servers ?? {};

  /// Creates McpConfig from JSON
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

  /// Converts to JSON for configuration file
  Map<String, dynamic> toJson() {
    if (servers.isEmpty) {
      return {};
    }

    return {
      'mcp_servers': servers.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  /// Creates a copy with updated servers
  McpConfig copyWith({
    Map<String, McpServer>? servers,
  }) {
    return McpConfig(
      servers: servers ?? this.servers,
    );
  }

  /// Adds a server to the configuration
  McpConfig addServer(McpServer server) {
    final newServers = Map<String, McpServer>.from(servers);
    newServers[server.name] = server;
    return copyWith(servers: newServers);
  }

  /// Removes a server from the configuration
  McpConfig removeServer(String serverName) {
    final newServers = Map<String, McpServer>.from(servers);
    newServers.remove(serverName);
    return copyWith(servers: newServers);
  }

  @override
  String toString() {
    return 'McpConfig(servers: ${servers.keys.join(', ')})';
  }
}

/// Installation information for MCP
class McpInstallationInfo {
  /// Whether MCP support is available
  final bool hasMcpSupport;

  /// List of configured MCP servers
  final List<McpServer> servers;

  /// Config file path
  final String? configPath;

  /// Version of MCP protocol supported
  final String? mcpVersion;

  const McpInstallationInfo({
    required this.hasMcpSupport,
    required this.servers,
    this.configPath,
    this.mcpVersion,
  });

  /// Creates a default "not installed" info
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

/// Options for adding MCP servers
class McpAddOptions {
  /// The scope to add the server to
  final McpScope scope;

  /// Whether to use npx to run the package
  final bool useNpx;

  /// Additional environment variables
  final Map<String, String>? environment;

  /// Whether to force overwrite existing server config
  final bool force;

  const McpAddOptions({
    this.scope = McpScope.user,
    this.useNpx = false,
    this.environment,
    this.force = false,
  });
}