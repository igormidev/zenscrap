import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';

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
    final result =
        await ref.read(clientProvider).privateAccount.getAccountInfo().toResult;

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
    return await ref.read(clientProvider).privateAccount.getAccountInfo();
  }

  void setUser(AccountInfo accountInfo) {
    state = AccountState.withData(accountInfo: accountInfo);
  }
}
