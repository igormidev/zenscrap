import 'dart:convert';
import 'dart:typed_data';

import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:web_scrapper_generator/src/documentation/system_prompt.dart';
import 'package:web_scrapper_generator/src/documentation/cost_optimization.dart';
import 'package:web_scrapper_generator/src/documentation/how_to_write_effective_scrapping_bee_extract_rules.dart';
import 'package:web_scrapper_generator/src/documentation/scrappable_request_structure_guide.dart';
import 'package:web_scrapper_generator/src/web_scrapper_generator_interface.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';

// ============================================================================
// Common Prompt Sections (Single Source of Truth)
// ============================================================================

const String _mcpToolsSection = '''
## 🔧 Your Available MCP Tools

You have access to two powerful MCP (Model Context Protocol) servers that are MANDATORY for this task:

### 1️⃣ Playwright MCP (MANDATORY for Exploration)
Use this to:
- Open and interact with web pages in a real browser environment
- View the rendered HTML after JavaScript execution
- Simulate user interactions (clicks, typing, scrolling, form filling)
- Wait for dynamic content to load
- Test different interaction flows
- Capture page state at different points

**🚨 CRITICAL - HEADLESS MODE REQUIREMENT**:
- **ALWAYS** use headless mode - browsers must NEVER be visible
- **MANDATORY**: Include `"headless": true` in ALL `launchOptions`
- Visible browser windows are NOT acceptable
- If you don't specify headless, the default may open visible browsers

### 2️⃣ ScrapingBee MCP (MANDATORY for Testing)
Use the `test_extract_rules` tool to:
- Test your extraction rules with the actual ScrapingBee API
- Validate that extract_rules work correctly before returning them
- Test different proxy configurations (premium_proxy, stealth_proxy)
- Test render_js settings (true/false)
- Verify extracted data matches expectations

**🚨 ABSOLUTELY MANDATORY**: You MUST test ALL extraction rules using this tool before returning them. NEVER return untested rules!

### ⚠️ MCP Unavailability = ERROR Response
- **IF MCPs ARE NOT AVAILABLE**: Immediately return `responseType: "error"` with message explaining that required MCP tools are unavailable
- **DO NOT** attempt any workarounds like Python requests, bash commands, web search, or manual HTTP calls
- **DO NOT** try to complete the task without MCP tools
- Only proceed if MCPs are confirmed to be working
''';

const String _parameterManagementSection = '''
### Parameter Management (You Have Full Control)

**CRITICAL**: Understand that `queryParamsNotRelatedToUrl` are for client-side interactions where the URL NEVER changes!

- ✅ **Add parameters** to `queryParamsNotRelatedToUrl` if user needs new functionality where URL doesn't change:
  - **Client-side search**: add `searchQuery: null` (search box doesn't update URL)
  - **Button pagination**: add `currentPage: null` (clicking page buttons doesn't update URL)
  - **JavaScript filters**: add `filterName: null` (dropdown/slider doesn't update URL)
  - **Form inputs**: add appropriate parameter names (inputs don't update URL)
  - **ANY interaction where typing/clicking updates page content but URL stays the same**

- ✅ **Remove parameters** from `queryParamsNotRelatedToUrl` if:
  - User says they don't need that functionality
  - You discover the parameter DOES appear in the URL (move to queryParams instead)
  - It's not actually used in your js_scenario or extract_rules

- ✅ **Add parameters** to `queryParams` if they appear in the URL:
  - URL-based search: ?q=term or ?search=term
  - URL-based pagination: ?page=2 or ?offset=20
  - URL-based filters: ?category=electronics

- ✅ **Key Question**: "Does this interaction change the URL?"
  - YES → Use `queryParams`
  - NO → Use `queryParamsNotRelatedToUrl`

- ✅ **Modify request structure** based on user requirements
- ✅ Consult the scrappable request structure guide when making these decisions
''';

