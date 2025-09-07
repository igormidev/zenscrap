/// Models for MCP (Model Context Protocol) server management

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
    final mcpServers = json['mcpServers'] as Map<String, dynamic>?;
    
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
    final mcpServers = <String, dynamic>{};
    servers.forEach((name, server) {
      mcpServers[name] = server.toJson();
    });

    return {
      'mcpServers': mcpServers,
    };
  }

  /// Adds a server to the configuration
  McpConfig addServer(McpServer server) {
    final newServers = Map<String, McpServer>.from(servers);
    newServers[server.name] = server;
    return McpConfig(servers: newServers);
  }

  /// Removes a server from the configuration
  McpConfig removeServer(String serverName) {
    final newServers = Map<String, McpServer>.from(servers);
    newServers.remove(serverName);
    return McpConfig(servers: newServers);
  }

  /// Gets a server by name
  McpServer? getServer(String name) {
    return servers[name];
  }

  /// Lists all server names
  List<String> get serverNames => servers.keys.toList();

  /// Gets all servers as a list
  List<McpServer> get serverList => servers.values.toList();
}

/// Result of checking MCP installation and status
class McpInstallationInfo {
  /// Whether Claude Code CLI is installed
  final bool isClaudeInstalled;
  
  /// Version of Claude Code CLI
  final String? claudeVersion;
  
  /// List of configured MCP servers
  final List<McpServer> servers;
  
  /// Whether MCP support is available
  final bool hasMcpSupport;
  
  /// Path to the configuration file
  final String? configPath;

  McpInstallationInfo({
    required this.isClaudeInstalled,
    this.claudeVersion,
    required this.servers,
    required this.hasMcpSupport,
    this.configPath,
  });

  /// Converts to a user-friendly map
  Map<String, dynamic> toMap() {
    return {
      'claude_installed': isClaudeInstalled,
      'claude_version': claudeVersion,
      'mcp_support': hasMcpSupport,
      'config_path': configPath,
      'servers': servers.map((s) => {
        'name': s.name,
        'command': s.command,
        'status': s.status?.name ?? 'unknown',
        'scope': s.scope?.name,
      }).toList(),
      'server_count': servers.length,
    };
  }
}

/// Options for adding an MCP server
class McpAddOptions {
  /// The scope to add the server to
  final McpScope scope;
  
  /// Whether to use npx for npm packages
  final bool useNpx;
  
  /// Whether to add -y flag to npx for automatic yes
  final bool npxAutoYes;
  
  /// Environment variables to set
  final Map<String, String>? environment;
  
  /// Additional arguments
  final List<String>? additionalArgs;
  
  /// For Windows: whether to wrap with cmd /c
  final bool windowsCmdWrapper;

  McpAddOptions({
    this.scope = McpScope.user,
    this.useNpx = true,
    this.npxAutoYes = true,
    this.environment,
    this.additionalArgs,
    this.windowsCmdWrapper = false,
  });
}

/// Popular MCP servers with pre-configured settings
class PopularMcpServers {
  static final Map<String, McpServer> servers = {
    'filesystem': McpServer(
      name: 'filesystem',
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-filesystem', '~/Documents', '~/Desktop'],
    ),
    'github': McpServer(
      name: 'github',
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-github'],
      env: {'GITHUB_TOKEN': ''},
    ),
    'postgres': McpServer(
      name: 'postgres',
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-postgres'],
      env: {'DATABASE_URL': ''},
    ),
    'git': McpServer(
      name: 'git',
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-git'],
    ),
    'puppeteer': McpServer(
      name: 'puppeteer',
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-puppeteer'],
    ),
    'sequential-thinking': McpServer(
      name: 'sequential-thinking',
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-sequential-thinking'],
    ),
    'slack': McpServer(
      name: 'slack',
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-slack'],
      env: {'SLACK_TOKEN': ''},
    ),
    'google-drive': McpServer(
      name: 'google-drive',
      command: 'npx',
      args: ['-y', '@modelcontextprotocol/server-google-drive'],
      env: {
        'GOOGLE_CLIENT_ID': '',
        'GOOGLE_CLIENT_SECRET': '',
      },
    ),
  };

  /// Gets a popular server configuration by name
  static McpServer? getServer(String name) {
    return servers[name];
  }

  /// Lists all available popular servers
  static List<String> get availableServers => servers.keys.toList();
}