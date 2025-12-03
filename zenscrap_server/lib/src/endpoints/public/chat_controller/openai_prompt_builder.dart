import 'dart:convert';

import 'package:zenscrap_server/src/endpoints/public/chat_controller/web_scraper_ai_models.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

// ============================================================================
// OpenAI Files & Vector Store Management
// ============================================================================

/// Manages OpenAI Vector Store for static documentation files.
/// Uses file_search tool instead of input_file to support .md files.
///
/// Architecture:
/// - Static docs (cost optimization, edit request, structure guide) are uploaded
///   once at server startup to a global Vector Store.
/// - Session-specific extraction rules guide is sent as inline system message
///   (not as a file) to avoid per-session Vector Store complexity.
/// - The file_search tool is added to requests to search the global Vector Store.
class OpenAiFileManager {
  /// Global Vector Store ID containing all static documentation
  static String? _vectorStoreId;

  /// File IDs for static documentation files (needed for reference)
  static String? _costOptimizationFileId;
  static String? _howToEditRequestFileId;
  static String? _requestStructureGuideFileId;

  /// Returns true if the Vector Store has been created and all files uploaded
  static bool get isInitialized => _vectorStoreId != null;

  /// The global Vector Store ID for use in file_search tool
  static String? get vectorStoreId => _vectorStoreId;

  /// File IDs (primarily for reference/debugging)
  static String? get costOptimizationFileId => _costOptimizationFileId;
  static String? get howToEditRequestFileId => _howToEditRequestFileId;
  static String? get requestStructureGuideFileId => _requestStructureGuideFileId;

  /// Sets the Vector Store ID and file IDs after initialization
  static void setVectorStoreData({
    required String vectorStoreId,
    required String costOptimizationFileId,
    required String howToEditRequestFileId,
    required String requestStructureGuideFileId,
  }) {
    _vectorStoreId = vectorStoreId;
    _costOptimizationFileId = costOptimizationFileId;
    _howToEditRequestFileId = howToEditRequestFileId;
    _requestStructureGuideFileId = requestStructureGuideFileId;
  }

  /// Clears all stored IDs (for testing or reset purposes)
  static void reset() {
    _vectorStoreId = null;
    _costOptimizationFileId = null;
    _howToEditRequestFileId = null;
    _requestStructureGuideFileId = null;
  }
}

// ============================================================================
// Static Documentation Content (Uploaded Once at Server Startup)
// ============================================================================

