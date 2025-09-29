# TASK:
Ensure if the scrapping @web_scrapper_generator/lib/src/scraping_bee_mcp.dart and @zenscrap_server/lib/src/core/scraping_bee.dart have the same testing outputs.

# Context:
This is a the codebase of a saas
This hole thing is all about helping the my clients to generate scrapping bee extract rules with the help of AI.

The main prompts are in @web_scrapper_generator/lib/src/prompts.dart 
And the interaction is mainly done in @web_scrapper_generator/lib/src/implementations/ , with all implementations

Note: Making a simple request to a api and asking it to analyse a html most times is not enought since it lacks of interations (example, the user asks to click in a filter button and wait the loading before extrating any data, the api can not handle that). Because of that, I created 3 packages that are unoficial implementations of popular coding cli tools, they are;
@claude_code_sdk/ @codex_cli_sdk/ @gemini_cli_sdk/ 

Using cli tools allows me use, for example, mcp tools to garantee quality.
The first mcp that the ai uses is the @web_scrapper_generator/lib/src/playwright_setup.dart
The ai will use Playwright to visualize the html of the page it is navigating and perform actions that the user might ask for - also, it will see the html after the actions and will be able to get a screenshot of the screen if needed. With this, it will have much more capacity of creating a good extract rule json and js scenario json to use with scrapping bee - and it can test if scrapping bee extract rule works with the scrapping bee mcp ( located in @web_scrapper_generator/lib/src/scraping_bee_mcp.dart  ) in order to have certain that it generated generate a ScrappingBeeFetchSettings that works.

With a ScrappingBeeFetchSettings ( @web_scrapper_generator/lib/src/web_scrapper_response.dart  ) generated, it will need to test it to try to see if that scrapping bee rule is in fact working - so in that part enters the scrapping be mcp that is a self made mcp, created by us, with our api key configured, so the ai can test if it in fact returns qualified responses that match what the customer asked for in his prompt.

So basicly it will make that back and forth from the creation of the rules 

Those mcps are configured in:
@web_scrapper_generator/lib/src/mcp_adapters.dart
The scraping bee mcp creation/setup logic is made in @web_scrapper_generator/lib/src/scraping_bee_mcp.dart
The puppeteer is configured in @web_scrapper_generator/lib/src/playwright_setup.dart

# But there is a problem:
I saw that the the ai uses the @web_scrapper_generator/lib/src/scraping_bee_mcp.dart to test the scrapping rules. And thats correct.

But then, when it returns correctly a response to the chat and the chat itself tests the in @zenscrap_server/lib/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart , when it tests with the ".fetchHtmlAndScreenshot" from @zenscrap_server/lib/src/core/scraping_bee.dart it fails and I don't know why since it did success in the mcp.

# Fix proposal
Because of that, I wan't to make them equal. My ideia is to use one source of true.
Let's unify
- ScrappingBeeExtractLogic at @zenscrap_server/lib/src/entities/scrappable/scrapping_bee_extract_logic.spy.yaml 
- ScrappingBeeFetchSettings at @web_scrapper_generator/lib/src/web_scrapper_response.dart
- Scrapping be mcp at @web_scrapper_generator/lib/src/scraping_bee_mcp.dart

First thing. Garantee that ScrappingBeeExtractLogic and ScrappingBeeFetchSettings have the same variables related to api capabilities. For example, I noticed that the ScrappingBeeExtractLogic does not have the stealth_proxy option - add with that variable it will be compatible with what mcp uses.

Now, lets garantee there is one source of true for testing.
For that, you will create in @web_scrapper_generator/ a unique mixin file that does request to scrapping bee. Move the _apiKey, _baseUrl and _dio from ScrapingBeeMcpServer to that new mixin and use that mixin in mcp server.
That mixin will have the follwing functions:
```dart
Map<String, String> buildQueryParameters({
  required String extract_rules,
  required String? js_scenario,
  required bool render_js,
  required int? wait,
  required String? wait_for,
  required String? wait_browser,
  required bool premium_proxy,
  required bool stealth_proxy,
  required String? country_code,
  required String? session_id,
  required bool? custom_google,
}) { ... }

Future<ExtractDataByRule> extractByRules({
  required String targetUrl,
  required String extract_rules,
  required String? js_scenario,
  required bool render_js,
  required int? wait,
  required String? wait_for,
  required String? wait_browser,
  required bool premium_proxy,
  required bool stealth_proxy,
  required String? country_code,
  required String? session_id,
  required bool? custom_google,
}) async { ... }

Future<ExtractFullDataByRule> fetchHtmlAndScreenshot({
  required String targetUrl,
  required String extract_rules,
  required String? js_scenario,
  required bool render_js,
  required int? wait,
  required String? wait_for,
  required String? wait_browser,
  required bool premium_proxy,
  required bool stealth_proxy,
  required String? country_code,
  required String? session_id,
  required bool? custom_google,
}) async { ... }
```

Then, after creating that mixin - use it in ScrapingBeeMcpServer and export it in @web_scrapper_generator/lib/web_scrapper_generator.dart so you can use it in as mixin for the class ScrapingBee in @zenscrap_server/lib/src/core/scraping_bee as well (refactor fetchHtmlAndScreenshot and extractByRules) - this way we will ensure that there is only 1 source of truth to fetch scrapping bee.

This way, the problem might disapear... Also, IF YOU THINK IS NEEDED, Modify the prompts in @web_scrapper_generator/lib/src/prompts.dart to tell ai that it SHOULD NOT END AND RETURN WITHOUT TESTING ITS GENERATED SCHEMA OF EXTRACT RULES IN THE MCP - ask it to use thame.

# Final considerations
Deeply understand how the chat systems works in @programming_cli_core_sdk/lib/src/cli_chat_options_interface.dart before writing any code.

Avoid changing the programming_cli_core_sdk for any reason - only change it if it is really needed.

I did not created any common source of mcp. I plan to do that later. But for now, continue to use the implementation of each package.

Some configurations will need to be done in the @zenscrap_server/ since it uses the generation feature of @web_scrapper_generator/ - garantee that the migration is done there as well
Btw, if you need to generate serverpod files, use the command "serverpod generate --experimental-features=all". It need to have that flag because I am using some experimental-features...

YOU SHOULD check for static analysis error in each file and in @web_scrapper_generator/ , @zenscrap_flutter/ and @@zenscrap_server/ folder as well. Garantee there a are no errors in the repository as a hole after the fix.

ultrathink to do this task - is is VERY COMPLEX and envolves a lot of testing to make it work - do not rush and take your time - do with calm all web researchs that you need and think for the max as possible.