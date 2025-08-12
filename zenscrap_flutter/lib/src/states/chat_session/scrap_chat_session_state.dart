import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'scrap_chat_session_state.freezed.dart';

@freezed
abstract class ScrapChatSessionState with _$ScrapChatSessionState {
  factory ScrapChatSessionState.initial() = _ScrapChatSessionStateInitial;
  factory ScrapChatSessionState.loading() = _ScrapChatSessionStateLoading;
  factory ScrapChatSessionState.withError({required ZenScrapException error}) =
      _ScrapChatSessionStateWithError;
  factory ScrapChatSessionState.withData({required Scrappable data}) =
      _ScrapChatSessionStateWithData;
}
