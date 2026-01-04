import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/dialogs/example_response_dialog.dart';
import 'package:zenscrap_flutter/src/ui/marketplace/dialogs/scrappable_info_dialog.dart';

class ScrappableDetailsDialog extends ConsumerWidget {
  final Scrappable scrappable;

  const ScrappableDetailsDialog({
    super.key,
    required this.scrappable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveBuilder(
      compact: (context, constraints) => SingleChildScrollView(
        padding: EdgeInsets.all(
          context.responsiveValue(
            compact: 16.0,
            medium: 24.0,
            expanded: 32.0,
          ),
        ),
        child: Column(
          children: [
            ExampleResponseDialog(scrappable: scrappable),
            const SizedBox(height: 16),
            ScrappableInfoDialog(scrappable: scrappable),
          ],
        ),
      ),
      medium: (context, constraints) => Row(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: ExampleResponseDialog(scrappable: scrappable)),
          Expanded(child: ScrappableInfoDialog(scrappable: scrappable)),
        ],
      ),
      expanded: (context, constraints) => Row(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: ExampleResponseDialog(scrappable: scrappable)),
          Expanded(child: ScrappableInfoDialog(scrappable: scrappable)),
        ],
      ),
    );
  }
}
