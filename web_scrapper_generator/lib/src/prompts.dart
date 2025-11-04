import 'dart:convert';
import 'dart:typed_data';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:web_scrapper_generator/src/documentation/system_prompt.dart';
import 'package:web_scrapper_generator/src/documentation/cost_optimization.dart';
import 'package:web_scrapper_generator/src/documentation/how_to_write_effective_scrapping_bee_extract_rules.dart';
import 'package:web_scrapper_generator/src/documentation/scrappable_request_structure_guide.dart';
import 'package:web_scrapper_generator/src/web_scrapper_generator_interface.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';

List<PromptContent> handleInitialPrompts(InitialPayloadData payload) {
  return switch (payload) {
    InitialPayloadDataCreatingFromZero() => creatingFromZeroInitialPrompt(
        payload: payload,
      ),
    InitialPayloadDataEditingExistingWebScrapper() =>
      editingExistingWebScrapperInitialPrompt(payload: payload),
  };
}

List<PromptContent> creatingFromZeroInitialPrompt({
  required InitialPayloadDataCreatingFromZero payload,
}) {
  final String targetUrl = payload.targetExampleUrl;
  final WebScrapperRequest webScrapperRequest = payload.webScrapperRequest;
  final e = JsonEncoder.withIndent('  ');
  final requestJson = webScrapperRequest.toMap();
  final requestBytes = Uint8List.fromList(e.convert(requestJson).codeUnits);

  return [
    // System prompt as MD file
    systemPromptContent,

    // How to write effective extraction rules guide as MD file
    extractionRulesContent,

    // Cost optimization guide as MD file
    costOptimizationContent,

    // Scrappable request structure guide as MD file
    scrappableRequestCreationStructureContent,

    PromptContent.text('''## Task: Create New Web Scraper

You are creating a NEW web scraper for a website. This is a fresh start - no existing configuration.

**Target URL**: $targetUrl

**WebScrapperRequest Structure**:
Below is a JSON representation of the WebScrapperRequest that defines the URL pattern, query parameters, and path parameters for this scraper.

**IMPORTANT**: Check the scrappable_request_structure_guide.md for detailed explanations of when to use queryParams vs queryParamsNotRelatedToUrl.

**Key Points**:
- The request may already have some queryParams defined (for URL-based parameters)
- The request may have queryParamsNotRelatedToUrl defined (for client-side interactions)
- Any parameter with a `null` value is DYNAMIC - users will provide different values
- Use `{parameterName}` placeholders in your extraction rules for dynamic parameters
- Parameters in queryParamsNotRelatedToUrl are NEVER added to URL - they're only used for placeholders in extract_rules/js_scenario
'''),
    PromptContent.bytes(
      data: requestBytes,
      fileName: 'scrapper_request',
      fileExtension: 'json',
    ),
    PromptContent.text('''
## Your Process:

1. **Understand the Request**: Review the WebScrapperRequest structure
   - Check what parameters are available (queryParams and queryParamsNotRelatedToUrl)
   - Parameters with null values are dynamic - use placeholders for them
   - Parameters in queryParamsNotRelatedToUrl are for client-side interactions only
2. **Exploration**: Use Playwright MCP to explore the target URL
   - **CRITICAL**: ALWAYS use `"headless": true` in launchOptions
   - Analyze the page structure and identify extraction opportunities
3. **Rule Creation**: Create extract_rules and js_scenario
   - Use `{parameterName}` placeholders for any dynamic parameters
   - See how_to_write_effective_scrapping_bee_extract_rules.md for guidance
4. **Testing** (MANDATORY): Test with ScrapingBee MCP
   - **CRITICAL**: Replace placeholders with mock values when testing (e.g., `{searchQuery}` → "test query")
   - Follow the cost_optimization.md workflow (start with premium_proxy, then optimize down)
   - Test extraction rules with ScrapingBee MCP `test_extract_rules`
   - **NEVER** return rules without MCP validation
5. **Return Results**: Provide tested and optimized extraction settings
   - **IMPORTANT**: Return rules with PLACEHOLDERS intact (not the mock values used for testing)

## Important Notes:
- The target URL provided may or may not have placeholders - analyze it to understand the structure
- If you see placeholders like `{productId}` in the URL, users will provide those values
- If you see `null` values in queryParams or queryParamsNotRelatedToUrl, use `{paramName}` in your extraction rules
- **MANDATORY**: Test your extraction rules with ScrapingBee MCP before returning
- **CRITICAL**: Tested extract_rules MUST pass MCP validation

The user will now describe what data they want to extract from this site.

ALL (without exception) the following texts below are instructions typed from the user that describe what should be extracted. Make sure you read them carefully and understand them before starting your work.

User prompt:'''),
  ];
}

