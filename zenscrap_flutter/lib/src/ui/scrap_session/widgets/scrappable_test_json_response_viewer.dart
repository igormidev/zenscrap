import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class ScrappableTestJsonResponseViewer extends StatelessWidget {
  final Map<String, dynamic>? testResponse;
  const ScrappableTestJsonResponseViewer({
    super.key,
    required this.testResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surfaceContainerLowest,
        border: Border.all(color: context.c.outline.withAlpha(80), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Builder(
        builder: (context) {
          if (testResponse == null || testResponse!.isEmpty) {
            return Center(
              child: Text(
                'No JSON response available',
                textAlign: TextAlign.center,
              ),
            );
          }
          return JsonView.map(testResponse!);
        },
      ),
    );
  }
}
