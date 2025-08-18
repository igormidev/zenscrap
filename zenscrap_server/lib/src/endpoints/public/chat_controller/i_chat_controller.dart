import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:zenscrap_server/src/generated/protocol.dart';

abstract class IChatController {
  Future<void> sendMessage({
    required Session session,
    required String userPromt,
    required,
    required ReferenceTestData referenceTestData,
    required StreamController<ChatResponse> chatSeason,
  });
}
