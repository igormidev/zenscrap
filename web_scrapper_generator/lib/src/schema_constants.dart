// Schema property descriptions - shared between all implementations
class SchemaDescriptions {
  // Response type descriptions
  static const String responseType =
      'The type of response: "message", "error", or "data"';
  static const List<String> responseTypeValues = ['message', 'error', 'data'];

  // Message descriptions
  static const String message =
      'A message from the AI (used for responseType "message")';
  static const String errorMessage =
      'An error message (used for responseType "error")';
  static const String resumeActionMessage =
      'A summary of what the AI did (used for responseType "data")';

  // Request descriptions
  static const String request =
      'Modified WebScrapperRequest if changes were made, null if no changes needed';
  static const String requestUrl =
      'URL pattern with {paramName} placeholders for dynamic segments';
  static const String requestQueryParam =
      'Query parameters with optional default values';
  static const String requestQueryParamDynamic =
      'Dynamic key-value pairs for query parameters';
  static const String requestPathParams = 'List of path parameter names';

  // Fetch settings descriptions
  static const String fetchSettings =
      'ScrapingBee fetch settings (used for responseType "data")';
  static const String fetchUrl = 'The target URL for scraping';
  static const String fetchExtractRules = 'JSON-encoded extraction rules';
  static const String fetchJsScenario =
      'JSON-encoded JavaScript scenario for interactions';
  static const String fetchRenderJs = 'Whether to render JavaScript';
  static const String fetchWait = 'Fixed delay in milliseconds';
  static const String fetchWaitFor = 'CSS/XPath selector to wait for';
  static const String fetchWaitBrowser = 'Browser event to wait for';
  static const String fetchPremiumProxy =
      'Whether to use premium residential proxy';
  static const String fetchCountryCode =
      'Proxy geolocation code (2-letter country code)';
  static const String fetchSessionId = 'Session ID for sticky sessions';
  static const String fetchCustomGoogle =
      'Whether to use Google-specific handling';

  // Overall schema description
  static const String overallDescription =
      'Structured response from the AI for web scraper generation';
}