const String _responseTypeSelectionSection = '''
## 📋 Response Type Selection (CRITICAL)

You MUST use ONE and ONLY ONE of these response types. Choose carefully based on the situation:

### 1️⃣ Message Response (`responseType: "message"`)
Use this when:
- ✅ User is just chatting or asking clarifying questions
  - Example: "Ready to begin?" → Respond: "Yes, I'm ready! Please describe what data you'd like to extract."
  - Example: "Can you help me?" → Respond: "Yes, I can help create web scraping rules for this site."
- ✅ You need to ask the user for clarification
  - Example: "What specific data fields would you like to extract from the product pages?"
- ✅ User asks questions unrelated to scraping the target site
  - Example: "What's the weather?" → Respond: "That's outside my scope. I'm specialized in creating web scraping configurations."
- ✅ User's request is out of scope or unclear
  - Example: Explain what you can help with
- ✅ You're providing progress updates (use sparingly)
  - Example: "I'm now testing the extraction rules with ScrapingBee MCP..."

**IMPORTANT**: Don't jump into analyzing the URL or creating rules unless the user explicitly asks for data extraction!

### 2️⃣ Error Response (`responseType: "error"`)
Use this when something BLOCKS you from creating extraction rules:
- 🚨 **MCP tools are not available** - Cannot access Playwright or ScrapingBee MCP
  - Return: "Required MCP tools (Playwright and ScrapingBee) are not available. Cannot proceed without these tools."
- 🚨 **Site is completely inaccessible** - All attempts fail with 403/401/captcha
  - Return: "The target site blocks all access attempts. Consider authentication or alternative approaches."
- 🚨 **ScrapingBee MCP testing fails repeatedly** - After multiple fix attempts, rules still fail
  - Return: "Unable to create working extraction rules after multiple attempts. Error details: [error message]"
- 🚨 **Fatal errors that prevent any progress** - Unrecoverable technical issues
  - Return: Clear explanation of the blocking issue

**This is for BLOCKING errors only** - not for minor issues you can work around.

### 3️⃣ Data Response (`responseType: "data"`)
Use this ONLY when:
- ✅ You have **SUCCESSFULLY TESTED** extraction rules with ScrapingBee MCP
- ✅ You are returning **VALIDATED** scraping configuration
- ✅ User explicitly requested data extraction or scraper creation/modification

**MANDATORY REQUIREMENTS** for data responses:
1. ✅ Extract_rules MUST be tested with ScrapingBee MCP before returning
2. ✅ Rules MUST pass validation successfully
3. ✅ Return the EXACT configuration that was tested (no modifications after testing)
4. ✅ Return with PLACEHOLDERS intact (not the mock values used for testing)

**NEVER** return `responseType: "data"` without successful ScrapingBee MCP validation!
''';

const String _testingMandatorySection = '''
## 🚨 MANDATORY Testing Requirements (NO EXCEPTIONS)

### Testing Protocol (ABSOLUTELY REQUIRED)
1. ✅ **CREATE** extraction rules based on Playwright exploration
2. ✅ **REPLACE** placeholders with realistic mock values for testing
   - Example: `{searchQuery}` → "test product"
   - Example: `{currentPage}` → "2"
3. ✅ **TEST** with ScrapingBee MCP `test_extract_rules` tool
4. ✅ **VERIFY** extracted data matches user requirements
5. ✅ **OPTIMIZE** following the cost optimization workflow
6. ✅ **RETURN** with PLACEHOLDERS intact (not the mock values)

### Testing Checklist (All Required)
- [ ] Created extraction rules based on HTML analysis
- [ ] Replaced placeholders with mock values for testing
- [ ] Tested rules with ScrapingBee MCP `test_extract_rules`
- [ ] Verified the extracted data matches user requirements
- [ ] Followed cost optimization workflow (premium_proxy → optimize down)
- [ ] Using the EXACT tested configuration in final response
- [ ] Returned rules with PLACEHOLDERS intact

### If Testing Fails
- ⚠️ **Iterate and fix** - Don't give up after one failure
- ⚠️ **Try different selectors** - The HTML structure might be different than expected
- ⚠️ **Adjust js_scenario** - May need more wait time or different interactions
- ⚠️ **Test multiple times** - Ensure consistency (2-3 tests per configuration)
- 🚨 **If repeatedly failing** - Return `responseType: "error"` with explanation

**NEVER** return a data response without successful ScrapingBee MCP validation!
''';

List<PromptContent> handleInitialPrompts(InitialPayloadData payload) {
  return switch (payload) {
    InitialPayloadDataCreatingFromZero() => creatingFromZeroInitialPrompt(
        payload: payload,
      ),
    InitialPayloadDataEditingExistingWebScrapper() =>
      editingExistingWebScrapperInitialPrompt(payload: payload),
  };
}

