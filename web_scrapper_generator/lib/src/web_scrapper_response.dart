// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
sealed class WebScrapperChatAIResponse {
  const WebScrapperChatAIResponse();
}

final class WebScrapperChatAIResponseJustMessage
    extends WebScrapperChatAIResponse {
  final String message;
  const WebScrapperChatAIResponseJustMessage(this.message);

  @override
  String toString() => message;
}

final class WebScrapperChatAIResponseErrorMessage
    extends WebScrapperChatAIResponse {
  final String errorDescription;
  const WebScrapperChatAIResponseErrorMessage(this.errorDescription);

  @override
  String toString() => errorDescription;
}

/// Response when only extraction rules (fetch settings) were modified
final class WebScrapperChatAIResponseOnlyExtractRulesModified
    extends WebScrapperChatAIResponse {
  /// A resume from the AI about what it did
  final String resumeActionMessage;

  /// The fetch settings that will be used when calling scrapping bee
  final ScrappingBeeFetchSettings fetchSettings;

  @override
  String toString() =>
      '$resumeActionMessage\nFetch Settings: ${fetchSettings.toString()}';

  const WebScrapperChatAIResponseOnlyExtractRulesModified({
    required this.fetchSettings,
    required this.resumeActionMessage,
  });
}

/// Response when only the request structure was modified
final class WebScrapperChatAIResponseOnlyRequestModified
    extends WebScrapperChatAIResponse {
  /// A resume from the AI about what it did
  final String resumeActionMessage;

  /// The modified request structure
  final WebScrapperRequest scrappableRequest;

  @override
  String toString() =>
      '$resumeActionMessage\nRequest: ${scrappableRequest.toString()}';

  const WebScrapperChatAIResponseOnlyRequestModified({
    required this.scrappableRequest,
    required this.resumeActionMessage,
  });
}

/// Response when both extraction rules and request structure were modified
final class WebScrapperChatAIResponseBothModified
    extends WebScrapperChatAIResponse {
  /// A resume from the AI about what it did
  final String resumeActionMessage;

  /// The fetch settings that will be used when calling scrapping bee
  final ScrappingBeeFetchSettings fetchSettings;

  /// The modified request structure
  final WebScrapperRequest scrappableRequest;

  @override
  String toString() =>
      '$resumeActionMessage\nFetch Settings: ${fetchSettings.toString()}\nRequest: ${scrappableRequest.toString()}';

  const WebScrapperChatAIResponseBothModified({
    required this.fetchSettings,
    required this.scrappableRequest,
    required this.resumeActionMessage,
  });
}

class WebScrapperRequest {
  //  Dynamic path fields are saved as {PATH_PARAM_NAME}. Example: www.mySocialMedia.com/posts/{postId}/comments/{commentsId}
  final String url;
  // Query parameters that will be added to the URL. The map value is the default value if not in user payload. Example: {"sort": "asc", "filter": null}
  final Map<String, String?> queryParam;
  // Dynamic parameters used ONLY in extract_rules/js_scenario placeholders, NOT added to URL. For client-side interactions like search boxes, pagination buttons, filters. Example: {"searchQuery": null, "currentPage": null}
  final Map<String, String?> queryParamsNotRelatedToUrl;
  // The name of the paths params that will be requested by the user in his payload, Example: [postId, commentsId]
  final List<String> pathParams;

  const WebScrapperRequest({
    required this.url,
    required this.queryParam,
    this.queryParamsNotRelatedToUrl = const {},
    required this.pathParams,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'queryParam': queryParam,
      'queryParamsNotRelatedToUrl': queryParamsNotRelatedToUrl,
      'pathParams': pathParams,
    };
  }

  @override
  String toString() =>
      'WebScrapperRequest(url: $url, queryParam: $queryParam, queryParamsNotRelatedToUrl: $queryParamsNotRelatedToUrl, pathParams: $pathParams)';
}

class ScrappingBeeFetchSettings {
  // the target page URL to scrape
  final String url;
  // stringified JSON describing what to extract (CSS/XPath selectors, lists, attributes, tables, etc.)
  final String extract_rules;
  // stringified JSON of scripted actions (click/type/scroll/infinite-scroll/etc.) to run before extraction
  final String? js_scenario;
  // enable a headless browser to execute JavaScript before extraction
  final bool render_js;
  // add a fixed delay (milliseconds) before returning the response
  final int? wait;
  // wait for a specific CSS/XPath selector to appear before returning
  final String? wait_for;
  // wait for a browser event (e.g., domcontentloaded) before returning
  final String? wait_browser;
  // will use residencial proxy, for more scrapper-resident sites
  final bool premium_proxy;
  // use stealth proxy for the hardest to scrape websites (most expensive option)
  final bool stealth_proxy;
  // proxy geolocation (e.g., us, de, br)
  final String? country_code;
  // keep the same IP across multiple requests (sticky sessions).
  final String? session_id;
  // enable Google-specific handling, this should allways be true if the url is from a google domain
  final bool? custom_google;

  const ScrappingBeeFetchSettings({
    required this.url,
    required this.extract_rules,
    this.js_scenario,
    required this.render_js,
    required this.premium_proxy,
    required this.stealth_proxy,
    this.wait,
    this.wait_for,
    this.wait_browser,
    this.country_code,
    this.session_id,
    this.custom_google,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'extract_rules': extract_rules,
      'js_scenario': js_scenario,
      'render_js': render_js,
      'wait': wait,
      'wait_for': wait_for,
      'wait_browser': wait_browser,
      'premium_proxy': premium_proxy,
      'stealth_proxy': stealth_proxy,
      'country_code': country_code,
      'session_id': session_id,
      'custom_google': custom_google,
    };
  }

  @override
  String toString() {
    return 'ScrappingBeeFetchSettings(url: $url, extract_rules: $extract_rules, js_scenario: $js_scenario, render_js: $render_js, wait: $wait, wait_for: $wait_for, wait_browser: $wait_browser, premium_proxy: $premium_proxy, stealth_proxy: $stealth_proxy, country_code: $country_code, session_id: $session_id, custom_google: $custom_google)';
  }
}
