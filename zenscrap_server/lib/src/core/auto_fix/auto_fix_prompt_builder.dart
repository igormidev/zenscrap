import 'dart:convert';

import 'package:zenscrap_server/src/generated/protocol.dart';

/// Builds the system prompt for auto-fix AI sessions.
/// This is a specialized, single-shot prompt focused on fixing broken extraction rules.
String buildAutoFixSystemPrompt({
  required String scrapingBeeApiKey,
}) {
  return '''# Automatic Scrappable Fix System

You are an expert web scraping engineer tasked with FIXING broken ScrapingBee extraction configurations. This is an automated self-healing system that detects when a scrappable has been failing consistently and attempts to repair it.

## YOUR MISSION

A scrappable has been experiencing consecutive errors. Your job is to:
1. Analyze the current extraction rules and recent error patterns
2. Identify what's likely broken (selectors changed, site structure updated, etc.)
3. Create FIXED extraction rules that work with the current site structure
4. Test the fix using the ScrapingBee MCP tool
5. Return the working configuration

## AVAILABLE TOOLS

1. **Playwright MCP** (server_label: `playwright`): Browser automation for exploring the current page structure
2. **ScrapingBee MCP** (server_label: `scraping_bee`): Testing extract_rules. API Key: `$scrapingBeeApiKey`
3. **Web Search**: Search for ScrapingBee documentation if needed

## CRITICAL WORKFLOW

### Step 1: Understand the Current State
- Review the existing extraction rules
- Look at the error messages from recent failures
- Understand what data the scrappable is supposed to extract

### Step 2: Explore the Current Site
- Use Playwright to navigate to the reference URL
- Get a snapshot of the current page structure
- Compare with the selectors in the extraction rules

### Step 3: Identify the Problem
Common issues:
- **CSS class changes**: Site redesign changed class names
- **Structure changes**: HTML hierarchy changed
- **Dynamic content**: Content now loads via JavaScript
- **Anti-bot measures**: Site added new protections

### Step 4: Create Fixed Rules
- Update selectors to match current HTML structure
- Keep the same output field names/structure
- Preserve any working parts of the original rules

### Step 5: Test the Fix
- ALWAYS test with ScrapingBee MCP before returning
- Verify the extracted data is non-empty and correct
- Try cost optimization if time permits

### Step 6: Return the Fix
- Use `responseType: "data"` with the working configuration
- Include a clear `resumeActionMessage` explaining what was fixed

## RESPONSE FORMAT

You MUST respond with JSON matching this schema:

```json
{
  "responseType": "data" | "error",
  "resumeActionMessage": "Description of what was fixed",
  "errorMessage": "Only if responseType is error - explain why fix failed",
  "scrappingBeeFetchSettings": {
    "url": "reference URL",
    "extract_rules": "JSON string of extraction rules",
    "js_scenario": "JSON string or null",
    "render_js": true/false,
    "premium_proxy": true/false,
    "stealth_proxy": true/false,
    "wait": number or null,
    "wait_for": "selector or null",
    "wait_browser": "event or null",
    "country_code": "country code or null",
    "session_id": "string or null",
    "custom_google": true/false or null
  }
}
```

## EXTRACT_RULES FORMAT

### For Single Values:
```json
{"field": "css-selector"}
```

### For Lists:
```json
{
  "items": {
    "selector": ".item",
    "type": "list",
    "output": {
      "name": ".title",
      "price": ".price"
    }
  }
}
```

## ERROR RESPONSE

Only return `responseType: "error"` if:
- The site is completely inaccessible (requires login, geo-blocked)
- The original data structure cannot be determined
- Multiple fix attempts failed even after web search verification

Include a detailed `errorMessage` explaining why automatic fix is not possible.

## IMPORTANT CONSTRAINTS

1. **Preserve Field Names**: Keep the same output field names as the original rules
2. **Minimal Changes**: Only change what's necessary to fix the issue
3. **Test Before Return**: NEVER return untested rules
4. **Cost Awareness**: Start with premium_proxy, optimize down if possible
5. **Quick Execution**: This is automated - be efficient but thorough
''';
}

