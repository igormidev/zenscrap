// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:programming_cli_core_sdk/src/cli_chat_interface.dart';
import 'package:programming_cli_core_sdk/src/cli_chat_options_interface.dart';

abstract class CodingCliInterface<
  C extends CliChatInterface,
  O extends CliChatOptions
> {
  /// List of active chat sessions for cleanup
  final List<C> activeSessions = [];

  /// Creates a new chat session with Codex
  ///
  /// [options] - Optional chat configuration options
  /// [apiKey] - Optional API key for this specific chat. If provided, overrides
  ///            any default API key from the SDK instance.
  C createNewChat({O? options, String? apiKey});

  /// Checks if the CLI is installed
  Future<bool> isCodexCLIInstalled();

  /// Installs the CLI using npm
  Future<void> installCodexCLI({bool global = true});

  /// Updates the CLI to the newest version if needed
  Future<void> updateToNewestVersionIfNeeded({bool global = true});

  /// Gets information about the installed SDK
  Future<Map<String, dynamic>> getSDKInfo();

  /// Adds the API key to the environment variables for the current process.
  /// This allows the CLI tool to authenticate without requiring login.
  ///
  /// Each implementation should set the appropriate environment variable:
  /// - Codex: OPENAI_API_KEY
  /// - Claude: ANTHROPIC_API_KEY
  /// - Gemini: GEMINI_API_KEY
  Future<void> addApiKeyToEnvironment(String apiKey);
}

