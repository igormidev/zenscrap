// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:programming_cli_core_sdk/src/cli_chat_interface.dart';
import 'package:programming_cli_core_sdk/src/cli_exception.dart';

abstract class CodingCliInterface<
  C extends CliChatInterface,
  O extends CliChatOptions
> {
  /// The API key for authenticating with the cli provider service
  final String apiKey;

  CodingCliInterface({required this.apiKey}) {
    if (apiKey.isEmpty) throw CliException('API key cannot be empty');
  }

  /// List of active chat sessions for cleanup
  final List<C> activeSessions = [];

  /// Creates a new chat session with Codex
  C createNewChat({O? options});

  /// Checks if the CLI is installed
  Future<bool> isCodexCLIInstalled();

  /// Installs the CLI using npm
  Future<void> installCodexCLI({bool global = true});

  /// Updates the CLI to the newest version if needed
  Future<void> updateToNewestVersionIfNeeded({bool global = true});

  /// Gets information about the installed SDK
  Future<Map<String, dynamic>> getSDKInfo();
}

abstract class CliChatOptions {
  /// Max Timeout to run the cli
  final Duration timeout = const Duration(minutes: 30);

  /// System prompt to set the context for Codex
  final String? systemPrompt;

  /// Model to use (e.g., 'gpt-5', 'codex-mini-latest')
  final String? model;

  /// Working directory for file operations
  final String? cwd;

  const CliChatOptions({this.systemPrompt, this.model, this.cwd});
}