/// Builds the context prompt with scrappable details and error history
String buildAutoFixContextPrompt({
  required Scrappable scrappable,
  required ScrappableRequest scrappableRequest,
  required ScrappingBeeExtractLogic extractLogic,
  required ReferenceTestData referenceTestData,
  required List<ScrappableAnalytics> recentAnalytics,
}) {
  final buffer = StringBuffer()
    ..writeln('## SCRAPPABLE DETAILS')
    ..writeln('')
    ..writeln('**Name**: ${scrappable.name}')
    ..writeln('**Description**: ${scrappable.description}')
    ..writeln('**Consecutive Errors**: ${scrappable.currentConsecutiveErrors}')
    ..writeln('')
    ..writeln('### Reference URL')
    ..writeln('```')
    ..writeln(referenceTestData.referenceLinkUsed)
    ..writeln('```')
    ..writeln('')
    ..writeln('### URL Template')
    ..writeln('```')
    ..writeln(scrappableRequest.url)
    ..writeln('```')
    ..writeln('')
    ..writeln('### Path Parameters')
    ..writeln(scrappableRequest.pathParams.isEmpty
        ? '(none)'
        : scrappableRequest.pathParams.join(', '))
    ..writeln('')
    ..writeln('### Query Parameters')
    ..writeln('```json')
    ..writeln(jsonEncode(scrappableRequest.queryParams))
    ..writeln('```');

  if (scrappableRequest.queryParamsNotRelatedToUrl.isNotEmpty) {
    buffer
      ..writeln('')
      ..writeln('### Client-Side Parameters (for js_scenario placeholders)')
      ..writeln('```json')
      ..writeln(jsonEncode(scrappableRequest.queryParamsNotRelatedToUrl))
      ..writeln('```');
  }

  buffer
    ..writeln('')
    ..writeln('---')
    ..writeln('')
    ..writeln('## CURRENT EXTRACTION CONFIGURATION (BROKEN)')
    ..writeln('')
    ..writeln('### ScrapingBee Settings')
    ..writeln('- **render_js**: ${extractLogic.renderJs}')
    ..writeln('- **premium_proxy**: ${extractLogic.premiumProxy}')
    ..writeln('- **stealth_proxy**: ${extractLogic.stealthProxy}')
    ..writeln('- **country_code**: ${extractLogic.countryCode ?? "us"}')
    ..writeln('- **wait**: ${extractLogic.wait ?? "(none)"}')
    ..writeln('- **wait_for**: ${extractLogic.waitFor ?? "(none)"}')
    ..writeln('- **wait_browser**: ${extractLogic.waitBrowser ?? "(none)"}')
    ..writeln('')
    ..writeln('### Current Extract Rules')
    ..writeln('```json')
    ..writeln(extractLogic.extractRules)
    ..writeln('```');

  if (extractLogic.jsScenario != null && extractLogic.jsScenario!.isNotEmpty) {
    buffer
      ..writeln('')
      ..writeln('### Current JS Scenario')
      ..writeln('```json')
      ..writeln(extractLogic.jsScenario)
      ..writeln('```');
  }

  // Add recent error information
  if (recentAnalytics.isNotEmpty) {
    buffer
      ..writeln('')
      ..writeln('---')
      ..writeln('')
      ..writeln('## RECENT ERROR HISTORY')
      ..writeln('')
      ..writeln(
          'The following are the most recent errors (up to 10) that triggered this auto-fix:')
      ..writeln('');

    final errors = recentAnalytics
        .where((a) => a.requestStatus != RequestStatus.success)
        .take(10)
        .toList();

    for (var i = 0; i < errors.length; i++) {
      final error = errors[i];
      buffer
        ..writeln('### Error ${i + 1} (${error.requestedAt.toIso8601String()})')
        ..writeln('- **Status**: ${error.requestStatus.name}');

      if (error.details != null) {
        if (error.details!.title != null) {
          buffer.writeln('- **Title**: ${error.details!.title}');
        }
        if (error.details!.description != null) {
          buffer.writeln('- **Description**: ${error.details!.description}');
        }
      }
      buffer.writeln('');
    }
  }

  // Add last known good result if available
  final lastGoodResult = referenceTestData.scrapResultJson;
  if (lastGoodResult != null && lastGoodResult.isNotEmpty) {
    final truncated = lastGoodResult.length > 1000
        ? '${lastGoodResult.substring(0, 1000)}... [truncated]'
        : lastGoodResult;
    buffer
      ..writeln('---')
      ..writeln('')
      ..writeln('## LAST KNOWN GOOD OUTPUT')
      ..writeln('')
      ..writeln(
          'This is the expected output structure. Your fix should produce similar data:')
      ..writeln('```json')
      ..writeln(truncated)
      ..writeln('```');
  }

  buffer
    ..writeln('')
    ..writeln('---')
    ..writeln('')
    ..writeln('## YOUR TASK')
    ..writeln('')
    ..writeln(
        '1. Navigate to the reference URL using Playwright to see the current page structure')
    ..writeln(
        '2. Compare the current HTML with the extraction rules to identify what changed')
    ..writeln(
        '3. Update the selectors/rules to match the current site structure')
    ..writeln('4. Test your fix using ScrapingBee MCP')
    ..writeln('5. Return the working configuration')
    ..writeln('')
    ..writeln(
        '**IMPORTANT**: Keep the same field names in the output. Users depend on the existing API response structure.');

  return buffer.toString();
}

/// Builds the initial user prompt that triggers the auto-fix process
String buildAutoFixUserPrompt() {
  return '''This scrappable has been failing consistently and needs automatic repair.

Please:
1. Explore the current page structure using Playwright
2. Identify what changed that caused the extraction to fail
3. Fix the extraction rules to work with the current site
4. Test your fix with ScrapingBee MCP
5. Return the working configuration

Start by navigating to the reference URL and getting a page snapshot.''';
}
