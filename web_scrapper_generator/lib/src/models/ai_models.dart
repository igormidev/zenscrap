/// Available Gemini models for web scraping
enum GeminiModel {
  gemini25Flash('gemini-2.5-flash'),
  gemini25Pro('gemini-2.5-pro');

  final String apiName;
  const GeminiModel(this.apiName);
}

/// Available Claude models for web scraping
enum ClaudeModel {
  // Claude 3 family (legacy)
  claude3Haiku('claude-3-haiku-20240307'),
  claude3Sonnet('claude-3-sonnet-20240229'),
  claude3Opus('claude-3-opus-20240229'),

  // Claude 3.5 family
  claude35Sonnet('claude-3-5-sonnet-20241022'),
  claude35Haiku('claude-3-5-haiku-20241022'),

  // Claude 3.7 family
  claude37Sonnet('claude-3-7-sonnet-20250219'),

  // Claude 4 family
  claudeSonnet4('claude-sonnet-4-20250514'),
  claudeOpus4('claude-opus-4-20250514'),
  claudeOpus41('claude-opus-4-1-20250805'),

  // Claude 4.5 family
  claude45Sonnet('claude-sonnet-4-20250514'),
  claude45Haiku('claude-haiku-4-5');

  final String apiName;
  const ClaudeModel(this.apiName);

  /// Get a human-readable display name
  String get displayName {
    switch (this) {
      case ClaudeModel.claude3Haiku:
        return 'Claude 3 Haiku (Fast, Legacy)';
      case ClaudeModel.claude3Sonnet:
        return 'Claude 3 Sonnet (Balanced, Legacy)';
      case ClaudeModel.claude3Opus:
        return 'Claude 3 Opus (Powerful, Legacy)';
      case ClaudeModel.claude35Sonnet:
        return 'Claude 3.5 Sonnet (Fast & Smart)';
      case ClaudeModel.claude35Haiku:
        return 'Claude 3.5 Haiku (Ultra-Fast)';
      case ClaudeModel.claude37Sonnet:
        return 'Claude 3.7 Sonnet (Hybrid Reasoning)';
      case ClaudeModel.claudeSonnet4:
        return 'Claude Sonnet 4 (Latest, Balanced)';
      case ClaudeModel.claudeOpus4:
        return 'Claude Opus 4 (Most Powerful)';
      case ClaudeModel.claudeOpus41:
        return 'Claude Opus 4.1 (Latest & Greatest)';
      case ClaudeModel.claude45Sonnet:
        return 'Claude 4.5 Sonnet (Fast & Smart)';
      case ClaudeModel.claude45Haiku:
        return 'Claude 4.5 Haiku (Ultra-Fast)';
    }
  }
}

/// Available Codex models for web scraping
enum CodexModel {
  gpt5Mini('gpt-5-mini'),
  gpt5('gpt-5'),
  gpt5Codex('gpt-5-codex');

  final String apiName;
  const CodexModel(this.apiName);

  /// Get a human-readable display name
  String get displayName {
    switch (this) {
      case CodexModel.gpt5Mini:
        return 'GPT-5 Mini (Fast & Efficient)';
      case CodexModel.gpt5:
        return 'GPT-5 (Fast Reasoning)';
      case CodexModel.gpt5Codex:
        return 'GPT-5 Codex (Powerful Reasoning)';
    }
  }
}
