import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'user_scrappables_state.freezed.dart';

@freezed
abstract class UserScrappablesState with _$UserScrappablesState {
  factory UserScrappablesState.initial() = _UserScrappablesListageInitial;
  factory UserScrappablesState.loading() = _UserScrappablesListageLoading;
  factory UserScrappablesState.withError({
    required ZenScrapException error,
  }) = _UserScrappablesListageWithError;
  factory UserScrappablesState.withData({
    required List<Scrappable> scrappables,
  }) = _UserScrappablesListageWithData;
}
