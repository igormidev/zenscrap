import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'marketplace_state.freezed.dart';

@freezed
class MarketplaceState with _$MarketplaceState {
  const factory MarketplaceState.initial() = _Initial;
  const factory MarketplaceState.loading() = _Loading;
  const factory MarketplaceState.loaded({
    required PaginatedScrappableResponse response,
    required String searchQuery,
  }) = _Loaded;
  const factory MarketplaceState.withError(
    ZenScrapException error,
  ) = _WithError;
}