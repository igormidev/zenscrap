import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';

class DeployButton extends ConsumerWidget {
  const DeployButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChatLoading = ref.watch(isChatLoadingProvider);
    return Tooltip(
      message:
          'Continue to edit/use this scrappable\nendpoint by deploying it!',
      child: FilledButton.icon(
        onPressed: isChatLoading
            ? null
            : () async {
                await context.push('/auth');
              },
        label: Text('DEPLOY ENDPOINT'),
        iconAlignment: IconAlignment.end,
        icon: Icon(Icons.rocket),
      ),
    );
  }
}
