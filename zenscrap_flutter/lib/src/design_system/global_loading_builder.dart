import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';

class GlobalLoadingBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isGlobalLoadingActive)
      builder;
  const GlobalLoadingBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (
        BuildContext context,
        WidgetRef ref,
        Widget? _,
      ) {
        final isGlobalLoading = ref.watch(isGlobalLoadingProvider);
        return builder.call(context, isGlobalLoading);
      },
    );
  }
}

class GlobalLoadingWrapper extends StatelessWidget {
  final Widget child;
  final Widget loadingWidget;

  const GlobalLoadingWrapper({
    super.key,
    required this.child,
    required this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      child: child,
      builder: (
        BuildContext context,
        WidgetRef ref,
        Widget? child,
      ) {
        final isGlobalLoading = ref.watch(isGlobalLoadingProvider);
        return isGlobalLoading ? loadingWidget : child!;
      },
    );
  }
}
