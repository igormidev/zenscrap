import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zenscrap_client/zenscrap_client.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class CTAContinueFlow extends ConsumerStatefulWidget {
  final Scrappable scrappable;
  const CTAContinueFlow({
    super.key,
    required this.scrappable,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CTAContinueFlowState();
}

class _CTAContinueFlowState extends ConsumerState<CTAContinueFlow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Deploy to use at scale', style: context.t.titleLarge),
        Spacer(),
        Tooltip(
          message:
              'Continue to edit/use this scrappable endpoint by deploying it!',
          child: FilledButton.icon(
            onPressed: () async {
              await context.push('/auth');
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
