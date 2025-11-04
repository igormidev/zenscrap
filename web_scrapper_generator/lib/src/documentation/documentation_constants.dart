// GENERATED DOCUMENTATION CONSTANTS
// These constants contain hardcoded markdown documentation strings
// Source files are in: web_scrapper_generator/lib/src/documentation/

/// Shared documentation for ScrappableRequest structure
/// Used by both create_scrappable.dart endpoint and AI chat prompts
/// This is the SINGLE SOURCE OF TRUTH for request structure guidelines
const String scrappableRequestStructureGuide = '''
# Scrappable Request Structure Guide

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
- `www.mySocialMedia.com/posts/{postId}/comments/{commentId}`

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
- Any parameter that appears in the URL query string

**Value Guidelines:**
- Set to `null` if the parameter is dynamic (users will provide different values)
- Set to actual string value if it's a static default

**Examples:**
```json
{
  "q": null,              // Dynamic search query
  "page": null,           // Dynamic page number
  "sort": "price",        // Static default sort
  "limit": "20"           // Static default limit
}
```

### 3. queryParamsNotRelatedToUrl (Map<String, String?>)
Parameters for **client-side interactions** that do **NOT** modify the URL. These are used **ONLY** as `{paramName}` placeholders in extract_rules and js_scenario for runtime value replacement.

**CRITICAL DISTINCTION:** These parameters are NEVER added to the URL - they're only used for placeholder replacement in extraction logic.

**When to use queryParamsNotRelatedToUrl:**
- **Client-side search boxes** that don't update the URL
- **Pagination via button clicks** (not URL-based)
- **Dropdown filters** that trigger JavaScript without changing URL
- **Form inputs** (date pickers, sliders, etc.) that don't affect URL
- **Any interaction** where users type/click but the URL stays the same

**Value Guidelines:**
- Almost always set to `null` (these are dynamic by nature)
- Use descriptive names: `searchQuery`, `currentPage`, `filterCategory`

**Examples:**
```json
{
  "searchQuery": null,     // For typing into search box
  "currentPage": null,     // For clicking page buttons
  "minPrice": null,        // For price filter slider
  "maxPrice": null,        // For price filter slider
  "category": null         // For dropdown selection
}
```

**How these work at runtime:**
- User sends API request: `{"searchQuery": "laptop", "currentPage": "2"}`
- System finds `{searchQuery}` in js_scenario and replaces it with `"laptop"`
- System finds `{currentPage}` in js_scenario and replaces it with `"2"`
- These parameters are NOT added to the URL

### 4. pathParams (List<String>)
An array of parameter names that were replaced in the URL with `{paramName}` placeholders.

**Important:** The names in this list must **exactly match** the placeholder names used in the `url` field.

**Examples:**
- URL: `https://example.com/products/{productId}` → pathParams: `["productId"]`
- URL: `https://blog.com/{year}/{month}/{slug}` → pathParams: `["year", "month", "slug"]`
- URL: `www.social.com/posts/{postId}/comments/{commentId}` → pathParams: `["postId", "commentId"]`

## Decision Tree: Which Field Should I Use?

### For URL Path Components:
**Question:** Is this part of the URL path (not query string)?
- **YES** → Use placeholder in `url` field (e.g., `{productId}`) and add name to `pathParams` list

### For Parameters:
**Question:** Does this parameter appear in the URL query string (after `?`)?
- **YES** → Use `queryParams`
  - Example: `https://example.com?q=search` → `queryParams: {"q": null}`

- **NO** → Ask: "Is this for client-side interaction?"
  - **YES** → Use `queryParamsNotRelatedToUrl`
    - Example: Typing into search box that doesn't update URL → `queryParamsNotRelatedToUrl: {"searchQuery": null}`

**Question:** Does clicking a pagination button change the URL?
- **YES** (URL becomes `?page=2`) → Use `queryParams: {"page": null}`
- **NO** (URL stays the same) → Use `queryParamsNotRelatedToUrl: {"currentPage": null}`

**Question:** Does selecting a filter update the URL?
- **YES** (URL becomes `?category=electronics`) → Use `queryParams: {"category": null}`
- **NO** (URL stays the same, but page content changes) → Use `queryParamsNotRelatedToUrl: {"category": null}`

## Key Takeaways

✅ **queryParams** = Appears in URL query string (added via `Uri.queryParameters`)
✅ **queryParamsNotRelatedToUrl** = Used for client-side interactions as `{paramName}` placeholders (NOT added to URL)
✅ **pathParams** = Names of `{placeholder}` parameters in the URL path
✅ **url** = URL template with path placeholders like `{productId}`

❌ **Don't** put client-side interaction parameters in `queryParams` if they don't modify the URL
❌ **Don't** add the same parameter to both `queryParams` and `queryParamsNotRelatedToUrl`
❌ **Don't** forget to list all path placeholder names in `pathParams`
''';

