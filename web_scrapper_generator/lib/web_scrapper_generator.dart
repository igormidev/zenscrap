/// Web Scrapper Generator with support for multiple AI providers
library;

// Core interface and types
export 'src/web_scrapper_generator_interface.dart';
export 'src/web_scrapper_response.dart';
export 'src/scraping_bee_mcp.dart';
export 'src/playwright_setup.dart';
export 'src/models/ai_models.dart';
export 'src/schema_constants.dart';

// Implementations
export 'src/implementations/web_scrapper_gemini_impl.dart';
export 'src/implementations/web_scrapper_claude_impl.dart';
export 'src/implementations/web_scrapper_codex_impl.dart';