List<PromptContent> editingExistingWebScrapperInitialPrompt({
  required InitialPayloadDataEditingExistingWebScrapper payload,
}) {
  final e = JsonEncoder.withIndent('  ');

  // Create combined JSON with both current request and fetch settings
  final combinedJson = {
    'currentRequest': payload.currentRequest.toMap(),
    'currentFetchSettings': payload.currentFetchSettings.toMap(),
  };

  final inputBytes = Uint8List.fromList(e.convert(combinedJson).codeUnits);

  return [
    // System prompt as MD file
    systemPromptContent,

    // How to write effective extraction rules guide as MD file
    extractionRulesContent,

    // Cost optimization guide as MD file
    costOptimizationContent,

    // Scrappable request structure guide as MD file
    scrappableRequestCreationStructureContent,

    PromptContent.text('''## Task: Edit Existing Web Scraper

You are editing an existing, working web scraper. The current configuration successfully extracts data, but the user wants to make modifications.

**Target URL**: ${payload.currentFetchSettings.url}

**IMPORTANT URL HANDLING**:
- The current URL above is what the existing scraper uses
- If the user asks you to test with a different URL, use that for your tests
- Your final ScrappingBeeFetchSettings.url should be the URL you actually validated against
- This means if you test with a new URL, that becomes the url in your response

**Current Configuration**:
The following JSON contains:
1. **currentRequest**: The current WebScrapperRequest (URL pattern, query params, path params) - You can modify this if needed
2. **currentFetchSettings**: The current ScrapingBee settings that are successfully extracting data - You can modify and improve this

**IMPORTANT - You CAN Modify Both Configurations**:
- If your changes need additional dynamic parameters (for search, pagination, filters, etc.), you can modify the request structure
- Add parameters to `queryParams` if they appear in the URL
- Add parameters to `queryParamsNotRelatedToUrl` for client-side interactions (search boxes, pagination buttons)
- Use `{parameterName}` placeholders in your extraction rules for any parameters with `null` values
- Check if the current settings already use placeholders - maintain consistency
- Check the scrappable_request_structure_guide.md for full details on when to use queryParams vs queryParamsNotRelatedToUrl

**Response Type Selection**:
- If you only modify extraction rules → return scrappingBeeFetchSettings (only)
- If you only modify request structure → return scrappableRequest (only)
- If you modify both → return both scrappingBeeFetchSettings and scrappableRequest
'''),
    PromptContent.bytes(
      data: inputBytes,
      fileName: 'current_config',
      fileExtension: 'json',
    ),
    PromptContent.text('''
## Your Process:

1. **Understand Current Setup**: The existing rules are working correctly
   - Check if current rules use placeholders like `{searchQuery}` or `{currentPage}`
   - Understand which parameters are dynamic (null values in queryParams and queryParamsNotRelatedToUrl)
2. **Identify Required Changes**: Based on the user's request, determine what needs modification
   - If adding new interactions, consider using placeholders for dynamic values
   - Maintain consistency with existing placeholder usage
   - See how_to_write_effective_scrapping_bee_extract_rules.md for guidance
3. **Test Modifications** (MANDATORY): Use Playwright and ScrapingBee MCPs to test changes
   - **CRITICAL**: Replace placeholders with mock values when testing (e.g., `{searchQuery}` → "test query")
   - Test the modified extract_rules with ScrapingBee MCP
   - **NEVER** return modified rules without MCP validation
4. **Preserve What Works**: Don't break existing functionality unless explicitly requested
   - Keep existing placeholders unless user asks to change them
   - Don't replace placeholders with hardcoded values
5. **Optimize if Possible**: If making changes, also check if settings can be optimized
   - See cost_optimization.md for the complete optimization strategy
6. **Return Updated Configuration**: Provide ONLY tested and validated settings
   - **IMPORTANT**: Return rules with PLACEHOLDERS intact (not the mock values used for testing)

## Important Notes:
- The current configuration is WORKING - be careful not to break it
- **You can modify both extraction rules AND request structure** as needed
- **MANDATORY**: Test extraction rule modifications with ScrapingBee MCP before returning
- **CRITICAL**: Modified extract_rules MUST pass MCP testing
- If the user's requested change would break functionality, explain why
- **Always check if the current settings can be optimized further:**
  * If using stealth_proxy, test if premium_proxy would work
  * If using premium_proxy, test if no proxy would work
  * If using render_js, test if static scraping would work
- **Return Patterns:**
  * If user is just asking questions → Use `responseType: "message"`
  * If current setup already meets requirements → Use `responseType: "message"` to explain
  * If you only modified extraction rules → return only scrappingBeeFetchSettings
  * If you only modified request structure → return only scrappableRequest
  * If you modified both → return both scrappingBeeFetchSettings and scrappableRequest
  * DON'T return a "data" response if nothing changed
- Remember: ScrappingBeeFetchSettings.url will be the actual URL you tested with
- **NEVER** return modified extraction rules without MCP validation

The user will now describe what modifications they want to make.'''),
  ];
}

final systemPromptContent = PromptContent.bytes(
  data: Uint8List.fromList(systemPrompt.codeUnits),
  fileName: 'system_prompt',
  fileExtension: 'md',
);

final extractionRulesContent = PromptContent.bytes(
  data:
      Uint8List.fromList(howToWriteEffectiveScrapingBeeExtractRules.codeUnits),
  fileName: 'how_to_write_effective_scrapping_bee_extract_rules',
  fileExtension: 'md',
);

final costOptimizationContent = PromptContent.bytes(
  data: Uint8List.fromList(costOptimization.codeUnits),
  fileName: 'cost_optimization',
  fileExtension: 'md',
);

final scrappableRequestCreationStructureContent = PromptContent.bytes(
  data: Uint8List.fromList(scrappableRequestStructureGuide.codeUnits),
  fileName: 'scrappable_request_structure_guide',
  fileExtension: 'md',
);
