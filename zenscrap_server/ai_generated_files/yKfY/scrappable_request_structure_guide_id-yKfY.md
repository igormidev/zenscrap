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
- URL: `https://example.com/products/{productId}` ’ pathParams: `["productId"]`
- URL: `https://blog.com/{year}/{month}/{slug}` ’ pathParams: `["year", "month", "slug"]`
- URL: `www.social.com/posts/{postId}/comments/{commentId}` ’ pathParams: `["postId", "commentId"]`

## Decision Tree: Which Field Should I Use?

### For URL Path Components:
**Question:** Is this part of the URL path (not query string)?
- **YES** ’ Use placeholder in `url` field (e.g., `{productId}`) and add name to `pathParams` list

### For Parameters:
**Question:** Does this parameter appear in the URL query string (after `?`)?
- **YES** ’ Use `queryParams`
  - Example: `https://example.com?q=search` ’ `queryParams: {"q": null}`

- **NO** ’ Ask: "Is this for client-side interaction?"
  - **YES** ’ Use `queryParamsNotRelatedToUrl`
    - Example: Typing into search box that doesn't update URL ’ `queryParamsNotRelatedToUrl: {"searchQuery": null}`

**Question:** Does clicking a pagination button change the URL?
- **YES** (URL becomes `?page=2`) ’ Use `queryParams: {"page": null}`
- **NO** (URL stays the same) ’ Use `queryParamsNotRelatedToUrl: {"currentPage": null}`

**Question:** Does selecting a filter update the URL?
- **YES** (URL becomes `?category=electronics`) ’ Use `queryParams: {"category": null}`
- **NO** (URL stays the same, but page content changes) ’ Use `queryParamsNotRelatedToUrl: {"category": null}`

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
- **URL-based:** `queryParams: {"q": null}` ’ URL updates to `?q=search_term`
- **Client-side:** `queryParamsNotRelatedToUrl: {"searchQuery": null}` ’ Use `{searchQuery}` in js_scenario

### Pagination
- **URL-based:** `queryParams: {"page": null}` ’ URL updates to `?page=2`
- **Button-based:** `queryParamsNotRelatedToUrl: {"currentPage": null}` ’ Use `{currentPage}` in js_scenario

### Filters
- **URL-based:** `queryParams: {"category": null, "brand": null}`
- **Client-side:** `queryParamsNotRelatedToUrl: {"category": null, "brand": null}`

### Date Ranges
- **URL-based:** `queryParams: {"from": null, "to": null}`
- **Client-side:** `queryParamsNotRelatedToUrl: {"startDate": null, "endDate": null}`

## Best Practices

1. **Use descriptive parameter names:**
   -  `searchQuery`, `currentPage`, `minPrice`
   - L `q`, `p`, `min`

2. **Be consistent with naming:**
   - If using `searchQuery` for client-side, don't use `q` for URL-based search elsewhere

3. **Set appropriate default values:**
   - Dynamic parameters (users will change): `null`
   - Static defaults (rarely change): actual value like `"20"`, `"asc"`

4. **Match pathParams exactly to URL placeholders:**
   - URL: `/{userId}/posts/{postId}` ’ pathParams: `["userId", "postId"]`
   - Order doesn't matter, but names must match exactly

5. **Think about the user experience:**
   - What values will users want to control?
   - Which parameters should have sensible defaults?
   - Is this parameter dynamic or static?

## Key Takeaways

 **queryParams** = Appears in URL query string (added via `Uri.queryParameters`)
 **queryParamsNotRelatedToUrl** = Used for client-side interactions as `{paramName}` placeholders (NOT added to URL)
 **pathParams** = Names of `{placeholder}` parameters in the URL path
 **url** = URL template with path placeholders like `{productId}`

L **Don't** put client-side interaction parameters in `queryParams` if they don't modify the URL
L **Don't** add the same parameter to both `queryParams` and `queryParamsNotRelatedToUrl`
L **Don't** forget to list all path placeholder names in `pathParams`