/// Cost Optimization Strategy - uploaded once and reused
const String costOptimizationGuide = '''# Cost Optimization Strategy for ScrapingBee

## Credit Costs

ScrapingBee charges different credit amounts based on parameters:

| Configuration | Credits | Use Case |
|--------------|---------|----------|
| Basic request (render_js=false) | 1 | Static HTML sites |
| JavaScript rendering (render_js=true) | 5 | Most modern websites |
| Premium proxy without JS | 10 | Protected static sites |
| Premium proxy with JS | 25 | Most protected sites |
| Stealth proxy | 75 | **RARELY NEEDED** - LinkedIn, Facebook, Instagram |
| Google domains (custom_google=true) | 20 | Any Google domain |

**IMPORTANT**: Stealth proxy is RARELY needed! Only a small fraction of sites require it (mainly LinkedIn, Facebook, Instagram, and other heavily protected social media). Most e-commerce and content sites work fine with premium_proxy or even no proxy at all.

## Optimization Strategy Summary

**Your goal**: Find the CHEAPEST configuration that works reliably.

**Reality Check:**
- **70%** of sites work with just `render_js=true` (5 credits)
- **25%** need `premium_proxy=true` (25 credits)
- Only **5%** need `stealth_proxy=true` (75 credits)

## Testing Order (ALWAYS follow this)

### 1. Initial Testing Phase - Finding What Works

**Start with:** `premium_proxy=true, render_js=true` (25 credits)

Did it work? (extracted the data correctly)
- **YES** → Move to Optimization Phase
- **NO** (captcha, blocked, empty data) → Try with `stealth_proxy=true` (75 credits)
  - Still doesn't work? → The site may need special handling or authentication
  - Works with stealth? → Note that stealth is required (RARE - mainly LinkedIn, Meta platforms)

### 2. Optimization Phase - Finding Minimum Requirements

**If your rules worked with premium_proxy:**

a) Test WITHOUT premium_proxy (set `premium_proxy=false`)
- **Works?** → Great! No proxy needed, move to JS testing
- **Fails?** → Keep `premium_proxy=true`, move to JS testing

**If your rules required stealth_proxy:**

a) Try downgrading to just `premium_proxy=true` (no stealth)
- **Works?** → Use premium_proxy instead of stealth (saves 50 credits!)
- **Fails?** → Must use stealth_proxy (very expensive but necessary)

### 3. JavaScript Optimization

With your determined proxy setting:

a) Try with `render_js=false`
- **Works?** → Great! Use without JS rendering (saves 4+ credits per request)
- **Fails?** → Keep `render_js=true`

**Test each configuration 2-3 times to ensure consistency!**

## Dynamic Country Proxy Selection

### When to Use Specific Countries (CRITICAL)

**Analyze the target URL and user request to determine the appropriate country:**

1. **E-commerce Sites with Regional Versions:**
   - Amazon.de → Use 'de' (Germany)
   - Amazon.co.uk → Use 'gb' (United Kingdom)
   - Mercadolibre.com.ar → Use 'ar' (Argentina)

2. **Domain TLD Indicators:**
   - .de domains → Consider 'de'
   - .fr domains → Consider 'fr'
   - .co.uk domains → Consider 'gb'
   - .com.br domains → Consider 'br'

### Default Country Selection

**DEFAULT TO 'us' UNLESS:**
1. The target domain clearly indicates another country
2. The user explicitly requests a different country
3. The site content is region-locked

## Special Cases

### Google Domains
**ALWAYS** set `custom_google=true` for Google domains without testing alternatives.
- Cost: 20 credits (flat rate)
- Domains: google.com, news.google.com, scholar.google.com, etc.

### Known Sites Requiring Stealth Proxy (Very Short List)
- LinkedIn (almost always needs stealth)
- Facebook/Instagram/Meta platforms
- Some heavily protected financial sites
- **Everything else usually works with premium_proxy or less**

## Key Takeaways

✅ **Start with premium_proxy=true** - works for 90%+ of sites
✅ **Always try to optimize down** - every step saves credits
✅ **Test configurations 2-3 times** - ensure consistency
✅ **stealth_proxy is RARE** - only LinkedIn, Meta, and few others need it

❌ **Don't start with stealth_proxy** - it's almost never needed
❌ **Don't use expensive settings by default** - optimize for cost
❌ **Don't skip testing cheaper alternatives** - you might be wasting credits

Remember: Your goal is to find the CHEAPEST configuration that works reliably!
''';

/// How to Edit Scrappable Request - uploaded once and reused
const String howToEditScrappableRequest = '''# How to Edit Scrappable Request Structure

This guide explains how to modify the scrappable request configuration to add/remove parameters and set default values.

## Overview

The scrappable request structure defines:
- **URL template** with path parameter placeholders
- **Query parameters** that appear in the URL
- **Query parameters NOT related to URL** for client-side interactions
- **Path parameters** list

You have FULL CONTROL to modify this structure based on user needs.

## Modifying Query Parameters

### queryParam (URL-based parameters)

These parameters are added to the URL using `Uri(queryParameters:)`.

**Adding a parameter:**
```json
{
  "queryParam": {
    "sort": "asc",           // Static default value
    "page": null,            // Required - user must provide
    "filter": "all"          // Static default value
  }
}
```

**Setting default values:**
- **null**: Parameter is REQUIRED - user MUST provide in their API payload
- **"value"**: Parameter has a DEFAULT - user CAN override, but not required

### queryParamsNotRelatedToUrl (Client-side interaction parameters)

These parameters are used ONLY as `{paramName}` placeholders in extract_rules/js_scenario. They are NEVER added to the URL.

**Adding a parameter:**
```json
{
  "queryParamsNotRelatedToUrl": {
    "searchQuery": null,     // Required - user must provide
    "currentPage": null,     // Required - user must provide
    "minPrice": "0",         // Default "0" - optional for user
    "maxPrice": null         // Required - user must provide
  }
}
```

**When to add:**
- User needs client-side search (search box doesn't update URL)
- User needs button-based pagination (clicking buttons doesn't update URL)
- User needs JavaScript filters (dropdowns/sliders don't update URL)
- User needs any form inputs that don't affect URL

## Critical Rules for queryParamsNotRelatedToUrl

### Rule 1: Use It or Remove It
If you have `searchQuery` in `queryParamsNotRelatedToUrl` but don't use `{searchQuery}` in your js_scenario or extract_rules:
- ❌ **WRONG**: Leave it there unused
- ✅ **CORRECT**: Remove it from queryParamsNotRelatedToUrl

### Rule 2: Create Placeholders for Dynamic Values
If you use `{searchQuery}` in js_scenario, it MUST exist in `queryParamsNotRelatedToUrl`:
- ❌ **WRONG**: Use `{searchQuery}` without defining it
- ✅ **CORRECT**: Add `"searchQuery": null` to queryParamsNotRelatedToUrl

### Rule 3: Match Parameter Names Exactly
The parameter name in `queryParamsNotRelatedToUrl` must match the placeholder:
- ❌ **WRONG**: `queryParamsNotRelatedToUrl: {"search": null}` but use `{searchQuery}` in js_scenario
- ✅ **CORRECT**: `queryParamsNotRelatedToUrl: {"searchQuery": null}` and use `{searchQuery}` in js_scenario

## Decision Tree

### "Should I add a parameter?"
1. Does the user need this functionality? → NO: Don't add it
2. Does this appear in the URL? → YES: Add to `queryParam`; NO: Continue to 3
3. Is this for client-side interaction? → YES: Add to `queryParamsNotRelatedToUrl`

### "Should I set a default value?"
1. Is there a sensible default most users would want? → YES: Set it (e.g., `"sort": "asc"`)
2. Does the value vary significantly per user? → YES: Use null (required)
3. Is this a safety default? → YES: Set it (e.g., `"limit": "100"` to prevent huge requests)

## Key Takeaways

✅ **queryParam** = Appears in URL query string (added via `Uri.queryParameters`)
✅ **queryParamsNotRelatedToUrl** = Used ONLY as {paramName} placeholders, NEVER in URL
✅ **null value** = Parameter is REQUIRED
✅ **"string value"** = Parameter has a DEFAULT (optional for user)
✅ **Use it or lose it** = Remove unused parameters from queryParamsNotRelatedToUrl
✅ **Match exactly** = Parameter names must match placeholders in js_scenario/extract_rules
''';

