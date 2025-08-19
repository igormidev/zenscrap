import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'scrap_chat_session_state.freezed.dart';

@freezed
abstract class ScrapChatSessionState with _$ScrapChatSessionState {
  factory ScrapChatSessionState.blank() = _ScrapChatSessionStateBlank;
  factory ScrapChatSessionState.creatingSessionState() =
      _ScrapChatSessionStateCreatingSessionState;
  factory ScrapChatSessionState.standard({
    required Scrappable data,
    required DateTime testExpirationDate,
    required String sessionUuid,
  }) = _ScrapChatSessionStateStandard;
  factory ScrapChatSessionState.withError({required ZenScrapException error}) =
      _ScrapChatSessionStateWithError;
}
