// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:programming_cli_core_sdk/src/cli_chat_interface.dart';
import 'package:programming_cli_core_sdk/src/cli_chat_options_interface.dart';

abstract class CodingCliInterface<
  C extends CliChatInterface,
  O extends CliChatOptions
> {
  /// The API key for authenticating with the cli provider service.
  /// If null or empty, the CLI will use logged-in credentials if available.
  final String? apiKey;

  CodingCliInterface({this.apiKey});

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

