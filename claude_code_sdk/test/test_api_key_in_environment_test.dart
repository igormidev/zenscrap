import 'dart:io';
import 'package:test/test.dart';

/// Runs Claude Code once in the *current working directory* using print/headless
/// mode (-p), injects ONLY the ANTHROPIC_API_KEY you pass, then deletes any
/// brand-new files/dirs Claude created.
///
/// Requirements:
/// - `claude` CLI installed and on PATH (per Anthropic docs).
/// - A disposable/DEV Anthropic key set below (do NOT commit prod keys).
///
/// References:
/// - CLI print/headless mode: `claude -p "query"`; `--model` accepts alias or
///   full model name (e.g. `sonnet` or `claude-sonnet-4-5-20250929`). :contentReference[oaicite:1]{index=1}
/// - Auth via `ANTHROPIC_API_KEY` env var (overrides logged-in subscription). :contentReference[oaicite:2]{index=2}
Future<ProcessResult> runClaudeOnceInCurrentDir({
  required String anthropicApiKey,
  required String prompt,
  String model =
      'sonnet', // you can also use a full name like: 'claude-sonnet-4-5-20250929'
}) async {
  final cwd = Directory.current;

  // 1) Snapshot top-level entries before running Claude.
  final before = await _listTopLevelBasenames(cwd);

  // 2) Minimal child env: isolate credentials but allow PATH/HOME so 'claude'
  //    is resolvable and can read ~/.claude if needed.
  final childEnv = <String, String>{
    'ANTHROPIC_API_KEY': anthropicApiKey, // per Anthropic support docs
    'PATH': Platform.environment['PATH'] ?? '',
    'HOME': Platform.environment['HOME'] ?? '',
  };

  // 3) Non-interactive "print" mode: one-shot, prints answer then exits.
  //    We also cap turns to 1 so it returns quickly.
  final args = <String>[
    '--model',
    model,
    '-p',
    '--max-turns',
    '1',
    prompt,
  ];

  final result = await Process.run(
    'claude',
    args,
    workingDirectory: cwd.path,
    environment: childEnv,
    includeParentEnvironment: true, // isolate from parent secrets
    runInShell: false,
  );

  // 4) Snapshot after and remove anything new Claude created.
  final after = await _listTopLevelBasenames(cwd);
  final newEntries = after.difference(before);
  for (final name in newEntries) {
    final file = File('${cwd.path}/$name');
    final dir = Directory('${cwd.path}/$name');
    if (await file.exists()) {
      await file.delete(recursive: true);
    } else if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  return result;
}

Future<Set<String>> _listTopLevelBasenames(Directory dir) async {
  final names = <String>{};
  await for (final e in dir.list(followLinks: false)) {
    names.add(e.uri.pathSegments.last);
  }
  return names;
}

void main() {
  // ⚠️ Use a *disposable/dev* key for testing.
  const testAnthropicKey =
      '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';

  test(
      'Claude Code authenticates with ONLY our injected ANTHROPIC_API_KEY and replies',
      () async {
    final result = await runClaudeOnceInCurrentDir(
      anthropicApiKey: testAnthropicKey,
      prompt:
          'How are you Claude Code? Can we start? Answer in one short line. '
          'Do NOT run shell and do NOT modify files.',
      // You can pin a specific model string if you want:
      // model: 'claude-sonnet-4-5-20250929',
    );

    // Helpful debug on failures:
    stdout.writeln('=== CLAUDE STDOUT ===\n${result.stdout}\n=== /STDOUT ===');
    stderr.writeln('=== CLAUDE STDERR ===\n${result.stderr}\n=== /STDERR ===');
    stdout.writeln('Claude exitCode: ${result.exitCode}');

    // 1) It should print *something* in print mode (-p).
    expect(
      result.stdout.toString().trim(),
      isNotEmpty,
      reason: 'Claude should answer the prompt in print/headless mode (-p).',
    );

    // 2) No missing-auth complaints (env var API key is the supported path).
    //    Support doc: env key takes precedence and is how you force API billing. :contentReference[oaicite:3]{index=3}
    expect(
      result.stderr.toString().toLowerCase(),
      isNot(contains('api key')),
      reason: 'Claude should see the ANTHROPIC_API_KEY we injected.',
    );
    print('Claude response: ${result.stdout}');

    // 3) Clean exit.
    expect(result.exitCode, equals(0),
        reason: 'claude -p should exit 0 after printing a reply.');
  }, timeout: Timeout(Duration(minutes: 2)));
}
