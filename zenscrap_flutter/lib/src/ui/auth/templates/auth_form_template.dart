import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:synchronized/synchronized.dart';
import 'package:zenscrap_flutter/src/design_system/components/adaptive_progress_indicator.dart';
import 'package:zenscrap_flutter/src/design_system/global_loading_builder.dart';
import 'package:zenscrap_flutter/src/design_system/responsive/responsive.dart';
import 'package:zenscrap_flutter/src/design_system/value_notifier_builder.dart';
import 'package:zenscrap_flutter/src/providers/global_loading_provider.dart';

final Lock _authLock = Lock();

class AuthFormTemplate<T> extends ConsumerStatefulWidget {
  final List<AuthFormItem> items;
  final String submitText;
  final Future<T?> Function(List<String> items) onSubmit;
  final FutureOr<void> Function(T data) onSubmitSuccess;
  /// Widgets displayed above the submit button (e.g., informational text)
  final List<Widget> aboveChildren;
  /// Widgets displayed below the submit button (e.g., alternative auth options like Google)
  final List<Widget> belowChildren;
  const AuthFormTemplate({
    super.key,
    required this.items,
    this.aboveChildren = const [],
    this.belowChildren = const [],
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
    // Responsive padding values
    final horizontalPadding = context.responsiveValue(
      compact: 16.0,
      medium: 20.0,
      expanded: 24.0,
    );
    final itemSpacing = context.responsiveValue(compact: 12.0, expanded: 16.0);

    return Form(
      key: _formKey,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          children: [
            SizedBox(height: itemSpacing),
            for (var i = 0; i < widget.items.length; i++) ...[
              _AuthFormField(
                item: widget.items[i],
                controller: _controllers[i],
                isObscureText: _isObscureText[i],
                isLast: i == widget.items.length - 1,
                allControllers: _controllers,
                onEditingComplete: () {
                  final isLast = i == widget.items.length - 1;
                  if (isLast) {
                    _validateForms();
                  } else {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
              SizedBox(height: itemSpacing),
            ],
            ...widget.aboveChildren,
            _SubmitButton(
              submitText: widget.submitText,
              onPressed: _validateForms,
            ),
            ...widget.belowChildren,
            SizedBox(height: itemSpacing),
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

/// Individual form field widget with proper touch target sizing
class _AuthFormField extends StatelessWidget {
  final AuthFormItem item;
  final TextEditingController controller;
  final ValueNotifier<bool?>? isObscureText;
  final bool isLast;
  final List<TextEditingController> allControllers;
  final VoidCallback onEditingComplete;

  const _AuthFormField({
    required this.item,
    required this.controller,
    required this.isObscureText,
    required this.isLast,
    required this.allControllers,
    required this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return ValueNotifierBuilder<bool?>(
      initialValue: item.obscureText ? false : isObscureText?.value,
      builder: (context, isDisplaying, _, setter) {
        final hintText = item.autofillHints;
        return TextFormField(
          controller: controller,
          obscureText: isDisplaying == null ? false : !isDisplaying,
          textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
          autofillHints: hintText != null ? [hintText] : null,
          keyboardType: item.keyboardType,
          onEditingComplete: onEditingComplete,
          // Ensure minimum touch target height for mobile (48px minimum)
          style: context.responsiveValue(
            compact: Theme.of(context).textTheme.bodyLarge,
            expanded: Theme.of(context).textTheme.bodyMedium,
          ),
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            // Responsive content padding for proper touch target on mobile
            contentPadding: context.responsiveValue(
              compact: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              expanded: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            hintText: item.hintText,
            labelText: item.labelText,
            suffixIcon: isDisplaying == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: () {
                        setter(!isDisplaying);
                      },
                      icon: Icon(
                        isDisplaying ? Icons.visibility : Icons.visibility_off,
                      ),
                      // Ensure icon button has minimum 48x48 touch target
                      iconSize: 24,
                    ),
                  ),
          ),
          validator:
              item.validator ??
              (text) {
                return item.validatorWithItems?.call(
                  text,
                  allControllers.map((e) => e.text).toList(),
                );
              },
        );
      },
    );
  }
}

/// Submit button with responsive sizing for proper mobile touch targets
class _SubmitButton extends ConsumerWidget {
  final String submitText;
  final VoidCallback onPressed;

  const _SubmitButton({required this.submitText, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlobalLoadingBuilder(
      builder: (context, isGlobalLoadingActive) {
        return SizedBox(
          width: double.infinity,
          // Minimum 48px height for mobile touch target, larger on desktop
          height: context.responsiveValue(compact: 52.0, expanded: 48.0),
          child: FilledButton(
            onPressed: isGlobalLoadingActive ? null : onPressed,
            style: FilledButton.styleFrom(
              // Ensure proper padding for touch target
              padding: context.responsiveValue(
                compact: const EdgeInsets.symmetric(vertical: 14),
                expanded: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            child: isGlobalLoadingActive
                ? const AdaptiveProgressIndicator()
                : Text(
                    submitText,
                    style: context.responsiveValue(
                      compact: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                      expanded: null, // Use default button text style
                    ),
                  ),
          ),
        );
      },
    );
  }
}
