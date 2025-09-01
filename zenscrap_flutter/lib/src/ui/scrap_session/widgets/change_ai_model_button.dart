import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/ai_models_extensions.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';

class ChangeAiModelButton extends ConsumerStatefulWidget {
  const ChangeAiModelButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeAiModelButtonState();
}

class _ChangeAiModelButtonState extends ConsumerState<ChangeAiModelButton> {
  final ValueNotifier<bool> _isChangingVN = ValueNotifier(false);
  AiModel aiModel = AiModel.gemini_2_5_flash;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _isChangingVN,
        builder: (context, isChanging, child) {
          return TextButton.icon(
            onPressed: isChanging
                ? null
                : () {
                    // Todo implement change logic...
                  },
            label: Text(aiModel.displayName),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.secondary,
              padding: EdgeInsets.zero,
              iconAlignment: IconAlignment.end,
            ),
            icon: isChanging
                ? CupertinoActivityIndicator()
                : Icon(Icons.keyboard_arrow_down),
          );
        });
  }

  Future<void> _changeModel(AiModel aiModel) async {
    final sessionUuid = ref
        .read(scrapChatProvider)
        .mapOrNull(standard: (value) => value.sessionUuid);
    if (sessionUuid == null) return;

    await ref.globalLoadingSetter(() async {
      _isChangingVN.value = true;
      await Future.delayed(const Duration(milliseconds: 600));
      final changeResult = await ref
          .read(clientProvider)
          .scrappableChatSession
          .changeChatModel(sessionUuid: sessionUuid, aiModel: aiModel)
          .toResult;
      _isChangingVN.value = false;

      changeResult.fold((_) {
        if (mounted) {
          setState(() {
            this.aiModel = aiModel;
          });
        }
      }, (failure) {
        handleBabelException(context, failure);
      });
    });
  }
}
