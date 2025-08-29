import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zenscrap_flutter/src/design_system/extensions/color_extensions.dart';
import 'package:zenscrap_flutter/src/design_system/snackbar_message.dart';

class CodeBlock extends StatelessWidget {
  final String code;
  final String? copyCode;
  final double? fontSize;
  final List<Widget>? leadingWidgets;
  final List<Widget>? trailingWidgets;
  const CodeBlock({
    super.key,
    required this.code,
    this.copyCode,
    this.fontSize,
    this.leadingWidgets,
    this.trailingWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final IconButton copyButton = IconButton(
      icon: const Icon(Icons.copy),
      onPressed: () async {
        await Clipboard.setData(
          ClipboardData(text: copyCode ?? code),
        );
        if (context.mounted) {
          showSnackbar(context, 'Code copied to clipboard');
        }
      },
    );
    final bool hasLeading = leadingWidgets?.isNotEmpty ?? true;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.c.onPrimary,
        boxShadow: defaultShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 5),
            child: Row(
              children: [
                if (hasLeading) ...[
                  Expanded(
                      child: Row(
                    spacing: 8,
                    children: [
                      copyButton,
                      ...?leadingWidgets,
                    ],
                  )),
                ] else
                  Expanded(
                    child: Row(
                      spacing: 8,
                      children: List.generate(
                        3,
                        (index) => CircleAvatar(
                          radius: 10,
                          backgroundColor: switch (index) {
                            0 => const Color(0xFFFF605C),
                            1 => const Color(0xFFFFBD44),
                            2 => const Color(0xFF00CA4E),
                            int() => Colors.transparent,
                          },
                        ),
                      ),
                    ),
                  ),
                if (!hasLeading) copyButton,
                ...?trailingWidgets,
                const SizedBox(width: 8),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SelectableText(
              code,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: fontSize),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

final defaultShadow = [
  BoxShadow(
    color: Colors.grey.withAlpha(128),
    blurRadius: 20.0, // soften the shadow
    spreadRadius: 0.0, //extend the shadow
    offset: const Offset(
      5.0, // Move to right 10  horizontally
      5.0, // Move to bottom 10 Vertically
    ),
  ),
];
