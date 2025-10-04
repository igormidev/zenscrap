import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

abstract class IChatController {
  final int scrappableId;
  const IChatController({required this.scrappableId});

  Future<void> changeModel(AiModel aiModel);

  Future<void> sendMessage({
    required Session session,
    required String userPrompt,
    required ReferenceTestData referenceTestData,
    required ScrappableRequest scrapperRequest,
    required ScrappingBeeExtractLogic? scrappingBeeExtractLogic,
    required StreamController<ChatResponse> chatSeason,
    required StreamController<String> thinkingStream,
  });
}