/// Scrappable Request Structure Guide - uploaded once and reused
const String scrappableRequestStructureGuide = '''# Scrappable Request Structure Guide

This guide explains the structure of a `ScrappableRequest` and how to properly configure URL patterns, query parameters, and path parameters for web scraping.

## Overview

A `ScrappableRequest` defines how to construct URLs for scraping and which parameters users can provide dynamically. It consists of:

1. **url**: The URL template with path parameter placeholders
2. **queryParams**: Parameters that appear in and modify the URL (added via `Uri.queryParameters`)
3. **queryParamsNotRelatedToUrl**: Parameters for client-side interactions that do NOT modify the URL (used only as `{paramName}` placeholders in extract_rules/js_scenario)
4. **pathParams**: List of parameter names that were replaced in the URL with `{paramName}` placeholders

## Field Descriptions

### 1. url (String)
The URL template with dynamic parts replaced by `{paramName}` placeholders.

**Examples:**
- `https://example.com/products/{productId}`
- `https://blog.com/posts/{year}/{month}/{slug}`

**When to use placeholders:**
- Numeric IDs (user IDs, post IDs, product IDs, etc.)
- Unique identifiers (UUIDs, slugs, hashes)
- Variable names (usernames, product names that change)
- Date components in URLs (year, month, day)

### 2. queryParams (Map<String, String?>)
Query parameters that **appear in the URL** or **modify the URL**. These are added to the URL using `Uri(queryParameters:)`.

**When to use queryParams:**
- URL-based search (e.g., `?q=laptop` or `?search=product`)
- URL-based pagination (e.g., `?page=2` or `?offset=20`)
- URL-based filters (e.g., `?category=electronics&sort=price`)

**Value Guidelines:**
- Set to `null` if the parameter is dynamic (users will provide different values)
- Set to actual string value if it's a static default

### 3. queryParamsNotRelatedToUrl (Map<String, String?>)
Parameters for **client-side interactions** that do **NOT** modify the URL. These are used **ONLY** as `{paramName}` placeholders in extract_rules and js_scenario for runtime value replacement.

**THE CORE CONCEPT:**
Some websites have interactive features (search boxes, pagination buttons, filters) where user actions trigger JavaScript and update the page content, BUT the URL never changes. For these cases, you need queryParamsNotRelatedToUrl.

**When to use queryParamsNotRelatedToUrl:**

1. **Client-side search boxes** (URL doesn't change when searching):
   - User types in search box → Page updates via JavaScript → URL stays same
   - Parameter: `searchQuery: null`
   - Used in js_scenario: `{"type": "{searchQuery}"}`

2. **Pagination via button clicks** (not URL-based):
   - User clicks "Next" or page number button → Content loads → URL stays same
   - Parameter: `currentPage: null`
   - Used in js_scenario: `{"click": "button[data-page='{currentPage}']"}`

3. **Dropdown filters/selects** (client-side filtering):
   - User selects from dropdown → JavaScript filters content → URL stays same
   - Parameters: `category: null`, `location: null`
   - Used in js_scenario: `{"select": {"selector": "select#category", "value": "{category}"}}`

### 4. pathParams (List<String>)
An array of parameter names that were replaced in the URL with `{paramName}` placeholders.

**Important:** The names in this list must **exactly match** the placeholder names used in the `url` field.

## Decision Tree: Which Field Should I Use?

### For URL Path Components:
**Question:** Is this part of the URL path (not query string)?
- **YES** → Use placeholder in `url` field (e.g., `{productId}`) and add name to `pathParams` list

### For Parameters:
**Question:** Does this parameter appear in the URL query string (after `?`)?
- **YES** → Use `queryParams`
- **NO** → Ask: "Is this for client-side interaction?"
  - **YES** → Use `queryParamsNotRelatedToUrl`

**Question:** Does clicking a pagination button change the URL?
- **YES** (URL becomes `?page=2`) → Use `queryParams: {"page": null}`
- **NO** (URL stays the same) → Use `queryParamsNotRelatedToUrl: {"currentPage": null}`

## Key Takeaways

✅ **queryParams** = Appears in URL query string (added via `Uri.queryParameters`)
✅ **queryParamsNotRelatedToUrl** = Used for client-side interactions as `{paramName}` placeholders (NOT added to URL)
✅ **pathParams** = Names of `{placeholder}` parameters in the URL path
✅ **url** = URL template with path placeholders like `{productId}`

❌ **Don't** put client-side interaction parameters in `queryParams` if they don't modify the URL
❌ **Don't** add the same parameter to both `queryParams` and `queryParamsNotRelatedToUrl`
❌ **Don't** forget to list all path placeholder names in `pathParams`
''';

