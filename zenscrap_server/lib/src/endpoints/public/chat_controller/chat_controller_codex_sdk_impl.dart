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

  const ChatControllerCodexSdkImpl._({
    required this.controller,
    required super.scrappableId,
  });

  factory ChatControllerCodexSdkImpl.startChat({
    required int scrappableId,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? currentFetchSettings,
    CodexModel model = CodexModel.gpt5Mini,
  }) {
    final controller = WebScrapperCodexImpl.startChat(
      initialPayload: IChatController.getInitialPayloadDate(
        referenceTestData: referenceTestData,
        scrapperRequest: scrapperRequest,
        currentFetchSettings: currentFetchSettings,
      ),
    );

    return ChatControllerCodexSdkImpl._(
      controller: controller,
      scrappableId: scrappableId,
    );
  }

  @override
  Future<void> changeModel(AiModel aiModel) async {
    // Map the normal/powerful models to appropriate Codex models with high reasoning effort
    switch (aiModel) {
      case AiModel.normal:
        // GPT-5 Mini with high reasoning effort for fast and efficient performance
        await controller.changeModelWithEffort(CodexModel.gpt5Mini, 'high');
        break;
      case AiModel.powerful:
        // GPT-5 with high reasoning effort for maximum capability
        await controller.changeModelWithEffort(CodexModel.gpt5Codex, 'high');
        break;
    }
  }
}
