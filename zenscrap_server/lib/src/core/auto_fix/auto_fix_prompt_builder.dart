import 'dart:convert';

import 'package:zenscrap_server/src/generated/protocol.dart';

/// Builds the system prompt for auto-fix AI sessions.
/// This is a specialized, single-shot prompt focused on fixing broken extraction rules.
String buildAutoFixSystemPrompt() {
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
2. **ScrapingBee MCP** (server_label: `scraping_bee`): Testing extract_rules (API key is configured server-side, no need to pass it)
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

/// Builds the context prompt with scrappable details, error history, and timeline context
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

  // Add timeline context and error analysis
  if (recentAnalytics.isNotEmpty) {
    buffer
      ..writeln('')
      ..writeln('---')
      ..writeln('')
      ..writeln('## ERROR TIMELINE & ANALYSIS')
      ..writeln('');

    // Separate successes and failures
    final successes = recentAnalytics
        .where((a) => a.requestStatus == RequestStatus.success)
        .toList();
    final failures = recentAnalytics
        .where((a) => a.requestStatus != RequestStatus.success)
        .toList();

    // Build timeline context
    if (successes.isNotEmpty && failures.isNotEmpty) {
      // Sort to find timeline boundaries
      final sortedSuccesses = List<ScrappableAnalytics>.from(successes)
        ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
      final sortedFailures = List<ScrappableAnalytics>.from(failures)
        ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

      final lastSuccess = sortedSuccesses.first;
      final firstFailureAfterSuccess = sortedFailures.lastWhere(
        (f) => f.requestedAt.isAfter(lastSuccess.requestedAt),
        orElse: () => sortedFailures.first,
      );

      buffer
        ..writeln('### Failure Timeline')
        ..writeln('')
        ..writeln('⚠️ **IMPORTANT CONTEXT:**')
        ..writeln(
            '- **Last successful request**: ${_formatDateTime(lastSuccess.requestedAt)}')
        ..writeln(
            '- **First error after that**: ${_formatDateTime(firstFailureAfterSuccess.requestedAt)}')
        ..writeln('')
        ..writeln(
            'The scrappable **worked correctly until ${_formatDateTime(lastSuccess.requestedAt)}** but started failing around ${_formatDateTime(firstFailureAfterSuccess.requestedAt)}.')
        ..writeln('')
        ..writeln(
            'This suggests something changed on the website between these two dates.')
        ..writeln('');

      // Add last successful payload/response example if available
      if (lastSuccess.details?.stringifiedPayload != null ||
          lastSuccess.details?.stringifiedResponse != null) {
        buffer
          ..writeln('---')
          ..writeln('')
          ..writeln('## LAST SUCCESSFUL REQUEST/RESPONSE')
          ..writeln('')
          ..writeln(
              'This is what a **working** request looked like. Use this as reference for what the output should be:')
          ..writeln('');

        final successPayload = lastSuccess.details?.stringifiedPayload;
        if (successPayload != null) {
          final truncatedPayload = successPayload.length > 2000
              ? '${successPayload.substring(0, 2000)}... [truncated]'
              : successPayload;
          buffer
            ..writeln('### Successful Request Payload')
            ..writeln('```json')
            ..writeln(truncatedPayload)
            ..writeln('```')
            ..writeln('');
        }

        if (lastSuccess.details?.stringifiedResponse != null) {
          final response = lastSuccess.details!.stringifiedResponse!;
          final truncatedResponse = response.length > 3000
              ? '${response.substring(0, 3000)}... [truncated]'
              : response;
          buffer
            ..writeln('### Successful Response (Expected Output)')
            ..writeln('')
            ..writeln(
                'Your fix should produce data with the same structure as this:')
            ..writeln('```json')
            ..writeln(truncatedResponse)
            ..writeln('```')
            ..writeln('');
        }
      }
    }

    // Add recent error details
    buffer
      ..writeln('---')
      ..writeln('')
      ..writeln('## RECENT ERRORS')
      ..writeln('')
      ..writeln(
          'The following errors triggered this auto-fix (most recent first):')
      ..writeln('');

    final recentErrors = failures.take(5).toList();
    for (var i = 0; i < recentErrors.length; i++) {
      final error = recentErrors[i];
      buffer
        ..writeln(
            '### Error ${i + 1} (${_formatDateTime(error.requestedAt)})')
        ..writeln('- **Status**: ${error.requestStatus.name}');

      if (error.details != null) {
        if (error.details!.title != null) {
          buffer.writeln('- **Title**: ${error.details!.title}');
        }
        if (error.details!.description != null) {
          buffer.writeln('- **Description**: ${error.details!.description}');
        }
        // Include failed payload if available
        final errorPayload = error.details?.stringifiedPayload;
        if (errorPayload != null) {
          final truncated = errorPayload.length > 500
              ? '${errorPayload.substring(0, 500)}... [truncated]'
              : errorPayload;
          buffer
            ..writeln('- **Request Payload**:')
            ..writeln('  ```json')
            ..writeln('  $truncated')
            ..writeln('  ```');
        }
      }
      buffer.writeln('');
    }
  }

  // Add last known good result if available (fallback if no analytics)
  final lastGoodResult = referenceTestData.scrapResultJson;
  if (lastGoodResult != null && lastGoodResult.isNotEmpty) {
    final truncated = lastGoodResult.length > 1000
        ? '${lastGoodResult.substring(0, 1000)}... [truncated]'
        : lastGoodResult;
    buffer
      ..writeln('---')
      ..writeln('')
      ..writeln('## REFERENCE OUTPUT STRUCTURE')
      ..writeln('')
      ..writeln(
          'This is the expected output structure from reference test data:')
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

/// Formats DateTime for display in prompts
String _formatDateTime(DateTime dt) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} UTC';
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
