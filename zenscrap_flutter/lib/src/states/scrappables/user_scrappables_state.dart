import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'user_scrappables_state.freezed.dart';


@freezed
abstract class UserScrappablesState with _$UserScrappablesState {
  factory UserScrappablesState.initial() = _UserScrappablesListageInitial;
  factory UserScrappablesState.loading({
    UserPaginatedScrappableResponse? response,
    @Default('') String searchQuery,
    @Default({}) Set<ScraperCategory> selectedCategories,
  }) = _UserScrappablesListageLoading;
  factory UserScrappablesState.withError({
    required ZenScrapException error,
    UserPaginatedScrappableResponse? response,
    @Default('') String searchQuery,
    @Default({}) Set<ScraperCategory> selectedCategories,
  }) = _UserScrappablesListageWithError;
  factory UserScrappablesState.withData({
    required UserPaginatedScrappableResponse response,
    required String searchQuery,
    required Set<ScraperCategory> selectedCategories,
  }) = _UserScrappablesListageWithData;
}
