# Gemini CLI SDK for Dart

A powerful Dart SDK for interacting with Google Gemini CLI, providing seamless integration with AI-powered coding assistance through the Gemini CLI tool.

## Features

- 🚀 **Shared Core**: Built on top of `programming_cli_core_sdk` for consistent streaming, schema, and file workflows across Codex, Claude, and Gemini.
- 📁 **File Support**: Attach local files or in-memory bytes through the shared `PromptContent` helpers.
- 📋 **Schema Orchestration**: Generate structured responses that are automatically validated against JSON schemas.
- 🔌 **MCP Management**: Inspect and configure Model Context Protocol servers using the shared MCP models.
- 🌊 **Streaming**: Stream Gemini responses while the core handles cleanup and schema validation.
- 🛠️ **CLI Utilities**: Check, install, and upgrade the Gemini CLI with convenience helpers.
- 🔐 **Secure**: Isolated environment per API key prevents credential leakage.

## Prerequisites

1. **Node.js and npm** (for Gemini CLI)
   - Download from [nodejs.org](https://nodejs.org/)

2. **Gemini CLI**
   - Install globally: `npm install -g @google/gemini-cli`
   - Or use the SDK's `installGeminiCLI()` helper

3. **Gemini API Key** (Optional)
   - Create one in [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Or sign in to Gemini CLI with: `gemini login`
   - Or export it as `GEMINI_API_KEY` environment variable

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  gemini_cli_sdk: ^3.0.0
```

Then run `dart pub get`.

## Architecture Overview

As of v3.0.0 the Gemini SDK is a thin implementation on top of `programming_cli_core_sdk`. The core package provides:

- `PromptContent` for text, file, bytes, and JSON prompts
- Process orchestration, streaming, and schema validation
- Shared MCP models and CLI helpers

`GeminiChat` is responsible only for constructing the Gemini CLI command and interpreting its output. This keeps the behaviour aligned with the Codex and Claude SDKs.

## Quick Start

### Authentication Options

The SDK supports three authentication methods:

**Option 1: Use CLI Login (Recommended for Development)**
```dart
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

Future<void> main() async {
  // No API key needed - uses existing CLI authentication
  final gemini = Gemini();

  final chat = gemini.createNewChat();
  // ... use the chat
}
```

**Option 2: Provide API Key to SDK**
```dart
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

Future<void> main() async {
  // API key applies to all chats from this SDK instance
  final gemini = Gemini(apiKey: 'YOUR_API_KEY');

  final chat = gemini.createNewChat();
  // ... use the chat
}
```

**Option 3: Provide API Key Per Chat**
```dart
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

Future<void> main() async {
  final gemini = Gemini(apiKey: 'DEFAULT_KEY');

  // This chat uses the SDK's default key
  final chat1 = gemini.createNewChat();

  // This chat overrides with a different key
  final chat2 = gemini.createNewChat(apiKey: 'SPECIAL_KEY');

  // ... use the chats
}
```

### Basic Usage

```dart
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

Future<void> main() async {
  // Initialize the SDK (API key is optional)
  final gemini = Gemini(apiKey: 'YOUR_API_KEY');
  final chat = gemini.createNewChat(
    options: const GeminiChatOptions(
      model: 'gemini-2.5-flash',
      allowedTools: ['*'],
      allowedMcpServerNames: ['playwright'],
    ),
  );

  try {
    final reply = await chat.sendMessage([
      PromptContent.text('What is the capital of France?'),
    ]);

    print('Gemini: $reply');
  } finally {
    await chat.dispose();
    await gemini.dispose();
  }
}
```

### Sending Files

```dart
final response = await chat.sendMessage([
  PromptContent.text('Summarise the findings in this report'),
  PromptContent.file(File('report.md')),
]);
```

### Structured Responses with JSON Schema

```dart
final schema = SchemaDefinition.object(
  properties: {
    'company': SchemaProperty.string(nullable: false),
    'revenue': SchemaProperty.number(nullable: false),
  },
);

final result = await chat.sendMessageWithSchema(
  messages: [
    PromptContent.text('Extract the company name and revenue from this article.'),
    PromptContent.file(File('article.html')),
  ],
  schema: schema,
);

print(result.llmMessage);
print(result.structuredSchemaData);
```

### Streaming Responses

```dart
final stream = chat.streamResponse([
  PromptContent.text('Explain the Gemini CLI in bullet points'),
]);

await for (final chunk in stream) {
  stdout.write(chunk);
}
```

## GeminiChatOptions

`GeminiChatOptions` controls how the CLI is invoked. Common fields include:

- `model`: Gemini model identifier (`gemini-2.5-flash`, `gemini-2.5-pro`, etc.)
- `allowedTools`: Explicit tool whitelist passed via `--allowed-tools`
- `allowedMcpServerNames`: MCP servers Gemini may call (`--allowed-mcp-server-names`)
- `approvalMode`: Tool approval strategy (`--approval-mode`)
- `repeatSystemPrompt`: Reuse the system prompt on every turn
- `resumeSessionId`: Resume a previous Gemini CLI session
- `additionalArgs`: Extra CLI flags forwarded verbatim

All options extend `CliChatOptions`, so `systemPrompt`, `model`, and `cwd` are shared across SDKs.

## MCP Helpers

```dart
final gemini = Gemini(apiKey: 'YOUR_API_KEY');

final mcpInfo = await gemini.isMcpInstalled();
print('MCP available: ${mcpInfo.hasMcpSupport}');

await gemini.installPopularMcpServer(
  'filesystem',
  environment: {'ROOT': '/Users/me/Projects'},
);

final servers = await gemini.listMcpServers();
for (final server in servers) {
  print('Configured MCP: ${server.name} -> ${server.command} ${server.args.join(' ')}');
}
```

## CLI Management

```dart
final gemini = Gemini(apiKey: 'YOUR_API_KEY');

final installed = await gemini.isGeminiCLIInstalled();
if (!installed) {
  await gemini.installGeminiCLI();
}

await gemini.updateToNewestVersionIfNeeded();
final info = await gemini.getSDKInfo();
print(info);
```

## Migration Notes (v3.0.0)

- Use `PromptContent` instead of `GeminiSdkContent`.
- Catch `CliException` instead of `GeminiSDKException`.
- Import `gemini_cli_sdk.dart` to gain access to the shared core exports.
- `GeminiChatOptions` now aligns with the options used by the Codex and Claude SDKs.

## License

MIT
