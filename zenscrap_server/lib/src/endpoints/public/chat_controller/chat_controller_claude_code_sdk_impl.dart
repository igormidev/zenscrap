import 'package:web_scrapper_generator/web_scrapper_generator.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/chat_controller_handler_mixin.dart';
import 'package:zenscrap_server/src/endpoints/public/chat_controller/i_chat_controller.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

class ChatControllerClaudeCodeSdkImpl extends IChatController
    with ChatControllerHandlerMixin {
  @override
  final WebScrapperClaudeImpl controller;

  @override
  String get providerName => 'Claude';

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
  Future<void> changeModel(AiModel aiModel) async {
    // Map the normal/powerful models to appropriate Claude models
    final claudeModel = switch (aiModel) {
      AiModel.normal => ClaudeModel.claude35Haiku, // Fast model
      AiModel.powerful => ClaudeModel.claudeSonnet4, // Latest balanced model
    };

    await controller.changeModel(claudeModel);
  }
}
