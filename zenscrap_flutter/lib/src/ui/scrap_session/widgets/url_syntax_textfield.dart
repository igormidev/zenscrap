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
      style: context.t.bodyMedium?.copyWith(
        fontFamily: 'monospace',
      ),
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                  ) ??
              const TextStyle(fontFamily: 'monospace'),
          cursorColor: Theme.of(context).colorScheme.primary,
          backgroundCursorColor: Colors.grey,
          maxLines: 3,
          minLines: 1,
        );
}

/// Alternative approach using TextFormField with custom buildCounter
class UrlHighlightedTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const UrlHighlightedTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
  });

  @override
  State<UrlHighlightedTextFormField> createState() =>
      _UrlHighlightedTextFormFieldState();
}

class _UrlHighlightedTextFormFieldState
    extends State<UrlHighlightedTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the URL with syntax highlighting using BabelText
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: context.c.outline),
            borderRadius: BorderRadius.circular(4),
            color: context.c.surfaceContainerHighest.withAlpha(51),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildHighlightedText(context),
          ),
        ),
        const SizedBox(height: 8),
        // Actual editable TextField
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText:
                widget.hintText ?? 'Enter URL with {pathParam} placeholders',
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            helperText: 'Use {paramName} for path parameters',
            helperMaxLines: 2,
          ),
          style: context.t.bodyMedium?.copyWith(
            fontFamily: 'monospace',
          ),
          maxLines: 3,
          minLines: 1,
          onChanged: (value) {
            setState(() {}); // Rebuild to update highlighted text
            widget.onChanged?.call(value);
          },
        ),
      ],
    );
  }

  Widget _buildHighlightedText(BuildContext context) {
    final text = widget.controller.text;
    if (text.isEmpty) {
      return Text(
        'URL preview will appear here',
        style: context.t.bodyMedium?.copyWith(
          color: context.c.onSurfaceVariant.withAlpha(128),
          fontFamily: 'monospace',
        ),
      );
    }

    // Parse the URL and highlight path parameters
    final regex = RegExp(r'\{[^}]+\}');
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      // No path parameters, just show plain text
      return Text(
        text,
        style: context.t.bodyMedium?.copyWith(
          fontFamily: 'monospace',
        ),
      );
    }

    // Build rich text with highlighted parameters
    final List<InlineSpan> spans = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Add text before the match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: context.t.bodyMedium?.copyWith(
            fontFamily: 'monospace',
          ),
        ));
      }

      // Add highlighted parameter
      final paramText = text.substring(match.start, match.end);
      spans.add(
        TextSpan(
          text: paramText,
          style: context.t.bodyMedium?.copyWith(
            color: context.c.primary,
            fontWeight: FontWeight.bold,
            backgroundColor: context.c.primaryContainer.withAlpha(77),
            fontFamily: 'monospace',
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Add remaining text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: context.t.bodyMedium?.copyWith(
          fontFamily: 'monospace',
        ),
      ));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: context.t.bodyMedium?.copyWith(
          fontFamily: 'monospace',
        ),
      ),
    );
  }
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
      backgroundColor:
          Theme.of(context).colorScheme.primaryContainer.withAlpha(77),
    );
    final pattern = r'\{' + _pathParameters.map((e) => e).join('|') + r'\}';
    final RegExp regex = RegExp(pattern);

    final List<TextSpan> spans = [];

    text.splitMapJoin(
      regex,
      onMatch: (Match match) {
        spans.add(TextSpan(
          text: match.group(0),
          style: emphasisStyle,
        ));
        return '';
      },
      onNonMatch: (String nonMatch) {
        spans.add(TextSpan(
          text: nonMatch,
          style: style,
        ));
        return '';
      },
    );

    return TextSpan(children: spans);
  }
}
