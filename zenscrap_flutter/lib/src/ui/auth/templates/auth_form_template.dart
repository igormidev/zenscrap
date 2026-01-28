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
  /// Form elements - can be single [AuthFormItem] or [AuthFormRow] for side-by-side fields
  final List<AuthFormElement> items;
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
  final ValueNotifier<bool> _isFormFilled = ValueNotifier(false);

  /// Flattens [AuthFormElement] list to get all individual [AuthFormItem]s
  /// Maintains order for correct controller indexing (important for cross-field validation)
  List<AuthFormItem> get _flatItems => widget.items.expand((element) {
        return switch (element) {
          AuthFormItem item => [item],
          AuthFormRow row => row.items,
        };
      }).toList();

  @override
  void initState() {
    for (final item in _flatItems) {
      final controller = TextEditingController();
      controller.addListener(_updateFormFilled);
      _controllers.add(controller);
      if (item.obscureText) {
        _isObscureText.add(ValueNotifier(false));
      } else {
        _isObscureText.add(null);
      }
    }
    super.initState();
  }

  void _updateFormFilled() {
    final allFilled = _controllers.every((c) => c.text.isNotEmpty);
    _isFormFilled.value = allFilled;
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.removeListener(_updateFormFilled);
      controller.dispose();
    }
    for (final isObscureText in _isObscureText) {
      isObscureText?.dispose();
    }
    _isFormFilled.dispose();
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
    final flatItems = _flatItems;
    final totalFlatItems = flatItems.length;

    return Form(
      key: _formKey,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          children: [
            SizedBox(height: itemSpacing),
            ..._buildFormElements(
              context: context,
              flatItems: flatItems,
              totalFlatItems: totalFlatItems,
              itemSpacing: itemSpacing,
            ),
            ...widget.aboveChildren,
            _SubmitButton(
              submitText: widget.submitText,
              onPressed: _validateForms,
              isFormFilled: _isFormFilled,
            ),
            ...widget.belowChildren,
            SizedBox(height: itemSpacing),
          ],
        ),
      ),
    );
  }

  /// Builds form elements handling both single items and rows
  List<Widget> _buildFormElements({
    required BuildContext context,
    required List<AuthFormItem> flatItems,
    required int totalFlatItems,
    required double itemSpacing,
  }) {
    final widgets = <Widget>[];
    var flatIndex = 0;

    for (final element in widget.items) {
      switch (element) {
        case AuthFormItem():
          widgets.add(
            _createSingleField(
              flatIndex: flatIndex,
              totalFlatItems: totalFlatItems,
            ),
          );
          widgets.add(SizedBox(height: itemSpacing));
          flatIndex++;

        case AuthFormRow():
          widgets.add(
            _createRowFields(
              row: element,
              startFlatIndex: flatIndex,
              totalFlatItems: totalFlatItems,
              itemSpacing: itemSpacing,
            ),
          );
          widgets.add(SizedBox(height: itemSpacing));
          flatIndex += element.items.length;
      }
    }

    return widgets;
  }

  /// Creates a single form field widget
  _SingleFormField _createSingleField({
    required int flatIndex,
    required int totalFlatItems,
  }) {
    final item = _flatItems[flatIndex];
    final isLast = flatIndex == totalFlatItems - 1;

    return _SingleFormField(
      item: item,
      controller: _controllers[flatIndex],
      isObscureText: _isObscureText[flatIndex],
      isLast: isLast,
      allControllers: _controllers,
      onValidateForms: _validateForms,
    );
  }

  /// Creates a row of fields widget - side-by-side on expanded, stacked on compact
  _RowFormFields _createRowFields({
    required AuthFormRow row,
    required int startFlatIndex,
    required int totalFlatItems,
    required double itemSpacing,
  }) {
    final fieldConfigs = <_SingleFormField>[];
    for (var i = 0; i < row.items.length; i++) {
      fieldConfigs.add(
        _createSingleField(
          flatIndex: startFlatIndex + i,
          totalFlatItems: totalFlatItems,
        ),
      );
    }

    return _RowFormFields(
      fields: fieldConfigs,
      itemSpacing: itemSpacing,
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

/// Base class for form elements - can be a single item or a row of items
sealed class AuthFormElement {
  const AuthFormElement();
}

/// Single form field configuration
class AuthFormItem extends AuthFormElement {
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

/// A row of form items displayed side-by-side on expanded screens
/// On compact screens, items stack vertically for better usability
class AuthFormRow extends AuthFormElement {
  final List<AuthFormItem> items;
  const AuthFormRow({required this.items});
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
  final ValueNotifier<bool> isFormFilled;

  const _SubmitButton({
    required this.submitText,
    required this.onPressed,
    required this.isFormFilled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlobalLoadingBuilder(
      builder: (context, isGlobalLoadingActive) {
        return ValueListenableBuilder<bool>(
          valueListenable: isFormFilled,
          builder: (context, formFilled, child) {
            final isEnabled = formFilled && !isGlobalLoadingActive;
            return SizedBox(
              width: double.infinity,
              // Minimum 48px height for mobile touch target, larger on desktop
              height: context.responsiveValue(compact: 52.0, expanded: 48.0),
              child: FilledButton(
                onPressed: isEnabled ? onPressed : null,
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
      },
    );
  }
}

/// Single form field widget that wraps _AuthFormField with proper callbacks
class _SingleFormField extends StatelessWidget {
  final AuthFormItem item;
  final TextEditingController controller;
  final ValueNotifier<bool?>? isObscureText;
  final bool isLast;
  final List<TextEditingController> allControllers;
  final VoidCallback onValidateForms;

  const _SingleFormField({
    required this.item,
    required this.controller,
    required this.isObscureText,
    required this.isLast,
    required this.allControllers,
    required this.onValidateForms,
  });

  @override
  Widget build(BuildContext context) {
    return _AuthFormField(
      item: item,
      controller: controller,
      isObscureText: isObscureText,
      isLast: isLast,
      allControllers: allControllers,
      onEditingComplete: () {
        if (isLast) {
          onValidateForms();
        } else {
          FocusScope.of(context).nextFocus();
        }
      },
    );
  }
}

/// Row of form fields - side-by-side on expanded, stacked on compact
class _RowFormFields extends StatelessWidget {
  final List<_SingleFormField> fields;
  final double itemSpacing;

  const _RowFormFields({
    required this.fields,
    required this.itemSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return context.responsiveValue(
      // Compact: Stack vertically with spacing
      compact: Column(
        children: [
          for (var i = 0; i < fields.length; i++) ...[
            fields[i],
            if (i < fields.length - 1) SizedBox(height: itemSpacing),
          ],
        ],
      ),
      // Expanded: Side-by-side in a row
      expanded: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < fields.length; i++) ...[
            if (i > 0) SizedBox(width: itemSpacing),
            Expanded(child: fields[i]),
          ],
        ],
      ),
    );
  }
}
