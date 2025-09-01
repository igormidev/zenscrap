import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/ai_models_extensions.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
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
  final ValueNotifier<bool> _showDropdownVN = ValueNotifier(false);
  AiModel aiModel = AiModel.gemini_2_5_flash;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isChangingVN,
      builder: (context, isChanging, child) {
        return ValueListenableBuilder(
          valueListenable: _showDropdownVN,
          builder: (context, showDropdown, child) {
            return PortalTarget(
              visible: showDropdown,
              portalFollower: TapRegion(
                onTapOutside: (_) {
                  _showDropdownVN.value = false;
                },
                child: _buildDropdownMenu(context),
              ),
              anchor: const Aligned(
                follower: Alignment.bottomRight,
                target: Alignment.topRight,
                offset: Offset(8, 0),
              ),
              child: TextButton.icon(
                onPressed: isChanging
                    ? null
                    : () {
                        _showDropdownVN.value = !_showDropdownVN.value;
                      },
                label: Text(aiModel.displayName),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.zero,
                  iconAlignment: IconAlignment.end,
                ),
                icon: isChanging
                    ? CupertinoActivityIndicator()
                    : Icon(
                        showDropdown
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownMenu(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final availableModels = AiModel.values;

    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: colorScheme.surface,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 280,
          maxWidth: 320,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withAlpha(51),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final model in availableModels)
                InkWell(
                  onTap: () {
                    _showDropdownVN.value = false;
                    _changeModel(model);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: model == aiModel
                          ? colorScheme.primary.withAlpha(25)
                          : null,
                      border: Border(
                        bottom: model != availableModels.last
                            ? BorderSide(
                                color: colorScheme.outline.withAlpha(25),
                                width: 1,
                              )
                            : BorderSide.none,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    model.displayName,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: model == aiModel
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: model == aiModel
                                          ? colorScheme.primary
                                          : colorScheme.onSurface,
                                    ),
                                  ),
                                  if (model == aiModel) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Current',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                model.briefDescription,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (model == aiModel)
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeModel(AiModel aiModel) async {
    if (aiModel == this.aiModel) return;
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
        showSnackbar(
            context, '✅ Scrap AI model changed to ${aiModel.displayName}');
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
