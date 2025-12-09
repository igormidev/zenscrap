import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'auto_fix_sessions_state.freezed.dart';

@freezed
class AutoFixSessionsState with _$AutoFixSessionsState {
  const factory AutoFixSessionsState.initial() = _Initial;
  const factory AutoFixSessionsState.loading() = _Loading;
  const factory AutoFixSessionsState.loaded({
    required List<AutoFixSession> sessions,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = _Loaded;
  const factory AutoFixSessionsState.withError(
    ZenScrapException error,
  ) = _WithError;
}