/// System prompt for web scraping expert
const String systemPrompt = '''
# Web Scraping Expert System Prompt

You are a world-class expert in web scraping, web automation, and web data extraction with deep knowledge of HTML, CSS, JavaScript, HTTP protocols, and modern web scraping techniques.

## 🚨 ABSOLUTE REQUIREMENTS - NO EXCEPTIONS 🚨

### 1. MCP TOOLS ARE MANDATORY
You MUST use the Playwright MCP and ScrapingBee MCP tools. These are NOT optional.

### 2. NO WORKAROUNDS ALLOWED
- NEVER use Python, bash, or any other method to fetch HTML or make HTTP requests
- NEVER use web search or web fetch tools to access the target pages
- NEVER try to work around MCP unavailability
- If MCPs are not available, return an ERROR response type immediately

### 3. TESTING IS MANDATORY
You MUST ALWAYS test your extraction rules using the ScrapingBee MCP's `test_extract_rules` tool before returning them. NEVER return untested extraction rules - they will fail in production!

### 4. MCP UNAVAILABILITY = ERROR
If you cannot access the Playwright MCP or ScrapingBee MCP tools, you MUST return a response with `responseType: "error"` explaining that the required MCP tools are unavailable. DO NOT try to complete the task without these tools.

## Response Format (CRITICAL)

You MUST use ONE and ONLY ONE of these three response patterns:

### 1. Message Response (responseType: "message")
Use this when you need to ask for clarification, provide information, or when the user's request is out of scope.

### 2. Error Response (responseType: "error")
Use this when something BLOCKS you from creating extraction rules:
- **MCP tools are unavailable**
- MCP connection errors or failures
- The site consistently returns captchas that cannot be bypassed
- Access is completely blocked even with all proxy settings
- Fatal errors that prevent any progress

### 3. Data Response (responseType: "data")
Use this ONLY when you have successfully created, tested, and optimized extraction rules. NEVER return this without MCP testing!

**FINAL REMINDER**: ALWAYS test your extraction rules with the ScrapingBee MCP before returning them. Untested rules are unacceptable and will likely fail in production. The MCP test is your quality gate - use it!
''';

/// Guide for writing effective ScrapingBee extraction rules
const String howToWriteEffectiveScrapingBeeExtractRules = '''
# How to Write Effective ScrapingBee Extract Rules

This guide explains how to write extraction rules for ScrapingBee, including format requirements, placeholder usage, and best practices.

## 🚨 CRITICAL: extract_rules FORMAT REQUIREMENTS 🚨

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

## FORMAT RULES

1. **For single fields:** Use SIMPLE format `"field": "selector"`
2. **For arrays/lists:** Use nested format with `"type": "list"`
3. **NEVER** use `"type": "text"` or `"type": "attribute"` for single fields
4. **To extract attributes:** Use `@` syntax: `"img@src"`, `"a@href"`

**See:** https://www.scrapingbee.com/documentation/data-extraction/

## 🔧 Dynamic Parameter Placeholders

### What Are Placeholders?

The system supports dynamic parameter placeholders using `{parameterName}` in both extract_rules and js_scenario. These allow extraction rules that work with user-provided values.

### When to Use Placeholders

- Search queries: `{searchQuery}`
- Pagination: `{currentPage}`, `{page}`
- Filters: `{category}`, `{minPrice}`, `{maxPrice}`
- Form inputs: `{startDate}`, `{endDate}`

### How Placeholders Work

1. **Creation**: You use `{parameterName}` in your extraction rules
2. **Testing**: When testing with ScrapingBee MCP, use realistic mock values
3. **Runtime**: System replaces `{parameterName}` with actual values from user's payload

### Example: Search Box Interaction
```json
{
  "instructions": [
    {"wait": 1000},
    {"click": "input#search-box"},
    {"type": "{searchQuery}"},
    {"click": "button.search-submit"},
    {"wait_for": "div.results-loaded"}
  ]
}
```
Runtime: `{searchQuery}` replaced with actual search term (e.g., "laptop")

## Testing with Mock Values (MANDATORY)

**CRITICAL**: When testing with ScrapingBee MCP `test_extract_rules`, you MUST replace placeholders with realistic mock values!

**Why?** ScrapingBee API doesn't understand `{parameterName}` syntax - it needs actual values.

**Process:**
1. Replace ALL placeholders with mock values for testing
2. Test with ScrapingBee MCP
3. Return ORIGINAL rules with placeholders intact

## TESTING CHECKLIST

- [ ] Created extraction rules based on HTML analysis
- [ ] Replaced placeholders with mock values for testing
- [ ] Tested rules with ScrapingBee MCP `test_extract_rules`
- [ ] Verified extracted data matches requirements
- [ ] Returned ORIGINAL rules with placeholders intact
- [ ] Using EXACT tested configuration in final response
''';

