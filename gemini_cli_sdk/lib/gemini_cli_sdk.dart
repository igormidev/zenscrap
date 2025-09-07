/// Gemini CLI SDK for Dart
///
/// A comprehensive SDK for interacting with Gemini CLI,
/// providing AI-powered coding assistance through the Gemini CLI.
library;

// Main classes
export 'src/gemini.dart' show GeminiSDK;
export 'src/gemini_chat.dart' show GeminiChat;

// Models
export 'src/models/chat_options.dart' show GeminiChatOptions;
export 'src/models/gemini_sdk_content.dart'
    show GeminiSdkContent, TextContent, FileContent, BytesContent;
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
export 'src/exceptions/gemini_exceptions.dart'
    show
        GeminiSDKException,
        CLINotFoundException,
        CLIConnectionException,
        ProcessException,
        JSONDecodeException;
