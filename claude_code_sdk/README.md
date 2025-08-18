# Claude Code SDK for Dart

A powerful Dart SDK for interacting with Claude Code, providing seamless integration with AI-powered coding assistance through the Claude Code CLI.

## Features

- 🚀 **Easy Integration**: Simple API for creating chat sessions with Claude
- 📁 **File Support**: Send files along with text prompts for context-aware responses
- 📋 **Schema Support**: Get structured responses using JSON schemas
- 🔄 **Streaming**: Real-time streaming of Claude's responses
- 🛠️ **Auto-Installation**: Built-in methods to check and install Claude Code SDK
- 🧹 **Resource Management**: Proper cleanup and disposal of chat sessions
- 🔐 **Secure**: API key management with environment variable support

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
  claude_code_sdk: ^1.0.0
```

Then run:

```bash
dart pub get
```

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

### Using Schemas for Structured Responses

```dart
import 'dart:io';
import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  final claudeSDK = Claude('YOUR_API_KEY');
  final claudeChat = claudeSDK.createNewChat();
  
  try {
    // Define a schema for the response
    final schema = SchemaObject(
      properties: {
        'userName': SchemaProperty.string(
          description: 'The name of the user found in the HTML',
        ),
        'userEmail': SchemaProperty.string(
          description: 'The email of the user if found',
        ),
        'userRole': SchemaProperty.string(
          description: 'The role or title of the user',
        ),
      },
      required: ['userName'],
    );
    
    // Send message with schema
    final result = await claudeChat.sendMessageWithSchema(
      messages: [
        ClaudeSdkContent.text('Extract user information from this HTML file'),
        ClaudeSdkContent.file(File('profile.html')),
      ],
      schema: schema,
    );
    
    print('Model message: ${result.modelMessage}');
    print('Extracted data: ${result.data}');
    
    // Access specific fields
    final userName = result.data['userName'];
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
    model: 'claude-3.5-sonnet',
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

## Schema Building

The SDK provides convenient factory methods for building schemas:

```dart
final schema = SchemaObject(
  properties: {
    'name': SchemaProperty.string(
      description: 'User name',
      defaultValue: 'Anonymous',
    ),
    'age': SchemaProperty.number(
      description: 'User age',
    ),
    'isActive': SchemaProperty.boolean(
      description: 'Whether the user is active',
      defaultValue: true,
    ),
    'tags': SchemaProperty.array(
      items: SchemaProperty.string(),
      description: 'List of tags',
    ),
    'metadata': SchemaProperty.object(
      properties: {
        'created': SchemaProperty.string(),
        'updated': SchemaProperty.string(),
      },
      description: 'Metadata object',
    ),
  },
  required: ['name', 'age'],
  description: 'User information schema',
);
```

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
- `getSDKInfo()` - Gets information about installed SDKs
- `dispose()` - Disposes all active chat sessions

### ClaudeChat Class

- `sendMessage(List<ClaudeSdkContent> contents)` - Sends a message and returns the response
- `sendMessageWithSchema({messages, schema})` - Sends a message with a schema for structured response
- `streamResponse(List<ClaudeSdkContent> contents)` - Streams the response
- `dispose()` - Disposes the chat session and cleans up resources

### ClaudeSdkContent

- `ClaudeSdkContent.text(String text)` - Creates text content
- `ClaudeSdkContent.file(File file)` - Creates file content

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
