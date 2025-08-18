import 'dart:io';

import 'claude_chat.dart';
import 'exceptions/claude_exceptions.dart';
import 'models/chat_options.dart';

/// Main Claude SDK class for interacting with Claude Code
class Claude {
  /// The API key for authenticating with Claude
  final String apiKey;

  /// List of active chat sessions for cleanup
  final List<ClaudeChat> _activeSessions = [];

  /// Creates a new Claude SDK instance
  Claude(this.apiKey) {
    if (apiKey.isEmpty) {
      throw ClaudeSDKException('API key cannot be empty');
    }
  }

  /// Creates a new chat session with Claude
  ClaudeChat createNewChat({ClaudeChatOptions? options}) {
    final chat = ClaudeChat(
      apiKey: apiKey,
      options: options,
    );
    _activeSessions.add(chat);
    return chat;
  }

  /// Checks if Claude Code SDK is installed
  Future<bool> isClaudeCodeSDKInstalled() async {
    try {
      // Try claude first (the actual command that works)
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('claude --version'),
      );
      
      if (result.exitCode == 0) {
        return true;
      }
      
      // Fallback to claude-code if claude doesn't work
      final result2 = await Process.run(
        _getShellCommand(),
        _getShellArgs('claude-code --version'),
      );
      
      return result2.exitCode == 0;
    } catch (e) {
      // If we can't run the command, assume it's not installed
      return false;
    }
  }

  /// Installs the Claude Code SDK using npm
  Future<void> installClaudeCodeSDK({bool global = true}) async {
    // Check if npm is installed first
    final npmInstalled = await _isNpmInstalled();
    if (!npmInstalled) {
      throw ClaudeSDKException(
        'npm is not installed. Please install Node.js and npm first.\n'
        'Visit https://nodejs.org/ to download and install Node.js.',
      );
    }

    print('Installing Claude Code SDK...');

    final command = global
        ? 'npm install -g @anthropic-ai/claude-code'
        : 'npm install @anthropic-ai/claude-code';

    try {
      final process = await Process.start(
        _getShellCommand(),
        _getShellArgs(command),
      );

      // Stream output to console
      process.stdout.listen((data) {
        stdout.write(String.fromCharCodes(data));
      });

      process.stderr.listen((data) {
        stderr.write(String.fromCharCodes(data));
      });

      final exitCode = await process.exitCode;

      if (exitCode != 0) {
        throw ProcessException(
          'Failed to install Claude Code SDK',
          exitCode: exitCode,
        );
      }

      print('\nClaude Code SDK installed successfully!');

      // Also check if Python SDK needs to be installed
      await _checkAndInstallPythonSDK();
    } catch (e) {
      throw ProcessException(
        'Failed to install Claude Code SDK: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Checks and installs Python SDK if needed
  Future<void> _checkAndInstallPythonSDK() async {
    print('\nChecking Python SDK...');

    // Check if pip is available
    final pipInstalled = await _isPipInstalled();
    if (!pipInstalled) {
      print('pip is not installed. Python SDK installation skipped.');
      print(
          'To use all features, install Python and pip, then run: pip install claude-code-sdk');
      return;
    }

    // Check if claude-code-sdk is already installed
    final pythonSdkInstalled = await _isPythonSDKInstalled();
    if (pythonSdkInstalled) {
      print('Python SDK is already installed.');
      return;
    }

    print('Installing Python SDK...');

    try {
      final process = await Process.start(
        _getShellCommand(),
        _getShellArgs('pip install claude-code-sdk'),
      );

      process.stdout.listen((data) {
        stdout.write(String.fromCharCodes(data));
      });

      process.stderr.listen((data) {
        stderr.write(String.fromCharCodes(data));
      });

      final exitCode = await process.exitCode;

      if (exitCode != 0) {
        print('Warning: Failed to install Python SDK.');
        print(
            'You can manually install it later with: pip install claude-code-sdk');
      } else {
        print('Python SDK installed successfully!');
      }
    } catch (e) {
      print('Warning: Failed to install Python SDK: $e');
      print(
          'You can manually install it later with: pip install claude-code-sdk');
    }
  }

  /// Checks if npm is installed
  Future<bool> _isNpmInstalled() async {
    try {
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('npm --version'),
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Checks if pip is installed
  Future<bool> _isPipInstalled() async {
    try {
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('pip --version'),
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Checks if Python SDK is installed
  Future<bool> _isPythonSDKInstalled() async {
    try {
      final result = await Process.run(
        _getShellCommand(),
        _getShellArgs('pip show claude-code-sdk'),
      );
      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Gets the appropriate shell command for the platform
  String _getShellCommand() {
    return Platform.isWindows ? 'cmd' : 'sh';
  }

  /// Gets the appropriate shell arguments for the platform
  List<String> _getShellArgs(String command) {
    if (Platform.isWindows) {
      return ['/c', command];
    } else {
      return ['-c', command];
    }
  }

  /// Disposes all active chat sessions
  Future<void> dispose() async {
    for (final session in _activeSessions) {
      if (!session.isDisposed) {
        await session.dispose();
      }
    }
    _activeSessions.clear();
  }

  /// Gets information about the Claude Code SDK installation
  Future<Map<String, dynamic>> getSDKInfo() async {
    final info = <String, dynamic>{};

    // Check Claude Code CLI
    info['claude_cli_installed'] = await isClaudeCodeSDKInstalled();

    if (info['claude_cli_installed'] == true) {
      try {
        final versionResult = await Process.run(
          _getShellCommand(),
          _getShellArgs('claude --version'),
        );
        if (versionResult.exitCode == 0) {
          info['claude_cli_version'] = versionResult.stdout.toString().trim();
        }
      } catch (_) {}
    }

    // Check npm
    info['npm_installed'] = await _isNpmInstalled();
    if (info['npm_installed'] == true) {
      try {
        final npmResult = await Process.run(
          _getShellCommand(),
          _getShellArgs('npm --version'),
        );
        if (npmResult.exitCode == 0) {
          info['npm_version'] = npmResult.stdout.toString().trim();
        }
      } catch (_) {}
    }

    // Check Python SDK
    info['python_sdk_installed'] = await _isPythonSDKInstalled();
    if (info['python_sdk_installed'] == true) {
      try {
        final pythonResult = await Process.run(
          _getShellCommand(),
          _getShellArgs('pip show claude-code-sdk'),
        );
        if (pythonResult.exitCode == 0) {
          final output = pythonResult.stdout.toString();
          final versionMatch = RegExp(r'Version: (.+)').firstMatch(output);
          if (versionMatch != null) {
            info['python_sdk_version'] = versionMatch.group(1)?.trim();
          }
        }
      } catch (_) {}
    }

    // Check pip
    info['pip_installed'] = await _isPipInstalled();

    return info;
  }
}