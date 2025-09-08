import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';

/// ScrapingBee MCP configuration and initialization
class ScrapingBeeMcp {
  static String? _apiKey;
  
  /// Initialize and configure the ScrapingBee MCP server
  static Future<void> initialize({
    required GeminiSDK geminiSDK,
    required String apiKey,
  }) async {
    _apiKey = apiKey;
    
    // Configure the MCP server in Gemini SDK
    await _configureMcpServer(geminiSDK);
  }
  
  /// Configure the MCP server in Gemini SDK
  static Future<void> _configureMcpServer(GeminiSDK geminiSDK) async {
    try {
      // Create the MCP server configuration
      final scrapingBeeServer = McpServer(
        name: 'scraping-bee',
        command: 'dart',
        args: [
          'run',
          path.join(Directory.current.path, 'bin', 'scraping_bee_mcp_server.dart'),
        ],
        env: {
          'SCRAPINGBEE_API_KEY': _apiKey ?? '',
        },
      );
      
      // Add the server to Gemini SDK
      await geminiSDK.addMcpServer(
        'scraping-bee',
        customServer: scrapingBeeServer,
      );
    } catch (e) {
      // Try with project scope if user scope fails
      try {
        await geminiSDK.addMcpServer(
          'scraping-bee',
          customServer: McpServer(
            name: 'scraping-bee',
            command: 'dart',
            args: [
              'run',
              path.join(Directory.current.path, 'bin', 'scraping_bee_mcp_server.dart'),
            ],
            env: {
              'SCRAPINGBEE_API_KEY': _apiKey ?? '',
            },
          ),
          options: const McpAddOptions(
            scope: McpScope.project,
          ),
        );
      } catch (e2) {
        throw Exception('Failed to configure ScrapingBee MCP server: $e2');
      }
    }
  }
  
  /// Check if the MCP server is configured
  static Future<bool> isConfigured(GeminiSDK geminiSDK) async {
    try {
      final servers = await geminiSDK.listMcpServers();
      return servers.any((server) => 
        server.name == 'scraping-bee' ||
        server.command.contains('scraping_bee_mcp_server')
      );
    } catch (e) {
      return false;
    }
  }
  
  /// Get information about the ScrapingBee MCP setup
  static Future<Map<String, dynamic>> getInfo(GeminiSDK geminiSDK) async {
    final info = <String, dynamic>{};
    
    // Check if configured
    info['configured'] = await isConfigured(geminiSDK);
    
    // Check if script exists
    final scriptPath = path.join(
      Directory.current.path,
      'bin',
      'scraping_bee_mcp_server.dart',
    );
    info['script_exists'] = await File(scriptPath).exists();
    info['script_path'] = scriptPath;
    
    // Check if API key is set
    info['api_key_set'] = _apiKey != null;
    
    // Get MCP server list
    try {
      final servers = await geminiSDK.listMcpServers();
      final scrapingBeeServer = servers.firstWhere(
        (s) => s.name == 'scraping-bee',
        orElse: () => const McpServer(
          name: 'not_found',
          command: '',
          args: [],
        ),
      );
      if (scrapingBeeServer.name != 'not_found') {
        info['server_config'] = {
          'name': scrapingBeeServer.name,
          'command': scrapingBeeServer.command,
          'args': scrapingBeeServer.args,
        };
      }
    } catch (e) {
      info['server_config'] = null;
    }
    
    return info;
  }
}