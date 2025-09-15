import 'package:web_scrapper_generator/web_scrapper_generator.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ChatControllerCodexSdkImpl extends IChatController
    with ChatControllerHandlerMixin {
  @override
  final WebScrapperCodexImpl controller;

  @override
  String get providerName => 'Codex';

  const ChatControllerCodexSdkImpl._({required this.controller});

  factory ChatControllerCodexSdkImpl.startChat({
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    CodexModel model = CodexModel.gptOss120b,
  }) {
    final webScrapperRequest = WebScrapperRequest(
      url: scrapperRequest.url,
      pathParams: scrapperRequest.pathParams,
      queryParam: scrapperRequest.queryParams,
    );
    final controller = WebScrapperCodexImpl.startChat(
      initialPayload: InitialPayloadDataCreatingFromZero(
        targetExampleUrl: referenceTestData.referenceLinkUsed,
        webScrapperRequest: webScrapperRequest,
      ),
      model: model,
    );

    return ChatControllerCodexSdkImpl._(controller: controller);
  }

  @override
  Future<void> changeModel(AiModel aiModel) async {
    // Map the normal/powerful models to appropriate Codex models
    switch (aiModel) {
      case AiModel.normal:
        // GPT-OSS-120B for balanced performance
        await controller.changeModel(CodexModel.gptOss120b);
        break;
      case AiModel.powerful:
        // GPT-5 for maximum capability
        await controller.changeModel(CodexModel.gpt5);
        break;
    }
  }
}
