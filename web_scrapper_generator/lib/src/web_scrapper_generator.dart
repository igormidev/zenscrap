// This file is deprecated and maintained for backward compatibility only.
// Please use the new implementations directly:
// - WebScrapperGeminiImpl for Gemini
// - WebScrapperClaudeImpl for Claude

@Deprecated('Use WebScrapperGeminiImpl or WebScrapperClaudeImpl instead')
library;

export 'web_scrapper_generator_interface.dart';
export 'implementations/web_scrapper_gemini_impl.dart';
export 'implementations/web_scrapper_claude_impl.dart';