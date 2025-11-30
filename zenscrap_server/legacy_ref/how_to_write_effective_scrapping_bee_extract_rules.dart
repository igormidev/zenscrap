import 'package:zenscrap_server/src/endpoints/public/chat_controller/web_scraper_ai_models.dart';

String howToWriteEffectiveScrapingBeeExtractRules(
  WebScrapperRequest webScrapperRequest,
  String mdFileHowToEditRequest,
) {
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

This guide explains how to write extraction rules for ScrapingBee, including format requirements, placeholder usage, and best practices.

## 🎯 CURRENT SCRAPPABLE REQUEST PARAMETERS

### Available URL Parameters (queryParam)
${hasQueryParams ? '''
These parameters are added to the URL. You can use them in your URL construction:
$queryParamsList
''' : 'No queryParam parameters defined.'}

### Available Client-Side Parameters (queryParamsNotRelatedToUrl)
${hasQueryParamsNotRelatedToUrl ? '''
**CRITICAL**: These parameters are ALREADY DEFINED and available for use as `{paramName}` placeholders in your js_scenario and extract_rules:

$queryParamsNotRelatedToUrlList

**UNDERSTANDING PARAMETERS:**

**Parameters with DEFAULT values** (e.g., "value"):
- Already have a default, giving you a hint about their purpose
- Example: `"currentPage": "1"` suggests pagination starting at page 1
- Example: `"minPrice": "0"` suggests price filtering with \$0 minimum
- Use the default as a clue, but verify against the actual website behavior

**Parameters that are REQUIRED** (null):
- User MUST provide these values in their API payload
- Parameter name is your only clue (e.g., `searchQuery`, `filterCategory`, `location`)
- You MUST deduce their purpose by:
  1. Examining the website structure (input fields, buttons, dropdowns)
  2. Analyzing the user's request and context
  3. Using Playwright MCP to explore interactive elements
  4. Checking parameter name patterns (searchQuery → search, currentPage → pagination, etc.)

**CRITICAL DECISION RULES:**

1. **CAN you confidently deduce what a parameter is for?**
   - YES → Use it appropriately in js_scenario based on your analysis
   - NO → Return `responseType: "message"` and ASK the user for clarification

2. **Example of asking for clarification:**
   ```
   responseType: "message"
   message: "I found these client-side parameters defined but need clarification:
   - 'customParam1' (required) - What should this parameter control on the page?
   - 'customParam2' (required) - What interaction does this represent?

   Please describe what these parameters should do so I can create the correct js_scenario."
   ```

3. **YOU MUST use ALL defined parameters OR remove unused ones:**
   - ✅ If you use all parameters in your js_scenario → GOOD
   - ✅ If you don't need some parameters → Return `responseType: "data"` but include those parameters in the REMOVAL list
   - ❌ Leaving parameters defined but unused → BAD (confuses users)

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

**IMPORTANT**: The example above shows SYNTAX only. DO NOT assume:
- Which parameter goes with which action
- What HTML selectors to use
- What interaction pattern is needed

YOU must determine this by exploring the actual website with Playwright MCP!

**To add/remove/modify parameters**, consult the file: $mdFileHowToEditRequest
''' : '''
No queryParamsNotRelatedToUrl parameters defined.

If user needs client-side interactions (search, pagination, filters, form inputs) that don't modify the URL:
1. You should add them to the request structure
2. Consult the file: $mdFileHowToEditRequest for instructions

**Example scenarios requiring queryParamsNotRelatedToUrl:**
- Search box that doesn't update URL when typing
- "Next Page" button that loads content via JavaScript (URL stays same)
- Dropdown filters that trigger AJAX requests (URL stays same)
- Form inputs where submission doesn't change URL
'''}

### Parameter Value Types (IMPORTANT)
- **null (REQUIRED)**: User MUST provide this value in their API payload
  - You must deduce its purpose from context or ask user for clarification
- **"value" (DEFAULT)**: User CAN override, but if not provided, this default is used
  - The default value often hints at the parameter's purpose
  - Example: `"minPrice": "0"` → likely for price range filtering
  - Example: `"sort": "asc"` → likely for sorting order
  - Example: `"currentPage": "1"` → likely for pagination

**To modify default values or change required/optional status**, consult the file: $mdFileHowToEditRequest

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
  },
  "image_url": {
    "selector": "img@src",
    "type": "attribute"  // ❌ DO NOT DO THIS!
  }
}
```

## FORMAT RULES YOU MUST FOLLOW

1. **For single text/attribute fields:** Use SIMPLE format `"field": "selector"` or `"field": "selector@attribute"`
2. **For arrays/lists:** Use nested format with `"type": "list"` and `"output"`
3. **NEVER** use `"type": "text"` or `"type": "attribute"` for single fields
4. **To extract attributes:** Use the `@` syntax: `"img@src"`, `"a@href"`, `"div@data-id"`
5. The format `{"selector": "...", "type": "text"}` is **INVALID** and will fail!

**See:** https://www.scrapingbee.com/documentation/data-extraction/

## 🔧 Dynamic Parameter Placeholders (CRITICAL FEATURE)

### What Are Placeholders?

The system supports **dynamic parameter placeholders** using the syntax `{parameterName}` in both `extract_rules` and `js_scenario`. These placeholders allow you to create extraction rules that work with user-provided values.

### When to Use Placeholders

Use placeholders for parameters that users will provide in their API payload:
- **Search queries**: `{searchQuery}`, `{query}`, `{searchTerm}`
- **Pagination**: `{currentPage}`, `{page}`, `{pageNumber}`
- **Filters**: `{category}`, `{location}`, `{minPrice}`, `{maxPrice}`
- **Form inputs**: `{startDate}`, `{endDate}`, `{quantity}`
- **Any dynamic value**: Users control via API payload

### How Placeholders Work

1. **Creation**: You use `{parameterName}` in your extraction rules
2. **Testing**: When testing with ScrapingBee MCP, use realistic mock values (explained below)
3. **Runtime**: The system replaces `{parameterName}` with actual values from the user's API payload
4. **Available Parameters**: Check the `WebScrapperRequest` queryParams and queryParamsNotRelatedToUrl to see what's available

### Understanding queryParamsNotRelatedToUrl

**IMPORTANT**: Before using placeholders, you need to understand where they come from!

Placeholders like `{searchQuery}` and `{currentPage}` come from the `queryParamsNotRelatedToUrl` field in the scrappable request. These are parameters that:
- Do NOT modify the URL
- Are used ONLY for client-side interactions
- Are replaced at runtime with user-provided values

**When to Add/Remove queryParamsNotRelatedToUrl:**

✅ **ADD a parameter** if:
- User needs to search and the search box doesn't update the URL
- User needs pagination via button clicks (not URL-based)
- User needs filters that trigger JavaScript without changing URL
- User needs any form input that doesn't affect the URL

❌ **REMOVE a parameter** if:
- User says they don't need that functionality
- The parameter appears in the URL (should be in queryParams instead)
- It's not actually used in the extraction logic

**Example Decision:**
- User: "I want to search for products"
- You check: Does the search update the URL?
  - NO → Add `searchQuery: null` to queryParamsNotRelatedToUrl
  - YES → Add `q: null` to queryParams instead

### Using Placeholders in js_scenario

**CRITICAL**: Placeholders are especially powerful in `js_scenario` for user interactions!

**Example 1 - Search Box Interaction:**
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
At runtime: `{searchQuery}` is replaced with the actual search term from the user's payload (e.g., "laptop")
**Note**: `searchQuery` must exist in `queryParamsNotRelatedToUrl` for this to work!

**Example 2 - Pagination via Button Clicks:**
```json
{
  "instructions": [
    {"wait": 1000},
    {"click": "button[data-page='{currentPage}']"},
    {"wait_for": "div.page-loaded"}
  ]
}
```
At runtime: `{currentPage}` is replaced with "2" if user sends `{"currentPage": "2"}`
**Note**: `currentPage` must exist in `queryParamsNotRelatedToUrl` for this to work!

**Example 3 - Multiple Filters:**
```json
{
  "instructions": [
    {"select": {"selector": "select#category", "value": "{category}"}},
    {"fill": {"selector": "input#min-price", "value": "{minPrice}"}},
    {"fill": {"selector": "input#max-price", "value": "{maxPrice}"}},
    {"click": "button#apply-filters"},
    {"wait_for": "div.filtered-results"}
  ]
}
```
**Note**: `category`, `minPrice`, and `maxPrice` must all exist in `queryParamsNotRelatedToUrl` for this to work!

### Using Placeholders in extract_rules

You can also use placeholders in CSS selectors if needed:

**Example - Dynamic attribute selection:**
```json
{
  "products": {
    "selector": ".product-card",
    "type": "list",
    "output": {
      "name": ".product-name",
      "price": ".price"
    }
  }
}
```

Note: Placeholders in extract_rules are less common than in js_scenario, but can be useful for dynamic selector construction.

## Testing with Mock Values (MANDATORY)

**CRITICAL**: When testing your extraction rules with the ScrapingBee MCP `test_extract_rules` tool, you MUST replace placeholders with realistic mock values!

**Why?** The ScrapingBee API doesn't understand `{parameterName}` syntax - it needs actual values to test.

**How to test:**
1. Before calling `test_extract_rules`, create a test version of your rules
2. Replace ALL placeholders with realistic mock values
3. Test with ScrapingBee MCP
4. Once validated, return the ORIGINAL rules (with placeholders intact)

**Example Testing Process:**

Your original js_scenario (with placeholders):
```json
{
  "instructions": [
    {"click": "input.search"},
    {"type": "{searchQuery}"},
    {"click": "button.submit"}
  ]
}
```

For testing with MCP, use:
```json
{
  "instructions": [
    {"click": "input.search"},
    {"type": "test product"},
    {"click": "button.submit"}
  ]
}
```

After successful test, return the ORIGINAL with placeholders:
```json
{
  "instructions": [
    {"click": "input.search"},
    {"type": "{searchQuery}"},
    {"click": "button.submit"}
  ]
}
```

## Placeholder Best Practices

1. **Use descriptive names**: `{searchQuery}` not `{q}`, `{currentPage}` not `{p}`
2. **Match parameter names**: Use the exact parameter names from `WebScrapperRequest.queryParams` and `queryParamsNotRelatedToUrl`
3. **Test thoroughly**: Always test with realistic mock values before returning
4. **Document in resumeActionMessage**: Explain which placeholders users need to provide
5. **Set sensible defaults**: When possible, suggest default values in your message

## Common Placeholder Patterns

- **Search**: `{searchQuery}`, `{query}`, `{keyword}`
- **Pagination**: `{currentPage}`, `{page}`, `{offset}`, `{limit}`
- **Filters**: `{category}`, `{brand}`, `{color}`, `{size}`
- **Price**: `{minPrice}`, `{maxPrice}`, `{priceRange}`
- **Date**: `{startDate}`, `{endDate}`, `{dateFrom}`, `{dateTo}`
- **Location**: `{location}`, `{city}`, `{country}`, `{zipCode}`

## Important Notes

- Placeholders are case-sensitive: `{searchQuery}` ≠ `{searchquery}`
- Use them in js_scenario for maximum power (interactions)
- Always test with mock values via ScrapingBee MCP
- Return the placeholder version (not the mock version) in your final response
- The system will handle replacement at runtime automatically

## JS Scenario Documentation

For complete js_scenario capabilities, see: https://www.scrapingbee.com/documentation/javascript-scenario/

Common actions:
- `{"wait": milliseconds}` - Wait for a fixed time
- `{"click": "selector"}` - Click an element
- `{"type": "text"}` - Type text into active element
- `{"select": {"selector": "select", "value": "option"}}` - Select dropdown option
- `{"fill": {"selector": "input", "value": "text"}}` - Fill input field
- `{"wait_for": "selector"}` - Wait for element to appear
- `{"scroll_x": pixels}`, `{"scroll_y": pixels}` - Scroll the page
- `{"infinite_scroll": {"max_count": 10}}` - Trigger infinite scroll

## Testing Requirements (ABSOLUTELY CRITICAL)

**MANDATORY TESTING PROTOCOL:**
1. You MUST test ALL extraction rules using the ScrapingBee MCP's `test_extract_rules` tool
2. NEVER return a `responseType: "data"` response without successful MCP validation
3. If testing fails, you MUST fix the rules and test again
4. Only return the EXACT rules that passed testing - no post-test modifications
5. The `extract_rules` in your final response must be IDENTICAL to what you tested

**TESTING CHECKLIST** (all items required):
- [ ] Created extraction rules based on HTML analysis
- [ ] Replaced placeholders with mock values for testing
- [ ] Tested rules with ScrapingBee MCP `test_extract_rules`
- [ ] Verified the extracted data matches user requirements
- [ ] Returned ORIGINAL rules with placeholders intact
- [ ] Using the EXACT tested configuration in final response
''';
}
