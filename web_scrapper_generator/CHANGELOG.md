## 2.0.3
- General minor refactors

## 2.0.1

### Bug Fixes
- **Fixed type mismatch in schema**: Changed `wait` field from `SchemaProperty.double()` to `SchemaProperty.integer()` to match the expected `int?` type in `ScrappingBeeFetchSettings`. This resolves the runtime error: "type 'double' is not a subtype of type 'int?' in type cast"
- **Fixed ScrapingBee 500 errors due to invalid extract_rules format**:
  - Added comprehensive format validation and auto-correction for extract_rules
  - Enhanced prompts with explicit format examples showing correct vs incorrect formats
  - Updated schema descriptions to clearly forbid verbose format for single fields
  - Auto-converts verbose format `{"field": {"selector": "...", "type": "text"}}` to simple format `{"field": "selector"}`
  - Prevents 500 errors caused by using verbose format for single text/attribute fields

## 2.0.0

- Updated Codex, Claude, and Gemini integrations to use new record-based structured responses
- Added streaming structured schema support across all CLI providers
- Improved schema validation and retry logic with temporary JSON files

## 1.0.0

- Initial version.
