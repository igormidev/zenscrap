import 'package:web_scrapper_generator/web_scrapper_generator.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ChatControllerGeminiSdkImpl extends IChatController
    with ChatControllerHandlerMixin {
  @override
  final WebScrapperGeminiImpl controller;

  @override
  String get providerName => 'Gemini';

  const ChatControllerGeminiSdkImpl._(
      {required this.controller, required super.scrappableId});

  factory ChatControllerGeminiSdkImpl.startChat({
    required int scrappableId,
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

    return ChatControllerGeminiSdkImpl._(
        controller: controller, scrappableId: scrappableId);
  }

  // The sendMessage method is now provided by ChatControllerHandlerMixin

  @override
  Future<void> changeModel(AiModel aiModel) {
    return controller.changeModel(switch (aiModel) {
      AiModel.normal => GeminiModel.gemini25Flash,
      AiModel.powerful => GeminiModel.gemini25Pro,
    });
  }
}
