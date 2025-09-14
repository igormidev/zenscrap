# Codex CLI SDK for Dart

A powerful Dart SDK for interacting with OpenAI Codex CLI, providing seamless integration with AI-powered coding assistance through the Codex CLI tool.

## Features

- 🚀 **Easy Integration**: Simple API for creating chat sessions with Codex
- 📁 **File Support**: Send files along with text prompts for context-aware responses
- 💾 **Bytes Support**: Send in-memory data as temporary files (auto-cleanup on dispose)
- 📋 **Schema Support**: Get structured responses using JSON schemas
- 🔄 **Session Management**: Resume and continue conversations seamlessly
- 🛠️ **Auto-Installation**: Built-in methods to check and install Codex CLI
- 🔌 **MCP Support**: Full Model Context Protocol integration for connecting to external tools
- 🧹 **Resource Management**: Proper cleanup and disposal of chat sessions and temp files
- 🔐 **Secure**: API key management with environment variable support
- ⚡ **Reliable**: Simple Process.run based implementation (no streaming complexity)
- 🌊 **Streaming**: Support for real-time streaming responses
- 🎯 **Multiple Modes**: Support for suggest, auto-edit, and full-auto modes

## Prerequisites

Before using this SDK, you need:

1. **Node.js and npm** (for Codex CLI)
   - Download from [nodejs.org](https://nodejs.org/)

2. **Codex CLI**
   - Install globally: `npm install -g @openai/codex`
   - Or use the SDK's built-in installer (see below)

3. **OpenAI API Key**
   - Get your API key from [OpenAI Platform](https://platform.openai.com/api-keys)
   - Or sign in with ChatGPT Plus/Pro/Team subscription

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  codex_cli_sdk: ^1.0.0
```

Then run:

```bash
dart pub get
```

## Available Models

The SDK supports the latest OpenAI models through Codex CLI:

- **GPT-5** - Default model for fast reasoning
- **codex-mini-latest** - Fine-tuned version of o4-mini for Codex CLI
- **codex-1** - Version of o3 optimized for software engineering

## Quick Start

### Basic Usage

```dart
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() async {
  // Initialize the SDK with your API key
  final codexSDK = Codex('YOUR_API_KEY');

  // Create a new chat session
  final codexChat = codexSDK.createNewChat();

  try {
    // Send a simple text message
    final result = await codexChat.sendMessage([
      CodexSdkContent.text('What is the capital of France?'),
    ]);

    print('Codex says: $result');
  } finally {
    // Always dispose of the chat when done
    await codexChat.dispose();
  }
}
```

### Sending Files with Messages

```dart
import 'dart:io';
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() async {
  final codexSDK = Codex('YOUR_API_KEY');
  final codexChat = codexSDK.createNewChat();

  try {
    // Send a message with a file
    final result = await codexChat.sendMessage([
      CodexSdkContent.text('Please analyze this HTML file and extract the user name'),
      CodexSdkContent.file(File('example.html')),
    ]);

    print('Analysis result: $result');
  } finally {
    await codexChat.dispose();
  }
}
```

### Sending Bytes as Temporary Files

You can send in-memory data (like images, documents, or any binary data) without creating permanent files:

```dart
import 'dart:typed_data';
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() async {
  final codexSDK = Codex('YOUR_API_KEY');
  final codexChat = codexSDK.createNewChat();

  try {
    // Example 1: Send image bytes
    final imageBytes = await File('photo.jpg').readAsBytes();
    final result = await codexChat.sendMessage([
      CodexSdkContent.text('What is in this image?'),
      CodexSdkContent.bytes(
        data: imageBytes,
        fileExtension: 'jpg',
      ),
    ]);

    // Example 2: Send text as bytes
    final textContent = 'Hello, this is dynamic content!';
    final textBytes = Uint8List.fromList(textContent.codeUnits);
    final result2 = await codexChat.sendMessage([
      CodexSdkContent.text('Read this text:'),
      CodexSdkContent.bytes(
        data: textBytes,
        fileExtension: 'txt',
      ),
    ]);

    print('Result: $result2');
  } finally {
    // Temporary files are automatically deleted when disposed
    await codexChat.dispose();
  }
}
```

### Using Schemas for Structured Responses

```dart
import 'dart:io';
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() async {
  final codexSDK = Codex('YOUR_API_KEY');
  final codexChat = codexSDK.createNewChat();

  try {
    // Define a schema with nullable properties
    final schema = SchemaObject(
      properties: {
        'userName': SchemaProperty.string(
          description: 'The name of the user found in the HTML',
          nullable: false, // Required field
        ),
        'userEmail': SchemaProperty.string(
          description: 'The email of the user if found',
          nullable: true, // Optional field
        ),
        'userRole': SchemaProperty.string(
          description: 'The role or title of the user',
          nullable: true, // Optional field
        ),
      },
    );

    // Send message with schema
    final result = await codexChat.sendMessageWithSchema(
      messages: [
        CodexSdkContent.text('Extract user information from this HTML file'),
        CodexSdkContent.file(File('profile.html')),
      ],
      schema: schema,
    );

    print('Model message: ${result.modelMessage}');
    print('Extracted data: ${result.data}');

    // Access specific fields
    final userName = result.data['userName'];
    print('User name: $userName');
  } finally {
    await codexChat.dispose();
  }
}
```

### Streaming Responses

```dart
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() async {
  final codexSDK = Codex('YOUR_API_KEY');
  final codexChat = codexSDK.createNewChat();

  try {
    // Stream the response
    await for (final chunk in codexChat.streamResponse([
      CodexSdkContent.text('Write a detailed explanation of quantum computing'),
    ])) {
      print(chunk); // Print each chunk as it arrives
    }
  } finally {
    await codexChat.dispose();
  }
}
```

## Advanced Configuration

### Chat Options

```dart
final codexChat = codexSDK.createNewChat(
  options: CodexChatOptions(
    systemPrompt: 'You are a helpful coding assistant',
    maxTurns: 5,
    model: 'codex-mini-latest',
    mode: 'auto-edit', // or 'suggest', 'full-auto'
    cwd: '/path/to/project',
    outputJson: true,
    quiet: true, // Non-interactive JSON mode
    timeoutMs: 30000,
    enableMcp: true,
    profile: 'custom-profile', // Use profile from config.toml
  ),
);
```

### Operation Modes

Codex CLI supports three distinct operation modes:

- **suggest**: Reviews proposed changes before applying
- **auto-edit**: Automatically reads and writes files but asks permission for shell commands
- **full-auto**: Fully autonomous operation within a sandboxed environment

```dart
// Suggest mode - review changes before applying
final suggestChat = codexSDK.createNewChat(
  options: CodexChatOptions(mode: 'suggest'),
);

// Auto-edit mode - automatic file operations
final autoEditChat = codexSDK.createNewChat(
  options: CodexChatOptions(mode: 'auto-edit'),
);

// Full-auto mode - fully autonomous
final fullAutoChat = codexSDK.createNewChat(
  options: CodexChatOptions(mode: 'full-auto'),
);
```

### Session Management

```dart
// Continue the last session
final chat = codexSDK.createNewChat(
  options: CodexChatOptions(continueLastSession: true),
);

// Resume a specific session
final chat = codexSDK.createNewChat(
  options: CodexChatOptions(resumeSessionId: 'session-id-here'),
);

// Reset conversation mid-session
chat.resetConversation();
```

### Checking and Installing Codex CLI

```dart
void main() async {
  final codexSDK = Codex('YOUR_API_KEY');

  // Check if Codex CLI is installed
  final isInstalled = await codexSDK.isCodexCLIInstalled();

  if (!isInstalled) {
    print('Codex CLI is not installed. Installing...');

    try {
      // Install the CLI globally
      await codexSDK.installCodexCLI(global: true);
      print('Installation complete!');
    } catch (e) {
      print('Installation failed: $e');
    }
  }

  // Get SDK information
  final info = await codexSDK.getSDKInfo();
  print('SDK Info: $info');
}
```

## MCP (Model Context Protocol) Support

The SDK provides comprehensive support for MCP, allowing Codex to connect to external tools and services.

### Checking MCP Installation

```dart
final mcpInfo = await codexSDK.isMcpInstalled();
print('MCP enabled: ${mcpInfo.hasMcpSupport}');
print('Configured servers: ${mcpInfo.servers.length}');

for (final server in mcpInfo.servers) {
  print('  - ${server.name}: ${server.status}');
}
```

### Installing Popular MCP Servers

```dart
// Install filesystem MCP server
await codexSDK.installPopularMcpServer('filesystem');

// Install GitHub MCP with environment variables
await codexSDK.installPopularMcpServer('github',
  environment: {'GITHUB_TOKEN': 'your-github-token'}
);

// Available popular servers:
// - filesystem: File system access
// - github: GitHub integration
// - postgres: PostgreSQL database
// - git: Git operations
// - puppeteer: Web automation
// - sequential-thinking: Problem solving
// - slack: Slack integration
// - google-drive: Google Drive access
```

### Adding Custom MCP Servers

```dart
// Add a custom MCP server
final customServer = McpServer(
  name: 'my-custom-server',
  command: 'node',
  args: ['path/to/server.js'],
  env: {'API_KEY': 'your-api-key'},
);

await codexSDK.addMcpServer(
  'my-custom-server',
  customServer: customServer,
);

// Or add an npm package as MCP server
await codexSDK.addMcpServer(
  'my-npm-server',
  packageName: '@company/mcp-server',
  options: McpAddOptions(
    scope: McpScope.user,
    useNpx: true,
    environment: {'CONFIG': 'value'},
  ),
);
```

### Managing MCP Servers

```dart
// List all configured servers
final servers = await codexSDK.listMcpServers();

// Get details about a specific server
final details = await codexSDK.getMcpServerDetails('filesystem');

// Remove a server
await codexSDK.removeMcpServer('my-custom-server');
```

### Using MCP in Chat Sessions

Once MCP servers are configured, they're automatically available in chat sessions:

```dart
final chat = codexSDK.createNewChat();

// Codex can now use the configured MCP tools
final result = await chat.sendMessage([
  CodexSdkContent.text(
    'List all files in my Documents folder' // Works if filesystem MCP is installed
  ),
]);
```

## Schema Building

The SDK provides convenient factory methods for building schemas with nullable control:

```dart
final schema = SchemaObject(
  properties: {
    'name': SchemaProperty.string(
      description: 'User name',
      defaultValue: 'Anonymous',
      nullable: false, // Required field
    ),
    'age': SchemaProperty.number(
      description: 'User age',
      nullable: false, // Required field
    ),
    'email': SchemaProperty.string(
      description: 'User email',
      nullable: true, // Optional field (default)
    ),
    'isActive': SchemaProperty.boolean(
      description: 'Whether the user is active',
      defaultValue: true,
      nullable: false, // Required with default value
    ),
    'tags': SchemaProperty.array(
      items: SchemaProperty.string(),
      description: 'List of tags',
      nullable: true, // Optional array
    ),
    'metadata': SchemaProperty.object(
      properties: {
        'created': SchemaProperty.string(nullable: false),
        'updated': SchemaProperty.string(nullable: true),
      },
      description: 'Metadata object',
      nullable: true, // Optional nested object
    ),
  },
  description: 'User information schema',
);
```

### Nullable Property Behavior

- `nullable: false` - The property is required and must be present in the response
- `nullable: true` (default) - The property is optional and may be omitted or null
- Properties with `nullable: false` are automatically added to the JSON schema's `required` array

## Error Handling

The SDK provides specific exception types for different error scenarios:

```dart
import 'package:codex_cli_sdk/codex_cli_sdk.dart';

void main() async {
  final codexSDK = Codex('YOUR_API_KEY');
  final codexChat = codexSDK.createNewChat();

  try {
    final result = await codexChat.sendMessage([
      CodexSdkContent.text('Hello, Codex!'),
    ]);
    print(result);
  } on CLINotFoundException {
    print('Codex CLI is not installed. Please install it first.');
  } on ProcessException catch (e) {
    print('Process error: ${e.message}');
    if (e.exitCode != null) {
      print('Exit code: ${e.exitCode}');
    }
  } on JSONDecodeException catch (e) {
    print('Failed to parse response: ${e.message}');
  } on CodexSDKException catch (e) {
    print('SDK error: ${e.message}');
  } finally {
    await codexChat.dispose();
  }
}
```

## Implementation Details

This SDK uses a simple and reliable approach:
- **Process.run**: Each message is sent as a separate process call
- **Session Management**: Uses `--resume` and `--continue` flags for conversation continuity
- **JSON Output**: Uses `--quiet` and `--json` flags for consistent parsing
- **MCP Configuration**: Manages `~/.codex/config.toml` for MCP servers

## Resource Management

### Important: Always Dispose Chat Sessions

Always dispose of chat sessions when done to ensure proper cleanup:

```dart
// Method 1: Using try-finally
final chat = codexSDK.createNewChat();
try {
  // Use the chat
  await chat.sendMessage([...]);
} finally {
  await chat.dispose();
}

// Method 2: Dispose all sessions at once
await codexSDK.dispose(); // Disposes all active sessions
```

## API Reference

### Codex Class

- `Codex(String apiKey)` - Creates a new SDK instance
- `createNewChat({CodexChatOptions? options})` - Creates a new chat session
- `isCodexCLIInstalled()` - Checks if Codex CLI is installed
- `installCodexCLI({bool global = true})` - Installs the Codex CLI
- `getSDKInfo()` - Gets information about installed SDKs
- `isMcpInstalled()` - Checks MCP installation status
- `listMcpServers()` - Lists all configured MCP servers
- `installPopularMcpServer(name, {environment})` - Installs a popular MCP server
- `addMcpServer(name, {packageName, customServer, options})` - Adds an MCP server
- `getMcpServerDetails(name)` - Gets details about a specific server
- `removeMcpServer(name)` - Removes an MCP server
- `dispose()` - Disposes all active chat sessions

### CodexChat Class

- `sendMessage(List<CodexSdkContent> contents)` - Sends a message and returns the response
- `sendMessageWithSchema({messages, schema})` - Sends a message with a schema for structured response
- `streamResponse(List<CodexSdkContent> contents)` - Streams the response
- `get sessionId` - Gets the current session ID (null until first message)
- `resetConversation()` - Resets the conversation, starting a new session
- `dispose()` - Disposes the chat session and cleans up resources (including temp files)

### CodexSdkContent

- `CodexSdkContent.text(String text)` - Creates text content
- `CodexSdkContent.file(File file)` - Creates file content
- `CodexSdkContent.bytes({data, fileExtension})` - Creates content from bytes (temporary file)

## Environment Variables

You can also set your API key as an environment variable:

```bash
export OPENAI_API_KEY="your-api-key-here"
```

Then use it in your code:

```dart
final apiKey = Platform.environment['OPENAI_API_KEY'] ?? '';
final codexSDK = Codex(apiKey);
```

## Troubleshooting

### Codex CLI not found

If you get a `CLINotFoundException`, make sure Codex CLI is installed:

```bash
npm install -g @openai/codex
```

Or use the SDK's built-in installer:

```dart
await codexSDK.installCodexCLI();
```

### Permission Errors

On Unix-like systems, you might need to use `sudo` for global npm installations:

```bash
sudo npm install -g @openai/codex
```

### Process Cleanup

Always dispose of chat sessions to prevent resource leaks:

```dart
await codexChat.dispose();
// or
await codexSDK.dispose(); // Disposes all sessions
```

### Rate Limits

Be aware of OpenAI's rate limits based on your subscription:
- ChatGPT Plus/Pro/Team users get access through their subscription
- API key users pay per token usage
- Check [OpenAI pricing](https://openai.com/pricing) for current rates

## Examples

Check the `example/` directory for more comprehensive examples:

- `example/basic_usage.dart` - Simple text messaging
- `example/file_analysis.dart` - Analyzing files with Codex
- `example/schema_example.dart` - Using schemas for structured responses
- `example/streaming_example.dart` - Streaming responses
- `example/installation_check.dart` - Checking and installing dependencies
- `example/mcp_management.dart` - Managing MCP servers
- `example/bytes_content_example.dart` - Working with in-memory data
- `example/modes_example.dart` - Using different operation modes

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Open an issue on [GitHub](https://github.com/yourusername/codex_cli_sdk)
- Check the [OpenAI documentation](https://platform.openai.com/docs)
- Visit the [Codex GitHub repository](https://github.com/openai/codex)

## Acknowledgments

- Built on top of the official Codex CLI by OpenAI
- Inspired by the Claude Code SDK and Gemini CLI SDK architectures
- Supports Model Context Protocol (MCP) for extensibility