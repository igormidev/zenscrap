# Claude Code SDK for Dart

A powerful Dart SDK for interacting with Claude Code, providing seamless integration with AI-powered coding assistance through the Claude Code CLI.

## Features

- 🚀 **Easy Integration**: Simple API for creating chat sessions with Claude
- 📁 **File Support**: Send files along with text prompts for context-aware responses
- 💾 **Bytes Support**: Send in-memory data as temporary files (auto-cleanup on dispose)
- 📋 **Schema Support**: Get structured responses using JSON schemas
- 🔄 **Session Management**: Automatic conversation continuity with --resume flag
- 🛠️ **Auto-Installation**: Built-in methods to check and install Claude Code SDK
- 🔌 **MCP Support**: Full Model Context Protocol integration for connecting to external tools
- 🧹 **Resource Management**: Proper cleanup and disposal of chat sessions and temp files
- 🔐 **Secure**: API key management with environment variable support
- ⚡ **Reliable**: Simple Process.run based implementation (no streaming complexity)

## Prerequisites

Before using this SDK, you need:

1. **Node.js and npm** (for Claude Code CLI)
   - Download from [nodejs.org](https://nodejs.org/)
   
2. **Claude Code CLI**
   - Install globally: `npm install -g @anthropic-ai/claude-code`
   - Or use the SDK's built-in installer (see below)

3. **Anthropic API Key**
   - Get your API key from [Anthropic Console](https://console.anthropic.com/)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  claude_code_sdk: ^2.1.0
```

Then run:

```bash
dart pub get
```

## Available Models

As of version 2.0.0, the SDK supports the latest Claude models:

### Claude 4 Family (Latest - Recommended)
- **Claude Sonnet 4** (`claude-sonnet-4-20250514`) - Default model, balanced performance
- **Claude Opus 4** (`claude-opus-4-20250514`) - Most powerful, best for complex tasks
- **Claude Opus 4.1** (`claude-opus-4-1-20250805`) - Latest incremental update with enhanced capabilities

### Claude 3.7 Family
- **Claude 3.7 Sonnet** (`claude-3-7-sonnet-20250219`) - Hybrid reasoning model with step-by-step thinking

### Claude 3.5 Family
- **Claude 3.5 Sonnet** (`claude-3-5-sonnet-20241022`) - Fast and smart
- **Claude 3.5 Haiku** (`claude-3-5-haiku-20241022`) - Ultra-fast responses

### Claude 3 Family (Legacy)
- **Claude 3 Opus** (`claude-3-opus-20240229`) - Powerful but older
- **Claude 3 Sonnet** (`claude-3-sonnet-20240229`) - Balanced but older
- **Claude 3 Haiku** (`claude-3-haiku-20240307`) - Fast but older

**Note**: Claude Sonnet 4 is the default model as of v2.0.0, offering the best balance of performance, cost, and capabilities.

## Quick Start

### Basic Usage

```dart
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  // Initialize the SDK with your API key
  final claudeSDK = Claude('YOUR_API_KEY');
  
  // Create a new chat session
  final claudeChat = claudeSDK.createNewChat();
  
  try {
    // Send a simple text message
    final result = await claudeChat.sendMessage([
      ClaudeSdkContent.text('What is the capital of France?'),
    ]);
    
    print('Claude says: $result');
  } finally {
    // Always dispose of the chat when done
    await claudeChat.dispose();
  }
}
```

### Sending Files with Messages

```dart
import 'dart:io';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  final claudeSDK = Claude('YOUR_API_KEY');
  final claudeChat = claudeSDK.createNewChat();
  
  try {
    // Send a message with a file
    final result = await claudeChat.sendMessage([
      ClaudeSdkContent.text('Please analyze this HTML file and extract the user name'),
      ClaudeSdkContent.file(File('example.html')),
    ]);
    
    print('Analysis result: $result');
  } finally {
    await claudeChat.dispose();
  }
}
```

### Sending Bytes as Temporary Files

You can send in-memory data (like images, documents, or any binary data) without creating permanent files:

```dart
import 'dart:typed_data';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  final claudeSDK = Claude('YOUR_API_KEY');
  final claudeChat = claudeSDK.createNewChat();
  
  try {
    // Example 1: Send image bytes
    final imageBytes = await File('photo.jpg').readAsBytes();
    final result = await claudeChat.sendMessage([
      ClaudeSdkContent.text('What is in this image?'),
      ClaudeSdkContent.bytes(
        data: imageBytes,
        fileExtension: 'jpg',
      ),
    ]);
    
    // Example 2: Send text as bytes
    final textContent = 'Hello, this is dynamic content!';
    final textBytes = Uint8List.fromList(textContent.codeUnits);
    final result2 = await claudeChat.sendMessage([
      ClaudeSdkContent.text('Read this text:'),
      ClaudeSdkContent.bytes(
        data: textBytes,
        fileExtension: 'txt',
      ),
    ]);
    
    print('Result: $result2');
  } finally {
    // Temporary files are automatically deleted when disposed
    await claudeChat.dispose();
  }
}
```

**Note:** Temporary files created from bytes are automatically cleaned up when you call `dispose()` on the chat session.

### Using Schemas for Structured Responses

```dart
import 'dart:io';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  final claudeSDK = Claude('YOUR_API_KEY');
  final claudeChat = claudeSDK.createNewChat();
  
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
      // No need to specify 'required' array - it's automatically derived from nullable properties
    );
    
    // Send message with schema
    final result = await claudeChat.sendMessageWithSchema(
      messages: [
        ClaudeSdkContent.text('Extract user information from this HTML file'),
        ClaudeSdkContent.file(File('profile.html')),
      ],
      schema: schema,
    );
    
    print('Model message: ${result.llmMessage}');
    print('Extracted data: ${result.structuredSchemaData}');
    
    // Access specific fields
    final userName = result.structuredSchemaData['userName'];
    print('User name: $userName');
  } finally {
    await claudeChat.dispose();
  }
}
```

### Streaming Responses

```dart
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  final claudeSDK = Claude('YOUR_API_KEY');
  final claudeChat = claudeSDK.createNewChat(
    options: ClaudeChatOptions(
      streamJson: true,
    ),
  );
  
  try {
    // Stream the response
    await for (final chunk in claudeChat.streamResponse([
      ClaudeSdkContent.text('Write a detailed explanation of quantum computing'),
    ])) {
      print(chunk); // Print each chunk as it arrives
    }
  } finally {
    await claudeChat.dispose();
  }
}
```

## Advanced Configuration

### Chat Options

```dart
final claudeChat = claudeSDK.createNewChat(
  options: ClaudeChatOptions(
    systemPrompt: 'You are a helpful coding assistant',
    maxTurns: 5,
    allowedTools: ['Read', 'Write', 'Bash'],
    permissionMode: 'acceptEdits',
    cwd: '/path/to/project',
    model: 'claude-sonnet-4-20250514',  // Or omit for default (Sonnet 4)
    outputJson: true,
    timeoutMs: 30000,
  ),
);
```

### Checking and Installing Claude Code SDK

```dart
void main() async {
  final claudeSDK = Claude('YOUR_API_KEY');
  
  // Check if Claude Code SDK is installed
  final isInstalled = await claudeSDK.isClaudeCodeSDKInstalled();
  
  if (!isInstalled) {
    print('Claude Code SDK is not installed. Installing...');
    
    try {
      // Install the SDK globally
      await claudeSDK.installClaudeCodeSDK(global: true);
      print('Installation complete!');
    } catch (e) {
      print('Installation failed: $e');
    }
  }
  
  // Get SDK information
  final info = await claudeSDK.getSDKInfo();
  print('SDK Info: $info');
}
```

### Auto-Update SDK

The SDK provides a convenient method to automatically check for and install updates:

```dart
void main() async {
  final claudeSDK = Claude('YOUR_API_KEY');

  // Automatically check for updates and install if needed
  await claudeSDK.updateToNewestVersionIfNeeded(global: true);

  // The function will:
  // 1. Check if CLI is installed (installs if not)
  // 2. Compare current version with latest npm version
  // 3. Update if a newer version is available
  // 4. Also updates Python SDK if installed
}
```

## MCP (Model Context Protocol) Support

The SDK provides comprehensive support for MCP, allowing Claude to connect to external tools and services.

### Checking MCP Installation

```dart
final mcpInfo = await claudeSDK.isMcpInstalled();
print('MCP enabled: ${mcpInfo.hasMcpSupport}');
print('Configured servers: ${mcpInfo.servers.length}');

