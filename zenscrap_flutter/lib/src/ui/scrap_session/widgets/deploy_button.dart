import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';

class DeployButton extends ConsumerWidget {
  const DeployButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChatLoading = ref.watch(isChatLoadingProvider);
    final isLoggedIn =
        ref.watch(sessionProvider.select((value) => value.maybeMap(
              orElse: () => true,
              notSignedIn: (_) => false,
            )));
    return Tooltip(
      message:
          'Continue to edit/use this scrappable\nendpoint by deploying it!',
      child: FilledButton.icon(
        onPressed: isChatLoading
            ? null
            : () async {
                if (isLoggedIn) {
                  context.pop(true);
                } else {}
                await context.push('/auth');
              },
        label: Text(isLoggedIn ? 'FINISH EDITS' : 'DEPLOY ENDPOINT'),
        iconAlignment: isLoggedIn ? IconAlignment.start : IconAlignment.end,
        icon: Icon(isLoggedIn ? Icons.save : Icons.rocket),
      ),
    );
  }
}
