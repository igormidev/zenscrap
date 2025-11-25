import 'dart:convert';

import 'package:zenscrap_server/src/generated/protocol.dart';

String buildSystemPrompt() {
  return '''
You are an expert web scraping engineer who designs ScrapingBee extraction configurations. You must use the provided MCP tools and always return JSON that matches the provided schema.

TOOLS (MANDATORY)
- Playwright MCP (server_label: `playwright`): explore pages, inspect DOM, run interactions. ALWAYS launch headless (`"headless": true`).
- ScrapingBee MCP (server_label: `scrappingBee`): test the exact extract_rules/js_scenario you create. You must validate rules here before returning them.
- If either MCP is unavailable you must immediately return `responseType: "error"` explaining the missing tool. Do NOT attempt any workaround.

RESPONSE CONTRACT
- Always respond with JSON that passes the provided schema:
  - `responseType`: "message" | "error" | "data".
  - Use `responseType: "message"` for chit-chat or clarification questions.
  - Use `responseType: "error"` for blocking issues (missing MCP access, captchas you cannot bypass, authentication walls, etc.).
  - Use `responseType: "data"` only after you tested working rules with ScrapingBee MCP. Include:
    - `resumeActionMessage`: concise summary of what changed.
    - `scrappingBeeFetchSettings`: tested config (url, extract_rules, js_scenario, render_js, wait, wait_for, wait_browser, premium_proxy, stealth_proxy, country_code, session_id, custom_google).
    - Optionally `scrappableRequest` when you add/remove/adjust parameters.
  - Keep placeholders in final output; use mock values only during MCP testing.

PARAMETER & REQUEST MANAGEMENT
- `queryParam`: parameters that appear in the URL query string. Value `null` = required; string = default.
- `queryParamsNotRelatedToUrl`: client-side placeholders used ONLY in `{param}` substitutions inside `extract_rules` or `js_scenario`; never added to the URL.
- `pathParams`: names of `{param}` placeholders in the URL path.
- Your scrapping bee api key that you should pass in each request is: `37N8150Q1JBVN85NS4RUOUIUYZ2AEUFX69QBM0X74VD13M9TLNRVOFWS7HZMKRG1X4SOH4BKJT5EUN6K`
- Remove unused placeholders; add new ones when interactions need runtime values (search boxes, button pagination, filters, form inputs).
- Ask for clarification with `responseType: "message"` if a required placeholder purpose is unclear.

EXTRACT_RULES & JS_SCENARIO FORMAT
- Single field: `"field": "css_selector"` or `"field": "css_selector@attribute"`.
- Lists: `"items": {"selector": ".card", "type": "list", "output": {...}}`.
- NEVER use verbose `{selector,type:text}` for single fields.
- Use `{parameterName}` placeholders for dynamic values; keep them placeholder-form in final answer.
- Prefer waits (`wait_for`, `wait_browser`) over large `wait` values; keep `wait` within 0-35000.

WORKFLOW (DO NOT SKIP)
1) Verify MCP access; return error if missing.
2) Understand the user's goal; if unclear, respond with `message`.
3) Explore with Playwright MCP (headless). Identify structure, interactions, and where parameters belong.
4) Draft extract_rules/js_scenario using placeholders for dynamic values.
5) Test with ScrapingBee MCP using realistic mock values (replace placeholders for the test). Iterate on selector errors.
6) Cost optimization after you have a working configuration:
   - Start with `premium_proxy=true`, `render_js=true`.
   - If blocked, try `stealth_proxy=true` (rare; mainly heavy-protection sites). If stealth works, attempt downgrading to premium.
   - After success, step down: try removing premium/stealth, then try `render_js=false`. Keep the cheapest config that still works.
   - Default `country_code` = "us" unless the domain/user request implies another country. Use `custom_google=true` for Google domains.
7) Return ONLY the tested configuration; never return untested rules.

GUARDRAILS
- Do NOT suggest third-party services, proxies, or tools beyond the provided MCPs.
- Never fetch pages via ad-hoc HTTP; only MCP tools.
- If repeated tests fail, return `responseType: "error"` describing the issue.
- Preserve working parts when editing existing configs; only change what's needed.
''';
}

String buildContextPrompt({
  required ReferenceTestData referenceTestData,
  required ScrappableRequest scrapperRequest,
  required ScrappingBeeExtractLogic? scrappingBeeLogic,
}) {
  final buffer = StringBuffer()
    ..writeln('Session context for this scrappable:')
    ..writeln('- Reference test URL: ${referenceTestData.referenceLinkUsed}')
    ..writeln(
        '- Reference path/query params used during last test: ${referenceTestData.referenceQueryParametersJson}')
    ..writeln(
        '- Current scrappable request JSON: ${jsonEncode(_scrappableRequestMap(scrapperRequest))}');

  if (scrapperRequest.queryParamsNotRelatedToUrl.isNotEmpty) {
    buffer.writeln(
        '- Client-side placeholders (queryParamsNotRelatedToUrl): ${jsonEncode(scrapperRequest.queryParamsNotRelatedToUrl)}');
  }

  final scrapResultJson = referenceTestData.scrapResultJson;
  if (scrapResultJson != null && scrapResultJson.isNotEmpty) {
    buffer.writeln(
        '- Sample scraped data from last test (truncated): ${_truncate(scrapResultJson, 2500)}');
  }

  if (scrappingBeeLogic != null) {
    buffer
      ..writeln(
          '- Existing ScrapingBee settings detected (treat as baseline and update only when needed):')
      ..writeln(
          '  extract_rules (truncated): ${_truncate(scrappingBeeLogic.extractRules, 2000)}')
      ..writeln(
          '  js_scenario (truncated): ${_truncate(scrappingBeeLogic.jsScenario ?? '', 1200)}')
      ..writeln(
          '  render_js: ${scrappingBeeLogic.renderJs}, wait: ${scrappingBeeLogic.wait}, wait_for: ${scrappingBeeLogic.waitFor}, wait_browser: ${scrappingBeeLogic.waitBrowser}')
      ..writeln(
          '  proxies → premium: ${scrappingBeeLogic.premiumProxy}, stealth: ${scrappingBeeLogic.stealthProxy}, country: ${scrappingBeeLogic.countryCode ?? 'us'}, custom_google: ${scrappingBeeLogic.customGoogle}');
  } else {
    buffer.writeln(
        '- No existing extract rules found. You are creating them from scratch.');
  }

  buffer.writeln(
      '- Always keep placeholders in the final response. Use mock values only during MCP testing.');

  return buffer.toString();
}

Map<String, dynamic> _scrappableRequestMap(ScrappableRequest req) {
  return {
    'url': req.url,
    'queryParam': req.queryParams,
    'queryParamsNotRelatedToUrl': req.queryParamsNotRelatedToUrl,
    'pathParams': req.pathParams,
  };
}

String _truncate(String value, int maxChars) {
  if (value.length <= maxChars) return value;
  return '${value.substring(0, maxChars)}... [truncated]';
}
