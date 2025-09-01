import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
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
            return TapRegion(
              onTapOutside: showDropdown
                  ? (_) {
                      _showDropdownVN.value = false;
                    }
                  : null,
              child: PortalTarget(
                visible: showDropdown,
                portalFollower: _AiModelDropdownMenu(
                  currentModel: aiModel,
                  onModelSelected: (model) {
                    _showDropdownVN.value = false;
                    _validateAndChangeModel(model);
                  },
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
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _validateAndChangeModel(AiModel aiModel) async {
    // Check if user is logged in
    final isLoggedIn =
        ref.read(sessionProvider.select((value) => value.maybeMap(
              orElse: () => true,
              notSignedIn: (_) => false,
            )));

    // If selecting Gemini 2.5 Pro and not logged in
    if (aiModel == AiModel.gemini_2_5_pro && !isLoggedIn) {
      await _showSignInDialog();
      return;
    }

    // If logged in and selecting Gemini 2.5 Pro, check plan
    if (aiModel == AiModel.gemini_2_5_pro && isLoggedIn) {
      final accountState = ref.read(accountProvider);
      final planTier = accountState.maybeWhen(
        withData: (accountInfo) => accountInfo.planTier,
        orElse: () => PlanTier.none,
      );

      // Check if user has at least Pro plan
      if (planTier == PlanTier.none || planTier == PlanTier.basic) {
        await showProPlanUpgradeDialog(
          context,
          mainCTAText:
              'Unlock access to Gemini 2.5 Pro for superior extraction accuracy and better understanding of complex web pages. Perfect for advanced scraping needs.',
        );
        return;
      }
    }

    // Proceed with model change
    await _changeModel(aiModel);
  }

  Future<void> _showSignInDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.account_circle_rounded,
          size: 48,
          color: context.c.primary,
        ),
        title: const Text('Sign In Required'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sign in to unlock powerful features:',
                style: context.t.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _SignInBenefit(
                icon: Icons.psychology_rounded,
                title: 'Advanced AI Models',
                description: 'Access Gemini 2.5 Pro and other premium models',
              ),
              const SizedBox(height: 12),
              _SignInBenefit(
                icon: Icons.timer_off_rounded,
                title: 'No Time Limits',
                description: 'Endpoints never expire with a subscription',
              ),
              const SizedBox(height: 12),
              _SignInBenefit(
                icon: Icons.api_rounded,
                title: 'More API Calls',
                description: 'Get thousands of API calls per month',
              ),
              const SizedBox(height: 12),
              _SignInBenefit(
                icon: Icons.hub_rounded,
                title: 'Multiple Endpoints',
                description: 'Create and manage multiple scraping endpoints',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Maybe Later'),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await context.push('/auth');
            },
            icon: const Icon(Icons.login_rounded),
            label: const Text('Sign In'),
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
        showSnackbar(
            context, '✅ Scrap AI model changed to ${aiModel.displayName}');
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
