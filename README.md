# TASK:
I wan't to unify the cli packages, those are; @claude_code_sdk/ @codex_cli_sdk/ @gemini_cli_sdk/ 
Since they have a lot of extremely similar structures ( if not 100% the equal structures ) I created a new package that will be the core for those cli sdk packages. It is the @programming_cli_core_sdk/ package.

I wan't you to START THE REFACTOR WITH CODEX
So you SHOULD NOT change a single line of code in @claude_code_sdk/ or  @claude_code_sdk/ because you should only refactor codex initially.

# Context: 

This is a the codebase of a saas
This hole thing is all about helping the my clients to generate scrapping bee extract rules with the help of AI.

The main prompts are in @web_scrapper_generator/lib/src/prompts.dart 
And the interaction is mainly done in @web_scrapper_generator/lib/src/implementations/ , with all implementations

Note: Making a simple request to a api and asking it to analyse a html most times is not enought since it lacks of interations (example, the user asks to click in a filter button and wait the loading before extrating any data, the api can not handle that). Because of that, I created 3 packages that are unoficial implementations of popular coding cli tools, they are;
@claude_code_sdk/ @codex_cli_sdk/ @gemini_cli_sdk/ 

Using cli tools allows me use, for example, mcp tools to garantee quality.
The first mcp that the ai uses is the @web_scrapper_generator/lib/src/puppeteer_setup.dart 
The ai will use this to visualize the html of the page it is navigating and perform actions that the user might ask for - also, it will see the html after the actions and will be able to get a screenshot of the screen if needed. With this, it will have much more capacity of creating a good extract rule json and js scenario json to use with scrapping bee

With a ScrappingBeeFetchSettings ( @web_scrapper_generator/lib/src/web_scrapper_response.dart ) generated, it will need to test it to try to see if that scrapping bee rule is in fact working - so in that part enters the scrapping be mcp that is a self made mcp, created by us, with our api key configured, so the ai can test if it in fact returns qualified responses that match what the customer asked for in his prompt.

So basicly it will make that back and forth from the creation of the rules 

Those mcps are configured in:
@web_scrapper_generator/lib/src/mcp_adapters.dart
The scraping bee mcp creation/setup logic is made in @web_scrapper_generator/lib/src/scraping_bee_mcp.dart 
The puppeteer is configured in @web_scrapper_generator/lib/src/puppeteer_setup.dart 

# But there is a problem:
All chat are really similar, they are:
- @gemini_cli_sdk/lib/src/gemini_chat.dart
- @claude_code_sdk/lib/src/claude_chat.dart
- @codex_cli_sdk/lib/src/codex_chat.dart

Also, the contents model when sending a prompt is very similar as well.
But they are not 100% the same. Because of that, I have to always check when I do a modification in one of them to do the same modification in the other and that does not scale - I don't wan't to repeat myself in 3 packages.

Because of that, let's unify every thing!

# Fix proposal

- GeminiSDK class from @gemini_cli_sdk/lib/src/gemini.dart, Codex class form @codex_cli_sdk/lib/src/codex.dart and Claude class from @claude_code_sdk/lib/src/claude.dart should be COMPLETY REFACTORED because now we will need to implement CodingCliInterface from @programming_cli_core_sdk/lib/src/coding_cli_interface.dart

- GeminiChat class from @gemini_cli_sdk/lib/src/gemini_chat.dart , CodexChat from @codex_cli_sdk/lib/src/codex_chat.dart ClaudeChat from @claude_code_sdk/lib/src/claude_chat.dart should be COMPLETY REFACTORED because now we will need to implement CliChatInterface from @programming_cli_core_sdk/lib/src/cli_chat_interface.dart 

