/// Available Gemini models for web scraping
enum GeminiModel {
  gemini25Flash('gemini-2.5-flash'),
  gemini25Pro('gemini-2.5-pro');

  final String apiName;
  const GeminiModel(this.apiName);
}

/// Available Claude models for web scraping
enum ClaudeModel {
  // Claude 3 family
  claude3Haiku('claude-3-haiku-20240307'),
  claude3Sonnet('claude-3-sonnet-20240229'),
  claude3Opus('claude-3-opus-20240229'),

  // Claude 3.5 family
  claude35Sonnet('claude-3.5-sonnet-20241022'),
  claude35Haiku('claude-3.5-haiku-20241022'),

  // Claude 3.7 family
  claude37Sonnet('claude-3.7-sonnet-20250224'),

  // Claude 4 family
  claude4Sonnet('claude-4-sonnet-20250522'),
  claude4Opus('claude-4-opus-20250522'),
  claude4Opus41('claude-opus-4.1-20250805');

  final String apiName;
  const ClaudeModel(this.apiName);

  /// Get a human-readable display name
  String get displayName {
    switch (this) {
      case ClaudeModel.claude3Haiku:
        return 'Claude 3 Haiku (Fast)';
      case ClaudeModel.claude3Sonnet:
        return 'Claude 3 Sonnet (Balanced)';
      case ClaudeModel.claude3Opus:
        return 'Claude 3 Opus (Powerful)';
      case ClaudeModel.claude35Sonnet:
        return 'Claude 3.5 Sonnet (Fast & Smart)';
      case ClaudeModel.claude35Haiku:
        return 'Claude 3.5 Haiku (Ultra-Fast)';
      case ClaudeModel.claude37Sonnet:
        return 'Claude 3.7 Sonnet (Hybrid Reasoning)';
      case ClaudeModel.claude4Sonnet:
        return 'Claude 4 Sonnet (Advanced)';
      case ClaudeModel.claude4Opus:
        return 'Claude 4 Opus (Most Capable)';
      case ClaudeModel.claude4Opus41:
        return 'Claude Opus 4.1 (Latest & Greatest)';
    }
  }
}