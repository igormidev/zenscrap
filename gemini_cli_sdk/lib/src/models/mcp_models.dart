/// MCP server configuration
class McpServer {
  final String name;
  final String command;
  final List<String> args;
  final Map<String, String>? env;

  const McpServer({
    required this.name,
    required this.command,
    required this.args,
    this.env,
  });

  Map<String, dynamic> toJson() => {
        'command': command,
        'args': args,
        if (env != null) 'env': env,
      };

  factory McpServer.fromJson(Map<String, dynamic> json) {
    return McpServer(
      name: json['name'] as String? ?? '',
      command: json['command'] as String,
      args: List<String>.from(json['args'] as List),
      env: json['env'] != null
          ? Map<String, String>.from(json['env'] as Map)
          : null,
    );
  }
}

/// MCP configuration file structure
class McpConfig {
  final Map<String, McpServer> mcpServers;

  const McpConfig({
    required this.mcpServers,
  });

  Map<String, dynamic> toJson() => {
        'mcpServers': mcpServers.map((key, value) => MapEntry(key, value.toJson())),
      };

  factory McpConfig.fromJson(Map<String, dynamic> json) {
    final servers = <String, McpServer>{};
    if (json['mcpServers'] != null) {
      final mcpServersMap = json['mcpServers'] as Map<String, dynamic>;
      mcpServersMap.forEach((key, value) {
        servers[key] = McpServer.fromJson({
          'name': key,
          ...value as Map<String, dynamic>,
        });
      });
    }
    return McpConfig(mcpServers: servers);
  }
}

/// Scope for MCP server configuration
enum McpScope {
  user,
  project,
}

/// Status of an MCP server
class McpServerStatus {
  final String name;
  final String status;
  final String? error;

  const McpServerStatus({
    required this.name,
    required this.status,
    this.error,
  });
}

/// Information about MCP installation
class McpInstallationInfo {
  final bool hasMcpSupport;
  final List<McpServerStatus> servers;
  final String? configPath;

  const McpInstallationInfo({
    required this.hasMcpSupport,
    required this.servers,
    this.configPath,
  });
}

/// Options for adding an MCP server
class McpAddOptions {
  final McpScope scope;
  final Map<String, String>? environment;
  final bool useNpx;

  const McpAddOptions({
    this.scope = McpScope.user,
    this.environment,
    this.useNpx = false,
  });
}

/// Popular MCP servers that can be easily installed
class PopularMcpServers {
  static const Map<String, Map<String, dynamic>> servers = {
    'filesystem': {
      'package': '@modelcontextprotocol/server-filesystem',
      'command': 'npx',
      'args': ['-y', '@modelcontextprotocol/server-filesystem'],
      'description': 'File system access',
    },
    'github': {
      'package': '@modelcontextprotocol/server-github',
      'command': 'npx',
      'args': ['-y', '@modelcontextprotocol/server-github'],
      'description': 'GitHub integration',
      'requiredEnv': ['GITHUB_TOKEN'],
    },
    'postgres': {
      'package': '@modelcontextprotocol/server-postgres',
      'command': 'npx',
      'args': ['-y', '@modelcontextprotocol/server-postgres'],
      'description': 'PostgreSQL database',
      'requiredEnv': ['DATABASE_URL'],
    },
    'git': {
      'package': '@modelcontextprotocol/server-git',
      'command': 'npx',
      'args': ['-y', '@modelcontextprotocol/server-git'],
      'description': 'Git operations',
    },
    'puppeteer': {
      'package': '@modelcontextprotocol/server-puppeteer',
      'command': 'npx',
      'args': ['-y', '@modelcontextprotocol/server-puppeteer'],
      'description': 'Web automation',
    },
    'sequential-thinking': {
      'package': '@modelcontextprotocol/server-sequential-thinking',
      'command': 'npx',
      'args': ['-y', '@modelcontextprotocol/server-sequential-thinking'],
      'description': 'Problem solving',
    },
    'slack': {
      'package': '@modelcontextprotocol/server-slack',
      'command': 'npx',
      'args': ['-y', '@modelcontextprotocol/server-slack'],
      'description': 'Slack integration',
      'requiredEnv': ['SLACK_BOT_TOKEN', 'SLACK_TEAM_ID'],
    },
    'google-drive': {
      'package': '@modelcontextprotocol/server-google-drive',
      'command': 'npx',
      'args': ['-y', '@modelcontextprotocol/server-google-drive'],
      'description': 'Google Drive access',
      'requiredEnv': ['GOOGLE_DRIVE_CLIENT_ID', 'GOOGLE_DRIVE_CLIENT_SECRET'],
    },
  };

  /// Gets the configuration for a popular server
  static Map<String, dynamic>? getServer(String name) {
    return servers[name];
  }

  /// Lists all available popular servers
  static List<String> list() {
    return servers.keys.toList();
  }

  /// Checks if a server is popular
  static bool isPopular(String name) {
    return servers.containsKey(name);
  }
}