for (final server in mcpInfo.servers) {
  print('  - ${server.name}: ${server.status}');
}
```

### Installing Popular MCP Servers

```dart
// Install filesystem MCP server
await claudeSDK.installPopularMcpServer('filesystem');

// Install GitHub MCP with environment variables
await claudeSDK.installPopularMcpServer('github', 
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

await claudeSDK.addMcpServer(
  'my-custom-server',
  customServer: customServer,
);

// Or add an npm package as MCP server
await claudeSDK.addMcpServer(
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
final servers = await claudeSDK.listMcpServers();

// Get details about a specific server
final details = await claudeSDK.getMcpServerDetails('filesystem');

// Remove a server
await claudeSDK.removeMcpServer('my-custom-server');
```

### Using MCP in Chat Sessions

Once MCP servers are configured, they're automatically available in chat sessions:

```dart
final chat = claudeSDK.createNewChat();

// Claude can now use the configured MCP tools
final result = await chat.sendMessage([
  ClaudeSdkContent.text(
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
  // The 'required' array is automatically generated from nullable: false properties
  description: 'User information schema',
);
```

### Nullable Property Behavior

- `nullable: false` - The property is required and must be present in the response
- `nullable: true` (default) - The property is optional and may be omitted or null
- Properties with `nullable: false` are automatically added to the JSON schema's `required` array
- You can still use the legacy `required` parameter on SchemaObject for backward compatibility

## Error Handling

The SDK provides specific exception types for different error scenarios:

```dart
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  final claudeSDK = Claude('YOUR_API_KEY');
  final claudeChat = claudeSDK.createNewChat();
  
  try {
    final result = await claudeChat.sendMessage([
      ClaudeSdkContent.text('Hello, Claude!'),
    ]);
    print(result);
  } on CLINotFoundException {
    print('Claude Code CLI is not installed. Please install it first.');
  } on ProcessException catch (e) {
    print('Process error: ${e.message}');
    if (e.exitCode != null) {
      print('Exit code: ${e.exitCode}');
    }
  } on JSONDecodeException catch (e) {
    print('Failed to parse response: ${e.message}');
  } on ClaudeSDKException catch (e) {
    print('SDK error: ${e.message}');
  } finally {
    await claudeChat.dispose();
  }
}
```

## Implementation Details

This SDK uses a simple and reliable approach:
- **Process.run**: Each message is sent as a separate process call (no streaming complexity)
- **Session Management**: Uses Claude CLI's `--resume` flag for conversation continuity
- **JSON Output**: Always uses `--output-format json` for consistent parsing
- **Automatic Fallback**: Tries `claude` command first, falls back to `claude-code` if needed

## Resource Management

### Important: Always Dispose Chat Sessions

Always dispose of chat sessions when done to ensure proper cleanup:

```dart
// Method 1: Using try-finally
final chat = claudeSDK.createNewChat();
try {
  // Use the chat
  await chat.sendMessage([...]);
} finally {
  await chat.dispose();
}

// Method 2: Dispose all sessions at once
await claudeSDK.dispose(); // Disposes all active sessions
```

## API Reference

### Claude Class

- `Claude(String apiKey)` - Creates a new SDK instance
- `createNewChat({ClaudeChatOptions? options})` - Creates a new chat session
- `isClaudeCodeSDKInstalled()` - Checks if Claude Code CLI is installed
- `installClaudeCodeSDK({bool global = true})` - Installs the Claude Code SDK
- `updateToNewestVersionIfNeeded({bool global = true})` - Updates SDK to newest version if available
- `getSDKInfo()` - Gets information about installed SDKs
- `dispose()` - Disposes all active chat sessions

### ClaudeChat Class

- `sendMessage(List<ClaudeSdkContent> contents)` - Sends a message and returns the response
- `sendMessageWithSchema({messages, schema})` - Returns a record with the LLM summary and parsed structured data
- `get sessionId` - Gets the current session ID (null until first message)
- `resetConversation()` - Resets the conversation, starting a new session
- `dispose()` - Disposes the chat session and cleans up resources (including temp files)

### ClaudeSdkContent

- `ClaudeSdkContent.text(String text)` - Creates text content
- `ClaudeSdkContent.file(File file)` - Creates file content
- `ClaudeSdkContent.bytes({data, fileExtension})` - Creates content from bytes (temporary file)

## Environment Variables

You can also set your API key as an environment variable:

```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

Then use it in your code:

```dart
final apiKey = Platform.environment['ANTHROPIC_API_KEY'] ?? '';
final claudeSDK = Claude(apiKey);
```

## Troubleshooting

### Claude Code CLI not found

If you get a `CLINotFoundException`, make sure Claude Code is installed:

```bash
npm install -g @anthropic-ai/claude-code
```

Or use the SDK's built-in installer:

```dart
await claudeSDK.installClaudeCodeSDK();
```

### Permission Errors

On Unix-like systems, you might need to use `sudo` for global npm installations:

```bash
sudo npm install -g @anthropic-ai/claude-code
```

### Process Cleanup

Always dispose of chat sessions to prevent resource leaks:

```dart
await claudeChat.dispose();
// or
await claudeSDK.dispose(); // Disposes all sessions
```

## Examples

Check the `example/` directory for more comprehensive examples:

- `example/basic_usage.dart` - Simple text messaging
- `example/file_analysis.dart` - Analyzing files with Claude
- `example/schema_example.dart` - Using schemas for structured responses
- `example/streaming_example.dart` - Streaming responses
- `example/installation_check.dart` - Checking and installing dependencies

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Open an issue on [GitHub](https://github.com/yourusername/claude_code_sdk)
- Check the [Anthropic documentation](https://docs.anthropic.com/)
- Visit the [Claude Code documentation](https://docs.anthropic.com/en/docs/claude-code)

## Acknowledgments

- Built on top of the official Claude Code CLI by Anthropic
- Inspired by the Python and TypeScript SDKs
