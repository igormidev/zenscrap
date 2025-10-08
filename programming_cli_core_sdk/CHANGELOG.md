## 2.0.0

### Breaking Changes
- **Removed `apiKey` from `CodingCliInterface`**: API keys are no longer stored in the interface constructor. Each implementation now manages its own API key.
- **Constructor change**: `CodingCliInterface` no longer requires an `apiKey` parameter in its constructor.

### Added
- **New method `addApiKeyToEnvironment(String apiKey)`**: Abstract method that implementations must override to add their respective API keys to environment variables. This ensures CLI tools can authenticate without requiring login sessions.

### Migration Guide
- When creating SDK instances (Codex, Claude, Gemini), you still pass the API key to their constructors.
- Call `addApiKeyToEnvironment(apiKey)` after creating the SDK instance to ensure the CLI can authenticate.
- Example:
  ```dart
  final codex = Codex(apiKey: 'your-api-key');
  await codex.addApiKeyToEnvironment('your-api-key');
  ```

## 1.0.0

- Initial version.
