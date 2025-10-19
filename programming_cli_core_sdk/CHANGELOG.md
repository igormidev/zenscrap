## 2.0.1

### Critical Bug Fixes
- **Fixed file cleanup leak in `_handleTemporaryFilesWrapper`**: Refactored to use try-finally pattern to **guarantee** cleanup of temporary files and schema test files in ALL scenarios, including:
  - When schema validation fails after retry (previously leaked files at line 200-203)
  - When exceptions are thrown during processing
  - When early returns occur in the flow
- **Added tracking flags**: `schemaFilesCreated` and `temporaryFilesCreated` flags ensure cleanup only runs when files were actually created
- **Removed redundant cleanup calls**: Cleanup now happens exclusively in the `finally` block, ensuring it runs exactly once regardless of success, failure, or early return

### Impact
This fix ensures that `ai_generated_files/` directory never accumulates leftover test files or schema response files, preventing disk space leaks and maintaining a clean working directory.

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