// ============================================================================
// Session-Specific Content (Generated Per Conversation)
// ============================================================================

/// Generates the extraction rules guide specific to the current scrappable request.
/// This is uploaded per-session because it contains dynamic parameter information.
String buildExtractionRulesGuide(WebScrapperRequest webScrapperRequest) {
  // Build dynamic parameter lists
  final queryParamsList = webScrapperRequest.queryParam.entries.map((e) {
    final hasDefault = e.value != null;
    return '  - **${e.key}**: ${hasDefault ? '"${e.value}" (default)' : 'null (REQUIRED)'}';
  }).join('\n');

  final queryParamsNotRelatedToUrlList =
      webScrapperRequest.queryParamsNotRelatedToUrl.entries.map((e) {
    final hasDefault = e.value != null;
    return '  - **${e.key}**: ${hasDefault ? '"${e.value}" (default)' : 'null (REQUIRED)'} → Use as `{${e.key}}` in js_scenario';
  }).join('\n');

  final hasQueryParams = webScrapperRequest.queryParam.isNotEmpty;
  final hasQueryParamsNotRelatedToUrl =
      webScrapperRequest.queryParamsNotRelatedToUrl.isNotEmpty;

  return '''# How to Write Effective ScrapingBee Extract Rules

## CURRENT SCRAPPABLE REQUEST PARAMETERS

### Available URL Parameters (queryParam)
${hasQueryParams ? '''
These parameters are added to the URL. You can use them in your URL construction:
$queryParamsList
''' : 'No queryParam parameters defined.'}

### Available Client-Side Parameters (queryParamsNotRelatedToUrl)
${hasQueryParamsNotRelatedToUrl ? '''
**CRITICAL**: These parameters are ALREADY DEFINED and available for use as `{paramName}` placeholders in your js_scenario and extract_rules:

$queryParamsNotRelatedToUrlList

**HOW TO USE PARAMETERS IN js_scenario:**

Parameters are placeholders that get replaced at runtime. The syntax is `{parameterName}`:

```json
{
  "instructions": [
    {"click": "selector.for.button"},
    {"type": "{anyParameterName}"},
    {"select": {"selector": "select#dropdown", "value": "{anotherParam}"}},
    {"fill": {"selector": "input.price", "value": "{priceParam}"}}
  ]
}
```

**CRITICAL DECISION RULES:**

1. **CAN you confidently deduce what a parameter is for?**
   - YES → Use it appropriately in js_scenario based on your analysis
   - NO → Return `responseType: "message"` and ASK the user for clarification

2. **YOU MUST use ALL defined parameters OR remove unused ones:**
   - ✅ If you use all parameters in your js_scenario → GOOD
   - ✅ If you don't need some parameters → Include them in the scrappableRequest removal
   - ❌ Leaving parameters defined but unused → BAD (confuses users)
''' : '''
No queryParamsNotRelatedToUrl parameters defined.

If user needs client-side interactions (search, pagination, filters, form inputs) that don't modify the URL:
1. You should add them to the request structure
2. Add to queryParamsNotRelatedToUrl field
'''}

### Parameter Value Types (IMPORTANT)
- **null (REQUIRED)**: User MUST provide this value in their API payload
- **"value" (DEFAULT)**: User CAN override, but if not provided, this default is used

## CRITICAL: extract_rules FORMAT REQUIREMENTS

ScrapingBee has STRICT format requirements. Using the wrong format will cause 500 errors!

### ✅ CORRECT FORMAT (Simple - use for ALL single fields)
```json
{
  "title": "h1.page-title",
  "description": "p.description",
  "image_url": "img.main-image@src",
  "link": "a.read-more@href"
}
```

### ✅ CORRECT FORMAT (List - use ONLY for arrays)
```json
{
  "products": {
    "selector": ".product-card",
    "type": "list",
    "output": {
      "name": ".product-name",
      "price": ".price@data-value",
      "image": "img@src"
    }
  }
}
```

### ❌ ABSOLUTELY FORBIDDEN (Verbose - causes 500 errors)
```json
{
  "title": {
    "selector": "h1.page-title",
    "type": "text"  // ❌ DO NOT DO THIS!
  }
}
```

## FORMAT RULES YOU MUST FOLLOW

1. **For single text/attribute fields:** Use SIMPLE format `"field": "selector"` or `"field": "selector@attribute"`
2. **For arrays/lists:** Use nested format with `"type": "list"` and `"output"`
3. **NEVER** use `"type": "text"` or `"type": "attribute"` for single fields
4. **To extract attributes:** Use the `@` syntax: `"img@src"`, `"a@href"`, `"div@data-id"`
5. The format `{"selector": "...", "type": "text"}` is **INVALID** and will fail!

## Testing with Mock Values (MANDATORY)

**CRITICAL**: When testing your extraction rules with the ScrapingBee MCP `test_extract_rules` tool, you MUST replace placeholders with realistic mock values!

**Why?** The ScrapingBee API doesn't understand `{parameterName}` syntax - it needs actual values to test.

**How to test:**
1. Before calling `test_extract_rules`, create a test version of your rules
2. Replace ALL placeholders with realistic mock values
3. Test with ScrapingBee MCP
4. Once validated, return the ORIGINAL rules (with placeholders intact)

## JS Scenario Documentation

**CRITICAL FORMAT REQUIREMENT:**
js_scenario MUST be a JSON object with an "instructions" array:
```json
{"instructions": [{"wait": 1000}, {"click": ".button"}]}
```

**NEVER pass:**
- Empty array `[]` - will cause 500 error
- Array of actions directly `[{"wait": 1000}]` - will cause 500 error
- Anything other than `{"instructions": [...]}` format

**If no actions are needed, OMIT the js_scenario parameter entirely!**

For complete js_scenario capabilities, see: https://www.scrapingbee.com/documentation/javascript-scenario/

Common actions (inside the instructions array):
- `{"wait": milliseconds}` - Wait for a fixed time
- `{"click": "selector"}` - Click an element
- `{"fill": {"selector": "input", "value": "text"}}` - Fill input field
- `{"wait_for": "selector"}` - Wait for element to appear
- `{"scroll_y": pixels}` - Scroll the page vertically
- `{"infinite_scroll": {"max_count": 10}}` - Trigger infinite scroll

## CSS Selector Limitations

**IMPORTANT: ScrapingBee uses a LIMITED CSS subset!**

**AVOID these pseudo-selectors (will cause errors):**
- `:nth-of-type()`, `:nth-child()` - NOT supported
- `:not()`, `:has()` - NOT supported
- `:first-of-type`, `:last-of-type` - NOT supported
- Complex combinators and filters

**USE these instead:**
- Class selectors: `.product-card`, `.item-name`
- ID selectors: `#main-content`
- Tag selectors: `h1`, `div`, `span`
- Attribute selectors: `[data-id]`, `a[href]`
- Basic descendant/child: `div.container > .item`
- Multiple classes: `.card.featured`

## Testing Requirements (ABSOLUTELY CRITICAL)

**MANDATORY TESTING PROTOCOL:**
1. You MUST test ALL extraction rules using the ScrapingBee MCP's `test_extract_rules` tool
2. NEVER return a `responseType: "data"` response without successful MCP validation
3. If testing fails, you MUST fix the rules and test again
4. Only return the EXACT rules that passed testing - no post-test modifications
5. The `extract_rules` in your final response must be IDENTICAL to what you tested
''';
}

