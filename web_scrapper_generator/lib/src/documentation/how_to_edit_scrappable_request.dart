const String howToEditScrappableRequest = '''# How to Edit Scrappable Request Structure

This guide explains how to modify the scrappable request configuration to add/remove parameters and set default values.

## 📋 Overview

The scrappable request structure defines:
- **URL template** with path parameter placeholders
- **Query parameters** that appear in the URL
- **Query parameters NOT related to URL** for client-side interactions
- **Path parameters** list

You have FULL CONTROL to modify this structure based on user needs.

## 🔧 Modifying Query Parameters

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
  - Example: `"sort": "asc"` means if user doesn't provide sort, use "asc"
  - Example: `"limit": "20"` means if user doesn't provide limit, use "20"

**Removing a parameter:**
Simply delete it from the map if it's not needed.

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

**Setting default values:**
- **null**: Parameter is REQUIRED - user MUST provide in their API payload
- **"value"**: Parameter has a DEFAULT - user CAN override, but not required
  - Example: `"minPrice": "0"` means if user doesn't provide minPrice, use "0"
  - Example: `"category": "all"` means if user doesn't provide category, use "all"

**Removing a parameter:**
If a parameter in `queryParamsNotRelatedToUrl` is NOT used in your js_scenario or extract_rules, you MUST remove it.

## 🎯 Critical Rules for queryParamsNotRelatedToUrl

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

## 📝 Examples

### Example 1: Adding Search Functionality

**Before:**
```json
{
  "url": "https://shop.com/products",
  "queryParam": {},
  "queryParamsNotRelatedToUrl": {},
  "pathParams": []
}
```

**After (Client-side search - URL doesn't change):**
```json
{
  "url": "https://shop.com/products",
  "queryParam": {},
  "queryParamsNotRelatedToUrl": {
    "searchQuery": null
  },
  "pathParams": []
}
```

**js_scenario usage:**
```json
{
  "instructions": [
    {"click": "input.search-box"},
    {"type": "{searchQuery}"},
    {"click": "button.submit"}
  ]
}
```

### Example 2: Adding Pagination with Default

**Adding button-based pagination with default page:**
```json
{
  "queryParamsNotRelatedToUrl": {
    "currentPage": "1"
  }
}
```

**What this means:**
- If user provides `{"currentPage": "3"}` → use page 3
- If user doesn't provide currentPage → use page 1 (default)

**js_scenario usage:**
```json
{
  "instructions": [
    {"click": "button[data-page='{currentPage}']"}
  ]
}
```

### Example 3: Removing Unused Parameter

**Scenario:** User says "I don't need pagination anymore"

**Before:**
```json
{
  "queryParamsNotRelatedToUrl": {
    "searchQuery": null,
    "currentPage": null
  }
}
```

**After:**
```json
{
  "queryParamsNotRelatedToUrl": {
    "searchQuery": null
  }
}
```

**And remove from js_scenario:**
Remove any `{currentPage}` placeholders from your extraction logic.

### Example 4: Moving Parameter from URL to Client-Side

**Scenario:** User says "The search is actually client-side, not in the URL"

**Before:**
```json
{
  "queryParam": {
    "q": null
  },
  "queryParamsNotRelatedToUrl": {}
}
```

**After:**
```json
{
  "queryParam": {},
  "queryParamsNotRelatedToUrl": {
    "searchQuery": null
  }
}
```

**And update js_scenario:**
Add search box interaction with `{searchQuery}` placeholder.

### Example 5: Setting Sensible Defaults

**Scenario:** Price filter where most users search for items greater than \$0

```json
{
  "queryParamsNotRelatedToUrl": {
    "minPrice": "0",     // Default: \$0 minimum
    "maxPrice": null,    // Required: user must specify max
    "category": "all"    // Default: all categories
  }
}
```

**What happens:**
- User sends `{}` → uses minPrice=0, category=all, but FAILS (maxPrice required)
- User sends `{"maxPrice": "1000"}` → uses minPrice=0, maxPrice=1000, category=all
- User sends `{"minPrice": "100", "maxPrice": "1000", "category": "electronics"}` → uses all provided values

## 🚨 Common Mistakes to Avoid

### Mistake 1: Unused Parameters
```json
{
  "queryParamsNotRelatedToUrl": {
    "searchQuery": null,
    "currentPage": null,
    "filter": null
  }
}
```
**js_scenario:**
```json
{
  "instructions": [
    {"click": "input.search"},
    {"type": "{searchQuery}"}
  ]
}
```
**Problem**: `currentPage` and `filter` are defined but never used!
**Fix**: Remove them from queryParamsNotRelatedToUrl.

### Mistake 2: Using Undefined Placeholder
**js_scenario:**
```json
{
  "instructions": [
    {"type": "{searchQuery}"}
  ]
}
```
**queryParamsNotRelatedToUrl:**
```json
{}
```
**Problem**: Using `{searchQuery}` but it's not defined!
**Fix**: Add `"searchQuery": null` to queryParamsNotRelatedToUrl.

### Mistake 3: Wrong Parameter Location
**Scenario**: Search appears in URL as `?q=laptop`

**Wrong:**
```json
{
  "queryParam": {},
  "queryParamsNotRelatedToUrl": {
    "q": null
  }
}
```

**Correct:**
```json
{
  "queryParam": {
    "q": null
  },
  "queryParamsNotRelatedToUrl": {}
}
```

## 💡 Decision Tree

### "Should I add a parameter?"
1. Does the user need this functionality? → NO: Don't add it
2. Does this appear in the URL? → YES: Add to `queryParam`; NO: Continue to 3
3. Is this for client-side interaction? → YES: Add to `queryParamsNotRelatedToUrl`

### "Should I set a default value?"
1. Is there a sensible default most users would want? → YES: Set it (e.g., `"sort": "asc"`)
2. Does the value vary significantly per user? → YES: Use null (required)
3. Is this a safety default? → YES: Set it (e.g., `"limit": "100"` to prevent huge requests)

### "Should I remove a parameter?"
1. Is it used in js_scenario or extract_rules? → NO: Remove it
2. Did the user say they don't need it? → YES: Remove it
3. Does it appear in the URL? → YES but in queryParamsNotRelatedToUrl: Move to queryParam

## 🎓 Best Practices

1. **Keep it minimal**: Only add parameters that are actually used
2. **Use descriptive names**: `searchQuery` not `q`, `currentPage` not `p`
3. **Set helpful defaults**: Make the API easier to use with sensible defaults
4. **Document in resumeActionMessage**: Tell users what parameters they need to provide
5. **Validate your changes**: Ensure all `{placeholders}` in js_scenario have matching parameters
6. **Test with mock values**: Replace placeholders with realistic values when testing with ScrapingBee MCP

## 📚 Key Takeaways

✅ **queryParam** = Appears in URL, added via Uri(queryParameters:)
✅ **queryParamsNotRelatedToUrl** = Used ONLY as {paramName} placeholders, NEVER in URL
✅ **null value** = Parameter is REQUIRED
✅ **"string value"** = Parameter has a DEFAULT (optional for user)
✅ **Use it or lose it** = Remove unused parameters from queryParamsNotRelatedToUrl
✅ **Match exactly** = Parameter names must match placeholders in js_scenario/extract_rules

Remember: The scrappable request structure is YOUR tool to make the API flexible and user-friendly!
''';
