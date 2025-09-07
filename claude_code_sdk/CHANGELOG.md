## 1.1.0

- Added comprehensive MCP (Model Context Protocol) support:
  - New `isMcpInstalled()` method to check MCP installation and list configured servers
  - `listMcpServers()` to get all configured MCP servers
  - `addMcpServer()` to add custom or npm-based MCP servers
  - `removeMcpServer()` to remove MCP servers
  - `getMcpServerDetails()` to get details about specific servers
  - `installPopularMcpServer()` for easy installation of popular servers
  - `getPopularMcpServers()` to list available popular servers
- New MCP models and types:
  - `McpServer` - MCP server configuration model
  - `McpConfig` - MCP configuration management
  - `McpInstallationInfo` - Installation status information
  - `McpScope` - Server scope enum (project/user/system)
  - `McpServerStatus` - Server status enum
  - `McpAddOptions` - Options for adding servers
  - `PopularMcpServers` - Pre-configured popular servers
- Pre-configured popular MCP servers:
  - filesystem - File system access
  - github - GitHub integration
  - postgres - PostgreSQL database
  - git - Git operations
  - puppeteer - Web automation
  - sequential-thinking - Problem solving
  - slack - Slack integration
  - google-drive - Google Drive access
- Added MCP management example in `example/mcp_management.dart`
- Updated SDK info to include MCP status
- Full Windows support with cmd wrapper option

## 1.0.0

- Initial release of Claude Code SDK for Dart
- Core features:
  - Create and manage chat sessions with Claude
  - Send text messages and file references
  - Schema-based structured responses
  - Real-time streaming of responses
  - Automatic SDK installation checking
  - Cross-platform support (Windows, macOS, Linux)
- Comprehensive error handling with custom exceptions
- Resource management with proper disposal
- Full test coverage
- Complete documentation and examples