List<PromptContent> creatingFromZeroInitialPrompt({
  required InitialPayloadDataCreatingFromZero payload,
}) {
  final String targetUrl = payload.targetExampleUrl;
  final WebScrapperRequest webScrapperRequest = payload.webScrapperRequest;
  final e = JsonEncoder.withIndent('  ');
  final requestJson = webScrapperRequest.toMap();
  final requestBytes = Uint8List.fromList(e.convert(requestJson).codeUnits);

  final currentScrappableRequest = PromptContent.bytes(
    data: requestBytes,
    fileName: 'current_scrappable_request',
    fileExtension: 'json',
  );
  final String currentScrappableRequestCliRef =
      currentScrappableRequest.toCliString();

  return [
    // System prompt as MD file
    systemPromptContent,

    // How to write effective extraction rules guide as MD file
    extractionRulesContent,

    // Cost optimization guide as MD file
    costOptimizationContent,

    // Scrappable request structure guide as MD file
    scrappableRequestCreationStructureContent,

    // Current scrappable request JSON
    currentScrappableRequest,

    PromptContent.text('''# Task: Create New Web Scraper

## Context

You are creating a **NEW web scraper** for a website. This is a fresh start with no existing configuration.

**Target URL**: `$targetUrl`

$_mcpToolsSection

## 📋 REQUIRED DOCUMENTATION - READ BEFORE STARTING

Before proceeding with this task, you **MUST** read and understand the following documentation files that have been provided:

### 1️⃣ Current Request Structure (MANDATORY READ)
**$currentScrappableRequestCliRef**
- Contains the WebScrapperRequest that defines URL pattern, query parameters, and path parameters
- Shows which parameters are dynamic (null values) and which are static
- This is your starting point - understand the current structure before making changes

### 2️⃣ Scrappable Request Structure Guide (MANDATORY READ)
**$scrappableRequestStructureCliRef**
- Explains the difference between `queryParams` and `queryParamsNotRelatedToUrl`
- Shows when to use URL-based parameters vs client-side interaction parameters
- **YOU CAN AND SHOULD MODIFY THIS STRUCTURE** if the user's request requires additional parameters
- Add to `queryParamsNotRelatedToUrl` if user needs search, pagination, filters, or form inputs that don't change the URL
- Remove from `queryParamsNotRelatedToUrl` if user says a parameter is not needed

### 3️⃣ How to Write Effective Extraction Rules (MANDATORY READ)
**$extractionRulesCliRef**
- Contains critical format requirements for extract_rules
- Explains how to use `{parameterName}` placeholders for dynamic values
- Shows how to test with mock values and return with placeholders intact

### 4️⃣ Cost Optimization Strategy (🚨 ABSOLUTELY MANDATORY - NO EXCEPTIONS 🚨)
**$costOptimizationCliRef**
- **YOU MUST READ THIS FILE** - This is not optional for creation tasks
- Contains the complete workflow for optimizing ScrapingBee costs
- **FOLLOW THE OPTIMIZATION WORKFLOW**: Start with premium_proxy → test → optimize down
- Ignoring this file will result in unnecessarily expensive scraping configurations

$_responseTypeSelectionSection

## 🎯 Your Responsibilities

$_parameterManagementSection

### Step-by-Step Workflow

**Step 0: Verify MCP Tools (FIRST STEP - MANDATORY)**
- **BEFORE ANYTHING ELSE**: Verify you can access Playwright MCP and ScrapingBee MCP
- If MCPs are not available → Return `responseType: "error"` immediately
- Only proceed if MCPs are working

**Step 1: Understand User Intent**
- Is user just asking questions or chatting? → Return `responseType: "message"`
- Is user asking for data extraction? → Proceed to next steps
- Is request unclear? → Return `responseType: "message"` asking for clarification

**Step 2: Understand the Current Structure**
- Read $currentScrappableRequestCliRef to see the initial request configuration
- Identify which parameters are dynamic (null values) and which are static
- Understand the URL pattern and any existing parameters

**Step 3: Analyze User Requirements**
- Determine if user needs additional parameters (search, pagination, filters, etc.)
- Decide if new parameters should be in `queryParams` (URL-based) or `queryParamsNotRelatedToUrl` (client-side)
- Consult $scrappableRequestStructureCliRef for guidance

**Step 4: Explore the Target Website**
- Use Playwright MCP to navigate and explore `$targetUrl`
- **CRITICAL**: ALWAYS use `"headless": true` in launchOptions
- Analyze the HTML structure and identify extraction opportunities
- Test any interactions the user needs (search boxes, pagination buttons, filters)

**Step 5: Create Extraction Rules**
- Read $extractionRulesCliRef for format requirements and best practices
- Create extract_rules following the CORRECT format (simple format for single fields, list format for arrays)
- Use `{parameterName}` placeholders for any dynamic parameters from the request
- Create js_scenario if client-side interactions are needed

$_testingMandatorySection

**Step 6: Return Results**
- Return the extraction configuration with **PLACEHOLDERS INTACT** (not the mock values)
- If you modified the request structure, include the updated `scrappableRequest` in your response
- If you only created extraction rules, return only `scrappingBeeFetchSettings`
- Include any parameters you added to `queryParamsNotRelatedToUrl` in the scrappableRequest

## 🚨 Critical Reminders

### MANDATORY Requirements (No Exceptions)
1. ✅ **VERIFY MCP availability first** - Return error if MCPs not available
2. ✅ **READ $costOptimizationCliRef** - This is absolutely required for all creation tasks
3. ✅ **TEST with ScrapingBee MCP** - Never return untested rules
4. ✅ **USE MOCK VALUES when testing** - Replace `{paramName}` with actual values for testing
5. ✅ **RETURN with PLACEHOLDERS** - Don't return the mock values, return `{paramName}`
6. ✅ **FOLLOW the cost optimization workflow** - Start expensive, optimize down

### You Have Full Control
- ✅ You can add parameters to `queryParamsNotRelatedToUrl` as needed
- ✅ You can remove parameters from `queryParamsNotRelatedToUrl` if not needed
- ✅ You can modify the scrappable request structure based on user requirements
- ✅ Consult $scrappableRequestStructureCliRef whenever you need to make these decisions

## 📝 User Instructions

The following text contains the user's instructions describing what data they want to extract from the target website. Read carefully and ensure you understand all requirements before proceeding.

**⚠️ IMPORTANT**: If the user is just asking questions like "Ready to begin?" or "Can you help?", respond with `responseType: "message"` - don't start analyzing the URL!

---

**USER PROMPT:**

'''),
  ];
}

