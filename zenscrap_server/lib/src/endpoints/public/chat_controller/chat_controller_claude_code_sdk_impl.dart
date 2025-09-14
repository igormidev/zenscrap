import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:web_scrapper_generator/web_scrapper_generator.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ChatControllerClaudeCodeSdkImpl extends IChatController
    with ChatControllerHandlerMixin {
  final WebScrapperClaudeImpl controller;
  const ChatControllerClaudeCodeSdkImpl._({required this.controller});

  factory ChatControllerClaudeCodeSdkImpl.startChat({
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    ClaudeModel model = ClaudeModel.claudeSonnet4,
  }) {
    final webScrapperRequest = WebScrapperRequest(
      url: scrapperRequest.url,
      pathParams: scrapperRequest.pathParams,
      queryParam: scrapperRequest.queryParams,
    );
    final controller = WebScrapperClaudeImpl.startChat(
      initialPayload: InitialPayloadDataCreatingFromZero(
        targetExampleUrl: referenceTestData.referenceLinkUsed,
        webScrapperRequest: webScrapperRequest,
      ),
      model: model,
    );

    return ChatControllerClaudeCodeSdkImpl._(controller: controller);
  }

  @override
  Future<void> sendMessage({
    required Session session,
    required String userPrompt,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    required StreamController<ChatResponse> chatSeason,
  }) async {
    try {
      const int maxAttempts = 3;
      int attempt = 0;
      RetryText? retryContent;

      while (attempt < maxAttempts) {
        attempt++;

        session.log('Starting attempt #$attempt');

        final WebScrapperChatAIResponse response =
            await controller.sendMessage(userPrompt: userPrompt);
        session.log('Ending attempt #$attempt');

        retryContent = await handleSendMessage(
          session: session,
          response: response,
          referenceTestData: referenceTestData,
          scrapperRequest: scrapperRequest,
          currentScrappingBeeExtractLogic: scrappingBeeExtractLogic,
          chatSeason: chatSeason,
          attemptNumber: attempt,
        );

        if (retryContent == null) {
          // No retry needed, exit the loop
          return;
        }
      }
    } catch (error, stackTrace) {
      session.log('Error occurred while generating extract rules with Claude',
          exception: error, stackTrace: stackTrace, level: LogLevel.error);
      chatSeason.add(ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            '[ FATAL ]\nAn internal error occurred while generating extract rules:\n$error',
      ));
    }
  }


  @override
  Future<void> changeModel(AiModel aiModel) async {
    // Claude doesn't support changing models mid-conversation in the same way as Gemini
    // For now, we'll map the Gemini models to appropriate Claude models
    final claudeModel = switch (aiModel) {
      AiModel.gemini_2_5_flash => ClaudeModel.claude35Haiku, // Fast model
      AiModel.gemini_2_5_pro => ClaudeModel.claudeSonnet4,  // Latest balanced model
    };

    await controller.changeModel(claudeModel);

    // Note: This would require creating a new chat session with Claude
    // The controller.changeModel method should handle this appropriately
  }
}