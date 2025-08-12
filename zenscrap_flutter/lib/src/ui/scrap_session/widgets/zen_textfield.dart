import 'package:flutter/material.dart';

class ZenTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final int? minLines;
  final int? maxLines;
  const ZenTextfield({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.minLines,
    this.maxLines,
  });

  @override
  State<ZenTextfield> createState() => _ZenTextfieldState();
}

class _ZenTextfieldState extends State<ZenTextfield> {
  final ValueNotifier<bool> _isOnTop = ValueNotifier(false);
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_setIsOnTop);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set initial state based on focus and text
      _setIsOnTop();
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_setIsOnTop);
    super.dispose();
  }

  void _setIsOnTop() {
    _isOnTop.value = _focusNode.hasFocus || widget.controller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(30),
      shadowColor: Theme.of(context).colorScheme.shadow.withAlpha(100),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 16, top: 16, bottom: 16),
          label: ValueListenableBuilder(
            valueListenable: _isOnTop,
            builder: (context, isOnTop, child) {
              return Transform.translate(
                offset: Offset(0, isOnTop ? -18 : 0), // negative = move up
                child: child,
              );
            },
            child: Text(widget.labelText),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.outline,
          ),
          hoverColor: Colors.transparent,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
          filled: true,
        ),
      ),
    );
  }
}
