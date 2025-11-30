# Claude Code Guidelines - Zenscrap Server

## Project Overview

Zenscrap Server is a Serverpod-based backend that powers an AI-driven web scraping rule generator. Users interact with an AI assistant through a chat interface to create, test, and refine ScrapingBee extraction configurations. The AI uses two MCP (Model Context Protocol) servers to browse pages and test extraction rules.

## Architecture

### Core Chat System (`lib/src/endpoints/public/chat_controller/`)

The chat system follows this flow:

1. **`scrappable_chat_session.dart`** - Session management endpoint
   - Creates/disposes chat sessions tied to a `Scrappable` entity
   - Maintains in-memory caches for session data:
     - `_scrapRedraftSessions`: Chat response streams
     - `_thinkingStream`: AI thinking process streams
     - `_cacheRefTestData`, `_cacheScrappingBeeExtractLogic`, `_cacheScrappableRequest`: Session-specific data
   - Uses `FutureCall` pattern for async message processing (`SessionPromptFutureCall`)

2. **`chat_controller_openai_sdk_impl.dart`** - OpenAI API integration
   - Uses OpenAI Responses API (`/v1/responses`) with streaming
   - Configures two MCP servers as tools:
     - `playwright`: Browser automation with ScrapingBee proxy
     - `scraping_bee`: Extract rules testing
   - Handles structured JSON responses with `text.format` and `json_schema`
   - Streams thinking process to user via `thinkingStream`

3. **`chat_controller_handler_mixin.dart`** - Response handling
   - Validates AI-generated extract rules by calling ScrapingBee API
   - Implements retry logic (up to 3 attempts) with detailed error feedback
   - Updates database with new/modified extract rules

4. **`openai_prompt_builder.dart`** - Prompt construction
   - System prompt with MCP usage instructions and workflow
   - Context prompt with current scrappable state

5. **`web_scraper_ai_models.dart`** - Data models and JSON schema
   - `webScraperResponseJsonSchema`: OpenAI structured output schema
   - Response types: `message`, `error`, `data`
   - `parseStructuredResponse()`: Converts JSON to typed response

### MCP Servers (External - Railway hosted)

**Playwright MCP** (`playwright-mcp-railway/`):
- URL: `https://playwright-mcp-scrapingbee-production.up.railway.app/mcp`
- Tools: `browser_navigate`, `browser_snapshot`, `browser_click`, `browser_type`, `browser_screenshot`, `browser_evaluate`, `browser_get_html`, `browser_wait_for`
- Uses ScrapingBee as proxy for anti-bot bypass

**ScrapingBee MCP** (`scrapping_bee_mcp/`):
- URL: `https://scraping-bee-mcp-production.up.railway.app/mcp`
- Tools: `test_extract_rules`, `get_page_html`, `get_screenshot`
- Requires `api_key` parameter in each call

## Key Data Structures

### ScrappingBeeExtractLogic (Database entity)
```dart
extractRules       // JSON string of CSS/XPath selectors
jsScenario         // Optional JS scenario for interactions
renderJs           // Enable headless browser
wait               // Fixed delay (0-35000ms)
waitFor            // Selector to wait for
waitBrowser        // Browser event to wait for
premiumProxy       // Residential proxy
stealthProxy       // Stealth proxy (expensive)
countryCode        // Geolocation
sessionId          // Sticky sessions
customGoogle       // Google-specific handling
```

### ScrappableRequest (Database entity)
```dart
url                        // Base URL with {param} placeholders
queryParams                // URL query params (null = required)
queryParamsNotRelatedToUrl // Client-side placeholders for js_scenario
pathParams                 // Path parameter names
```

## Common Issues & Debugging

### OpenAI Streaming
- The code uses `response.output_text.delta` for thinking content and `response.output_json.delta` for structured JSON
- `response.completed` event contains the full parsed response
- MCP events (`response.mcp_*`) are streamed to show tool usage

### Extract Rules Validation
- After AI returns extract rules, `handleSendMessage()` tests them via `scrappingBee.fetchHtmlAndScreenshotWithLogic()`
- Failures trigger retry with detailed error context in `buildRetryMessage()`

### JSON Parsing Fallbacks
The response parser tries multiple extraction paths:
1. `parsedFromCompletion` from `response.completed` event
2. `jsonBuffer` from `response.output_json.delta` events
3. JSON extraction from `thinkingBuffer` text content (markdown code blocks, etc.)

## Development Commands

```bash
# Generate Serverpod code (ALWAYS use experimental features)
serverpod generate --experimental-features=all

# Run server
dart bin/main.dart

# Run tests
dart test

# Apply database migrations
serverpod create-migration --experimental-features=all
serverpod migrate --experimental-features=all
```

## Critical Patterns

### Session Management
Sessions are tied to `Scrappable.id` and expire after 1 hour. Only one session per scrappable is allowed.

### API Keys
- OpenAI: `session.passwords['openAiApiKey']`
- ScrapingBee: Hardcoded in prompts (should be moved to config)
- Gemini (for create_scrappable): `session.passwords['geminiApiKey']`

### Error Handling
- `ZenScrapException` for user-facing errors with `title` and `description`
- `ErrorTextResponse` for streaming error messages to chat
- Detailed logging via `session.log()`

## OpenAI Responses API Configuration

The current implementation uses:
```dart
{
  'model': 'gpt-5.1',  // Model name
  'stream': true,
  'tools': [
    {'type': 'mcp', 'server_label': 'playwright', 'server_url': '...', 'require_approval': 'never'},
    {'type': 'mcp', 'server_label': 'scraping_bee', 'server_url': '...', 'require_approval': 'never'}
  ],
  'text': {'format': responseFormat},  // JSON schema for structured output
  'input': messages  // Conversation history
}
```

## Troubleshooting

### "Failed to parse structured response"
- Check if MCP servers are returning errors
- Look at `receivedEventTypes` in logs to see what events were received
- The AI might be using MCP tools extensively and not returning JSON properly

### MCP Not Working
- Test MCP endpoints directly with curl:
  ```bash
  curl -X POST https://playwright-mcp-scrapingbee-production.up.railway.app/mcp \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
  ```
- Check Railway logs for MCP server errors

### Extract Rules Always Failing
- The AI must test rules via ScrapingBee MCP before returning
- If MCP is unreachable, AI cannot validate rules
- Check if api_key is being passed correctly in MCP tool calls
