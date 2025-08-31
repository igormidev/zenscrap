import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/extensions/serverpod_to_result.dart';
import 'package:zenscrap_flutter/src/design_system/default_error_snackbar.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/session/session_providers.dart';
import 'package:zenscrap_flutter/src/states/session/session_state.dart';
import 'package:zenscrap_flutter/src/ui/dashboard/views/scrappables_dashboard.dart';

class DeployButton extends ConsumerStatefulWidget {
  final ReferenceTestData testData;
  const DeployButton({
    super.key,
    required this.testData,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeployButtonState();
}

class _DeployButtonState extends ConsumerState<DeployButton> {
  final ValueNotifier<bool> _isDeployingVN = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final isChatLoading = ref.watch(isChatLoadingProvider);
    final isLoggedIn =
        ref.watch(sessionProvider.select((value) => value.maybeMap(
              orElse: () => true,
              notSignedIn: (_) => false,
            )));
    return Tooltip(
      message:
          'Continue to edit/use this scrappable\nendpoint by deploying it!',
      child: ValueListenableBuilder(
          valueListenable: _isDeployingVN,
          builder: (context, isDeploying, child) {
            return FilledButton.icon(
              onPressed: isChatLoading || isDeploying
                  ? null
                  : () async {
                      if (isLoggedIn) {
                        await ref.globalLoadingSetter(() async {
                          final deployResult = await ref
                              .read(clientProvider)
                              .deployScrappable(testData: widget.testData)
                              .toResult;

                          deployResult.fold(
                            (_) {
                              if (context.canPop()) {
                                context.pop(true);
                              } else {
                                context.go(DashboardNavigationType
                                    .userEndpoints.routeOnClick!);
                              }
                            },
                            (failure) {
                              handleBabelException(context, failure);
                            },
                          );
                        });
                      } else {
                        await context.push('/auth');
                      }
                    },
              label: Text('DEPLOY ENDPOINT'),
              iconAlignment: IconAlignment.end,
              icon: Icon(Icons.rocket),
            );
          }),
    );
  }
}
