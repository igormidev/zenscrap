/// Comprehensive documentation for scrappable request structure.
/// This is the SINGLE SOURCE OF TRUTH used by both:
/// 1. AI generation prompts (create_scrappable.dart)
/// 2. Developer/AI understanding (this guide)
const String scrappableRequestStructureGuide =
    '''# Scrappable Request Structure Guide

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

**🎯 THE CORE CONCEPT:**
Some websites have interactive features (search boxes, pagination buttons, filters) where user actions trigger JavaScript and update the page content, BUT the URL never changes. For these cases, you need queryParamsNotRelatedToUrl.

**CRITICAL DISTINCTION:** These parameters are NEVER added to the URL - they're only used for placeholder replacement in extraction logic.

**When to use queryParamsNotRelatedToUrl:**

**📦 Common Patterns:**

1. **Client-side search boxes** (URL doesn't change when searching):
   - User types in search box → Page updates via JavaScript → URL stays same
   - Example: E-commerce sites with instant search
   - Parameter: `searchQuery: null`
   - Used in js_scenario: `{"type": "{searchQuery}"}`

2. **Pagination via button clicks** (not URL-based):
   - User clicks "Next" or page number button → Content loads → URL stays same
   - Example: Infinite scroll pages, JavaScript pagination
   - Parameter: `currentPage: null` or `pageNumber: null`
   - Used in js_scenario: `{"click": "button[data-page='{currentPage}']"}`

3. **Dropdown filters/selects** (client-side filtering):
   - User selects from dropdown → JavaScript filters content → URL stays same
   - Example: Product category filters, location selectors
   - Parameters: `category: null`, `location: null`, `sortBy: null`
   - Used in js_scenario: `{"select": {"selector": "select#category", "value": "{category}"}}`

4. **Form inputs and sliders** (interactive filters):
   - User adjusts price slider or date picker → Page updates → URL stays same
   - Example: Price range filters, date range selectors
   - Parameters: `minPrice: null`, `maxPrice: null`, `startDate: null`, `endDate: null`
   - Used in js_scenario: `{"fill": {"selector": "input#min-price", "value": "{minPrice}"}}`

5. **Any interaction where users type/click but URL stays the same**:
   - Modal search boxes
   - Popup filters
   - Accordion menus with content
   - Dynamic tabs without URL hash changes

**🔄 How It Works (Step by Step):**

**Step 1 - Request Creation:**
```json
{
  "url": "https://shop.com/products",
  "queryParams": {},
  "queryParamsNotRelatedToUrl": {
    "searchQuery": null,
    "currentPage": null
  },
  "pathParams": []
}
```

**Step 2 - AI Creates js_scenario with Placeholders:**
```json
{
  "instructions": [
    {"click": "input.search-box"},
    {"type": "{searchQuery}"},
    {"click": "button.search-submit"},
    {"wait_for": "div.results"},
    {"click": "button[data-page='{currentPage}']"},
    {"wait": 2000}
  ]
}
```

**Step 3 - User Sends API Request:**
```json
{
  "searchQuery": "laptop",
  "currentPage": "2"
}
```

**Step 4 - System Replaces Placeholders (at runtime):**
```json
{
  "instructions": [
    {"click": "input.search-box"},
    {"type": "laptop"},           // ← Replaced from payload
    {"click": "button.search-submit"},
    {"wait_for": "div.results"},
    {"click": "button[data-page='2']"},  // ← Replaced from payload
    {"wait": 2000}
  ]
}
```

**Step 5 - ScrapingBee Executes:**
- Opens: `https://shop.com/products` (URL never changes!)
- Clicks search box
- Types "laptop"
- Clicks submit
- Waits for results
- Clicks page 2 button
- Extracts data

**Value Guidelines:**
- Almost always set to `null` (these are dynamic by nature)
- Use descriptive names: `searchQuery`, `currentPage`, `filterCategory`
- Match the parameter names that will be used in js_scenario placeholders

**Examples:**
```json
{
  "searchQuery": null,     // For typing into search box
  "currentPage": null,     // For clicking page buttons
  "minPrice": null,        // For price filter slider
  "maxPrice": null,        // For price filter slider
  "category": null,        // For dropdown selection
  "location": null,        // For location filter
  "sortBy": null,          // For sort dropdown
  "filterTags": null       // For tag filters
}
```

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

## Complete Examples

### Example 1: URL-Based Search and Pagination
```json
{
  "url": "https://shop.com/products",
  "queryParams": {
    "q": null,
    "page": null,
    "sort": "price"
  },
  "queryParamsNotRelatedToUrl": {},
  "pathParams": []
}
```
**Resulting URL:** `https://shop.com/products?q=laptop&page=2&sort=price`

### Example 2: Client-Side Search (No URL Change)
```json
{
  "url": "https://shop.example.com/products",
  "queryParams": {},
  "queryParamsNotRelatedToUrl": {
    "searchQuery": null,
    "currentPage": null
  },
  "pathParams": []
}
```
**Resulting URL:** `https://shop.example.com/products` (URL never changes)
**Usage:** `{searchQuery}` and `{currentPage}` used in js_scenario to interact with page

### Example 3: Mixed - URL Pagination + Client-Side Search
```json
{
  "url": "https://realestate.com/listings",
  "queryParams": {
    "page": null
  },
  "queryParamsNotRelatedToUrl": {
    "searchQuery": null,
    "minPrice": null,
    "maxPrice": null
  },
  "pathParams": []
}
```
**Resulting URL:** `https://realestate.com/listings?page=2`
**Usage:** `{searchQuery}`, `{minPrice}`, `{maxPrice}` used in js_scenario

### Example 4: Path Parameters with URL Query Params
```json
{
  "url": "www.mySocialMedia.com/posts/{postId}/comments/{commentId}",
  "queryParams": {
    "sort": "asc",
    "filter": "all"
  },
  "queryParamsNotRelatedToUrl": {},
  "pathParams": ["postId", "commentId"]
}
```
**Resulting URL:** `www.mySocialMedia.com/posts/123/comments/456?sort=asc&filter=all`

### Example 5: E-commerce with Filters
```json
{
  "url": "https://shop.com/products/{categoryId}",
  "queryParams": {
    "sort": null,
    "limit": "20"
  },
  "queryParamsNotRelatedToUrl": {
    "priceMin": null,
    "priceMax": null,
    "brand": null
  },
  "pathParams": ["categoryId"]
}
```
**Resulting URL:** `https://shop.com/products/electronics?sort=price&limit=20`
**Usage:** `{priceMin}`, `{priceMax}`, `{brand}` used in js_scenario for filter interactions

## Common Patterns

### Search Functionality
- **URL-based:** `queryParams: {"q": null}` → URL updates to `?q=search_term`
- **Client-side:** `queryParamsNotRelatedToUrl: {"searchQuery": null}` → Use `{searchQuery}` in js_scenario

### Pagination
- **URL-based:** `queryParams: {"page": null}` → URL updates to `?page=2`
- **Button-based:** `queryParamsNotRelatedToUrl: {"currentPage": null}` → Use `{currentPage}` in js_scenario

### Filters
- **URL-based:** `queryParams: {"category": null, "brand": null}`
- **Client-side:** `queryParamsNotRelatedToUrl: {"category": null, "brand": null}`

### Date Ranges
- **URL-based:** `queryParams: {"from": null, "to": null}`
- **Client-side:** `queryParamsNotRelatedToUrl: {"startDate": null, "endDate": null}`

## Best Practices

1. **Use descriptive parameter names:**
   - ✅ `searchQuery`, `currentPage`, `minPrice`
   - ❌ `q`, `p`, `min`

2. **Be consistent with naming:**
   - If using `searchQuery` for client-side, don't use `q` for URL-based search elsewhere

3. **Set appropriate default values:**
   - Dynamic parameters (users will change): `null`
   - Static defaults (rarely change): actual value like `"20"`, `"asc"`

4. **Match pathParams exactly to URL placeholders:**
   - URL: `/{userId}/posts/{postId}` → pathParams: `["userId", "postId"]`
   - Order doesn't matter, but names must match exactly

5. **Think about the user experience:**
   - What values will users want to control?
   - Which parameters should have sensible defaults?
   - Is this parameter dynamic or static?

## Key Takeaways

✅ **queryParams** = Appears in URL query string (added via `Uri.queryParameters`)
✅ **queryParamsNotRelatedToUrl** = Used for client-side interactions as `{paramName}` placeholders (NOT added to URL)
✅ **pathParams** = Names of `{placeholder}` parameters in the URL path
✅ **url** = URL template with path placeholders like `{productId}`

❌ **Don't** put client-side interaction parameters in `queryParams` if they don't modify the URL
❌ **Don't** add the same parameter to both `queryParams` and `queryParamsNotRelatedToUrl`
❌ **Don't** forget to list all path placeholder names in `pathParams`
''';
