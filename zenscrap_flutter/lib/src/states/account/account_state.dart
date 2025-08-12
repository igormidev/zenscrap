import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zenscrap_client/zenscrap_client.dart';

part 'account_state.freezed.dart';

@freezed
abstract class AccountState with _$AccountState {
  factory AccountState.initial() = _AccountStateWithInitial;
  factory AccountState.loading() = _AccountStateLoading;
  factory AccountState.withError({
    required ZenScrapException exception,
  }) = _AccountStateWithError;
  factory AccountState.withData({
    required AccountInfo accountInfo,
  }) = AccountStateWithData;
}
