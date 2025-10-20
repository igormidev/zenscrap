import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
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
    return Row(
      spacing: 32,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ExampleResponseDialog(scrappable: scrappable),
        ScrappableInfoDialog(scrappable: scrappable),
      ],
    );
  }
}
