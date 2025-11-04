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
