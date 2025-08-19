import 'package:flutter/material.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class InitialScrappableCardIndicator extends StatelessWidget {
  final Scrappable scrappable;
  const InitialScrappableCardIndicator({super.key, required this.scrappable});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          scrappable.name,
          style: context.t.titleLarge,
        ),
      ),
    );
  }
}
