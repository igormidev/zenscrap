import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

Future<ProcessResult> runAndPrint(
  String executable,
  List<String> args, {
  Map<String, String>? environment,
  String? workingDirectory,
}) async {
  final result = await Process.run(
    executable,
    args,
    environment: environment,
    workingDirectory: workingDirectory,
  );
  // Mirror outputs to the test log:
  if (result.stdout != null && result.stdout.toString().isNotEmpty) {
    // ignore: avoid_print
    print(result.stdout);
  }
  if (result.stderr != null && result.stderr.toString().isNotEmpty) {
    // ignore: avoid_print
    print(result.stderr);
  }
  return result;
}

void main() {
  test('Codex exec via stdin API-key login', () async {
    // 1) Provide your key here (or read from env/CI secret)

    final codexApiKey =
        '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';
    if (codexApiKey.isEmpty) {
      fail(
        'Set CODEX_TEST_API_KEY in your environment (or replace the read above).',
      );
    }

    // 2) Isolate Codex state so we don’t pollute ~/.codex
    final tmp = await Directory.systemTemp.createTemp('codex_cli_test_');
    final codeXHome = Directory('${tmp.path}/.codex')
      ..createSync(recursive: true);

    // Build a clean env but keep PATH so we can find `codex`
    final env = <String, String>{
      'CODEX_HOME': codeXHome.path,
      'HOME': tmp.path, // some flows still read $HOME
      // Hard-disable any parent OPENAI_* that might interfere:
      'OPENAI_API_KEY': '',
      'AZURE_OPENAI_API_KEY': '',
    };

    // 3) Login non-interactively: pipe the key into `codex login --with-api-key`
    final loginProc = await Process.start(
      'codex',
      ['login', '--with-api-key'],
      environment: {
        ...Platform.environment, // keep PATH, etc.
        ...env,
      },
    );

    // Write the API key to stdin (no trailing spaces)
    loginProc.stdin
      ..write(codexApiKey)
      ..close();

    // Collect outputs to aid debugging
    final loginStdout = loginProc.stdout.transform(utf8.decoder).join();
    final loginStderr = loginProc.stderr.transform(utf8.decoder).join();
    final loginExit = await loginProc.exitCode;
    // ignore: avoid_print
    print('--- codex login stdout ---\n${await loginStdout}');
    // ignore: avoid_print
    print('--- codex login stderr ---\n${await loginStderr}');
    expect(loginExit, 0, reason: 'codex login failed');

    // 4) Run a non-interactive exec and print the final message to stdout
    final exec = await runAndPrint(
      'codex',
      ['exec', 'Hello!'],
      environment: {
        ...Platform.environment,
        ...env,
      },
      workingDirectory: Directory.current.path,
    );

    // 0 = success; CLI now prints only the final message to stdout in recent versions
    // (see 0.45.0 notes)
    expect(exec.exitCode, 0, reason: 'codex exec failed');
  }, timeout: const Timeout(Duration(minutes: 3)));

  test(
    'Current way codex cli is running',
    () async {
      final codexApiKey =
          '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';
      // The prompt to send
      final prompt = 'Hello!';

      // Run the codex CLI
      final result = await Process.run(
        'codex',
        ['exec', prompt],
        environment: {'OPENAI_API_KEY': codexApiKey},
        includeParentEnvironment: true,
      );

      // Print output to help debug / inspect
      print('--- codex exec stdout ---');
      print(result.stdout);
      print('--- codex exec stderr ---');
      print(result.stderr);
      print('--- codex exitCode ---');
      print(result.exitCode);

      // Assert success
      expect(result.exitCode, equals(0),
          reason: 'codex exec failed: ${result.stderr}');

      // Optionally assert non-empty response
      final out = (result.stdout ?? '').toString().trim();
      expect(out.isNotEmpty, isTrue, reason: 'codex stdout was empty');
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
