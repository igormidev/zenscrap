import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';

final accountProvider =
    StateNotifierProvider<AccountStateNotifier, AccountState>((ref) {
  return AccountStateNotifier(ref);
});

class AccountStateNotifier extends StateNotifier<AccountState> {
  AccountStateNotifier(this.ref) : super(AccountState.initial());
  final Ref ref;

  void logOut() async {
    state = AccountState.initial();
  }

  Future<void> getAccountInfo({bool force = false}) async {
    final isAlreadyWithData = state.maybeWhen(
      withData: (_) => true,
      orElse: () => false,
    );
    if (isAlreadyWithData && force == false) {
      return;
    }

    state = AccountState.loading();

    final scrappable = ref.read(scrapChatProvider).mapOrNull(
          standard: (value) => value.data,
        );
    final result = await ref
        .read(clientProvider)
        .privateAccount
        .getAccountInfo(
          initialScrappableIfNewUser: scrappable,
        )
        .toResult;

    result.fold(
      (accountInfo) {
        state = AccountState.withData(accountInfo: accountInfo);
      },
      (failure) {
        state = AccountState.withError(exception: failure);
      },
    );
  }

  Future<AccountInfo> getUser() async {
    return await ref
        .read(clientProvider)
        .privateAccount
        .getAccountInfo(initialScrappableIfNewUser: null);
  }

  void setUser(AccountInfo accountInfo) {
    state = AccountState.withData(accountInfo: accountInfo);
  }
}
