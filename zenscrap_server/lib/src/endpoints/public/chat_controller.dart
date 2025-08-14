import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

// final Map<RedraftSrappableSessionId, ChatSession> chatSessions = {};
class ChatController {
  static late final GenerativeModel _geminiModel;
  static void initialize(String geminiApiKey) {
    _geminiModel = GenerativeModel(
      model: 'gemini-2.5-pro',
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        responseSchema: generateExtractRulesSchema,
      ),
    );
  }

  ChatController._();

  late final ChatSession chatSession;
  static ChatController create() {
    final instance = ChatController._();
    instance.chatSession = _geminiModel.startChat();
    return instance;
  }

  Future<ChatResponse> sendMessage() {}
}

final Schema generateExtractRulesSchema = Schema(
  SchemaType.object,
  nullable: false,
  properties: {
    'message': Schema(
      SchemaType.string,
      nullable: true,
      description:
          '''Message from the AI assistant for better context for what was done.
This could be a quick short resume of what was done to generate the extraction rules or even a question for clarification (in case of questions, send the "dataJson" as null).

Better understanding of a question:
You can ask, for example, a question like: "I found two information about <something>, one in the the user header and the other in the footer, which one do you want to extract?".
In that case you are making a question, the "dataJson" field of the schema will be null (the "errorMessage" as well).
After the question, the user will give his response and you can then continue to process a extract rule.

This should be null if there is a errorMessage''',
    ),
    'errorMessage': Schema(
      SchemaType.string,
      nullable: true,
      description:
          '''Error message if there was an error during the generation process to get extract rules.
In the error message please explain what happened any why you where not able to complete the task.

Example things that could cause error:
- Example 1: The html is of a 404 page, you can respond with a message indicating that the page was not found.
- Example 2: The user provided invalid input, you can respond with a message asking them to correct it.

In any case that the errorMessage exists, the "dataJson" and "message" fields should be null.

This field should be null if there is no error.''',
    ),
    'dataJson': Schema(
      SchemaType.object,
      description:
          '''New extraction rules that are compliant with ScrapingBee extract rules feature.
If you have any doubts about how to generate the rules, you can web research the ScrapingBee documentation at "https://www.scrapingbee.com/documentation/data-extraction/#basic-usage".''',
    ),
  },
);