// ============================================================================
// System Prompt Builder (Core Prompt Structure)
// ============================================================================

/// Builds the comprehensive system prompt for the web scraping AI assistant.
/// This merges the best elements from the legacy prompts into a unified structure.
String buildSystemPrompt({
  required String scrapingBeeApiKey,
}) {
  return '''# Web Scraping Expert System

You are an expert web scraping engineer who designs ScrapingBee extraction configurations. You have access to powerful MCP tools and must always return JSON that matches the provided schema.

## CRITICAL REQUIREMENTS - READ CAREFULLY

### 1. MCP Tools Are MANDATORY
You MUST use the provided MCP tools. These are NOT optional:
- **Playwright MCP** (server_label: `playwright`): For exploring pages, inspecting DOM, running interactions
- **ScrapingBee MCP** (server_label: `scraping_bee`): For testing extract_rules/js_scenario

**API Key for ScrapingBee MCP**: `$scrapingBeeApiKey`

### 2. ALWAYS Use Headless Mode
When using Playwright MCP, ALWAYS launch in headless mode (`"headless": true`). Visible browser windows are NOT acceptable.

### 3. MCP Unavailability = ERROR Response
If either MCP is unavailable, you MUST immediately return `responseType: "error"` explaining the missing tool. DO NOT attempt any workarounds.

### 4. Testing Is MANDATORY
You MUST test ALL extraction rules using ScrapingBee MCP's `test_extract_rules` tool before returning them. NEVER return untested rules - they WILL fail in production!

### 5. Cost Optimization Is MANDATORY
You MUST NOT return the first working configuration! After finding a working config, you MUST:
- Test cheaper alternatives (remove premium_proxy, remove render_js)
- Return ONLY the cheapest config that works
- Include optimization results in your resumeActionMessage
**Skipping optimization wastes the user's money on EVERY API call!**

## RESPONSE CONTRACT

Always respond with JSON matching the provided schema:
- `responseType`: Must be one of: "message" | "error" | "data"

### responseType: "message"
Use for:
- Chit-chat or conversational responses
- Asking clarifying questions
- Questions not related to modifying the scraper (respond that it's out of scope)
- Progress updates (use sparingly)

### responseType: "error"
Use for BLOCKING issues only:
- MCP tools are unavailable
- Site is completely inaccessible (consistent 403/401/captcha)
- Authentication walls that cannot be bypassed
- Repeated test failures after multiple fix attempts

### responseType: "data"
Use ONLY when you have:
- Successfully tested extraction rules with ScrapingBee MCP
- Verified the test results match user requirements
- **COMPLETED the full cost optimization sequence** (tested cheaper alternatives!)
- Confirmed you're returning the CHEAPEST working configuration

Must include:
- `resumeActionMessage`: Summary including what optimizations you tested and final cost
- `scrappingBeeFetchSettings`: The CHEAPEST tested configuration that works
- Optionally `scrappableRequest`: If you added/removed/modified parameters

**NEVER return `responseType: "data"` without:**
1. Successful MCP testing
2. Testing cheaper alternatives (premium_proxy=false, render_js=false)
3. Including optimization results in resumeActionMessage

## PARAMETER MANAGEMENT

### queryParam
Parameters that appear in the URL query string:
- Value `null` = Required (user must provide)
- Value `"string"` = Default value (optional for user)

### queryParamsNotRelatedToUrl
Client-side placeholders used ONLY in `{param}` substitutions inside extract_rules or js_scenario:
- These are NEVER added to the URL
- Use for: search boxes, button pagination, dropdown filters, form inputs

### pathParams
Names of `{param}` placeholders in the URL path (e.g., `{productId}` in `/products/{productId}`)

### Rules:
- Remove unused placeholders - don't leave defined parameters that aren't used
- Add new ones when interactions need runtime values
- Ask for clarification with `responseType: "message"` if a required placeholder's purpose is unclear

## EXTRACT_RULES FORMAT (CRITICAL)

### Single fields - Use SIMPLE format:
```json
{
  "title": "h1.page-title",
  "image": "img.main@src"
}
```

### Lists - Use nested format with "type": "list":
```json
{
  "items": {
    "selector": ".card",
    "type": "list",
    "output": {
      "name": ".name",
      "price": ".price"
    }
  }
}
```

### NEVER use verbose format for single fields:
❌ `{"title": {"selector": "h1", "type": "text"}}` - This WILL fail!

## WORKFLOW (DO NOT SKIP ANY STEP)

### Step 1: Verify MCP Access
- If MCPs are unavailable → Return error immediately
- Only proceed if both MCPs are working

### Step 2: Understand User Intent
- Is user just chatting? → Return message response
- Is request unclear? → Return message asking for clarification
- Is user asking for data extraction? → Continue to next steps

### Step 3: Explore with Playwright MCP (HEADLESS)
- Navigate and explore the target website
- Analyze HTML structure and identify extraction opportunities
- Test any interactions needed (search, pagination, filters)

### Step 4: Create Extraction Rules
- Use CORRECT format (simple for single fields, list for arrays)
- Use `{parameterName}` placeholders for dynamic values
- Create js_scenario if client-side interactions are needed

### Step 5: Initial Test with ScrapingBee MCP (MANDATORY)
- Replace placeholders with realistic mock values for testing
- **START with**: `premium_proxy=true`, `render_js=true` (25 credits)
- Test with `test_extract_rules` tool
- Verify extracted data matches expectations
- If test fails → Try `stealth_proxy=true` (75 credits) - ONLY if premium fails
- If still fails → Fix selectors and retry (up to 3 attempts)

### Step 6: Cost Optimization (MANDATORY - DO NOT SKIP!)

⚠️ **CRITICAL**: You MUST NOT return `responseType: "data"` after just finding a working config!
You MUST test cheaper alternatives and return the CHEAPEST configuration that works.

**MANDATORY OPTIMIZATION SEQUENCE** (test each with ScrapingBee MCP):

**If your config uses `stealth_proxy=true`:**
1. Test with `stealth_proxy=false, premium_proxy=true` → Did it work?
   - YES → Use premium_proxy instead (saves 50 credits!)
   - NO → Must use stealth_proxy, continue to step 2

**If your config uses `premium_proxy=true` (or you just downgraded from stealth):**
2. Test with `premium_proxy=false` → Did it work?
   - YES → No proxy needed! Continue to step 3
   - NO → Keep premium_proxy=true, continue to step 3

**JavaScript Optimization:**
3. Test with `render_js=false` → Did it work?
   - YES → No JS rendering needed (saves 4+ credits per request!)
   - NO → Keep render_js=true

**RECORD YOUR OPTIMIZATION RESULTS:**
In your `resumeActionMessage`, you MUST include:
- What you tested: "Tested: stealth→premium→no proxy, JS→no JS"
- What worked: "premium_proxy=false + render_js=true worked"
- Final cost: "Final config costs 5 credits/request (down from 25)"

### Step 7: Return Optimized Results
- Return ONLY the CHEAPEST tested configuration that works
- Keep placeholders in final output (not the mock values used for testing)
- Include scrappableRequest if you modified parameters
- Your `resumeActionMessage` MUST mention the optimization tests performed

## DOCUMENTATION FILES

You have access to documentation via the file_search tool (Vector Store) and inline system messages:

**Vector Store (searchable via file_search):**
- **Cost Optimization Guide**: Contains detailed credit costs and optimization workflow
- **How to Edit Request Guide**: Explains how to add/remove parameters
- **Request Structure Guide**: Explains queryParams vs queryParamsNotRelatedToUrl

**Inline System Message (always available in context):**
- **Extraction Rules Guide**: Contains format requirements and placeholder usage for THIS session's parameters

## QUALITY CHECKLIST (SELF-VERIFY BEFORE RESPONDING)

Before returning any `responseType: "data"` response, you MUST verify ALL of these:

### Extraction Testing
☑️ Did I test the extraction rules with ScrapingBee MCP?
☑️ Did the test return non-empty, correct results?
☑️ Are all placeholders in the final output (not mock values)?
☑️ Is the extract_rules format correct (simple for single fields)?
☑️ Are all defined parameters in queryParamsNotRelatedToUrl actually used?

### Cost Optimization (MANDATORY - ALL MUST BE YES)
☑️ Did I test with `premium_proxy=false` to check if proxy is needed?
☑️ Did I test with `render_js=false` to check if JS rendering is needed?
☑️ If I started with stealth_proxy, did I test with just premium_proxy?
☑️ Am I returning the CHEAPEST configuration that works?
☑️ Does my `resumeActionMessage` include what optimizations I tested?

### ❌ STOP! If any optimization checkbox is NO:
You MUST go back and test the cheaper alternative before returning!
Returning an unoptimized config wastes the user's money on every single API call!

## GUARDRAILS

- DO NOT suggest third-party services, proxies, or tools beyond the provided MCPs
- NEVER fetch pages via ad-hoc HTTP; only use MCP tools
- If repeated tests fail, return `responseType: "error"` describing the issue
- Preserve working parts when editing existing configs; only change what's needed
- When in doubt, ask the user for clarification rather than guessing
''';
}

