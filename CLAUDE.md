# Claude Development Guidelines

## ⚠️ IMPORTANT: Package Update Guidelines

**ALWAYS update version, changelog, and README when modifying these packages:**

When you make changes to any of these SDK packages, you MUST update:
1. **Version** in `pubspec.yaml` - Follow semantic versioning
2. **CHANGELOG.md** - Add entry describing the changes
3. **README.md** - Update if there are API changes or new features

Affected packages:
- `claude_code_sdk/`
- `gemini_cli_sdk/`
- `codex_cli_sdk/`
- `programming_cli_core_sdk/`

## ⚠️ IMPORTANT: Serverpod Code Generation

**ALWAYS use the experimental features flag when generating Serverpod files:**

```bash
serverpod generate --experimental-features=all
```

This project uses experimental Serverpod features. Omitting the `--experimental-features=all` flag will cause generation errors.

## ⚠️ IMPORTANT: Static Analysis Verification

**ALWAYS check for static analysis errors after making code changes:**

Before completing any task, ensure:
1. No red squiggly lines (errors) in the IDE
2. No yellow squiggly lines (warnings) unless absolutely necessary
3. Run `dart analyze` or check IDE diagnostics to verify
4. Fix any unused imports, undefined variables, or type mismatches
5. Ensure all required parameters are provided

This prevents introducing bugs and maintains code quality standards.

## Flutter Best Practices

### Theme and Color Access
- **Text Theme**: Access text theme using `context.t`
- **Color Scheme**: Access color scheme using `context.c`
- **Opacity**: NEVER use `withOpacity()` as it is deprecated - always use `withAlpha()` instead
  - Example: `context.c.primary.withAlpha(128)` instead of `context.c.primary.withOpacity(0.5)`

### Widget Creation Guidelines

#### ⚠️ CRITICAL: NEVER Create Functions That Return Widgets
**ALWAYS use widget classes, 100% of the time. NO EXCEPTIONS.**

#### ✅ DO: Use Widget Classes
- Always create separate widget classes instead of functions that return widgets
- This ensures proper widget lifecycle management and optimization
- Every UI component must be a proper widget class (StatelessWidget, StatefulWidget, or ConsumerWidget)

```dart
// GOOD - Widget class
class MyCustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  
  const MyCustomButton({
    required this.label,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
```

#### ❌ DON'T: Use Functions Returning Widgets
```dart
// BAD - Function returning widget
Widget _buildButton(String label, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    child: Text(label),
  );
}
```

### Why This Matters
1. **Performance**: Widget classes allow Flutter to optimize rebuilds through the widget tree
2. **Const Constructors**: Widget classes can have const constructors for better performance
3. **Keys**: Widget classes can properly use keys for maintaining state
4. **Testing**: Widget classes are easier to test in isolation
5. **Type Safety**: Better type checking and IDE support

### Additional Flutter Guidelines
- Prefer `const` constructors whenever possible
- Use private widget classes (prefixed with `_`) for widgets only used within a single file
- Keep widgets focused on a single responsibility
- Pass callbacks and data through constructor parameters rather than accessing them globally

## API Error Handling Guidelines

### Always Use toResult Extension
When making API calls, always use the `toResult` extension from `zenscrap_flutter/lib/src/core/extensions/serverpod_to_result.dart`:

```dart
// GOOD - Using toResult
final result = await client.someEndpoint.call().toResult;
result.fold(
  (success) => // handle success,
  (error) => // handle error
);
```

```dart
// BAD - Direct try-catch
try {
  await client.someEndpoint.call();
} catch (e) {
  // handle error
}
```

### Dialog Error Handling
When making API calls directly within dialogs, use `handleBabelException` from `zenscrap_flutter/lib/src/design_system/default_error_snackbar.dart`:

```dart
// In dialogs, use handleBabelException for errors
final result = await client.someEndpoint.call().toResult;
result.fold(
  (success) => // handle success,
  (error) => handleBabelException(context, error),
);
```

This ensures consistent error handling and user feedback across the application.