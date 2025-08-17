import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:lottie/lottie.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/ui/auth/views/auth_view.dart';

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: LottieBuilder.network(
                      'https://lottie.host/3c4defca-fca7-4045-a13e-2a92f5f397fe/5G9WkNELtD.lottie',
                      decoder: customDecoder,
                      height: 260,
                      width: 260,
                      fit: BoxFit.contain,
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                  Text(
                    'No JSON response available',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                ],
              ),
            );
          }
          return JsonView.map(testResponse!);
        },
      ),
    );
  }
}
