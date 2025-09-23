import 'dart:io';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

Future<void> main() async {
  final apiKey = Platform.environment['GEMINI_API_KEY'] ?? 'YOUR_API_KEY';
  if (apiKey == 'YOUR_API_KEY') {
    stderr.writeln('Set GEMINI_API_KEY before running this example.');
    return;
  }

  final gemini = Gemini(apiKey: apiKey);

  final info = await gemini.isMcpInstalled();
  stdout
    ..writeln('MCP enabled: ${info.hasMcpSupport}')
    ..writeln('Config path: ${info.configPath}')
    ..writeln('Configured servers: ${info.servers.length}\n');

  stdout.writeln('Installing the filesystem MCP server (if not present)...');
  try {
    await gemini.installPopularMcpServer('filesystem');
    stdout.writeln('Filesystem MCP installed.\n');
  } on CliException catch (error) {
    stdout.writeln('Could not install filesystem MCP: ${error.message}\n');
  }

  final servers = await gemini.listMcpServers();
  if (servers.isEmpty) {
    stdout.writeln('No MCP servers configured.');
  } else {
    stdout.writeln('Configured servers:');
    for (final server in servers) {
      stdout
        ..writeln('• ${server.name}')
        ..writeln('  Command: ${server.command} ${server.args.join(' ')}');
      if (server.env != null && server.env!.isNotEmpty) {
        stdout.writeln('  Env: ${server.env}');
      }
    }
  }

  await gemini.dispose();
}
