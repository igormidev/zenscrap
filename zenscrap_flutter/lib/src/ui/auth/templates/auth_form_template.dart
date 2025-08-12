import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:synchronized/synchronized.dart';
import 'package:zenscrap_flutter/src/design_system/components/adaptive_progress_indicator.dart';
import 'package:zenscrap_flutter/src/design_system/global_loading_builder.dart';
import 'package:zenscrap_flutter/src/design_system/value_notifier_builder.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';

final Lock _authLock = Lock();

class AuthFormTemplate<T> extends ConsumerStatefulWidget {
  final List<AuthFormItem> items;
  final String submitText;
  final Future<T?> Function(List<String> items) onSubmit;
  final FutureOr<void> Function(T data) onSubmitSuccess;
  final List<Widget> children;
  const AuthFormTemplate({
    super.key,
    required this.items,
    this.children = const [],
    required this.submitText,
    required this.onSubmit,
    required this.onSubmitSuccess,
  });

  @override
  ConsumerState<AuthFormTemplate<T>> createState() =>
      _AuthFormTemplateState<T>();
}

class _AuthFormTemplateState<T> extends ConsumerState<AuthFormTemplate<T>> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];
  final List<ValueNotifier<bool?>?> _isObscureText = [];

  @override
  void initState() {
    for (final item in widget.items) {
      _controllers.add(TextEditingController());
      if (item.obscureText) {
        _isObscureText.add(ValueNotifier(false));
      } else {
        _isObscureText.add(null);
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final isObscureText in _isObscureText) {
      isObscureText?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 16),
            for (var i = 0; i < widget.items.length; i++) ...[
              ValueNotifierBuilder<bool?>(
                initialValue: widget.items[i].obscureText
                    ? false
                    : _isObscureText[i]?.value,
                builder: (context, isDisplaying, _, setter) {
                  final hintText = widget.items[i].autofillHints;
                  return TextFormField(
                    controller: _controllers[i],
                    obscureText: isDisplaying == null ? false : !isDisplaying,
                    textInputAction: i == widget.items.length - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                    autofillHints: hintText != null ? [hintText] : null,
                    keyboardType: widget.items[i].keyboardType,
                    onEditingComplete: () {
                      final isLast = i == widget.items.length - 1;
                      if (isLast) {
                        _validateForms();
                      } else {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      hintText: widget.items[i].hintText,
                      labelText: widget.items[i].labelText,
                      suffixIcon: isDisplaying == null
                          ? null
                          : Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: IconButton(
                                onPressed: () {
                                  setter(!isDisplaying);
                                },
                                icon: Icon(
                                  isDisplaying
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                    ),
                    validator: widget.items[i].validator ??
                        (text) {
                          return widget.items[i].validatorWithItems?.call(
                            text,
                            _controllers.map((e) => e.text).toList(),
                          );
                        },
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
            ...widget.children,
            Consumer(
              builder: (context, ref, child) {
                return GlobalLoadingBuilder(
                  builder: (context, isGlobalLoadingActive) {
                    return FilledButton(
                      onPressed: isGlobalLoadingActive ? null : _validateForms,
                      child: isGlobalLoadingActive
                          ? const AdaptiveProgressIndicator()
                          : Text(widget.submitText),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _validateForms() async {
    if (_formKey.currentState!.validate()) {
      await _authLock.synchronized(() async {
        final T? resp = await ref.globalLoadingSetter<T?>(() async {
          await Future.delayed(const Duration(milliseconds: 800));
          return await widget.onSubmit(
            _controllers.map((e) => e.text).toList(),
          );
        });
        if (resp == null) {
          return;
        }
        await widget.onSubmitSuccess(resp);
      });
    }
  }
}

class AuthFormItem {
  final String hintText;
  final String labelText;
  final String? autofillHints;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? Function(String? value, List<String> items)? validatorWithItems;
  const AuthFormItem({
    required this.hintText,
    this.obscureText = false,
    this.autofillHints,
    required this.labelText,
    this.validator,
    this.keyboardType,
    this.validatorWithItems,
  });
}
