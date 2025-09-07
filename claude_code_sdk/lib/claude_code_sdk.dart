/// Claude Code SDK for Dart
///
/// A comprehensive SDK for interacting with Claude Code,
/// providing AI-powered coding assistance through the Claude Code CLI.
library claude_code_sdk;

// Main classes
export 'src/claude.dart' show Claude;
export 'src/claude_chat.dart' show ClaudeChat;

// Models
export 'src/models/chat_options.dart' show ClaudeChatOptions;
export 'src/models/claude_sdk_content.dart'
    show ClaudeSdkContent, TextContent, FileContent, BytesContent;
export 'src/models/schema_models.dart'
    show SchemaResult, SchemaObject, SchemaProperty;
export 'src/models/mcp_models.dart'
    show
        McpServer,
        McpConfig,
        McpScope,
        McpServerStatus,
        McpInstallationInfo,
        McpAddOptions,
        PopularMcpServers;

// Exceptions
export 'src/exceptions/claude_exceptions.dart'
    show
        ClaudeSDKException,
        CLINotFoundException,
        CLIConnectionException,
        ProcessException,
        JSONDecodeException;