/// Cost optimization strategy for ScrapingBee
const String costOptimization = '''
# Cost Optimization Strategy for ScrapingBee

## Credit Costs

| Configuration | Credits | Use Case |
|--------------|---------|----------|
| Basic (render_js=false) | 1 | Static HTML sites |
| JavaScript rendering | 5 | Most modern websites |
| Premium proxy without JS | 10 | Protected static sites |
| Premium proxy with JS | 25 | Most protected sites |
| Stealth proxy | 75 | **RARELY NEEDED** - LinkedIn, Facebook, Instagram |
| Google domains | 20 | Any Google domain |

**IMPORTANT**: Stealth proxy is RARELY needed! Only ~5% of sites require it.

## 🎯 Optimization Strategy

**Your goal**: Find the CHEAPEST configuration that works reliably.

**Reality:**
- **70%** of sites work with just `render_js=true` (5 credits)
- **25%** need `premium_proxy=true` (25 credits)
- Only **5%** need `stealth_proxy=true` (75 credits)

## Testing Order (ALWAYS follow this)

### 1. Initial Testing - Finding What Works
**Start with:** `premium_proxy=true, render_js=true` (25 credits)

- **Works?** → Move to Optimization Phase
- **Fails?** → Try `stealth_proxy=true` (75 credits)
  - Still fails? → May need special handling
  - Works? → Note stealth is required (RARE)

### 2. Optimization - Finding Minimum Requirements
**If worked with premium_proxy:**
- Test WITHOUT premium_proxy (`premium_proxy=false`)
  - Works? → Great! Move to JS testing
  - Fails? → Keep premium_proxy

**If required stealth_proxy:**
- Try downgrading to just premium_proxy
  - Works? → Use premium_proxy (saves 50 credits!)
  - Fails? → Must use stealth_proxy

### 3. JavaScript Optimization
- Try with `render_js=false`
  - Works? → Great! (saves 4+ credits)
  - Fails? → Keep `render_js=true`

**Test each configuration 2-3 times for consistency!**

## Credit Savings Examples

| Optimization | Before | After | Savings per 1000 requests |
|-------------|--------|-------|---------------------------|
| Stealth → Premium | 75 | 25 | 50,000 credits |
| Premium → No Proxy | 25 | 5 | 20,000 credits |
| With JS → Without JS | 5 | 1 | 4,000 credits |
| Stealth → No Proxy + No JS | 75 | 1 | 74,000 credits! |

## Key Takeaways

✅ Start with premium_proxy=true - works for 90%+ of sites
✅ Always try to optimize down - every step saves credits
✅ Test configurations 2-3 times for consistency
✅ stealth_proxy is RARE - only LinkedIn, Meta, and few others need it

❌ Don't start with stealth_proxy - almost never needed
❌ Don't use expensive settings by default
❌ Don't skip testing cheaper alternatives

Remember: Find the CHEAPEST configuration that works reliably!
''';
