import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'package:web_scrapper_generator/web_scrapper_generator.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ChatControllerGeminiSdkImpl extends IChatController
    with ChatControllerHandlerMixin {
  final WebScrapperGeminiImpl controller;
  const ChatControllerGeminiSdkImpl._({required this.controller});

  factory ChatControllerGeminiSdkImpl.startChat({
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
  }) {
    final webScrapperRequest = WebScrapperRequest(
      url: scrapperRequest.url,
      pathParams: scrapperRequest.pathParams,
      queryParam: scrapperRequest.queryParams,
    );
    final controller = WebScrapperGeminiImpl.startChat(
      initialPayload: InitialPayloadDataCreatingFromZero(
        targetExampleUrl: referenceTestData.referenceLinkUsed,
        webScrapperRequest: webScrapperRequest,
      ),
      model: GeminiModel.gemini25Flash,
    );

    return ChatControllerGeminiSdkImpl._(controller: controller);
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
      session.log('Error occurred while generating extract rules with Gemini',
          exception: error, stackTrace: stackTrace, level: LogLevel.error);
      chatSeason.add(ErrorTextResponse(
        role: PromptRole.system,
        errorMessage:
            '[ FATAL ]\nAn internal error occurred while generating extract rules:\n$error',
      ));
    }
  }


  @override
  Future<void> changeModel(AiModel aiModel) {
    return controller.changeModel(switch (aiModel) {
      AiModel.normal => GeminiModel.gemini25Flash,
      AiModel.powerful => GeminiModel.gemini25Pro,
    });
  }
}
