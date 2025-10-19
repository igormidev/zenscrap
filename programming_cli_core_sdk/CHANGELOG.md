## 2.1.0

### Features
- **Made `chatNanoId` public**: The `_chatNanoId` field is now public, allowing implementations to access the unique chat identifier for scoping file operations.
- **Added `updateOptions` method**: New method allows updating chat options after the chat has been created, enabling dynamic configuration changes like setting the working directory.
- **Added `aiGeneratedFilesDir` getter**: Smart getter that returns the correct directory for AI-generated files, handling both cases where `cwd` is explicitly set (web scrapper implementations) and when it's not (direct SDK usage).

### Improvements
- **Optimized cleanup process**: Replaced file-by-file deletion with directory-level deletion. The `_cleanupTemporaryFiles` method now deletes the entire AI-generated files directory recursively, which is more efficient and ensures complete cleanup.
- **Fixed nested directory issue**: Corrected path construction to prevent creating nested `ai_generated_files/` directories. When `cwd` is set, paths now use it directly instead of adding the scoped path again.
- **Better scoping of file operations**: With the public `chatNanoId` and `updateOptions` method, implementations can now properly scope all CLI operations to their specific chat directory, preventing files from being created at the root level.

### Breaking Changes
- `_chatNanoId` is now `chatNanoId` (public instead of private).

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
