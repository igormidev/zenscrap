import 'package:claude_code_sdk/claude_code_sdk.dart';

void main() async {
  // Create SDK instance with your API key
  final claude = Claude('sk-ant-api03-YOUR_API_KEY_HERE');

  // Create a new chat session
  final chat = claude.createNewChat(
    options: ClaudeChatOptions(
      systemPrompt: 'You are a helpful assistant that extracts structured data',
      timeoutMs: 30000,
    ),
  );

  try {
    // Example 1: Simple schema with nullable properties
    print('Example 1: User information extraction\n');
    
    final userSchema = SchemaObject(
      properties: {
        'firstName': SchemaProperty.string(
          description: 'User\'s first name',
          nullable: false, // Required - must be present
        ),
        'lastName': SchemaProperty.string(
          description: 'User\'s last name',
          nullable: false, // Required - must be present
        ),
        'middleName': SchemaProperty.string(
          description: 'User\'s middle name if available',
          nullable: true, // Optional - may be null
        ),
        'age': SchemaProperty.number(
          description: 'User\'s age',
          nullable: false, // Required
        ),
        'email': SchemaProperty.string(
          description: 'User\'s email if available',
          nullable: true, // Optional
        ),
        'phoneNumber': SchemaProperty.string(
          description: 'User\'s phone number if available',
          nullable: true, // Optional
        ),
      },
    );
    
    final result1 = await chat.sendMessageWithSchema(
      messages: [
        ClaudeSdkContent.text(
          'Extract user info from: "John Smith is 30 years old. His email is john@example.com"'
        ),
      ],
      schema: userSchema,
    );
    print('Extracted user data: ${result1.data}\n');

    // Example 2: Nested schema with nullable objects and arrays
    print('Example 2: Product information with nested nullable properties\n');
    
    final productSchema = SchemaObject(
      properties: {
        'productId': SchemaProperty.string(
          description: 'Product ID',
          nullable: false, // Required
        ),
        'name': SchemaProperty.string(
          description: 'Product name',
          nullable: false, // Required
        ),
        'price': SchemaProperty.number(
          description: 'Product price',
          nullable: false, // Required
        ),
        'discount': SchemaProperty.number(
          description: 'Discount percentage if any',
          nullable: true, // Optional - may not have a discount
        ),
        'specifications': SchemaProperty.object(
          properties: {
            'weight': SchemaProperty.number(
              description: 'Weight in kg',
              nullable: true, // Optional spec
            ),
            'dimensions': SchemaProperty.string(
              description: 'Dimensions if available',
              nullable: true, // Optional spec
            ),
            'material': SchemaProperty.string(
              description: 'Material composition',
              nullable: false, // Required if specifications exist
            ),
          },
          nullable: true, // The entire specifications object is optional
        ),
        'tags': SchemaProperty.array(
          items: SchemaProperty.string(),
          description: 'Product tags',
          nullable: true, // Tags array is optional
        ),
        'inStock': SchemaProperty.boolean(
          description: 'Whether the product is in stock',
          nullable: false, // Required field
        ),
      },
    );
    
    final result2 = await chat.sendMessageWithSchema(
      messages: [
        ClaudeSdkContent.text(
          'Extract product info from: "The SuperWidget (ID: SW-001) costs \$99.99 and is made of aluminum. Currently in stock."'
        ),
      ],
      schema: productSchema,
    );
    print('Extracted product data: ${result2.data}\n');

    // Example 3: Schema with enum and default values
    print('Example 3: Order status with enums and defaults\n');
    
    final orderSchema = SchemaObject(
      properties: {
        'orderId': SchemaProperty.string(
          description: 'Order ID',
          nullable: false, // Required
        ),
        'status': SchemaProperty.string(
          description: 'Order status',
          enumValues: ['pending', 'processing', 'shipped', 'delivered', 'cancelled'],
          defaultValue: 'pending',
          nullable: false, // Required, but has a default
        ),
        'priority': SchemaProperty.string(
          description: 'Order priority level',
          enumValues: ['low', 'normal', 'high', 'urgent'],
          defaultValue: 'normal',
          nullable: true, // Optional with default
        ),
        'trackingNumber': SchemaProperty.string(
          description: 'Tracking number if shipped',
          nullable: true, // Optional - only present if shipped
        ),
        'estimatedDelivery': SchemaProperty.string(
          description: 'Estimated delivery date',
          nullable: true, // Optional
        ),
        'notes': SchemaProperty.string(
          description: 'Additional notes',
          nullable: true, // Optional
        ),
      },
    );
    
    final result3 = await chat.sendMessageWithSchema(
      messages: [
        ClaudeSdkContent.text(
          'Extract order info from: "Order #12345 has been shipped with tracking number TRK-9876"'
        ),
      ],
      schema: orderSchema,
    );
    print('Extracted order data: ${result3.data}\n');

  } catch (e) {
    print('Error: $e');
  } finally {
    await chat.dispose();
    await claude.dispose();
  }
}