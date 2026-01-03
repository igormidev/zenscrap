// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/states/account/account_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/dashboard_view.dart';

class DeployButton extends ConsumerStatefulWidget {
  final int scrappableId;
  final ReferenceTestData? testData;
  final ScrappingBeeExtractLogic? scrappingBeeExtractLogic;
  final ScrappableRequest? scrappableRequest;
  const DeployButton({
    super.key,
    required this.scrappableId,
    required this.testData,
    required this.scrappingBeeExtractLogic,
    required this.scrappableRequest,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeployButtonState();
}

class _DeployButtonState extends ConsumerState<DeployButton> {
  final ValueNotifier<bool> _isDeployingVN = ValueNotifier(false);

  @override
  void dispose() {
    _isDeployingVN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isChatLoading = ref.watch(isChatLoadingProvider);
    final isLoggedIn =
        ref.watch(sessionProvider.select((value) => value.maybeMap(
              orElse: () => true,
              notSignedIn: (_) => false,
            )));
    return Tooltip(
      message: l10n.scrap_session_deploy_tooltip,
      child: ValueListenableBuilder(
          valueListenable: _isDeployingVN,
          builder: (context, isDeploying, child) {
            return FilledButton.icon(
              onPressed: isChatLoading ||
                      isDeploying ||
                      widget.testData == null ||
                      widget.scrappableRequest == null ||
                      widget.scrappingBeeExtractLogic == null
                  ? null
                  : () async {
                      final analytics = ref.read(analyticsServiceProvider);

                      // Get message count for tracking
                      final messageCount =
                          ref.read(scrapChatProvider).mapOrNull(
                                    standard: (state) =>
                                        0, // Count not available
                                  ) ??
                              0;

                      // Track deploy attempt
                      await analytics.trackScrappableDeployAttempt(
                        scrappableId: widget.scrappableId,
                        messageCount: messageCount,
                        isAuthenticated: isLoggedIn,
                      );

                      await ref.globalLoadingSetter(() async {
                        try {
                          _isDeployingVN.value = true;
                          await Future.delayed(
                              const Duration(milliseconds: 400));

                          final deployResult = await ref
                              .read(scrapChatProvider.notifier)
                              .commitCurrentChanges();

                          deployResult.fold(
                            (_) async {
                              // Track deploy success
                              await analytics.trackScrappableDeploySuccess(
                                scrappableId: widget.scrappableId,
                                messageCount: messageCount,
                              );

                              if (isLoggedIn) {
                                if (context.canPop()) {
                                  context.pop(true);
                                } else {
                                  context.go(DashboardNavigationType
                                      .userEndpoints.routeOnClick!);
                                }
                              } else {
                                // Track unauthenticated attempt
                                await analytics
                                    .trackScrappableDeployUnauthenticatedAttempt(
                                  scrappableId: widget.scrappableId,
                                );

                                _isDeployingVN.value = false;
                                ref
                                        .read(accountProvider.notifier)
                                        .scrappableIdToBeAttached =
                                    widget.scrappableId;
                                unawaited(context.push('/auth'));
                              }
                            },
                            (failure) {
                              // Track deploy failure
                              analytics.trackScrappableDeployFailure(
                                scrappableId: widget.scrappableId,
                                errorMessage: failure.toString(),
                              );

                              handleBabelException(context, failure);
                            },
                          );
                        } finally {
                          _isDeployingVN.value = false;
                        }
                      });
                    },
              label: Text(l10n.scrap_session_deploy_endpoint),
              iconAlignment: IconAlignment.end,
              icon: isDeploying
                  ? CupertinoActivityIndicator()
                  : Icon(Icons.rocket),
            );
          }),
    );
  }
}
