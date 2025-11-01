import 'dart:io';

/// Helper class to ensure npm is installed in the server environment.
///
/// This is critical for cloud deployments where npm might not be pre-installed
/// but is required for CLI tools like Claude Code that depend on npm packages.
///
/// The installer attempts multiple strategies to install Node.js/npm without
/// requiring sudo privileges, making it suitable for restricted server environments.
class NpmInstaller {
  /// Ensures npm is installed and accessible in the system.
  ///
  /// First checks if npm is already available. If not, attempts to install
  /// it using strategies that don't require sudo (suitable for cloud deployments).
  ///
  /// Throws [Exception] if npm cannot be found or installed.
  static Future<void> ensureNpmInstalled() async {
    print('🔍 Checking npm installation...');

    if (await isNpmInstalled()) {
      final version = await _getNpmVersion();
      print('✓ npm is already installed (version: $version)');
      return;
    }

    print('⚠️  npm is not installed. Attempting automatic installation...');
    print('   Platform: ${Platform.operatingSystem}');

    if (Platform.isLinux || Platform.isMacOS) {
      await _installNpmUnix();
    } else if (Platform.isWindows) {
      throw Exception(
        'npm is not installed. Automatic installation on Windows is not supported.\n'
        'Please install Node.js manually from: https://nodejs.org/\n'
        'Or use WSL/Docker for deployment.',
      );
    } else {
      throw Exception(
        'npm is not installed on unsupported platform: ${Platform.operatingSystem}\n'
        'Please install Node.js manually from: https://nodejs.org/',
      );
    }

    // Verify installation succeeded
    if (!await isNpmInstalled()) {
      throw Exception(
        'npm installation completed but npm is still not accessible.\n'
        'This might be a PATH issue. Please install Node.js manually:\n'
        'https://nodejs.org/ or https://github.com/nvm-sh/nvm',
      );
    }

    final version = await _getNpmVersion();
    print('✓ npm successfully installed (version: $version)');
  }

  /// Checks if npm is installed and accessible via PATH.
  static Future<bool> isNpmInstalled() async {
    try {
      // Try standard npm command
      final result = await Process.run(
        'npm',
        ['--version'],
        runInShell: true,
      ).timeout(
        Duration(seconds: 5),
        onTimeout: () => ProcessResult(0, 1, '', 'timeout'),
      );

      if (result.exitCode == 0) {
        return true;
      }

      // If standard check failed, try with enhanced PATH
      final enhancedPath = _getEnhancedPath();
      final result2 = await Process.run(
        'npm',
        ['--version'],
        runInShell: true,
        environment: {
          ...Platform.environment,
          'PATH': enhancedPath,
        },
      ).timeout(
        Duration(seconds: 5),
        onTimeout: () => ProcessResult(0, 1, '', 'timeout'),
      );

      if (result2.exitCode == 0) {
        // Update global PATH if we found npm with enhanced path
        Platform.environment['PATH'] = enhancedPath;
        return true;
      }

      return false;
    } catch (e) {
      print('   Error checking npm: $e');
      return false;
    }
  }

  /// Gets the installed npm version.
  static Future<String> _getNpmVersion() async {
    try {
      final result = await Process.run(
        'npm',
        ['--version'],
        runInShell: true,
      );
      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
    } catch (_) {}
    return 'unknown';
  }

  /// Returns enhanced PATH with common Node.js installation locations.
  static String _getEnhancedPath() {
    final home = Platform.environment['HOME'] ?? '/root';
    final currentPath = Platform.environment['PATH'] ?? '';

    // Common Node.js installation locations
    final additionalPaths = [
      '$home/n/bin', // n version manager
      '$home/.nvm/versions/node/*/bin', // nvm
      '$home/.local/bin', // user local
      '/usr/local/bin', // system local
      '/opt/homebrew/bin', // macOS Apple Silicon Homebrew
      '/usr/local/opt/node/bin', // macOS Intel Homebrew
    ];

    return '${additionalPaths.join(':')}:$currentPath';
  }

  /// Installs npm on Unix-based systems (Linux/macOS) without requiring sudo.
  ///
  /// Uses the 'n-install' script which installs the 'n' Node.js version manager
  /// and the latest LTS version of Node.js to $HOME/n directory.
  ///
  /// This approach works without sudo and is suitable for cloud deployments.
  static Future<void> _installNpmUnix() async {
    final home = Platform.environment['HOME'] ?? '/root';

    // Check if curl or wget is available
    final hasCurl = await _hasCommand('curl');
    final hasWget = await _hasCommand('wget');

    if (!hasCurl && !hasWget) {
      throw Exception(
        'Neither curl nor wget is available. Cannot download installation script.\n'
        'Please install Node.js manually: https://nodejs.org/',
      );
    }

    print('📥 Downloading and installing Node.js via n-install...');
    print('   Installation directory: $home/n');
    print('   This may take 1-2 minutes...');

    // Use n-install which installs without sudo to $HOME/n
    // -y = auto-confirm
    // -q = quiet mode (less output)
    final downloadCmd = hasCurl
        ? 'curl -fsSL https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install'
        : 'wget -qO- https://raw.githubusercontent.com/mklement0/n-install/stable/bin/n-install';

    final installScript = '$downloadCmd | bash -s -- -y lts';

    try {
      final result = await Process.run(
        '/bin/bash',
        ['-c', installScript],
        environment: {
          ...Platform.environment,
          'HOME': home,
          'N_PREFIX': '$home/n', // Explicit installation prefix
        },
        runInShell: true,
      ).timeout(
        Duration(minutes: 5),
        onTimeout: () {
          throw Exception('Installation timed out after 5 minutes');
        },
      );

      // Log output for debugging
      if (result.stdout.toString().isNotEmpty) {
        print('   Installation output: ${result.stdout.toString().trim()}');
      }

      if (result.exitCode != 0) {
        final stderr = result.stderr.toString().trim();
        print('❌ Installation failed with exit code ${result.exitCode}');
        if (stderr.isNotEmpty) {
          print('   Error: $stderr');
        }
        throw Exception(
          'Failed to install Node.js via n-install. Exit code: ${result.exitCode}',
        );
      }

      // Update PATH for current process and future child processes
      final nBinPath = '$home/n/bin';
      final enhancedPath = _getEnhancedPath();
      Platform.environment['PATH'] = enhancedPath;

      print('✓ Installation script completed successfully');
      print('   Node.js binaries should be at: $nBinPath');

      // Give the system a moment to settle
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      print('❌ Installation error: $e');
      rethrow;
    }
  }

  /// Checks if a command is available in the system.
  static Future<bool> _hasCommand(String command) async {
    try {
      final result = await Process.run(
        'which',
        [command],
        runInShell: true,
      ).timeout(Duration(seconds: 3));
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

}
