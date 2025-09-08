#!/usr/bin/env dart

import 'package:web_scrapper_generator/src/scraping_bee_mcp.dart' as mcp;

/// Entry point for the ScrapingBee MCP server executable
/// Run this with: dart run bin/scraping_bee_mcp_server.dart
/// Or compile it: dart compile exe bin/scraping_bee_mcp_server.dart -o scraping_bee_mcp_server
void main() async {
  await mcp.main();
}