import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/core/mixins/edit_scrappable.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/widgets/edit_scrappable_dialog.dart';
import 'package:zenscrap_flutter/src/states/chat_session/scrap_chat_session_provider.dart';

class ScrappableEditVisualization extends ConsumerStatefulWidget {
  const ScrappableEditVisualization({
    super.key,
    required this.scrappable,
  });
  final Scrappable scrappable;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScrappableEditVisualizationState();
}

class _ScrappableEditVisualizationState
    extends ConsumerState<ScrappableEditVisualization> with EditScrappable {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLowest,
        border: Border.all(
          color: context.c.outline.withAlpha(60),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ScrappableEditForm(
        scrappable: widget.scrappable,
        shouldPopOnEnd: false,
        onSave: (
          name,
          description,
          category,
          willHideFromMarketplace, {
          bool? autoFixEnabled,
          int? autoFixThreshold,
          AiModel? autoFixAiModel,
          bool? autoFixUseAutoAiModel,
        }) async {
          return onEditScrappable(
            widget.scrappable,
            name,
            description,
            category,
            willHideFromMarketplace,
            () {
              // Update the scrappable in the state provider
              ref.read(scrapChatProvider.notifier).updateScrappableDetails(
                    name: name,
                    description: description,
                    category: category,
                  );
            },
            autoFixEnabled: autoFixEnabled,
            autoFixConsecutiveErrorThreshold: autoFixThreshold,
            autoFixPreferredAiModel: autoFixAiModel,
            autoFixUseAutoAiModel: autoFixUseAutoAiModel,
          );
        },
      ),
    );
  }
}
