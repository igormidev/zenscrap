import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/scrappables/user_scrappables_state.dart';

final userScrappables =
    StateNotifierProvider<UserScrappablesNotifier, UserScrappablesState>(
        UserScrappablesNotifier.new);

class UserScrappablesNotifier extends StateNotifier<UserScrappablesState> {
  final Ref ref;
  UserScrappablesNotifier(this.ref) : super(UserScrappablesState.initial());

  Future<void> getScrappables() async {
    state = UserScrappablesState.loading();
    final result =
        await ref.read(clientProvider).privateUserScrappables().toResult;
    result.fold((scrappables) {
      state = UserScrappablesState.withData(scrappables: scrappables);
    }, (error) {
      state = UserScrappablesState.withError(error: error);
    });
  }
}