// ============================================================================
// Context Prompt Builder (Session-Specific Context)
// ============================================================================

/// Builds the context prompt that contains session-specific information.
/// This is added to each conversation to provide current state.
String buildContextPrompt({
  required ReferenceTestData referenceTestData,
  required ScrappableRequest scrapperRequest,
  required ScrappingBeeExtractLogic? scrappingBeeLogic,
}) {
  final buffer = StringBuffer()
    ..writeln('## SESSION CONTEXT')
    ..writeln('')
    ..writeln('### Current Scrappable Configuration')
    ..writeln('- **Reference URL**: ${referenceTestData.referenceLinkUsed}')
    ..writeln(
        '- **URL Template**: ${scrapperRequest.url}')
    ..writeln('- **Path Parameters**: ${scrapperRequest.pathParams.isEmpty ? "(none)" : scrapperRequest.pathParams.join(", ")}')
    ..writeln(
        '- **Query Parameters**: ${jsonEncode(scrapperRequest.queryParams)}');

  if (scrapperRequest.queryParamsNotRelatedToUrl.isNotEmpty) {
    buffer.writeln(
        '- **Client-Side Parameters**: ${jsonEncode(scrapperRequest.queryParamsNotRelatedToUrl)}');
  }

  final scrapResultJson = referenceTestData.scrapResultJson;
  if (scrapResultJson != null && scrapResultJson.isNotEmpty) {
    final truncated = scrapResultJson.length > 1500
        ? '${scrapResultJson.substring(0, 1500)}... [truncated]'
        : scrapResultJson;
    buffer
      ..writeln('')
      ..writeln('### Last Test Results (Sample)')
      ..writeln('```json')
      ..writeln(truncated)
      ..writeln('```');
  }

  if (scrappingBeeLogic != null) {
    buffer
      ..writeln('')
      ..writeln('### Existing ScrapingBee Configuration')
      ..writeln('This scrappable already has working extraction rules. Modify only what the user requests.')
      ..writeln('')
      ..writeln('**Current Settings:**')
      ..writeln('- render_js: ${scrappingBeeLogic.renderJs}')
      ..writeln('- premium_proxy: ${scrappingBeeLogic.premiumProxy}')
      ..writeln('- stealth_proxy: ${scrappingBeeLogic.stealthProxy}')
      ..writeln('- country_code: ${scrappingBeeLogic.countryCode ?? "us"}')
      ..writeln('- wait: ${scrappingBeeLogic.wait ?? "(none)"}')
      ..writeln('- wait_for: ${scrappingBeeLogic.waitFor ?? "(none)"}')
      ..writeln('- wait_browser: ${scrappingBeeLogic.waitBrowser ?? "(none)"}');

    final extractRules = scrappingBeeLogic.extractRules;
    final truncatedRules = extractRules.length > 1500
        ? '${extractRules.substring(0, 1500)}... [truncated]'
        : extractRules;
    buffer
      ..writeln('')
      ..writeln('**Current Extract Rules:**')
      ..writeln('```json')
      ..writeln(truncatedRules)
      ..writeln('```');

    if (scrappingBeeLogic.jsScenario != null && scrappingBeeLogic.jsScenario!.isNotEmpty) {
      final jsScenario = scrappingBeeLogic.jsScenario!;
      final truncatedJs = jsScenario.length > 800
          ? '${jsScenario.substring(0, 800)}... [truncated]'
          : jsScenario;
      buffer
        ..writeln('')
        ..writeln('**Current JS Scenario:**')
        ..writeln('```json')
        ..writeln(truncatedJs)
        ..writeln('```');
    }
  } else {
    buffer
      ..writeln('')
      ..writeln('### Status')
      ..writeln('No existing extraction rules. You are creating them from scratch.');
  }

  buffer
    ..writeln('')
    ..writeln('---')
    ..writeln('Remember: Keep placeholders in final response. Use mock values only during MCP testing.');

  return buffer.toString();
}
