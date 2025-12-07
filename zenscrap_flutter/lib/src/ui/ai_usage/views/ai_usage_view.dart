import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class AiUsageView extends StatelessWidget {
  const AiUsageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.c.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.c.outline.withAlpha(50)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Credit History',
                style: context.t.titleLarge,
              ),
              const SizedBox(height: 16),
              Expanded(
                // Implement a listage of the AICreditHistoryItem
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
