import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/ai_models_extensions.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_state.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/dialogs/upgrade_plan_dialog.dart';

class ChangeAiModelButton extends ConsumerStatefulWidget {
  const ChangeAiModelButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangeAiModelButtonState();
}

class _ChangeAiModelButtonState extends ConsumerState<ChangeAiModelButton> {
  final ValueNotifier<bool> _isChangingVN = ValueNotifier(false);
  final OverlayPortalController _overlayController = OverlayPortalController();
  AiModel aiModel = AiModel.normal;

  @override
  void dispose() {
    _isChangingVN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isChangingVN,
      builder: (context, isChanging, child) {
        return OverlayPortal(
          controller: _overlayController,
          overlayChildBuilder: (BuildContext context) {
            return Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: TapRegion(
                onTapOutside: (_) {
                  _overlayController.hide();
                },
                child: Stack(
                  children: [
                    CompositedTransformFollower(
                      link: _layerLink,
                      targetAnchor: Alignment.topRight,
                      followerAnchor: Alignment.bottomRight,
                      offset: const Offset(8, 0),
                      child: _AiModelDropdownMenu(
                        currentModel: aiModel,
                        onModelSelected: (model) {
                          _overlayController.hide();
                          _validateAndChangeModel(model);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: CompositedTransformTarget(
            link: _layerLink,
            child: TextButton.icon(
              onPressed: isChanging
                  ? null
                  : () {
                      _overlayController.toggle();
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
                      _overlayController.isShowing
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
            ),
          ),
        );
      },
    );
  }

  final LayerLink _layerLink = LayerLink();

  Future<void> _validateAndChangeModel(AiModel aiModel) async {
    // Check if user is logged in
    final isLoggedIn =
        ref.read(sessionProvider.select((value) => value.maybeMap(
              orElse: () => true,
              notSignedIn: (_) => false,
            )));

    // If selecting Powerful model and not logged in
    if (aiModel == AiModel.powerful && !isLoggedIn) {
      await _showSignInDialog();
      return;
    }

    // If logged in and selecting Powerful model, check plan
    if (aiModel == AiModel.powerful && isLoggedIn) {
      final accountState = ref.read(accountProvider);
      final planTier = accountState.maybeWhen(
        withData: (accountInfo) => accountInfo.planTier,
        orElse: () => PlanTier.none,
      );

      // Check if user has at least Pro plan
      if (planTier == PlanTier.none || planTier == PlanTier.basic) {
        final l10n = AppLocalizations.of(context)!;
        await showProPlanUpgradeDialog(
          context,
          mainCTAText: l10n.scrap_session_powerful_model_upgrade,
        );
        return;
      }
    }

    // Proceed with model change
    await _changeModel(aiModel);
  }

  Future<void> _showSignInDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.account_circle_rounded,
          size: 48,
          color: context.c.primary,
        ),
        title: Text(l10n.scrap_session_sign_in_required),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.scrap_session_sign_in_unlock_features,
                style: context.t.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _SignInBenefit(
                icon: Icons.psychology_rounded,
                title: l10n.scrap_session_advanced_ai_models,
                description: l10n.scrap_session_advanced_ai_models_desc,
              ),
              const SizedBox(height: 12),
              _SignInBenefit(
                icon: Icons.timer_off_rounded,
                title: l10n.scrap_session_no_time_limits,
                description: l10n.scrap_session_no_time_limits_desc,
              ),
              const SizedBox(height: 12),
              _SignInBenefit(
                icon: Icons.api_rounded,
                title: l10n.scrap_session_more_api_credits,
                description: l10n.scrap_session_more_api_credits_desc,
              ),
              const SizedBox(height: 12),
              _SignInBenefit(
                icon: Icons.hub_rounded,
                title: l10n.scrap_session_multiple_endpoints,
                description: l10n.scrap_session_multiple_endpoints_desc,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.scrap_session_maybe_later),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await context.push('/auth');
            },
            icon: const Icon(Icons.login_rounded),
            label: Text(l10n.scrap_session_sign_in),
          ),
        ],
      ),
    );
  }

  Future<void> _changeModel(AiModel aiModel) async {
    if (aiModel == this.aiModel) return;
    final sessionUuid = ref
        .read(scrapChatProvider)
        .mapOrNull(standard: (value) => value.sessionUuid);
    if (sessionUuid == null) return;

    _isChangingVN.value = true;
    await ref.globalLoadingSetter(() async {
      await Future.delayed(const Duration(milliseconds: 600));
      final changeResult = await ref
          .read(clientProvider)
          .scrappableChatSession
          .changeChatModel(sessionUuid: sessionUuid, aiModel: aiModel)
          .toResult;
      _isChangingVN.value = false;

      if (!mounted) return;

      changeResult.fold((_) {
        setState(() {
          this.aiModel = aiModel;
        });
        final l10n = AppLocalizations.of(context)!;
        showSnackbar(
            context, l10n.scrap_session_model_changed(aiModel.displayName));
      }, (failure) {
        handleBabelException(context, failure);
      });
    });
  }
}

class _SignInBenefit extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _SignInBenefit({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.c.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 18,
            color: context.c.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.t.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: context.t.bodySmall?.copyWith(
                  color: context.c.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AiModelDropdownMenu extends StatelessWidget {
  final AiModel currentModel;
  final void Function(AiModel) onModelSelected;

  const _AiModelDropdownMenu({
    required this.currentModel,
    required this.onModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final availableModels = AiModel.values;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {}, // Consume taps to prevent TapRegion from closing
      child: Material(
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
                    onTap: () => onModelSelected(model),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: model == currentModel
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
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: model == currentModel
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: model == currentModel
                                            ? colorScheme.primary
                                            : colorScheme.onSurface,
                                      ),
                                    ),
                                    if (model == currentModel) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          l10n.scrap_session_current,
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
                          if (model == currentModel)
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
      ),
    );
  }
}
