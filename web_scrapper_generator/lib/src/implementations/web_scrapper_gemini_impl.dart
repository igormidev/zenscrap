import 'package:gemini_cli_sdk/gemini_cli_sdk.dart';
import 'package:web_scrapper_generator/src/prompts.dart';
import 'package:web_scrapper_generator/src/web_scrapper_generator_interface.dart';
import 'package:web_scrapper_generator/src/web_scrapper_response.dart';
import 'package:web_scrapper_generator/src/models/ai_models.dart';
import 'package:web_scrapper_generator/src/scraping_bee_mcp.dart';
import '../puppeteer_setup.dart';

/// Gemini implementation of the web scrapper generator
class WebScrapperGeminiImpl
    extends WebScrapperGeneratorController<GeminiModel> {
  static late final GeminiSDK _geminiSDK;

  /// Initialize the Gemini SDK and its MCP servers
  static Future<void> initGemini({
    required String geminiApiKey,
    required String scrappingBeeApiKey,
    required ScrappingBeeProxyConfig proxyConfig,
  }) async {
    // Initialize shared resources first
    await WebScrapperGeneratorController.initShared(
      scrappingBeeApiKey: scrappingBeeApiKey,
      proxyConfig: proxyConfig,
    );

    print('🚀 Initializing Gemini SDK for web scraper generator...\n');
    _geminiSDK = GeminiSDK(geminiApiKey);

    // Ensure Gemini CLI is installed and up to date
    await _geminiSDK.updateToNewestVersionIfNeeded(global: true);

    // Setup Puppeteer and its MCP integration
    await PuppeteerSetup.instance.setupIfNeeded(
      _geminiSDK,
      proxyConfig: proxyConfig,
    );

    // Initialize ScrapingBee MCP server
    await ScrapingBeeMcpServerSetup.instance.setupIfNeeded(_geminiSDK);
  }

  final GeminiChat _chat;

  WebScrapperGeminiImpl._(InitialPayloadData initialPayload, GeminiChat chat)
    : _chat = chat,
      super(initialPayload: initialPayload);

  /// Factory method to create a new chat instance
  static WebScrapperGeminiImpl startChat({
    required InitialPayloadData initialPayload,
    GeminiModel model = GeminiModel.gemini25Flash,
  }) {
    final chat = _geminiSDK.createNewChat(
      options: GeminiChatOptions(
        systemPrompt: systemPrompt,
        model: model.apiName,
        allowedMcpServerNames: ['puppeteer', 'scraping-bee-mcp'],
        allowedTools: ['*'], // Allow all tools from the allowed MCP servers
        approvalMode: 'yolo', // Automatically approve all tool usage
      ),
    );

    final instance = WebScrapperGeminiImpl._(initialPayload, chat);
    return instance;
  }

  @override
  Future<void> changeModel(GeminiModel model) async {
    _chat.changeModel(model.apiName);
  }

  @override
  Future<WebScrapperChatAIResponse> sendMessage({
    required String userPrompt,
  }) async {
    List<GeminiSdkContent> messages = [];

    // Add initial prompts if this is the first message
    final isFirstMessage = _chat.isFirstMessage;
    if (isFirstMessage) {
      messages.addAll(handleInitialPrompts(initialPayload));
    }

    // Add the user's prompt
    messages.add(GeminiSdkContent.text(userPrompt));

    // Define the response schema for structured output
    final responseSchema = buildGeminiResponseSchema();

    try {
      // Send message with schema for structured response
      final result = await _chat.sendMessageWithSchema(
        messages: messages,
        schema: responseSchema,
      );

      // Parse the structured response
      return parseStructuredResponse(result.data);
    } catch (e) {
      // If there's an error, return an error response
      return WebScrapperChatAIResponseErrorMessage(
        'Failed to process your request: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> dispose() async {
    await _chat.dispose();
  }
}

class AsyncClaudeSdkResponse {
  final String llmMessage;
  final Map<String, dynamic> structuredSchemaData;

  const AsyncClaudeSdkResponse({
    required this.llmMessage,
    required this.structuredSchemaData,
  });
}

/*# TASK:
You should fix the schema mode of cli packages by adding a json file as saving point

# Context: 

This is a the codebase of a saas
This hole thing is all about helping the my clients to generate scrapping bee extract rules with the help of AI.

The main prompts are in @web_scrapper_generator/lib/src/prompts.dart (check this for better context)
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
Currently, this literally just does not work. For some reasons:
- When trying to use gemini, it literally NEVER returns a response and there is nothing to be done to resolve the error since the error is a recent known issue that the gemini devs still need to fix: https://github.com/google-gemini/gemini-cli/issues/7851 - there is literally nothing we can do until they fix this issue, so the schema is totally broken since the error in interal in gemini cli code
- When trying to use codex I receive a error because it can not cast the response - this is because the essense/core of codex does not allow to do prompt engineering and ask it to return a schema (it does not return in a json style, it allmost every return other texts with it - example: it returns "[2025-09-16T00:58:43] codex" and it also prints previous responses before the json model response). And by the end, it allways returns "Invalid response: missing responseType field"
- Claude code to be honest I did not test if it is working, but to maintain the max similarity between 3 packages I will wan't to do this modification as well (even if I am not using it in this moment, I may use it in the future).

# Fix proposal
I wan't to modify all 3 packages to do the following:
For all packages, we will change the function that runs with schemas. 
The flow will be, in a short: 
1. The sdk will create a temporary json file (with .json sufiix) in the directly that is running
2. That json file will have a random uuid as name so they don't conflit with each other. That file name will be saved in the chat model
3. Use prompt engineering and ask the ai to save in that json file (pass the file path, with the special indicators to indicate it is a file - ex: in claude code a file indicator starts with "@" and ends with "/")
4. After the ai ends, you can read that json file. If it is with errors and does not parse to a json, ask the ai to try again and attach the error log. Do something close to whats currently already is beeing done with _parseSchemaResponse in @gemini_cli_sdk/lib/src/gemini_chat.dart and also in @claude_code_sdk/lib/src/claude_chat.dart (yes, the same function with the same purpose exists on both). So there will be two types of retry: One retry is if the json has a error - you can call this function _parseJsonContent and if it fails it will ask ai to see because there are a error in it (maybe the ai added a "," where it shouldn't or someting like that) - then, there will be the second parse function that is the _parseSchemaResponse itself that already exists, so it will try to parse the json content into the schema the user intented it to be - yes, you will need to make a refactor to garantee that the fields that are not nullable are all present and in the correct variable type - this is a thing we currently do not do but we should start to do. By the way, for both flow try 2 attempts instead of only 1 like is currently done in _parseSchemaResponse where it only retryies one time.
5. Delete the temporary file that you created only for this (make sure to put every thing in a try catch and make the remove happend even if there was a problem with generating with ai, so we don't leave any "trash file" in the repository). We will create and delete it by the end in every iteration the user uses a schema.

Ps: the _parseSchemaResponse does not exist in @codex_cli_sdk/ , create it will be more similar to the gemini and claude code packages... Are goal here is to mantain them the most similar as possible - do that before even starting to do the rest so then all packages will part from the same point where a _parseSchemaResponse exists in each package. Lets aim to make the implementations in all package the closest as possible. Of course, 100% fidelity is not possible since each package has its own way of doing things, but lets try to make common logic the clossest as possible.

Ps: we should modify to garantee that the schema is allways initially a object (maybe it is already this way, im not sure - just ensure it is allways a json since the temporary file is a json).

Ps: Make sure to create a good prompt - web research for references of how to make good prompt engeniring so you correctly guide it to add the schema json it that file. Make sure AI understands it should not return that schema in its response, it should only write that schema and his response can be a resume of what he did and a resume of its thinking process, etc...

# New "sendMessageWithSchema" response
All chats, e.g  @claude_code_sdk/lib/src/claude_chat.dart - @gemini_cli_sdk/lib/src/gemini_chat.dart and codex_cli_sdk/lib/src/codex_chat.dart , have the sendMessageWithSchema function and it will change.

Now, it will be more close to "Future<({String llmMessage, Map<String, dynamic> structuredSchemaData})> sendMessageWithSchema( ... )"
And its usage will be something close to: "final (:String llmMessage, :Map<String, dynamic> structuredSchemaData) = await chat.sendMessageWithSchema( ... );" (add this usage in readme's files of the package).

Using records will be a more elegant way or returning responses.
The llm message will be whatever the llm says after it ends - normally it is a text, something like "Generated with success the json you asked for!" - anyway, does not mater just show whatever the llm says (tell it to make a general resume of what it did by the end, that would be cool).

Now, with this new approach a brand new possibility is opened: Create a streamResponseWithSchema.
So, while the llm is thinking we will stream everything and by the end it will send the map response by a completer (maybe?).
A example of function declaration could be something like:
"({Stream<String> llmMessage, Completer<Map<String, dynamic>> structuredSchemaData}) streamResponseWithSchema( ... )"
And the usage could be something like:
"final (:Stream<String> llmMessage, :Completer<Map<String, dynamic>> structuredSchemaData) = chat.streamResponseWithSchema(...);"


# Final considerations
This will fundamentally change how packages schema are used, this is a breaking change. So don't forget to update the version on yaml, the change log and the readme file. Also, fell free to web research for detailed information about specific package implementation (mainly to use the correct nomeclature to refer to a file in each cli package. Claude code uses "@" in the start, but other packages can use different things). 

Some configurations will need to be done in the @zenscrap_server/ since it uses the generation feature of @web_scrapper_generator/ - garantee that the migration is done there as well
Btw, if you need to generate serverpod files, use the command "serverpod generate --experimental-features=all". It need to have that flag because I am using some experimental-features...

YOU SHOULD check for static analysis error in each file and in @web_scrapper_generator/ , @zenscrap_flutter/ and @@zenscrap_server/ folder as well. Garantee there a are no errors in the repository as a hole after the fix.

YOU SHOULD make the max possible that all benchmark tests pass. Yes, I created tests so you can test, after all the fixes, if they are working (currently none of them work for the reaons I mentioned previosly in the prompt). The tests are, for each model;
- @web_scrapper_generator/test/end_to_end_tests_per_model/codex_web_scrapper_generator_test.dart 
- @web_scrapper_generator/test/end_to_end_tests_per_model/claude_code_web_scrapper_test.dart 
- @web_scrapper_generator/test/end_to_end_tests_per_model/gemini_cli_web_scrapper_test.dart 

Ultra think to do this task - is is VERY COMPLEX and envolves a lot of testing to make it work - do not rush and take your time - do with calm all web researchs that you need and think for the max as possible.
*/
