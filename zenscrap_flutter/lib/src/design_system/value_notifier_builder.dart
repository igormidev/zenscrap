import 'package:flutter/material.dart';

class ValueNotifierBuilder<T> extends StatefulWidget {
  final T initialValue;
  final Widget? child;
  final void Function()? listener;
  final Widget Function(
    BuildContext context,
    T value,
    Widget? child,
    void Function(T newValue) notifierSetter,
  ) builder;
  const ValueNotifierBuilder({
    super.key,
    this.child,
    this.listener,
    required this.initialValue,
    required this.builder,
  });

  @override
  State<ValueNotifierBuilder<T>> createState() =>
      _ValueNotifierBuilderState<T>();
}

class _ValueNotifierBuilderState<T> extends State<ValueNotifierBuilder<T>> {
  late final ValueNotifier<T> valueListenable;

  @override
  void initState() {
    super.initState();
    valueListenable = ValueNotifier(widget.initialValue);
    if (widget.listener != null) {
      valueListenable.addListener(widget.listener!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.listener != null) {
      valueListenable.removeListener(widget.listener!);
    }
    valueListenable.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: valueListenable,
      child: widget.child,
      builder: (context, value, child) {
        return widget.builder(context, value, child, (newValue) {
          valueListenable.value = newValue;
        });
      },
    );
  }
}