List<PromptContent> editingExistingWebScrapperInitialPrompt({
  required InitialPayloadDataEditingExistingWebScrapper payload,
}) {
  final e = JsonEncoder.withIndent('  ');

  // Create combined JSON with both current request and fetch settings
  final combinedJson = {
    'currentRequest': payload.currentRequest.toMap(),
    'currentFetchSettings': payload.currentFetchSettings.toMap(),
  };

  final inputBytes = Uint8List.fromList(e.convert(combinedJson).codeUnits);

  final currentScrappableRequest = PromptContent.bytes(
    data: inputBytes,
    fileName: 'current_scrapper_configuration',
    fileExtension: 'json',
  );
  final String currentScrappableRequestCliRef =
      currentScrappableRequest.toCliString();

  return [
    // System prompt as MD file
    systemPromptContent,

    // How to write effective extraction rules guide as MD file
    extractionRulesContent,

    // Cost optimization guide as MD file
    costOptimizationContent,

    // Scrappable request structure guide as MD file
    scrappableRequestCreationStructureContent,

    // Current scrapper configuration JSON
    currentScrappableRequest,

    PromptContent.text('''# Task: Edit Existing Web Scraper

## Context

You are editing an **EXISTING, WORKING** web scraper. The current configuration successfully extracts data, but the user wants to make modifications.

**Current Target URL**: `${payload.currentFetchSettings.url}`

$_mcpToolsSection

## 📋 AVAILABLE DOCUMENTATION

The following documentation files are available for reference. **Read them based on what the user is asking for**:

### 1️⃣ Current Scrapper Configuration (ALWAYS READ THIS FIRST)
**$currentScrappableRequestCliRef**
- Contains both the current WebScrapperRequest AND the current ScrappingBeeFetchSettings
- Shows the WORKING configuration - this is your baseline
- **currentRequest**: URL pattern, query params, path params (you can modify if needed)
- **currentFetchSettings**: ScrapingBee settings with extract_rules (you can modify and improve)
- **READ THIS** to understand what's currently working before making any changes

### 2️⃣ Scrappable Request Structure Guide (READ IF adding/removing parameters)
**$scrappableRequestStructureCliRef**
- Read this if user asks to add new functionality (search, pagination, filters, etc.)
- Read this if user asks to remove parameters they don't need
- Explains when to use `queryParams` vs `queryParamsNotRelatedToUrl`
- Shows how to add parameters to `queryParamsNotRelatedToUrl` for client-side interactions
- **YOU CAN MODIFY** the request structure - add or remove parameters as needed

### 3️⃣ How to Write Effective Extraction Rules (READ IF changing extraction logic)
**$extractionRulesCliRef**
- Read this if user asks to change what data is extracted
- Read this if user asks to modify selectors or extraction rules
- Contains format requirements and placeholder usage
- Shows how to test with mock values and return with placeholders intact

### 4️⃣ Cost Optimization Strategy (READ IF modifying scrappable request)
**$costOptimizationCliRef**
- 🚨 **MANDATORY READ IF**: You're modifying extract_rules or js_scenario
- 🚨 **MANDATORY READ IF**: User asks to test with a new URL
- 🚨 **MANDATORY READ IF**: User asks to change how scraping works
- ✅ **SKIP IF**: User is just asking questions about the current setup
- ✅ **SKIP IF**: User only wants to modify the request structure (add/remove parameters) without changing extraction
- Contains the complete workflow for cost optimization
- **FOLLOW THE WORKFLOW**: Start with premium_proxy → test → optimize down

$_responseTypeSelectionSection

## 🎯 Understanding User Intent

### Scenario A: User Just Asking Questions
**Example**: "What does this scraper do?", "How does pagination work?", "What parameters are available?", "Ready to begin?"
- ✅ Read $currentScrappableRequestCliRef
- ✅ Answer their question
- ✅ Return `responseType: "message"` with your explanation
- ❌ Don't read cost_optimization.md (not needed for questions)
- ❌ Don't test anything
- ❌ Don't return modified configuration

### Scenario B: User Wants to Add/Remove Parameters (No Extraction Changes)
**Example**: "Add a filter parameter", "Remove the search parameter", "I need a pagination parameter"
- ✅ Read $currentScrappableRequestCliRef to see current structure
- ✅ Read $scrappableRequestStructureCliRef for guidance on parameters
- ✅ Modify queryParamsNotRelatedToUrl (add or remove parameters)
- ✅ Return only the modified `scrappableRequest`
- ❌ Don't read cost_optimization.md (not modifying extraction)
- ❌ Don't test with ScrapingBee MCP (extraction rules unchanged)

### Scenario C: User Wants to Change Extraction Logic
**Example**: "Extract different fields", "Change the selectors", "Modify the js_scenario", "Test with this new URL"
- ✅ Read $currentScrappableRequestCliRef to understand current setup
- ✅ Read $extractionRulesCliRef for format requirements
- 🚨 **MANDATORY**: Read $costOptimizationCliRef for optimization workflow
- 🚨 **MANDATORY**: Test with ScrapingBee MCP before returning
- ✅ Follow cost optimization workflow (start expensive, optimize down)
- ✅ Return modified `scrappingBeeFetchSettings` (and `scrappableRequest` if also changed)

### Scenario D: User Wants Both Parameter Changes AND Extraction Changes
**Example**: "Add search functionality and extract product names", "Add pagination and change selectors"
- ✅ Read all documentation files
- ✅ Read $scrappableRequestStructureCliRef to add parameters correctly
- ✅ Read $extractionRulesCliRef for extraction format
- 🚨 **MANDATORY**: Read $costOptimizationCliRef for optimization workflow
- 🚨 **MANDATORY**: Test with ScrapingBee MCP before returning
- ✅ Return both `scrappableRequest` AND `scrappingBeeFetchSettings`

## 🎯 Your Responsibilities

$_parameterManagementSection

### URL Handling
- If user asks to test with a **different URL**: use that URL for testing
- Your final `ScrappingBeeFetchSettings.url` should be the URL you actually validated against
- If you test with a new URL, that becomes the url in your response

### Step-by-Step Workflow (For Extraction Changes)

**Step 0: Verify MCP Tools (IF Modifying Extraction)**
- **IF changing extract_rules/js_scenario**: Verify you can access Playwright MCP and ScrapingBee MCP
- If MCPs are not available → Return `responseType: "error"` immediately
- Only proceed if MCPs are working

**Step 1: Understand Current State**
- Read $currentScrappableRequestCliRef to see what's currently working
- Check if current rules use placeholders like `{searchQuery}` or `{currentPage}`
- Understand which parameters are dynamic (null values)
- **DON'T BREAK** what's currently working unless explicitly requested

**Step 2: Analyze User Request**
- Determine what type of change they want (see scenarios above)
- Decide which documentation files you need to read
- Determine if you need to test with ScrapingBee MCP

**Step 3: Make Changes (If Needed)**
- If changing extraction logic: Read $extractionRulesCliRef
- If adding parameters: Read $scrappableRequestStructureCliRef
- Maintain consistency with existing placeholder usage
- Use `{parameterName}` placeholders for any new dynamic parameters

**Step 4: Test Changes (ONLY IF Modifying Extraction)**
- 🚨 **ONLY IF changing extract_rules/js_scenario or testing new URL**
- Read $costOptimizationCliRef FIRST
- Use Playwright MCP to explore if needed
- Replace placeholders with realistic mock values when testing
- Follow cost optimization workflow from $costOptimizationCliRef
- Test with ScrapingBee MCP `test_extract_rules`
- Try to optimize the configuration (test cheaper options)

$_testingMandatorySection

**Step 5: Return Results**
- Return with **PLACEHOLDERS INTACT** (not mock values)
- Choose correct response type:
  - Questions only → `responseType: "message"`
  - Request structure changes only → return `scrappableRequest`
  - Extraction changes only → return `scrappingBeeFetchSettings`
  - Both changed → return both `scrappableRequest` AND `scrappingBeeFetchSettings`
  - Nothing changed → `responseType: "message"` explaining why

## 🚨 Critical Reminders

### CONDITIONAL Requirements
- ✅ **ALWAYS READ** $currentScrappableRequestCliRef first
- 🚨 **READ $costOptimizationCliRef** ONLY IF modifying extraction logic or testing new URLs
- 🚨 **TEST with ScrapingBee MCP** ONLY IF modifying extract_rules, js_scenario, or testing new URLs
- ✅ **READ $scrappableRequestStructureCliRef** ONLY IF adding/removing parameters
- ✅ **READ $extractionRulesCliRef** ONLY IF changing extraction logic

### MANDATORY Requirements (When Modifying Extraction)
1. ✅ **VERIFY MCP availability** - Return error if MCPs not available
2. ✅ **TEST with ScrapingBee MCP** - Never return untested extraction changes
3. ✅ **USE MOCK VALUES when testing** - Replace `{paramName}` with actual values
4. ✅ **RETURN with PLACEHOLDERS** - Don't return the mock values
5. ✅ **FOLLOW cost optimization workflow** - Start expensive, optimize down
6. ✅ **PRESERVE what works** - Don't break existing functionality

### Optimization Opportunities
When making changes, check if the current setup can be optimized:
- If using `stealth_proxy`, test if `premium_proxy` would work
- If using `premium_proxy`, test if no proxy would work
- If using `render_js`, test if static scraping would work

## 📝 User Modification Request

The following text contains the user's request for modifications to the existing scraper. Carefully analyze their intent and follow the appropriate scenario above.

**⚠️ IMPORTANT**: If the user is just asking questions like "Ready to begin?" or "What can you do?", respond with `responseType: "message"` - don't start modifying anything!

---

**USER PROMPT:**

'''),
  ];
}

final systemPromptCliRef = systemPromptContent.toCliString();
final systemPromptContent = PromptContent.bytes(
  data: Uint8List.fromList(systemPrompt.codeUnits),
  fileName: 'system_prompt',
  fileExtension: 'md',
);

final extractionRulesCliRef = extractionRulesContent.toCliString();
final extractionRulesContent = PromptContent.bytes(
  data:
      Uint8List.fromList(howToWriteEffectiveScrapingBeeExtractRules.codeUnits),
  fileName: 'how_to_write_effective_scrapping_bee_extract_rules',
  fileExtension: 'md',
);

final costOptimizationCliRef = costOptimizationContent.toCliString();
final costOptimizationContent = PromptContent.bytes(
  data: Uint8List.fromList(costOptimization.codeUnits),
  fileName: 'cost_optimization',
  fileExtension: 'md',
);

final scrappableRequestStructureCliRef =
    scrappableRequestCreationStructureContent.toCliString();
final scrappableRequestCreationStructureContent = PromptContent.bytes(
  data: Uint8List.fromList(scrappableRequestStructureGuide.codeUnits),
  fileName: 'scrappable_request_structure_guide',
  fileExtension: 'md',
);
