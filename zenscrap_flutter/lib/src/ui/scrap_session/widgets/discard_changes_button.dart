import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_messages_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';

class DiscardChangesButton extends ConsumerStatefulWidget {
  const DiscardChangesButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DiscardChangesButtonState();
}

class _DiscardChangesButtonState extends ConsumerState<DiscardChangesButton> {
  final ValueNotifier<bool> _isDiscardingVN = ValueNotifier(false);
  @override
  void dispose() {
    _isDiscardingVN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        ref.watch(sessionProvider.select((value) => value.maybeMap(
              orElse: () => true,
              notSignedIn: (_) => false,
            )));
    if (!isLoggedIn) {
      return SizedBox.shrink();
    }
    final bool hasAtLeastOneMessage = ref.watch(chatMessagesProvider.select(
      (value) => value.maybeMap(
        data: (data) => data.value.isNotEmpty,
        orElse: () => false,
      ),
    ));
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 32,
        margin: const EdgeInsets.only(top: 10, left: 20),
        child: ValueListenableBuilder(
            valueListenable: _isDiscardingVN,
            builder: (context, isDiscarding, child) {
              return FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  backgroundColor: hasAtLeastOneMessage
                      ? context.c.errorContainer
                      : context.c.surfaceContainerHighest,
                  foregroundColor: hasAtLeastOneMessage
                      ? context.c.onErrorContainer
                      : context.c.onSurfaceVariant,
                ),
                onPressed: isDiscarding
                    ? null
                    : () async {
                        if (hasAtLeastOneMessage) {
                          return context.pop(true);
                        }
                        await ref.globalLoadingSetter(() async {
                          _isDiscardingVN.value = true;
                          try {
                            await ref
                                .read(scrapChatProvider.notifier)
                                .endSession();
                          } catch (_) {}
                          _isDiscardingVN.value = false;
                        });

                        // ignore: use_build_context_synchronously
                        return context.pop(true);
                      },
                label:
                    Text(hasAtLeastOneMessage ? 'Discard changes' : 'Go back'),
                icon: isDiscarding
                    ? CupertinoActivityIndicator()
                    : Icon(
                        hasAtLeastOneMessage ? Icons.delete : Icons.arrow_back),
              );
            }),
      ),
    );
  }
}
