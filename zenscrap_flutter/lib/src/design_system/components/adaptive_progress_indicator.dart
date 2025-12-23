import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/core/utils/device_utils.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    if (!DeviceUtils.isApple) {
      return const AspectRatio(
        aspectRatio: 1,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      );
    }

    return const AspectRatio(
      aspectRatio: 1,
      child: CircularProgressIndicator.adaptive(backgroundColor: Colors.black),
    );
  }
}
