// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
sealed class WebScrapperChatAIResponse {
  const WebScrapperChatAIResponse();
}

final class WebScrapperChatAIResponseJustMessage
    extends WebScrapperChatAIResponse {
  final String message;
  const WebScrapperChatAIResponseJustMessage(this.message);
}

final class WebScrapperChatAIResponseErrorMessage
    extends WebScrapperChatAIResponse {
  final String errorDescription;
  const WebScrapperChatAIResponseErrorMessage(this.errorDescription);
}

final class WebScrapperChatAIResponseWithDataResponse
    extends WebScrapperChatAIResponse {
  /// A resume from the AI about what it did
  final String resumeActionMessage;

  /// The request that the AI generated based on the user prompt - should be null if the ai did not need to update this
  final WebScrapperRequest? request;

  /// The fetch settings that will be used when calling scrapping bee
  final ScrappingBeeFetchSettings fetchSettings;

  const WebScrapperChatAIResponseWithDataResponse({
    required this.fetchSettings,
    required this.resumeActionMessage,
    required this.request,
  });
}

class WebScrapperRequest {
  //  Dynamic path fields are saved as {PATH_PARAM_NAME}. Example: www.mySocialMedia.com/posts/{postId}/comments/{commentsId}
  final String url;
  // The query parameters that will be requested by the user in his payload, Example: [sort, filter]. The map value will be the default value in case it does not exist in users payload
  final Map<String, String?> queryParam;
  // The name of the paths params that will be requested by the user in his payload, Example: [postId, commentsId]
  final List<String> pathParams;

  const WebScrapperRequest({
    required this.url,
    required this.queryParam,
    required this.pathParams,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'queryParam': queryParam,
      'pathParams': pathParams,
    };
  }
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
      'country_code': country_code,
      'session_id': session_id,
      'custom_google': custom_google,
    };
  }
}
