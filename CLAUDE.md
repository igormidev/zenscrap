# Claude Development Guidelines

## Flutter Best Practices

### Widget Creation Guidelines

#### ✅ DO: Use Widget Classes
- Always create separate widget classes instead of functions that return widgets
- This ensures proper widget lifecycle management and optimization

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