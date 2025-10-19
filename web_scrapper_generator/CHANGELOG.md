## 2.0.1

### Bug Fixes
- **Fixed type mismatch in schema**: Changed `wait` field from `SchemaProperty.double()` to `SchemaProperty.integer()` to match the expected `int?` type in `ScrappingBeeFetchSettings`. This resolves the runtime error: "type 'double' is not a subtype of type 'int?' in type cast"

## 2.0.0

- Updated Codex, Claude, and Gemini integrations to use new record-based structured responses
- Added streaming structured schema support across all CLI providers
- Improved schema validation and retry logic with temporary JSON files

## 1.0.0

- Initial version.
