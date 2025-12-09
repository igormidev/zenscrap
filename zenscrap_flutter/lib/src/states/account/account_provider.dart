import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';

/// Notifier for managing account state.
/// Migrated from StateNotifierProvider to NotifierProvider for Riverpod 3.0.
class AccountStateNotifier extends Notifier<AccountState> {
  int? scrappableIdToBeAttached;

  @override
  AccountState build() => AccountState.initial();

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

    final scrappable = ref.read(scrapChatProvider).maybeMap(
          standard: (value) => value.data,
          orElse: () => null,
        );

    final scrappableId = scrappable?.id ?? scrappableIdToBeAttached;
    final result = await ref
        .read(clientProvider)
        .privateAccount
        .getAccountInfo(initialScrappableId: scrappableId)
        .toResult;

    await result.fold(
      (accountInfo) async {
        await ref.read(scrapChatProvider.notifier).endSession();
        scrappableIdToBeAttached = null;
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
        .getAccountInfo(initialScrappableId: null);
  }

  void setUser(AccountInfo accountInfo) {
    state = AccountState.withData(accountInfo: accountInfo);
  }
}

final accountProvider =
    NotifierProvider<AccountStateNotifier, AccountState>(AccountStateNotifier.new);
