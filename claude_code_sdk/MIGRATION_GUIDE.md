# Migration Guide: Schema Nullable Properties

## Overview

Starting from version 1.1.0, the Claude Code SDK introduces a new pattern for defining required/optional properties in schemas. Instead of using a separate `required` array, you can now specify `nullable` directly on each `SchemaProperty`.

## Old Pattern (Still Supported)

```dart
// Old way: Using required array
final schema = SchemaDefinition(
  properties: {
    'userName': SchemaProperty.string(
      description: 'User name',
    ),
    'userEmail': SchemaProperty.string(
      description: 'User email',
    ),
    'userAge': SchemaProperty.number(
      description: 'User age',
    ),
  },
  required: ['userName', 'userAge'], // Specify required fields separately
);
```

## New Pattern (Recommended)

```dart
// New way: Using nullable on each property
final schema = SchemaDefinition(
  properties: {
    'userName': SchemaProperty.string(
      description: 'User name',
      nullable: false, // Required field
    ),
    'userEmail': SchemaProperty.string(
      description: 'User email',
      nullable: true, // Optional field (default)
    ),
    'userAge': SchemaProperty.number(
      description: 'User age',
      nullable: false, // Required field
    ),
  },
  // No need for 'required' array - it's automatically derived
);
```

## Benefits of the New Pattern

1. **Clearer Intent**: Nullability is defined where the property is defined
2. **Less Error-Prone**: No risk of forgetting to add a property to the required array
3. **Better IDE Support**: Autocomplete shows nullable option directly on the property
4. **Consistent**: Similar to TypeScript, GraphQL, and other schema definition patterns

## Migration Steps

### Step 1: Identify Required Fields

Look at your existing `required` array to identify which fields are required:

```dart
// Before
required: ['userName', 'userId', 'email']
```

### Step 2: Add Nullable Parameter

For each property:
- Add `nullable: false` if it was in the `required` array
- Add `nullable: true` (or omit it) if it was optional

```dart
// After
'userName': SchemaProperty.string(
  description: 'User name',
  nullable: false, // Was in required array
),
'middleName': SchemaProperty.string(
  description: 'Middle name',
  nullable: true, // Was not in required array (optional)
),
```

### Step 3: Remove Required Array

Once all properties have their nullable status defined, remove the `required` parameter from SchemaDefinition:

```dart
// Before
SchemaDefinition(
  properties: { /* ... */ },
  required: ['userName', 'userId'],
)

// After
SchemaDefinition(
  properties: { /* ... */ },
  // required array removed - automatically derived from nullable properties
)
```

## Complete Example

### Before Migration

```dart
final userSchema = SchemaDefinition(
  properties: {
    'id': SchemaProperty.string(description: 'User ID'),
    'firstName': SchemaProperty.string(description: 'First name'),
    'lastName': SchemaProperty.string(description: 'Last name'),
    'email': SchemaProperty.string(description: 'Email address'),
    'phone': SchemaProperty.string(description: 'Phone number'),
    'address': SchemaProperty.object(
      properties: {
        'street': SchemaProperty.string(),
        'city': SchemaProperty.string(),
        'country': SchemaProperty.string(),
        'postalCode': SchemaProperty.string(),
      },
    ),
    'preferences': SchemaProperty.object(
      properties: {
        'newsletter': SchemaProperty.boolean(),
        'notifications': SchemaProperty.boolean(),
      },
    ),
  },
  required: ['id', 'firstName', 'lastName', 'email'],
);
```

### After Migration

```dart
final userSchema = SchemaDefinition(
  properties: {
    'id': SchemaProperty.string(
      description: 'User ID',
      nullable: false, // Required
    ),
    'firstName': SchemaProperty.string(
      description: 'First name',
      nullable: false, // Required
    ),
    'lastName': SchemaProperty.string(
      description: 'Last name',
      nullable: false, // Required
    ),
    'email': SchemaProperty.string(
      description: 'Email address',
      nullable: false, // Required
    ),
    'phone': SchemaProperty.string(
      description: 'Phone number',
      nullable: true, // Optional (not in required array)
    ),
    'address': SchemaProperty.object(
      properties: {
        'street': SchemaProperty.string(nullable: true),
        'city': SchemaProperty.string(nullable: false),
        'country': SchemaProperty.string(nullable: false),
        'postalCode': SchemaProperty.string(nullable: true),
      },
      nullable: true, // Entire address object is optional
    ),
    'preferences': SchemaProperty.object(
      properties: {
        'newsletter': SchemaProperty.boolean(nullable: true),
        'notifications': SchemaProperty.boolean(nullable: true),
      },
      nullable: true, // Entire preferences object is optional
    ),
  },
);
```

## Default Behavior

- If `nullable` is not specified, it defaults to `true` (optional)
- This maintains backward compatibility with existing code
- Explicitly set `nullable: false` for required fields

## Nested Objects and Arrays

The nullable parameter works at every level:

```dart
'items': SchemaProperty.array(
  items: SchemaProperty.object(
    properties: {
      'name': SchemaProperty.string(nullable: false), // Each item must have a name
      'quantity': SchemaProperty.number(nullable: false), // Each item must have quantity
      'notes': SchemaProperty.string(nullable: true), // Notes are optional per item
    },
  ),
  nullable: false, // The items array itself is required
),
```

## Backward Compatibility

The old pattern with the `required` array still works and will continue to be supported. However, we recommend migrating to the new pattern for better code clarity and maintainability.

If both patterns are used simultaneously (nullable properties AND a required array), the required array takes precedence to maintain backward compatibility.