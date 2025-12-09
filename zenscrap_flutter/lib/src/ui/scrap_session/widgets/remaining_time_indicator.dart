import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class RemainingTimeIndicator extends StatefulWidget {
  final DateTime targetTime;
  const RemainingTimeIndicator(this.targetTime, {super.key});

  @override
  State<RemainingTimeIndicator> createState() => _RemainingTimeIndicatorState();
}

class _RemainingTimeIndicatorState extends State<RemainingTimeIndicator> {
  late ValueNotifier<Duration?> remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remaining = ValueNotifier(widget.targetTime.difference(DateTime.now()));

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final diff = widget.targetTime.difference(DateTime.now());
      if (diff.isNegative) {
        remaining.value = null; // null means expired
        _timer?.cancel();
      } else {
        remaining.value = diff;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    remaining.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.c;
    return ValueListenableBuilder<Duration?>(
      valueListenable: remaining,
      builder: (_, value, _) {
        final Color baseColor;
        final String text;
        if (value == null) {
          text = "Endpoint test time expired";
          baseColor = scheme.error;
        } else {
          final hours = value.inHours.toString().padLeft(2, '0');
          final minutes = (value.inMinutes % 60).toString().padLeft(2, '0');
          final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');

          // Choose color based on remaining time thresholds
          final totalMinutesLeft = value.inMinutes;
          baseColor = totalMinutesLeft < 15
              ? scheme
                    .error // red under 15m
              : (totalMinutesLeft < 35
                    ? Colors
                          .orange // yellow under 35m
                    : scheme.primary); // default

          final containsHour = hours != '00';
          text =
              "Endpoint expires in ${containsHour ? '$hours:' : ''}$minutes:$seconds";
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: baseColor,
              // color: baseColor.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            text,
            style: context.t.titleMedium?.copyWith(color: baseColor),
          ),
        );
      },
    );
  }
}
