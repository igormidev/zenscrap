import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/states/chat_session/is_chat_loading_provider.dart';

class CTAContinueFlow extends ConsumerStatefulWidget {
  final Scrappable scrappable;
  final DateTime targetTime;
  const CTAContinueFlow({
    super.key,
    required this.scrappable,
    required this.targetTime,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CTAContinueFlowState();
}

class _CTAContinueFlowState extends ConsumerState<CTAContinueFlow> {
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
    final isChatLoading = ref.watch(isChatLoadingProvider);
    return Row(
      children: [
        // Text('Deploy to use at scale', style: context.t.titleLarge),
        ValueListenableBuilder<Duration?>(
          valueListenable: remaining,
          builder: (_, value, __) {
            if (value == null) {
              return Text(
                "Time expired",
                style: context.t.titleLarge,
              );
            }
            final hours = value.inHours.toString().padLeft(2, '0');
            final minutes = (value.inMinutes % 60).toString().padLeft(2, '0');
            final seconds = (value.inSeconds % 60).toString().padLeft(2, '0');

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                "$hours:$minutes:$seconds",
                style: context.t.titleMedium,
              ),
            );
          },
        ),
        Spacer(),
        Tooltip(
          message:
              'Continue to edit/use this scrappable endpoint by deploying it!',
          child: FilledButton.icon(
            onPressed: isChatLoading
                ? null
                : () async {
                    await context.push(
                      '/auth',
                      extra: widget.scrappable,
                    );
                  },
            label: Text('DEPLOY ENDPOINT'),
            iconAlignment: IconAlignment.end,
            icon: Icon(Icons.rocket),
          ),
        ),
      ],
    );
  }
}
