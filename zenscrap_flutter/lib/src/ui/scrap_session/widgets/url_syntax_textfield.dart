import 'package:flutter/material.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';

class UrlSyntaxTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const UrlSyntaxTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
  });

  @override
  State<UrlSyntaxTextField> createState() => _UrlSyntaxTextFieldState();
}

class _UrlSyntaxTextFieldState extends State<UrlSyntaxTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Enter URL with {pathParam} placeholders',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: context.t.bodyMedium?.copyWith(fontFamily: 'monospace'),
      maxLines: 3,
      minLines: 1,
      onChanged: widget.onChanged,
    );
  }
}

/// Custom TextField that extends EditableText to provide syntax highlighting
class UrlSyntaxHighlightTextField extends EditableText {
  UrlSyntaxHighlightTextField({
    super.key,
    required super.controller,
    required BuildContext context,
    String? hintText,
    super.onChanged,
  }) : super(
         focusNode: FocusNode(),
         style:
             Theme.of(
               context,
             ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace') ??
             const TextStyle(fontFamily: 'monospace'),
         cursorColor: Theme.of(context).colorScheme.primary,
         backgroundCursorColor: Colors.grey,
         maxLines: 3,
         minLines: 1,
       );
}

class HighlightTextEditingController extends TextEditingController {
  void updatePathParameters(List<String> parameters) {
    _pathParameters
      ..clear()
      ..addAll(parameters);
    notifyListeners();
  }

  final List<String> _pathParameters = [];

  HighlightTextEditingController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    bool withComposing = false,
  }) {
    final emphasisStyle = style?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
      backgroundColor: Theme.of(
        context,
      ).colorScheme.primaryContainer.withAlpha(77),
    );
    final pattern = r'\{' + _pathParameters.map((e) => e).join('|') + r'\}';
    final RegExp regex = RegExp(pattern);

    final List<TextSpan> spans = [];

    text.splitMapJoin(
      regex,
      onMatch: (Match match) {
        spans.add(TextSpan(text: match.group(0), style: emphasisStyle));
        return '';
      },
      onNonMatch: (String nonMatch) {
        spans.add(TextSpan(text: nonMatch, style: style));
        return '';
      },
    );

    return TextSpan(children: spans);
  }
}