- GeminiChatOptions from gemini_cli_sdk/lib/src/models/chat_options.dart , CodexChatOptions from codex_cli_sdk/lib/src/models/chat_options.dart and ClaudeChatOptions from
claude_code_sdk/lib/src/models/chat_options.dart should be COMPLETY REFACTORED because now we will need to implement CliChatOptions from @programming_cli_core_sdk/lib/src/cli_chat_options_interface.dart 

- GeminiSdkContent from @gemini_cli_sdk/lib/src/models/gemini_sdk_content.dart , CodexSdkContent from @codex_cli_sdk/lib/src/models/codex_sdk_content.dart and ClaudeSdkContent from @claude_code_sdk/lib/src/models/claude_sdk_content.dart should be COMPLETY DELETED and because now we will use @programming_cli_core_sdk/lib/src/prompt_content.dart

- GeminiSDKException from @gemini_cli_sdk/lib/src/exceptions/gemini_exceptions.dart , CodexSDKException from @codex_cli_sdk/lib/src/exceptions/codex_exceptions.dart and ClaudeSDKException from @claude_code_sdk/lib/src/exceptions/claude_exceptions.dart should be COMPLETY DELETED and because now we will use CliException from @programming_cli_core_sdk/lib/src/cli_exception.dart

- Shema models such as the ones in codex_cli_sdk/lib/src/models/schema_models.dart , gemini_cli_sdk/lib/src/models/schema_models.dart and claude_code_sdk/lib/src/models/schema_models.dart should be @programming_cli_core_sdk/lib/src/schema_property.dart 

- The files structures of each one of the 3 packages should be really close - so refactor the the files so the 3 packages have the same files. In fact, remove all folders and maake the files all displayed inside src/ without any subfolder.

Since it is a big refactor, I don't wan't you to get confuse with this amout of work to do. Because of that - ONLY REFACTOR CODEX ( @codex_cli_sdk/  ) for now and do not touch in any file in @claude_code_sdk/ or @gemini_cli_sdk/ 

Ps: Note that now they will not need to implement functions like sendMessage, streamResponse, sendMessageWithSchema and streamResponseWithSchema since they are already implemented in CliChatInterface - the package main structure will now all be about implementing the specific cli process of each one of them... and the overall logic will be the same for all of them. Also, garantee to set the filePreffix of programming_cli_core_sdk/lib/src/prompt_content.dart because gemini and claude code file reference starts with "@"

# Final considerations
The programming_cli_core_sdk is already imported in codex_cli_sdk/pubspec.yaml, gemini_cli_sdk/pubspec.yaml and claude_code_sdk/pubspec.yaml

This will fundamentally change how the cli packages work internally - they will now implement ZERO logic and will only build the cli commands - so this is a breaking change. So don't forget to update the version on yaml, the change log and the readme file. Also, fell free to web research for detailed information about specific package implementation (mainly to use the correct nomeclature to refer to a file in each cli package. Claude code uses "@" in the start, but other packages can use different things). 

Avoid changing the programming_cli_core_sdk for any reason - only change it if it is really needed.


Since it is a big refactor, I don't wan't you to get confuse with this amout of work to do. Because of that - ONLY REFACTOR CODEX ( @codex_cli_sdk/  ) for now and do not touch in any file in @claude_code_sdk/ or @gemini_cli_sdk/ 

I did not created any common source of mcp. I plan to do that later. But for now, continue to use the implementation of each package

Some configurations will need to be done in the @zenscrap_server/ since it uses the generation feature of @web_scrapper_generator/ - garantee that the migration is done there as well
Btw, if you need to generate serverpod files, use the command "serverpod generate --experimental-features=all". It need to have that flag because I am using some experimental-features...

YOU SHOULD check for static analysis error in each file and in @web_scrapper_generator/ , @zenscrap_flutter/ and @@zenscrap_server/ folder as well. Garantee there a are no errors in the repository as a hole after the fix.

ultrathink to do this task - is is VERY COMPLEX and envolves a lot of testing to make it work - do not rush and take your time - do with calm all web researchs that you need and think for the max as possible.