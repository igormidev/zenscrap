import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/l10n/app_localizations.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';
import 'package:zenscrap_flutter/src/providers/posthog_provider.dart';
import 'package:zenscrap_flutter/src/providers/serverpod_providers.dart';
import 'package:zenscrap_flutter/src/ui/auth/widgets/incomplete_scrappable_warning_card.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_chat_message_stream_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_curl_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/sections/scrappable_test_response_section.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/discard_changes_button.dart';
import 'package:zenscrap_flutter/src/ui/scrap_session/widgets/zen_chat_textfield.dart';

class ScrappableEditSessionView extends ConsumerWidget {
  final Scrappable scrappable;
  final DateTime testExpirationDate;
  final List<String>? llmThinkingStream;
  const ScrappableEditSessionView({
    super.key,
    required this.scrappable,
    required this.testExpirationDate,
    required this.llmThinkingStream,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Track edit session view
    final analytics = ref.read(analyticsServiceProvider);
    final isAuthenticated = ref.read(clientProvider).auth.isAuthenticated;

    analytics.trackScrappableEditSessionView(
      scrappableId: scrappable.id ?? 0,
      targetUrl: scrappable.targetRequest?.url ?? '',
      isAuthenticated: isAuthenticated,
    );

    final ScrappableRequest? request = scrappable.targetRequest;
    final ScrappingBeeExtractLogic? extractLogic =
        scrappable.scrappingBeeExtractRules;
    final ReferenceTestData? testData = scrappable.referenceTestData;
    if (request == null) return SizedBox.fromSize();

    return ResponsiveBuilder(
      compact: (context, constraints) => _CompactLayout(
        scrappable: scrappable,
        testExpirationDate: testExpirationDate,
        llmThinkingStream: llmThinkingStream,
        request: request,
        extractLogic: extractLogic,
        testData: testData,
      ),
      expanded: (context, constraints) => _ExpandedLayout(
        scrappable: scrappable,
        testExpirationDate: testExpirationDate,
        llmThinkingStream: llmThinkingStream,
        request: request,
        extractLogic: extractLogic,
        testData: testData,
      ),
    );
  }
}

/// Compact layout for mobile - stacked vertical layout with tabs
class _CompactLayout extends StatelessWidget {
  final Scrappable scrappable;
  final DateTime testExpirationDate;
  final List<String>? llmThinkingStream;
  final ScrappableRequest request;
  final ScrappingBeeExtractLogic? extractLogic;
  final ReferenceTestData? testData;

  const _CompactLayout({
    required this.scrappable,
    required this.testExpirationDate,
    required this.llmThinkingStream,
    required this.request,
    required this.extractLogic,
    required this.testData,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: context.responsiveValue(
                compact: 16.0,
                medium: 18.0,
                expanded: 20.0,
              ),
              left: context.responsiveValue(
                compact: 16.0,
                medium: 18.0,
                expanded: 20.0,
              ),
              right: context.responsiveValue(
                compact: 16.0,
                medium: 18.0,
                expanded: 20.0,
              ),
            ),
            child: Column(
              children: [
                if (extractLogic == null) ...[
                  const _SetupIncompleteBanner(),
                  const SizedBox(height: 12),
                ],
                // Chat section takes more space on mobile
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      if (extractLogic == null) ...[
                        const _SetupIncompleteBanner(),
                        const SizedBox(height: 12),
                      ],
                      Expanded(
                        child: ScrappableChatMessageStreamSection(
                          llmThinkingStream: llmThinkingStream,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ZenChatTextfield(targetTime: testExpirationDate),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // CURL and test response section
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ScrappableCurlSection(
                        targetTime: testExpirationDate,
                        scrappableId: scrappable.id!,
                        testData: testData,
                        scrappingBeeExtractLogic: extractLogic,
                        scrappableRequest: request,
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ScrappableTestResponseSection(
                          scrappable: scrappable,
                          testData: testData,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const DiscardChangesButton(),
      ],
    );
  }
}

class _SetupIncompleteBanner extends ConsumerWidget {
  const _SetupIncompleteBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isLoading = ref.watch(isChatLoadingProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const IncompleteScrappableWarningCard(),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: isLoading
                  ? null
                  : () => ref
                        .read(scrapChatProvider.notifier)
                        .retryIncompleteSetup(),
              icon: const Icon(Icons.refresh),
              label: Text(l10n.api_analytics_retry),
            ),
          ),
        ],
      ),
    );
  }
}

/// Expanded layout for desktop - side-by-side layout
class _ExpandedLayout extends StatelessWidget {
  final Scrappable scrappable;
  final DateTime testExpirationDate;
  final List<String>? llmThinkingStream;
  final ScrappableRequest request;
  final ScrappingBeeExtractLogic? extractLogic;
  final ReferenceTestData? testData;

  const _ExpandedLayout({
    required this.scrappable,
    required this.testExpirationDate,
    required this.llmThinkingStream,
    required this.request,
    required this.extractLogic,
    required this.testData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              SizedBox.expand(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: context.responsiveValue(
                      compact: 16.0,
                      medium: 18.0,
                      expanded: 20.0,
                    ),
                    left: context.responsiveValue(
                      compact: 16.0,
                      medium: 18.0,
                      expanded: 20.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ScrappableChatMessageStreamSection(
                          llmThinkingStream: llmThinkingStream,
                        ),
                      ),
                      ZenChatTextfield(targetTime: testExpirationDate),
                    ],
                  ),
                ),
              ),
              const DiscardChangesButton(),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: context.responsiveValue(
                compact: 16.0,
                medium: 18.0,
                expanded: 20.0,
              ),
              right: context.responsiveValue(
                compact: 16.0,
                medium: 18.0,
                expanded: 20.0,
              ),
              top: context.responsiveValue(
                compact: 16.0,
                medium: 18.0,
                expanded: 20.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScrappableCurlSection(
                  targetTime: testExpirationDate,
                  scrappableId: scrappable.id!,
                  testData: testData,
                  scrappingBeeExtractLogic: extractLogic,
                  scrappableRequest: request,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ScrappableTestResponseSection(
                    scrappable: scrappable,
                    testData: testData,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
