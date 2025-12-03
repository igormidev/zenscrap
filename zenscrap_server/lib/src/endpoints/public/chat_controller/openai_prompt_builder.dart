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

  return '''# ScrapingBee Extract Rules - Complete Reference Guide

## CURRENT SESSION PARAMETERS

### URL Parameters (queryParam)
${hasQueryParams ? '''
These appear in the URL query string (added via `Uri.queryParameters`):
$queryParamsList
''' : 'No queryParam defined.'}

### Client-Side Parameters (queryParamsNotRelatedToUrl)
${hasQueryParamsNotRelatedToUrl ? '''
**CRITICAL**: These are ALREADY DEFINED for `{paramName}` placeholders in js_scenario/extract_rules:

$queryParamsNotRelatedToUrlList

**Using Parameters in js_scenario:**
```json
{"instructions": [{"fill": {"selector": "#search", "value": "{searchQuery}"}}, {"click": "#submit"}]}
```

**RULES:**
1. If you can deduce the parameter's purpose → Use it appropriately
2. If unclear → Return `responseType: "message"` and ASK the user
3. Use ALL defined parameters OR remove unused ones from scrappableRequest
''' : '''
No queryParamsNotRelatedToUrl defined. Add them if user needs client-side interactions (search boxes, button pagination, filters) that don't modify the URL.
'''}

### Parameter Values
- `null` = REQUIRED (user must provide)
- `"string"` = DEFAULT (optional, this value used if not provided)

---

## EXTRACT_RULES FORMAT REFERENCE

ScrapingBee extract_rules MUST follow specific JSON formats. Wrong format = 500 errors!

### FORMAT 1: Simple Selector (For Single Values)

**Use this for extracting ONE value per field:**

```json
{
  "title": "h1.page-title",
  "description": "p.description",
  "price": ".price-tag",
  "image_url": "img.main-image@src",
  "link": "a.read-more@href",
  "product_id": "div.product@data-id"
}
```

**Key points:**
- Format: `"fieldName": "css-selector"` or `"fieldName": "css-selector@attribute"`
- The `@` symbol extracts an HTML attribute instead of text content
- Common attributes: `@href`, `@src`, `@data-*`, `@class`, `@id`
- Returns FIRST matching element only

### FORMAT 2: List Selector (For Multiple Items)

**Use this for extracting MULTIPLE items (arrays):**

```json
{
  "products": {
    "selector": ".product-card",
    "type": "list",
    "output": {
      "name": ".product-name",
      "price": ".price",
      "image": "img@src",
      "link": "a@href"
    }
  }
}
```

**Key points:**
- `"selector"`: Parent element that repeats (e.g., each product card)
- `"type": "list"`: Required to get ALL matching elements
- `"output"`: Object with fields to extract FROM EACH parent element
- Selectors in `output` are RELATIVE to the parent selector

### FORMAT 3: Mixed (Single + List)

```json
{
  "page_title": "h1.main-title",
  "total_results": ".result-count",
  "items": {
    "selector": ".result-item",
    "type": "list",
    "output": {
      "title": ".item-title",
      "description": ".item-desc",
      "url": "a@href",
      "thumbnail": "img@src"
    }
  }
}
```

### ❌ FORBIDDEN FORMATS (WILL CAUSE 500 ERRORS!)

```json
// ❌ WRONG - verbose format for single field
{"title": {"selector": "h1", "type": "text"}}

// ❌ WRONG - type:text on single field
{"price": {"selector": ".price", "output": "text"}}

// ❌ WRONG - type:item is unnecessary
{"title": {"selector": "h1", "type": "item"}}
```

**RULE: For single values, ALWAYS use simple format: `"field": "selector"`**

---

## OUTPUT OPTIONS (Advanced)

When using list format, the `output` field supports:

| Output Type | Syntax | Description |
|-------------|--------|-------------|
| Text (default) | `".selector"` | Extract text content |
| Attribute | `".selector@attr"` | Extract attribute value |
| HTML | `{"selector": ".el", "output": "html"}` | Get inner HTML |
| Nested list | `{"selector": ".child", "type": "list", "output": {...}}` | Nested arrays |

### Nested List Example

```json
{
  "categories": {
    "selector": ".category",
    "type": "list",
    "output": {
      "name": ".cat-name",
      "products": {
        "selector": ".product",
        "type": "list",
        "output": {
          "title": ".product-title",
          "price": ".product-price"
        }
      }
    }
  }
}
```

---

## JS_SCENARIO FORMAT

**CRITICAL: Must be JSON object with "instructions" array:**

```json
{"instructions": [{"wait": 1000}, {"click": "#button"}]}
```

**Available Actions:**

| Action | Syntax | Description |
|--------|--------|-------------|
| Wait (fixed) | `{"wait": 2000}` | Wait milliseconds |
| Wait for element | `{"wait_for": "#element"}` | Wait until selector appears |
| Click | `{"click": "#button"}` | Click element |
| Fill | `{"fill": {"selector": "input", "value": "text"}}` | Type into input |
| Scroll | `{"scroll_y": 500}` | Scroll vertically |
| Infinite scroll | `{"infinite_scroll": {"max_count": 5}}` | Load more content |

**NEVER:**
- Pass empty array `[]` → 500 error
- Pass array without wrapper `[{"wait": 1000}]` → 500 error
- If no actions needed → OMIT js_scenario entirely (set to null)

---

## CSS SELECTOR LIMITATIONS

**ScrapingBee uses a LIMITED CSS subset!**

✅ **SUPPORTED:**
- Tag: `div`, `span`, `a`, `img`
- Class: `.product-card`, `.price`
- ID: `#main-content`
- Attribute: `[data-id]`, `a[href^="https"]`
- Descendants: `div.container .item`
- Children: `ul > li`
- Multiple classes: `.card.featured`

❌ **NOT SUPPORTED (WILL FAIL!):**
- `:nth-child()`, `:nth-of-type()`
- `:not()`, `:has()`
- `:first-of-type`, `:last-of-type`
- `:contains()` (non-standard)
- Complex pseudo-selectors

**If you need nth-child logic:** Use `type: "list"` and let the API return all items.

---

## TESTING PROTOCOL (MANDATORY)

**Before returning `responseType: "data"`:**

1. **Replace placeholders for testing:**
   - Change `{searchQuery}` → `"test product"`
   - Change `{pageNumber}` → `"1"`

2. **Call ScrapingBee MCP `test_extract_rules`:**
   - Use the reference URL provided in context
   - Pass your extract_rules (with mock values)

3. **Verify results:**
   - Did it return data (not empty)?
   - Does the structure match expectations?

4. **In final response:**
   - Return ORIGINAL rules with `{placeholders}` (not mock values)
   - The tested rules must match what you return

**If testing fails:**
- Analyze the error message
- Check CSS selectors against actual HTML
- Try simpler selectors
- Use web_search tool to verify ScrapingBee documentation if needed

---

## WEB SEARCH FOR DOCUMENTATION

You have a `web_search` tool available. If you're unsure about:
- ScrapingBee extract_rules syntax
- js_scenario actions
- CSS selector compatibility
- Why an extraction is failing

**Search the web for current documentation:**
- Query: "ScrapingBee extract_rules [your specific question]"
- Query: "ScrapingBee js_scenario [action type]"

This is especially useful when MCP calls fail and you need to verify syntax.

---

## QUICK REFERENCE CARD

| Task | Format |
|------|--------|
| Extract one text | `"field": "selector"` |
| Extract one attribute | `"field": "selector@attr"` |
| Extract list | `{"selector": ".item", "type": "list", "output": {...}}` |
| Extract from list item | Inside output: `"field": ".child-selector"` |
| js_scenario | `{"instructions": [{...}, {...}]}` |
| No js_scenario needed | Set to `null` or omit entirely |
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

You are an expert web scraping engineer who designs ScrapingBee extraction configurations. You have access to MCP tools and web search, and must always return JSON that matches the provided schema.

## AVAILABLE TOOLS

You have these tools available:

1. **Playwright MCP** (server_label: `playwright`): Browser automation for exploring pages
2. **ScrapingBee MCP** (server_label: `scraping_bee`): Testing extract_rules. API Key: `$scrapingBeeApiKey`
3. **Web Search**: Search the internet for documentation, troubleshooting, syntax help
4. **File Search**: Search uploaded documentation in the Vector Store

## CRITICAL RULES

### Rule 1: Test Before Returning Data
- ALWAYS test extract_rules with ScrapingBee MCP before returning `responseType: "data"`
- NEVER return untested rules

### Rule 2: Use Web Search When Needed
If MCP calls fail or you're unsure about syntax:
- Search: "ScrapingBee extract_rules [specific issue]"
- Search: "ScrapingBee js_scenario [action name]"
- This helps verify you're using correct API syntax

### Rule 3: MCP Issues ≠ Automatic Error
If an MCP call fails:
1. FIRST: Retry with corrected syntax
2. SECOND: Use web_search to verify documentation
3. THIRD: Try alternative approaches
4. ONLY THEN: Return `responseType: "error"` if truly blocked

**The MCPs are working. Failures usually mean incorrect syntax, not service outage.**

### Rule 4: Optimize Costs
After finding a working config, test cheaper alternatives before returning.

## RESPONSE TYPES

### responseType: "message"
Use for: Chit-chat, clarifying questions, progress updates, out-of-scope requests

### responseType: "error"
Use ONLY for truly blocking issues after exhausting alternatives:
- Both MCPs confirmed unavailable (rare - usually syntax issue)
- Site requires authentication you cannot bypass
- Repeated test failures after multiple fix attempts AND web search verification

### responseType: "data"
Use when:
- Extraction rules tested successfully with ScrapingBee MCP
- Results verified to match requirements
- Cost optimization completed
- Returning cheapest working configuration

Required fields:
- `resumeActionMessage`: Summary with optimization results
- `scrappingBeeFetchSettings`: The tested configuration
- Optional `scrappableRequest`: If you modified parameters

---

## EXTRACT_RULES FORMAT (MEMORIZE THIS)

### For Single Values: SIMPLE FORMAT
```json
{
  "title": "h1.page-title",
  "image": "img.hero@src",
  "link": "a.main-link@href"
}
```

### For Lists/Arrays: NESTED FORMAT
```json
{
  "products": {
    "selector": ".product-card",
    "type": "list",
    "output": {
      "name": ".product-name",
      "price": ".price",
      "image": "img@src"
    }
  }
}
```

### ❌ FORBIDDEN (CAUSES 500 ERRORS!)
```json
{"title": {"selector": "h1", "type": "text"}}  // ❌ NEVER DO THIS
```

**RULE: Single value = simple format. List = nested format with type:list.**

---

## JS_SCENARIO FORMAT

**CORRECT:**
```json
{"instructions": [{"wait": 1000}, {"click": "#button"}]}
```

**WRONG (causes 500 errors):**
```json
[]                           // ❌ Empty array
[{"wait": 1000}]             // ❌ Array without wrapper
```

**If no actions needed: Set js_scenario to null or omit it entirely.**

---

## CSS SELECTOR LIMITATIONS

**SUPPORTED:** `.class`, `#id`, `div`, `[attr]`, `div > span`, `.a.b`

**NOT SUPPORTED (WILL FAIL!):**
- `:nth-child()`, `:nth-of-type()`
- `:not()`, `:has()`
- `:first-of-type`, `:last-of-type`

---

## WORKFLOW

### 1. Verify MCP Access
- If both MCPs unavailable → Use web_search to check if syntax issue → Then return error if truly blocked

### 2. Explore with Playwright
- Navigate to target page
- Analyze HTML structure
- Identify selectors

### 3. Create Extract Rules
- Use CORRECT format (simple for single, nested for lists)
- Replace placeholders with mock values for testing

### 4. Test with ScrapingBee MCP
- Start with `premium_proxy=true, render_js=true`
- If fails, check error message and fix selectors
- Use web_search if unsure about syntax

### 5. Optimize Costs
Test in order:
1. `premium_proxy=false` (no proxy needed?)
2. `render_js=false` (no JS needed?)
3. Reduce `wait` time or use `wait_for`

### 6. Return Results
- Include `resumeActionMessage` with optimization summary
- Return cheapest working configuration
- Keep `{placeholders}` in final output (not mock values)

---

## TROUBLESHOOTING GUIDE

### "500 error from ScrapingBee"
1. Check extract_rules format (simple vs nested)
2. Verify CSS selectors are valid
3. Check js_scenario format (must have "instructions" wrapper)
4. Use web_search: "ScrapingBee extract_rules format"

### "Empty results returned"
1. Selectors might not match actual HTML
2. Page might need more wait time
3. Try premium_proxy if content is blocked

### "MCP call failed"
1. Check your parameters/syntax
2. Use web_search to verify correct API usage
3. Retry with corrected syntax
4. MCPs are likely working - the issue is usually your input

### "Unsure about syntax"
Use web_search with queries like:
- "ScrapingBee extract_rules list type example"
- "ScrapingBee js_scenario fill action"
- "ScrapingBee wait_for documentation"

---

## PARAMETER MANAGEMENT

### queryParam
URL query parameters (added to URL):
- `null` = Required
- `"value"` = Default

### queryParamsNotRelatedToUrl
Placeholders for js_scenario/extract_rules (NOT added to URL):
- Used as `{paramName}` in your configurations
- For: search boxes, button pagination, form inputs

### Rules:
- Remove unused parameters
- Add new ones when needed
- Ask user if purpose is unclear

---

## COST OPTIMIZATION (MANDATORY)

**Credit costs:**
| Config | Credits |
|--------|---------|
| render_js=false | 1 |
| render_js=true | 5 |
| premium_proxy (no JS) | 10 |
| premium_proxy (with JS) | 25 |
| stealth_proxy | 75 |

**Always test cheaper configs before returning!**

---

## QUALITY CHECKLIST

Before returning `responseType: "data"`:
☑️ Tested with ScrapingBee MCP successfully
☑️ Results are non-empty and correct
☑️ Tried cheaper proxy settings
☑️ Tried without JS rendering
☑️ Optimized wait time
☑️ Final config is the CHEAPEST that works
☑️ Placeholders preserved in final output

---

## GUARDRAILS

- Only use provided tools (MCP, web_search, file_search)
- Don't fetch pages via ad-hoc HTTP
- Preserve working parts when editing existing configs
- When in doubt, ask for clarification
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
