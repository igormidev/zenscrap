import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/elements/ip_limit_error_view.dart';
import 'package:zenscrap_flutter/src/design_system/elements/suspicious_ip_error_view.dart';
import 'package:zenscrap_flutter/src/design_system/elements/zen_tab.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_state.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/fullscreen_loading_page.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/pages/initial_chat_page.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/view/scrappable_edit_session.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/creating_scrappable_dialog.dart';

class InitialChatView extends ConsumerStatefulWidget {
  final int? scrappableId;
  const InitialChatView({
    super.key,
    required this.scrappableId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InitialChatViewState();
}

class _InitialChatViewState extends ConsumerState<InitialChatView> {
  final Completer<void> _initializationCompleter = Completer<void>();
  bool _isCreatingDialogShowing = false;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (widget.scrappableId != null) {
      unawaited(ref.read(scrapChatProvider.notifier).endSession());
      Future.delayed(const Duration(seconds: 3), () async {
        await ref
            .read(scrapChatProvider.notifier)
            .createSessionWithScrappableId(widget.scrappableId!);
        _initializationCompleter.complete();
      });
    } else {
      _initializationCompleter.complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ScrapChatSessionState scrapChatState = ref.watch(scrapChatProvider);

    // Listen for state changes to show/hide the creating scrappable dialog
    ref.listen(scrapChatProvider, (previous, next) {
      final isCreating = next.maybeWhen(
        creatingScrappable: (referenceLink, chunks, grounding) => true,
        orElse: () => false,
      );

      if (isCreating && !_isCreatingDialogShowing) {
        _isCreatingDialogShowing = true;
        CreatingScrappableDialog.show(context).then((_) {
          _isCreatingDialogShowing = false;
        });
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: FutureBuilder(
          future: _initializationCompleter.future,
          builder: (context, asyncSnapshot) {
            final isLoading =
                asyncSnapshot.connectionState == ConnectionState.waiting;
            if (isLoading) {
              final l10n = AppLocalizations.of(context)!;
              return FullpageLoadingPage(
                loadingMessage: l10n.scrap_session_creating_session,
              );
            }

            return scrapChatState.maybeWhen(
              withError: (exception) {
                // Check if this is an IP limit error
                if (exception.title == 'Usage Limit Reached') {
                  return IpLimitErrorView(exception: exception);
                }
                // Check if this is a suspicious IP error
                if (exception.title == 'Suspicious Connection Detected') {
                  return SuspiciousIpErrorView(exception: exception);
                }
                // Default error handling for other errors
                return ZenErrorTab(exception);
              },
              standard: (
                Scrappable scrappable,
                DateTime testExpirationDate,
                String sessionUuid,
                List<String>? llmThinkingStream,
              ) {
                return ScrappableEditSessionView(
                  testExpirationDate: testExpirationDate,
                  scrappable: scrappable,
                  llmThinkingStream: llmThinkingStream,
                );
              },
              // For blank, creatingSessionState, and creatingScrappable states
              // Show the initial chat page (dialog will show on top for creatingScrappable)
              orElse: () => InitialChatPage(),
            );
          },
        ),
      ),
    );
  }
}
